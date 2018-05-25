//
//  BY_TimeCountDownManager.h
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/2/6.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  倒计时管理类

#import <Foundation/Foundation.h>

/**
 *  倒计时完成block
 */
typedef void(^BY_TimeCountDownCompleteBlock)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second);

@interface BY_TimeCountDownManager : NSObject

/**
 *  单利创建倒计时，适合cell用
 *  单个倒计时创建时，最好用alloc 创建，避免销毁不及时
 
 *  @return    BY_TimeCountDownManager
 */
+ (instancetype)ShareBY_TimeCountDownManager;

/**
 *  用NSDate日期倒计时
 
 *  @param  startDate   开始时间
 *  @param  endDate     结束时间
 *  @param  completeBlock   倒计时结束的回调
 */
- (void)bY_timeCountDownWithStartTime:(NSDate *)startDate
                              endDate:(NSDate *)endDate
                        completeBlock:(BY_TimeCountDownCompleteBlock)completeBlock;

/**
 *  用timeStamp时间戳倒计时
 
 *  @param  startTimeStamp  开始时间
 *  @param  endTimeStamp    结束时间
 *  @param  completeBlock   倒计时结束回调
 */
- (void)bY_timeCountDownWithStartTimeStamp:(long long)startTimeStamp
                              endTimeStamp:(long long)endTimeStamp
                             completeBlock:(BY_TimeCountDownCompleteBlock)completeBlock;

/**
 *  用秒做倒计时
 
 *  @param  secondTime  秒数
 *  @param  completeBlock   倒计时完成回调
 */
- (void)bY_timeCountDownWithSecondTime:(long long)secondTime
                         completeBlock:(BY_TimeCountDownCompleteBlock)completeBlock;


/**
 *  每秒走一次的回调block
 
 *  @parma  PER_SECBlock    回到block
 */
- (void)bY_timeCountDownWithPER_SECBlock:(void(^)(void))PER_SECBlock;

/**
 *  当前时间与结束时间对比
 
 *  @parma  timestring  时间
 */
- (void)bY_timeGetNowTimeWithTimeString:(NSString *)timeString;

/**
 *  将时间戳转化为NSDate
 
 *  @parma  longlongValue
 *  @return NSDate  日期
 */
- (NSDate *)bY_timeDateWithLongLongValue:(long long)longlongValue;

/**
 *  根据传入的年月份获取该月份的天数
 
 *  @param  year    年份
 *  @param  month   月份
 *  @return   天数
 */
- (NSInteger)bY_getDayNumberWithYear:(NSInteger )year month:(NSInteger)month;

/**
 *  主动销毁定时器
 */
- (void)bY_timeDestoryTimer;

@end
