//
//  CustomMAAnnotationView.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/24.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

#import "CustomMAAnnotationView.h"

@interface CustomMAAnnotationView ()

@property (nonatomic, strong, readwrite) CustomCallOutView *calloutView;

@end

@implementation CustomMAAnnotationView

#pragma mark - 重写选中方法setSelected，选中时新建并添加callOutView，传入数据；非选中时删除callOutView。
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSLog(@"selected =  %d",self.selected);
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[CustomCallOutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"004.png"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subTitle = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

@end
