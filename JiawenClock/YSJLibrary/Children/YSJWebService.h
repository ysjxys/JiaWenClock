//
//  YSJWebService.h
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <Reachability.h>
#import <MBProgressHUD.h>
#import "NSObject+YSJ.h"

//post/get
typedef void (^CompleteHandle)(id response);
typedef void (^FailHandle)(NSURLSessionTask *operation, NSError *error);
//download
typedef void (^ProgressHandle)(NSProgress *downloadProgress);
typedef NSURL *(^DestinationHandle)(NSURL *targetPath, NSURLResponse *response);
typedef void (^CompletionHandle)(NSURLResponse *response, NSURL *filePath, NSError *error);


@interface YSJWebService : NSObject

/**
 *  POST/GET 一般网络请求
 */
+ (NSURLSessionDataTask *)requestTarget:(id)target withUrl:(NSString *)urlStr isPost:(BOOL)isPost parameters:(NSDictionary *)params complete:(CompleteHandle)completeHandle fail:(FailHandle)failHandle;

/**
 *  POST/GET 带header的网络请求
 */
+ (NSURLSessionDataTask *)requestTarget:(id)target withUrl:(NSString *)urlStr isPost:(BOOL)isPost parameters:(NSDictionary *)params headerKey:(NSString *)headerKey header:(NSString *)header complete:(CompleteHandle)completeHandle fail:(FailHandle)failHandle;

/**
 *  下载请求
 */
+ (NSURLSessionDownloadTask *)requestDownloadTarget:(id)target withUrl:(NSString *)urlStr progress:(ProgressHandle)progress destination:(DestinationHandle)destination complete:(CompletionHandle)complete;

@end
