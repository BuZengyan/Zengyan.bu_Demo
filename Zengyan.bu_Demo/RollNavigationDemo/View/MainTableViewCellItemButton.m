//
//  MainTableViewCellItemButton.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/4.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  单个button

#define kDistanceX 15.0f
#import "MainTableViewCellItemButton.h"
#import "RollNavigationHeader.h"
@interface MainTableViewCellItemButton()

@property (nonatomic, strong)   UIButton *itemButton;   /// 单个button
@property (nonatomic, strong)   UIButton *deleteButton; /// 删除按钮
@property (nonatomic, assign)   NSInteger btnTag;

@end

@implementation MainTableViewCellItemButton

- (instancetype)initWithFrame:(CGRect)frame btnTag:(NSInteger)btnTag{
    if (self = [super initWithFrame:frame]) {
        self.btnTag = btnTag;
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.itemButton];
    [self addSubview:self.deleteButton];
}

- (UIButton *)itemButton{
    if (!_itemButton) {
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemButton.frame = CGRectMake(0, 0, (kScreenWidth - kDistanceX * 5) / 4, kItemButtonHeight);
        _itemButton.backgroundColor= [UIColor whiteColor];
        [_itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _itemButton.tag = self.btnTag;
        _itemButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _itemButton.layer.masksToBounds = YES;
        _itemButton.layer.cornerRadius = 4;
        _itemButton.layer.borderWidth = 1;
        _itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_itemButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(self.frame.size.width - 15, 0, 15, 15);
        [_deleteButton setBackgroundColor:[UIColor whiteColor]];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.tag = self.btnTag + kTempBtnTag;
        _deleteButton.layer.cornerRadius = 15/2;
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_deleteButton setTitle:@"X" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}
- (void)btnClick:(UIButton *)btn{
    NSLog(@"点击了view%ld",btn.tag);
    NSInteger pointIndex = btn.tag - kTempBtnTag;
    if (self.scrollToPointViewBlock) {
        self.scrollToPointViewBlock(pointIndex);
    }
}

- (void)deleteClick:(UIButton *)btn{
    NSLog(@"删除了？？view%ld",btn.tag);
}

- (void)bindDataWithModel:(id)model cellType:(CellType)cellType pointTag:(NSInteger)pointTag{
    if ([model isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)model;
        [_itemButton setTitle:str forState:UIControlStateNormal];
        if (cellType == EditCellType) {
            _deleteButton.hidden = NO;
            _itemButton.enabled = NO;
            [_itemButton setTitle:str forState:UIControlStateNormal];
            if (_itemButton.tag == pointTag) {
                [_itemButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                _itemButton.layer.borderColor = [UIColor redColor].CGColor;
                _itemButton.enabled = NO;
            }else{
                [_itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _itemButton.enabled = YES;
            }

        }else if (cellType == NormalCellType){
            _deleteButton.hidden = YES;
            _itemButton.enabled = YES;
            
            [_itemButton setTitle:str forState:UIControlStateNormal];
            if (_itemButton.tag == pointTag) {
                [_itemButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                _itemButton.layer.borderColor = [UIColor redColor].CGColor;
                _itemButton.enabled = NO;
            }else{
                [_itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _itemButton.enabled = YES;
            }
        }else if (cellType == AddCellType){
            _deleteButton.hidden = YES;
            
            NSString *titleStr = [NSString stringWithFormat:@"+%@",str];
            [_itemButton setTitle:titleStr forState:UIControlStateNormal];
//            if (_itemButton.tag == pointTag) {
//                [_itemButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                _itemButton.layer.borderColor = [UIColor redColor].CGColor;
//                _itemButton.enabled = NO;
//            }else{
//                [_itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                _itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//                _itemButton.enabled = YES;
//            }
        }
    }
}

@end
