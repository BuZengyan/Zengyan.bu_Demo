//
//  EightViewController.m
//  CustomRollNavigaitionbarManager
//
//  Created by zengyan.bu on 2017/6/29.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//

#import "EightViewController.h"

@interface EightViewController ()

@end

@implementation EightViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height)];    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"EightVC";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
