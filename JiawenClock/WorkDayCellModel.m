//
//  WorkDayCellModel.m
//  JiawenClock
//
//  Created by ysj on 16/8/26.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WorkDayCellModel.h"

@implementation WorkDayCellModel


+ (instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.date = dic[WorkDateKey];
        self.isPlaned = [dic[IsPlanedKey] boolValue];
        if (self.isPlaned) {
            self.workDayType = dic[WorkTypeKey];
            self.startTime = dic[StartTimeKey];
            self.endTime = dic[EndTimeKey];
            self.loveName = dic[LoveNameKey];
        }
    }
    return self;
}
@end
