//
//  CityView.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/27.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  城市列表

#define kViewWidth (100.0f)
#define kCellHeight (176.0f/4)
#import "CityView.h"

@implementation CityView

- (id)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = dataArray;
        [self initView];
    }
    return self;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kCellHeight*4) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (void)initView{
    [self dataArray];
    [self addSubview:self.mainTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.citySelectedBlock) {
        self.citySelectedBlock([_dataArray objectAtIndex:indexPath.row]);
    }
}
@end
