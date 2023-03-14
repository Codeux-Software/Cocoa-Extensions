/* *********************************************************************
 *
 *         Copyright (c) 2015 - 2020 Codeux Software, LLC
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

@interface XRSystemInformation : NSObject
@property (nonatomic, class, copy, nullable, readonly) NSString *formattedEthernetMacAddress;

@property (nonatomic, class, readonly) BOOL systemIsSleeping;

@property (nonatomic, class, copy, nullable, readonly) NSString *systemBuildVersion;
@property (nonatomic, class, copy, nullable, readonly) NSString *systemStandardVersion;

@property (nonatomic, class, copy, nullable, readonly) NSString *systemOperatingSystemName;

@property (nonatomic, class, copy, nullable, readonly) NSString *systemModelName; // "iMac," "MacBook," "MacBook Pro," etc.

+ (nullable NSString *)retrieveSystemInformationKey:(NSString *)key;

@property (nonatomic, class, readonly) BOOL systemIsAppleSilicon;

+ (BOOL)isUsingOSXLionOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXLionOrLater() instead");
+ (BOOL)isUsingOSXMountainLionOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXMountainLionOrLater() instead");
+ (BOOL)isUsingOSXMavericksOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXMavericksOrLater() instead");
+ (BOOL)isUsingOSXYosemiteOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXYosemiteOrLater() instead");
+ (BOOL)isUsingOSXElCapitanOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXElCapitanOrLater() instead");
+ (BOOL)isUsingOSXSierraOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXSierraOrLater() instead");
+ (BOOL)isUsingOSXHighSierraOrLater COCOA_EXTENSIONS_DEPRECATED("Use XRRunningOnOSXHighSierraOrLater() instead");
@end

BOOL XRRunningOnOSXLionOrLater(void); // 10.7
BOOL XRRunningOnOSXMountainLionOrLater(void); // 10.8
BOOL XRRunningOnOSXMavericksOrLater(void); // 10.9
BOOL XRRunningOnOSXYosemiteOrLater(void); // 10.10
BOOL XRRunningOnOSXElCapitanOrLater(void); // 10.11
BOOL XRRunningOnOSXSierraOrLater(void); // 10.12
BOOL XRRunningOnOSXHighSierraOrLater(void); // 10.13
BOOL XRRunningOnOSXMojaveOrLater(void); // 10.14
BOOL XRRunningOnOSXCatalinaOrLater(void); // 10.15
BOOL XRRunningOnOSXBigSurOrLater(void); // 11.0
BOOL XRRunningOnOSXMontereyOrLater(void); // 12.0

BOOL XRRunningOnUnrecognizedOSVersion(void); // 10.??

NS_ASSUME_NONNULL_END
