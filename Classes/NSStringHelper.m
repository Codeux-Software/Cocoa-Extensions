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
#import "CGContextHelper.h"

#import <CommonCrypto/CommonDigest.h>

#import <WebKit/WebKit.h>

#include <arpa/inet.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const NSStringEmptyPlaceholder = @"";
NSString * const NSStringNewlinePlaceholder = @"\x0a";
NSString * const NSStringWhitespacePlaceholder = @"\x20";

NSString * const CS_AtoZUnderscoreDashCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_";
NSString * const CS_UnicodeReplacementCharacter = @"�";

@interface NSString (CSStringHelperPrivate)
+ (nullable id)getTokenFromFirstQuoteGroup:(nullable id)stringValue returnedDeletionRange:(NSRange * _Nullable)quoteRange;
+ (nullable id)getTokenFromFirstWhitespaceGroup:(nullable id)stringValue returnedDeletionRange:(NSRange * _Nullable)whitespaceRange;
@end

@implementation NSString (CStringHelper)

+ (nullable instancetype)stringWithBytes:(const void *)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding
{
	return [[NSString alloc] initWithBytes:bytes length:length encoding:encoding];
}

+ (nullable instancetype)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
	return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSRange)range
{
	return NSMakeRange(0, [self length]);
}

+ (NSString *)stringWithUUID
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	
	NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
	
	CFRelease(uuidObj);

	return uuidString;
}

+ (nullable NSString *)charsetRepFromStringEncoding:(NSStringEncoding)encoding
{
	CFStringEncoding foundationEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);

	CFStringRef charsetString = CFStringConvertEncodingToIANACharSetName(foundationEncoding);

	if (charsetString) {
		return (__bridge NSString *)(charsetString);
	} else {
		return nil;
	}
}

+ (NSDictionary<NSString *, NSNumber *> *)supportedStringEncodingsWithTitle:(BOOL)favorUTF8
{
    NSMutableDictionary<NSString *, NSNumber *> *encodingList = [NSMutableDictionary dictionary];

    NSArray *supportedEncodings = [NSString supportedStringEncodings:favorUTF8];

    for (NSNumber *encoding in supportedEncodings) {
        NSString *encodingTitle = [NSString localizedNameOfStringEncoding:[encoding unsignedIntegerValue]];

		if (encodingTitle) {
			encodingList[encodingTitle] = encoding;
		}
    }

    return encodingList;
}

+ (NSArray<NSNumber *> *)supportedStringEncodings:(BOOL)favorUTF8
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
	UniChar strChar = [self characterAtIndex:anIndex];

	return [[NSString alloc] initWithCharacters:&strChar length:1];
}

- (NSString *)substringAfterIndex:(NSUInteger)anIndex
{
	return [self substringFromIndex:(anIndex + 1)];
}

- (NSString *)substringBeforeIndex:(NSUInteger)anIndex
{
	return [self substringFromIndex:(anIndex - 1)];
}

- (BOOL)isEqualIgnoringCase:(NSString *)other
{
	return ([self caseInsensitiveCompare:other] == NSOrderedSame);
}

- (BOOL)contains:(NSString *)string
{
	return ([self stringPosition:string] >= 0);
}

- (BOOL)containsIgnoringCase:(NSString *)string
{
	return ([self stringPositionIgnoringCase:string] >= 0);
}

- (NSArray<NSString *> *)characterStringBuffer
{
	NSMutableArray *buffer = [NSMutableArray arrayWithCapacity:[self length]];

	for (NSUInteger i = 0; i < [self length]; i++) {
		NSString *character = [self stringCharacterAtIndex:i];

		[buffer addObject:character];
	}

	return [buffer copy];
}

- (nullable NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

	NSParameterAssert(data != nil);

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
	
    NSMutableString *output = [NSMutableString stringWithCapacity:(CC_SHA1_DIGEST_LENGTH * 2)];
	
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
	
    return output;
}

- (nullable NSString *)sha256
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

	NSParameterAssert(data != nil);

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256([data bytes], (CC_LONG)[data length], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:(CC_SHA256_DIGEST_LENGTH * 2)];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (nullable NSString *)md5
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

- (NSArray<NSString *> *)split:(NSString *)delimiter
{
	return [self componentsSeparatedByString:delimiter];
}

