//
//  RollNavigationBackView.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  对外视图

#import <UIKit/UIKit.h>

@interface RollNavigationBackView : UIView

/** 更新视图
 *  @param  titleArray      标题数组
 *  @param  controllerArray 视图控制器数组
 *  @param  colorArray      颜色数组
 */
- (void)updateWithTitleArray:(NSArray *)titleArray
             controllerArray:(NSArray *)controllerArray
                  colorArray:(NSArray *)colorArray;
@end
