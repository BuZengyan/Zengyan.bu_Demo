//
//  RollNavigationBaseView.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  基本视图

#import <UIKit/UIKit.h>

@interface RollNavigationBaseView : UIView <UIScrollViewDelegate>

/** 更新视图
 *  @param  titleArray      标题数组
 *  @param  colorArray      颜色数组
 *  @param  controllerArray 控制器数组
 */
- (void)updateWithTitleArray:(NSArray *)titleArray
                  colorArray:(NSArray *)colorArray
             controllerArray:(NSArray *)controllerArray;

/** 跳转到指定页面
 
 */
- (void)scrollToPointView:(NSInteger)pointIndex;


@end
