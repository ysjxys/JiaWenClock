//
//  EditWorkDayViewController.m
//  JiawenClock
//
//  Created by ysj on 16/10/24.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "EditWorkDayViewController.h"
#import "FMDBHelper.h"
#import "UIBarButtonItem+YSJ.h"

@interface EditWorkDayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@property (nonatomic, strong) NSNumber *workTypeId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateStr;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation EditWorkDayViewController

- (instancetype)initWithWorkTypeId:(NSNumber *)workTypeId date:(NSDate *)date dateStr:(NSString *)dateStr{
    if (self = [super init]) {
        self.workTypeId = workTypeId;
        self.date = date;
        self.dateStr = dateStr;
        
        self.cellHeight = 1;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _cellHeight = 60;
    [_tableView reloadData];
    _tableView.hidden = NO;
    [_tableView selectRowAtIndexPath:_lastIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
    _dataArr = [FMDBHelper selectDataFromTable:TableNameWorkType];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _dateStr;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" color:[UIColor blackColor] textSize:16 bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(sureBtnClicked)];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.hidden = YES;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)sureBtnClicked{
    if (_workTypeId) {
        NSArray *arr = [FMDBHelper selectDataFromTable:TableNameWorkDay andOrKey:NoneKey compareKeyArr:@[[FMDBHelper compareKey:CompareKeyEqual]] columnArr:@[@{WorkDateKey:_date}]];
    
        if (arr.count == 0) {
            //未插入数据，采用insert
            NSDictionary *dic = @{WorkDateKey:_date, WorkTypeKey:_workTypeId};
            [FMDBHelper insertKeyValues:dic intoTable:TableNameWorkDay];
        }else{
            //已插入数据，采用update
            [FMDBHelper updateTable:TableNameWorkDay updateDic:@{WorkTypeKey:_workTypeId} andOrKey:NoneKey compareKeyArr:@[[FMDBHelper compareKey:CompareKeyEqual]] columnArr:@[@{WorkDateKey:_date}]];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshWorkDataNotification" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"EditWorkDayViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    NSDictionary *dic = _dataArr[indexPath.row];
    
    cell.textLabel.text = dic[LoveNameKey];
    
    NSString *startTime = [NSString stringWithFormat:@"%@:%@",[dic[StartTimeKey] substringToIndex:2],[dic[StartTimeKey] substringFromIndex:2]];
    NSString *endTime = [NSString stringWithFormat:@"%@:%@",[dic[EndTimeKey] substringToIndex:2],[dic[EndTimeKey] substringFromIndex:2]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@~%@",startTime,endTime];
    
    if (!_workTypeId) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    if ([dic[IdKey] isEqualToNumber:_workTypeId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _lastIndexPath = indexPath;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_lastIndexPath) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _lastIndexPath = indexPath;
    NSDictionary *dic = _dataArr[indexPath.row];
    _workTypeId = dic[IdKey];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
