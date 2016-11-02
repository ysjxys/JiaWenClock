//
//  WorkDayTableViewCell.m
//  JiawenClock
//
//  Created by ysj on 16/8/25.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WorkDayTableViewCell.h"
#import "WorkDayCellModel.h"
#import "NSDate+YSJ.h"
#import "UIImage+YSJ.h"
@interface WorkDayTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *loveNameLabel;

@property (weak, nonatomic) IBOutlet UIView *imgBackView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) WorkDayCellModel *cellModel;
@end
@implementation WorkDayTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView Model:(WorkDayCellModel *)cellModel{
    static NSString *identifier = @"WorkDayTableViewCell";
    WorkDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    cell.cellModel = cellModel;
    return cell;
}

- (void)setCellModel:(WorkDayCellModel *)cellModel{
    _cellModel = cellModel;
    
    int weekNumber = [cellModel.date weekNumber];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@", [cellModel.date dateToStringWithFormatterStr:@"MM月dd日"], [self weekNumberToString:weekNumber]];
    
    if (cellModel.isPlaned) {
        _loveNameLabel.text = cellModel.loveName;
        
        int startTimeInt = [cellModel.startTime intValue];
        if (startTimeInt == 0) {
            _imgView.image = [[UIImage imageNamed:@"rest.jpg"] circleImage];
        }else if(startTimeInt < 1200){
            _imgView.image = [[UIImage imageNamed:@"Sun"] circleImage];
        }else{
            _imgView.image = [[UIImage imageNamed:@"Moon"] circleImage];
        }
    }else{
        _loveNameLabel.text = @"未设定计划";
        _imgView.image = [[UIImage imageNamed:@"question"] circleImage];
    }
}

- (NSString *)weekNumberToString:(int)weekNum{
    NSString *weekStr;
    switch (weekNum) {
        case 0:
            weekStr = @"星期一";
            break;
        case 1:
            weekStr = @"星期二";
            break;
        case 2:
            weekStr = @"星期三";
            break;
        case 3:
            weekStr = @"星期四";
            break;
        case 4:
            weekStr = @"星期五";
            break;
        case 5:
            weekStr = @"星期六";
            break;
        case 6:
            weekStr = @"星期日";
            break;
        default:
            break;
    }
    return weekStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
