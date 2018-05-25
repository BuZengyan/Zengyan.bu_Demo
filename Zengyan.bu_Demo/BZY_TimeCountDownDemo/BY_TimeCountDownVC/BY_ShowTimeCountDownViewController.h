//
//  BY_ShowTimeCountDownViewController.h
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/2/6.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  显示倒计时View

typedef NS_ENUM(NSInteger, TimeCountDownType) {
    TimeCountDownTypeWithDate,                  /// 日期
    TimeCountDownTypeWithTimeString             /// 时间戳
};

#import <UIKit/UIKit.h>

@interface BY_ShowTimeCountDownViewController : UIViewController

@property (nonatomic, assign)   TimeCountDownType timeCountDownType;

@end
