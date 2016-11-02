//
//  NSString+YSJ.h
//  ysjLib
//
//  Created by ysj on 15/12/4.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (YSJ)

/**
 *  获得文件路径size大小以longlong形式展现
 */
- (unsigned long long)fileSizeLongLong;

/**
 *  获得文件路径size大小以string形式展现
 */
- (NSString *)fileSizeString;

/**
 *  获得Library路径
 */
+ (NSString *)stringWithLibrary;

/**
 *  获得Cache路径
 */
+ (NSString *)stringWithCacheDir;

/**
 *  获得Document路径
 */
+ (NSString *)stringWithDocumentDir;

/**
 *  获得Temp路径
 */
+ (NSString *)stringWithTempDir;

/**
 *  输入formatterStr，返回对应格式转化后的NSDate
 */
- (NSDate *)stringToDateWithFormatterStr:(NSString *)formatterStr;

/**
 *  返回默认formatter的对应NSDate
 *  默认formatter为@"yyyy-MM-dd HH:mm:ss"
 */
- (NSDate *)stringToDateWithDefaultFormatterStr;

/**
 *  返回某段文本的所占size大小，font为文本字体，maxSize为可容许的最大大小
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  MD5加密
 */
- (NSString *)md5HexDigest;

/**
 *  去特殊字符
 */
- (NSString *)trimStr:(NSString *)str;

/**
 *  解码base64加密的字符串并返回
 */
- (NSString *)base64Decoded:(NSString *)base64Str;

/**
 *  解码base64加密的字符串并将json转换为dictionary返回
 */
- (NSDictionary *)base64DecodeAndTransform:(NSString *)base64String;

@end
