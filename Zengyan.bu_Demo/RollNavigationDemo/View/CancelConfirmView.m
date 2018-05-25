//
//  CancelConfirmView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  顶部取消确认视图

#import "CancelConfirmView.h"
#import "RollNavigationHeader.h"
@interface CancelConfirmView ()

@property (nonatomic, strong)   UIButton *cancelBtn;
@property (nonatomic, strong)   UIButton *confirmBtn;

@end
@implementation CancelConfirmView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.cancelBtn];
//    [self addSubview:self.confirmBtn];
    
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, kCancelConfirmViewHeight, kCancelConfirmViewHeight);
        [_cancelBtn setTitle:@"X" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(kScreenWidth - kCancelConfirmViewHeight, 0, kCancelConfirmViewHeight, kCancelConfirmViewHeight);
        [_confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
- (void)cancelClick:(UIButton *)btn{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmClick:(UIButton *)btn{
//    if (self.confirmBlock) {
//        self.confirmBlock();
//    }
}
@end
