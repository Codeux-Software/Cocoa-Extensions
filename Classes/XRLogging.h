
#if defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)
#import <os/log.h>
#endif

NS_ASSUME_NONNULL_BEGIN

static BOOL LogToConsoleDebugLoggingEnabled = NO;

#define LogToConsoleCurrentStackTrace		LogToConsoleError("Current Stack: %{public}@", [NSThread callStackSymbols]);

#if defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)
/* macOS Sierra macros */
static os_log_t LogToConsoleDefaultSubsystem = OS_LOG_DEFAULT;

/* Internal macro for performing logging */
#define LogToConsoleTypeDefault OS_LOG_TYPE_DEFAULT
#define LogToConsoleTypeInfo OS_LOG_TYPE_INFO
#define LogToConsoleTypeDebug OS_LOG_TYPE_DEBUG
#define LogToConsoleTypeError OS_LOG_TYPE_ERROR
#define LogToConsoleTypeFault OS_LOG_TYPE_FAULT

#define _LogToConsoleWithSubsystemAndType(_subsystem, _type, _format, ...)		\
	if ([XRSystemInformation isUsingOSXSierraOrLater]) {	\
		os_log_with_type(_subsystem, _type, _format, ##__VA_ARGS__);	\
	} else {	\
		_LogToConsoleNSLog(_type, _format, ##__VA_ARGS__);		\
	}

/* LogToConsole() */
#define LogToConsole(_format, ...)	\
	LogToConsoleWithSubsystem(LogToConsoleDefaultSubsystem, _format, ##__VA_ARGS__)

#define LogToConsoleWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDefault, _format, ##__VA_ARGS__)	\

/* LogToConsoleDebug() */
#define LogToConsoleDebug(_format, ...)	\
	LogToConsoleDebugWithSubsystem(LogToConsoleDefaultSubsystem, _format, ##__VA_ARGS__)

#define LogToConsoleDebugWithSubsystem(_subsystem, _format, ...)	\
	if (LogToConsoleDebugLoggingEnabled) {		\
		_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDebug, _format, ##__VA_ARGS__)	\
	}

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

#else /* End macOS Sierra macros */

/* Internal macro for performing logging */
#define LogToConsoleTypeDefault 0x00
#define LogToConsoleTypeInfo 0x01
#define LogToConsoleTypeDebug 0x02
#define LogToConsoleTypeError 0x03
#define LogToConsoleTypeFault 0x04

#define _LogToConsoleWithSubsystemAndType(_subsystem, _type, _format, ...)		\
	_LogToConsoleNSLog(_type, _format, ##__VA_ARGS__);

/* LogToConsole() */
#define LogToConsole(_format, ...)	\
	LogToConsoleWithSubsystem(NULL, _format, ##__VA_ARGS__)

#define LogToConsoleWithSubsystem(_subsystem, _format, ...)	\
	_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDefault, _format, ##__VA_ARGS__)	\

/* LogToConsoleDebug() */
#define LogToConsoleDebug(_format, ...)	\
	LogToConsoleDebugWithSubsystem(NULL, _format, ##__VA_ARGS__)

#define LogToConsoleDebugWithSubsystem(_subsystem, _format, ...)	\
	if (LogToConsoleDebugLoggingEnabled) {		\
		_LogToConsoleWithSubsystemAndType(_subsystem, LogToConsoleTypeDebug, _format, ##__VA_ARGS__)	\
	}

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

#endif

#define _LogToConsoleNSLog(_type, _format, ...)		\
	_LogToConsoleNSLogShim_v2(_type, __FILE__, __PRETTY_FUNCTION__, __LINE__, _format, ##__VA_ARGS__);

COCOA_EXTENSIONS_EXTERN void _LogToConsoleNSLogShim_v2(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...);

NS_ASSUME_NONNULL_END
