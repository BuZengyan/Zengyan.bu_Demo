//
//  BY_TimeCountDownManager.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/2/6.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  倒计时管理类

#import "BY_TimeCountDownManager.h"
@interface BY_TimeCountDownManager()

@property (nonatomic, strong)   dispatch_source_t timer;
@property (nonatomic, strong)   NSDateFormatter *dateFormatter;

@end
@implementation BY_TimeCountDownManager

#pragma mark - 创建单利

+ (instancetype)ShareBY_TimeCountDownManager{
    static dispatch_once_t onceToken;
    static BY_TimeCountDownManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[BY_TimeCountDownManager alloc] init];
    });
    return manager;
}

#pragma mark - 重写init方法
- (instancetype)init{
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        [self.dateFormatter setTimeZone:localTimeZone];
    }
    return self;
}

#pragma mark - 用日期倒计时
- (void)bY_timeCountDownWithStartTime:(NSDate *)startDate
                              endDate:(NSDate *)endDate
                        completeBlock:(BY_TimeCountDownCompleteBlock)completeBlock{
    if (_timer == nil) {
        NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
        __block int timeOut = timeInterval;
        if (timeOut != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);/// 每秒执行
            
            dispatch_source_set_event_handler(_timer, ^{
                if (timeOut <= 0) {
                    // 倒计时结束关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0,0,0,0);
                    });
                }else{
                    // 开始倒计时
                    int days = (int)(timeOut / (3600 * 24));
                    int hours = (int)((timeOut - days * 24 * 3600) / 3600);
                    int minute = (int)((timeOut - days * 24 * 3600 - hours * 3600) / 60);
                    int second = (int)(timeOut - days * 24 * 3600 - hours * 3600 - minute * 60);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeOut--;
                }
            });
            dispatch_resume(_timer);   /// 恢复队列
        }
    }
}

#pragma mark - 时间戳倒计时
- (void)bY_timeCountDownWithStartTimeStamp:(long long)startTimeStamp
                              endTimeStamp:(long long)endTimeStamp
                             completeBlock:(BY_TimeCountDownCompleteBlock)completeBlock{
    // 将时间戳转换为日期
    NSDate *startDate = [self bY_timeDateWithLongLongValue:startTimeStamp];
    NSDate *endDate = [self bY_timeDateWithLongLongValue:endTimeStamp];
    [self bY_timeCountDownWithStartTime:startDate endDate:endDate completeBlock:completeBlock];
}

#pragma mark - 时间戳转化为NSDate
- (NSDate *)bY_timeDateWithLongLongValue:(long long)longlongValue{
    long long value = longlongValue / 1000;
    NSNumber *time = [NSNumber numberWithLongLong:value];
    // 转换为NSTimeInterval
    NSTimeInterval timeInterval = [time longValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    return date;
}

@end
