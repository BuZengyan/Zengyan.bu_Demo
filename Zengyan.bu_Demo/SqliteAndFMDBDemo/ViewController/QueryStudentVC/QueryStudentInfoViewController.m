//
//  QueryStudentInfoViewController.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/11.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  查询学生信息
#define kQueryTopRemindViewHeight (44.0f)

#import "QueryStudentInfoViewController.h"
#import "QueryTopRemindView.h"
#import "QueryStudentTextFeildView.h"
#import "StudentInfoModel.h"
#import "StudentInfoCell.h"
#import <sqlite3.h>

@interface QueryStudentInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)   QueryTopRemindView *topView;
@property (nonatomic, strong)   QueryStudentTextFeildView *textFeildView;
@property (nonatomic, strong)   NSMutableArray      *dataArray;         /// 数据源
@property (nonatomic, strong)   UITableView         *mainTableView;     /// 列表信息


@end

@implementation QueryStudentInfoViewController
{
    sqlite3 *db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查询学生信息";
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.textFeildView];
    [self.view addSubview:self.mainTableView];
    
    [self studentSqlite];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapClick{
    [self.view endEditing:YES];
}

#pragma mark - 初始化数据源
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - 初始化各个控件
- (QueryTopRemindView *)topView{
    if (!_topView) {
        _topView = [[QueryTopRemindView alloc] initWithFrame:CGRectMake(0, kNaviHeight, kScreenWidth, kQueryTopRemindViewHeight)];
    }
    return _topView;
}

- (QueryStudentTextFeildView *)textFeildView{
    if (!_textFeildView) {
        _textFeildView = [[QueryStudentTextFeildView alloc] initWithFrame:CGRectMake(0, kNaviHeight + kQueryTopRemindViewHeight, kScreenWidth, kQueryTopRemindViewHeight * 2)];
        kSelfWeak;
        _textFeildView.queryBlock = ^(NSString *studentNumberStr) {
            [weakSelf queryClick:studentNumberStr];
        };
        
    
        _textFeildView.resetBlock = ^{
            [weakSelf.topView updateTopLabelTextWith:SearchDefaultType];
        };
    }
    return _textFeildView;
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviHeight + kQueryTopRemindViewHeight * 3, kScreenWidth, kScreenHeight - kNaviHeight - kQueryTopRemindViewHeight * 3) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellstr";
    StudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[StudentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (self.dataArray.count > 0) {
        [cell bindDataWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
#pragma mark - 查询事件
- (void)queryClick:(NSString *)studentNumber{
    if ([self checkStudentNumber:studentNumber]) {
        [self queryDataWithTableName:kStudentInfo putIntostudentNumber:studentNumber];
    }
}

// 检测输入学号
- (BOOL)checkStudentNumber:(NSString *)studentNumber{
    if (studentNumber.length == 0) {
        [self.topView updateTopLabelTextWith:SearchErrorType];
        return NO;
    }
    return YES;
}

#pragma mark - 数据库操作
- (void)studentSqlite{
    /// 创建数据库
    [self creatStudentSqlite];
    /// 创建表
    [self creatStudentTable];
}

#pragma mark - 创数据库
- (void)creatStudentSqlite{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsStr = [paths objectAtIndex:0];
    /// 应用的文档目录
    NSLog(@"documentsStr === %@",documentsStr);
    NSString *database_path = [documentsStr stringByAppendingPathComponent:kSqliteName];
    /// 打开数据库，如果没有打开的话，会在改目录创建数据库
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
    }
}

#pragma mark - 创建表
- (void)creatStudentTable{
    // IF NOT EXISTS 如果不存在 （如果该数据库已经存在了该表，则sqlite3_exec在执行数据库操作的时候不会报错给我们，如果表已经存在了，又没有加这个判断的话，会执行不成功并关闭数据库）
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, 学号 VARCHAR, 姓名 VARCHAR, 性别 VARCHAR, 年龄 VARCHAR);",kStudentInfo];
    [self execSql:sql];
}

#pragma mark - 查询表内学生信息
- (void)queryDataWithTableName:(NSString *)tbName putIntostudentNumber:(NSString *)putIntostudentNumber{
    [self.dataArray removeAllObjects];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@;",tbName];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSInteger indexId = sqlite3_column_int(statement, 0);
            char *studentNumber = (char*)sqlite3_column_text(statement, 1);
            NSString *studentNumberStr = [[NSString alloc] initWithUTF8String:studentNumber];
            char *name = (char *)sqlite3_column_text(statement, 2);
            NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
            char *sex = (char *)sqlite3_column_text(statement, 3);
            NSString *sexStr = [[NSString alloc] initWithUTF8String:sex];
            char *age = (char *)sqlite3_column_text(statement, 4);
            NSString *ageStr = [[NSString alloc] initWithUTF8String:age];
            
            if ([studentNumberStr isEqualToString:putIntostudentNumber]) {
                StudentInfoModel *studentModel = [[StudentInfoModel alloc] init];
                studentModel.serialNumber = [NSString stringWithFormat:@"%ld",indexId];
                studentModel.studentNumber = studentNumberStr;
                studentModel.studentName = nameStr;
                studentModel.studentSex = sexStr;
                studentModel.studentAge = ageStr;
                [self.dataArray addObject:studentModel];
            }
        }
    }else{
        NSLog(@"%@查询数据失败",tbName);
    }
    
    /// 查询后检测
    if (self.dataArray.count == 0) {
        [self.topView updateTopLabelTextWith:SearchErrorType];
    }else{
        [self.topView updateTopLabelTextWith:SearchSuccessType];
    }
    [self.mainTableView reloadData];
}

#pragma mark - 执行sql
- (void)execSql:(NSString *)sql{
    char *err;
    sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
