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

#include <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@implementation NSArray (CSArrayHelper)

- (BOOL)boolAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj respondsToSelector:@selector(boolValue)]) {
			return [obj boolValue];
		}

		return NO;
	}
}

- (nullable NSArray *)arrayAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj isKindOfClass:[NSArray class]]) {
			return obj;
		}

		return nil;
	}
}

- (nullable NSString *)stringAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj isKindOfClass:[NSString class]]) {
			return obj;
		}

		return nil;
	}
}

- (nullable NSDictionary *)dictionaryAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj isKindOfClass:[NSDictionary class]]) {
			return obj;
		}

		return nil;
	}
}

- (NSInteger)integerAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj respondsToSelector:@selector(integerValue)]) {
			return [obj integerValue];
		}

		return 0;
	}
}

- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj respondsToSelector:@selector(unsignedIntegerValue)]) {
			return [obj unsignedIntegerValue];
		}

		return 0;
	}
}

- (long long)longLongAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj respondsToSelector:@selector(longLongValue)]) {
			return [obj longLongValue];
		}

		return 0;
	}
}

- (double)doubleAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj respondsToSelector:@selector(doubleValue)]) {
			return [obj doubleValue];
		}

		return 0;
	}
}

- (nullable void *)pointerAtIndex:(NSUInteger)n
{
	@synchronized(self) {
		id obj = self[n];

		if ([obj isKindOfClass:[NSValue class]]) {
			return [obj pointerValue];
		}

		return NULL;
	}
}

- (BOOL)containsObjectIgnoringCase:(id)anObject
{
	PointerIsEmptyAssertReturn(anObject, NO)

	@synchronized(self) {
		NSInteger objectIndex =
		[self indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
			if ([object respondsToSelector:@selector(isEqualIgnoringCase:)] == NO) {
				return NO;
			}

			if ([object isEqualIgnoringCase:anObject]) {
				*stop = YES;

				return YES;
			} else {
				return NO;
			}
		}];

		return (objectIndex != NSNotFound);
	}
}

- (NSRange)range
{
	return NSMakeRange(0, [self count]);
}

- (NSArray *)arrayByRemovingObjectAtIndex:(NSUInteger)index
{
	@synchronized(self) {
		NSMutableArray *array = [self mutableCopy];

		[array removeObjectAtIndex:index];

		return [array copy];
	}
}

- (NSMutableArray *)mutableSubarrayWithRange:(NSRange)range
{
	@synchronized(self) {
		NSArray *subarray = [self subarrayWithRange:range];

		return [subarray mutableCopy];
	}
}

- (NSArray *)stringArrayControllerObjects
{
	NSMutableArray *newSet = [NSMutableArray array];

	@synchronized(self) {
		[self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			if ([object isKindOfClass:[NSString class]] == NO) {
				return;
			}

			[newSet addObject:@{@"string" : object}];
		}];
	}

	return [newSet copy];
}

@end

@implementation NSMutableArray (CSMutableArrayHelper)

- (void)addObjectWithoutDuplication:(id)anObject
{
	PointerIsEmptyAssert(anObject)

	if ([self containsObject:anObject] == NO) {
		[self addObject:anObject];
	}
}

- (void)insertBool:(BOOL)value atIndex:(NSUInteger)index
{
	[self insertObject:@(value) atIndex:index];
}

- (void)insertInteger:(NSInteger)value atIndex:(NSUInteger)index
{
	[self insertObject:@(value) atIndex:index];
}

- (void)insertUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index
{
	[self insertObject:@(value) atIndex:index];
}

- (void)insertLongLong:(long long)value atIndex:(NSUInteger)index
{
	[self insertObject:@(value) atIndex:index];
}

- (void)insertDouble:(double)value atIndex:(NSUInteger)index
{
	[self insertObject:@(value) atIndex:index];
}

- (void)insertPointer:(void *)value atIndex:(NSUInteger)index
{
	[self insertObject:[NSValue valueWithPointer:value] atIndex:index];
}

- (void)addBool:(BOOL)value
{
	[self addObject:@(value)];
}

- (void)addInteger:(NSInteger)value
{
	[self addObject:@(value)];
}

- (void)addUnsignedInteger:(NSUInteger)value
{
	[self addObject:@(value)];
}

- (void)addLongLong:(long long)value
{
	[self addObject:@(value)];
}

- (void)addDouble:(double)value
{
	[self addObject:@(value)];
}

- (void)addPointer:(void *)value
{
	[self addObject:[NSValue valueWithPointer:value]];
}

- (void)performSelectorOnObjectValueAndReplace:(SEL)performSelector
{
	PointerIsEmptyAssert(performSelector)

	@synchronized(self) {
		NSArray *oldArray = [self copy];

		[oldArray enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			NSMethodSignature *methodSignature = [object methodSignatureForSelector:performSelector];

			if (*([methodSignature methodReturnType]) != '@') { // Return object
				LogToConsole(@"Selector '%@' does not return object value.",
							 [object description], NSStringFromSelector(performSelector))
				LogToConsoleCurrentStackTrace

				return;
			}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
			id newObject = [object performSelector:performSelector];
#pragma GCC diagnostic pop

			if (newObject) {
				self[index] = newObject;
			} else {
				LogToConsole(@"Object %@ returned a nil value when performing selector '%@' - it will not be replaced.",
						[object description], NSStringFromSelector(performSelector))
				LogToConsoleCurrentStackTrace
			}
		}];
	}
}

- (NSUInteger)insertSortedObject:(id)object usingComparator:(NSComparator)comparator
{
	PointerIsEmptyAssertReturn(object, NSNotFound)
	PointerIsEmptyAssertReturn(comparator, NSNotFound)

	@synchronized(self) {
		NSUInteger index = [self indexOfObject:object
								 inSortedRange:[self range]
									   options:NSBinarySearchingInsertionIndex
							   usingComparator:comparator];

		[self insertObject:object atIndex:index];

		return index;
	}
}

@end

@implementation NSIndexSet (CSIndexSetHelper)

- (NSArray<NSNumber *> *)arrayFromIndexSet
{
	NSMutableArray *ary = [NSMutableArray array];

	[self enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		[ary addObject:@(index)];
	}];
	
	return ary;
}

@end

NS_ASSUME_NONNULL_END
