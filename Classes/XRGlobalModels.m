/* *********************************************************************

        Copyright (c) 2010 - 2015 Codeux Software, LLC
   Please see Acknowledgements.pdf for additional information.

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

#import <objc/objc-runtime.h>

#pragma mark -
#pragma mark Validity

BOOL NSObjectIsEmpty(id obj)
{
	/* Check for common string length. */
	if ([obj respondsToSelector:@selector(length)]) {
		return ((NSInteger)objc_msgSend(obj, @selector(length)) < 1);
	}
	
	/* Check for common array types. */
	if ([obj respondsToSelector:@selector(count)]) {
		return ((NSInteger)objc_msgSend(obj, @selector(count)) < 1);
	}
	
	/* Check for singleton. */
	if ([obj isKindOfClass:[NSNull class]]) {
		return YES;
	}
	
	/* Check everything else. */
	return (obj == nil || obj == NULL);
}

BOOL NSObjectIsNotEmpty(id obj)
{
	return (NSObjectIsEmpty(obj) == NO);
}

BOOL NSObjectsAreEqual(id obj1, id obj2)
{
	return ((obj1 == nil && obj2 == nil) || [obj1 isEqual:obj2]);
}

#pragma mark -
#pragma mark Grand Central Dispatch

void XRPerformBlockOnGlobalDispatchQueue(XRPerformBlockOnDispatchQueueOperationType operationType, dispatch_block_t block)
{
	dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	XRPerformBlockOnDispatchQueue(workerQueue, block, operationType);
}

void XRPerformBlockSynchronouslyOnGlobalQueue(dispatch_block_t block)
{
	dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	XRPerformBlockOnDispatchQueue(workerQueue, block, XRPerformBlockOnDispatchQueueSyncOperationType);
}

void XRPerformBlockAsynchronouslyOnGlobalQueue(dispatch_block_t block)
{
	dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	XRPerformBlockOnDispatchQueue(workerQueue, block, XRPerformBlockOnDispatchQueueAsyncOperationType);
}

void XRPerformBlockOnMainDispatchQueue(XRPerformBlockOnDispatchQueueOperationType operationType, dispatch_block_t block)
{
	if (operationType == XRPerformBlockOnDispatchQueueSyncOperationType) {
		XRPerformBlockSynchronouslyOnMainQueue(block);
	} else {
		XRPerformBlockOnDispatchQueue(dispatch_get_main_queue(), block, operationType);
	}
}

void XRPerformBlockSynchronouslyOnMainQueue(dispatch_block_t block)
{
	/* Check thread we are on. */
	/* If we are already on the main thread and performing a synchronous action,
	 then all we have to do is invoke the block supplied to us. */
	if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
		block(); // Perform block.
	} else {
		XRPerformBlockOnDispatchQueue(dispatch_get_main_queue(), block, XRPerformBlockOnDispatchQueueSyncOperationType);
	}
}

void XRPerformBlockAsynchronouslyOnMainQueue(dispatch_block_t block)
{
	XRPerformBlockOnDispatchQueue(dispatch_get_main_queue(), block, XRPerformBlockOnDispatchQueueAsyncOperationType);
}

void XRPerformBlockSynchronouslyOnQueue(dispatch_queue_t queue, dispatch_block_t block)
{
	XRPerformBlockOnDispatchQueue(queue, block, XRPerformBlockOnDispatchQueueSyncOperationType);
}

void XRPerformBlockAsynchronouslyOnQueue(dispatch_queue_t queue, dispatch_block_t block)
{
	XRPerformBlockOnDispatchQueue(queue, block, XRPerformBlockOnDispatchQueueAsyncOperationType);
}

void XRPerformDelayedBlockOnGlobalQueue(dispatch_block_t block, NSInteger seconds)
{
	dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	XRPerformDelayedBlockOnQueue(workerQueue, block, seconds);
}

void XRPerformDelayedBlockOnMainQueue(dispatch_block_t block, NSInteger seconds)
{
	XRPerformDelayedBlockOnQueue(dispatch_get_main_queue(), block, seconds);
}

void XRPerformBlockOnDispatchQueue(dispatch_queue_t queue, dispatch_block_t block, XRPerformBlockOnDispatchQueueOperationType operationType)
{
	switch (operationType) {
		case XRPerformBlockOnDispatchQueueAsyncOperationType:
		{
			dispatch_async(queue, block);
			
			break;
		}
		case XRPerformBlockOnDispatchQueueSyncOperationType:
		{
			dispatch_sync(queue, block);
			
			break;
		}
		case XRPerformBlockOnDispatchQueueBarrierAsyncOperationType:
		{
			dispatch_barrier_async(queue, block);
			
			break;
		}
		case XRPerformBlockOnDispatchQueueBarrierSyncOperationType:
		{
			dispatch_barrier_sync(queue, block);
			
			break;
		}
	}
}

void XRPerformDelayedBlockOnQueue(dispatch_queue_t queue, dispatch_block_t block, NSInteger seconds)
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC));

	dispatch_after(popTime, queue, block);
}
