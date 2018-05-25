//
//  RollNavigationViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/16.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  仿今日头条demo

// 测试获取字符串长度
#define MAXThree(a,b,c) ((a > b ? a : b) > c ? (a > b ? a : b) : c)
#define MAXFour(a,b,c,d) (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d)
#define MAXFive(a,b,c,d,e) ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e)
#define MAXSix(a,b,c,d,e,f) ( ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e) > f ? ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e) : f)
#define MAXSeven(a,b,c,d,e,f,g) (( ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e) > f ? ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e) : f) > g ? ( ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e) > f ? ((((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) > e ? (((a > b ? a : b) > c ? (a > b ? a : b) : c) > d ? ((a > b ? a : b) > c ? (a > b ? a : b) : c) : d) : e) : f) : g)

#define kDistanceX (60.0f)

#import "RollNavigationViewController.h"
#import "RollNavigationHeader.h"
#import "BaseViewController.h"

@interface RollNavigationViewController ()
@property (nonatomic, strong)   UIButton *baseButton;
@end

@implementation RollNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新头条";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseButton];
    [self getCurrentLanguage];
    /// 测试获取字符串长度
    [self testMaxStringLength];
}

#pragma mark - 初始化控件
- (UIButton *)baseButton{
    if (!_baseButton) {
        _baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _baseButton.frame = CGRectMake(kDistanceX, kDistanceX / 2 + kNavHeight64, kScreenWidth - kDistanceX * 2, kDistanceX );
        _baseButton.backgroundColor = [UIColor orangeColor];
        _baseButton.layer.masksToBounds = YES;
        _baseButton.layer.cornerRadius = 4;
        [_baseButton setTitle:@"新头条" forState:UIControlStateNormal];
        [_baseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _baseButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_baseButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baseButton;
}


- (void)btnClick:(UIButton *)btn{
    BaseViewController *vc = [[BaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取系统语言
- (void)getCurrentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"%@" , currentLanguage);
}

#pragma mark - 测试获取字符串最大长度
- (void)testMaxStringLength{
    int a,b,c,d,e,f,g;
    a = 111;
    b = 222;
    c = 333;
    d = 444;
    e = 555;
    f = 666;
    g = 777;
    int maxThree = MAXThree(a,b,c);
    int maxFour = MAXFour(a,b,c,d);
    int maxFive = MAXFive(a,b,c,d,e);
    int maxSix = MAXSix(a, b, c, d, e, f);
    int maxSeven = MAXSeven(a,b,c,d,e,f,g);
    NSLog(@"\n maxThree = %d,\n maxFour = %d ,\n maxFive = %d ,\n maxSix = %d, \n maxSeven = %d",maxThree,maxFour,maxFive,maxSix,maxSeven);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
