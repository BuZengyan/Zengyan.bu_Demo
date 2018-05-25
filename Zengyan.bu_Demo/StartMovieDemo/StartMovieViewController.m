//
//  StartMovieViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/18.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  启动页视屏

#define kDistanceX (60.0f)
#define kButtonHeight (44.0f)
#define kBottomY (60.0f)
#import "StartMovieViewController.h"
#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface StartMovieViewController ()<AVPlayerViewControllerDelegate>

@property (nonatomic, strong)   AVPlayer *player;    /// 播放

@end

@implementation StartMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imageView];
    [self setupAVPlayer];
}

#pragma mark - 初始化控件
- (AVPlayer *)player{
    if (!_player ) {
        AVPlayerItem *playerItem = [self getPlayItem];
        _player = [[AVPlayer alloc]initWithPlayerItem:playerItem]; // 可以利用 AVPlayerItem 对这个视频的状态进行监控
    }
    return _player;
}

- (AVPlayerItem *)getPlayItem{
    // 通过文件 URL 来实例化 AVPlayerItem 选择本地的视屏
    self.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"qidong"ofType:@"mp4"]];
    NSURL *saveUrl = self.movieURL;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:saveUrl];
    return playerItem;
}

- (void)setupAVPlayer{
    // 播放视图层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.view.layer addSublayer:playerLayer];
    [self.player play];
    
    // 播放完的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    // 登录按钮
    [self setupLoginView];
}

#pragma mark - 进入按钮
- (void)setupLoginView{
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake(kDistanceX, kScreenHeight - kBottomY - kButtonHeight ,kScreenWidth - kDistanceX * 2, kButtonHeight);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = kButtonHeight / 2;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    enterMainButton.alpha = 0;
    [self.view addSubview:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:3.0 animations:^{
        enterMainButton.alpha = 0.6;
    }];
}

#pragma mark - NSNotificationCenter循环播放
- (void)moviePlayDidEnd:(NSNotification *)noti{
    AVPlayerItem * playerItem = [noti object];
    [playerItem seekToTime:kCMTimeZero];    //关键代码
    [self.player play];
}

#pragma mark - 进入应用
- (void)enterMainAction:(UIButton *)btn {
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.view.window.rootViewController = nav;
    [self.view.window makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
