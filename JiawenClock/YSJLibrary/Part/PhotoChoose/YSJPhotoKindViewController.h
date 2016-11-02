//
//  YSJPhotoKindViewController.h
//  ysjLib
//
//  Created by ysj on 16/7/26.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJViewController.h"
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, ShowType) {
    showTypeList = 1,
    showTypeDetail
};

typedef NS_ENUM(NSInteger, SelectType) {
    SelectTypeSingle = 1,
    SelectTypeMultiple
};

typedef void (^PicsSelectdHandle)(NSArray<PHAsset *> *assetArr);

@interface YSJPhotoKindViewController : YSJViewController

- (instancetype)initWithShowType:(ShowType)showType selectType:(SelectType)selectType picsSelectHandle:(PicsSelectdHandle)handle;

@end
