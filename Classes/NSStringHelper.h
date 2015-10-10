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

#define CSCEF_StringIsAlphabetic(c)						('a' <= (c) && (c) <= 'z' || 'A' <= (c) && (c) <= 'Z')
#define CSCEF_StringIsBase10Numeric(c)					('0' <= (c) && (c) <= '9')
#define CSCEF_StringIsAlphabeticNumeric(c)				(CSCEF_StringIsAlphabetic(c) || CSCEF_StringIsBase10Numeric(c))
#define CSCEF_StringIsWordLetter(c)						(CSCEF_StringIsAlphabeticNumeric(c) || (c) == '_')

COCOA_EXTENSIONS_EXTERN NSString * const NSStringEmptyPlaceholder;
COCOA_EXTENSIONS_EXTERN NSString * const NSStringNewlinePlaceholder;
COCOA_EXTENSIONS_EXTERN NSString * const NSStringWhitespacePlaceholder;

COCOA_EXTENSIONS_EXTERN NSString * const CSCEF_LatinAlphabetIncludingUnderscoreDashCharacterSet; 

#pragma mark
#pragma mark String Helpers

@interface NSString (CSCEFStringHelper)
+ (instancetype)stringWithBytes:(const void *)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding;
+ (instancetype)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

@property (readonly, copy) NSString *sha1;
@property (readonly, copy) NSString *sha256;
@property (readonly, copy) NSString *md5;

@property (nonatomic, assign, readonly) NSRange range;

+ (NSString *)stringWithUUID;

+ (NSString *)charsetRepFromStringEncoding:(NSStringEncoding)encoding;

+ (NSArray *)supportedStringEncodings:(BOOL)favorUTF8; // favorUTF8 = place UTF-8 at index 0  of array

+ (NSDictionary *)supportedStringEncodingsWithTitle:(BOOL)favorUTF8;

- (NSString *)substringAfterIndex:(NSUInteger)anIndex;
- (NSString *)substringBeforeIndex:(NSUInteger)anIndex;

- (NSString *)stringCharacterAtIndex:(NSUInteger)anIndex;

- (NSString *)stringByDeletingPreifx:(NSString *)prefix;

- (NSString *)stringByDeletingAllCharactersInSet:(NSString *)validChars;
- (NSString *)stringByDeletingAllCharactersNotInSet:(NSString *)validChars;

- (CGFloat)compareWithWord:(NSString *)stringB lengthPenaltyWeight:(CGFloat)weight;

- (BOOL)hasPrefixIgnoringCase:(NSString *)aString;
- (BOOL)hasSuffixIgnoringCase:(NSString *)aString;

- (BOOL)isEqualIgnoringCase:(NSString *)other;

- (BOOL)contains:(NSString *)str;
- (BOOL)containsIgnoringCase:(NSString *)str;

- (BOOL)containsCharactersFromCharacterSet:(NSCharacterSet *)validChars;
- (BOOL)onlyContainsCharactersFromCharacterSet:(NSCharacterSet *)validChars;

- (BOOL)containsCharacters:(NSString *)validChars;
- (BOOL)onlyContainsCharacters:(NSString *)validChars;

- (NSUInteger)occurrencesOfCharacter:(UniChar)character;

- (NSInteger)stringPosition:(NSString *)needle;
- (NSInteger)stringPositionIgnoringCase:(NSString *)needle;

- (NSArray *)split:(NSString *)delimiter;

@property (readonly, copy) NSString *trim;
@property (readonly, copy) NSString *trimNewlines;
- (NSString *)trimCharacters:(NSString *)charset;

@property (readonly, copy) NSString *removeAllNewlines;

@property (getter=isAlphabeticNumericOnly, readonly) BOOL alphabeticNumericOnly;
@property (getter=isNumericOnly, readonly) BOOL numericOnly;

@property (readonly, copy) NSString *safeFilename;

- (NSRange)rangeOfNextSegmentMatchingRegularExpression:(NSString *)regex startingAt:(NSUInteger)start;

@property (readonly, copy) NSString *encodeURIComponent;
@property (readonly, copy) NSString *encodeURIFragment;
@property (readonly, copy) NSString *decodeURIFragment;

@property (readonly, copy) NSData *IPv4AddressBytes;
@property (readonly, copy) NSData *IPv6AddressBytes;

