
#if defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)
#import <os/log.h>
#endif

NS_ASSUME_NONNULL_BEGIN

static BOOL LogToConsoleDebugLoggingEnabled = NO;
static BOOL LogToConsoleInfoLoggingEnabled = YES;

#define LogToConsoleCurrentStackTrace		LogToConsoleError("Current Stack: %{public}@", [NSThread callStackSymbols]);

#if defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)

#define LogToConsoleWithType(_format_, _type_, ...)		\
	if ([XRSystemInformation isUsingOSXSierraOrLater]) {	\
		os_log_with_type(OS_LOG_DEFAULT, _type_, _format_, ##__VA_ARGS__);	\
	} else {	\
		LogToConsoleNSLog(_format_, ##__VA_ARGS__);		\
	}

#define LogToConsole(_format_, ...)		\
	LogToConsoleWithType(_format_, OS_LOG_TYPE_DEFAULT, ##__VA_ARGS__)

#define LogToConsoleDebug(_format_, ...)	\
	if (LogToConsoleDebugLoggingEnabled) {		\
		LogToConsoleWithType(_format_, OS_LOG_TYPE_DEBUG, ##__VA_ARGS__)	\
	}

#define LogToConsoleError(_format_, ...)	\
	LogToConsoleWithType(_format_, OS_LOG_TYPE_ERROR, ##__VA_ARGS__)	\

#define LogToConsoleInfo(_format_, ...)	\
	if (LogToConsoleInfoLoggingEnabled) {		\
		LogToConsoleWithType(_format_, OS_LOG_TYPE_INFO, ##__VA_ARGS__)	\
	}

#else

#define LogToConsoleWithType(_format_, _type_, ...)		\
	LogToConsoleNSLog(_format_, ##__VA_ARGS__);

#define LogToConsole(_format_, ...)		\
	LogToConsoleWithType(_format_, 0, ##__VA_ARGS__)

#define LogToConsoleDebug(_format_, ...)	\
	if (LogToConsoleDebugLoggingEnabled) {		\
		LogToConsoleWithType(_format_, 0, ##__VA_ARGS__)	\
	}

#define LogToConsoleError(_format_, ...)	\
	LogToConsoleWithType(_format_, 0, ##__VA_ARGS__)	\

#define LogToConsoleInfo(_format_, ...)	\
	if (LogToConsoleInfoLoggingEnabled) {		\
		LogToConsoleWithType(_format_, 0, ##__VA_ARGS__)	\
	}

#endif

#define LogToConsoleNSLog(_format_, ...)		\
	_LogToConsoleNSLogShim(_format_, __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

COCOA_EXTENSIONS_EXTERN void _LogToConsoleNSLogShim(const char *formatter, const char *filename, const char *function, unsigned long line, ...);

NS_ASSUME_NONNULL_END
