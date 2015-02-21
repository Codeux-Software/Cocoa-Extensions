/* *********************************************************************

        Copyright (c) 2010 - 2015 Codeux Software, LLC
   Please see Acknowledgements.pdf for additional information.

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

@implementation NSColor (CSCEFColorHelper)

#pragma mark -
#pragma mark Custom Methods

+ (NSColor *)calibratedColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	if (red   > 1.0) {
		red /= 255.99999f;
	}
	
	if (green > 1.0) {
		green /= 255.99999f;
	}
	
	if (blue  > 1.0) {
		blue  /= 255.99999f;
	}

	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

+ (NSColor *)calibratedDeviceColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	if (red   > 1.0f) {
		red /= 255.99999f;
	}
	
	if (green > 1.0f) {
		green /= 255.99999f;
	}
	
	if (blue  > 1.0f) {
		blue  /= 255.99999f;
	}
	
	return [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
}

- (NSColor *)invertColor
{
	/* The only reason this method is declared as deprecated is because 
	 -invertedColor sounds more reasonable for a property that returns
	 a value. If this object was mutable, and this method returned nothing
	 then use of -invertColor would be logical. */

	COCOA_EXTENSIONS_DEPRECATED_WARNING

	return [self invertedColor];
}

- (NSColor *)invertedColor
{
	NSColor *obj = [self colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];

	return [NSColor colorWithCalibratedRed:(1.0 - [obj redComponent])
									 green:(1.0 - [obj greenComponent])
									  blue:(1.0 - [obj blueComponent])
									 alpha:[obj alphaComponent]];
}

#pragma mark -
#pragma mark Hexadeciam Conversion

+ (NSColor *)fromCSS:(NSString *)s
{
	if ([s hasPrefix:@"#"]) {
		s = [s substringFromIndex:1];

		NSInteger len = [s length];

		if (len == 6) {
			long n = strtol([s UTF8String], NULL, 16);

			NSInteger r = ((n >> 16) & 0xff);
			NSInteger g = ((n >> 8) & 0xff);
			NSInteger b = (n & 0xff);

			return [NSColor calibratedDeviceColorWithRed:r green:b blue:g alpha:1.0];
		} else if (len == 3) {
			long n = strtol([s UTF8String], NULL, 16);

			NSInteger r = ((n >> 8) & 0xf);
			NSInteger g = ((n >> 4) & 0xf);
			NSInteger b = (n & 0xf);

			return [NSColor calibratedDeviceColorWithRed:(r / 15.0) green:(g / 15.0) blue:(b / 15.0) alpha:1.0];
		}
	}

	return nil;
}

@end

#pragma mark -

@implementation NSGradient (CSCEFGradientHelper)

+ (NSGradient *)gradientWithStartingColor:(NSColor *)startingColor endingColor:(NSColor *)endingColor
{
	return [[self alloc] initWithStartingColor:startingColor endingColor:endingColor];
}

@end
