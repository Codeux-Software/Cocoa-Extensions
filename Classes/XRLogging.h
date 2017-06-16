
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
#define LogToConsoleTypeDefault OS_LOG_TYPE_DEFAULT
#define LogToConsoleTypeInfo OS_LOG_TYPE_INFO
#define LogToConsoleTypeDebug OS_LOG_TYPE_DEBUG
#define LogToConsoleTypeError OS_LOG_TYPE_ERROR
#define LogToConsoleTypeFault OS_LOG_TYPE_FAULT

#define LogToConsoleSubsystemType os_log_t

#define _LogToConsoleFormattedMessage(_subsystem, _type, _formattedMessage)		\
	if (_subsystem != NULL) {	\
		os_log_with_type(_subsystem, _type, "%{public}@", _formattedMessage);	\
} else {	\
		NSLog(_formattedMessage);		\
	}
#else // _LogToConsoleSupportsUnifiedLogging
#define LogToConsoleTypeDefault 0x00
#define LogToConsoleTypeInfo 0x01
#define LogToConsoleTypeDebug 0x02
#define LogToConsoleTypeError 0x03
#define LogToConsoleTypeFault 0x04

#define LogToConsoleSubsystemType void *

#define _LogToConsoleFormattedMessage(_subsystem, _type, _formattedMessage)		\
	NSLog(_formattedMessage);
#endif

/* _LogToConsoleWithSubsystemAndType() */
#define _LogToConsoleWithSubsystemAndType(_subsystem, _type, _format, ...)		\
	do {	\
		LogToConsoleSubsystemType _subsystemPtr = _subsystem;	\
		if (_subsystemPtr == NULL) {	\
			_subsystemPtr = LogToConsoleDefaultSubsystem();		\
		}	\
		NSString *_formattedMessage = _LogToConsoleFormatMessage(_subsystemPtr, _type, _format, ##__VA_ARGS__);	\
		if (_formattedMessage != nil) {		\
			_LogToConsoleFormattedMessage(_subsystemPtr, _type, _formattedMessage);	\
		}	\
	} while (0);

/* LogToConsole() */
#define LogToConsole(_format, ...)	\
	LogToConsoleWithSubsystem(NULL, _format, ##__VA_ARGS__)

#define LogToConsoleWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDefault, _format, ##__VA_ARGS__)	\

/* LogToConsoleDebug() */
#define LogToConsoleDebug(_format, ...)	\
	LogToConsoleDebugWithSubsystem(NULL, _format, ##__VA_ARGS__)

#define LogToConsoleDebugWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDebug, _format, ##__VA_ARGS__)	\

/* LogToConsoleError() */
#define LogToConsoleError(_format, ...)	\
	LogToConsoleErrorWithSubsystem(NULL, _format, ##__VA_ARGS__)

#define LogToConsoleErrorWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeError, _format, ##__VA_ARGS__)	\

/* LogToConsoleInfo() */
#define LogToConsoleInfo(_format, ...)	\
	LogToConsoleInfoWithSubsystem(NULL, _format, ##__VA_ARGS__)

#define LogToConsoleInfoWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeInfo, _format, ##__VA_ARGS__)

/* _LogToConsoleFormattedMessage() */
#define _LogToConsoleFormatMessage(_subsystem, _type, _format, ...)		\
	_LogToConsoleFormatMessage_v2(_subsystem, _type, __FILE__, __PRETTY_FUNCTION__, __LINE__, _format, ##__VA_ARGS__)

/* LogToConsoleSetDebugLoggingEnabled() */
#define LogToConsoleSetDebugLoggingEnabled(_enabled)	\
	_LogToConsoleSetDebugLoggingEnabled(_enabled);

/* LogToConsoleDefaultSubsystem() */
#define LogToConsoleDefaultSubsystem()	\
	_LogToConsoleDefaultSubsystem()

/* LogToConsoleSetDefaultSubsystem() */
#define LogToConsoleSetDefaultSubsystem(_subsystem)		\
	_LogToConsoleSetDefaultSubsystem(_subsystem)

/* LogToConsoleCurrentStackTrace() */
#define LogToConsoleCurrentStackTrace	\
	LogCurrentStackTraceWithSubsystem(NULL);

#define LogCurrentStackTraceWithSubsystem(_subsystem)	\
	_LogCurrentStackTraceWithSubsystemAndType(_subsystem, LogToConsoleTypeError)

#define LogCurrentStackTraceWithType(_type)	\
	_LogCurrentStackTraceWithSubsystemAndType(NULL, _type)

#define _LogCurrentStackTraceWithSubsystemAndType(_subsystem, _type)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, _type, "Current Stack: %@", [NSThread callStackSymbols]);

/* Helper functions (private) */
COCOA_EXTENSIONS_EXTERN NSString * _Nullable _LogToConsoleFormatMessage_v2(LogToConsoleSubsystemType subsystem, u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...);

void _LogToConsoleSetDebugLoggingEnabled(BOOL enabled);

LogToConsoleSubsystemType _Nullable _LogToConsoleDefaultSubsystem(void);
void _LogToConsoleSetDefaultSubsystem(LogToConsoleSubsystemType _Nullable subsystem);

NS_ASSUME_NONNULL_END
