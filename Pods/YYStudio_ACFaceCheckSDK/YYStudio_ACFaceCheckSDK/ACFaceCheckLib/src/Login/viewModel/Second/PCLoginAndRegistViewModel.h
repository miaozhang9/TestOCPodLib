//
//  PCLoginAndRegistViewModel.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCCaptchaViewModel.h"
#import "PCImgCaptchaDTO.h"
#import "ACAvailableListDTO.h"

@interface PCLoginAndRegistViewModel : PCCaptchaViewModel

//@property (nonatomic, strong) RACCommand *confirmCommand;

// mock Data
- (ACAvailableListDTO *)getSchedules;

-(void)getUserLevelRequesSignalsuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;

@end
