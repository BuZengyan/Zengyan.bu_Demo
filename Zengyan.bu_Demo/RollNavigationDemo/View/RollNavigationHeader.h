
//
//  RollNavigationHeader.h
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  UI尺寸

#ifndef RollNavigationHeader_h
#define RollNavigationHeader_h

#define KScale kScreenWidth/375
#define kStatusBarHeight (20.0f)
#define kNavigationBarHeight (44.0f)
#define kNavHeight64 (64.0f)
#define kPageBtn (32.0f)*KScale
#define kLineBottomHeight (2.0f)

#define btnTempTag 1000000
#define kSelectTempBtnTag 222222
#define kMoreBtnSize (22.0f*2)
#define kIPhone5MoreBtnSize (18.0f*2)
#define kIphone4MoreBtnSize (15.5f*2)
#define kRedLabelHeight (6.5f*2)*KScale
#define kRedLabelWidth (12.0f*2)*KScale
#define kRedLabelTempTag (1111111)
#define kShadowHeight (8.0f)

#define FUll_CONTENT_HEIGHT kScreenHeight - kNavHeight64 - PageBtn
//tabbar的高度
#define TabbarHeight 49
//TopTab相关参数
#define LeftLength  .6 * 45                     //左侧的视图长度 20 / 45
#define LeftX .12 * self.frame.size.width       //左侧视图的X 20 / 375
#define TotalY .015 * kScreenHeight             //两边图片的Y 10 / 45
#define TotalYPlus .009 * kScreenHeight         //右侧图片的高度调节
#define TitleWidth  .4 * kScreenWidth / 2       //标题的宽度 55 / 375
#define RightImageWidth .085 * kScreenWidth     //右侧图片宽度
#define RightImageHeight .024 * kScreenHeight   //右侧图片高度
#define RightTitleWidth .06 * kScreenWidth      //右侧文字宽度
#define RightTitleHeight .021 * kScreenHeight   //右侧文字高度
#define RightTitleY 0.0015 * kScreenHeight      //右侧文字Y
#define RightTitleX 0.015 * kScreenWidth        //右侧文字X
#define LinbottomWidth (132.0/375)*kScreenWidth //下面红线的宽度
#define kBaseCount 6

#define More5LineWidth kScreenWidth / kBaseCount      //超过5个标题的宽度

#define kMoreItemViewY 20.0f
#define kCancelConfirmViewHeight (34.0f)
#define kScrollViewForShowItemButtonViewHeight (kScreenHeight - kCancelConfirmViewHeight - kMoreItemViewY)
#define kCellHeight kScrollViewForShowItemButtonViewHeight/2

#define kItemButtonHeight (30.0f)
#define kTempBtnTag (111111)

/// block self 使用方法：（kSelfWeak  weakSelf.成员变量）
#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(weakSelf) strongSelf = weakSelf


#endif /* RollNavigationHeader_h */
