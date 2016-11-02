//
//  WorkTypeModel.h
//  JiawenClock
//
//  Created by ysj on 16/9/27.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTypeModel : NSObject

@property (nonatomic, copy) NSString *loveName;
@property (nonatomic, assign) int workTypeId;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

+ (instancetype)workTypeWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
