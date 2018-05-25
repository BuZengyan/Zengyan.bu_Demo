//
//  QueryTopRemindView.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/11.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  表头提示信息

#define kQueryTopRemindViewHeight (44.0f)

#import "QueryTopRemindView.h"

@interface QueryTopRemindView ()
@property (nonatomic, strong)   UILabel *topLabel;
@end

@implementation QueryTopRemindView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

#pragma mark - 初始化控件
- (void)initView{
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kQueryTopRemindViewHeight)];
    self.topLabel.backgroundColor = UIColorHex(0x0079BF);
    self.topLabel.font = [UIFont boldSystemFontOfSize:16];
    self.topLabel.text = @"查询学生信息";
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topLabel];
}

#pragma mark - 绑定数据
- (void)updateTopLabelTextWith:(SearchResultType)searchResultType{
    if (searchResultType == SearchSuccessType) {
        self.topLabel.text = @"查询成功！";
        self.topLabel.textColor = [UIColor whiteColor];
    }else if (searchResultType == SearchErrorType){
        self.topLabel.text = @"没有查询到学号信息，请重新输入！";
        self.topLabel.textColor = [UIColor redColor];
    }else{
        self.topLabel.text = @"查询学生信息";
        self.topLabel.textColor = [UIColor whiteColor];
    }
}
@end
