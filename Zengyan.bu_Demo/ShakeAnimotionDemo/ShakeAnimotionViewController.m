//
//  ShakeAnimotionViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/16.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  抖动效果

#define Angle2Radian(angle) ((angle)/180.0*M_PI)
#define kDistanceX (30)
#define kDistanceY (120.0f)
#define kBasicCount 4
#define kButtonWidth (kScreenWidth - kDistanceX * (kBasicCount + 1))/kBasicCount
#define kButtonHeight (kButtonWidth)
#define kTime 0.2
#define kTempTag 10000

#import "ShakeAnimotionViewController.h"

@interface ShakeAnimotionViewController ()

@property (nonatomic, strong)   UIImageView  *bgView;                    /// 背景View
@property (nonatomic, strong)   NSMutableArray  *titleArray;        /// 按钮标题
@property (nonatomic, strong)   NSMutableArray  *btnArray;          /// 按钮数组
@property (nonatomic, strong)   NSMutableArray  *btnOverViewArray;  //
@property (nonatomic, strong)   NSMutableArray  *deleteViewArray;   /// 删除标识按钮
@end

@implementation ShakeAnimotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"仿苹果手机界面";
    [self.view addSubview:self.bgView];
    [self takeSubButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainTapClick)];
    [self.view addGestureRecognizer:tap];
}

- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgView.image = [UIImage imageNamed:@"003.png"];
    }
    return _bgView;
}

#pragma mark - 初始化各个数据源
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"QQ",@"微信",@"QQ空间",@"头条",@"网易",@"网易音乐",@"支付宝",@"12306",@"企业微信",@"天气",@"京东",@"淘宝",@"天猫",@"亚马逊",@"闲鱼",@"直播吧",@"爱奇艺",@"苏宁",@"百度地图",@"高德",@"脑点子",@"图片",@"电话", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}

