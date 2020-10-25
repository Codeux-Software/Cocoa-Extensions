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

@implementation NSFileManager (CSFileManagerHelper)

- (nullable id <NSObject, NSCopying, NSCoding>)cloudUbiquityIdentityToken
{
	return self.ubiquityIdentityToken;
}

- (BOOL)fileExistsAtURL:(NSURL *)url
{
	NSParameterAssert(url != nil);

	return [self fileExistsAtPath:url.path];
}

- (BOOL)directoryExistsAtURL:(NSURL *)url
{
	NSParameterAssert(url != nil);

	return [self directoryExistsAtPath:url.path];
}

- (BOOL)directoryExistsAtPath:(NSString *)path
{
	NSParameterAssert(path != nil);

	BOOL isDirectory = NO;

	BOOL existsResult = [self fileExistsAtPath:path isDirectory:&isDirectory];

	return (existsResult && isDirectory);
}

- (BOOL)lockItemAtPath:(NSString *)path error:(NSError **)error
{
	NSParameterAssert(path != nil);

	NSDictionary *newattrs = @{NSFileImmutable : @(YES)};

	return [self setAttributes:newattrs	ofItemAtPath:path error:error];
}

- (BOOL)unlockItemAtPath:(NSString *)path error:(NSError **)error
{
	NSParameterAssert(path != nil);

	NSDictionary *newattrs = @{NSFileImmutable : @(NO)};

	return [self setAttributes:newattrs	ofItemAtPath:path error:error];
}

- (NSArray<NSString *> *)buildPathArrayWithPaths:(NSArray<NSString *> *)paths
{
	NSParameterAssert(paths != nil);

	NSMutableArray<NSString *> *pathData = [NSMutableArray array];

	for (id pathObject in paths) {
		if ([pathObject isKindOfClass:[NSString class]] == NO) {
			continue;
		}

		if ([pathObject length] == 0) {
			continue;
		}

		BOOL isDirectory = NO;

		BOOL pathExists = [self fileExistsAtPath:pathObject isDirectory:&isDirectory];

		if (pathExists && isDirectory) {
			[pathData addObject:pathObject];
		}
	}

	return [pathData copy];
}

- (NSArray<NSString *> *)buildPathArray:(NSString *)path, ...
{
	NSParameterAssert(path != nil);

	NSMutableArray<NSString *> *pathObjects = [NSMutableArray array];

	if ( path) {
		[pathObjects addObject:path];
	}

	id pathObj = nil;

	va_list args;
	va_start(args, path);

	while ((pathObj = va_arg(args, id))) {
		[pathObjects addObject:pathObj];
	}

	va_end(args);

	return [self buildPathArrayWithPaths:pathObjects];
}

- (BOOL)isUbiquitousItemAtPathDownloaded:(NSString *)path
{
	NSParameterAssert(path != nil);

	NSURL *fileURL = [NSURL fileURLWithPath:path];

	/* Check whether the given path is ubiquitous */
	NSError *isUbiquitousError = nil;

	NSNumber *isUbiquitous = [fileURL resourceValueForKey:NSURLIsUbiquitousItemKey error:&isUbiquitousError];

	if (isUbiquitous == nil || isUbiquitous.boolValue == NO) {
		if (isUbiquitousError) {
			LogToConsoleErrorWithSubsystem(_CSFrameworkInternalLogSubsystem(),
				"isUbiquitous lookup failed: '%@': %@",
				path, isUbiquitousError.localizedDescription);
			LogStackTraceWithSubsystem(_CSFrameworkInternalLogSubsystem());

			return NO;
		} else {
			/* If an error did not occur looking up status for a path, but
			 the path is not ubiquitous, then we return YES anyways. */
			/* YES will indicate the file is downloaded and since the file
			 is not ubiquitous, it is in fact downloaded. */
			LogToConsoleDebugWithSubsystem(_CSFrameworkInternalLogSubsystem(),
				"Returning YES for path that is not ubiquitous: '%@'",
				path);

			return YES;
		}
	}

	/* If the path is a directory, then check each file in the directory and
	 stop if there is at least one file that is not downloaded. */
	/* The reason its done like this is because when the key
	 NSURLUbiquitousItemDownloadingStatusKey was checked for on directories,
	 it always returned nil. That means having to scan each file in each
	 subdirectory was the only option. */
	NSError *isDirectoryError = nil;

	NSNumber *isDirectory = [fileURL resourceValueForKey:NSURLIsDirectoryKey error:&isDirectoryError];

	if (isDirectory == nil)
	{
		if (isDirectoryError) {
			LogToConsoleErrorWithSubsystem(_CSFrameworkInternalLogSubsystem(),
				"isDirectory lookup failed: '%@': %@", path,
			     isDirectoryError.localizedDescription);
			LogStackTraceWithSubsystem(_CSFrameworkInternalLogSubsystem());
		}

		return NO;
	}
	else if (isDirectory.boolValue)
	{
		NSError *directoryContentsError = nil;

		NSArray *directoryContents = [self contentsOfDirectoryAtPath:path error:&directoryContentsError];

		if (directoryContents == nil) {
			LogToConsoleErrorWithSubsystem(_CSFrameworkInternalLogSubsystem(),
				"directoryContents returned nil: '%@': %@",
				 path, directoryContentsError.localizedDescription);
			LogStackTraceWithSubsystem(_CSFrameworkInternalLogSubsystem());

			return NO;
		}

		for (NSString *file in directoryContents) {
			NSString *filePath = [path stringByAppendingPathComponent:file];

			if ([self isUbiquitousItemAtPathDownloaded:filePath] == NO) {
				return NO;
			}
		}

		return YES;
	}

	/* Check download status for a file */
	NSError *isDownloadedError = nil;

	BOOL isDownloaded = YES;

	NSString *_isDownloaded = [fileURL resourceValueForKey:NSURLUbiquitousItemDownloadingStatusKey error:&isDownloadedError];

	if (_isDownloaded) {
		 isDownloaded = (NSObjectsAreEqual(_isDownloaded, NSURLUbiquitousItemDownloadingStatusDownloaded) ||
						 NSObjectsAreEqual(_isDownloaded, NSURLUbiquitousItemDownloadingStatusCurrent));
	}

	if (isDownloadedError) {
		LogToConsoleErrorWithSubsystem(_CSFrameworkInternalLogSubsystem(),
			"isDownloaded lookup failed: '%@': %@",
			path, isDownloadedError.localizedDescription);
		LogStackTraceWithSubsystem(_CSFrameworkInternalLogSubsystem());
	}

	return isDownloaded;
}

