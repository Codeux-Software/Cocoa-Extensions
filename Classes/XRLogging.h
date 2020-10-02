
#import <os/log.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XRLoggingType) {
	XRLoggingTypeDefault = 0,
	XRLoggingTypeDebug = 1,
	XRLoggingTypeInfo = 2,
	XRLoggingTypeError = 3,
	XRLoggingTypeFault = 4,
};

#define LogToConsoleTypeDefault 	XRLoggingTypeDefault
#define LogToConsoleTypeInfo 		XRLoggingTypeDebug
#define LogToConsoleTypeDebug 		XRLoggingTypeInfo
#define LogToConsoleTypeError 		XRLoggingTypeError
#define LogToConsoleTypeFault 		XRLoggingTypeFault

/* LogToConsole() */
#define LogToConsole(_message, ...)	\
	LogToConsoleWithSubsystem(NULL, _message, ##__VA_ARGS__)

#define LogToConsoleWithSubsystem(_subsystem, _message, ...)	\
	_LogToConsole(LogToConsoleTypeDefault, _subsystem, _message, ##__VA_ARGS__)	\

/* LogToConsoleDebug() */
#define LogToConsoleDebug(_message, ...)	\
	LogToConsoleDebugWithSubsystem(NULL, _message, ##__VA_ARGS__)

#define LogToConsoleDebugWithSubsystem(_subsystem, _message, ...)	\
	_LogToConsole(LogToConsoleTypeDebug, _subsystem, _message, ##__VA_ARGS__)	\

/* LogToConsoleInfo() */
#define LogToConsoleInfo(_message, ...)	\
	LogToConsoleInfoWithSubsystem(NULL, _message, ##__VA_ARGS__)

#define LogToConsoleInfoWithSubsystem(_subsystem, _message, ...)	\
	_LogToConsole(LogToConsoleTypeInfo, _subsystem, _message, ##__VA_ARGS__)

/* LogToConsoleError() */
#define LogToConsoleError(_message, ...)	\
	LogToConsoleErrorWithSubsystem(NULL, _message, ##__VA_ARGS__)

#define LogToConsoleErrorWithSubsystem(_subsystem, _message, ...)	\
	_LogToConsole(LogToConsoleTypeError, _subsystem, _message, ##__VA_ARGS__)	\

/* LogToConsoleFault() */
#define LogToConsoleFault(_message, ...)	\
	LogToConsoleFaultWithSubsystem(NULL, _message, ##__VA_ARGS__)

#define LogToConsoleFaultWithSubsystem(_subsystem, _message, ...)	\
	_LogToConsole(LogToConsoleTypeFault, _subsystem, _message, ##__VA_ARGS__)	\

/* LogToConsoleDefaultSubsystem() */
#define LogToConsoleDefaultSubsystem()	\
	_LogToConsoleDefaultSubsystem()

/* LogToConsoleSetDefaultSubsystem() */
#define LogToConsoleSetDefaultSubsystem(_subsystem)		\
	_LogToConsoleSetDefaultSubsystem(_subsystem)

/* LogToConsoleCurrentStackTrace() */
#define LogStackTrace() 	\
	LogStackTraceWithSubsystem(NULL);

#define LogStackTraceWithSubsystem(_subsystem) 	\
	_LogStackTrace(LogToConsoleTypeDefault, _subsystem)

#define LogStackTraceWithType(_type) 	\
	_LogStackTrace(_type, NULL)

#define LogStackTraceWithArguments(_type, _subsystem) 	\
	_LogStackTrace(_type, _subsystem)

/* Helper functions (private) */
#define _LogToConsole(_type, _subsystem, _message, ...)		\
	_LogToConsoleBridged_v1(_type, _subsystem, __FILE__, __LINE__, 0, __PRETTY_FUNCTION__, _message, ##__VA_ARGS__)

#define _LogStackTrace(_type, _subsystem) 	\
	_LogStackTraceBridged_v1(_type, _subsystem, [NSThread callStackSymbols])

void _LogToConsoleBridged_v1(XRLoggingType type, os_log_t _Nullable subsystem, const char *file, unsigned long line, unsigned long column, const char *function, const char *message, ...);
void _LogStackTraceBridged_v1(XRLoggingType type, os_log_t _Nullable subsystem, NSArray<NSString *> *trace);

os_log_t _Nullable _LogToConsoleDefaultSubsystem(void);
void _LogToConsoleSetDefaultSubsystem(os_log_t _Nullable subsystem);

NS_ASSUME_NONNULL_END
