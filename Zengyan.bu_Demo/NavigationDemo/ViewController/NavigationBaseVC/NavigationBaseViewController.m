//
//  NavigationBaseViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/16.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  导航相关主页

#define kSearchViewHeight (64.0f)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (64.0f)
#define kCellHeight (176.0f/4)
#define kMainTableViewCellHeight (60.0f)

#import "NavigationBaseViewController.h"
#import "FindLocationViewController.h"
#import "GeocodingViewController.h"
#import "ReGeocodingViewController.h"
#import "DriveViewController.h"

@interface NavigationBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView     *mainTableView;
@property (nonatomic, strong)   NSMutableArray  *titleArray;  /// 数据源
@property (nonatomic, strong)   NSMutableArray  *viewControllersArray;   /// 控制器数组
@end

@implementation NavigationBaseViewController

#pragma mark - tableView
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
        [_titleArray addObject:@"位置查找"];
        [_titleArray addObject:@"地理编码 + 导航"];     // 输入地址查询位置
        [_titleArray addObject:@"地理逆编码"];
        [_titleArray addObject:@"导航（调用外部地图导航）"];
    }
    return _titleArray;
}

- (NSMutableArray *)viewControllersArray{
    if (!_viewControllersArray) {
        _viewControllersArray = [[NSMutableArray alloc] initWithObjects:@"FindLocationViewController",@"GeocodingViewController",@"ReGeocodingViewController",@"DriveViewController", nil];
    }
    return _viewControllersArray;
}


#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"地图导航demo";
    [self.view addSubview:self.mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
