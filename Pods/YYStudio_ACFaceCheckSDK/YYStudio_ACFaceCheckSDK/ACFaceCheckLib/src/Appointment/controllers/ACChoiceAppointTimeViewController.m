 //
//  PCChoiceAppointViewController.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACChoiceAppointTimeViewController.h"

#import <Masonry/Masonry.h>
#import "UIColor+Addtion.h"
#import "ACChoiceAppointTimeListView.h"

#define kDayWidth (115*kWScale)
#define kHeadheight 42
#define kRowNum 5

@interface ACChoiceAppointTimeViewController ()<ACChoiceAppointTimeListViewDelegate>

@property (nonatomic, strong) ACAvailableListDTO *listDto;

@property (nonatomic, strong) ACChoiceAppointTimeHeadView *headView;

@property (nonatomic, strong) ACChoiceAppointTimeListView *dayListView;
@property (nonatomic, strong) ACChoiceAppointTimeListView *timeListView;

@property (nonatomic, strong) NSMutableArray *appointDateArr;
@property (nonatomic, strong) NSMutableArray *slotsArr;

@property (nonatomic, copy) NSString *selectAppointDate;
@property (nonatomic, strong) ACAvailableDTO *selectAvailableDTO;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, weak) id<PCChoiceAppointTimeDelegate> delegate;

@end

@implementation ACChoiceAppointTimeViewController

- (instancetype)initWithAppointTimeDelegate:(id<PCChoiceAppointTimeDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor pc_colorWithHexString:@"#000000" alpha:0.4];
    [self createAndModifySubViews];
}

#pragma mark - private

- (void)createAndModifySubViews {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.dayListView];
    [self.view addSubview:self.timeListView];
    
    [self refreshListView];
}

- (void)refreshListView{
    if (self.appointDateArr.count == 0 || self.slotsArr.count == 0) {
        return ;
    }
    
    if (self.appointDateArr.count-1 < _selectIndexPath.section) {
        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    ACAvailableDayDTO *dto = self.listDto.schedules[_selectIndexPath.section];
    _selectAppointDate = dto.appointdate;
    [self.dayListView updateDataArray:self.appointDateArr selectIndexPath:[NSIndexPath indexPathForRow:_selectIndexPath.section inSection:0]];
    [self.timeListView updateDataArray:self.slotsArr[_selectIndexPath.section] selectIndexPath:nil];
}

#pragma mark - public

- (void)updateDataSource:(ACAvailableListDTO *)listDto {
    self.listDto = listDto;
    [self.appointDateArr removeAllObjects];
    [self.slotsArr removeAllObjects];
    for (NSInteger i = 0; i < listDto.schedules.count; i++) {
        ACAvailableDayDTO *dto = listDto.schedules[i];
        [self.appointDateArr addObject:dto];
        for (ACAvailableDTO *item in dto.slots) {
            item.isPassToday = dto.isPassToday;
        }
        [self.slotsArr addObject:dto.slots];
    }
    [self refreshListView];
}

- (void)presentAppointTimeViewWithController:(UIViewController *)viewController {
    [viewController.view addSubview:self.view];
    [viewController addChildViewController:self];
    [self didMoveToParentViewController:viewController];
    
    CGRect mainRect = viewController.view.bounds;
    self.view.frame = mainRect;
}

- (void)dismissAppointTimeView {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - action

- (void)clickCancleButtonAction {
    [self dismissAppointTimeView];
}

- (void)clickSureButtonAction {
    if (_selectAvailableDTO) {
        [self dismissAppointTimeView];
        if (_delegate && [_delegate respondsToSelector:@selector(confirmChoiceAppointTime:availableDTO:)]) {
            [_delegate confirmChoiceAppointTime:self.selectAppointDate availableDTO:self.selectAvailableDTO];
        }
    }
}

#pragma mark - PCChoiceAppointTimeListViewDelegate

- (void)choiceAppointTimeListView:(UITableView *)tableView appointDate:(ACAvailableDayDTO *)appointDay indexPath:(NSIndexPath *)indexPath {
    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row ];
    _selectAppointDate = appointDay.appointdate;
    _selectAvailableDTO = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(refreshChoiceAppointTimeWithDayIndex:Complete:)]) {
        __weak typeof(self) weakSelf = self;
        [_delegate refreshChoiceAppointTimeWithDayIndex:indexPath.row Complete:^(ACAvailableListDTO *listDto, NSInteger dayIndex) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (listDto == nil) {
                [strongSelf updateDataSource:strongSelf.listDto];
            } else {
                [strongSelf updateDataSource:listDto];
            }
            [strongSelf refreshListView];
        }];
    } else {
        [self.timeListView updateDataArray:self.slotsArr[indexPath.row] selectIndexPath:nil];
    }
}

- (void)choiceAppointTimeListView:(UITableView *)tableView availableDTO:(ACAvailableDTO *)availableDTO indexPath:(NSIndexPath *)indexPath {
    _selectIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_selectIndexPath.section];
    _selectAvailableDTO = availableDTO;
}

#pragma mark - setter and getter

- (ACChoiceAppointTimeHeadView *)headView {
    if (!_headView) {
        self.headView = [[ACChoiceAppointTimeHeadView alloc] initWithFrame:(CGRectMake(0, ACNScreenHeight - kHeadheight - kRowHeight*kRowNum, ACNScreenWidth, 42))];
        [_headView.cancleBtn addTarget:self action:@selector(clickCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView.sureBtn addTarget:self action:@selector(clickSureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

- (ACChoiceAppointTimeListView *)dayListView {
    if (!_dayListView) {
        self.dayListView = [[ACChoiceAppointTimeListView alloc] initWithFrame:(CGRectMake(0, ACNScreenHeight - kRowHeight*kRowNum, kDayWidth, kRowHeight*kRowNum)) viewType:ACChoiceAppointTimeView_Day];
        _dayListView.delegate = self;
    }
    return _dayListView;
}

- (ACChoiceAppointTimeListView *)timeListView {
    if (!_timeListView) {
       self.timeListView = [[ACChoiceAppointTimeListView alloc] initWithFrame:(CGRectMake(kDayWidth, ACNScreenHeight - kRowHeight*kRowNum, ACNScreenWidth - kDayWidth, kRowHeight*kRowNum)) viewType:ACChoiceAppointTimeView_time];
        _timeListView.delegate = self;
    }
    return _timeListView;
}

- (NSMutableArray *)appointDateArr {
    if (!_appointDateArr) {
        self.appointDateArr = [NSMutableArray array];
    }
    return _appointDateArr;
}

- (NSMutableArray *)slotsArr {
    if (!_slotsArr) {
        self.slotsArr = [NSMutableArray array];
    }
    return _slotsArr;
}

@end
