//
//  MainTableViewCell.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  显示button的cell

#define kCountForEveryRow (4)   /// 每行4个
#define kDistanceX (15.0f)
#define kDistanceY (15.0f)

#define kButtonWidth (kScreenWidth - kDistanceX * 5) / 4

#import "MainTableViewCell.h"
#import "RollNavigationHeader.h"


@interface MainTableViewCell ()

@property (nonatomic, strong)   UIView *lineView;
@property (nonatomic, assign)   NSInteger rowCount; /// 需要几行
@property (nonatomic, assign)   NSInteger btnIndex;
//@property (nonatomic, assign)   NSInteger selectedBtnTag; // 选中button的tag值
@property (nonatomic, strong)   NSMutableArray *buttonArray;    ///



@end
@implementation MainTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectedBtnTag = kTempBtnTag;
        [self initView];
    }
    return self;
}

- (void)setBtnArray:(NSMutableArray *)btnArray{
    _btnArray = btnArray;
}

- (void)setItemsArray:(NSArray *)itemsArray{
    _itemsArray = itemsArray;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttonArray;
}

- (void)initView{
    [self.contentView addSubview:self.lineView];
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (void)bindDataWithModel:(id)model cellType:(CellType)cellType pointTag:(NSInteger)pointTag{
//    self.selectedBtnTag = pointTag;
    NSArray *dataArray = (NSArray *)model;
    self.rowCount = dataArray.count % 4 == 0 ? dataArray.count / 4 : dataArray.count / 4 + 1;
    self.btnIndex = 0;
    // 添加按钮视图
    for (int i = 0 ; i < self.rowCount; i++) {
        for (int j = 0; j < kCountForEveryRow; j++) {
            MainTableViewCellItemButton *itemButton = [[MainTableViewCellItemButton alloc] initWithFrame:CGRectMake(kDistanceX + (kDistanceX + kButtonWidth) * j, kDistanceY + (kItemButtonHeight + kDistanceY) * i, kButtonWidth, kItemButtonHeight) btnTag:self.btnIndex + kTempBtnTag ];
            [self.contentView addSubview:itemButton];
            [itemButton bindDataWithModel:[dataArray objectAtIndex:self.btnIndex] cellType:cellType pointTag:pointTag];
            self.btnIndex++;
            [self.buttonArray addObject:itemButton];
            // 跳转事件
            kSelfWeak;
            itemButton.scrollToPointViewBlock = ^(NSInteger pointIndex) {
                //
                [weakSelf scrollToPointView:pointIndex];
//                weakSelf.selectedBtnTag = pointIndex + kTempBtnTag;
                
            };
            
            if (self.btnIndex > dataArray.count - 1) {
                return;
            }
        }
    }
}

#pragma mark - 跳转事件
- (void)scrollToPointView:(NSInteger )pointIndex{
    if (self.scrollToPointViewBlock) {
        self.scrollToPointViewBlock(pointIndex);
    }
}

#pragma mark - 更新button状态
//- (void)updateBtnStyleWithSelectedBtnTag:(NSInteger)btnTag{
//    for (MainTableViewCellItemButton *item in self.buttonArray) {
//        if (item.tag == btnTag) {
//            <#statements#>
//        }
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
