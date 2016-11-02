//
//  YSJPhotoAlbumCell.m
//  ysjLib
//
//  Created by ysj on 16/7/28.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJPhotoAlbumCell.h"
#import "UIView+YSJ.h"
#import "YSJPhotoConstant.h"

@implementation YSJPhotoAlbumCell

+ (instancetype)cellWithTableView:(UITableView *)tableView title:(NSString *)title image:(UIImage *)image{
    static NSString *identifier = @"cell";
    YSJPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YSJPhotoAlbumCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.albumImgView = [[UIImageView alloc]initWithFrame:CGRectMake(
             AlbumCellEdge,
             AlbumCellEdge,
             AlbumCellHeight-2*AlbumCellEdge,
             AlbumCellHeight-2*AlbumCellEdge)];
        cell.albumImgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.albumImgView.clipsToBounds = YES;
        [cell addSubview:cell.albumImgView];
        
        cell.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(
             cell.albumImgView.right+1.5*AlbumCellEdge,
             0,
             cell.width-AlbumCellHeight-4*AlbumCellEdge,
             AlbumCellHeight)];
        cell.titleLabel.textColor = [UIColor blackColor];
        [cell addSubview:cell.titleLabel];
    }
    cell.albumImgView.image = image;
    cell.titleLabel.text = title;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
