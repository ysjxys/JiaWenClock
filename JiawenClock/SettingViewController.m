//
//  SettingViewController.m
//  JiawenClock
//
//  Created by ysj on 16/9/14.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "SettingViewController.h"
#import "YSJCell.h"
#import "YSJPhotoChooseViewController.h"
#import "YSJNavigationController.h"
#import "WorkTypeSettingViewController.h"
#import <Photos/Photos.h>
#import "AboutViewController.h"

#define cellHeight50 50

@interface SettingViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) YSJTableView *ysjTV;
@property (nonatomic, strong) NSArray<YSJCellGroupModel *> *dataArr;
@property (nonatomic, copy) NSArray<UITableViewRowAction *> *rowActionArr;
@property (nonatomic, strong) YSJCellModel *dayNumberCellModel;
@property (nonatomic, strong) YSJCellModel *beforeCellModel;
@property (nonatomic, strong) YSJCellModel *csHeadImageCellModel;
@property (nonatomic, strong) YSJCellModel *csBackImageCellModel;

@property (nonatomic, strong) UIAlertController *dayNumAC;
@property (nonatomic, strong) UIAlertController *hourBeforeAC;
@property (nonatomic, strong) UIAlertController *clearAC;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemSelected)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self initAlertControllers];
    [self initData];
    _ysjTV = [YSJTableView viewWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-StatusBarHeight-NavigationBarHeight-TabBarHeight) TableViewStyle:UITableViewStyleGrouped cellIdentifier:@"SettingViewControllerCell" rowActionArr:nil dataArr:_dataArr];
    _ysjTV.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_ysjTV];
}

- (void)backBarButtonItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)labelWithTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.text = title;
    label.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    return label;
}

- (UILabel *)subLabelWithTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor lightGrayColor];
    return label;
}

- (void)refreshData:(YSJCellModel *)cellModel{
    if ([cellModel isEqual:_dayNumberCellModel]) {
        UILabel *dayNumberLabel = (UILabel *)_dayNumberCellModel.trailingModel.customerView;
        dayNumberLabel.text = [NSString stringWithFormat:@"%d天",[[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyShowDays] intValue]];
    }
    
    if ([cellModel isEqual:_beforeCellModel]) {
        UILabel *beforeLabelNum = (UILabel *)_beforeCellModel.trailingModel.customerView;
        beforeLabelNum.text = [NSString stringWithFormat:@"%dh",[[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyAboveHours] intValue]];
    }
    
    if ([cellModel isEqual:_csHeadImageCellModel]) {
        UIImage *img;
        if ([[NSFileManager defaultManager] fileExistsAtPath:HeadImgFilePath]) {
            img = [UIImage imageWithData:[NSData dataWithContentsOfFile:HeadImgFilePath]];
        }else{
            img = [UIImage imageNamed:@"rest.jpg"];
            [UIImageJPEGRepresentation(img, 1.0) writeToFile:HeadImgFilePath atomically:YES];
        }
        _csHeadImageCellModel.trailingModel.trailImg = img;
    }
    
    if ([cellModel isEqual:_csBackImageCellModel]) {
        UIImage *img;
        if ([[NSFileManager defaultManager] fileExistsAtPath:BackImgFilePath]) {
            img = [UIImage imageWithData:[NSData dataWithContentsOfFile:BackImgFilePath]];
        }else{
            img = [UIImage imageNamed:@"back.jpg"];
            [UIImageJPEGRepresentation(img, 1.0) writeToFile:HeadImgFilePath atomically:YES];
        }
        _csBackImageCellModel.trailingModel.trailImg = img;
    }
}

