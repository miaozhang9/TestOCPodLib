//
//  PCChoiceAppointTimeListView.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACChoiceAppointTimeListView.h"

#import <Masonry/Masonry.h>
#import "UIColor+Addtion.h"
#import "ACAppConstant.h"
#import "ACAvailableListDTO.h"
#import "NSDate+Addtion.h"
#import "IPAInternetSpeedTools.h"

@interface ACChoiceAppointTimeListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, assign) ACChoiceAppointTimeViewType viewType;
@property (nonatomic, strong) NSArray *dayArr;
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation ACChoiceAppointTimeListView

- (instancetype)initWithFrame:(CGRect)frame viewType:(ACChoiceAppointTimeViewType)viewType {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = viewType;
        [self.listView registerClass:[ACChoiceAppointTimeDayCell class] forCellReuseIdentifier:@"ACChoiceAppointTimeDayCell"];
        [self.listView registerClass:[ACChoiceAppointTimeSlotCell class] forCellReuseIdentifier:@"ACChoiceAppointTimeSlotCell"];
        [self addSubview:self.listView];
        if (self.viewType == ACChoiceAppointTimeView_Day) {
            self.listView.backgroundColor = [UIColor pc_colorWithHexString:@"#F5F5F5"];
        } else {
            self.listView.backgroundColor = [UIColor pc_colorWithHexString:@"#FFFFFF"];
        }
    }
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewType == ACChoiceAppointTimeView_Day) {
        return self.dayArr.count;
    } else {
        return self.timeArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == ACChoiceAppointTimeView_Day) {
        ACChoiceAppointTimeDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACChoiceAppointTimeDayCell"];
        if ([_selectIndexPath isEqual:indexPath]) {
            [cell selectState];
        } else {
            [cell defaultState];
        }
        ACAvailableDayDTO *dto = self.dayArr[indexPath.row];
        if ([dto.isPassToday isEqualToString:@"1"]) {
            cell.titleLb.textColor = [UIColor pc_colorWithHexString:@"#9B9B9B"];
        }
        if ([NSDate isTodayWithTime:dto.appointdate]) {
            cell.titleLb.text = @"今日";
        } else if ([NSDate isTomorrowWithTime:dto.appointdate]) {
            cell.titleLb.text = @"明日";
        } else {
            cell.titleLb.text = [NSDate onlydateFormatterWithTime:dto.appointdate];
        }
        return cell;
    } else {
        ACChoiceAppointTimeSlotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACChoiceAppointTimeSlotCell"];
        ACAvailableDTO *dto = self.timeArr[indexPath.row];
        [cell updateAppointItem:dto];
        
        if ([dto.isPassToday isEqualToString:@"1"]) {
            [cell defaultState];
        } else {
            if ([_selectIndexPath isEqual:indexPath]) {
                [cell selectState];
            } else {
                [cell defaultState];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == ACChoiceAppointTimeView_Day) {
        if (_delegate && [_delegate respondsToSelector:@selector(choiceAppointTimeListView:appointDate:indexPath:)]) {
            [_delegate choiceAppointTimeListView:self.listView appointDate:self.dayArr[indexPath.row] indexPath:indexPath];
        }
        _selectIndexPath = indexPath;
        [tableView reloadData];
    } else {
        ACAvailableDTO *dto = self.timeArr[indexPath.row];
        if (![dto.isPassToday isEqualToString:@"1"]) {
            if ([dto.availablecount integerValue] > 0) {
                if (_delegate && [_delegate respondsToSelector:@selector(choiceAppointTimeListView:availableDTO:indexPath:)]) {
                    [_delegate choiceAppointTimeListView:self.listView availableDTO:dto indexPath:indexPath];
                }
                _selectIndexPath = indexPath;
                [tableView reloadData];
            }
        }
    }
}

#pragma mark -

- (void)updateDataArray:(NSArray *)arr selectIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == ACChoiceAppointTimeView_Day) {
        self.dayArr = arr;
    } else {
        self.timeArr = arr;
        self.listView.contentOffset = CGPointMake(0, 0);
    }
    _selectIndexPath = indexPath;
    [self.listView reloadData];
}

- (UITableView *)listView {
    if (!_listView) {
        self.listView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.bounces = NO;
    }
    return _listView;
}

@end

@implementation ACChoiceAppointTimeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initAndModifySubviews];
    }
    return self;
}

