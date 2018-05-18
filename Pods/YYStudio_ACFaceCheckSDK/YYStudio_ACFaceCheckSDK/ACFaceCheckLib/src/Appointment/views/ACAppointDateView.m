//
//  ACAppointDateView.m
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/8.
//  Copyright © 2018年  All rights reserved.
//

#import "ACAppointDateView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Addtion.h"
#import "ACAppConstant.h"
#import "ACAvailableListDTO.h"
#import "NSDate+Addtion.h"
#import "IPAInternetSpeedTools.h"

static NSString *cellID = @"ACAppointDateCell";

@interface ACAppointDateView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dayArr;
//@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end
@implementation ACAppointDateView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
         [self.collectionView registerClass:[ACAppointDateCell class] forCellWithReuseIdentifier:cellID];

      
    }
    return self;
}




- (void)updateDataArray:(NSArray *)dateArray selectIndexPath:(NSIndexPath *)indexPath {
    self.dayArr = dateArray;
    _selectIndexPath = indexPath;
    [self.collectionView reloadData];
}




#pragma maek ---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dayArr ? self.dayArr.count : 0;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ACAppointDateCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    if (!cell ) {
//        NSLog(@"cell为空,创建cell");
//        cell = [[ACAppointDateCell alloc] init];
//    }
    
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
    } else if ([NSDate isAfterTomorrowWithTime:dto.appointdate]) {
        cell.titleLb.text = @"后天";
    }
    else {
        
        cell.titleLb.text =  [NSDate weekStringFromTime:dto.appointdate]; 
    }
     cell.describeLb.text =  [NSDate onlyDayFormatterWithTime:dto.appointdate];
    
    
    return cell;
}

#pragma maek ---UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectIndexPath = indexPath;
    [self.collectionView reloadData];
    
    if (_dateViewAppointCallBackBlcok) {
        _dateViewAppointCallBackBlcok(true, self.dayArr[indexPath.row], indexPath);
    }
    
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置UICollectionView为横向滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 每一行cell之间的间距
        flowLayout.minimumLineSpacing = 0;
        // 每一列cell之间的间距
        // flowLayout.minimumInteritemSpacing = 10;
        // 设置第一个cell和最后一个cell,与父控件之间的间距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
        //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
            flowLayout.itemSize = CGSizeMake(75, 70);// 该行代码就算不写,item也会有默认尺寸
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    return _collectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation ACAppointDateCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor pc_colorWithHexString:ColorEEEEEE];
 
         [self initAndModifySubviews];
    }
    return self;
}

- (void)initAndModifySubviews {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.describeLb];
    
    __weak typeof(self) weakSelf = self;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
     
    }];
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.and.width.mas_equalTo(weakSelf);

    }];
    
    [_describeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.centerX.and.width.mas_equalTo(weakSelf);
    }];
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 75, 70);
    //设置渐变区域的起始和终止位置（范围为0-1）
    //        gradient.startPoint = CGPointMake(0, 0);
    //        gradient.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    gradient.colors = [NSArray arrayWithObjects:
                       (__bridge id)[UIColor pc_colorWithHexString:Color3F43E0].CGColor,
                       (__bridge id)[UIColor pc_colorWithHexString:Color643EF2].CGColor,
                       nil];
    //设置颜色分割点（范围：0-1）
    //        gradient.locations = @[@(0.5f), @(1.0f)];
    [self.bgView.layer addSublayer:gradient];
}

- (void)selectState {
    self.bgView.hidden = NO;
    _titleLb.textColor = [UIColor whiteColor];
    _describeLb.textColor = [UIColor whiteColor];
}

- (void)defaultState {
    self.bgView.hidden = YES;
    _titleLb.textColor = [UIColor pc_colorWithHexString:Color999999];
    _describeLb.textColor = [UIColor pc_colorWithHexString:Color999999];
}

- (UIView *)bgView {
    if (!_bgView) {
        self.bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        self.titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor pc_colorWithHexString:Color999999];
    }
    return _titleLb;
}

- (UILabel *)describeLb {
    if (!_describeLb) {
        self.describeLb = [[UILabel alloc] init];
        _describeLb.font = [UIFont systemFontOfSize:14];
        _describeLb.textAlignment = NSTextAlignmentCenter;
        _describeLb.textColor = [UIColor pc_colorWithHexString:Color999999];
    }
    return _describeLb;
}


@end
