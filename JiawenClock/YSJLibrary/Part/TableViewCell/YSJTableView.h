//
//  YSJTableView.h
//  JiawenClock
//
//  Created by ysj on 16/9/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSJCellGroupModel;
@interface YSJTableView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<YSJCellGroupModel *> *dataArr;

+ (instancetype)viewWithFrame:(CGRect)frame TableViewStyle:(UITableViewStyle)tableViewStyle cellIdentifier:(NSString *)identifier rowActionArr:(NSArray<UITableViewRowAction *> *)rowActionArr dataArr:(NSArray<YSJCellGroupModel *> *)dataArr;


@end
