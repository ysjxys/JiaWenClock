//
//  YSJTableViewCell.h
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSJCellModel;

@interface YSJTableViewCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView cellModel:(YSJCellModel *)cellModel identifier:(NSString *)identifier;



@end
