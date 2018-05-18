//
//  IPAInternetSpeedTools.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/9/13.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

// main screen's scale
#ifndef ACNScreenScale
#define ACNScreenScale [IPAInternetSpeedTools acn_screenScale]
#endif

// main screen's size (portrait)
#ifndef ACNScreenSize
#define ACNScreenSize [IPAInternetSpeedTools acn_screenSize]
#endif

// main screen's width (portrait)
#ifndef ACNScreenWidth
#define ACNScreenWidth [IPAInternetSpeedTools acn_screenSize].width
#endif

// main screen's height (portrait)
#ifndef ACNScreenHeight
#define ACNScreenHeight [IPAInternetSpeedTools acn_screenSize].height
#endif

@interface IPAInternetSpeedTools : NSObject

+ (unsigned long long) antiFormatBandWith:(NSString *)sizeStr;
+ (NSString *)formattedFileSize:(unsigned long long)size;
//suffixLenth 单位字符串长度
+ (NSString *)formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length;
+ (NSString *)formattedBandWidth:(unsigned long long)size;
+ (NSString *)formatBandWidth:(unsigned long long)size;
+ (int)formatBandWidthInt:(unsigned long long) size;

+ (CGFloat)acn_screenScale;
+ (CGSize)acn_screenSize;

@end
