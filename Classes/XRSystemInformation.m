/* *********************************************************************

        Copyright (c) 2010 - 2015 Codeux Software, LLC
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

#import <IOKit/IOKitLib.h>

#include <sys/sysctl.h>

NS_ASSUME_NONNULL_BEGIN

@implementation XRSystemInformation

#pragma mark -
#pragma mark Public

+ (nullable NSString *)formattedEthernetMacAddress
{
	CFDataRef macAddressRef = nil;

	/* Mach port used to initiate communication with IOKit. */
	mach_port_t masterPort;

	kern_return_t machPortResult = IOMasterPort(MACH_PORT_NULL, &masterPort);

	if (machPortResult != KERN_SUCCESS) {
		return nil;
	}

	/* Create a matching dictionary */
	CFMutableDictionaryRef matchingDict = IOBSDNameMatching(masterPort, 0, "en0");

	if (matchingDict == NULL) {
		return nil;
	}

	/* Look up registered bjects that match a matching dictionary. */
	io_iterator_t iterator;

	kern_return_t getMatchResult = IOServiceGetMatchingServices(masterPort, matchingDict, &iterator);

	if (getMatchResult != KERN_SUCCESS) {
		return nil;
	}

	/* Iterate over services */
	io_object_t service;

	while ((service = IOIteratorNext(iterator)) > 0) {
		io_object_t parentService;

		kern_return_t kernResult = IORegistryEntryGetParentEntry(service, kIOServicePlane, &parentService);

		if (kernResult == KERN_SUCCESS) {
			if (macAddressRef) {
				CFRelease(macAddressRef);
			}

			macAddressRef = (CFDataRef)IORegistryEntryCreateCFProperty(parentService, CFSTR("IOMACAddress"), kCFAllocatorDefault, 0);

			IOObjectRelease(parentService);
		}

		IOObjectRelease(service);
	}

	IOObjectRelease(iterator);

	/* If we have a MAC address, convert it into a formatted string. */
	if (macAddressRef) {
		unsigned char macAddressBytes[6];

		CFDataGetBytes(macAddressRef, CFRangeMake(0, 6), macAddressBytes);

		CFRelease(macAddressRef);

		NSString *formattedMacAddress =
		[NSString stringWithFormat:
			 @"%02x:%02x:%02x:%02x:%02x:%02x",
			 macAddressBytes[0], macAddressBytes[1], macAddressBytes[2],
			 macAddressBytes[3], macAddressBytes[4], macAddressBytes[5]];

		return formattedMacAddress;
	}

	return nil;
}

+ (nullable NSString *)systemBuildVersion
{
	static id cachedValue = nil;
	
	if (cachedValue == nil) {
		cachedValue = [self retrieveSystemInformationKey:@"ProductBuildVersion"];
	}
	
	return cachedValue;
}

+ (nullable NSString *)systemStandardVersion
{
	static id cachedValue = nil;
	
	if (cachedValue == nil) {
		cachedValue = [self retrieveSystemInformationKey:@"ProductVersion"];
	}
	
	return cachedValue;
}

+ (nullable NSString *)systemOperatingSystemName
{
	static id cachedValue = nil;

	if (cachedValue == nil) {
		if (XRRunningOnOSXHighSierraOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"macOS High Sierra", @"XRSystemInformation", nil);
		} else if (XRRunningOnOSXSierraOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"macOS Sierra", @"XRSystemInformation", nil);
		} else if (XRRunningOnOSXElCapitanOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"OS X El Capitan", @"XRSystemInformation", nil);
		} else if (XRRunningOnOSXYosemiteOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"OS X Yosemite", @"XRSystemInformation", nil);
		} else if (XRRunningOnOSXMavericksOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"OS X Mavericks", @"XRSystemInformation", nil);
		} else if (XRRunningOnOSXMountainLionOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"OS X Mountain Lion", @"XRSystemInformation", nil);
		} else if (XRRunningOnOSXLionOrLater()) {
			cachedValue = NSLocalizedStringFromTable(@"OS X Lion", @"XRSystemInformation", nil);
		}
	}

	return cachedValue;
}

+ (BOOL)isUsingOSXLionOrLater
{
	return XRRunningOnOSXLionOrLater();
}

+ (BOOL)isUsingOSXMountainLionOrLater
{
	return XRRunningOnOSXMountainLionOrLater();
}

+ (BOOL)isUsingOSXMavericksOrLater
{
	return XRRunningOnOSXMavericksOrLater();
}