@property (getter=isIPv4Address, readonly) BOOL IPv4Address;
@property (getter=isIPv6Address, readonly) BOOL IPv6Address;
@property (getter=isIPAddress, readonly) BOOL IPAddress;

#ifdef COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
- (NSUInteger)wrappedLineCount:(NSUInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight withFont:(NSFont *)textFont;

- (CGFloat)pixelHeightInWidth:(NSUInteger)width withFont:(NSFont *)textFont;
- (CGFloat)pixelHeightInWidth:(NSUInteger)width withFont:(NSFont *)textFont lineBreakMode:(NSLineBreakMode)lineBreakMode;
#endif 

@property (readonly, copy) NSString *scannerString;

@property (readonly, copy) NSString *trimAndGetFirstToken;

#ifdef COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
@property (readonly, copy) NSURL *URLUsingWebKitPasteboard;
#endif
@end

#pragma mark
#pragma mark String Number Formatter Helper

@interface NSString (CSCEFStringNumberHelper)
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

@interface NSMutableString (CSCEFMutableStringHelper)
@property (getter=getToken, readonly, copy) NSString *token;
@property (getter=getTokenIncludingQuotes, readonly, copy) NSString *tokenIncludingQuotes;

@property (readonly, copy) NSString *uppercaseGetToken;
@end

#pragma mark 
#pragma mark Attributed String Helpers

@interface NSAttributedString (CSCEFAttributedStringHelper)
@property (readonly, copy) NSDictionary *attributes;

@property (nonatomic, assign, readonly) NSRange range;

+ (NSAttributedString *)attributedString;
+ (NSAttributedString *)attributedStringWithString:(NSString *)string;
+ (NSAttributedString *)attributedStringWithString:(NSString *)string attributes:(NSDictionary *)stringAttributes;

+ (NSAttributedString *)emptyString COCOA_EXTENSIONS_DEPRECATED("Use -attributedString isntead");
+ (NSAttributedString *)emptyStringWithBase:(NSString *)string COCOA_EXTENSIONS_DEPRECATED("Use -attributedStringWithString: isntead");

+ (NSAttributedString *)stringWithBase:(NSString *)string attributes:(NSDictionary *)stringAttributes COCOA_EXTENSIONS_DEPRECATED("Use -attributedStringWithString:attributes: isntead");

- (NSAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set;
- (NSAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set frontChop:(NSRangePointer)front;

@property (readonly, copy) NSArray *splitIntoLines;

@property (readonly, copy) NSString *scannerString;

#ifdef COCOA_EXTENSIONS_BUILT_AGAINST_OS_X_SDK
- (NSUInteger)wrappedLineCount:(NSInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight;
- (NSUInteger)wrappedLineCount:(NSInteger)boundWidth lineMultiplier:(NSUInteger)lineHeight withFont:(NSFont *)textFont;

- (CGFloat)pixelHeightInWidth:(NSUInteger)width;
- (CGFloat)pixelHeightInWidth:(NSUInteger)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)pixelHeightInWidth:(NSUInteger)width lineBreakMode:(NSLineBreakMode)lineBreakMode withFont:(NSFont *)textFont;

- (NSImage *)imageRepWithSize:(NSSize)originalSize scaleFactor:(CGFloat)scaleFactor backgroundColor:(NSColor *)backgroundColor NS_AVAILABLE_MAC(10_10);
#endif
@end

#pragma mark 
#pragma mark Mutable Attributed String Helpers

@interface NSMutableAttributedString (CSCEFMutableAttributedStringHelper)
+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string attributes:(NSDictionary *)stringAttributes;

+ (NSMutableAttributedString *)mutableStringWithBase:(NSString *)string attributes:(NSDictionary *)stringAttributes COCOA_EXTENSIONS_DEPRECATED("Use -mutableAttributedStringWithString:attributes: isntead");

@property (getter=getTokenAsString, readonly, copy) NSString *tokenAsString;
@property (readonly, copy) NSString *uppercaseGetToken;

@property (readonly, copy) NSString *trimmedString;

@property (getter=getToken, readonly, copy) NSAttributedString *token;
@property (getter=getTokenIncludingQuotes, readonly, copy) NSAttributedString *tokenIncludingQuotes;
@end
