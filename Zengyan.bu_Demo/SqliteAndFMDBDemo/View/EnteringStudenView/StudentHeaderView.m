//
//  StudentHeaderView.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/8.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  标头信息 [UIScreen mainScreen].bounds.size.height

#define kStudentHeaderViewHeight (44.0f)

#import "StudentHeaderView.h"

@interface StudentHeaderView ()

@property (nonatomic, strong)   NSMutableArray *titleArray; /// 标题数组

@end

@implementation StudentHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = UIColorHex(0x0079BF);
    }
    return self;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"学号",@"姓名",@"性别",@"年龄", nil];
    }
    return _titleArray;
}

- (void)initView{
    CGFloat labelWidth = kScreenWidth / self.titleArray.count;
    for (int i = 0 ; i < self.titleArray.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(labelWidth * i, 0, labelWidth, kStudentHeaderViewHeight);
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.titleArray objectAtIndex:i];
        [self addSubview:label];
    }
}
@end
