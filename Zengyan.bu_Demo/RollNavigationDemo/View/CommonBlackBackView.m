//
//  CommonBlackBackView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  公共黑色透明背景View

#import "CommonBlackBackView.h"

@implementation CommonBlackBackView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)hiddenBackView{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    }];
}

- (void)showBackView{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0.6;
    }];
}

@end
