//
//  YSJPhotoAlbumCell.h
//  ysjLib
//
//  Created by ysj on 16/7/28.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YSJPhotoAlbumCell : UITableViewCell

@property (nonatomic, strong) UIImageView *albumImgView;
@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView title:(NSString *)title image:(UIImage *)image;

@end