- (NSMutableArray *)btnOverViewArray{
    if (!_btnOverViewArray) {
        _btnOverViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnOverViewArray;
}


- (NSMutableArray *)deleteViewArray{
    if (!_deleteViewArray) {
        _deleteViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _deleteViewArray;
}

#pragma mark - 添加button
- (void)takeSubButton{
    // 行数
    NSInteger rowCount = self.titleArray.count % kBasicCount == 0 ? self.titleArray.count / kBasicCount : self.titleArray.count / kBasicCount + 1;
    NSInteger count = 0;
    for (int i = 0 ; i < rowCount; i ++) {
        for (int j = 0; j < kBasicCount; j ++) {
            if (count >= self.titleArray.count) {
                return;
            }
            // 1.基本按钮
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kDistanceX + (kDistanceX + kButtonWidth) * j, kDistanceY + (kDistanceX + kButtonHeight) * i, kButtonWidth, kButtonHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            NSString *btnStr = [self.titleArray objectAtIndex:count];
            [button setTitle:btnStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = UIColorHex(0x0079BF);
            [button addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 14;
            button.tag = count + kTempTag;
            [self.view addSubview:button];
            [self.btnArray addObject:button];
            
            
            // 2.长按
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sublongPressClick:)];
            [button addGestureRecognizer:longPress];
            
            // 3.覆盖View
            UIView *overView = [[UIView alloc] init];
            overView.frame = CGRectMake(0, 0, kButtonWidth, kButtonHeight);
            overView.backgroundColor = [UIColor blackColor];
            overView.alpha = 0.1;
            [button addSubview:overView ];
            overView.hidden = YES;
            [self.btnOverViewArray addObject:overView];
            
            // 4.删除按钮
            UIButton *spaceOverButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
            spaceOverButton.frame = CGRectMake(button.frame.origin.x - 5, button.frame.origin.y - 5, kButtonWidth , kButtonHeight);
            spaceOverButton.backgroundColor = [UIColor clearColor];
            [spaceOverButton addTarget:self action:@selector(subTapClick:) forControlEvents:UIControlEventTouchUpInside];
            spaceOverButton.tag = kTempTag * 10 + count;
            [self.view addSubview:spaceOverButton ];
            spaceOverButton.hidden = YES;
            
            CGFloat labelWidth = 15;
            CGFloat labelHeight = 15;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
            label.backgroundColor = [UIColor whiteColor];
            label.alpha = 0.8;
            label.textColor = [UIColor redColor];
            label.text = @"X";
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = labelWidth / 2;
            label.font = [UIFont boldSystemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            [spaceOverButton addSubview:label];
            [self.deleteViewArray addObject:spaceOverButton];
    
            count++;
        }
    }
}

#pragma mark - 点击左右抖动效果
- (void)subBtnClick:(UIButton *)btn{
    NSString *btnStr = [self.titleArray objectAtIndex:btn.tag - kTempTag];
    NSLog(@"抖动了%@",btnStr);
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = kTime;
    CGFloat delta = 10;
    shakeAnim.values = @[@0 , @(-delta), @(delta), @0];
    shakeAnim.repeatCount = 3;
    [btn.layer addAnimation:shakeAnim forKey:nil];
}

#pragma mark - 长按抖动效果
- (void)sublongPressClick:(UIGestureRecognizer *)tap{
    for (UIButton *button in self.btnArray) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.keyPath = @"transform.rotation";
        anim.values = @[@(Angle2Radian(-3)), @(Angle2Radian(3)), @(Angle2Radian(-3))];
        anim.duration = kTime;
        // 动画次数设置为最大
        anim.repeatCount = MAXFLOAT;
        // 保持动画执行完毕后的状态
        anim.removedOnCompletion = YES;
        anim.fillMode = kCAFillModeForwards;
        [button.layer addAnimation:anim forKey:@"shake"];
        for (UIView *buttonSubView in button.subviews) {
            buttonSubView.hidden = NO;
        }
    }
    
    for (UIView *spaceView in self.deleteViewArray) {
        spaceView.hidden = NO;
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.keyPath = @"transform.rotation";
        anim.values = @[@(Angle2Radian(-3)), @(Angle2Radian(3)), @(Angle2Radian(-3))];
        anim.duration = kTime;
        // 动画次数设置为最大
        anim.repeatCount = MAXFLOAT;
        // 保持动画执行完毕后的状态
        anim.removedOnCompletion = YES;
        anim.fillMode = kCAFillModeForwards;
        [spaceView.layer addAnimation:anim forKey:@"shakeSpace"];
    }
}

#pragma mark - 删除事件
- (void)subTapClick:(UIButton *)btn{
    
#warning 未完待续。。。
    for (UIView *subView in self.view.subviews) {
        if (![subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (self.titleArray.count > 0) {
        [self.titleArray removeObjectAtIndex:btn.tag - kTempTag * 10 ];
        [self.btnArray removeAllObjects];
        [self.btnOverViewArray removeAllObjects];
        [self takeSubButton];
    }
    /*
     for (UIView *spaceView in self.deleteViewArray) {
     [spaceView.layer removeAnimationForKey:@"shakeSpace"];
     spaceView.hidden = YES;
     }
     
     for (int i = 0 ; i < self.btnArray.count; i ++) {
     UIButton *button = [self.btnArray objectAtIndex:i];
     [button.layer removeAnimationForKey:@"shake"];
     NSString *btnStr = [self.titleArray objectAtIndex:i];
     [button setTitle:btnStr forState:UIControlStateNormal];
     
     for (UIView *btnOverView in self.btnOverViewArray) {
     btnOverView.hidden = YES;
     }
     }
     */
}

#pragma mark - 点击空白处恢复常规状态
- (void)mainTapClick{
    for (UIView *spaceView in self.deleteViewArray) {
        [spaceView.layer removeAnimationForKey:@"shakeSpace"];
        spaceView.hidden = YES;
    }
    for (int i = 0 ; i < self.btnArray.count; i ++) {
        UIButton *button = [self.btnArray objectAtIndex:i];
        [button.layer removeAnimationForKey:@"shake"];
        NSString *btnStr = [self.titleArray objectAtIndex:i];
        [button setTitle:btnStr forState:UIControlStateNormal];
        
        for (UIView *btnOverView in self.btnOverViewArray) {
            btnOverView.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