- (NSArray<NSString *> *)splitWithMaximumLength:(NSUInteger)maximumLength
{
	NSParameterAssert(maximumLength > 0);

	NSUInteger stringLength = [self length];

	if (stringLength <= maximumLength) {
		return @[self];
	}

	NSMutableArray<NSString *> *splitStrings = [NSMutableArray array];

	NSUInteger processedLength = 0;

	while (processedLength < stringLength) {
		NSUInteger remainingLength = (stringLength - processedLength);

		if (remainingLength > maximumLength) {
			remainingLength = maximumLength;
		}

		NSString *line = [self substringWithRange:NSMakeRange(processedLength, remainingLength)];

		[splitStrings addObject:line];

		processedLength += remainingLength;
	}

	return [splitStrings copy];
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimNewlines
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)trimCharacters:(NSString *)characters
{
	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];

	return [self stringByTrimmingCharactersInSet:characterSet];
}

- (NSString *)removeAllNewlines
{
	return [self stringByReplacingOccurrencesOfCharacterSet:[NSCharacterSet newlineCharacterSet] withString:NSStringEmptyPlaceholder];
}

- (NSString *)stringByReplacingOccurrencesOfCharacterSet:(NSCharacterSet *)target withString:(NSString *)replacement
{
	NSParameterAssert(target != nil);

	NSMutableString *newString = [NSMutableString string];

	for (NSUInteger i = 0; i < [self length]; i++) {
		UniChar c = [self characterAtIndex:i];

		if ([target characterIsMember:c]) {
			if (replacement && [replacement length] > 0) {
				[newString appendString:replacement];
			}
		} else {
			[newString appendFormat:@"%C", c];
		}
	}

	return newString;
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

- (BOOL)hasPrefixWithCharacterSet:(NSCharacterSet *)characterSet
{
	NSRange prefixRange = [self rangeOfCharacterFromSet:characterSet options:NSAnchoredSearch];

	return (prefixRange.location == 0 && prefixRange.length > 0);
}

- (BOOL)hasSuffixWithCharacterSet:(NSCharacterSet *)characterSet
{
	NSRange suffixRange = [self rangeOfCharacterFromSet:characterSet options:(NSAnchoredSearch | NSBackwardsSearch)];

	return ((suffixRange.length + suffixRange.location) == [self length]);
}

- (CGFloat)compareWithWord:(NSString *)stringB lengthPenaltyWeight:(CGFloat)weight
{
	if (stringB == nil || [stringB length] == 0) {
		return 0.0;
	}

	if ([stringB length] > [self length]) {
		return 0.0;
	}

	NSString *_stringA = [self lowercaseString];

	NSString *_stringB = [stringB lowercaseString];

	NSInteger commonCharacterCount = 0;

	NSInteger startPosition = 0;

	CGFloat distancePenalty = 0;

	for (NSInteger i = 0; i < [_stringB length]; i++) {
		BOOL matchFound = NO;

		for (NSInteger j = startPosition; j < [_stringA length]; j++) {
			if ([_stringB characterAtIndex:i] != [_stringA characterAtIndex:j]) {
				continue;
			}

			NSInteger distance = (j - startPosition);

			if (distance > 0) {
				distancePenalty += ((distance - 1.0) / distance);
			}

			commonCharacterCount++;

			startPosition = (j + 1);

			matchFound = YES;

			break;
		}

		if (matchFound == NO) {
			return 0.0;
		}
	}

	CGFloat lengthPenalty = (1.0 - (CGFloat)[_stringB length] / [_stringA length]);

	return (commonCharacterCount - distancePenalty - weight*lengthPenalty);
}

- (NSInteger)stringPosition:(NSString *)needle
{
	NSRange searchResult = [self rangeOfString:needle];
	
	if (searchResult.location == NSNotFound) {
		return (-1);
	}
	
	return searchResult.location;
}

- (NSInteger)stringPositionIgnoringCase:(NSString *)needle
{
	NSRange searchResult = [self rangeOfString:needle options:NSCaseInsensitiveSearch];

	if (searchResult.location == NSNotFound) {
		return (-1);
	}

	return searchResult.location;
}

- (void)enumerateMatchesOfString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock
{
	[self enumerateMatchesOfString:string withBlock:enumerationBlock options:0];
}

- (void)enumerateMatchesOfString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock options:(NSStringCompareOptions)options
{
	NSParameterAssert(string != nil);
	NSParameterAssert(enumerationBlock != nil);

	BOOL searchBackwards = ((options & NSBackwardsSearch) == NSBackwardsSearch);

	NSUInteger searchLength = self.length;

	NSUInteger currentPosition = 0;

	while ((searchBackwards == NO && currentPosition < searchLength) ||
		   (searchBackwards && searchLength > 0))
	{
		NSRange range = [self rangeOfString:string
									options:options
									  range:NSMakeRange(currentPosition, (searchLength - currentPosition))];

		if (range.location == NSNotFound) {
			break;
		}

		BOOL stop = NO;

		enumerationBlock(range, &stop);

		if (stop) {
			break;
		}

		if (searchBackwards) {
			searchLength = range.location;
		} else {
			currentPosition = NSMaxRange(range);
		}
	}
}

- (void)enumerateFirstOccurrenceOfCharactersInString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock
{
	[self enumerateFirstOccurrenceOfCharactersInString:string withBlock:enumerationBlock options:0];
}

- (void)enumerateFirstOccurrenceOfCharactersInString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock options:(NSStringCompareOptions)options
{
	NSParameterAssert(string != nil);
	NSParameterAssert(enumerationBlock != nil);

	BOOL searchBackwards = ((options & NSBackwardsSearch) == NSBackwardsSearch);

	NSUInteger searchLength = self.length;

	NSUInteger currentPosition = 0;

	NSArray *stringCharacters = [string characterStringBuffer];

	for (NSString *stringCharacter in stringCharacters) {
		NSRange range = [self rangeOfString:stringCharacter
									options:options
									  range:NSMakeRange(currentPosition, (searchLength - currentPosition))];

		if (range.location == NSNotFound) {
			break;
		}

		BOOL stop = NO;

		enumerationBlock(range, &stop);

		if (stop) {
			break;
		}

		if (searchBackwards) {
			searchLength = range.location;
		} else {
			currentPosition = NSMaxRange(range);
		}
	}
}

- (NSString *)stringByDeletingPreifx:(NSString *)prefix
{
	if ([self hasPrefix:prefix]) {
		return [self substringFromIndex:[prefix length]];
	}
	
	return self;
}

- (BOOL)isIPAddress
{
	return ([self isIPv4Address] || [self isIPv6Address]);
}

- (BOOL)isIPv4Address
{
	return ([self IPv4AddressBytes] != nil);
}

- (BOOL)isIPv6Address
{
	return ([self IPv6AddressBytes] != nil);
}

- (nullable NSData *)IPv4AddressBytes
{
	struct sockaddr_in sa;

	int result = inet_pton(AF_INET, [self UTF8String], &(sa.sin_addr));

	if (result == 1) {
		return [NSData dataWithBytes:&(sa.sin_addr.s_addr) length:4];
	} else {
		return nil;
	}
}

- (nullable NSData *)IPv6AddressBytes
{
	struct sockaddr_in6 sa;

	int result = inet_pton(AF_INET6, [self UTF8String], &(sa.sin6_addr));

	if (result == 1) {
		return [NSData dataWithBytes:&(sa.sin6_addr) length:16];
	} else {
		return nil;
	}
}

- (NSString *)trimAndGetFirstToken
{
	NSString *bob = [self trim];

	NSString *firstToken = [NSString getTokenFromFirstWhitespaceGroup:bob returnedDeletionRange:NULL];

	return firstToken;
}

- (NSString *)safeFilename
{
	NSString *bob = [self trim];

	bob = [bob stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	bob = [bob stringByReplacingOccurrencesOfString:@":" withString:@"_"];

	return bob;
}

- (NSUInteger)occurrencesOfCharacter:(UniChar)character
{
	NSUInteger characterCount = 0;

	for (NSUInteger i = 0; i < [self length]; ++i) {
		UniChar c = [self characterAtIndex:i];

		if (c == character) {
			characterCount += 1;
		}
	}

	return characterCount;
}

- (BOOL)isNumericOnly
{
	if ([self length] == 0) {
		return NO;
	}

	for (NSUInteger i = 0; i < [self length]; ++i) {
		UniChar c = [self characterAtIndex:i];
		
		if (CS_StringIsBase10Numeric(c) == NO) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)isAlphabeticNumericOnly
{
	if ([self length] == 0) {
		return NO;
	}

	for (NSUInteger i = 0; i < [self length]; ++i) {
		UniChar c = [self characterAtIndex:i];
		
		if (CS_StringIsAlphabeticNumeric(c) == NO) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)containsCharactersFromCharacterSet:(NSCharacterSet *)characterSet
{
	NSParameterAssert(characterSet != nil);

	NSRange searchRange = [self rangeOfCharacterFromSet:characterSet];

	return (searchRange.location != NSNotFound);
}

- (BOOL)onlyContainsCharactersFromCharacterSet:(NSCharacterSet *)characterSet
{
	NSParameterAssert(characterSet != nil);

	NSRange searchRange = [self rangeOfCharacterFromSet:characterSet];

	return (searchRange.location == NSNotFound);
}

- (BOOL)containsCharacters:(NSString *)characters
{
	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];

	return [self containsCharactersFromCharacterSet:characterSet];
}

- (BOOL)onlyContainsCharacters:(NSString *)characters
{
	NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:characters] invertedSet];

	return [self onlyContainsCharactersFromCharacterSet:characterSet];
}

- (NSString *)stringByDeletingAllCharactersInSet:(NSString *)characters deleteThoseNotInSet:(BOOL)onlyDeleteThoseNotInSet
{
	NSParameterAssert(characters != nil);
	
	NSMutableString *result = [NSMutableString string];

	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];
	
	NSScanner *scanner = [NSScanner scannerWithString:self];
	
	while ([scanner isAtEnd] == NO) {
		NSString *buffer;
		
		if (onlyDeleteThoseNotInSet) {
			if ([scanner scanCharactersFromSet:characterSet intoString:&buffer]) {
				[result appendString:buffer];
			} else {
				[scanner setScanLocation:([scanner scanLocation] + 1)];
			}
		} else {
			if ([scanner scanCharactersFromSet:characterSet intoString:&buffer]) {
				[scanner setScanLocation:([scanner scanLocation] + 1)];
			} else {
				[result appendString:buffer];
			}
		}
	}
	
	return result;
}

