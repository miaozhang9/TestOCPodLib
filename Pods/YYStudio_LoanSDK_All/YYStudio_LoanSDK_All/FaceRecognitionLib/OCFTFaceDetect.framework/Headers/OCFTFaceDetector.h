//
//  OCFTFaceDetector.h
//  OCFTFaceDetect
//
//  Created by PA on 2017/9/27.
//  Copyright © 2017年 Shanghai OneConnect Technology CO,LTD. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/*!
 * 检测失败类型
 */
typedef enum OCFTFaceDetectFailedType {
    
    OCFT_DISCONTINUIIY_ATTACK = 301,    //非连续性攻击（可理解为用户晃动过大）
    OCFT_CAMERA_AUTH_FAIL,              //相机权限获取失败
    OCFT_SDK_ERROR                      //SDK异常
    
} OCFTFaceDetectFailedType;


/**
 * 检测过程中的提示
 */
typedef enum OCFTFaceDetectOptimizationType {
    
    OCFT_DETECT_NORMAL = 101,                     // 正常
    
    OCFT_DETECT_NO_FACE,                          // 没有检测到人脸
    OCFT_DETECT_MULTIFACE,                        // 存在多人脸
    
    OCFT_DETECT_ERROR_YL,                         // 人脸太靠左
    OCFT_DETECT_ERROR_YR,                         // 人脸太靠右
    OCFT_DETECT_ERROR_PU,                         // 不能仰头
    OCFT_DETECT_ERROR_PD,                         // 不能低头
    
    OCFT_DETECT_ERROR_ROLL_LEFT,                  // 不能向左歪头
    OCFT_DETECT_ERROR_ROLL_RIGHT,                 // 不能向右歪头
    
    OCFT_DETECT_ERROR_DARK,                       // 光线太暗了
    OCFT_DETECT_ERROR_BRIGHT,                     // 光线太亮了
    OCFT_DETECT_ERROR_FUZZY,                      // 图像太模糊
    
    OCFT_DETECT_ERROR_CLOSE,                      // 人脸过于靠近
    OCFT_DETECT_ERROR_FAR,                        // 人脸过于靠远
    OCFT_DETECT_ERROR_ILLEGAL,                    // 存在换脸攻击
    
    OCFT_DETECT_STAYSTILL,                        // 请保持相对静止
    
} OCFTFaceDetectOptimizationType;

/*!
 * 检测动作类型
 */
typedef enum OCFTFaceDetectActionStep {
    OCFT_EyeBlink        = 200,
    OCFT_EyeBlink_FIRST  = 201,                   //完成第一次眨眼
    OCFT_EyeBlink_SECOND = 202,                   //完成第二次眨眼
    OCFT_EyeBlink_THREE  = 203,                   //完成第三次眨眼
    
}OCFTFaceDetectActionStep;

@interface OCFTFaceImageInfo : NSObject
@property (readonly) UIImage *targetImage;            /** 检测结果图片 */
@property (readonly) CGRect face_rect;                /** 人脸位置 */
@property (readonly) float yaw;                       /** 左右旋转弧度 */
@property (readonly) float pitch;                     /** 上下俯仰弧度 */
@property (readonly) float roll;                      /** 左右偏航弧度 */
@property (readonly) float blurness_motion;           /** 运动模糊程度 */
@property (readonly) float brightness;                /** 亮度 */
@property (readonly) float eyeDis;                    /** 两眼间距 */
@property (readonly) float liveType;                  /** 活体结果 */
@end

@interface OCFTFaceDetectionFrame : NSObject
@property (readonly) OCFTFaceImageInfo *faceImage;    /** 正脸图片 */

@end

@interface OCFTSDKInfo : NSObject
@property (readonly) NSString *version;               /** SDK版本号 **/
@end

@protocol OCFTFaceDetectProtocol <NSObject>
@required
-(void)onDetectionFailed:(OCFTFaceDetectFailedType)failedType;//识别失败回调
@required
-(void)onSuggestingOptimization:(OCFTFaceDetectOptimizationType)type;//辅助提示信息接口，主要包装一些附加功能（比如光线过亮／暗的提示），以便增强活体检测的质量
@required
-(void)onDetectionChangeAnimation:(OCFTFaceDetectActionStep)step options:(NSDictionary*)options;//提示用户做活体动作（options字段目前送入nil，该字段作为后续的拓展字段）
@required
-(void)onDetectionSuccess:(OCFTFaceDetectionFrame *)faceInfo;

- (void)onDetectionView:(UIView *)preView;
@optional
-(void)onStartDetectionAnimation:(OCFTFaceDetectActionStep)step options:(NSDictionary *)info;//表示已经开始活体检测info为预留字段，目前为nil

@end

@interface OCFTFaceDetector : NSObject
+ (instancetype)getDetectorWithDelegate:(id<OCFTFaceDetectProtocol>)delegate;//初始化SDK方法

/*
 开始检查方法会自动调用startCamera开启摄像头
 该方法可重复调用，reset状态
 */
- (void)startLiveness; // 开始检测
/*
 停止检查方法会自动调用stopCamera关闭摄像头
 动作检测完成后，会自动调用stopLiveness
 该方法适用于在检测途中，停止检测
 */
- (void)stopLiveness; // 停止检测

/*
 该方法使用场景适用于需要仅开始相机视图界面，而不进行活体检测
 */
- (void)startCamera;    // 开启摄像头
- (void)stopCamera;   // 停止摄像头

+ (OCFTSDKInfo *)getSDKInfo;//获取sdk信息
@end
