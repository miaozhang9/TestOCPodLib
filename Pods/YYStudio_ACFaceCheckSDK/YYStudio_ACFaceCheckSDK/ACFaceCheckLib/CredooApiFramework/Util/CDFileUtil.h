
//
//  FileUtil.h
//  Helper Functions and Classes for Ordinary Application Development on iPhone
//
//  Created by Chenny Shan
//

#pragma once
#import <Foundation/Foundation.h>


@interface CDFileUtil : NSObject {

}

typedef enum _PathType {
	PathTypeLibrary,
	PathTypeCaches,
	PathTypeDocument,
	PathTypeResource,
	PathTypeBundle,
	PathTypeTemp,
} PathType;


+ (NSString*)pathForPathType:(PathType)type;

+ (NSString*)pathOfFile:(NSString*)filename withPathType:(PathType)type;

+ (BOOL)fileExistsAtPath:(NSString*)path;

+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory;

+ (BOOL)copyFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath;

+ (BOOL)moveFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath;

+ (BOOL)deleteFileAtPath:(NSString*)path;

+ (BOOL)createDirectoryAtPath:(NSString *)path withAttributes:(NSDictionary*)attributes;

+ (BOOL)createFileAtPath:(NSString*)path withData:(NSData*)data andAttributes:(NSDictionary*)attr;

+ (NSData*)dataFromPath:(NSString*)path;

+ (NSArray*)contentsOfDirectoryAtPath:(NSString*)path;

+ (unsigned long long int)sizeOfFolderPath:(NSString *)path;

+ (unsigned long long int)sizeOfFileAtPath:(NSString*) filePath;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+(NSDate *)createdDateOfFile:(NSString *)filePath;

@end
