//
//  CityView.h
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/27.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  城市列表


#import <UIKit/UIKit.h>
typedef void(^CitySelectedBlock)(NSString *cityName);

@interface CityView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *mainTableView;
@property (nonatomic, strong)   NSMutableArray *dataArray;  // 城市数据源
@property (nonatomic, copy) CitySelectedBlock citySelectedBlock;

- (id)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray;

@end
