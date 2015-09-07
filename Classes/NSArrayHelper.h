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

@interface NSArray (CSCEFArrayHelper)
@property (nonatomic, assign, readonly) NSRange range;

- (BOOL)boolAtIndex:(NSUInteger)n;
- (NSArray *)arrayAtIndex:(NSUInteger)n;
- (NSString *)stringAtIndex:(NSUInteger)n;
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)n;
- (NSInteger)integerAtIndex:(NSUInteger)n;
- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)n;
- (long long)longLongAtIndex:(NSUInteger)n;
- (double)doubleAtIndex:(NSUInteger)n;
- (void *)pointerAtIndex:(NSUInteger)n NS_RETURNS_INNER_POINTER;

- (BOOL)containsObjectIgnoringCase:(id)anObject;

- (NSArray *)arrayByInsertingSortedObject:(id)obj usingComparator:(NSComparator)comparator;

- (NSArray *)arrayByRemovingObjectAtIndex:(NSUInteger)idx;

- (NSMutableArray *)mutableSubarrayWithRange:(NSRange)range;

- (NSUInteger)indexOfObjectMatchingValue:(id)value withKeyPath:(NSString *)keyPath;
- (NSUInteger)indexOfObjectMatchingValue:(id)value withKeyPath:(NSString *)keyPath usingSelector:(SEL)comparison;

/* -stringArryControllerObjects returns an NSArray of NSDictionary with single key,
 named "string" which contains any NSString values in original array. */
@property (nonatomic, copy, readonly) NSArray *stringArryControllerObjects;
@end

@interface NSMutableArray (CSCEFMutableArrayHelper)
- (void)addObjectWithoutDuplication:(id)anObject;

- (void)addBool:(BOOL)value;
- (void)addInteger:(NSInteger)value;
- (void)addUnsignedInteger:(NSUInteger)value;
- (void)addLongLong:(long long)value;
- (void)addDouble:(double)value;
- (void)addPointer:(void *)value;

- (void)insertBool:(BOOL)value atIndex:(NSUInteger)index;
- (void)insertInteger:(NSInteger)value atIndex:(NSUInteger)index;
- (void)insertUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;
- (void)insertLongLong:(long long)value atIndex:(NSUInteger)index;
- (void)insertDouble:(double)value atIndex:(NSUInteger)index;
- (void)insertPointer:(void *)value atIndex:(NSUInteger)index;

- (void)performSelectorOnObjectValueAndReplace:(SEL)performSelector;

- (NSUInteger)insertSortedObject:(id)obj usingComparator:(NSComparator)comparator;
@end

@interface NSIndexSet (CSCEFIndexSetHelper)
- (NSArray *)arrayFromIndexSet;
@end
