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

@implementation NSDictionary (CSCEFDictionaryHelper)

- (BOOL)boolForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj respondsToSelector:@selector(boolValue)]) {
		return [obj boolValue];
	}
	
	return NO;
}

- (NSInteger)integerForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj respondsToSelector:@selector(integerValue)]) {
		return [obj integerValue];
	}
	
	return 0;
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key
{
	id obj = self[key];

	if ([obj respondsToSelector:@selector(unsignedIntegerValue)]) {
		return [obj unsignedIntegerValue];
	}

	return 0;
}

- (long long)longLongForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj respondsToSelector:@selector(longLongValue)]) {
		return [obj longLongValue];
	}
	
	return 0;
}

- (double)doubleForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj respondsToSelector:@selector(doubleValue)]) {
		return [obj doubleValue];
	}
	
	return 0;
}

- (float)floatForKey:(NSString *)key
{
	id obj = self[key];

	if ([obj respondsToSelector:@selector(floatValue)]) {
		return [obj floatValue];
	}

	return 0;
}

- (NSString *)stringForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj isKindOfClass:[NSString class]]) {
		return obj;
	}
	
	return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj isKindOfClass:[NSDictionary class]]) {
		return obj;
	}
	
	return nil;
}

- (NSArray *)arrayForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj isKindOfClass:[NSArray class]]) {
		return obj;
	}
	
	return nil;
}

- (void *)pointerForKey:(NSString *)key
{
	id obj = self[key];
	
	if ([obj isKindOfClass:[NSValue class]]) {
		return [obj pointerValue];
	}
	
	return nil;
}

- (id)objectForKey:(id)key orUseDefault:(id)defaultValue
{
	if ([self containsKey:key]) {
		return self[key];
	} else {
		return defaultValue;
	}
}

- (NSString *)stringForKey:(id)key orUseDefault:(NSString *)defaultValue
{
	if ([self containsKey:key]) {
		return [self stringForKey:key];
	} else {
		return defaultValue;
	}
}

- (BOOL)boolForKey:(NSString *)key orUseDefault:(BOOL)defaultValue
{
	if ([self containsKey:key]) {
		return [self boolForKey:key];
	} else {
		return defaultValue;
	}
}

- (NSArray *)arrayForKey:(NSString *)key orUseDefault:(NSArray *)defaultValue
{
	if ([self containsKey:key]) {
		return [self arrayForKey:key];
	} else {
		return defaultValue;
	}
}

- (NSDictionary *)dictionaryForKey:(NSString *)key orUseDefault:(NSDictionary *)defaultValue
{
	if ([self containsKey:key]) {
		return [self dictionaryForKey:key];
	} else {
		return defaultValue;
	}
}

- (NSInteger)integerForKey:(NSString *)key orUseDefault:(NSInteger)defaultValue
{
	if ([self containsKey:key]) {
		return [self integerForKey:key];
	} else {
		return defaultValue;
	}
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key orUseDefault:(NSInteger)defaultValue
{
	if ([self containsKey:key]) {
		return [self unsignedIntegerForKey:key];
	} else {
		return defaultValue;
	}
}

- (long long)longLongForKey:(NSString *)key orUseDefault:(long long)defaultValue
{
	if ([self containsKey:key]) {
		return [self longLongForKey:key];
	} else {
		return defaultValue;
	}
}

- (double)doubleForKey:(NSString *)key orUseDefault:(double)defaultValue
{
	if ([self containsKey:key]) {
		return [self doubleForKey:key];
	} else {
		return defaultValue;
	}
}

- (float)floatForKey:(NSString *)key orUseDefault:(float)defaultValue
{
	if ([self containsKey:key]) {
		return [self floatForKey:key];
	} else {
		return defaultValue;
	}
}

- (void)assignObjectTo:(__strong id *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = self[key];
	}
}

- (void)assignObjectTo:(__strong id *)pointer forKey:(NSString *)key performCopy:(BOOL)copyValue
{
	if ([self containsKey:key]) {
		if (copyValue) {
			*pointer = [self[key] copy];
		} else {
			*pointer =  self[key];
		}
	}
}

- (void)assignStringTo:(__strong NSString **)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [[self stringForKey:key] copy];
	}
}

