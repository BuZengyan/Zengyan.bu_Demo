//
//  ScrollViewForShowItemButtonView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  展示更多按钮内容的View


#define kHeaderViewHeight (44.0f)
#define kDistanceX (15.0f)
#define kDistanceY (15.0f)

#import "ScrollViewForShowItemButtonView.h"
#import "RollNavigationHeader.h"
#import "MainTableViewCell.h"

@interface ScrollViewForShowItemButtonView()

@property (nonatomic, strong)   UIView *headerOne;
@property (nonatomic, strong)   UIView *headerTwo;
@property (nonatomic, assign)   CellType cellType;
@property (nonatomic, assign)   NSInteger pointIndex;

@end

@implementation ScrollViewForShowItemButtonView

- (instancetype)initWithFrame:(CGRect)frame itemsArray:(NSArray *)itemsArray{
    if (self = [super initWithFrame:frame]) {
        self.itemsArray = itemsArray;
        self.cellType = NormalCellType;
        self.pointIndex = kTempBtnTag;
        [self initView];
    }
    return self;
}

- (NSArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [[NSArray alloc] init];
    }
    return _itemsArray;
}

- (void)initView{
    [self addSubview:self.mainTableView];
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrollViewForShowItemButtonViewHeight) style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = YES;
        _mainTableView.showsHorizontalScrollIndicator = YES;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UIView *)headerOne{
    if (!_headerOne) {
        _headerOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
        _headerOne.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDistanceX, 0, kScreenWidth - kHeaderViewHeight, kHeaderViewHeight)];
        label.text = @"我的频道";
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        [_headerOne addSubview:label];
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(kScreenWidth - kHeaderViewHeight, 0, kHeaderViewHeight, kHeaderViewHeight);
        [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [editBtn addTarget:self action:@selector(editClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_headerOne addSubview:editBtn];
    }
    return _headerOne;
}

- (UIView *)headerTwo{
    if (!_headerTwo) {
        _headerTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
        _headerTwo.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDistanceX, 0, kScreenWidth - kDistanceX * 2, kHeaderViewHeight)];
        label.text = @"频道推荐";
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        [_headerTwo addSubview:label];
    }
    return _headerTwo;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    // 防止重复生成
    for (MainTableViewCellItemButton *item in cell.contentView.subviews) {
        [item removeFromSuperview];
    }
    
    kSelfWeak;
    cell.scrollToPointViewBlock = ^(NSInteger pointIndex) {
        
        [weakSelf scrollClick:pointIndex];
        
    };
    if (indexPath.section == 0) {
        [cell bindDataWithModel:self.itemsArray cellType:self.cellType pointTag:self.pointIndex] ;
    }else{
        [cell bindDataWithModel:self.itemsArray cellType:AddCellType pointTag:self.pointIndex];
    }
    
  

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.headerOne;
    }else{
        return self.headerTwo;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderViewHeight;
}


#pragma mark - 跳转事件
- (void)scrollClick:(NSInteger)pointIndex{
    //
    self.pointIndex = pointIndex + kTempBtnTag;
    if (self.scrollToPointViewBlock) {
        self.scrollToPointViewBlock(pointIndex);
    }
    [self.mainTableView reloadData];
}

#pragma mark - 编辑事件
- (void)editClcik:(UIButton *)btn{
    if (self.cellType == NormalCellType) {
        self.cellType = EditCellType;
    }else{
        self.cellType = NormalCellType;
    }
//    self.mainTableView reloadSections:[nss] withRowAnimation:<#(UITableViewRowAnimation)#>
    [self.mainTableView reloadData];
}

#pragma mark - 更新按钮状态
- (void)updateButtonStyleWith:(NSInteger)pointIndex{
    self.pointIndex = pointIndex + kTempBtnTag;
    [self.mainTableView reloadData];
}

#pragma mark - 计算cell高度
- (CGFloat)getCellHeight{
    NSInteger rowCount = self.itemsArray.count % 4 == 0 ? self.itemsArray.count / 4 : self.itemsArray.count / 4 + 1;
    CGFloat allHeight = rowCount * (kItemButtonHeight + kDistanceY) + kDistanceY;
    return allHeight;
}
@end
