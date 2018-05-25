//
//  HeaderSearchView.h
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/27.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  搜索视图

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(NSString *textFeildStr);
@interface HeaderSearchView : UIView <UITextFieldDelegate>

@property (nonatomic, strong)   UITextField *mainTextFeild;
@property (nonatomic, strong)   UIButton *searchBtn;
@property (nonatomic, copy) SearchBlock searchBlock;
@property (nonatomic, copy) NSString *placeholder;
- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;
@end
