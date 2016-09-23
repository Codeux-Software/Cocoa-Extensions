/* *********************************************************************

        Copyright (c) 2010 - 2016 Codeux Software, LLC
     Please see ACKNOWLEDGEMENT for additional information.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of "Codeux Software, LLC", nor the names of its 
   contributors may be used to endorse or promote products derived 
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

NS_ASSUME_NONNULL_BEGIN

LogToConsoleSubsystemType _CSFrameworkInternalLogSubsystem(void)
{
	static LogToConsoleSubsystemType _subsystem = NULL;

#if _LogToConsoleSupportsUnifiedLogging == 1
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([XRSystemInformation isUsingOSXSierraOrLater] == NO) {
			return;
		}

		_subsystem =
		os_log_create("com.codeux.frameworks.CocoaExtensions", "General");
	});
#endif

	return _subsystem;
}

#if _LogToConsoleSupportsUnifiedLogging == 1
static LogToConsoleSubsystemType _LogToConsoleDefaultSubsystemValue = NULL;

static BOOL _LogToConsoleIsUsingUnifiedLogging = NO;
#endif

LogToConsoleSubsystemType _LogToConsoleDefaultSubsystem(void)
{
#if _LogToConsoleSupportsUnifiedLogging == 1
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		_LogToConsoleIsUsingUnifiedLogging = [XRSystemInformation isUsingOSXSierraOrLater];
	});

	if (_LogToConsoleIsUsingUnifiedLogging == NO) {
		return NULL;
	}

	if (_LogToConsoleDefaultSubsystemValue == NULL) {
		return OS_LOG_DEFAULT;
	}

	return _LogToConsoleDefaultSubsystemValue;
#else 
	return NULL;
#endif
}

void _LogToConsoleSetDefaultSubsystem(LogToConsoleSubsystemType subsystem)
{
#if _LogToConsoleSupportsUnifiedLogging == 1
	_LogToConsoleDefaultSubsystemValue = subsystem;
#endif
}

static BOOL _LogToConsoleDebugLoggingEnabled = NO;

void _LogToConsoleSetDebugLoggingEnabled(BOOL enabled)
{
	_LogToConsoleDebugLoggingEnabled = enabled;
}

NSString * _Nullable _LogToConsoleFormatMessage_v1_arg(LogToConsoleSubsystemType subsystem, u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, va_list arguments)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	if (type == LogToConsoleTypeDebug) {
		BOOL logDebug =

#if _LogToConsoleSupportsUnifiedLogging == 1
		(_LogToConsoleDebugLoggingEnabled || _LogToConsoleIsUsingUnifiedLogging);
#else
		_LogToConsoleDebugLoggingEnabled;
#endif

		if (logDebug == NO) {
			return nil;
		}
	}

	NSString *formatString = nil;

	if (_LogToConsoleIsUsingUnifiedLogging == NO) {
	const char *typeString = NULL;

	switch (type) {
		case LogToConsoleTypeInfo:
		{
			typeString = "Info";

			break;
		}
		case LogToConsoleTypeDebug:
		{
			typeString = "Debug";

			break;
		}
		case LogToConsoleTypeError:
		{
			typeString = "Error";

			break;
		}
		case LogToConsoleTypeFault: {
			typeString = "Fault";

			break;
		}
		default:
		{
			typeString = "Default";

			break;
		}
	}

		formatString = [NSString stringWithFormat:@"[%s] %s [Line %d]: %s", typeString, function, line, formatter];
	} else {
		formatString = [NSString stringWithFormat:@"%s [Line %d]: %s", function, line, formatter];
	}

	formatString = [formatString stringByReplacingOccurrencesOfString:@"%{public}" withString:@"%"];

	NSString *formattedString = [[NSString alloc] initWithFormat:formatString arguments:arguments];

	return formattedString;
}

NSString *_LogToConsoleFormatMessage_v2(LogToConsoleSubsystemType subsystem, u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	va_list arguments;
	va_start(arguments, formatter);

	NSString *formattedString = _LogToConsoleFormatMessage_v1_arg(subsystem, type, filename, function, line, formatter, arguments);

	va_end(arguments);

	return formattedString;
}

#pragma mark -
#pragma mark Deprecated

NSString *_LogToConsoleFormatMessage_v1(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	va_list arguments;
	va_start(arguments, formatter);

	NSString *formattedString = _LogToConsoleFormatMessage_v1_arg(LogToConsoleDefaultSubsystem(), type, filename, function, line, formatter, arguments);

	va_end(arguments);

	return formattedString;
}

void _LogToConsoleNSLogShim(const char *formatter, const char *filename, const char *function, unsigned long line, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	static BOOL _deprecationWarningPosted = NO;

	if (_deprecationWarningPosted == NO) {
		_deprecationWarningPosted = YES;

		COCOA_EXTENSIONS_DEPRECATED_WARNING
	}

	va_list arguments;
	va_start(arguments, line);

	NSString *formattedString = _LogToConsoleFormatMessage_v1_arg(LogToConsoleDefaultSubsystem(), LogToConsoleTypeDefault, filename, function, line, formatter, arguments);

	va_end(arguments);

	NSLog(formattedString);
}

void _LogToConsoleNSLogShim_v2(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	static BOOL _deprecationWarningPosted = NO;

	if (_deprecationWarningPosted == NO) {
		_deprecationWarningPosted = YES;

		COCOA_EXTENSIONS_DEPRECATED_WARNING
	}

	va_list arguments;
	va_start(arguments, formatter);

	NSString *formattedString = _LogToConsoleFormatMessage_v1_arg(LogToConsoleDefaultSubsystem(), type, filename, function, line, formatter, arguments);

	va_end(arguments);

	NSLog(formattedString);
}

NS_ASSUME_NONNULL_END