- (BOOL)replaceItemAtPath:(NSString *)destinationPath withItemAtPath:(NSString *)sourcePath
{
	return [self replaceItemAtPath:destinationPath
					withItemAtPath:sourcePath
				 moveToDestination:NO
			moveDestinationToTrash:YES];
}

- (BOOL)replaceItemAtPath:(NSString *)destinationPath
		   withItemAtPath:(NSString *)sourcePath
   moveDestinationToTrash:(BOOL)moveDestinationToTrash
{
	return [self replaceItemAtPath:destinationPath
					withItemAtPath:sourcePath
				 moveToDestination:NO
			moveDestinationToTrash:moveDestinationToTrash];
}

- (BOOL)replaceItemAtPath:(NSString *)destinationPath
		   withItemAtPath:(NSString *)sourcePath
		moveToDestination:(BOOL)moveToDestination
   moveDestinationToTrash:(BOOL)moveDestinationToTrash
{
	if (sourcePath == nil || destinationPath == nil) {
		return NO;
	}

	return [self replaceItemAtURL:[NSURL fileURLWithPath:destinationPath]
					withItemAtURL:[NSURL fileURLWithPath:sourcePath]
				moveToDestination:moveToDestination
		   moveDestinationToTrash:moveDestinationToTrash];
}

- (BOOL)replaceItemAtURL:(NSURL *)destinationURL withItemAtURL:(NSURL *)sourceURL
{
	return [self replaceItemAtURL:destinationURL
					withItemAtURL:sourceURL
				moveToDestination:NO
		   moveDestinationToTrash:YES];
}

- (BOOL)replaceItemAtURL:(NSURL *)destinationURL
		   withItemAtURL:(NSURL *)sourceURL
  moveDestinationToTrash:(BOOL)moveDestinationToTrash
{
	return [self replaceItemAtURL:destinationURL
					withItemAtURL:sourceURL
				moveToDestination:NO
		   moveDestinationToTrash:moveDestinationToTrash];
}

- (BOOL)replaceItemAtURL:(NSURL *)destinationURL
		   withItemAtURL:(NSURL *)sourceURL
	   moveToDestination:(BOOL)moveToDestination
  moveDestinationToTrash:(BOOL)moveDestinationToTrash
{
	/* Check URLs */
	if ((sourceURL == nil || sourceURL.fileURL == NO) ||
		(destinationURL == nil || destinationURL.fileURL == NO))
	{
		return NO;
	}

	/* Remove destination if it exists */
	if ([self fileExistsAtURL:destinationURL]) {
		NSError *removeFileError = nil;

		BOOL removeResult = NO;

		if (moveDestinationToTrash) {
			removeResult = [self trashItemAtURL:destinationURL resultingItemURL:NULL error:&removeFileError];
		} else {
			removeResult = [self removeItemAtURL:destinationURL error:&removeFileError];
		}

		if (removeResult == NO) {
			LogToConsoleErrorWithSubsystem(_CSFrameworkInternalLogSubsystem(),
				"Failed to remove file at destination: '%@': %@",
				[destinationURL path], removeFileError.localizedDescription);
			LogStackTraceWithSubsystem(_CSFrameworkInternalLogSubsystem());

			return NO;
		}
	}

	/* Perform copy operation */
	BOOL copyResult = NO;

	NSError *copyFileError = nil;

	if (moveToDestination) {
		copyResult = [self moveItemAtURL:sourceURL toURL:destinationURL error:&copyFileError];
	} else {
		copyResult = [self copyItemAtURL:sourceURL toURL:destinationURL error:&copyFileError];
	}

	if (copyResult == NO) {
		LogToConsoleErrorWithSubsystem(_CSFrameworkInternalLogSubsystem(),
			"Failed to copy file to destination: '%@' -> '%@': %@",
			sourceURL.path, destinationURL.path, copyFileError.localizedDescription);
		LogStackTraceWithSubsystem(_CSFrameworkInternalLogSubsystem());

		return NO;
	}

	return YES;
}

@end

NS_ASSUME_NONNULL_END
