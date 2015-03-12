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

/* A portion of this source file contains copyrighted work derived from one or more
 3rd party, open source projects. The use of this work is hereby acknowledged. */

/*
 The New BSD License

 Copyright (c) 2008 - 2010 Satoshi Nakagawa < psychs AT limechat DOT net >
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
*/

#import "CocoaExtensions.h"

#import <CommonCrypto/CommonDigest.h>

#include <arpa/inet.h>

NSString * const NSStringEmptyPlaceholder = @"";
NSString * const NSStringNewlinePlaceholder = @"\x0a";
NSString * const NSStringWhitespacePlaceholder = @"\x20";

NSString * const CSCEF_LatinAlphabetIncludingUnderscoreDashCharacterSet = @"\x2d\x5f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a";

@interface NSString (CSCEFStringHelperPrivate)
+ (id)getTokenFromFirstQuoteGroup:(id)stringValue returnedDeletionRange:(NSRange *)quoteRange;
+ (id)getTokenFromFirstWhitespaceGroup:(id)stringValue returnedDeletionRange:(NSRange *)whitespaceRange;
@end

@implementation NSString (CSCEFStringHelper)

- (NSRange)range
{
	return NSMakeRange(0, ([self length] - 1));
}

+ (instancetype)stringWithBytes:(const void *)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding
{
	return [[NSString alloc] initWithBytes:bytes length:length encoding:encoding];
}

+ (instancetype)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
	return [[NSString alloc] initWithData:data encoding:encoding];
}

+ (NSString *)stringWithUUID
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	
	NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
	
	CFRelease(uuidObj);

	return uuidString;
}

+ (NSString *)charsetRepFromStringEncoding:(NSStringEncoding)encoding
{
	CFStringEncoding cfencoding = CFStringConvertNSStringEncodingToEncoding(encoding);

	CFStringRef charsetStr = CFStringConvertEncodingToIANACharSetName(cfencoding);

	return (__bridge NSString *)(charsetStr);
}

+ (NSDictionary *)supportedStringEncodingsWithTitle:(BOOL)favorUTF8
{
    NSMutableDictionary *encodingList = [NSMutableDictionary dictionary];

    NSArray *supportedEncodings = [NSString supportedStringEncodings:favorUTF8];

    for (id encoding in supportedEncodings) {
        NSString *encodingTitle = [NSString localizedNameOfStringEncoding:[encoding integerValue]];

		if (encodingTitle) {
			encodingList[encodingTitle] = encoding;
		}
    }

    return encodingList;
}

+ (NSArray *)supportedStringEncodings:(BOOL)favorUTF8
{
    NSMutableArray *encodingList = [NSMutableArray array];

    const NSStringEncoding *encodings = [NSString availableStringEncodings];

    if (favorUTF8) {
        [encodingList addObject:@(NSUTF8StringEncoding)];
    }

    while (1 == 1) {
        NSStringEncoding encoding = (*encodings++);

        if (encoding == 0) {
            break;
        }

        if (favorUTF8 && encoding == NSUTF8StringEncoding) {
            continue;
        }
		
		[encodingList addObject:@(encoding)];
    }

    return encodingList;
}

- (NSString *)stringCharacterAtIndex:(NSUInteger)anIndex
{
	if (anIndex > [self length]) {
		return nil;
	}
	
	UniChar strChar = [self characterAtIndex:anIndex];

	return [NSString stringWithUniChar:strChar];
}

- (NSString *)substringAfterIndex:(NSUInteger)anIndex
{
	return [self substringFromIndex:(anIndex + 1)];
}

- (NSString *)substringBeforeIndex:(NSUInteger)anIndex
{
	return [self substringFromIndex:(anIndex - 1)];
}

- (NSString *)stringByAppendingIRCFormattingStop
{
	return [self stringByAppendingFormat:@"%C", 0x0F];
}

- (BOOL)isEqualIgnoringCase:(NSString *)other
{
	return ([self caseInsensitiveCompare:other] == NSOrderedSame);
}

- (BOOL)contains:(NSString *)str
{
	return ([self stringPosition:str] >= 0);
}

