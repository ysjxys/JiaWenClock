//
//  WeatherDay.h
//  JiawenClock
//
//  Created by ysj on 16/10/26.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDay : NSObject


@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int minTemperature;
@property (nonatomic, assign) int maxTemperature;
@property (nonatomic, copy) NSString *weatherDetail;
@property (nonatomic, assign) int wetPercent;
@property (nonatomic, assign) int rainPossiblePercent;
@property (nonatomic, copy) NSString *windPower;
@property (nonatomic, copy) NSString *windDir;

+ (instancetype)weatherWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
