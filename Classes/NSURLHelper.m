/* *********************************************************************
 *
 *         Copyright (c) 2016 - 2020 Codeux Software, LLC
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

@implementation NSURL (CSURLHelper)

- (nullable id)resourceValueForKey:(NSString *)key
{
	NSParameterAssert(key != nil);

	return [self resourceValueForKey:key error:nil];
}

- (nullable id)resourceValueForKey:(NSString *)key error:(NSError **)error
{
	NSParameterAssert(key != nil);

	id resourceValue = nil;

	if ([self getResourceValue:&resourceValue forKey:key error:error] == NO) {
		return nil;
	}

	return resourceValue;
}

- (BOOL)isEqualByFileRepresentation:(NSURL *)url
{
	NSParameterAssert(url != nil);
	NSParameterAssert(url.isFileURL);

	const char *left = self.fileSystemRepresentation;
	const char *right = url.fileSystemRepresentation;

	return (strcmp(left, right) == 0);
}

@end

#pragma mark -

@implementation NSArray (CSURLHelper)

+ (NSArray<NSString *> *)pathsArrayForFileURLs:(NSArray<NSURL *> *)fileURLs
{
	NSParameterAssert(fileURLs != nil);

	return [fileURLs arrayByApplyingBlock:^NSString *(NSURL *url, NSUInteger index, BOOL *stop) {
		NSAssert(url.isFileURL, @"URL '%@' is not a file.", url);

		return url.path;
	}];
}

@end

NS_ASSUME_NONNULL_END
