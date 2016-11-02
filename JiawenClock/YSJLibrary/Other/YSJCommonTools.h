//
//  YSJCommonTools.h
//  ysjLib
//
//  Created by ysj on 16/6/28.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSJCommonTools : NSObject

- (void)setExampleDic:(NSDictionary *)exampleDic;
- (NSDictionary *)exampleDic;

/**
 *  公共实例获取方法
 */
+ (YSJCommonTools *)shareTools;

/**
 *  获得某个类的所有属性
 */
- (NSArray *)getAllProperties:(id)propertiClass;

/**
 *  获得某个实例的所有属性与值
 */
- (NSDictionary *)getAllPropertiesAndValues:(id)purposeClass;

/**
 *  输出一个类的所有方法名与参数数量
 */
-(void)printAllMethod:(id)purposeClass;
@end
