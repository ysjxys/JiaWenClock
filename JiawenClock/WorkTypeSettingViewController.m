//
//  WorkTypeSettingViewController.m
//  JiawenClock
//
//  Created by ysj on 16/9/27.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "WorkTypeSettingViewController.h"
#import "UIView+YSJ.h"
#import "YSJCell.h"
#import "EditWorkTypeViewController.h"
#import "FMDBHelper.h"
#import "WorkTypeModel.h"
#import "UIBarButtonItem+YSJ.h"
#import "YSJNavigationController.h"
#import "MJRefresh.h"

@interface WorkTypeSettingViewController ()
@property (nonatomic, strong) YSJTableView *ysjTV;
@property (nonatomic, copy) NSArray<UITableViewRowAction *> *rowActionArr;
@property (nonatomic, copy) NSArray<YSJCellGroupModel *> *dataArr;
@property (nonatomic, strong) UIAlertController *deleteAC;
@property (nonatomic, strong) NSMutableArray<WorkTypeModel *> *workTypeArr;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@end

@implementation WorkTypeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotification];
    [self initData];
    [self initViews];
}

- (void)addWorkTypeBarBtnClicked{
    EditWorkTypeViewController *editVC = [[EditWorkTypeViewController alloc]initWithWorkTypeMode:WorkTypeModeAdd];
    YSJNavigationController *nav = [[YSJNavigationController alloc]initWithRootViewController:editVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWorkTypeArrData) name:@"updateWorkTypeSettingViewControllerNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"班次设置";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"添加" color:[UIColor blackColor]textSize:15 bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(addWorkTypeBarBtnClicked)];
    
    _ysjTV = [YSJTableView viewWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-StatusBarHeight-NavigationBarHeight) TableViewStyle:UITableViewStylePlain cellIdentifier:@"WorkTypeSettingCell" rowActionArr:_rowActionArr dataArr:_dataArr];
    [self.view addSubview:_ysjTV];
    _ysjTV.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadWorkTypeArrData];
        [_ysjTV.tableView.mj_header endRefreshing];
    }];
}

- (void)initData{
    _deleteAC = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    [_deleteAC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [_deleteAC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSArray *compareKeyArr = @[[FMDBHelper compareKey:CompareKeyEqual]];
        [FMDBHelper deleteTable:TableNameWorkType andOrKey:NoneKey compareKeyArr:compareKeyArr columnArr:@[@{@"id":@(_workTypeArr[_deleteIndexPath.row].workTypeId)}]];
        [self loadWorkTypeArrData];
    }]];
    
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EditWorkTypeViewController *editVC = [[EditWorkTypeViewController alloc]initWithWorkTypeMode:WorkTypeModeEdit];
        editVC.workTypeModel = _workTypeArr[indexPath.row];
        YSJNavigationController *nav = [[YSJNavigationController alloc]initWithRootViewController:editVC];
        [_ysjTV.tableView setEditing:NO animated:YES];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    editAction.backgroundColor = self.view.tintColor;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.row == 0) {
            [self showHudWithTitle:@"人生在世不可以没有休息日啊"];
            return;
        }
        _deleteIndexPath = indexPath;
        [self presentViewController:_deleteAC animated:YES completion:nil];
    }];
    
    _rowActionArr = @[deleteAction,editAction];
    
    [self loadWorkTypeArrData];
}

- (void)loadWorkTypeArrData{
    NSArray *dbData = [FMDBHelper selectDataFromTable:TableNameWorkType];
    _workTypeArr = [NSMutableArray array];
    for (int i = 0; i < dbData.count; i++) {
        WorkTypeModel *model = [WorkTypeModel workTypeWithDic:dbData[i]];
        [_workTypeArr addObject:model];
    }
    
    YSJCellGroupModel *groupWorkType = [[YSJCellGroupModel alloc]init];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < _workTypeArr.count; i++) {
        WorkTypeModel *model = _workTypeArr[i];
        
        YSJCellCenterModel *centerModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = model.loveName;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        centerModel.topView = titleLabel;
        
        
        YSJCellTrailingModel *trailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelView];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        if (model.workTypeId == 1) {
            timeLabel.text = @"休~息~";
        }else{
            NSString *endTimeHour = [model.endTime substringWithRange:NSMakeRange(0, 2)];
            if ([endTimeHour intValue] >= 24) {
                endTimeHour = [endTimeHour intValue]-24>10?[NSString stringWithFormat:@"%d",[endTimeHour intValue]-24]:[NSString stringWithFormat:@"0%d",[endTimeHour intValue]-24];
            }
            timeLabel.text = [NSString stringWithFormat:@"%@:%@ - %@:%@",[model.startTime substringWithRange:NSMakeRange(0, 2)], [model.startTime substringWithRange:NSMakeRange(2, 2)], endTimeHour,[model.endTime substringWithRange:NSMakeRange(2, 2)]];
        }
        
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        trailingModel.trailViewWHCompareDegree = 3.0f;
        trailingModel.customerView = timeLabel;
        
        
        YSJCellModel *cellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:centerModel tailingModel:trailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
            EditWorkTypeViewController *editVC = [[EditWorkTypeViewController alloc]initWithWorkTypeMode:WorkTypeModeEdit];
            editVC.workTypeModel = _workTypeArr[indexPath.row];
            YSJNavigationController *nav = [[YSJNavigationController alloc]initWithRootViewController:editVC];
            [self presentViewController:nav animated:YES completion:^{
                _ysjTV.tableView.editing = NO;
            }];
        }];
        cellModel.cellHeight = 50.0f;
        [modelArr addObject:cellModel];
    }
    groupWorkType.modelArr = modelArr;
    
    _dataArr = @[groupWorkType];
    self.ysjTV.dataArr = _dataArr;
    [self.ysjTV.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
