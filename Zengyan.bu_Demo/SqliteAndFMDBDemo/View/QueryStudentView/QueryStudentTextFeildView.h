//
//  QueryStudentTextFeildView.h
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/11.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  根据学号查询View


#import <UIKit/UIKit.h>

typedef void(^QueryStudentBlock)(NSString *studentNumberStr);   /// 输入学号查询
typedef void(^ResetRemindStyleBlock)(void); /// 重置状态

@interface QueryStudentTextFeildView : UIView

@property (nonatomic, copy) QueryStudentBlock queryBlock;
@property (nonatomic, copy) ResetRemindStyleBlock   resetBlock;

@end
