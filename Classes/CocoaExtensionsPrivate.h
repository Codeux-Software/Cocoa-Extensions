
#import "CocoaExtensions.h"

#if _LogToConsoleSupportsUnifiedLogging == 1
static os_log_t _CSFrameworkInternalLogSubsystem = NULL;
#else
static void *_CSFrameworkInternalLogSubsystem = NULL;
#endif 

#import "XRFrameworkEntryPoint.h"
