//
//  IPAInternetSpeedTest.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/9/13.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MeasureBlock) (long speed);
typedef void (^FinishMeasureBlock) (long speed);

@interface IPAInternetSpeedTest : NSObject


/**
 *  初始化测速方法
 *
 *  @param measureBlock       实时返回测速信息
 *  @param finishMeasureBlock 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock:(MeasureBlock)measureBlock finishMeasureBlock:(FinishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock;

/**
 *  开始测速
 */
-(void)startMeasur;

@end
