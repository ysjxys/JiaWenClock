//
//  YSJWebService.m
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJWebService.h"
#import "AFNetworking.h"

#define NetIsNotConnected @"网络连接不可用"
#define UsingMobileNet @"正在使用移动网络"


@interface YSJWebService()

@end
@implementation YSJWebService

/**
 *  POST/GET 带header的网络请求
 */
+ (NSURLSessionDataTask *)requestTarget:(id)target withUrl:(NSString *)urlStr isPost:(BOOL)isPost parameters:(NSDictionary *)params headerKey:(NSString *)headerKey header:(NSString *)header complete:(CompleteHandle)completeHandle fail:(FailHandle)failHandle{
    MBProgressHUD *hud;
    if (!target) {
        return nil;
    }else{
        hud = [[MBProgressHUD alloc]initWithView:[(UIViewController *)target view]];
        [[(UIViewController *)target view] addSubview:hud];
        [hud show:YES];
    }
    
    Reachability *reachabiltiy = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (!reachabiltiy.isReachable) {
        //        NotReachable = 0,
        //        ReachableViaWiFi = 2,
        //        ReachableViaWWAN = 1
        [hud removeFromSuperview];
        [self showHudWithTarget:target title:NetIsNotConnected];
        return nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    if (headerKey && header) {
        [manager.requestSerializer setValue:header forHTTPHeaderField:headerKey];
    }
    //输入拼装后的url
    [self printUrlInfo:params withUrl:urlStr];
    NSURLSessionDataTask *dataTask;
    if (isPost) {
        dataTask = [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            //获取到目前的数据请求的进度
            NSLog(@"%lld", uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            completeHandle(responseObject);
            [hud removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hud removeFromSuperview];
            [self showHudWithTarget:target title:@"服务器繁忙"];
            if (failHandle) {
                failHandle(task,error);
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else{
        dataTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            //获取到目前的数据请求的进度
            NSLog(@"%lld", downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            completeHandle(responseObject);
            [hud removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hud removeFromSuperview];
            [self showHudWithTarget:target title:@"服务器繁忙"];
            if (failHandle) {
                failHandle(task,error);
            }else{
                NSLog(@"%@",error);
            }
        }];
    }
    return dataTask;
}

/**
 *  POST/GET 一般网络请求
 */
+ (NSURLSessionDataTask *)requestTarget:(id)target withUrl:(NSString *)urlStr isPost:(BOOL)isPost parameters:(NSDictionary *)params complete:(CompleteHandle)completeHandle fail:(FailHandle)failHandle{
    return [self requestTarget:target withUrl:urlStr isPost:isPost parameters:params headerKey:nil header:nil complete:completeHandle fail:failHandle];
}

/**
 *  下载请求
 */
+ (NSURLSessionDownloadTask *)requestDownloadTarget:(id)target withUrl:(NSString *)urlStr progress:(ProgressHandle)progress destination:(DestinationHandle)destination complete:(CompletionHandle)complete{
    
    //网络监控句柄
    AFNetworkReachabilityManager *reachabiltiy = [AFNetworkReachabilityManager sharedManager];
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [reachabiltiy startMonitoring];
    [reachabiltiy setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable://未连接
                [self showHudWithTarget:target title:NetIsNotConnected];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://3g4g
                [self showHudWithTarget:target title:UsingMobileNet];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://wifi
                
                break;
            default:
                break;
        }
        
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:sessionConfiguration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destination?destination(targetPath, response):nil;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (complete) {
            complete(response, filePath, error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    return downloadTask;
}

/**
 *  显示拼装后的url字符串
 */
+ (void)printUrlInfo:(NSDictionary *)params withUrl:(NSString *)url{
    if ([params isNotEmpty]) {
        NSMutableString *str = [NSMutableString string];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [str appendFormat:@"&%@=%@", key, obj];
        }];
        NSString *subStr = [str substringFromIndex:1];
        NSLog(@"URL--------------           %@?%@          --------------", url,subStr);
    }else{
        NSLog(@"URL--------------           %@          --------------", url);
    }
}

/**
 *  显示hud
 */
+ (void)showHudWithTarget:(id)target title:(NSString *)title{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:[(UIViewController *)target view]];
    HUD.labelText = title;
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"X"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [[(UIViewController *)target view] addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5f);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}


@end
