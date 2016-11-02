//
//  YSJTableView.m
//  JiawenClock
//
//  Created by ysj on 16/9/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTableView.h"
#import "UIView+YSJ.h"
#import "YSJCellModel.h"
#import "YSJCellHeadingModel.h"
#import "YSJCellCenterModel.h"
#import "YSJCellTrailingModel.h"
#import "YSJTableViewCell.h"
#import "YSJCellGroupModel.h"
@interface YSJTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray<UITableViewRowAction *> *rowActionArr;
@property (nonatomic, copy) NSString *cellIdentifier;
@end

@implementation YSJTableView


+ (instancetype)viewWithFrame:(CGRect)frame TableViewStyle:(UITableViewStyle)tableViewStyle cellIdentifier:(NSString *)identifier rowActionArr:(NSArray<UITableViewRowAction *> *)rowActionArr dataArr:(NSArray<YSJCellGroupModel *> *)dataArr{
    YSJTableView *ysjView = [[YSJTableView alloc]initWithFrame:frame];
    ysjView.dataArr = dataArr;
    ysjView.rowActionArr = rowActionArr;
    ysjView.cellIdentifier = identifier;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:tableViewStyle];
    tableView.delegate = ysjView;
    tableView.dataSource = ysjView;
    ysjView.tableView = tableView;
    [ysjView addSubview:tableView];
    
    return ysjView;
}

#pragma mark - tableView Delegate & DataSource Method
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowActionArr?UITableViewCellEditingStyleDelete:UITableViewCellEditingStyleNone;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowActionArr;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.modelArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.headViewHeight?group.headViewHeight:0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    YSJCellGroupModel *group = _dataArr[section];
    return group.footViewHeight?group.footViewHeight:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSJCellGroupModel *group = _dataArr[indexPath.section];
    YSJCellModel *cellModel = group.modelArr[indexPath.row];
    return cellModel.cellHeight?cellModel.cellHeight:44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSJCellGroupModel *group = _dataArr[indexPath.section];
    YSJCellModel *cellModel = group.modelArr[indexPath.row];
    YSJTableViewCell *cell = [YSJTableViewCell cellWithTableView:tableView cellModel:cellModel identifier:_cellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSJCellGroupModel *group = _dataArr[indexPath.section];
    YSJCellModel *cellModel = group.modelArr[indexPath.row];
    cellModel.selectedHandle(cellModel, indexPath);
}

@end