- (void)showAndSaveImgWithPathString:(NSString *)pathString{
    
    __weak typeof(self) weakSelf = self;
    YSJPhotoKindViewController *photoVC = [[YSJPhotoKindViewController alloc]initWithShowType:showTypeList selectType:SelectTypeSingle picsSelectHandle:^(NSArray<PHAsset *> *assetArr) {
        [[PHImageManager defaultManager] requestImageDataForAsset:assetArr.firstObject options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *image = [UIImage imageWithData:imageData];
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:pathString atomically:YES];
            [weakSelf refreshData:_csHeadImageCellModel];
            [weakSelf refreshData:_csBackImageCellModel];
            [weakSelf.ysjTV.tableView reloadData];
        }];
    }];
    YSJNavigationController *nav = [[YSJNavigationController alloc]initWithRootViewController:photoVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)initData{
    __weak typeof(self) weakSelf = self;
    //workSettingGroup
    YSJCellCenterModel *wcDayNumberCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    wcDayNumberCellCenterModel.topView = [self labelWithTitle:@"显示日期数量"];
    YSJCellTrailingModel *wcDayNumberCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelArrow];
    UILabel *dayNumberLabel = [self subLabelWithTitle:[NSString stringWithFormat:@"%d天",[[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyShowDays] intValue]]];
    wcDayNumberCellTrailingModel.customerView = dayNumberLabel;
    
    _dayNumberCellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:wcDayNumberCellCenterModel tailingModel:wcDayNumberCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [weakSelf presentViewController:_dayNumAC animated:YES completion:nil];
    }];
    _dayNumberCellModel.cellHeight = cellHeight50;
    
    YSJCellCenterModel *wcHourBeforeCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    wcHourBeforeCellCenterModel.topView = [self labelWithTitle:@"日期延后过期小时数"];
    YSJCellTrailingModel *wcHourBeforeCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelArrow];
    int beforeLabelNum = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyAboveHours] intValue];
    UILabel *beforeLabel = [self subLabelWithTitle:[NSString stringWithFormat:@"%dh",beforeLabelNum]];
    wcHourBeforeCellTrailingModel.customerView = beforeLabel;
    _beforeCellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:wcHourBeforeCellCenterModel tailingModel:wcHourBeforeCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [weakSelf presentViewController:_hourBeforeAC animated:YES completion:nil];
    }];
    _beforeCellModel.cellHeight = cellHeight50;
    
    YSJCellCenterModel *wcWorkChangeCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    wcWorkChangeCellCenterModel.topView = [self labelWithTitle:@"班次设置"];
    YSJCellTrailingModel *wcWorkChangeCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelArrow];
    YSJCellModel *workChange = [YSJCellModel modelWithHeadingModel:nil centerModel:wcWorkChangeCellCenterModel tailingModel:wcWorkChangeCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        WorkTypeSettingViewController *workTypeVC = [[WorkTypeSettingViewController alloc]init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:workTypeVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }];
    workChange.cellHeight = 50;
    
    YSJCellGroupModel *workSettingGroup = [[YSJCellGroupModel alloc]init];
    workSettingGroup.modelArr = @[_dayNumberCellModel,_beforeCellModel,workChange];
    
    
    //customerSettingGroup
    YSJCellCenterModel *csHeadImageCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    csHeadImageCellCenterModel.topView = [self labelWithTitle:@"个性化图片"];
    YSJCellTrailingModel *csHeadImageCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelImage];
    csHeadImageCellTrailingModel.trailViewWHCompareDegree = 1.0;
    _csHeadImageCellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:csHeadImageCellCenterModel tailingModel:csHeadImageCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [weakSelf showAndSaveImgWithPathString:HeadImgFilePath];
    }];
    [self refreshData:_csHeadImageCellModel];
    _csHeadImageCellModel.cellHeight = cellHeight50;
    
    YSJCellCenterModel *csBackImageCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    csBackImageCellCenterModel.topView = [self labelWithTitle:@"背景图片"];
    YSJCellTrailingModel *csBackImageCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelImage];
    csBackImageCellTrailingModel.trailViewWHCompareDegree = 1.5;
    _csBackImageCellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:csBackImageCellCenterModel tailingModel:csBackImageCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [weakSelf showAndSaveImgWithPathString:BackImgFilePath];
    }];
    [self refreshData:_csBackImageCellModel];
    _csBackImageCellModel.cellHeight = cellHeight50;
    
    YSJCellGroupModel *customerSettingGroup = [[YSJCellGroupModel alloc]init];
    customerSettingGroup.modelArr = @[_csHeadImageCellModel,_csBackImageCellModel];
    
    
    //aboutGroup
    YSJCellCenterModel *resetCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    resetCellCenterModel.topView = [self labelWithTitle:@"恢复默认设置"];
    YSJCellTrailingModel *resetCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelNull];
    YSJCellModel *resetCellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:resetCellCenterModel tailingModel:resetCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        [weakSelf presentViewController:_clearAC animated:YES completion:nil];
    }];
    resetCellModel.cellHeight = cellHeight50;
    
    YSJCellCenterModel *aboutCellCenterModel = [YSJCellCenterModel modelWithCenterModelType:CenterModel1];
    aboutCellCenterModel.topView = [self labelWithTitle:@"关于这个APP"];
    YSJCellTrailingModel *aboutCellTrailingModel = [YSJCellTrailingModel modelWithTrailingModelType:TrailingModelArrow];
    YSJCellModel *aboutCellModel = [YSJCellModel modelWithHeadingModel:nil centerModel:aboutCellCenterModel tailingModel:aboutCellTrailingModel selectedHandle:^(YSJCellModel *cellModel, NSIndexPath *indexPath){
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:aboutVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }];
    aboutCellModel.cellHeight = cellHeight50;
    
    YSJCellGroupModel *aboutGroup = [[YSJCellGroupModel alloc]init];
    aboutGroup.modelArr = @[aboutCellModel,resetCellModel];
    
    
    _dataArr = @[workSettingGroup, customerSettingGroup, aboutGroup];
}

