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

#include <Availability.h>

NS_ASSUME_NONNULL_BEGIN

#define CS_StringIsAlphabetic(c)					('a' <= (c) && (c) <= 'z' || 'A' <= (c) && (c) <= 'Z')
#define CS_StringIsBase10Numeric(c)					('0' <= (c) && (c) <= '9')
#define CS_StringIsAlphabeticNumeric(c)				(CS_StringIsAlphabetic(c) || CS_StringIsBase10Numeric(c))
#define CS_StringIsWordLetter(c)					(CS_StringIsAlphabeticNumeric(c) || (c) == '_')

COCOA_EXTENSIONS_EXTERN NSString * const NSStringEmptyPlaceholder;
COCOA_EXTENSIONS_EXTERN NSString * const NSStringNewlinePlaceholder;
COCOA_EXTENSIONS_EXTERN NSString * const NSStringWhitespacePlaceholder;

COCOA_EXTENSIONS_EXTERN NSString * const CS_AtoZUnderscoreDashCharacters;
COCOA_EXTENSIONS_EXTERN NSString * const CS_UnicodeReplacementCharacter;

#pragma mark
#pragma mark String Helpers

@interface NSString (CSStringHelper)
+ (nullable instancetype)stringWithBytes:(const void *)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding;
+ (nullable instancetype)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

@property (readonly, copy, nullable) NSString *sha1;
@property (readonly, copy, nullable) NSString *sha256;
@property (readonly, copy, nullable) NSString *md5;

@property (readonly) NSRange range;

+ (NSString *)stringWithUUID;

+ (nullable NSString *)charsetRepFromStringEncoding:(NSStringEncoding)encoding;

+ (NSArray<NSNumber *> *)supportedStringEncodings:(BOOL)favorUTF8; // favorUTF8 = place UTF-8 at index 0  of array

+ (NSDictionary<NSString *, NSNumber *> *)supportedStringEncodingsWithTitle:(BOOL)favorUTF8;

- (NSString *)substringAfterIndex:(NSUInteger)anIndex;
- (NSString *)substringBeforeIndex:(NSUInteger)anIndex;

- (NSString *)stringCharacterAtIndex:(NSUInteger)anIndex;

- (NSString *)stringByDeletingPreifx:(NSString *)prefix;

- (NSString *)stringByDeletingAllCharactersInSet:(NSString *)characters;
- (NSString *)stringByDeletingAllCharactersNotInSet:(NSString *)characters;

- (NSString *)stringByReplacingOccurrencesOfCharacterSet:(NSCharacterSet *)target withString:(NSString *)replacement;

- (CGFloat)compareWithWord:(NSString *)stringB lengthPenaltyWeight:(CGFloat)weight;

- (BOOL)hasPrefixIgnoringCase:(NSString *)aString;
- (BOOL)hasSuffixIgnoringCase:(NSString *)aString;

- (BOOL)hasPrefixWithCharacterSet:(NSCharacterSet *)characterSet;
- (BOOL)hasSuffixWithCharacterSet:(NSCharacterSet *)characterSet;

- (BOOL)isEqualIgnoringCase:(NSString *)other;

- (BOOL)contains:(NSString *)string;
- (BOOL)containsIgnoringCase:(NSString *)string;

- (BOOL)containsCharactersFromCharacterSet:(NSCharacterSet *)characterSet;
- (BOOL)onlyContainsCharactersFromCharacterSet:(NSCharacterSet *)characterSet;

- (BOOL)containsCharacters:(NSString *)characters;
- (BOOL)onlyContainsCharacters:(NSString *)characters;

- (NSUInteger)occurrencesOfCharacter:(UniChar)character;

- (NSInteger)stringPosition:(NSString *)needle;
- (NSInteger)stringPositionIgnoringCase:(NSString *)needle;

- (void)enumerateMatchesOfString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock;
- (void)enumerateMatchesOfString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock options:(NSStringCompareOptions)options;

- (void)enumerateFirstOccurrenceOfCharactersInString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock;
- (void)enumerateFirstOccurrenceOfCharactersInString:(NSString *)string withBlock:(void (NS_NOESCAPE ^)(NSRange range, BOOL *stop))enumerationBlock options:(NSStringCompareOptions)options;

- (NSArray<NSString *> *)split:(NSString *)delimiter;
- (NSArray<NSString *> *)splitWithMaximumLength:(NSUInteger)maximumLength;

@property (readonly, copy) NSString *trim;
@property (readonly, copy) NSString *trimNewlines;
- (NSString *)trimCharacters:(NSString *)characters;

@property (readonly, copy) NSString *removeAllNewlines;

@property (getter=isAlphabeticNumericOnly, readonly) BOOL alphabeticNumericOnly;
@property (getter=isNumericOnly, readonly) BOOL numericOnly;

@property (readonly, copy) NSString *safeFilename;

- (NSRange)rangeOfNextSegmentMatchingRegularExpression:(NSString *)regex startingAt:(NSUInteger)start;

@property (readonly, copy, nullable) NSData *IPv4AddressBytes;
@property (readonly, copy, nullable) NSData *IPv6AddressBytes;

@property (getter=isIPv4Address, readonly) BOOL IPv4Address;
@property (getter=isIPv6Address, readonly) BOOL IPv6Address;
@property (getter=isIPAddress, readonly) BOOL IPAddress;

- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight withFont:(NSFont *)textFont;

