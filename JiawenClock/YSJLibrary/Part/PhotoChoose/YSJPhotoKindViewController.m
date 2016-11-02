//
//  YSJPhotoKindViewController.m
//  ysjLib
//
//  Created by ysj on 16/7/26.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJPhotoKindViewController.h"
#import "UIBarButtonItem+YSJ.h"
#import  <Photos/Photos.h>
#import "YSJPhotoAlbumCell.h"
#import "YSJPhotoChooseViewController.h"
#import "YSJPhotoConstant.h"

@interface YSJPhotoKindViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) PicsSelectdHandle handle;
@property (nonatomic, assign) ShowType showType;
@property (nonatomic, assign) SelectType selectType;

@end

@implementation YSJPhotoKindViewController

- (instancetype)initWithShowType:(ShowType)showType selectType:(SelectType)selectType picsSelectHandle:(PicsSelectdHandle)handle{
    if (self = [super init]) {
        self.showType = showType;
        self.selectType = selectType;
        self.handle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" color:self.view.tintColor textSize:RightBarItemTextSize bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(cancelBtnClicked)];
    self.navigationItem.title = @"选取照片";
    [self setBackBtnText:nil];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-StatusBarHeight-NavigationBarHeight) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self initPic];
}

- (void)initPic{
    // 列出所有相册智能相册
    PHFetchResult *albumsResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    _dataArr = [NSMutableArray array];
    for (int i = 0; i < albumsResult.count; i++) {
        PHCollection *phCollection = albumsResult[i];
        if ([phCollection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)phCollection;
            [self.dataArr addObject:assetCollection];
        }else{
            NSAssert(NO, @"Fetch collection not PHCollection: %@", phCollection);
        }
    }
}

- (void)cancelBtnClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AlbumCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PHAssetCollection *assetCollection = self.dataArr[indexPath.row];
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    PHAsset *asset = fetchResult.lastObject;
    
    NSString *cellTitle = [NSString stringWithFormat:@"%@（%lu）", assetCollection.localizedTitle, fetchResult.count];
    
    YSJPhotoAlbumCell *cell = [YSJPhotoAlbumCell cellWithTableView:tableView title:cellTitle image:[UIImage imageNamed:@"none"]];
    
    if (fetchResult.count != 0) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(AlbumCellHeight*2, AlbumCellHeight*2) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.albumImgView.image = result;
        }];
    }else{
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PHAssetCollection *assetCollection = self.dataArr[indexPath.row];
    YSJPhotoChooseViewController *photoVC = [[YSJPhotoChooseViewController alloc]initWithAssetCollection:assetCollection showType:self.showType selectType:self.selectType handle:self.handle];
    [self.navigationController pushViewController:photoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
