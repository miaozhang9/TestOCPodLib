//
//  ACAppointDateView.h
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/8.
//  Copyright © 2018年  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACAvailableListDTO.h"

typedef void(^AppointDateCallBackBlcok) (BOOL isSuccess, ACAvailableDayDTO *dto, NSIndexPath *indexPath);

@interface ACAppointDateView : UIView
@property (nonatomic, copy) AppointDateCallBackBlcok dateViewAppointCallBackBlcok;
- (void)updateDataArray:(NSArray *)dateArray selectIndexPath:(NSIndexPath *)indexPath;
@end

@interface ACAppointDateCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *describeLb;


- (void)selectState;
- (void)defaultState;
@end