- (NSString *)stringByDeletingAllCharactersInSet:(NSString *)characters
{
	return [self stringByDeletingAllCharactersInSet:characters deleteThoseNotInSet:NO];
}

- (NSString *)stringByDeletingAllCharactersNotInSet:(NSString *)characters
{
	return [self stringByDeletingAllCharactersInSet:characters deleteThoseNotInSet:YES];
}

- (NSRange)rangeOfNextSegmentMatchingRegularExpression:(NSString *)regex startingAt:(NSUInteger)start
{
	NSParameterAssert(regex != nil);

	NSRange emptyRange = NSEmptyRange();

	NSUInteger stringLength = [self length];

	if (stringLength <= start) {
		return emptyRange;
	}
	
	NSString *searchString = [self substringFromIndex:start];
	
	NSRange searchRange = [XRRegularExpression string:searchString rangeOfRegex:regex];

	if (searchRange.location == NSNotFound) {
		return emptyRange;
	}

	emptyRange.location = (start + searchRange.location);
	emptyRange.length = searchRange.length;

	return emptyRange;
}

- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight withFont:(NSFont *)textFont
{
	CGFloat boundHeight = [self pixelHeightInWidth:boundWidth withFont:textFont];
	
	return (boundHeight / lineHeight);
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width withFont:(nullable NSFont *)textFont
{
	return [self pixelHeightInWidth:width withFont:textFont lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width withFont:(nullable NSFont *)textFont lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	NSAttributedString *base = [NSAttributedString attributedStringWithString:self];

	return [base pixelHeightInWidth:width lineBreakMode:lineBreakMode withFont:textFont];
}

- (NSString *)scannerString
{
	return self;
}

+ (nullable id)getTokenFromFirstWhitespaceGroup:(nullable id)stringValue returnedDeletionRange:(NSRange * _Nullable)whitespaceRange
{
	/* Check the input. */
	if (stringValue == nil || [stringValue length] == 0) {
		return nil;
	}

	/* What type of string are we processing? */
	BOOL isAttributedString = ([stringValue isKindOfClass:[NSAttributedString class]]);

	/* Define base variables. */
	NSScanner *scanner = [NSScanner scannerWithString:[stringValue scannerString]];

	[scanner setCharactersToBeSkipped:nil]; // Do not skip anything.

	/* Scan up to first space. */
	[scanner scanUpToString:@" " intoString:NULL];

	NSUInteger scanLocation = [scanner scanLocation];

	/* We now scan from the scan location to the end of whitespaces. */
	if (whitespaceRange) {
		NSUInteger stringLength = [stringValue length];

		NSUInteger stringForward = scanLocation;

		while (stringForward < stringLength) {
			UniChar c = [[stringValue scannerString] characterAtIndex:stringForward];

			if (c == ' ') {
				stringForward += 1;
			} else {
				break;
			}
		}

		*whitespaceRange = NSMakeRange(0, stringForward);
	}

	/* Build and return final tokenized string from range. */
	id resultString = nil;

	if (isAttributedString) {
		resultString = [stringValue attributedSubstringFromRange:NSMakeRange(0, scanLocation)];
	} else {
		resultString = [stringValue substringToIndex:scanLocation];
	}

	return resultString;
}

+ (nullable id)getTokenFromFirstQuoteGroup:(nullable id)stringValue returnedDeletionRange:(NSRange * _Nullable)quoteRange
{
	/* Check the input. */
	if (stringValue == nil || [stringValue length] == 0) {
		return nil;
	}

	/* What type of string are we processing? */
	BOOL isAttributedString = ([stringValue isKindOfClass:[NSAttributedString class]]);

	/* String must have an opening quote before we even use it. */
	if ([[stringValue scannerString] hasPrefix:@"\""] == NO) {
		return nil;
	}

	id originalString = [stringValue mutableCopy];

	/* Define base variables. */
	NSScanner *scanner = [NSScanner scannerWithString:[originalString scannerString]];

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
		for (NSUInteger i = (scanLocation - 1); i > 0; i--) {
			UniChar c = [[originalString scannerString] characterAtIndex:i];

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
				UniChar rightChar = [[originalString scannerString] characterAtIndex:charIndex];

				if (rightChar != ' ') {
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
			UniChar c = [[originalString scannerString] characterAtIndex:loopPosition];

			if (c == '\\' && loopPosition > 0) {
				if (isInSlashGroup == NO) {
					isInSlashGroup = YES;

					slashGroupStart = loopPosition;
					slashGroupCount = 1;
				} else {
					slashGroupCount += 1;
				}
			}
			else if (c != '\\' || (c == '\\' && loopPosition == 0))
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
							NSAttributedString *newGroup = [NSAttributedString attributedStringWithString:newSlashGroup];

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
			NSUInteger stringLength = [stringValue length];

			NSUInteger stringForward = ([scanner scanLocation] + 1);

			while (stringForward < stringLength) {
				UniChar c = [[stringValue scannerString] characterAtIndex:stringForward];

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

- (nullable NSURL *)URLUsingWebKitPasteboard
{
	NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];

	[pasteboard setStringContent:self];

	NSURL *u = [WebView URLFromPasteboard:pasteboard];

	if (u == nil) {
		u = [NSURL URLWithString:self];
	}

	[pasteboard releaseGlobally];

	return u;
}

- (NSDictionary<NSString *, NSString *> *)URLQueryItems
{
	NSMutableDictionary<NSString *, NSString *> *queryItems = [NSMutableDictionary dictionary];

	NSArray *components = [self componentsSeparatedByString:@"&"];

	for (NSString *component in components) {
		if (component.length == 0) {
			continue;
		}

		NSInteger equalSignPosition = [component stringPosition:@"="];

		if (equalSignPosition < 0) { // not found
			queryItems[component] = NSStringEmptyPlaceholder;
		} else {
			NSString *name = [component substringToIndex:equalSignPosition];
			NSString *value = [component substringAfterIndex:equalSignPosition];

			queryItems[name] = value.percentDecodedString;
		}
	}

	return [queryItems copy];
}

@end

#pragma mark -
#pragma mark String Percent Encoding Helper

@implementation NSString (CSStringPercentEncodingHelper)

- (nullable NSString *)percentEncodedStringWithAllowedCharacters:(NSString *)allowedCharacters
{
	if ([XRSystemInformation isUsingOSXMavericksOrLater]) {
		NSCharacterSet *characterSet =
		[NSCharacterSet characterSetWithCharactersInString:allowedCharacters];

		return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
	} else {
		CFStringRef encodedRef =
		CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
												(CFStringRef)self,
												(CFStringRef)allowedCharacters,
												(CFStringRef)@"!#$%&'()*+,/:;=?@[]",
												kCFStringEncodingUTF8);

		if (encodedRef) {
			return (__bridge_transfer NSString *)encodedRef;
		} else {
			return nil;
		}
	}
}

- (nullable NSString *)percentDecodedString
{
	if ([XRSystemInformation isUsingOSXMavericksOrLater]) {
		return [self stringByRemovingPercentEncoding];
	} else {
		return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
}

- (nullable NSString *)percentEncodedString
{
	static NSString *allowedCharacters = @"-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

- (nullable NSString *)percentEncodedURLUser
{
	static NSString *allowedCharacters = @"!$&'()*+,-.0123456789;=ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

- (nullable NSString *)percentEncodedURLPassword
{
	static NSString *allowedCharacters = @"!$&'()*+,-.0123456789;=ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

- (nullable NSString *)percentEncodedURLHost
{
	static NSString *allowedCharacters = @"!$&'()*+,-.0123456789:;=ABCDEFGHIJKLMNOPQRSTUVWXYZ[]_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

- (nullable NSString *)percentEncodedURLPath
{
	static NSString *allowedCharacters = @"!$&'()*+,-./0123456789:=@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

- (nullable NSString *)percentEncodedURLQuery
{
	static NSString *allowedCharacters = @"!$&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

- (nullable NSString *)percentEncodedURLFragment
{
	static NSString *allowedCharacters = @"!$&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

	return [self percentEncodedStringWithAllowedCharacters:allowedCharacters];
}

@end

#pragma mark -
#pragma mark String Number Formatter Helper

@implementation NSString (CSStringNumberHelper)

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
	}

	if (deletionRange.location != NSNotFound) {
		[self deleteCharactersInRange:deletionRange];
	}

	return quotedGroup;
}

- (NSString *)getToken
{
	NSRange deletionRange = NSEmptyRange();

	NSString *token = [NSString getTokenFromFirstWhitespaceGroup:self returnedDeletionRange:&deletionRange];

	if (token == nil) {
		return NSStringEmptyPlaceholder;
	}

	if (deletionRange.location != NSNotFound) {
		[self deleteCharactersInRange:deletionRange];
	}

	return token;
}

- (NSString *)lowercaseGetToken
{
	return [[self getToken] lowercaseString];
}

- (NSString *)uppercaseGetToken
{
	return [[self getToken] uppercaseString];
}

@end

#pragma mark -
#pragma mark Attributed String Helper

@implementation NSAttributedString (NSAttributedStringHelper)

+ (NSAttributedString *)attributedString
{
	return [NSAttributedString attributedStringWithString:NSStringEmptyPlaceholder];
}

+ (NSAttributedString *)attributedStringWithString:(NSString *)string
{
	return [[NSAttributedString alloc] initWithString:string];
}

+ (NSAttributedString *)attributedStringWithString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)stringAttributes
{
	return [[NSAttributedString alloc] initWithString:string attributes:stringAttributes];
}

- (NSDictionary<NSString *, id> *)attributes
{
	return [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, [self length])];
}

- (NSAttributedString *)attributedSubstringFromIndex:(NSUInteger)from
{
	NSRange range = NSMakeRange(from, ([self length] - from));

	return [self attributedSubstringFromRange:range];
}

- (NSAttributedString *)attributedSubstringToIndex:(NSUInteger)to
{
	NSRange range = NSMakeRange(0, ([self length] - to));

	return [self attributedSubstringFromRange:range];
}

- (NSRange)range
{
	return NSMakeRange(0, [self length]);
}

- (NSString *)scannerString
{
	return [self string];
}

- (NSArray<NSAttributedString *> *)splitIntoLines
{
    NSMutableArray<NSAttributedString *> *lines = [NSMutableArray array];
    
    NSUInteger stringLength = [self length];

    NSUInteger rangeStartIn = 0;
    
    NSMutableAttributedString *mutableSelf = [self mutableCopy];
    
    while (rangeStartIn < stringLength) {
		NSRange searchRange = NSMakeRange(rangeStartIn, (stringLength - rangeStartIn));
     
		NSRange lineRange = [[self string] rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:searchRange];
        
        if (lineRange.location == NSNotFound) {
            break;
        }
        
        NSRange rangeToDelete = NSMakeRange(0, ((lineRange.location - rangeStartIn) + 1));

		NSRange rangeToSubstring = NSMakeRange(rangeStartIn, (lineRange.location - rangeStartIn));
        
        NSAttributedString *line = [self attributedSubstringFromRange:rangeToSubstring];
        
		if (line) {
			[lines addObject:line];
		}
		
        [mutableSelf deleteCharactersInRange:rangeToDelete];

        rangeStartIn = NSMaxRange(lineRange);
    }
    
	if ([lines count] == 0) {
        [lines addObject:self];
    } else {
        if ([mutableSelf length] > 0) {
			[lines addObject:mutableSelf];
        }
    }
    
    return lines;
}

- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight
{
	return [self wrappedLineCount:boundWidth lineMultiplier:lineHeight withFont:nil];
}

- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight withFont:(nullable NSFont *)textFont
{	
	CGFloat boundHeight = [self pixelHeightInWidth:boundWidth lineBreakMode:NSLineBreakByWordWrapping withFont:textFont];

	return (boundHeight / lineHeight);
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width
{
	return [self pixelHeightInWidth:width lineBreakMode:NSLineBreakByWordWrapping withFont:nil];
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	return [self pixelHeightInWidth:width lineBreakMode:lineBreakMode withFont:nil];
}

- (CGFloat)pixelHeightInWidth:(NSUInteger)width lineBreakMode:(NSLineBreakMode)lineBreakMode withFont:(nullable NSFont *)textFont
{
	NSMutableAttributedString *baseMutable = [self mutableCopy];

	NSRange baseMutableRange = NSMakeRange(0, [baseMutable length]);

	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	
	[paragraphStyle setLineBreakMode:lineBreakMode];

	if (textFont) {
		[baseMutable addAttribute:NSFontAttributeName value:textFont range:baseMutableRange];
	}

	[baseMutable addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:baseMutableRange];

	NSRect bounds = [baseMutable boundingRectWithSize:NSMakeSize(width, 0.0)
											  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)];

	return NSHeight(bounds);
}

- (nullable NSImage *)imageRepWithSize:(NSSize)originalSize scaleFactor:(CGFloat)scaleFactor backgroundColor:(NSColor *)backgroundColor
{
	return [self imageRepWithSize:originalSize scaleFactor:scaleFactor backgroundColor:backgroundColor coreTextFrameOffset:NULL];
}

- (nullable NSImage *)imageRepWithSize:(NSSize)originalSize scaleFactor:(CGFloat)scaleFactor backgroundColor:(NSColor *)backgroundColor coreTextFrameOffset:(CGFloat *)coreTextFrameOffset
{
	/* Perform basic validation on the current state of the
	 string and the values of hte supplied paramaters. */
	if ([XRSystemInformation isUsingOSXYosemiteOrLater] == NO) {
		return nil;
	}

	if ([self length] <= 0) {
		return nil;
	}

	if (originalSize.width <= 0 || originalSize.height <= 0) {
		return nil;
	}

	if (ABS(scaleFactor) <= 0) {
		return nil;
	}

	if (backgroundColor == nil) {
		return nil;
	}

	/* Begin by building a context for the drawing process using
	 some very magic numbers. */
	CGFloat cellFrameWidth = originalSize.width;
	CGFloat cellFrameHeight = originalSize.height;

	CGFloat cellFrameWidthScaled = (cellFrameWidth * scaleFactor);
	CGFloat cellFrameHeightScaled = (cellFrameHeight * scaleFactor);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	NSUInteger bytesPerPixel = 4;
	NSUInteger bytesPerRow = (bytesPerPixel * cellFrameWidthScaled);

	NSUInteger bitsPerComponent = 8;

	CGBitmapInfo bitmapInfo = (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);

	CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
									cellFrameWidthScaled,
									cellFrameHeightScaled,
									bitsPerComponent,
									bytesPerRow,
									colorSpace,
									bitmapInfo);

	/* Create an AppKit graphics context using the newly created
	 core graphic's context and set it as the current context. */
	[NSGraphicsContext saveGraphicsState];

	NSGraphicsContext *bitmapContextAppKitContext = nil;

	if ([XRSystemInformation isUsingOSXYosemiteOrLater]) {
		bitmapContextAppKitContext =
		[NSGraphicsContext graphicsContextWithCGContext:bitmapContext flipped:NO];
	} else {
		bitmapContextAppKitContext =
		[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO];
	}

	[NSGraphicsContext setCurrentContext:bitmapContextAppKitContext];

	/* Prepare string to draw by first advertising we want font smoothing */
	CGContextSetShouldAntialias(bitmapContext, true);
	CGContextSetShouldSmoothFonts(bitmapContext, true);
	CGContextSetShouldSubpixelPositionFonts(bitmapContext, true);
	CGContextSetShouldSubpixelQuantizeFonts(bitmapContext, true);

	CGContextSetFontSmoothingBackgroundColorPrivate(bitmapContext, [backgroundColor CGColor]);

	/* Set the scale factor for retina displays */
	CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);

	/* Set other values for drawing */
	CGContextSetTextMatrix(bitmapContext, CGAffineTransformIdentity);

	/* Define the path that the text will be drawn in */
	CTFramesetterRef coreTextFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);

	CGMutablePathRef graphicsPath = CGPathCreateMutable();

	/* Even though the client specifies the height, core text 
	 still draws into the frame that it suggests to fix an edge
	 case bug dealing with emoji characters. */
	CGRect coreTextFrame = CGRectMake(0, 0, cellFrameWidth, cellFrameHeight);

	CGSize coreTextFrameSuggested = CTFramesetterSuggestFrameSizeWithConstraints(coreTextFramesetter, CFRangeMake(0, 0), NULL, CGSizeMake(cellFrameWidth, CGFLOAT_MAX), NULL);

	CGFloat coreTextFrameHeightDifference = (coreTextFrameSuggested.height - coreTextFrame.size.height);

	if (coreTextFrameHeightDifference > 0) {
		coreTextFrame.size.height += coreTextFrameHeightDifference;

		if ( coreTextFrameOffset) {
			*coreTextFrameOffset = coreTextFrameHeightDifference;
		}
	} else {
		if ( coreTextFrameOffset) {
			*coreTextFrameOffset = 0;
		}
	}

	CGPathAddRect(graphicsPath, NULL, coreTextFrame);

	/* Perform core text draw */
	CTFrameRef coreTextFrameRef = CTFramesetterCreateFrame(coreTextFramesetter, CFRangeMake(0, [self length]), graphicsPath, NULL);

	CTFrameDraw(coreTextFrameRef, bitmapContext);

	CFRelease(coreTextFrameRef);
	CFRelease(coreTextFramesetter);

	/* Create the image from the context */
	CGImageRef bitmapImage = CGBitmapContextCreateImage(bitmapContext);

	NSImage *imageCompletedDraw = [[NSImage alloc] initWithCGImage:bitmapImage size:NSZeroSize];

	/* Perform cleanup and return final result */
	CGImageRelease(bitmapImage);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);

	CFRelease(graphicsPath);

	[NSGraphicsContext restoreGraphicsState];

	return imageCompletedDraw;
}

@end

#pragma mark -
#pragma mark Mutable Attributed String Helper

@implementation NSMutableAttributedString (NSMutableAttributedStringHelper)

+ (NSMutableAttributedString *)mutableAttributedString
{
	return [NSMutableAttributedString mutableAttributedStringWithString:NSStringEmptyPlaceholder];
}

+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string
{
	return [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
}

+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)stringAttributes
{
	return [[NSMutableAttributedString alloc] initWithString:string attributes:stringAttributes];
}

- (NSString *)trimmedString
{
	return [[self string] trim];
}

- (NSString *)getTokenAsString
{
	return [[self getToken] string];
}

- (NSString *)lowercaseGetToken
{
	return [[self getTokenAsString] lowercaseString];
}

- (NSString *)uppercaseGetToken
{
	return [[self getTokenAsString] uppercaseString];
}

- (NSAttributedString *)getToken
{
	NSRange deletionRange = NSEmptyRange();

	NSAttributedString *token = [NSString getTokenFromFirstWhitespaceGroup:self returnedDeletionRange:&deletionRange];

	if (token == nil) {
		return [NSAttributedString attributedString];
	}

	if (deletionRange.location != NSNotFound) {
		[self deleteCharactersInRange:deletionRange];
	}

	return token;
}

- (NSAttributedString *)getTokenIncludingQuotes
{
	NSRange deletionRange = NSEmptyRange();

	NSAttributedString *quotedGroup = [NSString getTokenFromFirstQuoteGroup:self returnedDeletionRange:&deletionRange];

	if (quotedGroup == nil) {
		return [self getToken];
	}

	if (deletionRange.location != NSNotFound) {
		[self deleteCharactersInRange:deletionRange];
	}

	return quotedGroup;
}

- (void)appendString:(NSString *)string
{
	[self appendAttributedString:
	 [NSAttributedString attributedStringWithString:string]];
}

- (void)appendString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)stringAttributes
{
	[self appendAttributedString:
	 [NSAttributedString attributedStringWithString:string attributes:stringAttributes]];
}

@end

NS_ASSUME_NONNULL_END
