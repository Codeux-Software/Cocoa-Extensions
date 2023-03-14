/* *********************************************************************
 *
 *         Copyright (c) 2015 - 2018 Codeux Software, LLC
 *     Please see ACKNOWLEDGEMENT for additional information.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of "Codeux Software, LLC", nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *********************************************************************** */

NS_ASSUME_NONNULL_BEGIN

COCOA_EXTENSIONS_EXTERN BOOL NSObjectIsEmpty(id _Nullable obj);
COCOA_EXTENSIONS_EXTERN BOOL NSObjectIsNotEmpty(id _Nullable obj);

COCOA_EXTENSIONS_INLINE
BOOL NSObjectsAreEqual(id _Nullable obj1, id _Nullable obj2)
{
	return ((obj1 == nil && obj2 == nil) || [obj1 isEqual:obj2]);
}

#pragma mark -

typedef enum XRPerformBlockOnDispatchQueueOperationType	: NSInteger {
	XRPerformBlockOnDispatchQueueBarrierAsyncOperationType,
	XRPerformBlockOnDispatchQueueBarrierSyncOperationType,
	XRPerformBlockOnDispatchQueueAsyncOperationType,
	XRPerformBlockOnDispatchQueueSyncOperationType,
} XRPerformBlockOnDispatchQueueOperationType;

COCOA_EXTENSIONS_EXTERN dispatch_queue_t XRCreateDispatchQueue(const char *label, dispatch_queue_attr_t attributes);
COCOA_EXTENSIONS_EXTERN dispatch_queue_t XRCreateDispatchQueueWithPriority(const char *label, dispatch_queue_attr_t attributes, dispatch_qos_class_t priority);

COCOA_EXTENSIONS_EXTERN void XRPerformBlockOnGlobalDispatchQueue(XRPerformBlockOnDispatchQueueOperationType operationType, dispatch_block_t block);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockOnGlobalDispatchQueueWithPriority(XRPerformBlockOnDispatchQueueOperationType operationType, dispatch_block_t block, dispatch_queue_priority_t priority);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockOnMainDispatchQueue(XRPerformBlockOnDispatchQueueOperationType operationType, dispatch_block_t block);

COCOA_EXTENSIONS_EXTERN void XRPerformBlockSynchronouslyOnMainQueue(DISPATCH_NOESCAPE dispatch_block_t block);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockAsynchronouslyOnMainQueue(dispatch_block_t block);

COCOA_EXTENSIONS_EXTERN void XRPerformBlockSynchronouslyOnGlobalQueue(DISPATCH_NOESCAPE dispatch_block_t block);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockSynchronouslyOnGlobalQueueWithPriority(DISPATCH_NOESCAPE dispatch_block_t block, dispatch_queue_priority_t priority);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockAsynchronouslyOnGlobalQueue(dispatch_block_t block);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockAsynchronouslyOnGlobalQueueWithPriority(dispatch_block_t block, dispatch_queue_priority_t priority);

COCOA_EXTENSIONS_EXTERN void XRPerformBlockSynchronouslyOnQueue(dispatch_queue_t queue, DISPATCH_NOESCAPE dispatch_block_t block);
COCOA_EXTENSIONS_EXTERN void XRPerformBlockAsynchronouslyOnQueue(dispatch_queue_t queue, dispatch_block_t block);

COCOA_EXTENSIONS_EXTERN void XRPerformBlockOnDispatchQueue(dispatch_queue_t queue, dispatch_block_t block, XRPerformBlockOnDispatchQueueOperationType operationType);

COCOA_EXTENSIONS_EXTERN dispatch_source_t _Nullable XRScheduleBlockOnGlobalQueue(dispatch_block_t block, NSTimeInterval delay);
COCOA_EXTENSIONS_EXTERN dispatch_source_t _Nullable XRScheduleBlockOnGlobalQueueWithPriority(dispatch_block_t block, NSTimeInterval delay, dispatch_queue_priority_t priority);
COCOA_EXTENSIONS_EXTERN dispatch_source_t _Nullable XRScheduleBlockOnMainQueue(dispatch_block_t block, NSTimeInterval delay);
COCOA_EXTENSIONS_EXTERN dispatch_source_t _Nullable XRScheduleBlockOnQueue(dispatch_queue_t queue, dispatch_block_t block, NSTimeInterval delay, BOOL repeat);

COCOA_EXTENSIONS_EXTERN void XRResumeScheduledBlock(dispatch_source_t blockSource);
COCOA_EXTENSIONS_EXTERN void XRCancelScheduledBlock(dispatch_source_t blockSource);

COCOA_EXTENSIONS_EXTERN void XRPerformDelayedBlockOnGlobalQueue(dispatch_block_t block, NSTimeInterval delay);
COCOA_EXTENSIONS_EXTERN void XRPerformDelayedBlockOnGlobalQueueWithPriority(dispatch_block_t block, NSTimeInterval delay, dispatch_queue_priority_t priority);
COCOA_EXTENSIONS_EXTERN void XRPerformDelayedBlockOnMainQueue(dispatch_block_t block, NSTimeInterval delay);

COCOA_EXTENSIONS_EXTERN void XRPerformDelayedBlockOnQueue(dispatch_queue_t queue, dispatch_block_t block, NSTimeInterval delay);

#pragma mark -

COCOA_EXTENSIONS_EXTERN void XRExchangeImplementation(NSString *className, NSString *originalMethod, NSString *replacementMethod) COCOA_EXTENSIONS_DEPRECATED("Use XRExchangeInstanceMethod() instead");

COCOA_EXTENSIONS_EXTERN void XRExchangeInstanceMethod(NSString *className, NSString *originalMethod, NSString *replacementMethod);
COCOA_EXTENSIONS_EXTERN void XRExchangeClassMethod(NSString *className, NSString *originalMethod, NSString *replacementMethod);

NS_ASSUME_NONNULL_END
