//
//  CancelConfirmView.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  顶部取消确认视图

/// 取消点击事件
typedef void(^CancelBlock)();

/// 确认点击事件
//typedef void(^ConfirmBlock)();

#import <UIKit/UIKit.h>

@interface CancelConfirmView : UIView

@property (nonatomic, copy) CancelBlock cancelBlock;
//@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end
