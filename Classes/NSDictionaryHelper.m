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

NS_ASSUME_NONNULL_BEGIN

@implementation NSDictionary (CSDictionaryHelper)

- (BOOL)boolForKey:(NSString *)key
{
	return [self boolForKey:key orUseDefault:NO];
}

- (NSInteger)integerForKey:(NSString *)key
{
	return [self integerForKey:key orUseDefault:0];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key
{
	return [self unsignedIntegerForKey:key orUseDefault:0];
}

- (long long)longLongForKey:(NSString *)key
{
	return [self longLongForKey:key orUseDefault:0];
}

- (double)doubleForKey:(NSString *)key
{
	return [self doubleForKey:key orUseDefault:0];
}

- (float)floatForKey:(NSString *)key
{
	return [self floatForKey:key orUseDefault:0];
}

- (nullable NSString *)stringForKey:(NSString *)key
{
	return [self stringForKey:key orUseDefault:nil];
}

- (nullable NSDictionary *)dictionaryForKey:(NSString *)key
{
	return [self dictionaryForKey:key orUseDefault:nil];
}

- (nullable NSArray *)arrayForKey:(NSString *)key
{
	return [self arrayForKey:key orUseDefault:nil];
}

- (nullable void *)pointerForKey:(NSString *)key
{
	PointerIsEmptyAssertReturn(key, NULL)

	@synchronized(self) {
		id obj = self[key];

		if ([obj isKindOfClass:[NSValue class]]) {
			return [obj pointerValue];
		}

		return nil;
	}
}

- (nullable id)objectForKey:(id)key orUseDefault:(nullable id)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if (obj) {
			return obj;
		}

		return defaultValue;
	}
}

- (nullable NSString *)stringForKey:(id)key orUseDefault:(nullable NSString *)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj isKindOfClass:[NSString class]]) {
			return obj;
		}

		return defaultValue;
	}
}

- (BOOL)boolForKey:(NSString *)key orUseDefault:(BOOL)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj respondsToSelector:@selector(boolValue)]) {
			return [obj boolValue];
		}

		return defaultValue;
	}
}

- (nullable NSArray *)arrayForKey:(NSString *)key orUseDefault:(nullable NSArray *)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj isKindOfClass:[NSArray class]]) {
			return obj;
		}

		return defaultValue;
	}
}

- (nullable NSDictionary *)dictionaryForKey:(NSString *)key orUseDefault:(nullable NSDictionary *)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj isKindOfClass:[NSDictionary class]]) {
			return obj;
		}

		return defaultValue;
	}
}

- (NSInteger)integerForKey:(NSString *)key orUseDefault:(NSInteger)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj respondsToSelector:@selector(integerValue)]) {
			return [obj integerValue];
		}

		return defaultValue;
	}
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key orUseDefault:(NSInteger)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj respondsToSelector:@selector(unsignedIntegerValue)]) {
			return [obj unsignedIntegerValue];
		}

		return defaultValue;
	}
}

- (long long)longLongForKey:(NSString *)key orUseDefault:(long long)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj respondsToSelector:@selector(longLongValue)]) {
			return [obj longLongValue];
		}

		return defaultValue;
	}
}

- (double)doubleForKey:(NSString *)key orUseDefault:(double)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj respondsToSelector:@selector(doubleValue)]) {
			return [obj doubleValue];
		}

		return defaultValue;
	}
}

- (float)floatForKey:(NSString *)key orUseDefault:(float)defaultValue
{
	PointerIsEmptyAssertReturn(key, defaultValue)

	@synchronized(self) {
		id obj = self[key];

		if ([obj respondsToSelector:@selector(floatValue)]) {
			return [obj floatValue];
		}

		return defaultValue;
	}
}

- (void)assignObjectTo:(__strong id *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	@synchronized(self) {
		id object = self[key];

		if ([object respondsToSelector:@selector(copy)]) {
			*pointer = [object copy];
		}
	}
}

- (void)assignStringTo:(__strong NSString **)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	NSString *object = [self stringForKey:key];

	if (object) {
		*pointer = [object copy];
	}
}

- (void)assignBoolTo:(BOOL *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	*pointer = [self boolForKey:key orUseDefault:*pointer];
}

