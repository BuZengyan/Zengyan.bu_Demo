//
//  StudentInfoCell.h
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/8.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  学生信息明细

#import <UIKit/UIKit.h>

@interface StudentInfoCell : UITableViewCell

/** 绑定数据
 *
 */
- (void)bindDataWithModel:(id)model;
@end
