
/*
 * Copyright (c) 2007-2009 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDInvocation.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark Public Helper Methods

@implementation NSObject (DDExtensions)

- (nullable id)invokeOnThread:(NSThread *)thread
{
	NSParameterAssert(thread != nil);

	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setParentThread:thread];
	[grabber setThreadType:DDInvocationParentThread];

	return [grabber prepareWithInvocationTarget:self];
}

+ (nullable id)invokeOnThread:(NSThread *)thread
{
	NSParameterAssert(thread != nil);

	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setParentThread:thread];
	[grabber setThreadType:DDInvocationParentThread];

	return [grabber prepareWithInvocationTarget:self];
}

- (nullable id)iomt
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setThreadType:DDInvocationMainThread];

	return [grabber prepareWithInvocationTarget:self];
}

+ (nullable id)iomt
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setThreadType:DDInvocationMainThread];

	return [grabber prepareWithInvocationTarget:self];
}

- (nullable id)invokeOnMainThread
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setThreadType:DDInvocationMainThread];

	return [grabber prepareWithInvocationTarget:self];
}

+ (nullable id)invokeOnMainThread
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setThreadType:DDInvocationMainThread];

	return [grabber prepareWithInvocationTarget:self];
}

- (nullable id)invokeInBackgroundThread
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setThreadType:DDInvocationBackgroundThread];

	return [grabber prepareWithInvocationTarget:self];
}

+ (nullable id)invokeInBackgroundThread
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setThreadType:DDInvocationBackgroundThread];

	return [grabber prepareWithInvocationTarget:self];
}

- (nullable id)invokeOnMainThreadAndWaitUntilDone:(BOOL)waitUntilDone
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setWaitUntilDone:waitUntilDone];
	[grabber setThreadType:DDInvocationMainThread];

	return [grabber prepareWithInvocationTarget:self];
}

+ (nullable id)invokeOnMainThreadAndWaitUntilDone:(BOOL)waitUntilDone
{
	DDInvocation *grabber = [DDInvocation invocationGrabber];

	[grabber setWaitUntilDone:waitUntilDone];
	[grabber setThreadType:DDInvocationMainThread];

	return [grabber prepareWithInvocationTarget:self];
}

#pragma mark -

+ (void)performBlockOnMainThread:(ddEmtpyBlockDataType)block
{
	XRPerformBlockSynchronouslyOnMainQueue(block);
}

- (void)performBlockOnMainThread:(ddEmtpyBlockDataType)block
{
	XRPerformBlockSynchronouslyOnMainQueue(block);
}

+ (void)performBlockOnGlobalQueue:(ddEmtpyBlockDataType)block
{
	XRPerformBlockAsynchronouslyOnGlobalQueue(block);
}

- (void)performBlockOnGlobalQueue:(ddEmtpyBlockDataType)block
{
	XRPerformBlockAsynchronouslyOnGlobalQueue(block);
}

- (void)performBlockOnMainThread:(ddEmtpyBlockDataType)block afterDelay:(NSTimeInterval)delay
{
	XRPerformDelayedBlockOnMainQueue(block, delay);
}

- (void)performBlockOnGlobalQueue:(ddEmtpyBlockDataType)block afterDelay:(NSTimeInterval)delay
{
	XRPerformDelayedBlockOnGlobalQueue(block, delay);
}

+ (void)performBlockOnMainThread:(ddEmtpyBlockDataType)block afterDelay:(NSTimeInterval)delay
{
	XRPerformDelayedBlockOnMainQueue(block, delay);
}

+ (void)performBlockOnGlobalQueue:(ddEmtpyBlockDataType)block afterDelay:(NSTimeInterval)delay
{
	XRPerformDelayedBlockOnGlobalQueue(block, delay);
}

- (void)performSelectorInCommonModes:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay
{
	[self performSelector:aSelector withObject:anArgument afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}

@end

NS_ASSUME_NONNULL_END
