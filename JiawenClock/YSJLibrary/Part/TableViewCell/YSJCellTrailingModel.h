//
//  YSJCellTailingModel.h
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YSJCellModel;
typedef NS_ENUM(NSInteger, TrailingModelType) {
    TrailingModelNull = 0,
    TrailingModelImage,
    TrailingModelSwitch,
    TrailingModelArrow,
    TrailingModelView,
};
typedef void (^SwitchChangedHandle)(YSJCellModel *cellModel, BOOL isOn);


@interface YSJCellTrailingModel : NSObject

@property (nonatomic, assign) CGFloat trailViewWHCompareDegree;
@property (nonatomic, strong) UIImage *trailImg;
@property (nonatomic, strong) UIView *customerView;
@property (nonatomic, assign) TrailingModelType trailingModelType;
@property (nonatomic, copy) SwitchChangedHandle switchChangedHandle;

- (instancetype)initWithTrailingModelType:(TrailingModelType)trailingModelType;
+ (instancetype)modelWithTrailingModelType:(TrailingModelType)trailingModelType;

@end
