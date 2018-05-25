//
//  BY_ShowTimeCountDownViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/2/6.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  显示倒计时View

#import "BY_ShowTimeCountDownViewController.h"

@interface BY_ShowTimeCountDownViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *mainTableView;
@property (nonatomic, strong)   NSMutableArray  *dataArray;


@end

@implementation BY_ShowTimeCountDownViewController
- (void)setTimeCountDownType:(TimeCountDownType)timeCountDownType{
    _timeCountDownType = timeCountDownType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    self.view.backgroundColor = UIColorHex(0xFFFFFF);
}

#pragma mark - 初始化数据源
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - 标题
- (void)setupTitle{
    self.navigationItem.title = self.timeCountDownType == TimeCountDownTypeWithDate ? @"日期倒计时" : @"时间戳倒计时";
}
#pragma mark - 各个控件
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
