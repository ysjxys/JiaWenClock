//
//  CityGroup.h
//  JiawenClock
//
//  Created by ysj on 16/10/31.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;

@interface CityGroup : NSObject

@property (nonatomic, copy) NSString *charMark;
@property (nonatomic, strong) NSMutableArray<City *> *cityArr;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)groupWithDic:(NSDictionary *)dic;

@end
