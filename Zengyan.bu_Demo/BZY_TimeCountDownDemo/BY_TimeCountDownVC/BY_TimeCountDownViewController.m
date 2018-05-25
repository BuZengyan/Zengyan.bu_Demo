//
//  BY_TimeCountDownViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/2/6.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  倒计时

#define kCellHeight (60.0f)

#import "BY_TimeCountDownViewController.h"
#import "BY_ShowTimeCountDownViewController.h"

@interface BY_TimeCountDownViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *mainTableView;     ///
@property (nonatomic, strong)   NSMutableArray  *titleArray;    ///

@end

@implementation BY_TimeCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"倒计时";
    self.view.backgroundColor = UIColorHex(0xFFFFFF);
    [self.view addSubview:self.mainTableView];
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

#pragma makr - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, kCellHeight - 1, kScreenWidth - 20, 1)];
        lineView.backgroundColor = UIColorHex(0xF0F0F1);
        [cell.contentView addSubview:lineView];
    }
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择了？%@",[self.titleArray objectAtIndex:indexPath.row]);
    BY_ShowTimeCountDownViewController *showVc = [[BY_ShowTimeCountDownViewController alloc] init];
    if (indexPath.row == 1) {
        showVc.timeCountDownType = TimeCountDownTypeWithDate;
    }else{
        showVc.timeCountDownType = TimeCountDownTypeWithTimeString;
    }
    [self.navigationController pushViewController:showVc animated:YES];
}

#pragma mark - 数据处理
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"时间戳倒计时",@"日期倒计时", nil];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
