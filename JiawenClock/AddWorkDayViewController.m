//
//  AddWorkDayViewController.m
//  JiawenClock
//
//  Created by ysj on 16/8/22.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "AddWorkDayViewController.h"
#import "UIView+YSJ.h"
#import "YSJCellModel.h"
#import "UIBarButtonItem+YSJ.h"
#import "FSCalendar.h"
#import "NSDate+YSJ.h"
#import "YSJNavigationController.h"
#import "NSString+YSJ.h"
#import "FMDBHelper.h"


#define StartTimeCellTitle @"起始日期"
#define EndTimeCellTitle @"结束日期"
#define WorkTypeCellTitle @"工作类型"
@interface AddWorkDayViewController ()<UITableViewDataSource, UITableViewDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<YSJCellModel *> *dataArr;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, copy) NSArray *workTypeArr;

@property (nonatomic, strong) FSCalendar *startCalendar;
@property (nonatomic, strong) FSCalendar *endCalendar;
@property (nonatomic, strong) NSCalendar *lunarCalendar;
@property (nonatomic, copy) NSArray<NSString *> *lunarChars;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSMutableDictionary *workTypeDic;
@property (nonatomic, assign) CGFloat bottomViewheight;


@end

@implementation AddWorkDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"添加工作日历";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    YSJNavigationController *nav = (YSJNavigationController *)self.navigationController;
    nav.isAutorotate = NO;
    
    [self initData];
    [self initViews];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated{
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)initViews{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" color:[UIColor blackColor] textSize:15.0f bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentLeft target:self action:@selector(cancelBtnClicked)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" color:[UIColor blackColor] textSize:15.0f bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(sureBtnClicked)];
    
    CGFloat bottomViewheight = 250;
    if (ScreenWidth == 375){
        bottomViewheight = 300;
    }else if (ScreenWidth == 414){
        bottomViewheight = 350;
    }
    _bottomViewheight = bottomViewheight;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-StatusBarHeight-NavigationBarHeight-bottomViewheight) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    table.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:table];
    _tableView = table;
    
    _lunarCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, table.bottom, self.view.width, bottomViewheight)];
    picker.delegate = self;
    picker.dataSource = self;
    [self.view addSubview:picker];
    _picker = picker;
    
    FSCalendar *startCalendar = [[FSCalendar alloc]initWithFrame:picker.frame];
    startCalendar.dataSource = self;
    startCalendar.delegate = self;
    startCalendar.appearance.headerDateFormat = @"yyyy.MM";
    startCalendar.backgroundColor = [UIColor whiteColor];
    startCalendar.appearance.selectionColor = [UIColor greenColor];
    [self.view addSubview:startCalendar];
    _startCalendar = startCalendar;
    
    FSCalendar *endCalendar = [[FSCalendar alloc]initWithFrame:startCalendar.frame];
    endCalendar.dataSource = self;
    endCalendar.delegate = self;
    endCalendar.appearance.headerDateFormat = @"yyyy.MM";
    endCalendar.backgroundColor = [UIColor whiteColor];
    endCalendar.appearance.selectionColor = [UIColor redColor];
    [self.view addSubview:endCalendar];
    _endCalendar = endCalendar;
}

- (void)initData{
    _workTypeArr = [FMDBHelper selectDataFromTable:TableNameWorkType];
    
    YSJCellModel *startDayModel = [[YSJCellModel alloc]init];
    startDayModel.title = StartTimeCellTitle;
    startDayModel.selectedHandle = ^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [_startCalendar reloadData];
        [self chanegBottomView:_startCalendar];
    };
    
    YSJCellModel *endDayModel = [[YSJCellModel alloc]init];
    endDayModel.title = EndTimeCellTitle;
    endDayModel.selectedHandle = ^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [_endCalendar reloadData];
        [self chanegBottomView:_endCalendar];
    };
    
    YSJCellModel *workTypeModel = [[YSJCellModel alloc]init];
    workTypeModel.title = WorkTypeCellTitle;
    workTypeModel.selectedHandle = ^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [self chanegBottomView:_picker];
    };
    
    _dataArr = @[startDayModel,endDayModel,workTypeModel];
}

- (void)chanegBottomView:(UIView *)view{
    CGFloat viewBottom = self.view.height;
    if (view == _startCalendar) {
        [UIView animateWithDuration:0.3 animations:^{
            _endCalendar.bottom = viewBottom + _bottomViewheight;
            _picker.bottom = viewBottom + _bottomViewheight;
            [UIView animateWithDuration:0.3 animations:^{
                _startCalendar.bottom = viewBottom;
            }];
        }];
    }
    if (view == _endCalendar) {
        [UIView animateWithDuration:0.3 animations:^{
            _startCalendar.bottom = viewBottom + _bottomViewheight;
            _picker.bottom = viewBottom + _bottomViewheight;
            [UIView animateWithDuration:0.3 animations:^{
                _endCalendar.bottom = viewBottom;
            }];
        }];
    }
    if (view == _picker) {
        [UIView animateWithDuration:0.3 animations:^{
            _endCalendar.bottom = viewBottom + _bottomViewheight;
            _startCalendar.bottom = viewBottom + _bottomViewheight;
            [UIView animateWithDuration:0.3 animations:^{
                _picker.bottom = viewBottom;
                NSInteger selectedRow = [_picker selectedRowInComponent:0];
                [self pickerView:_picker didSelectRow:selectedRow inComponent:0];
            }];
        }];
    }
}

