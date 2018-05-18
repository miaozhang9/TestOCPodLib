//
//  ACFaceCheckBundle.h
//  ACFaceCheckLib
//
//  Created by Miaoz on 2017/11/27.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACFaceCheckBundle : NSObject

+ (NSBundle *)bundle;

+ (NSString *)filePath:(NSString *)fileName;

+ (NSString *)filePath:(NSString *)fileName type:(NSString *)type;

+ (UIImage *)imageNamed:(NSString *)imgName;

+ (NSDictionary *)infoPlist;

//+ (NSDictionary *)enviromentPlist;

@end
