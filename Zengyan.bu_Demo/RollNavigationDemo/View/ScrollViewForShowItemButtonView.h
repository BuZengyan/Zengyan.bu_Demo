//
//  ScrollViewForShowItemButtonView.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  展示更多按钮内容的View


#import <UIKit/UIKit.h>

// 跳转到指定页面
typedef void(^ScrollToPointViewWhenSelectedButtonBlcok)(NSInteger pointIndex);

@interface ScrollViewForShowItemButtonView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *mainTableView;
@property (nonatomic, strong)   NSArray *itemsArray;
@property (nonatomic, copy) ScrollToPointViewWhenSelectedButtonBlcok scrollToPointViewBlock;

- (instancetype)initWithFrame:(CGRect)frame itemsArray:(NSArray *)itemsArray;

/// 更新按钮状态
- (void)updateButtonStyleWith:(NSInteger)pointIndex;

@end
