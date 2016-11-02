//
//  YSJPHAsset.h
//  ysjLib
//
//  Created by ysj on 16/8/3.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Photos/Photos.h>

@interface YSJPHAsset : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) PHAsset *phAsset;

+ (instancetype)ysjAssetWithPHAsset:(PHAsset *)asset;

@end
