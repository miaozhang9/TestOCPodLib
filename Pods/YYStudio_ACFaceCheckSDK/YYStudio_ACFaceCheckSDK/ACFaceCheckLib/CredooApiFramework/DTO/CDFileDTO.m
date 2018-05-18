//
//  ZYTFileDTO.m
//  ZYT
//
//  Created by 易愿 on 16/8/24.
//  Copyright © 2016年 xujialiang. All rights reserved.
//

#import "CDFileDTO.h"

NSString const *kImageJPG = @"jpg";

@implementation CDZYTFileDTO

- (NSString *)fileAbsolutePath {
    if (!self.filePath.length) {
        return @"";
    }
    NSString *directory = [NSSearchPathForDirectoriesInDomains(self.rootPathDirectory, NSUserDomainMask, YES) firstObject];
    return [directory stringByAppendingString:self.filePath];
}

@end
