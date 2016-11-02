//
//  YSJCellModel.m
//  JiawenClock
//
//  Created by ysj on 16/8/23.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJCellModel.h"
#import "YSJCellHeadingModel.h"
#import "YSJCellCenterModel.h"
#import "YSJCellTrailingModel.h"

@implementation YSJCellModel

+ (instancetype)modelWithHeadingModel:(YSJCellHeadingModel *)headingModel centerModel:(YSJCellCenterModel *)centerModel tailingModel:(YSJCellTrailingModel *)trailingModel selectedHandle:(SelectedHandle)selectedHandle{
    return [[self alloc]initWithHeadingModel:headingModel centerModel:centerModel trailingModel:trailingModel selectedHandle:selectedHandle];
}

- (instancetype)initWithHeadingModel:(YSJCellHeadingModel *)headingModel centerModel:(YSJCellCenterModel *)centerModel trailingModel:(YSJCellTrailingModel *)trailingModel selectedHandle:(SelectedHandle)selectedHandle{
    if (self = [super init]) {
        self.headingModel = headingModel;
        self.centerModel = centerModel;
        self.trailingModel = trailingModel;
        self.selectedHandle = selectedHandle;
        self.cellContentHeightPercentDegree = 1.0f;
        self.cellContentBorderDegree = 0.0f;
        self.cellHeight = 44.0f;
    }
    return self;
}

@end
