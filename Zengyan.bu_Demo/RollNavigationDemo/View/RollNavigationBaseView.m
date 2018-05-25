//
//  RollNavigationBaseView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  基本视图

#define MaxNums 20

#import "RollNavigationBaseView.h"
#import "RollNavigationHeader.h"
#import "SmallRedView.h"

#import "CommonBlackBackView.h"
#import "MoreItemView.h"

@interface RollNavigationBaseView ()

/// 预防scrollView成为第一视图
@property (nonatomic, strong)   UIView *firstView;

/// 显示控制器视图
@property (nonatomic, strong)   UIScrollView    *showControllerScrollView;

/// 当前页码
@property (nonatomic, assign)   NSInteger   currentPage;

/// 显示顶部标题
@property (nonatomic, strong)   UIScrollView    *topTitleScrollView;

/// 标题数组
@property (nonatomic, strong)   NSArray *titleArray;

/// 控制器数组
@property (nonatomic, strong)   NSArray *controllerArray;

/// 颜色数组
@property (nonatomic, strong)   NSArray *colorArray;

/// 底部线
@property (nonatomic, strong)   UIView  *lineBottom;

/// 存放button的数组
@property (nonatomic, strong)   NSMutableArray *btnArray;

/// redView宽度
@property (nonatomic, assign)   CGFloat redViewWidth;

/// redView高度
@property (nonatomic, assign)   CGFloat redViewHeight;

/// 更多按钮
@property (nonatomic, strong)   UIButton *addButton;

/// 更多按钮背景
@property (nonatomic, strong)   UIView *addBackgroundView;

/// 黑色背景视图
@property (nonatomic, strong)   CommonBlackBackView *backView;

/// 更多按钮视图
@property (nonatomic, strong)   MoreItemView *itemView;

@end
@implementation RollNavigationBaseView
{
    UIColor     *selectedColor;     //  选中时的颜色
    UIColor     *unselectedColor;   //  未选中时的颜色
    UIColor     *bottomLineColor;   //  底部移动线的颜色
    CGFloat     btnWidth;           //  顶部标题按钮的宽度
    BOOL        viewAlloc[MaxNums]; // 记录VC是否被加载过
    UIView *line;
}

#pragma mark - 初始化各个控件
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray =[NSArray array];
    }
    return _controllerArray;
}

- (NSArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [NSArray array];
    }
    return _colorArray;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kScreenWidth - kPageBtn, 0, kPageBtn, kPageBtn);
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor clearColor];
        [_addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIView *)addBackgroundView{
    if (!_addBackgroundView) {
        _addBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - kPageBtn, 0, kPageBtn, kPageBtn)];
        _addBackgroundView.backgroundColor = [UIColor whiteColor];
        _addBackgroundView.alpha = 0.8;
    }
    return _addBackgroundView;
}
#pragma mark - 计算初始状态小红点size
- (void)takeRedViewSize{
    UIImage *image = [UIImage imageNamed:@"num-bg2@2x.png"];
    self.redViewWidth = image.size.width;
    self.redViewHeight = image.size.height;
}

#pragma mark - 底线
- (UIView *)lineBottom{
    if (!_lineBottom) {
        _lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, kPageBtn - kLineBottomHeight, 0, kLineBottomHeight)];
    }
    return _lineBottom;
}

#pragma mark - 顶部按钮背景视图
- (UIScrollView *)topTitleScrollView{
    if (!_topTitleScrollView) {
        _topTitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageBtn)];
        _topTitleScrollView.tag = 917;
        _topTitleScrollView.delegate = self;
        _topTitleScrollView.scrollEnabled = YES;
        _topTitleScrollView.alwaysBounceHorizontal = NO;
        _topTitleScrollView.showsHorizontalScrollIndicator = NO;
        _topTitleScrollView.showsVerticalScrollIndicator = NO;
        _topTitleScrollView.backgroundColor = [UIColor whiteColor];
        _topTitleScrollView.alpha = 1;
        line = [[UIView alloc] init];
        line.frame = CGRectMake(0, kPageBtn - 1, kScreenWidth, 1);
        line.backgroundColor = [UIColor lightGrayColor];
