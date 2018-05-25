//
//  MainTableViewCell.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  显示button的cell

#import <UIKit/UIKit.h>
#import "MainTableViewCellItemButton.h"

typedef void(^ScrollToPointViewBlock)(NSInteger pointIndex);

@interface MainTableViewCell : UITableViewCell
@property (nonatomic, strong)   NSArray *itemsArray;
@property (nonatomic, strong)   NSMutableArray *btnArray;   // 存放button的数组

@property (nonatomic, copy) ScrollToPointViewBlock scrollToPointViewBlock;

/** 绑定数据
 
 */
- (void)bindDataWithModel:(id)model cellType:(CellType)cellType pointTag:(NSInteger)pointTag;

@end
