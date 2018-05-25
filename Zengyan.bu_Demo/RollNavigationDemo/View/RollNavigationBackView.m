//
//  RollNavigationBackView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  对外视图


#import "RollNavigationBackView.h"
#import "RollNavigationBaseView.h"
#import "RollNavigationHeader.h"

@interface RollNavigationBackView ()
/// 显示的基本视图
@property (nonatomic, strong)   RollNavigationBaseView *rollBaseView;

@end

@implementation RollNavigationBackView

#pragma mark - 初始化

- (RollNavigationBaseView *)rollBaseView{
    if (!_rollBaseView) {
        _rollBaseView = [[RollNavigationBaseView alloc] initWithFrame:CGRectMake(0, KIsiPhoneX == YES ? kNaviHeight : kNavHeight64, kScreenWidth, kScreenHeight - kNavHeight64)];
    }
    return _rollBaseView;
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, kNavHeight64, kScreenWidth, kScreenHeight - kNavHeight64);
        [self addSubview:self.rollBaseView];
    }
    return self;
}

#pragma mark - 更新视图数据

- (void)updateWithTitleArray:(NSArray *)titleArray
             controllerArray:(NSArray *)controllerArray
                  colorArray:(NSArray *)colorArray{

    [self.rollBaseView updateWithTitleArray:titleArray
                                 colorArray:colorArray
                            controllerArray:controllerArray];
}


@end