- (void)assignBoolTo:(BOOL *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [self boolForKey:key];
	}
}

- (void)assignArrayTo:(__strong NSArray **)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [[self arrayForKey:key] copy];
	}
}

- (void)assignDictionaryTo:(__strong NSDictionary **)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [[self dictionaryForKey:key] copy];
	}
}

- (void)assignIntegerTo:(NSInteger *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [self integerForKey:key];
	}
}

- (void)assignUnsignedIntegerTo:(NSUInteger *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [self unsignedIntegerForKey:key];
	}
}

- (void)assignLongLongTo:(long long *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [self longLongForKey:key];
	}
}

- (void)assignDoubleTo:(double *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [self doubleForKey:key];
	}
}

- (void)assignFloatTo:(float *)pointer forKey:(NSString *)key
{
	if ([self containsKey:key]) {
		*pointer = [self floatForKey:key];
	}
}

- (BOOL)containsKey:(NSString *)baseKey
{
	return ((self[baseKey] == nil) == NO);
}
	
- (BOOL)containsKeyIgnoringCase:(NSString *)baseKey
{
	NSString *caslessKey = [self keyIgnoringCase:baseKey];
	
	return ([caslessKey length] > 0);
}

- (NSString *)firstKeyForObject:(id)object
{
	for (NSString *key in [self allKeys]) {
		if ([self[key] isEqual:object]) {
			return key;
		}
	}

	return nil;
}

- (NSString *)keyIgnoringCase:(NSString *)baseKey
{
	for (NSString *key in [self allKeys]) {
		if ([key isEqualIgnoringCase:baseKey]) {
			return key;
		} 
	}
	
	return nil;
}

- (id)sortedDictionary
{
	COCOA_EXTENSIONS_DEPRECATED_WARNING

	return [self sortedDictionary:NO];
}

- (id)sortedReversedDictionary
{
	COCOA_EXTENSIONS_DEPRECATED_WARNING

	return [self sortedDictionary:YES];
}

- (NSArray *)sortedDictionaryKeys
{
	return [self sortedDictionaryKeys:NO];
}

- (NSArray *)sortedDictionaryReversedKeys
{
	return [self sortedDictionaryKeys:YES];
}

- (NSArray *)sortedDictionaryKeys:(BOOL)reversed
{
	NSArray *keys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
	
	if (reversed) {
		return [[keys reverseObjectEnumerator] allObjects];
	}

	return keys;
}

- (id)sortedDictionary:(BOOL)reversed
{
	NSArray *sortedKeys = [self sortedDictionaryKeys:reversed];

	NSMutableDictionary *newDict = [NSMutableDictionary dictionary];

	for (NSString *key in sortedKeys) {
		newDict[key] = self[key];
	}

	return newDict;
}

- (NSDictionary *)dictionaryByRemovingDefaults:(NSDictionary *)defaults
{
	NSMutableDictionary *ndic = [NSMutableDictionary dictionary];

	@synchronized(self) {
		for (NSString *currentObjectKey in self) {
			id currentObject = self[currentObjectKey];

			BOOL emptyObject = NSObjectIsEmpty(currentObject);

			BOOL voidDefaults = (defaults && NSObjectsAreEqual(currentObject, defaults[currentObjectKey]));

			if (voidDefaults == NO && emptyObject == NO) {
				ndic[currentObjectKey] = currentObject;
			}
		}
	}

	return [ndic copy];
}

@end

@implementation NSMutableDictionary (CSCEFMutableDictionaryHelper)

- (void)setObjectWithoutOverride:(id)value forKey:(NSString *)key
{
	if ((value == nil) == NO) {
		if ([self containsKey:key] == NO) {
			self[key] = value;
		}
	}
}

- (void)maybeSetObject:(id)value forKey:(NSString *)key
{
	if ((value == nil) == NO) {
		self[key] = value;
	}
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
	self[key] = @(value);
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
	self[key] = @(value);
}

- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString *)key
{
	self[key] = @(value);
}

- (void)setLongLong:(long long)value forKey:(NSString *)key
{
	self[key] = @(value);
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
	self[key] = @(value);
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
	self[key] = @(value);
}

- (void)setPointer:(void *)value forKey:(NSString *)key
{
	self[key] = [NSValue valueWithPointer:value];
}

@end
