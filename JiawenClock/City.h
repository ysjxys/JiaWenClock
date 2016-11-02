//
//  City.h
//  JiawenClock
//
//  Created by ysj on 16/10/31.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;

+ (instancetype)cityWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
