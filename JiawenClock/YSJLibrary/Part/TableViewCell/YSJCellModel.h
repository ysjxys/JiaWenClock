//
//  YSJCellModel.h
//  JiawenClock
//
//  Created by ysj on 16/8/23.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YSJCellHeadingModel;
@class YSJCellCenterModel;
@class YSJCellTrailingModel;
@class YSJCellModel;

typedef void (^SelectedHandle)(YSJCellModel *cellModel, NSIndexPath *indexPath);

@interface YSJCellModel : NSObject


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailText;

@property (nonatomic, assign) CGFloat cellContentBorderDegree;
@property (nonatomic, assign) CGFloat cellContentHeightPercentDegree;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) SelectedHandle selectedHandle;
@property (nonatomic, strong) YSJCellHeadingModel *headingModel;
@property (nonatomic, strong) YSJCellCenterModel *centerModel;
@property (nonatomic, strong) YSJCellTrailingModel *trailingModel;


+ (instancetype)modelWithHeadingModel:(YSJCellHeadingModel *)headingModel centerModel:(YSJCellCenterModel *)centerModel tailingModel:(YSJCellTrailingModel *)trailingModel selectedHandle:(SelectedHandle)selectedHandle;

- (instancetype)initWithHeadingModel:(YSJCellHeadingModel *)headingModel centerModel:(YSJCellCenterModel *)centerModel trailingModel:(YSJCellTrailingModel *)trailingModel selectedHandle:(SelectedHandle)selectedHandle;

@end
