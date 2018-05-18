//
//  ACAppointTimeView.m
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/8.
//  Copyright © 2018年  All rights reserved.
//

#import "ACAppointTimeView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Addtion.h"
#import "UIFont+Addtion.h"
#import "ACAppConstant.h"
#import "ACAvailableListDTO.h"
#import "NSDate+Addtion.h"
#import "IPAInternetSpeedTools.h"

static NSString *cellID = @"ACAppointTimeCell";

@interface ACAppointTimeView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation ACAppointTimeView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.listView registerClass:[ACAppointTimeCell class] forCellReuseIdentifier:cellID];
    }
    return self;
}

- (void)updateDataArray:(NSArray *)timeArray {
    self.timeArr = timeArray;
    self.listView.contentOffset = CGPointMake(0, 0);
   
    [self.listView reloadData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeArr ? self.timeArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        ACAppointTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        ACAvailableDTO *dto = self.timeArr[indexPath.row];
        [cell updateAppointItem:dto];
    
   
        __weak typeof(self) weakSelf = self;
        cell.timeCellappointCallBackBlcok = ^(BOOL isSuccess, ACAvailableDTO *dto) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.timeViewAppointCallBackBlcok) {
                strongSelf.timeViewAppointCallBackBlcok(true, dto);
            }
        };
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
        ACAvailableDTO *dto = self.timeArr[indexPath.row];
        if (![dto.isPassToday isEqualToString:@"1"]) {
            if ([dto.availablecount integerValue] > 0) {
             
                _selectIndexPath = indexPath;
                [tableView reloadData];
            }
        }
}


- (UITableView *)listView {
    if (!_listView) {
        self.listView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.delegate = self;
        _listView.dataSource = self;
//        _listView.bounces = NO;
    }
    return _listView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@interface ACAppointTimeCell ()
@property (nonatomic, strong) UILabel *timeLb;
//@property (nonatomic, strong) UILabel *numLb;
@property (nonatomic, strong) ACAppointTimeCellDescribeView *describeNumView;
@property (nonatomic, strong) UIButton *appointButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong)ACAvailableDTO *dto;

@end

@implementation ACAppointTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        [self initAndModifySubviews];
    }
    return self;
}

- (void)initAndModifySubviews {
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.describeNumView];
    [self.contentView addSubview:self.appointButton];
    [self.contentView addSubview:self.lineView];
    
    __weak typeof(self) weakSelf = self;
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(@14);
    }];
    
   
    
    [_appointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-14);
         make.centerY.equalTo(weakSelf.timeLb);
        make.size.mas_equalTo(CGSizeMake(80*kWScale, 25*kWScale));
    }];
    
    [_describeNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.timeLb);
        make.width.equalTo(@85);
        make.right.equalTo(weakSelf.appointButton.mas_left).offset(kWScale * -14);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}


- (void)updateAppointItem:(ACAvailableDTO *)dto  {

    self.dto = dto;

    _timeLb.text = [NSString stringWithFormat:@"%@ - %@", dto.starttime, dto.endtime];
    if ( dto.availablecount.integerValue > 0 && dto.availablecount.integerValue <= 5) {
        _describeNumView.hidden = NO;
         _describeNumView.numLb.text = [NSString stringWithFormat:@"%ld", (long)dto.availablecount.integerValue];
    } else {
         _describeNumView.hidden = YES;
        _describeNumView.numLb.text = @"0";
    }

    if ([dto.isPassToday isEqualToString:@"1"]) {
        
        [_appointButton setTitle:@"预约" forState:UIControlStateNormal];
        [self unCapableAppointState];
    } else if ([dto.availablecount integerValue] == 0) {
            [_appointButton setTitle:@"已满" forState:UIControlStateNormal];
            [self unCapableAppointState];
            _appointButton.enabled = YES;
           
        } else {
            [_appointButton setTitle:@"预约" forState:UIControlStateNormal];
            [self capableAppointState];
        }

}

- (void)capableAppointState {
    _appointButton.enabled = YES;
     _appointButton.backgroundColor = [UIColor whiteColor];
    [_appointButton setTitleColor:[UIColor pc_colorWithHexString:Color2363FF] forState:UIControlStateNormal];
//    [_appointButton setTitle:@"预约" forState:UIControlStateNormal];
    _appointButton.layer.borderColor = [UIColor pc_colorWithHexString:Color2363FF].CGColor;
}

