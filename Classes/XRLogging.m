/* *********************************************************************
 *
 *         Copyright (c) 2016 - 2020 Codeux Software, LLC
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

NS_ASSUME_NONNULL_BEGIN

os_log_t _Nullable _CSFrameworkInternalLogSubsystem(void)
{
	return [XRLogging frameworkSubsystem];
}

os_log_t _Nullable _LogToConsoleDefaultSubsystem(void)
{
	return [XRLogging defaultSubsystem];
}

void _LogToConsoleSetDefaultSubsystem(os_log_t _Nullable subsystem)
{
	[XRLogging setDefaultSubsystem:subsystem];
}

void _LogToConsoleSetDebugLoggingEnabled(BOOL enabled)
{
	COCOA_EXTENSIONS_DEPRECATED_WARNING

	[XRLogging setDebugLogging:enabled];
}

void _LogToConsoleBridged_v1(XRLoggingType type, os_log_t _Nullable subsystem, const char *file, unsigned long line, unsigned long column, const char *function, const char *message, ...)
{
	NSCParameterAssert(file != NULL);
	NSCParameterAssert(function != NULL);
	NSCParameterAssert(message != NULL);

	va_list arguments;
	va_start(arguments, message);

	NSString *formattedMessage = [[NSString alloc] initWithFormat:@(message) arguments:arguments];

	va_end(arguments);

	[XRLogging logMessage:formattedMessage asType:type inSubsystem:subsystem file:@(file) line:line column:column function:@(function)];
}

void _LogStackTraceBridged_v1(XRLoggingType type, os_log_t _Nullable subsystem, NSArray<NSString *> *trace)
{
	NSCParameterAssert(trace != nil);

	[XRLogging logStackTraceSymbols:trace asType:type inSubsystem:subsystem];
}

#pragma mark -
#pragma mark Deprecated

NSString *_LogToConsoleFormatMessage_v2(os_log_t _Nullable subsystem, u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		COCOA_EXTENSIONS_DEPRECATED_WARNING
	});

	va_list arguments;
	va_start(arguments, formatter);

	NSString *formattedString = [[NSString alloc] initWithFormat:@(formatter) arguments:arguments];

	va_end(arguments);

	return formattedString;
}

NSString *_LogToConsoleFormatMessage_v1(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		COCOA_EXTENSIONS_DEPRECATED_WARNING
	});

	va_list arguments;
	va_start(arguments, formatter);

	NSString *formattedString = [[NSString alloc] initWithFormat:@(formatter) arguments:arguments];

	va_end(arguments);

	return formattedString;
}

void _LogToConsoleNSLogShim(const char *formatter, const char *filename, const char *function, unsigned long line, ...)
{
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		COCOA_EXTENSIONS_DEPRECATED_WARNING
	});
}

void _LogToConsoleNSLogShim_v2(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		COCOA_EXTENSIONS_DEPRECATED_WARNING
	});
}

NS_ASSUME_NONNULL_END
