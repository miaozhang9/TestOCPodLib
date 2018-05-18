//
//  ACAppointSelectorView.h
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/9.
//  Copyright © . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMyLastAppointDTO.h"
#import "ACAvailableListDTO.h"
@protocol  ACAppointSelectorDelegate <NSObject>

@required
/**
 确定选中预约日期后的回调
 @param availableDayDTO 预约日期实例
 @param availableDTO 预约当日时间段实例
 */
- (void)confirmAppointSelectTime:(ACAvailableDayDTO *)availableDayDTO availableDTO:(ACAvailableDTO*)availableDTO;

@end

@interface ACAppointSelectorView : UIView
@property (nonatomic, weak) id <ACAppointSelectorDelegate> delegate;
@property(nonatomic,strong)ACMyLastAppointDTO *lastAppointDTO;
- (void)updateDataSource:(ACAvailableListDTO *)listDto;

@end

@interface ACAppointSelectorTitleView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@interface ACAppointSelectorNoteView : UIView
@property (nonatomic, strong) UILabel *noteLabel;

@end
