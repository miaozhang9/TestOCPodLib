//
//  IPAInternetSpeedTest.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/9/13.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "IPAInternetSpeedTest.h"
#import "ACEnviromentGlobal.h"
#import "IPAInternetSpeedTools.h"
@interface IPAInternetSpeedTest ()<NSURLSessionDownloadDelegate>
{
    int _second;
    MeasureBlock infoBlock;
    FinishMeasureBlock fmeasureBlock;
    NSTimeInterval lastTime;
    NSTimeInterval startTime;
}

/**
 *  session
 */
@property (nonatomic, strong) NSURLSession* urlSession;
/**
 *  下载任务
 */
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;

@property (copy, nonatomic) void (^faildBlock) (NSError *error);

@property (nonatomic,assign)NSInteger tag;

@end


@implementation IPAInternetSpeedTest

/**
 *  初始化测速方法
 *
 *  @param measureBlock       实时返回测速信息
 *  @param finishMeasureBlock 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock:(MeasureBlock)measureBlock finishMeasureBlock:(FinishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock
{
    self = [super init];
    if (self) {
        infoBlock = measureBlock;
        fmeasureBlock = finishMeasureBlock;
        _faildBlock = failedBlock;
    }
    return self;
}

/**
 *  开始测速
 */
-(void)startMeasur
{
    self.tag = 0;
    // 创建任务
    //暂时删除
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:kInternetSpeedTestURL]];
    // 开始任务
    [self.downloadTask resume];
    lastTime = [NSDate date].timeIntervalSinceReferenceDate;
    startTime = lastTime;
}

#pragma mark -- NSURLSessionDownloadDelegate
/**
 *  下载完毕会调用
 *
 *  @param location     文件临时地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{

}

/**
 *  每次写入沙盒完毕调用
 *  在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
 *
 *  @param bytesWritten              这次写入的大小
 *  @param totalBytesWritten         已经写入沙盒的大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.tag == 0) {
        startTime = [NSDate date].timeIntervalSinceReferenceDate;
        self.tag++;
    }
    NSTimeInterval curTime = [NSDate date].timeIntervalSinceReferenceDate;
    infoBlock(bytesWritten / (curTime - lastTime));
    lastTime = curTime;
    
    if (totalBytesWritten == totalBytesExpectedToWrite) {

        fmeasureBlock(totalBytesWritten / (lastTime - startTime));
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        if (self.faildBlock) {
            self.faildBlock(error);
        }
    }
}

- (void)dealloc
{
    NSLog(@"MeasurNetTools dealloc");
}

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _urlSession;
}

@end
