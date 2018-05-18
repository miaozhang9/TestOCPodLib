//
//  ACFaceCheckBundle.m
//  ACFaceCheckLib
//
//  Created by Miaoz on 2017/11/27.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "ACFaceCheckBundle.h"
NSString * const ACFaceCheckLibBundle_Key = @"ACFaceCheckLibBundle.bundle";
@implementation ACFaceCheckBundle

+ (NSBundle *)bundle{
    //NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:QHLoanDoorBundle_Key];
    NSString *bundlePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:ACFaceCheckLibBundle_Key];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
   
    return bundle;
}

+ (NSString *)filePath:(NSString *)fileName{
    return [self filePath:fileName type:nil];
}

+ (NSString *)filePath:(NSString *)fileName type:(NSString *)type{
    return [[self bundle] pathForResource:fileName ofType:type];
}

+ (UIImage *)imageNamed:(NSString *)imgName{
    return [UIImage imageNamed:imgName inBundle:[self bundle] compatibleWithTraitCollection:nil];
}

+ (NSDictionary *)infoPlist{
    NSString *dir = [self filePath:@"Info" type:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dir];
    return dict;
}

//+ (NSDictionary *)enviromentPlist{
//    NSString *dir = [self filePath:@"enviroment" type:@"plist"];
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dir];
//    return dict;
//}

@end
