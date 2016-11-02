//
//  WorkDayInfoViewController.m
//  JiawenClock
//
//  Created by ysj on 16/10/26.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WorkDayInfoViewController.h"
#import "WorkDayCellModel.h"
#import "NSDate+YSJ.h"
#import "WeatherDay.h"
#import "UIImage+YSJ.h"

@interface WorkDayInfoViewController ()

@property (nonatomic, strong) WorkDayCellModel *cellModel;
@property (nonatomic, strong) WeatherDay *weatherDay;

@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *wetLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@end

@implementation WorkDayInfoViewController

+ (instancetype)infoWithCellModel:(WorkDayCellModel *)cellModel weatherDay:(WeatherDay *)weatherDay{
    return [[self alloc]initWithCellModel:cellModel weatherDay:weatherDay];
}

- (instancetype)initWithCellModel:(WorkDayCellModel *)cellModel weatherDay:(WeatherDay *)weatherDay{
    if (self = [super init]) {
        self.cellModel = cellModel;
        self.weatherDay = weatherDay;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    
    _backImgView.clipsToBounds = YES;
    _backImgView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:BackImgFilePath]];
    _backImgView.image = img;
    
    int weekNumber = [_cellModel.date weekNumber];
    _dayLabel.text = [NSString stringWithFormat:@"%@ %@", [_cellModel.date dateToStringWithFormatterStr:@"yyyy年MM月dd日"], [self weekNumberToString:weekNumber]];
    if (_cellModel.startTime) {
        _loveNameLabel.text = [NSString stringWithFormat:@"%@班",_cellModel.loveName];
        _workTimeLabel.text = [NSString stringWithFormat:@"%@:%@ - %@:%@", [_cellModel.startTime substringToIndex:2], [_cellModel.startTime substringFromIndex:2], [_cellModel.endTime substringToIndex:2], [_cellModel.endTime substringFromIndex:2]];
    }
    
    if (_weatherDay) {
        _tempLabel.text = [NSString stringWithFormat:@"%d - %d°C",_weatherDay.minTemperature, _weatherDay.maxTemperature];
        _weatherLabel.text = _weatherDay.weatherDetail;
        _wetLabel.text = [NSString stringWithFormat:@"湿度:%d%%  降水概率:%d%%", _weatherDay.wetPercent ,_weatherDay.rainPossiblePercent];
        _windLabel.text = [NSString stringWithFormat:@"风向:%@  风力:%@级", _weatherDay.windDir, _weatherDay.windPower];
    }
    [self changeTextColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma - mark judge color method

- (void)changeTextColor{
    UIImage *img = _backImgView.image;
    
    if([img isLightColor]){
        _dayLabel.textColor = [UIColor blackColor];
        _loveNameLabel.textColor = [UIColor blackColor];
        _workTimeLabel.textColor = [UIColor blackColor];
        _tempLabel.textColor = [UIColor blackColor];
        _weatherLabel.textColor = [UIColor blackColor];
        _wetLabel.textColor = [UIColor blackColor];
        _windLabel.textColor = [UIColor blackColor];
    }else{
        _dayLabel.textColor = [UIColor whiteColor];
        _loveNameLabel.textColor = [UIColor whiteColor];
        _workTimeLabel.textColor = [UIColor whiteColor];
        _tempLabel.textColor = [UIColor whiteColor];
        _weatherLabel.textColor = [UIColor whiteColor];
        _wetLabel.textColor = [UIColor whiteColor];
        _windLabel.textColor = [UIColor whiteColor];
    }
}

@end
