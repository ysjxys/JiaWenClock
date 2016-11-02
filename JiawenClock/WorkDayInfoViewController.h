//
//  WorkDayInfoViewController.h
//  JiawenClock
//
//  Created by ysj on 16/10/26.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
@class WorkDayCellModel;
@class WeatherDay;

@interface WorkDayInfoViewController : YSJViewController


+ (instancetype)infoWithCellModel:(WorkDayCellModel *)cellModel weatherDay:(WeatherDay *)weatherDay;
- (instancetype)initWithCellModel:(WorkDayCellModel *)cellModel weatherDay:(WeatherDay *)weatherDay;


@end
