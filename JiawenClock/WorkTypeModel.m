//
//  WorkTypeModel.m
//  JiawenClock
//
//  Created by ysj on 16/9/27.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WorkTypeModel.h"

@implementation WorkTypeModel


+ (instancetype)workTypeWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.loveName = dic[LoveNameKey];
        self.startTime = dic[StartTimeKey];
        self.endTime = dic[EndTimeKey];
        self.workTypeId = [dic[@"id"] intValue];
    }
    return self;
}

@end
