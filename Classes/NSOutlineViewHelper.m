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

- (NSIndexSet *)selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes maximumNumberOfSelections:(NSUInteger)maximumNumberOfSelections
{
	NSParameterAssert(proposedSelectionIndexes != nil);
	NSParameterAssert(maximumNumberOfSelections > 0);

	if (proposedSelectionIndexes.count <= maximumNumberOfSelections) {
		return proposedSelectionIndexes;
	}

	/* If the user has already selected the maximum, then return the current index set.
	 This prevents the user clicking one item up and having the entire selection shift
	 because the following logic works from highest to lowest. */
	if (self.numberOfSelectedRows == maximumNumberOfSelections) {
		return self.selectedRowIndexes;
	}

	return [proposedSelectionIndexes subsetWithMaximumIndexes:maximumNumberOfSelections];
}

@end

#pragma mark -

@implementation NSOutlineView (CSOutlineViewHelper)

+ (void)load
{
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		if ([XRSystemInformation isUsingOSXSierraOrLater]) {
			return;
		}

		XRExchangeInstanceMethod(@"NSOutlineView", @"reloadItem:reloadChildren:", @"ce_priv_reloadItem:reloadChildren:");
	});
}

- (void)ce_priv_reloadItem:(id)item reloadChildren:(BOOL)reloadChildren
{
	/* -reloadItem does not reload the view on platforms older than 10.12.
	 On older platforms, we perform the reload manually. */

	/* If we are reloading children, we can get away with using original. */
	if (reloadChildren) {
		[self ce_priv_reloadItem:item reloadChildren:reloadChildren];
	}

	/* Reload individual items */
	NSInteger itemRow = [self rowForItem:item];

	if (itemRow < 0) {
		return;
	}

	NSIndexSet *rowIndexes = [NSIndexSet indexSetWithIndex:itemRow];

	NSRange columnIndexRange = NSMakeRange(0, [self numberOfColumns]);

	NSIndexSet *columnIndexes = [NSIndexSet indexSetWithIndexesInRange:columnIndexRange];

	[self reloadDataForRowIndexes:rowIndexes columnIndexes:columnIndexes];
}

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

- (NSInteger)numberOfItemsInGroup:(nullable id)groupItem
{
	if ([XRSystemInformation isUsingOSXYosemiteOrLater]) {
		return [self numberOfChildrenOfItem:groupItem];
	}

	NSParameterAssert([self.dataSource respondsToSelector:@selector(outlineView:numberOfChildrenOfItem:)]);

	return [self.dataSource outlineView:self numberOfChildrenOfItem:groupItem];
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
