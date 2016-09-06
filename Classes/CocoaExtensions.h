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

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
	#define COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
#else
	#define COCOA_EXTENSIONS_BUILT_AGAINST_iOS_SDK
#endif

#import <CocoaExtensions/StaticDefinitions.h>

#import <CocoaExtensions/XRLogging.h>

#import <CocoaExtensions/XRBase64Encoding.h>
#import <CocoaExtensions/XRGlobalModels.h>
#import <CocoaExtensions/XRRegularExpression.h>

#import <CocoaExtensions/NSArrayHelper.h>
#import <CocoaExtensions/NSByteCountFormatterHelper.h>
#import <CocoaExtensions/NSDataHelper.h>
#import <CocoaExtensions/NSDateHelper.h>
#import <CocoaExtensions/NSDictionaryHelper.h>
#import <CocoaExtensions/NSNumberHelper.h>
#import <CocoaExtensions/NSRangeHelper.h>
#import <CocoaExtensions/NSRectHelper.h>
#import <CocoaExtensions/NSStringHelper.h>
#import <CocoaExtensions/NSValueHelper.h>

#ifdef COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
#import <CocoaExtensions/ApplePrivateMac.h>

#import <CocoaExtensions/XRAccessibility.h>
#import <CocoaExtensions/XRAddressBook.h>
#import <CocoaExtensions/XRKeychain.h>
#import <CocoaExtensions/XRPortMapper.h>
#import <CocoaExtensions/XRSystemInformation.h>

#import <CocoaExtensions/NSArrayControllerHelper.h>
#import <CocoaExtensions/NSBundleHelper.h>
#import <CocoaExtensions/NSColorHelper.h>
#import <CocoaExtensions/NSFileManagerHelper.h>
#import <CocoaExtensions/NSFontHelper.h>
#import <CocoaExtensions/NSImageHelper.h>
#import <CocoaExtensions/NSIndexSetHelper.h>
#import <CocoaExtensions/NSMenuHelper.h>
#import <CocoaExtensions/NSMethodSignatureHelper.h>
#import <CocoaExtensions/NSObjectHelper.h>
#import <CocoaExtensions/NSOutlineViewHelper.h>
#import <CocoaExtensions/NSPasteboardHelper.h>
#import <CocoaExtensions/NSScreenHelper.h>
#import <CocoaExtensions/NSSplitViewHelper.h>
#import <CocoaExtensions/NSTextFieldHelper.h>
#import <CocoaExtensions/NSThemeFrameHelper.h>
#import <CocoaExtensions/NSThreadHelper.h>
#import <CocoaExtensions/NSURLHelper.h>
#import <CocoaExtensions/NSUserDefaultsHelper.h>
#import <CocoaExtensions/NSWindowHelper.h>
#import <CocoaExtensions/NSWorkspaceHelper.h>
#endif
