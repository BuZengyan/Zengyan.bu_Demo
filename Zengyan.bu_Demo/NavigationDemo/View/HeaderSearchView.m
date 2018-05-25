//
//  HeaderSearchView.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/27.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  搜索视图

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kSearchViewHeight (64.0f)
#define kDistanceY (15.0f)
#define kDistanceX (15.0f)
#define kButtonWidth (60.0f)

#import "HeaderSearchView.h"

@implementation HeaderSearchView
{
    NSString *textFeildStr;
}
- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.placeholder = placeholder;
        [self initView];
    }
    return self;
}

- (void)initView{
    _mainTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kDistanceX, kDistanceY, self.frame.size.width - kDistanceX*3 - kButtonWidth, kSearchViewHeight - kDistanceY*2)];
    _mainTextFeild.delegate = self;
    _mainTextFeild.layer.masksToBounds = YES;
    _mainTextFeild.layer.borderColor = [UIColor redColor].CGColor;
    _mainTextFeild.layer.borderWidth = 0;
    _mainTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextFeild.placeholder = self.placeholder;
    _mainTextFeild.layer.cornerRadius = 6;
    _mainTextFeild.font = [UIFont systemFontOfSize:12];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 10,  kSearchViewHeight - kDistanceY*2)];
    _mainTextFeild.leftView = view;
    _mainTextFeild.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:_mainTextFeild];
    _mainTextFeild.backgroundColor = [UIColor whiteColor];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(self.frame.size.width - kDistanceX - kButtonWidth, kDistanceY, kButtonWidth, kSearchViewHeight - kDistanceY*2);
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _searchBtn.backgroundColor = [UIColor blueColor];
    _searchBtn.layer.cornerRadius = 6;
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];
}

- (void)btnClick:(UIButton *)btn{

    if ([_mainTextFeild isFirstResponder]) {
        [_mainTextFeild resignFirstResponder];
    }
    
//    textFeildStr = @"大悦城";
    
    if (self.searchBlock) {
        self.searchBlock(textFeildStr);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFeild.text = %@",textField.text);
    textFeildStr = textField.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textFeildStr = textField.text;
}
@end
