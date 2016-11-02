//
//  YSJCellHeadingModel.h
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HeadingModelType) {
    HeadingModelNull = 0,
    HeadingModelImage,
    HeadingModelView,
};

@interface YSJCellHeadingModel : NSObject

@property (nonatomic, assign) CGFloat headViewWHCompareDegree;
@property (nonatomic, strong) UIImage *headImg;
@property (nonatomic, strong) UIView *customerView;
@property (nonatomic, assign) HeadingModelType headingModelType;

- (instancetype)initWithHeadingModelType:(HeadingModelType)headingModelType;
+ (instancetype)modelWithHeadingModelType:(HeadingModelType)headingModelType;
@end