- (void)assignArrayTo:(__strong NSArray **)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	NSArray *object = [self arrayForKey:key];

	if (object) {
		*pointer = [object copy];
	}
}

- (void)assignDictionaryTo:(__strong NSDictionary **)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	NSDictionary *object = [self dictionaryForKey:key];

	if (object) {
		*pointer = [object copy];
	}
}

- (void)assignIntegerTo:(NSInteger *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	*pointer = [self integerForKey:key orUseDefault:*pointer];
}

- (void)assignUnsignedIntegerTo:(NSUInteger *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	*pointer = [self unsignedIntegerForKey:key orUseDefault:*pointer];
}

- (void)assignLongLongTo:(long long *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	*pointer = [self longLongForKey:key orUseDefault:*pointer];
}

- (void)assignDoubleTo:(double *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	*pointer = [self doubleForKey:key orUseDefault:*pointer];
}

- (void)assignFloatTo:(float *)pointer forKey:(NSString *)key
{
	PointerIsEmptyAssert(pointer)

	*pointer = [self floatForKey:key orUseDefault:*pointer];
}

- (BOOL)containsKey:(NSString *)baseKey
{
	PointerIsEmptyAssertReturn(baseKey, NO)

	@synchronized (self) {
		return (self[baseKey] != nil);
	}
}
	
- (BOOL)containsKeyIgnoringCase:(NSString *)baseKey
{
	NSString *caslessKey = [self keyIgnoringCase:baseKey];
	
	return ([caslessKey length] > 0);
}

- (nullable id)firstKeyForObject:(id)anObject
{
	PointerIsEmptyAssertReturn(anObject, nil)

	NSSet *keys =
	[self keysOfEntriesPassingTest:^BOOL(id key, id object, BOOL *stop) {
		if (NSObjectsAreEqual(object, anObject)) {
			*stop = YES;

			return YES;
		} else {
			return NO;
		}
	}];

	if ([keys count] == 0) {
		return nil;
	}

	return [keys anyObject];
}

- (nullable id)keyIgnoringCase:(id)baseKey
{
	NSSet *keys =
	[self keysOfEntriesPassingTest:^BOOL(id key, id object, BOOL *stop) {
		if ([key respondsToSelector:@selector(isEqualIgnoringCase:)] == NO) {
			return NO;
		}

		if ([key isEqualIgnoringCase:baseKey]) {
			*stop = YES;

			return YES;
		} else {
			return NO;
		}
	}];

	if ([keys count] == 0) {
		return nil;
	}

	return [keys anyObject];
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

- (NSDictionary *)dictionaryByRemovingDefaults:(nullable NSDictionary *)defaults
{
	return [self dictionaryByRemovingDefaults:defaults allowEmptyValues:NO];
}

- (NSDictionary *)dictionaryByRemovingDefaults:(nullable NSDictionary *)defaults allowEmptyValues:(BOOL)allowEmptyValues
{
	if (defaults == nil && allowEmptyValues == YES) {
		return self;
	}

	NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];

	@synchronized(self) {
		[self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			BOOL emptyObject = (allowEmptyValues && NSObjectIsEmpty(object));

			BOOL voidDefaults = (defaults && NSObjectsAreEqual(object, defaults[key]));

			if (voidDefaults == NO && emptyObject == NO) {
				newDictionary[key] = object;
			}
		}];
	}

	return [newDictionary copy];
}

@end

@implementation NSMutableDictionary (CSMutableDictionaryHelper)

- (void)setObjectWithoutOverride:(id)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(value)
	PointerIsEmptyAssert(key)

	if (self[key] == nil) {
		self[key] = value;
	}
}

- (void)maybeSetObject:(nullable id)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(value)
	PointerIsEmptyAssert(key)

	self[key] = value;
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = @(value);
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = @(value);
}

- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = @(value);
}

- (void)setLongLong:(long long)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = @(value);
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = @(value);
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = @(value);
}

- (void)setPointer:(void *)value forKey:(NSString *)key
{
	PointerIsEmptyAssert(key)

	self[key] = [NSValue valueWithPointer:value];
}

@end

NS_ASSUME_NONNULL_END
