//
//  YSJPhotoCell.h
//  ysjLib
//
//  Created by ysj on 16/7/28.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class YSJPHAsset;

@interface YSJPhotoCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath ysjPHAsset:(YSJPHAsset *)ysjAsset;

- (void)changeSelected;

@end
