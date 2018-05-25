//
//  BaseViewController.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/29.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//

#import "BaseViewController.h"
#import "RollNavigationBackView.h"

@interface BaseViewController ()
@property (nonatomic, strong)   RollNavigationBackView *rollNavigationView;
@end

@implementation BaseViewController
#pragma mark - 初始化
- (RollNavigationBackView *)rollNavigationView{
    if (!_rollNavigationView) {
        _rollNavigationView = [[RollNavigationBackView alloc] init];
    }
    return _rollNavigationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"明日头条";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // 1.初始化
    self.rollNavigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:self.rollNavigationView];
    
    // 2.构造数据源
    NSArray *titleArray = [NSArray arrayWithObjects:
                           @"推荐",
                           @"热点",
                           @"NBA",
                           @"图片",
                           @"社会",
                           @"娱乐",
                           @"问答",
                           @"汽车",
                           @"体育",
                           @"财经",
                           @"军事",
                           @"段子",
                           @"视频",
                           @"正能量",
                           @"小说",
                           @"科技",
                           @"美女",
                           @"国际",
                           @"健康",
                           @"趣图",
                           @"上海",
                           @"电影",
                           nil];
    NSArray *controllerArray = [NSArray arrayWithObjects:
                                @"OneViewController",
                                @"TwoViewController",
                                @"ThreeViewController",
                                @"FourViewController",
                                @"FiveViewController",
                                @"SixViewController",
                                @"SevenViewController",
                                @"EightViewController",
                                @"NineViewController",
                                @"TenViewController",
                                @"SixViewController",
                                @"SevenViewController",
                                @"EightViewController",
                                @"NineViewController",
                                @"TenViewController",
                                @"OneViewController",
                                @"TwoViewController",
                                @"ThreeViewController",
                                @"FourViewController",
                                @"FiveViewController",
                                @"FourViewController",
                                @"FiveViewController",

                                nil];
    NSArray *colorArray = [NSArray arrayWithObjects:
                           [UIColor redColor],
                           [UIColor blackColor],
                           [UIColor redColor],
                           nil];
    // 3.更新数据
    [self.rollNavigationView updateWithTitleArray:titleArray controllerArray:controllerArray colorArray:colorArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
