//
//  WorkListViewController.m
//  JiawenClock
//
//  Created by ysj on 16/8/22.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WorkListViewController.h"
#import "UIView+YSJ.h"
#import "UIBarButtonItem+YSJ.h"
#import "AddWorkDayViewController.h"
#import "YSJNavigationController.h"
#import "NSString+YSJ.h"
#import "NSDate+YSJ.h"
#import "FMDBHelper.h"
#import "WorkDayCellModel.h"
#import "WorkDayTableViewCell.h"
#import "MJRefresh.h"
#import "EditWorkDayViewController.h"
#import "WorkDayInfoViewController.h"
#import "YSJWebService.h"
#import "WeatherDay.h"
#import "ChooseCityViewController.h"

@interface WorkListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray<WorkDayCellModel *> *dataArr;
@property (nonatomic, copy) NSArray<UITableViewRowAction *> *rowActionArr;
@property (nonatomic, strong) NSMutableArray<WeatherDay *> *weatherArr;
@property (nonatomic, strong) UIBarButtonItem *cityBarItem;
@property (nonatomic, strong) NSMutableDictionary *weatherParam;
@property (nonatomic, copy) NSString *cityNamePinyin;
@end

@implementation WorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _weatherParam = [NSMutableDictionary dictionaryWithDictionary:@{@"key":@"49a3c8b84bfb43ae9361fe5a2f6795f3"}];
    
    [self initNotifications];
    [self initRowActionArr];
    [self refreshWorkData];
    [self initWeatherData];
    [self initViews];
}

- (void)initNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWorkData) name:@"RefreshWorkDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCity:) name:@"ChooseCityNotification" object:nil];
}

- (void)initRowActionArr{
    UITableViewRowAction *actionEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        WorkDayTableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        WorkDayCellModel *model = _dataArr[indexPath.row];
        EditWorkDayViewController *editWorkDayVC = [[EditWorkDayViewController alloc]initWithWorkTypeId:model.workDayType date:model.date dateStr:cell.dateLabel.text];
        
        _table.editing = NO;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editWorkDayVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
    actionEdit.backgroundColor = self.view.tintColor;
    _rowActionArr = @[actionEdit];
}

- (void)initWeatherData{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyLocalCity]) {
        [_weatherParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyLocalCity] forKey:@"city"];
        [self loadWeatherData];
    }else{
        [self loadIpData];
    }
}

- (void)loadIpData{
    [YSJWebService requestTarget:self withUrl:@"http://ip-api.com/json" isPost:NO parameters:nil complete:^(id response) {
        if (![(NSDictionary *)response objectForKey:@"city"]) {
            return;
        }
        _cityNamePinyin = [(NSDictionary *)response objectForKey:@"city"];
        [_weatherParam setObject:_cityNamePinyin forKey:@"city"];
        [self loadWeatherData];
    } fail:nil];
}

- (void)loadWeatherData{
    //采用了和风天气
    [YSJWebService requestTarget:self withUrl:@"https://api.heweather.com/x3/weather" isPost:NO parameters:_weatherParam complete:^(id response) {
        NSLog(@"%@",response);
        NSArray *weatherArr = [response[@"HeWeather data service 3.0"] lastObject][@"daily_forecast"];
        _weatherArr = [NSMutableArray array];
        for (NSDictionary *dic in weatherArr) {
            WeatherDay *weather = [WeatherDay weatherWithDic:dic];
            [_weatherArr addObject:weather];
        }
        [_table reloadData];
    } fail:nil];
}

