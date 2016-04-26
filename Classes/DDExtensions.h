
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

NS_ASSUME_NONNULL_BEGIN

typedef void (^ddEmtpyBlockDataType)(void);

@interface NSObject (DDExtensions)
- (nullable id)iomt COCOA_EXTENSIONS_DEPRECATED("Use -performBlockOnMainThread: instead."); // Invoke On Main Thread
- (nullable id)invokeOnThread:(NSThread *)thread COCOA_EXTENSIONS_DEPRECATED("This method will throw an exception if used. Use Grand Central Dispatch (GCD) instead.");
- (nullable id)invokeOnMainThread COCOA_EXTENSIONS_DEPRECATED("Use -performBlockOnMainThread: instead");
- (nullable id)invokeInBackgroundThread COCOA_EXTENSIONS_DEPRECATED("Use performBlockOnGlobalQueue: instead");
- (nullable id)invokeOnMainThreadAndWaitUntilDone:(BOOL)waitUntilDone COCOA_EXTENSIONS_DEPRECATED("Use -performBlockOnMainThread: instead");

- (void)performBlockOnMainThread:(ddEmtpyBlockDataType)block; // Performs a block synchronously (blocks) on the main thread
- (void)performBlockOnGlobalQueue:(ddEmtpyBlockDataType)block; // Performs a block asynchronously on a global queue with a normal priority. Does not block.

// ---

+ (nullable id)iomt COCOA_EXTENSIONS_DEPRECATED("Use -performBlockOnMainThread: instead."); // Invoke On Main Thread
+ (nullable id)invokeOnThread:(NSThread *)thread COCOA_EXTENSIONS_DEPRECATED("This method will throw an exception if used. Use Grand Central Dispatch (GCD) instead.");
+ (nullable id)invokeOnMainThread COCOA_EXTENSIONS_DEPRECATED("Use -performBlockOnMainThread: instead");
+ (nullable id)invokeInBackgroundThread COCOA_EXTENSIONS_DEPRECATED("Use performBlockOnGlobalQueue: instead");
+ (nullable id)invokeOnMainThreadAndWaitUntilDone:(BOOL)waitUntilDone COCOA_EXTENSIONS_DEPRECATED("Use -performBlockOnMainThread: instead");

+ (void)performBlockOnMainThread:(ddEmtpyBlockDataType)block;
+ (void)performBlockOnGlobalQueue:(ddEmtpyBlockDataType)block;
@end

NS_ASSUME_NONNULL_END
