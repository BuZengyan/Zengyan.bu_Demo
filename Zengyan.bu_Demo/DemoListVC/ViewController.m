//
//  ViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/16.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  包含自己编写的所以demo

#define kCellHeight 60.0f

#import "ViewController.h"
#import "ShakeAnimotionViewController.h"
#import "SqliteAndFMDBDemoViewController.h"
#import "BaseViewController.h"
#import "NavigationBaseViewController.h"
#import "DrawCurveViewController.h"
#import "CreateBarImageViewController.h"
#import "BY_TimeCountDownViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)   NSMutableArray  *viewControllersArray;  /// 主页列表数据源
@property (nonatomic, strong)   NSMutableArray  *listTitleArray;
@property (nonatomic, strong)   UITableView     *mainTableView;         /// 主页列表
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Demo列表";
    [self.view addSubview:self.mainTableView];
}

#pragma mark - 初始化数据源
- (NSMutableArray *)viewControllersArray{
    if (!_viewControllersArray) {
        _viewControllersArray = [[NSMutableArray alloc] initWithObjects:
                                 @"ShakeAnimotionViewController",
                                 @"SqliteAndFMDBDemoViewController",
                                 @"BaseViewController",
                                 @"NavigationBaseViewController",
                                 @"CreateBarImageViewController",
                                 @"DrawCurveViewController",
                                 @"BY_TimeCountDownViewController",
                                 nil];
    }
    return _viewControllersArray;
}

- (NSMutableArray *)listTitleArray{
    if (!_listTitleArray) {
        _listTitleArray = [[NSMutableArray alloc] initWithObjects:
                           @"ShakeAnimotionDemo",
                           @"SqliteAndFMDBDemo",
                           @"头条滚动栏demo",
                           @"地图导航相关demo",
                           @"条形码生成器Demo",
                           @"画圆角曲线demo",
                           @"倒计时demo",
                           nil];
    }
    return _listTitleArray;
}
#pragma mark - 初始化各个控件
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",indexPath.row,[self.listTitleArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *className = [self.viewControllersArray objectAtIndex:indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *vc = class.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
