//
//  MainTableViewCellItemButton.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  单个button


#import <UIKit/UIKit.h>
/// 点击button跳转事件
typedef void(^ScrollToPointViewBlock)(NSInteger pointIndex);

typedef NS_ENUM(NSInteger, CellType) {
    NormalCellType = 1, // 1.正常状态
    EditCellType = 2,   // 2.编辑状态
    AddCellType         // 3.添加状态
};

@interface MainTableViewCellItemButton : UIView

@property (nonatomic, copy) ScrollToPointViewBlock scrollToPointViewBlock;

- (instancetype)initWithFrame:(CGRect)frame btnTag:(NSInteger)btnTag;


/** 绑定数据
 
 */
- (void)bindDataWithModel:(id)model cellType:(CellType)cellType pointTag:(NSInteger )pointTag;

@end