- (void)loadData{
    //获得用户设定的时间滞后量与显示天数
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int aboveHours = [[defaults objectForKey:UserDefaultKeyAboveHours] intValue];
    int showDays = [[defaults objectForKey:UserDefaultKeyShowDays] intValue];
    //根据上述两个参数，计算出最大最小date用于数据库筛选
    NSDate *firstDate = [NSDate dateSinceNowWithHoursLater:-24-aboveHours];
    NSDate *lastDate = [NSDate dateSinceDate:firstDate WithDaysLater:showDays];
    //拼装数据库筛选条件数组
    NSArray *comareKeyArr = @[[FMDBHelper compareKey:CompareKeyBigger],[FMDBHelper compareKey:CompareKeySmaller]];
    NSArray *conditionArr = @[@{WorkDateKey:firstDate},@{WorkDateKey:lastDate}];
    //获得保存于数据库的设定记录 与 工作类型记录
    NSArray *recordArr = [FMDBHelper selectDataFromTable:TableNameWorkDay andOrKey:AndKey compareKeyArr:comareKeyArr columnArr:conditionArr];
    NSArray *workTypeArr = [FMDBHelper selectDataFromTable:TableNameWorkType];
    //把工作类型数组转变为以工作类型id为key的字典类型方便后续使用
    NSMutableDictionary *workTypeDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in workTypeArr) {
        [workTypeDic setObject:dic forKey:dic[@"id"]];
    }
    //创建傀儡数组
    _dataArr = [NSMutableArray array];
    NSDate *todayZeroClock = [[[NSDate date] dateToStringWithFormatterStr:@"yyyy-MM-dd"] stringToDateWithFormatterStr:@"yyyy-MM-dd"];
    for (int i = 0; i < showDays; i++) {
        WorkDayCellModel *model = [[WorkDayCellModel alloc]initWithDic:@{WorkDateKey:[NSDate dateSinceDate:todayZeroClock WithDaysLater:i],IsPlanedKey:@0}];
        [_dataArr addObject:model];
    }
    //将已经设定工作的日子覆盖在傀儡数组上
    for (NSDictionary *dic in recordArr) {
        NSDate *workDay = [NSDate dateWithTimeIntervalSince1970:[dic[WorkDateKey] doubleValue]];
        int dayGap = [workDay compareTimeToAnotherDate:todayZeroClock]/(24*60*60);
        
        WorkDayCellModel *model = [[WorkDayCellModel alloc]init];
        model.date = workDay;
        model.isPlaned = YES;
        model.workDayType = dic[WorkTypeKey];
        model.startTime = workTypeDic[model.workDayType][StartTimeKey];
        model.endTime = workTypeDic[model.workDayType][EndTimeKey];
        model.loveName = workTypeDic[model.workDayType][LoveNameKey];
        [_dataArr replaceObjectAtIndex:dayGap withObject:model];
    }
    YSJLOG(@"%@",_dataArr);
}

- (void)initViews{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemSelected)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-StatusBarHeight-NavigationBarHeight-TabBarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshWorkDataNotification" object:nil];
        [table.mj_header endRefreshing];
    }];
    [self.view addSubview:table];
    self.table = table;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"批量添加/修改" color:[UIColor blackColor] textSize:15 bounds:CGRectMake(0, 0, 100, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(addBtnClicked)];
    table.tableFooterView = [[UIView alloc]init];
    
    
    NSString *localCity = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyLocalCity]?[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyLocalCity]:@"地区";
    
    _cityBarItem = [UIBarButtonItem itemWithTitle:localCity color:[UIColor blackColor] textSize:15 bounds:CGRectMake(0, 0, 100, 35) alignment:UIControlContentHorizontalAlignmentLeft target:self action:@selector(chooseCityBtnClicked)];
    self.navigationItem.leftBarButtonItem = _cityBarItem;
}




#pragma mark - btn selected
- (void)backBarButtonItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnClicked{
    AddWorkDayViewController *addVC = [[AddWorkDayViewController alloc]init];
    
    YSJNavigationController *nav = [[YSJNavigationController alloc]initWithRootViewController:addVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)chooseCityBtnClicked{
    ChooseCityViewController *chooseVC = [[ChooseCityViewController alloc]initWithCityName:_cityNamePinyin];
    YSJNavigationController *nav = [[YSJNavigationController alloc]initWithRootViewController:chooseVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma makr - Notification Method
- (void)refreshWorkData{
    [self loadData];
    [_table reloadData];
}

- (void)chooseCity:(NSNotification *)notification{
    NSString *cityName = notification.userInfo[@"cityName"];
    [_cityBarItem chanegCustomerBarBtnTitle:cityName];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:UserDefaultKeyLocalCity];
    [_weatherParam setObject:cityName forKey:@"city"];
    [self loadWeatherData];
}

#pragma mark - tableView Delegate & DataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowActionArr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkDayCellModel *model = _dataArr[indexPath.row];
    WorkDayTableViewCell *cell = [WorkDayTableViewCell cellWithTableView:tableView Model:model];
    if (indexPath.row < _weatherArr.count) {
        WeatherDay *weatherDay = _weatherArr[indexPath.row];
        cell.weatherLabel.text = [NSString stringWithFormat:@"%d~%d°C  %@",weatherDay.minTemperature, weatherDay.maxTemperature, weatherDay.weatherDetail];
    }else{
        cell.weatherLabel.text = @"暂无天气信息";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WorkDayCellModel *model = _dataArr[indexPath.row];
    WorkDayInfoViewController *infoVC;
    if (indexPath.row < _weatherArr.count) {
        infoVC = [[WorkDayInfoViewController alloc]initWithCellModel:model weatherDay:_weatherArr[indexPath.row]];
    }else{
        infoVC = [[WorkDayInfoViewController alloc]initWithCellModel:model weatherDay:nil];
    }
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:infoVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


#pragma mark - memory method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
