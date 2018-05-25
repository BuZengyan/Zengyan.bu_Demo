//
//  QueryStudentTextFeildView.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/11.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  根据学号查询View

#define kTextFeildHeight (44.0f)
#define kLeftLabelWidth (80)
#define kTextFeildWidth (kScreenWidth - kLeftLabelWidth)
#define kButtonWidth (kScreenWidth)

#import "QueryStudentTextFeildView.h"
@interface QueryStudentTextFeildView() <UITextFieldDelegate>

@property (nonatomic, strong)   UITextField *studentNumberTextFeild;    ///
@property (nonatomic, copy)     NSString    *studentNumber;
@property (nonatomic, strong)   UIButton    *searchButton;

@end
@implementation QueryStudentTextFeildView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addLeftRemindLabel];
    [self addSubview:self.studentNumberTextFeild];
    [self addSubview:self.searchButton];
}

- (void)addLeftRemindLabel{
   
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, kLeftLabelWidth, kTextFeildHeight);
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"学号";
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        label.layer.cornerRadius = 0;
        [self addSubview:label];
}

- (UITextField *)studentNumberTextFeild{
    if (!_studentNumberTextFeild) {
        _studentNumberTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kLeftLabelWidth, 0, kTextFeildWidth, kTextFeildHeight)];
        _studentNumberTextFeild.placeholder = @"请输入学号";
        _studentNumberTextFeild.layer.masksToBounds = YES;
        _studentNumberTextFeild.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _studentNumberTextFeild.layer.borderWidth = 1;
        _studentNumberTextFeild.tag = 111;
        _studentNumberTextFeild.delegate = self;
        _studentNumberTextFeild.leftViewMode = UITextFieldViewModeAlways;
        _studentNumberTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kTextFeildHeight)];
    }
    return _studentNumberTextFeild;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(0, kTextFeildHeight, kButtonWidth, kTextFeildHeight);
        _searchButton.layer.masksToBounds = YES;
        _searchButton.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _searchButton.layer.borderWidth =  1;
        [_searchButton setTitleColor:UIColorHex(0x0079BF) forState:UIControlStateNormal];
        [_searchButton setTitle:@"查询" forState:UIControlStateNormal];
        _searchButton.tag = 3333;
        [_searchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

#pragma mark - 点击事件
- (void)btnClick:(UIButton *)btn{
    [self hiddenKeyboard];
    if (self.queryBlock) {
        kSelfWeak;
        self.queryBlock(weakSelf.studentNumber);
    }
}
#pragma mark - UITextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self hiddenKeyboard];
    // 学号
    self.studentNumber = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hiddenKeyboard];
    self.studentNumber = textField.text;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self resetStyle];
}

#pragma mark - 重置状态
- (void)resetStyle{
    if (self.resetBlock) {
        self.resetBlock();
    }
}

#pragma mark - 注销键盘响应
- (void)hiddenKeyboard{
    if ([self.studentNumberTextFeild isFirstResponder]) {
        [self.studentNumberTextFeild resignFirstResponder];
    }
}

@end
