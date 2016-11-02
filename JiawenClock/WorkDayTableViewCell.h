//
//  WorkDayTableViewCell.h
//  JiawenClock
//
//  Created by ysj on 16/8/25.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkDayCellModel;

@interface WorkDayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView Model:(WorkDayCellModel *)cellModel;

@end
