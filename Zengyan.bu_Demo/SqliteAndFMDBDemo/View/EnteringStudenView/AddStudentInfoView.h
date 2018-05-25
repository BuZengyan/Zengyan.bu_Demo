//
//  AddStudentInfoView.h
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/8.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  录入学生信息视图



#import <UIKit/UIKit.h>
/**
 *  按钮点击事件
 */
typedef void(^AddStudentInfoViewBlock)(NSInteger btnTag, NSString *studentNumer, NSString  *studentName, NSString *studentSex, NSString *studentAge);

@interface AddStudentInfoView : UIView
@property (nonatomic, strong)   AddStudentInfoViewBlock addBlock;

/**
 *  学号重复
 */
- (void)hasSameNumber;
@end
