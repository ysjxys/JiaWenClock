//
//  EditWorkTypeViewController.h
//  JiawenClock
//
//  Created by ysj on 16/9/27.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
#import "WorkTypeModel.h"

typedef NS_ENUM(NSInteger,WorkTypeMode) {
    WorkTypeModeAdd = 0,
    WorkTypeModeEdit,
};

@interface EditWorkTypeViewController : YSJViewController

@property (nonatomic, strong) WorkTypeModel *workTypeModel;

- (instancetype)initWithWorkTypeMode:(WorkTypeMode)workTypeMode;

@end
