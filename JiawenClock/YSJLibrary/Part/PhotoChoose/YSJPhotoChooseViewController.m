//
//  YSJPhotoChooseViewController.m
//  ysjLib
//
//  Created by ysj on 16/7/28.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJPhotoChooseViewController.h"
#import "UIBarButtonItem+YSJ.h"
#import "YSJPhotoCell.h"
#import "YSJPhotoConstant.h"
#import "UIView+YSJ.h"
#import "YSJPHAsset.h"
#import "YSJCommonTools.h"

@interface YSJPhotoChooseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) ShowType showType;
@property (nonatomic, assign) SelectType selectType;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) PicsSelectdHandle handle;

@property (nonatomic, strong) UIView *backDetailView;
@property (nonatomic, strong) UIImageView *imgDetailView;
@property (nonatomic, strong) UIView *bottomDetailView;
@property (nonatomic, assign) BOOL isDetailMode;
@end

@implementation YSJPhotoChooseViewController

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection showType:(ShowType)showType selectType:(SelectType)selectType handle:(PicsSelectdHandle)handle{
    if (self = [super init]) {
        self.assetCollection = assetCollection;
        self.handle = handle;
        self.showType = showType;
        self.selectType = selectType;
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        for (int i = 0; i < result.count; i++) {
            YSJPHAsset *ysjAsset = [YSJPHAsset ysjAssetWithPHAsset:[result objectAtIndex:i]];
            [self.dataArr addObject:ysjAsset];
        }
        //按时间顺序排序 ascend:是否升序
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"phAsset.creationDate" ascending:NO];
        //为数组增加排序规则
        [self.dataArr sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.assetCollection.localizedTitle;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" color:self.view.tintColor textSize:RightBarItemTextSize bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(rightBarBtnClicked)];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-StatusBarHeight-NavigationBarHeight) collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[YSJPhotoCell class] forCellWithReuseIdentifier:PhotoCollectionCellIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    if (_showType == showTypeList) {
        
    }else if(_showType == showTypeDetail){
        self.isDetailMode = YES;
        [self changeRightBarBtnTitle];
        [self initDetaiViews];
    }
}

- (void)initDetaiViews{
    UIView *backDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-StatusBarHeight-NavigationBarHeight)];
    backDetailView.backgroundColor = [UIColor whiteColor];
    self.backDetailView = backDetailView;
    backDetailView.alpha = 0;
    [self.view addSubview:backDetailView];
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backDetailViewTap)];
    [backDetailView addGestureRecognizer:tap];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.backDetailView.frame];
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor whiteColor];
    [backDetailView addSubview:imgView];
    self.imgDetailView = imgView;
    
    CGFloat bottomDetailViewHeight = 40;
    UIView *bottomDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom-StatusBarHeight-NavigationBarHeight-bottomDetailViewHeight, self.view.width, bottomDetailViewHeight)];
    bottomDetailView.backgroundColor = [UIColor whiteColor];
    bottomDetailView.alpha = 0;
    self.bottomDetailView = bottomDetailView;
    [self.view addSubview:bottomDetailView];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bottomDetailView.width, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    lineLabel.alpha = 0.3;
    [bottomDetailView addSubview:lineLabel];
    
    UIButton *bottomSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomSureBtn.frame = CGRectMake(0, 0, bottomDetailView.width, bottomDetailView.height);
    [bottomSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomSureBtn setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [bottomSureBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [bottomSureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomDetailView addSubview:bottomSureBtn];
}

- (void)changeRightBarBtnTitle{
    [self.navigationItem.rightBarButtonItem chanegCustomerBarBtnTitle:self.isDetailMode?@"选择":@"取消"];
}

- (void)backDetailViewTap{
    [UIView animateWithDuration:0.2 animations:^{
        self.backDetailView.alpha = 0;
        self.collectionView.alpha = 1;
    }];
}

- (void)rightBarBtnClicked{
    if (_showType == showTypeList) {
        [self sureBtnClicked];
    }else if(_showType == showTypeDetail){
        self.isDetailMode = !self.isDetailMode;
        [self changeRightBarBtnTitle];
        if (self.isDetailMode) {
            for (YSJPHAsset *ysjAsset in self.dataArr) {
                ysjAsset.isSelected = NO;
            }
            [self.collectionView reloadData];
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomDetailView.alpha = !self.isDetailMode;
        }];
    }
}

- (void)sureBtnClicked{
    NSMutableArray<PHAsset *> *choosedArr = [NSMutableArray array];
    for (YSJPHAsset *ysjAsset in self.dataArr) {
        if (ysjAsset.isSelected) {
            [choosedArr addObject:ysjAsset.phAsset];
        }
        
    }
    if (choosedArr.count == 0) {
        return;
    }
    self.handle(choosedArr);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collection Delegate & DataSource & FlowLayoutDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     YSJPhotoCell *cell = [YSJPhotoCell cellWithCollectionView:collectionView indexPath:indexPath ysjPHAsset:self.dataArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showType == showTypeList) {
        //列表展示
        YSJPhotoCell *cell = (YSJPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell changeSelected];
        if (self.selectType == SelectTypeSingle) {
            [self sureBtnClicked];
        }
    }else if (self.showType == showTypeDetail){
        if (!self.isDetailMode) {
            //列表模式
            YSJPhotoCell *cell = (YSJPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell changeSelected];
        }else{
//            PHAsset *asset = self.dataArr[indexPath.row][DicKeyAsset];
            YSJPHAsset *ysjAsset = self.dataArr[indexPath.row];
            if (ysjAsset.phAsset.mediaType == PHAssetMediaTypeImage) {
                [[PHImageManager defaultManager] requestImageForAsset:ysjAsset.phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    self.imgDetailView.image = result;
                    [UIView animateWithDuration:0.2 animations:^{
                        self.backDetailView.alpha = 1;
                        self.collectionView.alpha = 0;
                    }];
                }];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
    return result.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(PhotoCollectionCellWidth, PhotoCollectionCellWidth);
}

//section top bottom left right edge
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(PhotoCollectionCellSectionEdge, PhotoCollectionCellSectionEdge, PhotoCollectionCellSectionEdge, PhotoCollectionCellSectionEdge);
}

//edge for line
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return PhotoCollectionCellSectionEdge;
}

//edge for cell
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return PhotoCollectionCellSectionEdge;
}


#pragma mark - Array & Dictionary InitMethod
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