- (void)initAlertControllers{
    _dayNumAC = [UIAlertController alertControllerWithTitle:@"日期设置" message:@"能够显示的最大日期数量" preferredStyle:UIAlertControllerStyleAlert];
    
    [_dayNumAC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入能够显示的最大日期数量";
        textField.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyShowDays]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [_dayNumAC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [_dayNumAC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        int dayNum = [_dayNumAC.textFields.firstObject.text intValue];
        if (dayNum < 1 || dayNum > 60) {
            [self showHudWithTitle:@"日期数量应在1~60之间 设置失败"];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:dayNum] forKey:UserDefaultKeyShowDays];
        [self refreshData:_dayNumberCellModel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    
    
    _hourBeforeAC = [UIAlertController alertControllerWithTitle:@"滞后小时设置" message:@"日期过期滞后小时数" preferredStyle:UIAlertControllerStyleAlert];
    
    [_hourBeforeAC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入日期过期滞后小时数量";
        textField.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyAboveHours]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [_hourBeforeAC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [_hourBeforeAC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        int dayNum = [_hourBeforeAC.textFields.firstObject.text intValue];
        if (dayNum < 1 || dayNum > 12) {
            [self showHudWithTitle:@"小时数量应在1~12之间 设置失败"];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:dayNum] forKey:UserDefaultKeyAboveHours];
        [self refreshData:_beforeCellModel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    
    _clearAC = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要恢复初始设置吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [_clearAC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:UserDefaultKeyAboveHours];
        [[NSUserDefaults standardUserDefaults] setObject:@30 forKey:UserDefaultKeyShowDays];
        [[NSFileManager defaultManager] removeItemAtPath:HeadImgFilePath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:BackImgFilePath error:nil];
        
        [self refreshData:_beforeCellModel];
        [self refreshData:_dayNumberCellModel];
        [self refreshData:_csBackImageCellModel];
        [self refreshData:_csHeadImageCellModel];
        [self.ysjTV.tableView reloadData];
    }]];
    
    [_clearAC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
