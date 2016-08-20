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

#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark Swizzling

/* Swizzle functions take strings to make it difficult for Apple to find private APIs */
void XRExchangeImplementation(NSString *className, NSString *originalMethod, NSString *replacementMethod)
{
	XRExchangeInstanceMethod(className, originalMethod, replacementMethod);
}

void XRExchangeInstanceMethod(NSString *className, NSString *originalMethod, NSString *replacementMethod)
{
	NSCParameterAssert(className != nil);
	NSCParameterAssert(originalMethod != nil);
	NSCParameterAssert(replacementMethod != nil);

	Class class = NSClassFromString(className);

	SEL originalSelector = NSSelectorFromString(originalMethod);
	SEL swizzledSelector = NSSelectorFromString(replacementMethod);

	Method originalMethodDcl = class_getInstanceMethod(class, originalSelector);
	Method swizzledMethodDcl = class_getInstanceMethod(class, swizzledSelector);

	BOOL methodAdded =
	class_addMethod(class,
					originalSelector,
					method_getImplementation(swizzledMethodDcl),
					method_getTypeEncoding(swizzledMethodDcl));

	if (methodAdded) {
		class_replaceMethod(class,
							swizzledSelector,
							method_getImplementation(originalMethodDcl),
							method_getTypeEncoding(originalMethodDcl));
	} else {
		method_exchangeImplementations(originalMethodDcl, swizzledMethodDcl);
	}
}

void XRExchangeClassMethod(NSString *className, NSString *originalMethod, NSString *replacementMethod)
{
	NSCParameterAssert(className != nil);
	NSCParameterAssert(originalMethod != nil);
	NSCParameterAssert(replacementMethod != nil);

	Class classClass = NSClassFromString(className);

	Class class = object_getClass(classClass);

	SEL originalSelector = NSSelectorFromString(originalMethod);
	SEL swizzledSelector = NSSelectorFromString(replacementMethod);

	Method originalMethodDcl = class_getClassMethod(class, originalSelector);
	Method swizzledMethodDcl = class_getClassMethod(class, swizzledSelector);

	BOOL methodAdded =
	class_addMethod(class,
					originalSelector,
					method_getImplementation(swizzledMethodDcl),
					method_getTypeEncoding(swizzledMethodDcl));

	if (methodAdded) {
		class_replaceMethod(class,
							swizzledSelector,
							method_getImplementation(originalMethodDcl),
							method_getTypeEncoding(originalMethodDcl));
	} else {
		method_exchangeImplementations(originalMethodDcl, swizzledMethodDcl);
	}
}

#pragma mark -
#pragma mark Validity

BOOL NSObjectIsEmpty(id _Nullable obj)
{
	if (obj == nil || obj == NULL) {
		return YES;
	} else if ([obj respondsToSelector:@selector(length)]) {
		return ([obj length] < 1);
	} else if ([obj respondsToSelector:@selector(count)]) {
		return ([obj count] < 1);
	} else	if ([obj isKindOfClass:[NSNull class]]) {
		return YES;
	}

	return NO;
}

BOOL NSObjectIsNotEmpty(id _Nullable obj)
{
	return (NSObjectIsEmpty(obj) == NO);
}

BOOL NSObjectsAreEqual(id _Nullable obj1, id _Nullable obj2)
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
	if ([NSThread isMainThread]) {
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

void XRPerformDelayedBlockOnGlobalQueue(dispatch_block_t block, NSTimeInterval delay)
{
	dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

	XRPerformDelayedBlockOnQueue(workerQueue, block, delay);
}

void XRPerformDelayedBlockOnMainQueue(dispatch_block_t block, NSTimeInterval delay)
{
	XRPerformDelayedBlockOnQueue(dispatch_get_main_queue(), block, delay);
}

void XRPerformDelayedBlockOnQueue(dispatch_queue_t queue, dispatch_block_t block, NSTimeInterval delay)
{
	NSCParameterAssert(delay >= 0);

	dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (delay * NSEC_PER_SEC));

	dispatch_after(timer, queue, block);
}

dispatch_source_t _Nullable XRScheduleBlockOnGlobalQueue(dispatch_block_t block, NSTimeInterval delay)
{
	dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

	return XRScheduleBlockOnQueue(workerQueue, block, delay);
}

dispatch_source_t _Nullable XRScheduleBlockOnMainQueue(dispatch_block_t block, NSTimeInterval delay)
{
	return XRScheduleBlockOnQueue(dispatch_get_main_queue(), block, delay);
}

dispatch_source_t _Nullable XRScheduleBlockOnQueue(dispatch_queue_t queue, dispatch_block_t block, NSTimeInterval delay)
{
	NSCParameterAssert(delay >= 0);

	dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

	if (timerSource == NULL) {
		return NULL;
	}

	dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (delay * NSEC_PER_SEC));

	dispatch_source_set_timer(timerSource, timer, DISPATCH_TIME_FOREVER, 0);

	dispatch_source_set_event_handler(timerSource, block);
	  
	dispatch_resume(timerSource);

	return timerSource;
}

void XRCancelScheduledBlock(dispatch_source_t blockSource)
{
	dispatch_source_cancel(blockSource);
}

NS_ASSUME_NONNULL_END