+ (BOOL)isUsingOSXYosemiteOrLater
{
	return XRRunningOnOSXYosemiteOrLater();
}

+ (BOOL)isUsingOSXElCapitanOrLater
{
	return XRRunningOnOSXElCapitanOrLater();
}

+ (BOOL)isUsingOSXSierraOrLater
{
	return XRRunningOnOSXSierraOrLater();
}

+ (BOOL)isUsingOSXHighSierraOrLater
{
	return XRRunningOnOSXHighSierraOrLater();
}

#pragma mark -
#pragma mark Private

+ (nullable NSString *)systemModelToken
{
	static id cachedValue = nil;
	
	if (cachedValue == nil) {
		char modelBuffer[256];
		
		size_t sz = sizeof(modelBuffer);
		
		if (sysctlbyname("hw.model", modelBuffer, &sz, NULL, 0) == 0) {
			modelBuffer[(sizeof(modelBuffer) - 1)] = 0;
			
			cachedValue = @(modelBuffer);
		}
	}
	
	return cachedValue;
}

+ (nullable NSString *)systemModelName
{
	static id cachedValue = nil;
	
	if (cachedValue == nil) {
		/* This method is not returning very detailed information. Only
		the model being ran on. Therefore, not much love will be put into
		it. As can be seen below, we are defining our models inline instead
		of using a dictionary that will have to be loaded from a file. */
		
		NSDictionary *modelPrefixes = @{
			@"macbookpro"	: @"MacBook Pro",
			@"macbookair"	: @"MacBook Air",
			@"macbook"		: @"MacBook",
			@"macpro"		: @"Mac Pro",
			@"macmini"		: @"Mac Mini",
			@"imac"			: @"iMac",
			@"xserve"		: @"Xserve"
		};
		
		NSString *modelToken = [self systemModelToken];
		
		if ([modelToken length] <= 0) {
			return nil;
		}
		
		modelToken = [modelToken lowercaseString];
		
		for (NSString *modelPrefix in modelPrefixes) {
			if ([modelToken hasPrefix:modelPrefix]) {
				cachedValue = modelPrefixes[modelPrefix];
			}
		}
	}
	
	return cachedValue;
}

+ (nullable NSString *)retrieveSystemInformationKey:(NSString *)key
{
	NSParameterAssert(key != nil);

	NSDictionary *sysinfo = [self systemInformationDictionary];

	NSString *infos = sysinfo[key];

	if ([infos length] <= 0) {
		return nil;
	}

	return infos;
}

+ (nullable NSDictionary<NSString *, id> *)createDictionaryFromFileAtPath:(NSString *)path
{
	NSParameterAssert(path != nil);

	NSFileManager *fileManger = [NSFileManager defaultManager];

	if ([fileManger fileExistsAtPath:path]) {
		return [NSDictionary dictionaryWithContentsOfFile:path];
	} else {
		return nil;
	}
}

+ (nullable NSDictionary *)systemInformationDictionary
{
	NSDictionary *systemInfo = [XRSystemInformation createDictionaryFromFileAtPath:@"/System/Library/CoreServices/SystemVersion.plist"];

	if (systemInfo == nil) {
		systemInfo = [XRSystemInformation createDictionaryFromFileAtPath:@"/System/Library/CoreServices/ServerVersion.plist"];
	}

	return systemInfo;
}

@end

BOOL XRRunningOnOSXLionOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 7;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		} else {
			cachedValue = (floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_7);
		}
	});

	return cachedValue;
}

BOOL XRRunningOnOSXMountainLionOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 8;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		} else {
			cachedValue = (floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_8);
		}
	});

	return cachedValue;
}

BOOL XRRunningOnOSXMavericksOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 9;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		} else {
			cachedValue = (floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_9);
		}
	});

	return cachedValue;
}

BOOL XRRunningOnOSXYosemiteOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 10;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		}
	});

	return cachedValue;
}

BOOL XRRunningOnOSXElCapitanOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 11;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		}
	});

	return cachedValue;
}

BOOL XRRunningOnOSXSierraOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 12;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		}
	});

	return cachedValue;
}

BOOL XRRunningOnOSXHighSierraOrLater(void)
{
	static BOOL cachedValue = NO;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
			NSOperatingSystemVersion compareVersion;

			compareVersion.majorVersion = 10;
			compareVersion.minorVersion = 13;
			compareVersion.patchVersion = 0;

			cachedValue = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:compareVersion];
		}
	});

	return cachedValue;
}

NS_ASSUME_NONNULL_END