- (void)unCapableAppointState {
     _appointButton.enabled = NO;
     _appointButton.backgroundColor = [UIColor pc_colorWithHexString:ColorEEEEEE];
    [_appointButton setTitleColor:[UIColor pc_colorWithHexString:Color999999] forState:UIControlStateNormal];
//    [_appointButton setTitle:@"已满" forState:UIControlStateNormal];
    _appointButton.layer.borderColor = [UIColor pc_colorWithHexString:ColorEEEEEE].CGColor;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        self.timeLb = [[UILabel alloc] init];
        _timeLb.font = [UIFont pingFangSCRegularWithSize:20*kWScale];
        _timeLb.textColor = [UIColor pc_colorWithHexString:Color4a4a4a];
        _timeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLb;
}

- (ACAppointTimeCellDescribeView *)describeNumView {
    if (!_describeNumView) {
        self.describeNumView = [[ACAppointTimeCellDescribeView alloc] init];
    }
    return _describeNumView;
}

- (UIButton *)appointButton {
    if (!_appointButton) {
        self.appointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _appointButton.backgroundColor = [UIColor whiteColor];
         [_appointButton setTitleColor:[UIColor pc_colorWithHexString:Color2363FF] forState:UIControlStateNormal];
        [_appointButton setTitle:@"预约" forState:UIControlStateNormal];
        _appointButton.titleLabel.font = [UIFont pingFangSCRegularWithSize:14 * kWScale];
        _appointButton.layer.borderColor = [UIColor pc_colorWithHexString:Color2363FF].CGColor;
        _appointButton.layer.borderWidth = 1.0;
        _appointButton.layer.cornerRadius = 12.5 * kWScale;
        _appointButton.layer.masksToBounds = YES;
        [_appointButton addTarget:self action:@selector(appointClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointButton;
    
}
- (UIView *)lineView {
    if (!_lineView) {
        self.lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor pc_colorWithHexString:ColorD8D8D8];
    }
    return _lineView;
}

#pragma make --event
- (void)appointClick:(UIButton *)sender {
    
    if (_timeCellappointCallBackBlcok) {
        _timeCellappointCallBackBlcok(true,self.dto);
    }
}


@end


@interface ACAppointTimeCellDescribeView ()
@property (nonatomic, strong) UILabel *leftLb;

@property (nonatomic, strong) UILabel *rightLb;


@end
@implementation ACAppointTimeCellDescribeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAndModifySubviews];
    }
    return self;
}

#pragma mark - private
- (void)initAndModifySubviews {
    [self addSubview:self.leftLb];
    [self addSubview:self.numLb];
    [self addSubview:self.rightLb];
    
    
    __weak typeof(self) weakself = self;
    
    [_leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself);
        make.centerY.equalTo(weakself);
    }];
   
    
    [_numLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.leftLb.mas_right).offset(2);
        make.centerY.equalTo(weakself);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.numLb.mas_right).offset(2);
        make.centerY.equalTo(weakself);
    }];
    
  
    
}

#pragma mark -setter&gettter
- (UILabel *)leftLb {
    if (!_leftLb) {
        self.leftLb = [[UILabel alloc] init];
        _leftLb.font = [UIFont pingFangSCRegularWithSize:12];
        _leftLb.textColor = [UIColor pc_colorWithHexString:Color999999];
        _leftLb.textAlignment = NSTextAlignmentRight;
        _leftLb.text = @"仅剩";
    }
    return _leftLb;
}
- (UILabel *)numLb {
    if (!_numLb) {
        self.numLb = [[UILabel alloc] init];
        _numLb.font = [UIFont pingFangSCRegularWithSize:12];
        _numLb.textColor = [UIColor whiteColor];
        _numLb.textAlignment = NSTextAlignmentCenter;
        _numLb.backgroundColor = [UIColor pc_colorWithHexString:ColorFF991D];
        _numLb.layer.cornerRadius = 10;
        _numLb.layer.masksToBounds = YES;
        _numLb.text = @"0";
    }
    return _numLb;
}
- (UILabel *)rightLb {
    if (!_rightLb) {
        self.rightLb = [[UILabel alloc] init];
        _rightLb.font = [UIFont pingFangSCRegularWithSize:12];
        _rightLb.textColor = [UIColor pc_colorWithHexString:Color999999];
        _rightLb.textAlignment = NSTextAlignmentRight;
        _rightLb.text = @"个席位";
    }
    return _rightLb;
}
@end


