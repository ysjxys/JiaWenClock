//
//  WeatherDay.m
//  JiawenClock
//
//  Created by ysj on 16/10/26.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WeatherDay.h"
#import "NSDate+YSJ.h"
#import "NSString+YSJ.h"

@implementation WeatherDay

+ (instancetype)weatherWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.date = [dic[@""] stringToDateWithFormatterStr:@"yyyy-MM-dd"];
        self.minTemperature = [dic[@"tmp"][@"min"] intValue];
        self.maxTemperature = [dic[@"tmp"][@"max"] intValue];
        self.weatherDetail = dic[@"cond"][@"txt_d"];
        self.wetPercent = [dic[@"hum"] intValue];
        self.rainPossiblePercent = [dic[@"pop"] intValue];
        self.windPower = dic[@"wind"][@"sc"];
        self.windDir = dic[@"wind"][@"dir"];
    }
    return self;
}

@end