- (void)initAndModifySubviews {
    self.cancleBtn = [self createButtonWithTitle:@"取消"];
    self.sureBtn = [self createButtonWithTitle:@"确定"];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor pc_colorWithHexString:@"#C9C9C9"];
    [self addSubview:lineView];
    
    __weak typeof(self) weakSelf = self;
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(14);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.cancleBtn);
        make.right.mas_equalTo(-14);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor pc_colorWithHexString:@"#4A90E2"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:btn];
    return btn;
}


@end

@implementation ACChoiceAppointTimeDayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initAndModifySubviews];
    }
    return self;
}

- (void)initAndModifySubviews {
    [self.contentView addSubview:self.goldView];
    [self.contentView addSubview:self.titleLb];
    
    CGFloat padLeft = 0;
    if (ACNScreenWidth < 375.0) {
        padLeft = 12;
    } else {
        padLeft = 22;
    }
    __weak typeof(self) weakSelf = self;
    [_goldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padLeft);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
}

- (void)selectState {
    self.goldView.hidden = NO;
    _titleLb.textColor = [UIColor pc_colorWithHexString:@"#4A90E2"];
}

- (void)defaultState {
    self.goldView.hidden = YES;
    _titleLb.textColor = [UIColor pc_colorWithHexString:@"#4A4A4A"];
}

- (UIView *)goldView {
    if (!_goldView) {
        self.goldView = [[UIView alloc] init];
        _goldView.backgroundColor = [UIColor pc_colorWithHexString:@"#4A90E2"];
    }
    return _goldView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        self.titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor pc_colorWithHexString:@"#4A4A4A"];
    }
    return _titleLb;
}

@end


@interface ACChoiceAppointTimeSlotCell ()

@property (nonatomic, assign) CGFloat fontSize;

@end

@implementation ACChoiceAppointTimeSlotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        if (ACNScreenWidth < 375.0) {
            _fontSize = 12;
        } else {
            _fontSize = 14;
        }
        [self initAndModifySubviews];
    }
    return self;
}

- (void)initAndModifySubviews {
    self.timeLb = [self createLabelWithTextAlignment:NSTextAlignmentLeft];
    self.numLb = [self createLabelWithTextAlignment:NSTextAlignmentLeft];
    self.appointLb = [self createLabelWithTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.lineView];
    __weak typeof(self) weakSelf = self;
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(10);
    } ];
    [_numLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.timeLb);
        make.left.mas_equalTo(weakSelf.timeLb.mas_right).mas_offset(0);
    }];
    [_appointLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.timeLb);
        make.right.mas_equalTo(-14);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateAppointItem:(ACAvailableDTO *)dto {
    NSInteger num = [dto.availablecount integerValue];
    NSInteger num1 = [dto.totalcount integerValue];
    NSInteger num2 = num1 - num;
    NSString *availableNum = [NSString stringWithFormat:@"%ld",num2];
    _timeLb.text = [NSString stringWithFormat:@"%@ - %@", dto.starttime, dto.endtime];
    _numLb.text = [NSString stringWithFormat:@"（%@／%@）", availableNum, dto.totalcount];
    
    if ([dto.isPassToday isEqualToString:@"1"]) {
        _appointLb.text = @"预约";
        [self unCapableAppointState];
    } else {
        if ([dto.availablecount integerValue] == 0) {
            _appointLb.text = @"已满";
            [self unCapableAppointState];
        } else {
            _appointLb.text = @"预约";
            [self capableAppointState];
        }
    }
}

- (void)selectState {
    self.contentView.backgroundColor = [UIColor pc_colorWithHexString:@"#F5F5F5"];
}

- (void)defaultState {
    self.contentView.backgroundColor = [UIColor pc_colorWithHexString:@"#FFFFFF"];
}

- (void)capableAppointState {
    _timeLb.textColor = [UIColor pc_colorWithHexString:@"#4A4A4A"];
    _numLb.textColor = [UIColor pc_colorWithHexString:@"#4A90E2"];
    _appointLb.textColor = [UIColor pc_colorWithHexString:@"#4A90E2"];
}

- (void)unCapableAppointState {
    _timeLb.textColor = [UIColor pc_colorWithHexString:@"#C9C9C9"];
    _numLb.textColor = [UIColor pc_colorWithHexString:@"#C9C9C9"];
    _appointLb.textColor = [UIColor pc_colorWithHexString:@"#C9C9C9"];
}

- (UILabel *)createLabelWithTextAlignment:(NSTextAlignment)textAlignment {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:self.fontSize];
    lb.textAlignment = textAlignment;
    [self.contentView addSubview:lb];
    return lb;
}

- (UIView *)lineView {
    if (!_lineView) {
        self.lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor pc_colorWithHexString:@"#C9C9C9"];
    }
    return _lineView;
}

@end
