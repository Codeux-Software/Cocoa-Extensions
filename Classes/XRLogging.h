
#if defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)
#import <os/log.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)
#define _LogToConsoleSupportsUnifiedLogging	1
#else 
#define _LogToConsoleSupportsUnifiedLogging	0
#endif

#if _LogToConsoleSupportsUnifiedLogging == 1
static os_log_t LogToConsoleDefaultSubsystem = OS_LOG_DEFAULT;

#define LogToConsoleTypeDefault OS_LOG_TYPE_DEFAULT
#define LogToConsoleTypeInfo OS_LOG_TYPE_INFO
#define LogToConsoleTypeDebug OS_LOG_TYPE_DEBUG
#define LogToConsoleTypeError OS_LOG_TYPE_ERROR
#define LogToConsoleTypeFault OS_LOG_TYPE_FAULT

#define _LogToConsoleFormattedMessage(_subsystem, _type, _formattedMessage)		\
	if ([XRSystemInformation isUsingOSXSierraOrLater]) {	\
		os_log_with_type(_subsystem, _type, _formattedMessage.UTF8String);	\
	} else {	\
		NSLog(_formattedMessage);		\
	}
#else // _LogToConsoleSupportsUnifiedLogging
static void *LogToConsoleDefaultSubsystem = NULL;

#define LogToConsoleTypeDefault 0x00
#define LogToConsoleTypeInfo 0x01
#define LogToConsoleTypeDebug 0x02
#define LogToConsoleTypeError 0x03
#define LogToConsoleTypeFault 0x04

#define _LogToConsoleFormattedMessage(_subsystem, _type, _formattedMessage)		\
	NSLog(_formattedMessage);
#endif

/* _LogToConsoleWithSubsystemAndType() */
#define _LogToConsoleWithSubsystemAndType(_subsystem, _type, _format, ...)		\
	do {	\
		NSString *_formattedMessage = _LogToConsoleFormatMessage(_type, _format, ##__VA_ARGS__);	\
		if (_formattedMessage != nil) {		\
			_LogToConsoleFormattedMessage(_subsystem, _type, _formattedMessage);	\
		}	\
	} while (0);

/* LogToConsole() */
#define LogToConsole(_format, ...)	\
	LogToConsoleWithSubsystem(LogToConsoleDefaultSubsystem, _format, ##__VA_ARGS__)

#define LogToConsoleWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDefault, _format, ##__VA_ARGS__)	\

/* LogToConsoleDebug() */
#define LogToConsoleDebug(_format, ...)	\
	LogToConsoleDebugWithSubsystem(LogToConsoleDefaultSubsystem, _format, ##__VA_ARGS__)

#define LogToConsoleDebugWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDebug, _format, ##__VA_ARGS__)	\

/* LogToConsoleError() */
#define LogToConsoleError(_format, ...)	\
	LogToConsoleErrorWithSubsystem(LogToConsoleDefaultSubsystem, _format, ##__VA_ARGS__)

#define LogToConsoleErrorWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeError, _format, ##__VA_ARGS__)	\

/* LogToConsoleInfo() */
#define LogToConsoleInfo(_format, ...)	\
	LogToConsoleInfoWithSubsystem(LogToConsoleDefaultSubsystem, _format, ##__VA_ARGS__)

#define LogToConsoleInfoWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeInfo, _format, ##__VA_ARGS__)

/* _LogToConsoleFormattedMessage() */
#define _LogToConsoleFormatMessage(_type, _format, ...)		\
	_LogToConsoleFormatMessage_v1(_type, __FILE__, __PRETTY_FUNCTION__, __LINE__, _format, ##__VA_ARGS__)

COCOA_EXTENSIONS_EXTERN NSString * _Nullable _LogToConsoleFormatMessage_v1(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...);

/* LogToConsoleSetDebugLoggingEnabled() */
#define LogToConsoleSetDebugLoggingEnabled(_enabled)	\
	_LogToConsoleSetDebugLoggingEnabled(_enabled);

/* LogToConsoleCurrentStackTrace() */
#define LogToConsoleCurrentStackTrace	\
	LogCurrentStackTraceWithSubsystem(LogToConsoleDefaultSubsystem);

#define LogCurrentStackTraceWithSubsystem(_subsystem)	\
	_LogCurrentStackTraceWithSubsystemAndType(_subsystem, LogToConsoleTypeError)

#define LogCurrentStackTraceWithType(_type)	\
	_LogCurrentStackTraceWithSubsystemAndType(LogToConsoleDefaultSubsystem, _type)

#define _LogCurrentStackTraceWithSubsystemAndType(_subsystem, _type)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, _type, "Current Stack: %@", [NSThread callStackSymbols]);

NS_ASSUME_NONNULL_END
