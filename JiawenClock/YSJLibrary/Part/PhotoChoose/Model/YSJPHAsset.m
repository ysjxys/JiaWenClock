//
//  YSJPHAseet.m
//  ysjLib
//
//  Created by ysj on 16/8/3.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJPHAsset.h"
#import "YSJCommonTools.h"

@implementation YSJPHAsset

+ (instancetype)ysjAssetWithPHAsset:(PHAsset *)asset{
    YSJPHAsset *ysjAsset = [[self alloc]init];
    ysjAsset.phAsset = asset;
    ysjAsset.isSelected = NO;
    return ysjAsset;
}


@end
