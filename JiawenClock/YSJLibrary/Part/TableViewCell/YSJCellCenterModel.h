//
//  YSJCellCenterModel.h
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CenterModelType) {
    CenterModelNull = 0,//a empty view
    CenterModel1,//1 customer View
    CenterModel2,//2 customer View
    CenterModel3,//3 customer View
};

typedef NS_ENUM(NSInteger, CellCenterViewLabelType) {
    CellCenterViewLabelTop = 0,
    CellCenterViewLabelMiddle,
    CellCenterViewLabelBottom,
};

@interface YSJCellCenterModel : NSObject

@property (nonatomic, assign) CenterModelType centerModelType;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;

- (instancetype)initWithCenterModelType:(CenterModelType)centerModelType;
+ (instancetype)modelWithCenterModelType:(CenterModelType)centerModelType;

@end
