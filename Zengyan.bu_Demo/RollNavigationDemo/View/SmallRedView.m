//
//  SmallRedView.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/7/3.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  小红点

#import "SmallRedView.h"
@interface SmallRedView()

@property (nonatomic, strong)   UIImageView *imageView; /// 小红点图片
@property (nonatomic, strong)   UILabel *label;         /// 小红点数据

@property (nonatomic, assign)   CGFloat redViewWidth ;
@property (nonatomic, assign)   CGFloat redViewHeight;

@end
@implementation SmallRedView

- (id)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.imageView];
    [self addSubview:self.label];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"num-bg2@2x.png"];
        self.redViewWidth = image.size.width;
        self.redViewHeight = image.size.height;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.redViewWidth, self.redViewHeight)];
        _imageView.image = image;
    }
    return _imageView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.redViewWidth, self.redViewHeight)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.text = @"3";
    }
    return _label;
}

#pragma mark - 更新数据
- (void)updateDataWithModel:(id)model{
//    NSString *str = @"999";
    self.label.text = @"3";
    /*
    if ([redModel.orderCount integerValue ] == 0 && [redModel.deliOrderCount integerValue] == 0) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    
        // 设置显示label
        self.label.text = str;
        CGFloat textWidth = [[self class] widthWithString:str font:[UIFont systemFontOfSize:12]];
        
        
        UIImage *image = [UIImage imageNamed:@"num-bg2@2x.png"];
        self.imageView.frame = CGRectMake(0, 0, textWidth, image.size.height);
        CGFloat top = 5;
        CGFloat left = 5;
        CGFloat bottom = 5;
        CGFloat right = 5;
        
        // 设置端盖的值
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        // 设置拉伸的模式
        UIImageResizingMode mode = UIImageResizingModeStretch;
        
        // 拉伸图片
        UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
        self.imageView.image = newImage;
        self.label.frame = CGRectMake(2.5, 0, textWidth - 5, image.size.height);
        self.fram.size =
        self.frame.size = CGSizeMake(newImage.size.width, self.frame.size.height);
    }
     */

}

#pragma mark- 单行文字宽度
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGRect rtRect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rtRect.size.width;
}

#pragma mark - 计算高度
+ (CGFloat)heightWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGRect rtRect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rtRect.size.height;
    
}
@end
