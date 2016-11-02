//
//  City.m
//  JiawenClock
//
//  Created by ysj on 16/10/31.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "City.h"

@implementation City

+ (instancetype)cityWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.pinyin = dic[@"pinyin"];
        self.Id = dic[@"id"];
        self.province = dic[@"province"];
        self.city = dic[@"city"];
        self.town = dic[@"town"];
    }
    return self;
}

@end
