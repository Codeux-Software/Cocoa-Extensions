/* *********************************************************************
*
*            Copyright (c) 2018 Codeux Software, LLC
*     Please see ACKNOWLEDGEMENT for additional information.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
*  * Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
*  * Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
*  * Neither the name of "Codeux Software, LLC", nor the names of its
*    contributors may be used to endorse or promote products derived
*    from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*
*********************************************************************** */

import os.log

///
/// Logging acts as a facility for logging messages, regardless of macOS version.
/// Because it's designed to be backwards compatible, it isn't as technical savvy
/// as something such as os_log which allows much more powerful formatters.
/// At worst, assume NSLog() is used; so design the log message around that.
///
@objc(XRLogging)
public class Logging : NSObject
{
	///
	/// Subsystems are favored in this order:
	///
	/// 1. "subsystem" argument of function
	/// 2. defaultSubsystem value (default = nil)
	/// 3. OSLog.default (on macOS 10.12 and later)
	///
	@objc
	public static var defaultSubsystem: OSLog?

	///
	/// Flag to enable debug log type
	///
	/// macOS 10.12 and later control debug logging
	/// at the system level which negates this flag.
	///
	/// See: os_log_debug_enabled()
	///
	@objc
	public static var debugLogging = false

	@objc
	public enum `Type` : Int
	{
		case `default` = 0

		case debug = 1
		case info = 2
		case error = 3
		case fault = 4

		@available(OSX 10.12, *)
		fileprivate var systemType:OSLogType
		{
			switch self {
				case .debug:
					return OSLogType.debug
				case .info:
					return OSLogType.info
				case .error:
					return OSLogType.error
				case .fault:
					return OSLogType.fault
				default:
					return OSLogType.default
			}
		} // systemType

		public var description: String
		{
			switch self {
				case .debug:
					return "Debug"
				case .info:
					return "Info"
				case .error:
					return "Error"
				case .fault:
					return "Fault"
				default:
					return "Default"
			}
		} // description

		fileprivate var formatterDescription: String?
		{
			/* No need to show description when performing
			 unified logging because system captrues this. */
			if #available(OSX 10.12, *) {
				return nil
			}

			return "[\(description)] "
		} // formatterDescription
	}

	fileprivate struct Context
	{
		var subsystem: OSLog?
		var type: `Type` = .`default`
		var file: String
		var line: Int
		var column: Int
		var function: String
	}

	public static func log(_ message: String, _ arguments: CVarArg..., type: `Type`, subsystem: OSLog?, file: String, line: Int, column: Int, function: String)
	{
		log(message, arguments: getVaList(arguments), type: type, subsystem: subsystem, file: file, line: line, column: column, function: function)
	}

	public static func log(_ message: String, arguments: CVaListPointer, type: `Type`, subsystem: OSLog?, file: String, line: Int, column: Int, function: String)
	{
		let context = Context(subsystem: subsystem, type: type, file: file, line: line, column: column, function: function)

		let formattedMessage = NSString(format: message, arguments: arguments) as String

		log(formattedMessage, in: context)
	}

	@objc(logMessage:asType:inSubsystem:file:line:column:function:)
	public static func log(_ formattedMessage: String, type: `Type`, subsystem: OSLog?, file: String, line: Int, column: Int, function: String)
	{
		let context = Context(subsystem: subsystem, type: type, file: file, line: line, column: column, function: function)

		log(formattedMessage, in: context)
	}

	@objc(logStackTraceSymbols:asType:inSubsystem:)
	public static func logStackTrace(trace: [String], type: `Type`, subsystem: OSLog?)
	{
		/* Details such as file, line, column, and function are useless
		 when logging symbols but so I don't have to spend a day modifying
		 the facility to accept those as optional, just give it defaults. */
		log("Current Stack: %@", trace, type: type, subsystem: subsystem, file: #file, line: #line, column: #column, function: #function)
	}

	fileprivate static func log(_ formattedMessage: String, in context: Context)
	{
		let messageToLog = "\(context.type.formatterDescription ?? "")\(context.function) [\(context.line):\(context.column)]: \(formattedMessage)"

		guard #available(OSX 10.12, *) else {
			if (context.type == .debug) {
				if (debugLogging == false) {
					return
				}
			}

			NSLog(messageToLog)

			return
		}

		let subsystem = (context.subsystem ?? defaultSubsystem ?? OSLog.default)

		/* os_log wants a StaticString (compile-time string) which we cannot offer.
		 We therefore have to use a formatter to format the already formatted string. */
		os_log("%{public}@", dso: #dsohandle, log: subsystem, type: context.type.systemType, messageToLog)
	}

	/* Subsystem used by the Cocoa Extensions framework for logging */
	@objc
	internal var frameworkSubsystem: OSLog? =
	{
		if #available(OSX 10.12, *) {
			return OSLog(subsystem: "com.codeux.frameworks.CocoaExtensions", category: "General")
		}

		return nil
	}()
}

// MARK - Convenience Functions

/// We can't use macros in Swift which is why all the extra arguments exist.
/// Unless there is a very, very, very specific to do so, don't set anything
/// after subsystem as you will just be lying to your own logs.
public func LogToConsole(_ message: String, _ arguments: CVarArg..., type: Logging.`Type` = .`default`, subsystem: OSLog? = nil, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function)
{
	Logging.log(message, arguments: getVaList(arguments), type: type, subsystem: subsystem, file: file, line: line, column: column, function: function)
}

public func LogToConsoleDebug(_ message: String, _ arguments: CVarArg..., subsystem: OSLog? = nil, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function)
{
	Logging.log(message, arguments: getVaList(arguments), type: .debug, subsystem: subsystem, file: file, line: line, column: column, function: function)
}

public func LogToConsoleInfo(_ message: String, _ arguments: CVarArg..., subsystem: OSLog? = nil, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function)
{
	Logging.log(message, arguments: getVaList(arguments), type: .info, subsystem: subsystem, file: file, line: line, column: column, function: function)
}

public func LogToConsoleError(_ message: String, _ arguments: CVarArg..., subsystem: OSLog? = nil, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function)
{
	Logging.log(message, arguments: getVaList(arguments), type: .error, subsystem: subsystem, file: file, line: line, column: column, function: function)
}

public func LogToConsoleFault(_ message: String, _ arguments: CVarArg..., subsystem: OSLog? = nil, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function)
{
	Logging.log(message, arguments: getVaList(arguments), type: .fault, subsystem: subsystem, file: file, line: line, column: column, function: function)
}

public func LogStackTrace(type: Logging.`Type` = .`default`, subsystem: OSLog? = nil, trace: [String] = Thread.callStackSymbols)
{
	Logging.logStackTrace(trace: trace, type: type, subsystem: subsystem)
}
