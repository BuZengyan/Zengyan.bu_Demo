//
//  SqliteAndFMDBDemoViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/16.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  数据库操作
#define kCellHeight (44.0f)
#import "SqliteAndFMDBDemoViewController.h"
#import "EnteringStudentInfoViewController.h"
#import "QueryStudentInfoViewController.h"

@interface SqliteAndFMDBDemoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)   NSMutableArray  *dataArray;     /// 数据源
@property (nonatomic, strong)   UITableView *mainTableView;     /// 列表信息
@property (nonatomic, strong)   NSMutableArray  *headerArray;    /// 头视图数据源

@end

@implementation SqliteAndFMDBDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生信息录入系统";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}
#pragma mark - 初始化数据源
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"录入学生信息",@"查询学生信息", nil];
    }
    return _dataArray;
}

- (NSMutableArray *)headerArray{
    if (!_headerArray) {
        _headerArray = [[NSMutableArray alloc] initWithCapacity:0];
        [_headerArray addObject:@"Sqlite3.0"];
        [_headerArray addObject:@"FMDB"];
    }
    return _headerArray;
    
}
#pragma mark - 初始化各个控件
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headerArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    header.backgroundColor = UIColorHex(0x0079BF);
    header.text = [NSString stringWithFormat:@" %@",[self.headerArray objectAtIndex:section]];
    header.textColor = [UIColor whiteColor];
    header.font = [UIFont boldSystemFontOfSize:16];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, kScreenWidth, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EnteringStudentInfoViewController *vc = [[EnteringStudentInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            QueryStudentInfoViewController *vc = [[QueryStudentInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        // 敬请期待
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
