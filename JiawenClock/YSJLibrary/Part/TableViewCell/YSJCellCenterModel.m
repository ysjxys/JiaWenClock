//
//  YSJCellCenterModel.m
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJCellCenterModel.h"

@implementation YSJCellCenterModel

- (instancetype)initWithCenterModelType:(CenterModelType)centerModelType{
    if (self = [super init]) {
        self.centerModelType = centerModelType;
    }
    return self;
}

+ (instancetype)modelWithCenterModelType:(CenterModelType)centerModelType{
    return [[self alloc]initWithCenterModelType:centerModelType];
}
@end