- (void)setModelAndCellText:(NSString *)cellText WithCellKey:(NSString *)cellKey{
    YSJCellModel *purposeModel;
    for (YSJCellModel *model in _dataArr) {
        if ([model.title isEqualToString:cellKey]) {
            purposeModel = model;
            break;
        }
    }
    for (UITableViewCell *cell in _tableView.visibleCells) {
        if ([cell.textLabel.text isEqualToString:cellKey]) {
            cell.detailTextLabel.text = cellText;
            purposeModel.detailText = cell.detailTextLabel.text;
            break;
        }
    }
}

#pragma mark - BarBtnSelected
- (void)cancelBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureBtnClicked{
    if (!_startDate) {
        [self showHudWithTitle:@"请选择工作起始日期"];
        return;
    }
    if (!_endDate) {
        [self showHudWithTitle:@"请选择工作起始日期"];
        return;
    }
    if (!_workTypeDic) {
        [self showHudWithTitle:@"请选择工作种类"];
        return;
    }
    YSJLOG(@"%@  %@  %@",_startDate,_endDate,_workTypeDic);
    
    int timeDays = [_endDate compareTimeToAnotherDate:_startDate]/(24*60*60);
    for (int i = 0; i < timeDays+1; i++) {
        NSDate *date = [NSDate dateSinceDate:_startDate WithDaysLater:i];
        
        NSArray *compareArr = @[[FMDBHelper compareKey:CompareKeyEqual]];
        NSArray *columnArr = @[@{WorkDateKey:date}];
        
        NSArray *oriArr = [FMDBHelper selectDataFromTable:TableNameWorkDay andOrKey:NoneKey compareKeyArr:compareArr columnArr:columnArr];
        
        if (oriArr.count < 1) {
            [FMDBHelper insertKeyValues:@{WorkDateKey:date,WorkTypeKey:_workTypeDic[@"id"]} intoTable:TableNameWorkDay];
        }else{
            NSDictionary *updateDic = @{WorkTypeKey:_workTypeDic[@"id"]};
            [FMDBHelper updateTable:TableNameWorkDay updateDic:updateDic andOrKey:NoneKey compareKeyArr:compareArr columnArr:columnArr];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshWorkDataNotification" object:nil];
    [self cancelBtnClicked];
}

#pragma mark - PickerView Delegate & DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _workTypeArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_workTypeArr[row] objectForKey:LoveNameKey];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _workTypeDic = [_workTypeArr[row] mutableCopy];
    [self setModelAndCellText:_workTypeArr[row][LoveNameKey] WithCellKey:WorkTypeCellTitle];
}

#pragma mark - FSCalendar Delegate & DataSource & DelegateAppearance
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    if ([date compareTimeToAnotherDate:calendar.today]<0) {
        return NO;
    }
    if (calendar == _startCalendar) {
        if (_endDate && [date compareTimeToAnotherDate:_endDate]>0) {
            return NO;
        }
        return YES;
    }
    if (calendar == _endCalendar) {
        if (_startDate && [date compareTimeToAnotherDate:_startDate]<0) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    [calendar reloadData];
    
    if (calendar == _startCalendar) {
        _startDate = date;
        [self setModelAndCellText:[_startDate  dateToStringWithFormatterStr:@"MM-dd"] WithCellKey:StartTimeCellTitle];
    }else{
        _endDate = date;
        [self setModelAndCellText:[_endDate  dateToStringWithFormatterStr:@"MM-dd"] WithCellKey:EndTimeCellTitle];
    }
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillColorForDate:(NSDate *)date{
    if (calendar == _startCalendar) {
        if (date == _endDate) {
            return _endCalendar.appearance.selectionColor;
        }
        if (date == calendar.selectedDate) {
            return calendar.appearance.selectionColor;
        }
        return [UIColor whiteColor];
    }
    if (calendar == _endCalendar) {
        if (date == _startDate) {
            return _startCalendar.appearance.selectionColor;
        }
        if (date == calendar.selectedDate) {
            return calendar.appearance.selectionColor;
        }
        return [UIColor whiteColor];
    }
    return [UIColor whiteColor];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    return [date compareTimeToAnotherDate:calendar.today]<0?calendar.appearance.titlePlaceholderColor:calendar.appearance.titleDefaultColor;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    //显示农历
    NSInteger day = [_lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
    return _lunarChars[day-1];
}

#pragma mark - tableView Delegate & DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.tintColor = [UIColor blackColor];
    }
    YSJCellModel *model = _dataArr[indexPath.section];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YSJCellModel *model = _dataArr[indexPath.section];
    model.selectedHandle(model,indexPath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
