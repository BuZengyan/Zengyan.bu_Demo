//
//  EnteringStudentInfoViewController.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/11.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  录入学生信息VC

#define kStudentHeaderViewHeight (44.0f)
#define kCellHeight (44.0f)
#define kAddStudentInfoViewHeight kCellHeight * 6

#import "EnteringStudentInfoViewController.h"
#import "StudentHeaderView.h"
#import "StudentInfoModel.h"
#import "StudentInfoCell.h"
#import "AddStudentInfoView.h"
#import <sqlite3.h>

@interface EnteringStudentInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   StudentHeaderView   *headerView;
@property (nonatomic, strong)   NSMutableArray      *dataArray;         /// 数据源
@property (nonatomic, strong)   UITableView         *mainTableView;     /// 列表信息
@property (nonatomic, strong)   AddStudentInfoView  *addInfoView;       /// 录入信息View
@property (nonatomic, copy)     NSString            *deleteSqlStr;      /// 删除str
@end

@implementation EnteringStudentInfoViewController{
    sqlite3 *db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"学生信息录入表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.addInfoView];
    [self studentSqlite];
    // 首先查询
    [self queryDataWithTableName:kStudentInfo];
}
#pragma mark - 初始化数据源
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - 初始化各个控件
- (StudentHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[StudentHeaderView alloc] initWithFrame:CGRectMake(0,kNaviHeight + kAddStudentInfoViewHeight, kScreenWidth, kStudentHeaderViewHeight)];
    }
    return _headerView;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height + self.headerView.frame.origin.y, kScreenWidth, kScreenHeight - kNaviHeight - kStudentHeaderViewHeight - kAddStudentInfoViewHeight) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
    
}

- (AddStudentInfoView *)addInfoView{
    if (!_addInfoView) {
        _addInfoView = [[AddStudentInfoView alloc] init];
        _addInfoView.frame = CGRectMake(0, kNaviHeight, kScreenWidth, kAddStudentInfoViewHeight);
        kSelfWeak;
        _addInfoView.addBlock = ^(NSInteger btnTag, NSString *studentNumer, NSString *studentName, NSString *studentSex, NSString *studentAge) {
            [weakSelf addStudentInfoWithBtnTag:btnTag studentNumber:studentNumer studentName:studentName studentSex:studentSex studentAge:studentAge];
        };
    }
    return _addInfoView;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    StudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[StudentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        [cell bindDataWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - 点击事件
- (void)tapClick:(UITapGestureRecognizer *)tap{
    
}

#pragma mark - 录入信息
- (void)addStudentInfoWithBtnTag:(NSInteger)btnTag
                   studentNumber:(NSString *)studentNumber
                     studentName:(NSString *)studentName
                      studentSex:(NSString *)studentSex
                      studentAge:(NSString *)studentAge{
    
    if (btnTag == 3333) {
        /// 插入
        // 1.首先判断是否有相同学号
        for (StudentInfoModel *model in self.dataArray) {
            if ([model.studentNumber isEqualToString:studentNumber]) {
                [self.addInfoView hasSameNumber];
                return;
            }
        }
        
        // 2.添加到数据库
        NSString *sql = [NSString stringWithFormat:
                         @"INSERT INTO '%@' ('学号', '姓名', '性别', '年龄') VALUES ('%@', '%@', '%@','%@');",kStudentInfo, studentNumber,studentName, studentSex,studentAge];
        [self execSql:sql];
        
        /// 查询表
        [self queryDataWithTableName:kStudentInfo];
    }else if (btnTag == 2222){
        /// 修改
        for (StudentInfoModel *model in self.dataArray) {
            if ([model.studentNumber isEqualToString:studentNumber]) {
                NSString *sqlForName = [NSString stringWithFormat:@"UPDATE %@ set 姓名='%@' WHERE 学号='%@';",kStudentInfo,studentName,studentNumber];
                [self execSql:sqlForName];
                NSString *sqlForSex = [NSString stringWithFormat:@"UPDATE %@ set 性别='%@' WHERE 学号='%@';",kStudentInfo,studentSex,studentNumber];
                [self execSql:sqlForSex];
                NSString *sqlAge = [NSString stringWithFormat:@"UPDATE %@ set 年龄='%@' WHERE 学号='%@';",kStudentInfo,studentAge,studentNumber];
                [self execSql:sqlAge];
            }
        }
        
        [self queryDataWithTableName:kStudentInfo];
    }else if (btnTag == 1111){
        /// 删除
        self.deleteSqlStr = studentNumber;
        if (self.dataArray.count > 0) {
            NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE 学号='%@';",kStudentInfo,self.deleteSqlStr];
            [self execSql:sql];
            [self queryDataWithTableName:kStudentInfo];
        }
    }
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

#pragma mark - 查询表
- (void)queryDataWithTableName:(NSString *)tbName{
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
            
            StudentInfoModel *studentModel = [[StudentInfoModel alloc] init];
            studentModel.serialNumber = [NSString stringWithFormat:@"%ld",indexId];
            studentModel.studentNumber = studentNumberStr;
            studentModel.studentName = nameStr;
            studentModel.studentSex = sexStr;
            studentModel.studentAge = ageStr;
            
            [self.dataArray addObject:studentModel];
        }
    }else{
        NSLog(@"%@查询数据失败",tbName);
    }
    
    // 排序：升序
    [self.dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        StudentInfoModel *p1 = (StudentInfoModel *)obj1;
        StudentInfoModel *p2 = (StudentInfoModel *)obj2;
        return [p1.studentNumber compare:p2.studentNumber];
    }];
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
