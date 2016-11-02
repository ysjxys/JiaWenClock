//
//  WorkDayCellModel.h
//  JiawenClock
//
//  Created by ysj on 16/8/26.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJCellModel.h"

@interface WorkDayCellModel : YSJCellModel

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL isPlaned;
@property (nonatomic, strong) NSNumber *workDayType;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *loveName;

+ (instancetype)modelWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
