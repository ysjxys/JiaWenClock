//
//  YSJCellHeadingModel.m
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJCellHeadingModel.h"

@implementation YSJCellHeadingModel

- (instancetype)initWithHeadingModelType:(HeadingModelType)headingModelType{
    if (self = [super init]) {
        self.headingModelType = headingModelType;
        self.headViewWHCompareDegree = headingModelType==HeadingModelNull?0.0f:1.0f;
    }
    return self;
}

+ (instancetype)modelWithHeadingModelType:(HeadingModelType)headingModelType{
    return [[self alloc] initWithHeadingModelType:headingModelType];
}
@end
