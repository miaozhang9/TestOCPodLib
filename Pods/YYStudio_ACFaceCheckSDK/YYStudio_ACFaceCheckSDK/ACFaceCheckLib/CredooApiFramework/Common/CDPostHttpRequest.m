//
//  PostHttpRequest.m
//  ZYT
//
//  Created by test on 16/6/7.
//  Copyright © 2016年 xujialiang. All rights reserved.
//

#import "CDPostHttpRequest.h"

@implementation CDPostHttpRequest

- (void)generateTask {
    self.task = [[CDBaseRequestQueue sharedAuthRequestQueue] generatePostTaskWithRequest:self];
}

@end
