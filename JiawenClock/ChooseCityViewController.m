//
//  ChooseCityViewController.m
//  JiawenClock
//
//  Created by ysj on 16/10/31.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "UIBarButtonItem+YSJ.h"
#import "City.h"
#import "CityGroup.h"
#import "UIView+YSJ.h"
#import "YSJWebService.h"

@interface ChooseCityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CityGroup *> *dataArr;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSArray *hotCityArr;
@property (nonatomic, strong) UIButton *localCityBtn;
@end

@implementation ChooseCityViewController

- (instancetype)initWithCityName:(NSString *)cityName{
    if (self = [super init]) {
        _cityName = [cityName lowercaseString];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self loadLocal];
}

- (void)loadLocal{
    if (_cityName) {
        return;
    }
    [YSJWebService requestTarget:self withUrl:@"http://ip-api.com/json" isPost:NO parameters:nil complete:^(id response) {
        if (![(NSDictionary *)response objectForKey:@"city"]) {
            return;
        }
        _cityName = [[(NSDictionary *)response objectForKey:@"city"] lowercaseString];
        [_localCityBtn setTitle:[self searchLocalName] forState:UIControlStateNormal];
        _localCityBtn.enabled = YES;
    } fail:nil];
}

- (void)initData{
    NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    NSArray *tempArr = [NSArray arrayWithContentsOfFile:pathStr];
    
    _dataArr = [NSMutableArray array];
    for (int i = 0; i < tempArr.count; i++) {
        NSDictionary *singleMarkDic = tempArr[i];
        CityGroup *group = [CityGroup groupWithDic:singleMarkDic];
        [_dataArr addObject:group];
    }
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"选择地区";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" color:[UIColor blackColor] textSize:15 bounds:CGRectMake(0, 0, 40, 35) alignment:UIControlContentHorizontalAlignmentLeft target:self action:@selector(backBtnClicked)];
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 320)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UILabel *localLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, headView.width, 20)];
    localLabel.text = @"定位城市";
    localLabel.textColor = [UIColor grayColor];
    [headView addSubview:localLabel];
    
    CGFloat distance = (self.view.width-10-80*3)/4;
    _localCityBtn = [self createBtnWithTitle:_cityName?[self searchLocalName]:@"未定位"];
    _localCityBtn.frame = CGRectMake(distance, localLabel.bottom+10, 80, 40);
    [_localCityBtn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (!_cityName) {
        _localCityBtn.enabled = NO;
    }
    [headView addSubview:_localCityBtn];
    
    UILabel *usualLabel = [[UILabel alloc]initWithFrame:CGRectMake(localLabel.left, _localCityBtn.bottom+10, headView.width, 20)];
    usualLabel.text = @"热门城市";
    usualLabel.textColor = [UIColor grayColor];
    [headView addSubview:usualLabel];
    
    _hotCityArr = @[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州",@"程度",@"重庆"];
    
    for (int i = 0; i < _hotCityArr.count; i++) {
//
        UIButton *cityBtn = [self createBtnWithTitle:_hotCityArr[i]];
        int line = i%3;
        int row = i/3;
        cityBtn.frame = CGRectMake(distance+line*(distance+80), usualLabel.bottom+15+row*(5+40), 80, 40);
        cityBtn.tag = i;
        [cityBtn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:cityBtn];
    }
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UITableView alloc]init];
    tableView.tableHeaderView = headView;
    tableView.sectionIndexColor = [UIColor blackColor];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (UIButton *)createBtnWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    return btn;
}

- (NSString *)searchLocalName{
    if (!_cityName) {
        return _cityName;
    }
    
    NSString *firstChar = [[_cityName substringToIndex:1] uppercaseString];
    CityGroup *purposeGroup;
    for (int i = 0; i < _dataArr.count; i++) {
        CityGroup *group = _dataArr[i];
        if ([group.charMark isEqualToString:firstChar]) {
            purposeGroup = group;
            break;
        }
    }
    
    NSString *purposeName = _cityName;
    for (City *city in purposeGroup.cityArr) {
        if ([city.pinyin isEqualToString:_cityName]) {
            purposeName = city.town;
            break;
        }
    }
    return purposeName;
}

#pragma mark - btnClicked
- (void)cityBtnClicked:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseCityNotification" object:nil userInfo:@{@"cityName":btn.titleLabel.text}];
    [self backBtnClicked];
}

- (void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr[section].cityArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _dataArr[section].charMark;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [_dataArr valueForKeyPath:@"charMark"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    City *city = _dataArr[indexPath.section].cityArr[indexPath.row];
    
    cell.textLabel.text = city.town;
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
