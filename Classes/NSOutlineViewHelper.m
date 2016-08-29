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

NS_ASSUME_NONNULL_BEGIN

@implementation NSTableView (CSTableViewHelper)

- (void)selectItemAtIndex:(NSUInteger)index
{
	[self selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	
	[self scrollRowToVisible:index];
}

- (NSInteger)rowBeneathMouse
{
	NSPoint ml = self.window.mouseLocationOutsideOfEventStream;

	NSPoint pt = [self convertPoint:ml fromView:nil];

	return [self rowAtPoint:pt];
}

- (NSInteger)rowUnderMouse
{
	return [self rowBeneathMouse];
}

@end

#pragma mark -

@implementation NSOutlineView (CSOutlineViewHelper)

- (NSArray *)selectedObjects
{
	NSIndexSet *selectedRows = [self selectedRowIndexes];

	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:selectedRows.count];

	[selectedRows enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		id object = [self itemAtRow:index];

		[objects addObject:object];
	}];

	return [objects copy];
}

- (BOOL)isGroupItem:(id)item
{
	NSParameterAssert(item != nil);

	return ([self levelForItem:item] == 0);
}

- (NSArray *)groupItems
{
	NSMutableArray *groups = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < [self numberOfRows]; i++) {
		if ([self levelForRow:i] == 0) {
			id curRow = [self itemAtRow:i];

			[groups addObject:curRow];
		}
	}
	
	return groups;
}

- (nullable NSArray *)itemsFromParentGroup:(id)item
{
	return [self itemsInGroup:item];
}

- (nullable NSArray *)itemsInGroup:(id)groupItem
{
	NSParameterAssert(groupItem != nil);

	if ([self isGroupItem:groupItem] == NO) {
		NSArray *parentItem = [self parentForItem:groupItem];

		if (parentItem) {
			groupItem = parentItem;
		} else {
			return nil;
		}
	}

	NSMutableArray *allRows = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < [self numberOfRows]; i++) {
		id itemAtRow = [self itemAtRow:i];

		id parentItem = [self parentForItem:itemAtRow];

		if (parentItem == groupItem) {
			[allRows addObject:itemAtRow];
		}
	}
	
	return allRows;
}

- (nullable NSIndexSet *)indexesOfItemsInGroup:(id)groupItem
{
	NSArray *itemsInGroup = [self itemsInGroup:groupItem];

	if (itemsInGroup == nil) {
		return nil;
	}

	id itemFirst = [itemsInGroup firstObject];
	id itemLast = [itemsInGroup lastObject];

	if (itemFirst == nil) {
		return nil;
	}

	NSInteger itemFirstIndex = [self rowForItem:itemFirst];
	NSInteger itemLastIndex = [self rowForItem:itemLast];

	return [NSIndexSet indexSetWithIndexesInRange:
			NSMakeRange(itemFirstIndex, (itemLastIndex - itemFirstIndex + 1))];
}

@end

NS_ASSUME_NONNULL_END
