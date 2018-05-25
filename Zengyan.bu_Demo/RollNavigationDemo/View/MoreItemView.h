//
//  MoreItemView.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  更多下拉菜单

// 取消事件
typedef void(^MoreItemViewCancelBlock)();

#import <UIKit/UIKit.h>
typedef void(^ScrollToPointViewFromMoreItemViewBlock)(NSInteger pointIndex);

@interface MoreItemView : UIView

@property (nonatomic, copy) MoreItemViewCancelBlock itemViewCancelBlock;

@property (nonatomic, strong)   NSArray *itemsArray; /// 按钮数组

@property (nonatomic, copy) ScrollToPointViewFromMoreItemViewBlock scrollToPointViewBlock;

///
- (instancetype)initWithFrame:(CGRect)frame itemsArray:(NSArray *)itemsArray;

/// 更新按钮视图
- (void)updateBtnStyleWith:(NSInteger)pointIndex;

/** 显示视图
 
 */
- (void)showMoreItemView;


/** 隐藏视图
 
 */
- (void)hiddenMoreItemView;

@end
