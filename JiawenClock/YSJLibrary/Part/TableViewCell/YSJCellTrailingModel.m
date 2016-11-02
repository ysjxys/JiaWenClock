//
//  YSJCellTailingModel.m
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJCellTrailingModel.h"

@implementation YSJCellTrailingModel

- (instancetype)initWithTrailingModelType:(TrailingModelType)trailingModelType{
    if (self = [super init]) {
        self.trailingModelType = trailingModelType;
        self.trailViewWHCompareDegree = trailingModelType==TrailingModelNull?0.0f:1.0f;
    }
    return self;
}

+ (instancetype)modelWithTrailingModelType:(TrailingModelType)trailingModelType{
    return [[self alloc]initWithTrailingModelType:trailingModelType];
}

@end
