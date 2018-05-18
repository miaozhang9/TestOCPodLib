
//
//  FileUtil.h
//  Helper Functions and Classes for Ordinary Application Development on iPhone
//
//  Created by Chenny Shan
//

#import "CDFileUtil.h"
#import <sys/xattr.h>
#import <UIKit/UIKit.h>

@implementation CDFileUtil

#pragma mark -
#pragma mark file-related functions

+ (NSString*)pathForPathType:(PathType)type
{
	NSSearchPathDirectory directory;
	switch(type)
	{
		case PathTypeDocument:
			directory = NSDocumentDirectory;
			break;
		case PathTypeLibrary:
			directory = NSLibraryDirectory;
			break;
		case PathTypeCaches:
			directory = NSCachesDirectory;
			break;
		case PathTypeBundle:
			return [[NSBundle mainBundle] bundlePath];
			break;
		case PathTypeResource:
			return [[NSBundle mainBundle] resourcePath];
			break;
		case PathTypeTemp:
			return NSTemporaryDirectory();
			break;
		default:
			return nil;
	}
	NSArray* directories = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
	if(directories != nil && [directories count] > 0)
		return [directories objectAtIndex:0];
	return nil;
}

+ (NSString*)pathOfFile:(NSString*)filename withPathType:(PathType)type
{
	return [[self pathForPathType:type] stringByAppendingPathComponent:filename];
}

+ (BOOL)fileExistsAtPath:(NSString*)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
	return [manager fileExistsAtPath:path];
}

+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
	return [manager fileExistsAtPath:path isDirectory:isDirectory];
}

+ (BOOL)copyFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
	NSError* error;
    NSFileManager *manager = [NSFileManager defaultManager];
	BOOL result = [manager copyItemAtPath:srcPath toPath:dstPath error:&error];
    if (!result) {
        NSLog(@"Copy error:%@", [error localizedDescription]);
    }
    return result;
}

+ (BOOL)moveFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
	NSError* error;
    NSFileManager *manager = [NSFileManager defaultManager];
	BOOL result = [manager moveItemAtPath:srcPath toPath:dstPath error:&error];
    if (!result) {
        NSLog(@"Move error:%@", [error localizedDescription]);
    }
    return result;
}

+ (BOOL)deleteFileAtPath:(NSString*)path
{
	NSError* error;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result = [manager removeItemAtPath:path error:&error];
    if (!result) {
        NSLog(@"Delete error:%@", [error localizedDescription]);
    }
	return result;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path withAttributes:(NSDictionary*)attributes
{
	NSError* error;
    NSFileManager *manager = [NSFileManager defaultManager];
	BOOL result = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:attributes error:&error];
    if (!result) {
        NSLog(@"Create dir error:%@", [error localizedDescription]);
    }
    return result;
}

+ (BOOL)createFileAtPath:(NSString*)path withData:(NSData*)data andAttributes:(NSDictionary*)attr
{
    NSFileManager *manager = [NSFileManager defaultManager];
	return [manager createFileAtPath:path contents:data attributes:attr];
}

+ (NSData*)dataFromPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
	return [manager contentsAtPath:path];
}

+ (NSArray*)contentsOfDirectoryAtPath:(NSString*)path
{
	NSError* error;
    NSFileManager *manager = [NSFileManager defaultManager];
	return [manager contentsOfDirectoryAtPath:path error:&error];
}

//referenced: http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
+ (unsigned long long int)sizeOfFolderPath:(NSString *)path
{
    unsigned long long int totalSize = 0;
    
    NSFileManager *manager = [NSFileManager defaultManager];
	NSEnumerator* enumerator = [[manager subpathsOfDirectoryAtPath:path error:nil] objectEnumerator];	
    NSString* fileName;
    while(fileName = [enumerator nextObject])
	{
		totalSize += [[manager attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil] fileSize];
    }
	
    return totalSize;	
}

+ (unsigned long long int) sizeOfFileAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    BOOL flag = NO;
    
    NSString *path = [URL path];
    if ([CDFileUtil fileExistsAtPath:path]) {
        NSString *version = [[UIDevice currentDevice] systemVersion];
        NSComparisonResult comparison51 = [version compare:@"5.1" options:NSCaseInsensitiveSearch];
        if (NSOrderedSame == comparison51 || NSOrderedDescending == comparison51) { // version >= 5.1
            NSError *error = nil;
            flag = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
            if(!flag){
                NSLog(@"Error excluding %@ from backup %@", path, error);
            }
        }
        else {
            NSComparisonResult comparison50 = [version compare:@"5.0" options:NSCaseInsensitiveSearch];
            if (NSOrderedDescending == comparison50) { // version > 5.0 && version < 5.1
                
                const char* filePath = [path fileSystemRepresentation];
                
                const char* attrName = "com.apple.MobileBackup";
                u_int8_t attrValue = 1;
                
                int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
                flag = (result == 0);
                if(!flag){
                    NSLog(@"addSkipBackupAttributeToItemAtURL(setxattr) failed: %@", path);
                }
            }
            else {  // version <= 5.0
            }
        }
    }
    
    return flag;
}

+(NSDate *)createdDateOfFile:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileModificationDate];
    }
    return [NSDate dateWithTimeIntervalSince1970:0];
}
@end
