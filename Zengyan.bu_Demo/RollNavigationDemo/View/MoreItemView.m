//
//  MoreItemView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  更多下拉菜单

#import "MoreItemView.h"
#import "RollNavigationHeader.h"
#import "CancelConfirmView.h"
#import "ScrollViewForShowItemButtonView.h"

@interface MoreItemView ()

@property (nonatomic, strong)   CancelConfirmView *cancelConfirmView;

@property (nonatomic, strong)   ScrollViewForShowItemButtonView *showItemButtonView;

@end
@implementation MoreItemView
- (instancetype)initWithFrame:(CGRect)frame itemsArray:(NSArray *)itemsArray{
    if (self = [super initWithFrame:frame]) {
        self.itemsArray = itemsArray;
        self.backgroundColor = [UIColor orangeColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        [self initView];
    }
    return self;
}

- (NSArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [[NSArray alloc] init];
    }
    return _itemsArray;
}

- (void)initView{
    [self addSubview:self.cancelConfirmView];
    [self addSubview:self.showItemButtonView];
}

#pragma mark - 取消和确认视图
- (CancelConfirmView *)cancelConfirmView{
    if (!_cancelConfirmView) {
        _cancelConfirmView = [[CancelConfirmView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCancelConfirmViewHeight)];
        if (KIsiPhoneX) {
            _cancelConfirmView.frame = CGRectMake(0, 10, kScreenWidth, kCancelConfirmViewHeight - 10);
        }
        kSelfWeak;
        _cancelConfirmView.cancelBlock = ^{
            [weakSelf cancleBlockClick];
        };
    }
    return _cancelConfirmView;
}

#pragma mark - 
- (ScrollViewForShowItemButtonView *)showItemButtonView{
    if (!_showItemButtonView) {
        _showItemButtonView = [[ScrollViewForShowItemButtonView alloc] initWithFrame:CGRectMake(0, kCancelConfirmViewHeight, kScreenWidth, kScrollViewForShowItemButtonViewHeight) itemsArray:self.itemsArray];
        kSelfWeak;
        _showItemButtonView.scrollToPointViewBlock = ^(NSInteger pointIndex) {
            // 跳转到指定页面
            [weakSelf scrollViewToPoint:pointIndex];
        };
    }
    return _showItemButtonView;
}

- (void)cancleBlockClick{
    if (self.itemViewCancelBlock) {
        self.itemViewCancelBlock();
    }
}

#pragma mark - 跳转到指定页面
- (void)scrollViewToPoint:(NSInteger)pointIndex{
    if (self.scrollToPointViewBlock) {
        self.scrollToPointViewBlock(pointIndex);
    }
}

- (void)updateBtnStyleWith:(NSInteger)pointIndex{
    [self.showItemButtonView updateButtonStyleWith:pointIndex];
}

#pragma mark - 显示视图
- (void)showMoreItemView{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0,kMoreItemViewY , kScreenWidth, kScreenHeight - kMoreItemViewY);
    }];
}

#pragma mark - 隐藏视图
- (void)hiddenMoreItemView{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - kMoreItemViewY);
    }];
}
@end
