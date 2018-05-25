//
//  QueryTopRemindView.h
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/11.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  表头提示信息

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SearchResultType) {
    SearchDefaultType = 1,              //  默认状态
    SearchSuccessType = 2,              //  查询成功
    SearchErrorType                     //  查询失败
};

@interface QueryTopRemindView : UIView

@property (nonatomic, assign)   SearchResultType searchResultType;

/**
 *  更新数据
 */
- (void)updateTopLabelTextWith:(SearchResultType)searchResultType;

@end
