//
//  YSJPhotoChooseViewController.h
//  ysjLib
//
//  Created by ysj on 16/7/28.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJViewController.h"
#import "YSJPhotoKindViewController.h"



@interface YSJPhotoChooseViewController : YSJViewController

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection showType:(ShowType)showType selectType:(SelectType)selectType handle:(PicsSelectdHandle)handle;

@end
