//
//  DrawCurveViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/16.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  画圆角曲线

#define kImageViewHeight (60.0f)
#define kDistanceX (20.0f)
#define kDistanceY (30.0f)
#define kTopY (100.0f)
#define kBgViewSize (kScreenWidth)
#define kButtonHeight (44.0f)
#define kButtonWidth (kScreenWidth / 3)
#define kTempTag 1000
#define kTime 0.35
#define kRounedSize (100.0f)
#define kSquareSize (160.0f)

#import "DrawCurveViewController.h"

@interface DrawCurveViewController ()

@property (nonatomic,strong)    CAShapeLayer    *shapeLayer;
@property (nonatomic,strong)    UIImageView     *imageView;         /// 矩形圆角曲线
@property (nonatomic, assign)   CGFloat         tempValue;




@end

@implementation DrawCurveViewController

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDistanceX, kTopY + (kBgViewSize - kImageViewHeight) / 2, kScreenWidth - kDistanceX * 2,kImageViewHeight)];
        _imageView.layer.cornerRadius = 12;
        self.tempValue = 12;
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = UIColorHex(0x0079BF).CGColor;   // 虚线颜色
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;   // 填充颜色
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:self.tempValue];
        _shapeLayer.path = path.CGPath;
        _shapeLayer.frame = self.imageView.bounds;
        _shapeLayer.lineWidth = 1;
        _shapeLayer.lineCap = @"round";
        _shapeLayer.lineDashPattern = @[@3, @3];    // 设置虚线
    }
    return _shapeLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"圆角曲线";
    self.view.backgroundColor = UIColorHex(0xF0F0F1);
    [self.view addSubview:self.imageView];
    [self.imageView.layer addSublayer:self.shapeLayer];
    [self addButton];
}

- (void)addButton{

    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithObjects:@"圆角矩形",@"圆",@"正方形", nil];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kButtonWidth * i, kScreenHeight - kButtonHeight * 2, kButtonWidth, kButtonHeight);
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = kTempTag + i;
        btn.backgroundColor = UIColorHex(0x0079BF);
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    if (btn.tag == 0 + kTempTag) {
        // 原始状态
        [UIView animateWithDuration:kTime animations:^{
            self.imageView.frame = CGRectMake(kDistanceX, kTopY + (kBgViewSize - kImageViewHeight) / 2, kScreenWidth - kDistanceX * 2,kImageViewHeight);
            self.imageView.layer.cornerRadius = 12;
            self.tempValue = 12;
            [self.imageView.layer addSublayer:self.shapeLayer];
        }];
    }else if (btn.tag == 1 + kTempTag){
        // 圆形
        [UIView animateWithDuration:kTime animations:^{
            self.imageView.frame = CGRectMake((kScreenWidth - kRounedSize) / 2, kTopY + (kBgViewSize - kImageViewHeight) / 2, kRounedSize,kRounedSize);
            self.imageView.layer.cornerRadius = kRounedSize / 2;
            self.tempValue = kRounedSize / 2;
            [self.imageView.layer addSublayer:self.shapeLayer];
        }];
    }else if (btn.tag == 2 + kTempTag){
        // 正方形
        [UIView animateWithDuration:kTime animations:^{
            self.imageView.frame = CGRectMake((kScreenWidth - kSquareSize) / 2,kTopY +  (kBgViewSize - kImageViewHeight) / 2, kSquareSize,kSquareSize);
            self.imageView.layer.cornerRadius = 0;
            self.tempValue = 0;
            [self.imageView.layer addSublayer:self.shapeLayer];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
