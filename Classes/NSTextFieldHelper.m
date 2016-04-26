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

#import "CocoaExtensions.h"

@implementation NSTextField (CSTextFieldHelper)

+ (void)load
{
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		XRExchangeInstanceMethod(@"NSTextField", @"setStringValue:", @"ce_priv_setStringValue:");
	});
}

- (NSString *)trimmedStringValue
{
	NSString *value = [super stringValue];

	return [value trim];
}

- (NSString *)trimmedFirstTokenStringValue
{
	NSString *value = [self trimmedStringValue];

	NSInteger spacePosition = [value stringPosition:NSStringWhitespacePlaceholder];

	if (spacePosition > 0) {
		return [value substringToIndex:spacePosition];
	}

	return value;
}

- (void)ce_priv_setStringValue:(NSString *)stringValue
{
	if (stringValue) {
		[self ce_priv_setStringValue:stringValue];
	} else {
		[self ce_priv_setStringValue:NSStringEmptyPlaceholder];
	}
}

@end

#pragma mark -

@implementation NSTextView (CSTextViewHelper)

- (BOOL)isFocused
{
	return ([[self window] firstResponder] == self);
}

- (void)focus
{
    if ([self isFocused] == NO) {
		[[self window] makeFirstResponder:self];
	}
}

- (NSRange)range
{
    return NSMakeRange(0, [self stringLength]);
}

- (NSUInteger)stringLength
{
    return [[self string] length];
}

- (nullable NSScrollView *)scrollView
{
	return [self enclosingScrollView];
}

@end
