//
//  CityGroup.m
//  JiawenClock
//
//  Created by ysj on 16/10/31.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "CityGroup.h"
#import "City.h"

@implementation CityGroup

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *cityDic in dic[@"citys"]) {
            City *city = [City cityWithDic:cityDic];
            [array addObject:city];
        }
        self.cityArr = array;
        self.charMark = dic[@"key"];
    }
    return self;
}

+ (instancetype)groupWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end