- (BOOL)containsIgnoringCase:(NSString *)str
{
	return ([self stringPositionIgnoringCase:str] >= 0);
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
	
    NSMutableString *output = [NSMutableString stringWithCapacity:(CC_SHA1_DIGEST_LENGTH * 2)];
	
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
	
    return output;
}

- (NSString *)sha256
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256([data bytes], (CC_LONG)[data length], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:(CC_SHA256_DIGEST_LENGTH * 2)];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)md5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_MD5_DIGEST_LENGTH ];

    CC_MD5([data bytes], (CC_LONG)[data length], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:(CC_MD5_DIGEST_LENGTH * 2)];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH ; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSArray *)split:(NSString *)delimiter
{
	return [self componentsSeparatedByString:delimiter];
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimNewlines
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)trimCharacters:(NSString *)charset
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:charset]];
}

- (NSString *)removeAllNewlines
{
	return [self stringByReplacingOccurrencesOfString:NSStringNewlinePlaceholder withString:NSStringEmptyPlaceholder];
}

- (BOOL)hasPrefixIgnoringCase:(NSString *)aString
{
	NSRange prefixRange = [self rangeOfString:aString options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
	
	return (prefixRange.location == 0 && prefixRange.length > 0);
}

- (BOOL)hasSuffixIgnoringCase:(NSString *)aString
{
	NSRange suffixRange = [self rangeOfString:aString options:(NSAnchoredSearch | NSCaseInsensitiveSearch | NSBackwardsSearch)];

	return ((suffixRange.length + suffixRange.location) == [self length]);
}

- (CGFloat)compareWithWord:(NSString *)stringB lengthPenaltyWeight:(CGFloat)weight
{
	NSString *stringA = [NSString stringWithString:self];

	NSAssertReturnR(([stringB length] > 0), 0.0);
	NSAssertReturnR(([stringB length] <= [stringA length]), 0.0);

	stringA = [stringA lowercaseString];
	stringB = [stringB lowercaseString];

	NSInteger commonCharacterCount = 0;
	NSInteger startPosition = 0;

	CGFloat distancePenalty = 0;

	for (NSInteger i = 0; i < [stringB length]; i++) {
		BOOL matchFound = NO;

		for (NSInteger j = startPosition; j < [stringA length]; j++) {
			if ([stringB characterAtIndex:i] == [stringA characterAtIndex:j]) {
				NSInteger distance = (j - startPosition);

				if (distance > 0) {
					distancePenalty += ((distance - 1.0) / distance);
				}

				commonCharacterCount++;

				startPosition = (j + 1);

				matchFound = YES;

				break;
			}
		}

		if (matchFound == NO) {
			return 0.0;
		}
	}

	CGFloat lengthPenalty = (1.0 - (CGFloat)[stringB length] / [stringA length]);

	return (commonCharacterCount - distancePenalty - weight*lengthPenalty);
}

- (NSInteger)stringPosition:(NSString *)needle
{
	NSRange searchResult = [self rangeOfString:needle];
	
	if (searchResult.location == NSNotFound) {
		return -1;
	}
	
	return searchResult.location;
}

- (NSInteger)stringPositionIgnoringCase:(NSString *)needle
{
	NSRange searchResult = [self rangeOfString:needle options:NSCaseInsensitiveSearch];

	if (searchResult.location == NSNotFound) {
		return -1;
	}

	return searchResult.location;
}

- (NSString *)stringByDeletingPreifx:(NSString *)prefix
{
	if ([prefix length] > 0 && [self length] >= [prefix length]) {
		if ([self hasPrefix:prefix]) {
			return [self substringFromIndex:[prefix length]];
		}
	}
	
	return self;
}

- (BOOL)isIPAddress
{
	return ([self isIPv4Address] || [self isIPv6Address]);
}

- (BOOL)isIPv4Address
{
	struct sockaddr_in sa;
	
    int result = inet_pton(AF_INET, [self UTF8String], &(sa.sin_addr));
    
	return (result == 1);
}

- (BOOL)isIPv6Address
{
	struct in6_addr sa;
	
    int result = inet_pton(AF_INET6, [self UTF8String], &sa);
    
	return (result == 1);
}

- (NSString *)trimAndGetFirstToken
{
	NSObjectIsEmptyAssertReturn(self, self);

	NSString *firstToken = [NSString getTokenFromFirstWhitespaceGroup:[self trim] returnedDeletionRange:NULL];

	return firstToken;
}

- (NSString *)safeFilename
{
	NSString *bob = [self trim];

	bob = [bob stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	bob = [bob stringByReplacingOccurrencesOfString:@":" withString:@"_"];

	return bob;
}

- (BOOL)isNumericOnly
{
	NSObjectIsEmptyAssertReturn(self, NO);
	
	for (NSUInteger i = 0; i < [self length]; ++i) {
		UniChar c = [self characterAtIndex:i];
		
		if (CSCEF_StringIsBase10Numeric(c) == NO) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)isAlphabeticNumericOnly
{
	NSObjectIsEmptyAssertReturn(self, NO);

	for (NSUInteger i = 0; i < [self length]; ++i) {
		UniChar c = [self characterAtIndex:i];
		
		if (CSCEF_StringIsAlphabeticNumeric(c) == NO) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)containsCharactersFromCharacterSet:(NSCharacterSet *)validChars
{
	PointerIsEmptyAssertReturn(validChars, NO);

	NSObjectIsEmptyAssertReturn(self, NO);

	NSRange searchRange = [self rangeOfCharacterFromSet:validChars];

	return NSDissimilarObjects(searchRange.location, NSNotFound);
}

- (BOOL)onlyContainsCharactersFromCharacterSet:(NSCharacterSet *)validChars
{
	PointerIsEmptyAssertReturn(validChars, NO);

	NSObjectIsEmptyAssertReturn(self, NO);

	NSRange searchRange = [self rangeOfCharacterFromSet:validChars];

	return (searchRange.location == NSNotFound);
}

- (BOOL)containsCharacters:(NSString *)validChars
{
	NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:validChars];

	return [self containsCharactersFromCharacterSet:chars];
}

- (BOOL)onlyContainsCharacters:(NSString *)validChars
{
	NSCharacterSet *chars = [[NSCharacterSet characterSetWithCharactersInString:validChars] invertedSet];

	return [self onlyContainsCharactersFromCharacterSet:chars];
}

- (NSString *)stringByDeletingAllCharactersInSet:(NSString *)validChars deleteThoseNotInSet:(BOOL)onlyDeleteThoseNotInSet
{
	NSObjectIsEmptyAssertReturn(self, nil);
	NSObjectIsEmptyAssertReturn(validChars, nil);
	
	NSMutableString *result = [NSMutableString string];

	NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:validChars];
	
	NSScanner *scanner = [NSScanner scannerWithString:self];
	
	while ([scanner isAtEnd] == NO) {
		NSString *buffer;
		
		if (onlyDeleteThoseNotInSet) {
			if ([scanner scanCharactersFromSet:chars intoString:&buffer]) {
				[result appendString:buffer];
			} else {
				[scanner setScanLocation:([scanner scanLocation] + 1)];
			}
		} else {
			if ([scanner scanCharactersFromSet:chars intoString:&buffer]) {
				[scanner setScanLocation:([scanner scanLocation] + 1)];
			} else {
				[result appendString:buffer];
			}
		}
	}
	
	return result;
}

- (NSString *)stringByDeletingAllCharactersInSet:(NSString *)validChars
{
	return [self stringByDeletingAllCharactersInSet:validChars deleteThoseNotInSet:NO];
}

- (NSString *)stringByDeletingAllCharactersNotInSet:(NSString *)validChars
{
	return [self stringByDeletingAllCharactersInSet:validChars deleteThoseNotInSet:YES];
}

- (NSRange)rangeOfNextSegmentMatchingRegularExpression:(NSString *)regex startingAt:(NSUInteger)start
{
	NSUInteger stringLength = [self length];
	
	NSAssertReturnR((stringLength > start), NSEmptyRange());
	
	NSString *searchString = [self substringFromIndex:start];
	
	NSRange searchRange = [XRRegularExpression string:searchString rangeOfRegex:regex];

	if (searchRange.location == NSNotFound) {
		return NSEmptyRange();
	}

	NSRange r = NSMakeRange((start + searchRange.location),
									 searchRange.length);
	
	return r;
}

- (NSString *)encodeURIComponent
{
	NSObjectIsEmptyAssertReturn(self, NSStringEmptyPlaceholder);
	
	const char *sourcedata = [self UTF8String];
	const char *characters = "0123456789ABCDEF";

	PointerIsEmptyAssertReturn(sourcedata, NSStringEmptyPlaceholder);
	
	NSUInteger datalength = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	char  buf[(datalength * 4)];
	char *dest = buf;
	
	for (NSInteger i = (datalength - 1); i >= 0; --i) {
		unsigned char c = *sourcedata++;
		
		if (CSCEF_StringIsWordLetter(c) || c == '-' || c == '.' || c == '~') {
			*dest++ = c;
		} else {
			*dest++ = '%';
			*dest++ = characters[(c / 16)];
			*dest++ = characters[(c % 16)];
		}
	}
	
	return [NSString stringWithBytes:buf length:(dest - buf) encoding:NSASCIIStringEncoding];
}

- (NSString *)encodeURIFragment
{
	NSObjectIsEmptyAssertReturn(self, NSStringEmptyPlaceholder);

	const char *sourcedata = [self UTF8String];
	const char *characters = "0123456789ABCDEF";

	PointerIsEmptyAssertReturn(sourcedata, NSStringEmptyPlaceholder);

	NSUInteger datalength = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

	char  buf[(datalength * 4)];
	char *dest = buf;

	for (NSInteger i = (datalength - 1); i >= 0; --i) {
		unsigned char c = *sourcedata++;
		
		if (CSCEF_StringIsWordLetter(c)
			|| c == '#' || c == '%'
			|| c == '&' || c == '+'
			|| c == ',' || c == '-'
			|| c == '.' || c == '/'
			|| c == ':' || c == ';'
			|| c == '=' || c == '?'
			|| c == '@' || c == '~')
		{
			*dest++ = c;
		} else {
			*dest++ = '%';
			*dest++ = characters[(c / 16)];
			*dest++ = characters[(c % 16)];
		}
	}
	
	return [NSString stringWithBytes:buf length:(dest - buf) encoding:NSASCIIStringEncoding];
}

- (NSString *)decodeURIFragment
{
	return [self stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

#ifdef COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight forcedFont:(NSFont *)textFont
{
	CGFloat boundHeight = [self pixelHeightInWidth:boundWidth forcedFont:textFont];
	
	return (boundHeight / lineHeight);
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width forcedFont:(NSFont *)font
{
	NSAttributedString *base = [NSAttributedString emptyStringWithBase:self];

	return [base pixelHeightInWidth:width forcedFont:font];
}
#endif

- (NSString *)string
{
	return self;
}

+ (id)getTokenFromFirstWhitespaceGroup:(id)stringValue returnedDeletionRange:(NSRange *)whitespaceRange
{
	/* What type of string are we processing? */
	BOOL isAttributedString = ([stringValue isKindOfClass:[NSAttributedString class]]);

	/* Check the input. */
	if (stringValue == nil || [stringValue length] < 1) {
		if (isAttributedString) {
			return [NSAttributedString emptyString];
		} else {
			return NSStringEmptyPlaceholder;
		}
	}

	/* Define base variables. */
	NSScanner *scanner = [NSScanner scannerWithString:[stringValue string]];

	[scanner setCharactersToBeSkipped:nil]; // Do not skip anything.

	/* Scan up to first space. */
	[scanner scanUpToString:@" " intoString:NULL];

	NSInteger scanLocation = [scanner scanLocation];

	/* We now scan from the scan location to the end of whitespaces. */
	if (whitespaceRange) {
		NSInteger stringLength = [stringValue length];
		NSInteger stringForward = scanLocation;

		while (1 == 1) { // Infinite loops are safe! :-)
			NSAssertReturnLoopBreak(stringForward < stringLength);

			UniChar c = [[stringValue string] characterAtIndex:stringForward];

			if (c == ' ') {
				stringForward += 1;
			} else {
				break;
			}
		}

		*whitespaceRange = NSMakeRange(0, stringForward);
	}

	/* Build and return final tokenized string from range. */
	id resultString;

	if (isAttributedString) {
		resultString = [stringValue attributedSubstringFromRange:NSMakeRange(0, scanLocation)];
	} else {
		resultString = [stringValue substringToIndex:scanLocation];
	}

	return resultString;
}

+ (id)getTokenFromFirstQuoteGroup:(id)stringValue returnedDeletionRange:(NSRange *)quoteRange
{
	/* What type of string are we processing? */
	BOOL isAttributedString = ([stringValue isKindOfClass:[NSAttributedString class]]);

	/* Check the input. */
	if (stringValue == nil || [stringValue length] < 1) {
		if (isAttributedString) {
			return [NSAttributedString emptyString];
		} else {
			return NSStringEmptyPlaceholder;
		}
	}

	/* String must have an opening quote before we even use it. */
	id originalString = [stringValue mutableCopy];

	if ([[originalString string] hasPrefix:@"\""] == NO) {
		return nil;
	}

	/* Define base variables. */
	NSScanner *scanner = [NSScanner scannerWithString:[originalString string]];

	[scanner setCharactersToBeSkipped:nil]; // Do not skip anything.

	/* We do have a starting quote so we will now set the scanner
	 to that then have it set it it to destroy it from scanner. */
	[scanner scanUpToString:@"\"" intoString:NULL];
	[scanner scanString:@"\"" intoString:NULL];

	/* Now we will scan the rest of the string to the end. */
	while ([scanner isAtEnd] == NO) {
		[scanner scanUpToString:@"\"" intoString:NULL];

		/* End here. */
		if ([scanner scanLocation] == [stringValue length]) {
			return nil;
		}

		/* Scan location is now set at this quote. */
		NSUInteger scanLocation = [scanner scanLocation];

		/* Check the left side of the quote. */
		NSInteger slashCount = 0;

		/* Find all slashes left of this quote. */
		for (NSInteger i = (scanLocation - 1); i > 0; i--) {
			UniChar c = [[originalString string] characterAtIndex:i];

			if (c == '\\') {
				slashCount += 1;
			} else {
				break;
			}
		}

		BOOL slashesAreEven = (slashCount > 0 && ((slashCount % 2) == 0));

		/* If the quote is not escaped, then we either want
		 to be at the end of the string or only have a space
		 to our right side. Anything else invalidates group. */
		if (slashesAreEven || slashCount == 0) {
			NSUInteger charIndex = (scanLocation + 1);

			if ([originalString length] > charIndex) {
				UniChar rightChar = [[originalString string] characterAtIndex:charIndex];

				if (NSDissimilarObjects(rightChar, ' ')) {
					return nil;
				}
			}
		}

		/* Start calculations on escapes. */
		if (slashCount > 0) {
			if (slashesAreEven) {
				/* The slashes escape themselves left of this quote
				 so we do not have to do anything except continue on. */
			} else {
				/* Scan current quote and move forward. */
				if ([scanner isAtEnd]) {
					return nil;
				} else {
					[scanner setScanLocation:([scanner scanLocation] + 1)];
				}

				continue;
			}
		} /* End escape calculations. */

		/* Delete outside quotes. */
		[originalString deleteCharactersInRange:NSMakeRange(scanLocation, ([originalString length] - scanLocation))];
		[originalString deleteCharactersInRange:NSMakeRange(0, 1)];

		/* Now that we calculated escapes, we will now replace slash 
		 groups so that two slashes equal to one anywhere in the string. */
		NSInteger loopPosition = ([originalString length] - 1);

		BOOL isInSlashGroup = NO;
		BOOL lastCharWasQuote = NO;

		NSInteger slashGroupStart = -1;
		NSInteger slashGroupCount = -1;

		while (loopPosition > -1) {
			UniChar c = [[originalString string] characterAtIndex:loopPosition];

			if (c == '\\' && loopPosition > 0) {
				if (isInSlashGroup == NO) {
					isInSlashGroup = YES;

					slashGroupStart = loopPosition;
					slashGroupCount = 1;
				} else {
					slashGroupCount += 1;
				}
			}
			else if (NSDissimilarObjects(c, '\\') || (c == '\\' && loopPosition == 0))
			{
				/* Increase by one if we end at a \ */
				if (loopPosition == 0 && c == '\\') {
					if (isInSlashGroup == NO) {
						isInSlashGroup = YES;

						slashGroupStart = 0;
						slashGroupCount = 1;
					} else {
						slashGroupCount += 1;
					}
				}

				if (isInSlashGroup) {
					if (lastCharWasQuote && slashGroupCount == 1) {
						/* When a single slash escapes a quote, then we just delete that single
						 slash entirely. Any other character with a single slash, does not have
						 that slash erased as that character does not need escaping. */

						[originalString deleteCharactersInRange:NSMakeRange(slashGroupStart, 1)];
					} else {
						/* We are scanning backwards so the start is position minus length. */
						NSInteger actualStart = ((slashGroupStart - slashGroupCount) + 1);

						NSRange deleteRange = NSMakeRange(actualStart, slashGroupCount);

						/* Delete the existing slash group. */
						[originalString deleteCharactersInRange:deleteRange];

						/* Now, we build the replacement slashes. */
						NSMutableString *newSlashGroup = [NSMutableString string];

						/* How many slashes is the loop going to create? */
						NSInteger newCount = slashGroupCount;

						/* If previous char was a quote, then we have to minus one. */
						if (lastCharWasQuote) {
							newCount -= 1;
						}

						/* If the number of slashes is divisible by two, then it is a
						 matter of dividing them and replacing them with the divided value. */
						BOOL divisibleByTwo = ((slashGroupCount % 2) == 0);

						if (divisibleByTwo == NO) {
							/* We manually insert the extra when we can't divide. */
							newCount -= 1;

							[newSlashGroup appendString:@"\\"];
						}

						/* Updated math. */
						newCount = (newCount / 2);

						/* Create slash group. */
						for (NSInteger i = 0; i < newCount; i++) {
							[newSlashGroup appendString:@"\\"];
						}

						/* Insert the new group. */
						if (isAttributedString) {
							NSAttributedString *newGroup = [NSAttributedString emptyStringWithBase:newSlashGroup];

							[originalString insertAttributedString:newGroup atIndex:actualStart];
						} else {
							[originalString insertString:newSlashGroup atIndex:actualStart];
						}
					}

					isInSlashGroup = NO;

					slashGroupCount = -1;
					slashGroupStart = -1;
				}

				lastCharWasQuote = (c == '"');
			}

			/* Go down by one. */
			loopPosition -= 1;
		}

		/* We are done here. First we have to calculate the deletion range.
		 As the deletion range takes into account all whitespaces following
		 it so the next token starts at an actual character, we still have 
		 to scan forward from the starting location. For that, we will use
		 a simple for loop and compare characters. */
		if (quoteRange) {
			NSInteger stringLength = [stringValue length];
			NSInteger stringForward = ([scanner scanLocation] + 1);

			while (1 == 1) { // Infinite loops are safe! :-)
				NSAssertReturnLoopBreak(stringForward < stringLength);

				UniChar c = [[stringValue string] characterAtIndex:stringForward];

				if (c == ' ') {
					stringForward += 1;
				} else {
					break;
				}
			}

			*quoteRange = NSMakeRange(0, stringForward);
		}

		/* Build and return final tokenized string from range. */
		return originalString;
	} /* while loop. */
	
	return nil;
}

@end

#pragma mark -
#pragma mark String Number Formatter Helper

@implementation NSString (CSCEFStringNumberHelper)

+ (NSString *)stringWithChar:(char)value
{
 return [NSString stringWithFormat:@"%c", value];
}

+ (NSString *)stringWithUniChar:(UniChar)value
{
	return [NSString stringWithFormat:@"%C", value];
}

+ (NSString *)stringWithUnsignedChar:(unsigned char)value
{
	return [NSString stringWithFormat:@"%c", value];
}

+ (NSString *)stringWithShort:(short)value
{
	return [NSString stringWithFormat:@"%hi", value];
}

+ (NSString *)stringWithUnsignedShort:(unsigned short)value
{
	return [NSString stringWithFormat:@"%hu", value];
}

+ (NSString *)stringWithInt:(int)value
{
	return [NSString stringWithFormat:@"%i", value];
}

+ (NSString *)stringWithInteger:(NSInteger)value
{
	return [NSString stringWithFormat:@"%ld", value];
}

+ (NSString *)stringWithUnsignedInt:(unsigned int)value
{
	return [NSString stringWithFormat:@"%u", value];
}

+ (NSString *)stringWithUnsignedInteger:(NSUInteger)value
{
	return [NSString stringWithFormat:@"%lu", value];
}

+ (NSString *)stringWithLong:(long)value
{
	return [NSString stringWithFormat:@"%ld", value];
}

+ (NSString *)stringWithUnsignedLong:(unsigned long)value
{
	return [NSString stringWithFormat:@"%lu", value];
}

+ (NSString *)stringWithLongLong:(long long)value
{
	return [NSString stringWithFormat:@"%qi", value];
}

+ (NSString *)stringWithUnsignedLongLong:(unsigned long long)value
{
	return [NSString stringWithFormat:@"%qu", value];
}

+ (NSString *)stringWithFloat:(float)value
{
	return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)stringWithDouble:(double)value
{
	return [NSString stringWithFormat:@"%f", value];
}

@end

#pragma mark -
#pragma mark Mutable String Helper

@implementation NSMutableString (NSMutableStringHelper)

- (NSString *)getTokenIncludingQuotes
{
	NSRange deletionRange = NSEmptyRange();

	NSString *quotedGroup = [NSString getTokenFromFirstQuoteGroup:self returnedDeletionRange:&deletionRange];

	if (quotedGroup == nil) {
		return [self getToken];
	} else {
		if ((deletionRange.location == NSNotFound) == NO) {
			[self deleteCharactersInRange:deletionRange];
		}

		return quotedGroup;
	}
}

- (NSString *)getToken
{
	NSRange deletionRange = NSEmptyRange();

	NSString *token = [NSString getTokenFromFirstWhitespaceGroup:self returnedDeletionRange:&deletionRange];

	if (token == nil) {
		return NSStringEmptyPlaceholder;
	} else {
		if ((deletionRange.location == NSNotFound) == NO) {
			[self deleteCharactersInRange:deletionRange];
		}

		return token;
	}
}

- (NSString *)uppercaseGetToken
{
	return [[self getToken] uppercaseString];
}

@end

#pragma mark -
#pragma mark Attributed String Helper

@implementation NSAttributedString (NSAttributedStringHelper)

+ (NSAttributedString *)emptyString
{
    return [NSAttributedString emptyStringWithBase:NSStringEmptyPlaceholder];
}

+ (NSAttributedString *)emptyStringWithBase:(NSString *)base
{
	return [[NSAttributedString alloc] initWithString:base];
}

+ (NSAttributedString *)stringWithBase:(NSString *)base attributes:(NSDictionary *)baseAttributes
{
	return [[NSAttributedString alloc] initWithString:base attributes:baseAttributes];
}

- (NSDictionary *)attributes
{
	return [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, [self length])];
}

- (NSAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set
{
	return [self attributedStringByTrimmingCharactersInSet:set frontChop:NULL];
}

- (NSAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set frontChop:(NSRangePointer)front
{
	NSString *baseString = [self string];
	
	NSRange range;
	
	NSUInteger locati = 0;
	NSUInteger length = 0;
	
	NSCharacterSet *invertedSet = [set invertedSet];
	
	range = [baseString rangeOfCharacterFromSet:invertedSet];

	if (range.length >= 1) {
		locati = range.location;
	} else {
		locati = 0;
	}
	
	if ((front == nil) == NO) {
		*front = range;
	}
	
	range = [baseString rangeOfCharacterFromSet:invertedSet options:NSBackwardsSearch];

	if (range.length >= 1) {
		length = (NSMaxRange(range) - locati);
	} else {
		length = ([baseString length] - locati);
	}
	
	return [self attributedSubstringFromRange:NSMakeRange(locati, length)];
}

- (NSArray *)splitIntoLines
{
    NSMutableArray *lines = [NSMutableArray array];
    
    NSInteger stringLength = [self length];
    NSInteger rangeStartIn = 0;
    
    NSMutableAttributedString *copyd = [self mutableCopy];
    
    while (rangeStartIn < stringLength) {
		NSRange srb = NSMakeRange(rangeStartIn, (stringLength - rangeStartIn));
     
		NSRange srr = [[self string] rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:srb];
        
        if (srr.location == NSNotFound) {
            break;
        }
        
        NSRange delRange = NSMakeRange(0, ((srr.location - rangeStartIn) + 1));
        NSRange cutRange = NSMakeRange(rangeStartIn, (srr.location - rangeStartIn));
        
        NSAttributedString *line = [self attributedSubstringFromRange:cutRange];
        
		if (line) {
			[lines addObject:line];
		}
		
        [copyd deleteCharactersInRange:delRange];
        
        rangeStartIn = NSMaxRange(srr);
    }
    
	if ([lines count] == 0) {
        [lines addObject:self];
    } else {
        if ([copyd length] > 0) {
			[lines addObject:copyd];
        }
    }
    
    return lines;
}

#ifdef COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight
{
	return [self wrappedLineCount:boundWidth lineMultiplier:lineHeight forcedFont:nil];
}

- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight forcedFont:(NSFont *)textFont
{	
	CGFloat boundHeight = [self pixelHeightInWidth:boundWidth forcedFont:textFont];

	return (boundHeight / lineHeight);
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width
{
	return [self pixelHeightInWidth:width forcedFont:nil];
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width forcedFont:(NSFont *)font
{
	NSMutableAttributedString *baseMutable = [self mutableCopy];
	
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	
	[paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
	
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:paragraphStyle, NSParagraphStyleAttributeName, nil];

	if (font == nil) {
		attributes[NSFontAttributeName] = font;
	}

	[baseMutable setAttributes:attributes range:NSMakeRange(0, [baseMutable length])];

	NSRect bounds = [baseMutable boundingRectWithSize:NSMakeSize(width, 0.0)
											  options:NSStringDrawingUsesLineFragmentOrigin];
	
	return NSHeight(bounds);
}
#endif

@end

#pragma mark -
#pragma mark Mutable Attributed String Helper

@implementation NSMutableAttributedString (NSMutableAttributedStringHelper)

+ (NSMutableAttributedString *)mutableStringWithBase:(NSString *)base attributes:(NSDictionary *)baseAttributes
{
	return [[NSMutableAttributedString alloc] initWithString:base attributes:baseAttributes];
}

- (NSString *)getTokenAsString
{
	return [[self getToken] string];
}

- (NSString *)uppercaseGetToken
{
	return [[self getTokenAsString] uppercaseString];
}

- (NSString *)trimmedString
{
	return [[self string] trim];
}

- (NSAttributedString *)getToken
{
	NSRange deletionRange = NSEmptyRange();

	NSAttributedString *token = [NSString getTokenFromFirstWhitespaceGroup:self returnedDeletionRange:&deletionRange];

	if (token == nil) {
		return [NSAttributedString emptyString];
	} else {
		if ((deletionRange.location == NSNotFound) == NO) {
			[self deleteCharactersInRange:deletionRange];
		}

		return token;
	}
}

- (NSAttributedString *)getTokenIncludingQuotes
{
	NSRange deletionRange = NSEmptyRange();

	NSAttributedString *quotedGroup = [NSString getTokenFromFirstQuoteGroup:self returnedDeletionRange:&deletionRange];

	if (quotedGroup == nil) {
		return [self getToken];
	} else {
		if ((deletionRange.location == NSNotFound) == NO) {
			[self deleteCharactersInRange:deletionRange];
		}

		return quotedGroup;
	}
}

@end