- (CGFloat)pixelHeightInWidth:(NSUInteger)width withFont:(nullable NSFont *)textFont;
- (CGFloat)pixelHeightInWidth:(NSUInteger)width withFont:(nullable NSFont *)textFont lineBreakMode:(NSLineBreakMode)lineBreakMode;

@property (readonly, copy) NSString *scannerString;

@property (readonly, copy) NSString *trimAndGetFirstToken;

@property (readonly, copy, nullable) NSURL *URLUsingWebKitPasteboard;

@property (readonly, copy) NSDictionary<NSString *, NSString *> *URLQueryItems;

@property (readonly, copy) NSArray<NSString *> *characterStringBuffer;
@end

#pragma mark -
#pragma mark String Percent Encoding Helper

@interface NSString (CSStringPercentEncodingHelper)
@property (readonly, copy, nullable) NSString *percentEncodedString;
@property (readonly, copy, nullable) NSString *percentDecodedString;

@property (readonly, copy, nullable) NSString *percentEncodedURLUser;
@property (readonly, copy, nullable) NSString *percentEncodedURLPassword;
@property (readonly, copy, nullable) NSString *percentEncodedURLHost;
@property (readonly, copy, nullable) NSString *percentEncodedURLPath;
@property (readonly, copy, nullable) NSString *percentEncodedURLQuery;
@property (readonly, copy, nullable) NSString *percentEncodedURLFragment;
@end

#pragma mark
#pragma mark String Number Formatter Helper

@interface NSString (CSStringNumberHelper)
+ (NSString *)stringWithChar:(char)value;
+ (NSString *)stringWithUniChar:(UniChar)value;
+ (NSString *)stringWithUnsignedChar:(unsigned char)value;
+ (NSString *)stringWithShort:(short)value;
+ (NSString *)stringWithUnsignedShort:(unsigned short)value;
+ (NSString *)stringWithInt:(int)value;
+ (NSString *)stringWithUnsignedInt:(unsigned int)value;
+ (NSString *)stringWithLong:(long)value;
+ (NSString *)stringWithUnsignedLong:(unsigned long)value;
+ (NSString *)stringWithLongLong:(long long)value;
+ (NSString *)stringWithUnsignedLongLong:(unsigned long long)value;
+ (NSString *)stringWithFloat:(float)value;
+ (NSString *)stringWithDouble:(double)value;
+ (NSString *)stringWithInteger:(NSInteger)value;
+ (NSString *)stringWithUnsignedInteger:(NSUInteger)value;
@end

#pragma mark 
#pragma mark Mutable String Helpers

@interface NSMutableString (CSMutableStringHelper)
@property (getter=getToken, readonly, copy) NSString *token;
@property (getter=getTokenIncludingQuotes, readonly, copy) NSString *tokenIncludingQuotes;

@property (readonly, copy) NSString *lowercaseGetToken;
@property (readonly, copy) NSString *uppercaseGetToken;
@end

#pragma mark 
#pragma mark Attributed String Helpers

@interface NSAttributedString (CSAttributedStringHelper)
@property (readonly, copy) NSDictionary<NSString *, id> *attributes;

@property (readonly) NSRange range;

+ (NSAttributedString *)attributedString;
+ (NSAttributedString *)attributedStringWithString:(NSString *)string;
+ (NSAttributedString *)attributedStringWithString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)stringAttributes;

- (NSAttributedString *)attributedSubstringFromIndex:(NSUInteger)from;
- (NSAttributedString *)attributedSubstringToIndex:(NSUInteger)to;

@property (readonly, copy) NSArray<NSAttributedString *> *splitIntoLines;

@property (readonly, copy) NSString *scannerString;

- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight;
- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight withFont:(nullable NSFont *)textFont;

- (CGFloat)pixelHeightInWidth:(NSUInteger)width;
- (CGFloat)pixelHeightInWidth:(NSUInteger)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)pixelHeightInWidth:(NSUInteger)width lineBreakMode:(NSLineBreakMode)lineBreakMode withFont:(nullable NSFont *)textFont;

- (nullable NSImage *)imageRepWithSize:(NSSize)originalSize scaleFactor:(CGFloat)scaleFactor backgroundColor:(NSColor *)backgroundColor NS_AVAILABLE_MAC(10_10);
- (nullable NSImage *)imageRepWithSize:(NSSize)originalSize scaleFactor:(CGFloat)scaleFactor backgroundColor:(NSColor *)backgroundColor coreTextFrameOffset:(CGFloat *)coreTextFrameOffset NS_AVAILABLE_MAC(10_10);

@property (readonly) NSRect imageBoundsOfFirstRun;
@end

#pragma mark 
#pragma mark Mutable Attributed String Helpers

@interface NSMutableAttributedString (CSMutableAttributedStringHelper)
+ (NSMutableAttributedString *)mutableAttributedString;
+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string;
+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)stringAttributes;

@property (getter=getTokenAsString, readonly, copy) NSString *tokenAsString;
@property (readonly, copy) NSString *lowercaseGetToken;
@property (readonly, copy) NSString *uppercaseGetToken;

@property (readonly, copy) NSString *trimmedString;

@property (getter=getToken, readonly, copy) NSAttributedString *token;
@property (getter=getTokenIncludingQuotes, readonly, copy) NSAttributedString *tokenIncludingQuotes;

- (void)appendString:(NSString *)string;
- (void)appendString:(NSString *)string attributes:(NSDictionary<NSString *, id> *)stringAttributes;
@end

NS_ASSUME_NONNULL_END
