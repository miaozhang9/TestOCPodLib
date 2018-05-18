//
//  ACAppointSelectorView.m
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/9.
//  Copyright © . All rights reserved.
//

#import "ACAppointSelectorView.h"
#import "ACAppointDateView.h"
#import "ACAppointTimeView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Addtion.h"
#import "UIFont+Addtion.h"
#import "ACAppConstant.h"
#import "ACAvailableListDTO.h"
#import "NSDate+Addtion.h"
#import "NSString+Addtion.h"
#import "IPAInternetSpeedTools.h"


@interface ACAppointSelectorView ()
@property (nonatomic, strong) ACAppointSelectorTitleView *titleView;
@property (nonatomic, strong) ACAppointSelectorNoteView *noteView;
@property (nonatomic, strong) ACAppointDateView *dateView;
@property (nonatomic, strong) ACAppointTimeView *timeView;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) ACAvailableListDTO *listDto;
@end

@implementation ACAppointSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initAndModifySubviews];
        
        __weak typeof(self) weakSelf = self;
        
        self.dateView.dateViewAppointCallBackBlcok = ^(BOOL isSuccess, ACAvailableDayDTO *dto, NSIndexPath *indexPath) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.selectIndexPath = indexPath;
             [strongSelf.timeView updateDataArray:strongSelf.listDto.schedules[indexPath.row].slots];
        };
        
        self.timeView.timeViewAppointCallBackBlcok = ^(BOOL isSuccess, ACAvailableDTO *dto) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(confirmAppointSelectTime:availableDTO:)]) {
                [strongSelf.delegate confirmAppointSelectTime:strongSelf.listDto.schedules[strongSelf.selectIndexPath.row] availableDTO:dto];
            }
        };
        
    }
    return self;
}

#pragma mark - private

- (void)initAndModifySubviews {
    [self addSubview:self.titleView];
    [self addSubview:self.dateView];
    [self addSubview:self.noteView];
    [self addSubview:self.timeView];
    
    __weak typeof(self) weakSelf = self;
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(weakSelf);
        make.height.equalTo(@77);
    }];
    [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.and.right.equalTo(weakSelf.titleView);
         make.top.equalTo(weakSelf.titleView.mas_bottom).offset(0);
         make.height.equalTo(@70);
    }];
    [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.titleView);
        make.top.equalTo(weakSelf.dateView.mas_bottom).offset(0);
        make.height.equalTo(@26);
    }];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.titleView);
        make.top.equalTo(weakSelf.noteView.mas_bottom).offset(0);
        make.bottom.equalTo(weakSelf);
    }];
}
#pragma mark - public
- (void)updateDataSource:(ACAvailableListDTO *)listDto {
     _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    for (NSInteger i = 0; i < listDto.schedules.count; i++) {
        ACAvailableDayDTO *dto = listDto.schedules[i];
//        [self.appointDateArr addObject:dto];
        for (ACAvailableDTO *item in dto.slots) {
            item.isPassToday = dto.isPassToday;
        }
//        [self.slotsArr addObject:dto.slots];
    }
    
     self.listDto = listDto;
    
    if (self.listDto.schedules && self.listDto.schedules.count == 0){
        
        return;
    }
    
    if (self.listDto.schedules.count-1 < _selectIndexPath.section) {
        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.dateView updateDataArray:self.listDto.schedules selectIndexPath:_selectIndexPath];
    [self.timeView updateDataArray:self.listDto.schedules[_selectIndexPath.row].slots];

}


#pragma mark - setter and getter

- (ACAppointSelectorTitleView *)titleView {
    if (!_titleView) {
        self.titleView = [[ACAppointSelectorTitleView alloc] init];
    }
    return _titleView;
}

- (ACAppointDateView *)dateView {
    if (!_dateView) {
        self.dateView = [[ACAppointDateView alloc] init];
    }
    return _dateView;
}

- (ACAppointTimeView *)timeView {
    if (!_timeView) {
        self.timeView = [[ACAppointTimeView alloc] init];
    }
    return _timeView;
}

- (ACAppointSelectorNoteView *)noteView {
    if (!_noteView) {
        self.noteView = [[ACAppointSelectorNoteView alloc] init];
        _noteView.hidden = YES;
    }
    return _noteView;
}

- (void)setLastAppointDTO:(ACMyLastAppointDTO *)lastAppointDTO{
    _lastAppointDTO = lastAppointDTO;
    if ([_lastAppointDTO.isPassToday isEqualToString:@"1"]) {
        self.noteView.hidden = NO;
        self.noteView.noteLabel.text =  @"由于您未能在预约时间参与面核，请重新预约（今日时段已不可预约）";
          CGSize hintSize = [self.noteView.noteLabel.text pc_sizeForStringWithSize:CGSizeMake(ACNScreenWidth-14, 100) font:self.noteView.noteLabel.font];
        
        [self.noteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(hintSize.height + 5));
        }];

        
    } else {
        self.noteView.hidden = YES;
        [self.noteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
//    else if ( [_lastAppointDTO.appointupdate isEqualToString:@"1"]) {
//        NSString *start =[NSDate dateFormatterDayNomalWithTime:self.lastAppointDTO.starttime];
//        NSString *end =[NSDate dateFormatterTimeNomalWithTime:self.lastAppointDTO.endtime];
//        self.noteView.noteLabel.text =  [NSString stringWithFormat:@"注：已预约时段：%@-%@",start,end];
//    } else {
//        self.noteView.noteLabel.text =  [NSString stringWithFormat:@"注：请选择预约时间段"];
//    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation ACAppointSelectorTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initAndModifySubviews];
        
    }
    return self;
}

- (void)initAndModifySubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
    
     __weak typeof(self) weakSelf = self;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.top.equalTo(@6);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(@-15);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont pingFangSCMediumWithSize:24];
        _titleLabel.textColor = [UIColor pc_colorWithHexString:Color4a4a4a];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"预约面核时间";
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        self.descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont pingFangSCRegularWithSize:14];
        _descLabel.textColor = [UIColor pc_colorWithHexString:Color999999];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.text = @"预约成功，我们将以短信形式通知您。";
    }
    return _descLabel;
}

@end

@implementation ACAppointSelectorNoteView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:253/255.0 green:234/255.0 blue:232/255.0 alpha:1];
        [self initAndModifySubviews];
        
    }
    return self;
}

- (void)initAndModifySubviews {
    [self addSubview:self.noteLabel];

    __weak typeof(self) weakSelf = self;
    [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@0);
        make.top.and.bottom.equalTo(weakSelf);
//        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        self.noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = [UIColor clearColor];
        _noteLabel.font = [UIFont pingFangSCRegularWithSize:12];
        _noteLabel.numberOfLines = 0;
        _noteLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noteLabel.textColor = [UIColor pc_colorWithHexString:ColorF53420];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.text = @"注：用户预约时需要注意的提醒文案";
    }
    return _noteLabel;
}
@end