//        [_topTitleScrollView addSubview:line];
    }
    return _topTitleScrollView;
}

#pragma mark - 添加VC视图的scrollView
- (UIScrollView *)showControllerScrollView{
    if (!_showControllerScrollView) {
        _showControllerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageBtn, kScreenWidth, kScreenHeight - kNavHeight64 - kPageBtn)];
        _showControllerScrollView.delegate = self;
        _showControllerScrollView.tag = 318;
        _showControllerScrollView.backgroundColor = [UIColor whiteColor];
        _showControllerScrollView.contentSize = CGSizeMake(kScreenWidth * self.titleArray.count, 0);
        _showControllerScrollView.pagingEnabled = YES;
        _showControllerScrollView.scrollEnabled = YES;
        _showControllerScrollView.showsHorizontalScrollIndicator = NO;
        _showControllerScrollView.showsVerticalScrollIndicator = NO;
        _showControllerScrollView.alwaysBounceHorizontal = YES;
    }
    return _showControllerScrollView;
}

#pragma mark - 空背景视图（预防scrollView作为第一视图造成View错位）
- (UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight64)];
    }
    return _firstView;
}

#pragma mark - 更多按钮时的背景视图
- (CommonBlackBackView *)backView{
    if (!_backView) {
        _backView = [[CommonBlackBackView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBackView:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

#pragma mark - 更多按钮
- (MoreItemView *)itemView{
    if (!_itemView) {
        _itemView = [[MoreItemView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - kMoreItemViewY) itemsArray:self.titleArray];
        _itemView.backgroundColor = [UIColor clearColor];
        kSelfWeak;
        _itemView.itemViewCancelBlock = ^{
            [weakSelf cancelBlockClick];
        };
        _itemView.scrollToPointViewBlock = ^(NSInteger pointIndex) {
            [weakSelf scrollToPointView:pointIndex];
        };
    }
    return _itemView;
}

#pragma mark - 更新数据
- (void)updateWithTitleArray:(NSArray *)titleArray
                  colorArray:(NSArray *)colorArray
             controllerArray:(NSArray *)controllerArray{
    
    self.titleArray = titleArray;
    self.controllerArray = controllerArray;
    self.colorArray = colorArray;
    
    [self takeRedViewSize];
    
    // 1.添加视图
    [self takeSubView];
    
    // 2.构造数据源
    [self constructionData];
    
    // 3.设置topScrollview 滚动区域
    [self setScrollViewContentSize];
    
    // 4.添加标题按钮
    [self addTitleButton];
    
    // 5.底部移动线
    [self addBottomLine];
}

#pragma mark - 添加子视图
- (void)takeSubView{
    [self addSubview:self.firstView];
    [self addSubview:self.topTitleScrollView];

    [self addSubview:self.showControllerScrollView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.itemView];
    
    [self addSubview:self.addBackgroundView];
    [self addSubview:self.addButton];
    
    // 第一次进来只添加第一个VC
    if (self.controllerArray.count > 0 && self.titleArray.count > 0) {
        NSString *className = self.controllerArray[0];
        Class class = NSClassFromString(className);
        if (class) {
            UIViewController *vc = class.new;
            vc.view.frame = CGRectMake(kScreenWidth * 0, 0, kScreenWidth , kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kPageBtn);
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.view.alpha = 0.8;
            [self.showControllerScrollView addSubview:vc.view];
            viewAlloc[0] = YES;
        }
    }
}

#pragma mark - 构造数据源
- (void)constructionData{
    if (self.colorArray.count >= 3) {
        selectedColor = [self.colorArray objectAtIndex:0];
        unselectedColor = [self.colorArray objectAtIndex:1];
        bottomLineColor = [self.colorArray objectAtIndex:2];
    }
}

#pragma mark - 设置偏移量
- (void)setScrollViewContentSize{
    if (self.titleArray.count > kBaseCount) {
        self.topTitleScrollView.contentSize = CGSizeMake((kScreenWidth/kBaseCount) * self.titleArray.count + kPageBtn, 0);
        line.frame = CGRectMake(0, kPageBtn - 1, (kScreenWidth/kBaseCount) * self.titleArray.count + kPageBtn, 1);
    }else{
        self.topTitleScrollView.contentSize = CGSizeMake(kScreenWidth, 0);
        line.frame = CGRectMake(0, kPageBtn - 1, kScreenWidth, 1);
    }
}

#pragma mark - 添加标题按钮
- (void)addTitleButton{
    btnWidth = self.titleArray.count > kBaseCount ? kScreenWidth / kBaseCount : kScreenWidth / self.titleArray.count; // button的宽度
    for (int i = 0; i < self.titleArray.count; i++) {

        // 标题
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + btnTempTag;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, kPageBtn);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            if (selectedColor) {
                [btn setTitleColor:selectedColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
//            btn.backgroundColor = [UIColor yellowColor];
        }else{
            if (unselectedColor) {
                [btn setTitleColor:unselectedColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
        [self.topTitleScrollView addSubview:btn];
        [self.btnArray addObject:btn];
        
        // 小红点
        CGFloat titleWidth = [[self class] widthWithString:[self.titleArray objectAtIndex:i] font:[UIFont systemFontOfSize:14]];
        CGFloat titleHeight = [[self class] heightWithString:[self.titleArray objectAtIndex:i] font:[UIFont systemFontOfSize:14] constrainedToWidth:btnWidth];
        CGFloat x = (btnWidth - titleWidth)/2 + titleWidth;
        CGFloat y = (kPageBtn - titleHeight)/6;
        SmallRedView *redView = [[SmallRedView alloc] init];
//        redView.backgroundColor = [UIColor greenColor];
        redView.tag = i + btnTempTag * 2;
        redView.frame = CGRectMake(x , y, self.redViewWidth, self.redViewHeight);
        [btn addSubview:redView];
        if (i != 0) {
            redView.hidden = YES;
        }
    }
}

#pragma mark - 移动底线
- (void)addBottomLine{
    self.lineBottom.frame = CGRectMake(0, kPageBtn - kLineBottomHeight, btnWidth, kLineBottomHeight);
    if (bottomLineColor) {
        self.lineBottom.backgroundColor = bottomLineColor;
    }else{
        self.lineBottom.backgroundColor = [UIColor redColor];
    }
    [self.topTitleScrollView addSubview:self.lineBottom];
}

#pragma mark - 标题按钮选择事件
- (void)btnClick:(UIButton *)btn{
    
    self.currentPage = btn.tag - btnTempTag;
    
    
    // 1.公用动画移动
    [self moveAnimotion];
    
    // 2.视图滚动
    [self showControllerScrollViewMove];
    
  
}

#pragma mark - 更多按钮点击事件
- (void)addClick:(UIButton *)btn{
    NSLog(@"点击了添加按钮");
    [self.backView showBackView];
    [self.itemView showMoreItemView];
}

- (void)hiddenBackView:(UITapGestureRecognizer *)tap{
    [self.itemView hiddenMoreItemView];
    [self.backView hiddenBackView];
}

#pragma mark - 取消按钮点击事件
- (void)cancelBlockClick{
    [self.itemView hiddenMoreItemView];
    [self.backView hiddenBackView];
}

#pragma mark - 小红点的隐藏或显示：测试用
- (void)showOrHiddenRedViewWithBtnTag:(NSInteger)btnTag{
    for (UIButton *tempBtn in self.btnArray) {
        if (tempBtn.tag == btnTag) {
            SmallRedView *redView = (SmallRedView *)[tempBtn viewWithTag:btnTag + btnTempTag];
            if (redView) {
                redView.hidden = NO;
                [redView updateDataWithModel:nil];
            }
        }else{
            UIView *redView = (SmallRedView *)[tempBtn viewWithTag:tempBtn.tag + btnTempTag];
            if (redView) {
                redView.hidden = YES;
            }
        }
    }
}

#pragma mark - 公共动画移动
- (void)moveAnimotion{
    // 0.小红点的隐藏或显示
    [self showOrHiddenRedViewWithBtnTag:self.currentPage + btnTempTag];
    
    // 1.底线移动
    [self topScrollViewBottomLineMoveThing];
    
    // 2.顶部滚动栏偏移事件
    [self topScrollViewContentOffThing];
    
    // 3.添加或移动视图
    [self addOrMoveControllerView];
    
    // 4.更新按钮状态
    [self.itemView updateBtnStyleWith:self.currentPage];
}

#pragma mark - 顶部底线移动事件
- (void)topScrollViewBottomLineMoveThing{
    [UIView animateWithDuration:0.35 animations:^{
        for (UIButton *btn in _btnArray) {
            if (btn.tag == self.currentPage + btnTempTag) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        self.lineBottom.frame = CGRectMake(self.currentPage * btnWidth, kPageBtn - kLineBottomHeight, btnWidth, kLineBottomHeight);
    }];
}

#pragma mark - 顶部滚动栏的偏移事件
- (void)topScrollViewContentOffThing{
    if (self.titleArray.count > kBaseCount) {
        CGFloat topTabOffsetX = 0;
        // 新算法
        if (self.currentPage <= kBaseCount / 2) {
            topTabOffsetX = 0*More5LineWidth;
            if (self.titleArray.count > kBaseCount) {
                if (self.currentPage == kBaseCount / 2) {
                    topTabOffsetX =  More5LineWidth/(kBaseCount / 2);
                }
            }
        }else if (self.currentPage > kBaseCount / 2 && self.currentPage < self.titleArray.count - 1){
            topTabOffsetX = (self.currentPage - kBaseCount / 2)*More5LineWidth;
            if (self.titleArray.count > kBaseCount) {
                topTabOffsetX = (self.currentPage - kBaseCount / 2)*More5LineWidth ;
            }
            if (self.titleArray.count - self.currentPage <= kBaseCount / 2 ) {
                topTabOffsetX = (self.titleArray.count - kBaseCount)*More5LineWidth;
            }
        }else if (self.currentPage == self.titleArray.count - 1){
            if (self.titleArray.count > kBaseCount) {
                topTabOffsetX = (self.currentPage - kBaseCount + 1)*More5LineWidth + kPageBtn;
            }else{
                topTabOffsetX = (self.currentPage - kBaseCount + 1)*More5LineWidth;
            }
        }
        [self.topTitleScrollView setContentOffset:CGPointMake(topTabOffsetX, 0) animated:YES];
    }
}

#pragma mark - 点击滚动按钮时添加或移动控制器视图
- (void)addOrMoveControllerView{
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        if (self.currentPage == i && i <= self.controllerArray.count - 1) {
            NSString *className = self.controllerArray[i];
            Class class = NSClassFromString(className);
            if (class && viewAlloc[i] == NO) {
                UIViewController *vc = class.new;
                vc.view.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight - kNavHeight64 - kPageBtn);
                vc.view.alpha = 1;
                [self.showControllerScrollView addSubview:vc.view];
                vc.view.backgroundColor = [UIColor whiteColor];
                 vc.view.alpha = 0.8;
                viewAlloc[i] = YES;
            }else if (!class) {
                NSLog(@"您所提供的vc%li类并没有找到。  Your Vc%li is not found in this project!",(long)i + 1,(long)i + 1);
            }
        }else if (self.currentPage == i && i > self.controllerArray.count - 1) {
            NSLog(@"您没有配置对应Title%li的VC",(long)i + 1);
        }
    }
}

#pragma mark - 视图控制器滚动
- (void)showControllerScrollViewMove{
    [self.showControllerScrollView setContentOffset:CGPointMake(kScreenWidth * self.currentPage, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 318) {
        self.currentPage = (NSInteger)(scrollView.contentOffset.x / kScreenWidth);
        // 公共动画移动
        [self moveAnimotion];
    }
}

#pragma mark - 跳转到指定页面
- (void)scrollToPointView:(NSInteger)pointIndex{
    [self.itemView hiddenMoreItemView];
    [self.backView hiddenBackView];
    self.currentPage = pointIndex;
    [self moveAnimotion];
    [self showControllerScrollViewMove];
}

#pragma mark- 单行文字宽度
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGRect rtRect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rtRect.size.width;
}

#pragma mark - 计算高度
+ (CGFloat)heightWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGRect rtRect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rtRect.size.height;
}
@end
