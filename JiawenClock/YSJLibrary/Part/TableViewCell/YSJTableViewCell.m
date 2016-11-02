//
//  YSJTableViewCell.m
//  JiawenClock
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTableViewCell.h"
#import "YSJCellModel.h"
#import "YSJCellCenterModel.h"
#import "YSJCellHeadingModel.h"
#import "YSJCellTrailingModel.h"

#define CellContentSizePercent 0.85f

@interface YSJTableViewCell()
@property (nonatomic, strong) YSJCellModel *cellModel;

@property (nonatomic, strong) UIView *cellBackView;
@property (nonatomic, strong) UIView *headingBasicView;
@property (nonatomic, strong) UIView *centerBasicView;
@property (nonatomic, strong) UIView *trailingBasicView;
@property (nonatomic, strong) UILabel *bottomLineLabel;

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIView *headCustomerView;

@property (nonatomic, strong) UIImageView *trailImgView;
@property (nonatomic, strong) UIView *trailCustomerView;

@property (nonatomic, strong) UIView *centerTopCustomerView;
@property (nonatomic, strong) UIView *centerMiddleCustomerView;
@property (nonatomic, strong) UIView *centerBottomCustomerView;

//cellBackView
@property (nonatomic, strong) NSLayoutConstraint *backViewHeightConstraintA;
@property (nonatomic, strong) NSLayoutConstraint *backViewHeightConstraintB;
@property (nonatomic, strong) NSLayoutConstraint *backViewWidthConstraintA;
@property (nonatomic, strong) NSLayoutConstraint *backViewWidthConstraintB;
//headingBasicView
@property (nonatomic, strong) NSLayoutConstraint *hbvWidthConstraintA;
@property (nonatomic, strong) NSLayoutConstraint *hbvWidthConstraintB;
//@property (nonatomic, strong) NSLayoutConstraint *hbvWidthConstraintZero;
//trailingBasicView
@property (nonatomic, strong) NSLayoutConstraint *tbvWidthConstraintA;
@property (nonatomic, strong) NSLayoutConstraint *tbvWidthConstraintB;
//@property (nonatomic, strong) NSLayoutConstraint *tbvWidthConstraintZero;
//centerMiddleCustomerView
@property (nonatomic, strong) NSLayoutConstraint *cmcvHeightConstraintNormal;
@property (nonatomic, strong) NSLayoutConstraint *cmcvHeightConstraintZero;
//centerBottomCustomerView
@property (nonatomic, strong) NSLayoutConstraint *cbcvHeightConstraintNormal;
@property (nonatomic, strong) NSLayoutConstraint *cbcvHeightConstraintZero;

@end

@implementation YSJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView cellModel:(YSJCellModel *)cellModel identifier:(NSString *)identifier{
    YSJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YSJTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell initBasicConstraint];
        [cell initHeadingModelConstraint];
        [cell initTrailingModelConstraint];
        [cell initCenterModelConstraint];
//        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    cell.cellModel = cellModel;
    return cell;
}

- (void)setCellModel:(YSJCellModel *)cellModel{
    _cellModel = cellModel;
    [self updateCellContentHeightPercentDegree];
    [self updateHeadingViewWHCompareDegree];
    [self updateTrailingViewWHCompareDegree];
    
    switch (cellModel.headingModel.headingModelType) {
        case HeadingModelImage:
            [_headingBasicView bringSubviewToFront:_headImgView];
            _headImgView.image = cellModel.headingModel.headImg;
            break;
        case HeadingModelView:
            [_headingBasicView bringSubviewToFront:_headCustomerView];
            for (UIView *subView in _headCustomerView.subviews) {
                [subView removeFromSuperview];
            }
            if (!cellModel.headingModel.customerView) {
                break;
            }
            [_headCustomerView addSubview:cellModel.headingModel.customerView];
            [self initFullViewConstraint:cellModel.headingModel.customerView backView:_headCustomerView sizePercent:CellContentSizePercent];
            break;
        case HeadingModelNull:
        default:
            break;
    }
    
    switch (cellModel.trailingModel.trailingModelType) {
        case TrailingModelView:
            [_trailingBasicView bringSubviewToFront:_trailCustomerView];
            for (UIView *subView in _trailCustomerView.subviews) {
                [subView removeFromSuperview];
            }
            if (!cellModel.trailingModel.customerView) {
                break;
            }
            [_trailCustomerView addSubview:cellModel.trailingModel.customerView];
            [self initFullViewConstraint:cellModel.trailingModel.customerView backView:_trailCustomerView sizePercent:CellContentSizePercent];
            break;
        case TrailingModelArrow:
            for (UIView *view in self.trailCustomerView.subviews) {
                [view removeFromSuperview];
            }
            [_trailingBasicView bringSubviewToFront:_trailCustomerView];
            if (cellModel.trailingModel.customerView) {
                [_trailCustomerView addSubview:cellModel.trailingModel.customerView];
                [self initFullViewConstraint:cellModel.trailingModel.customerView backView:_trailCustomerView sizePercent:1.0f];
            }
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case TrailingModelImage:
            [_trailingBasicView bringSubviewToFront:_trailImgView];
            _trailImgView.image = cellModel.trailingModel.trailImg;
            break;
        case TrailingModelSwitch:{
            [_trailingBasicView bringSubviewToFront:_trailCustomerView];
            for (UIView *subView in _trailCustomerView.subviews) {
                [subView removeFromSuperview];
            }
            UISwitch *switchBtn = [[UISwitch alloc]init];
            [switchBtn addTarget:self action:@selector(switchBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
            [_trailCustomerView addSubview:switchBtn];
            [self initFullViewConstraint:switchBtn backView:_trailCustomerView sizePercent:CellContentSizePercent];
            break;
        }
        case TrailingModelNull:
        default:
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
    }
    switch (cellModel.centerModel.centerModelType) {
        case CenterModel1:
            [self setHideCenterMiddleAndBottomView];
            for (UIView *view in self.centerTopCustomerView.subviews) {
                [view removeFromSuperview];
            }
            [_centerTopCustomerView addSubview:cellModel.centerModel.topView];
            [self initFullViewConstraint:cellModel.centerModel.topView backView:_centerTopCustomerView sizePercent:1.0f];
            break;
        case CenterModel2:
            [self setHideCenterBottomView];
            for (UIView *view in self.centerTopCustomerView.subviews) {
                [view removeFromSuperview];
            }
            for (UIView *view in self.centerMiddleCustomerView.subviews) {
                [view removeFromSuperview];
            }
            [_centerTopCustomerView addSubview:cellModel.centerModel.topView];
            [self initFullViewConstraint:cellModel.centerModel.topView backView:_centerTopCustomerView sizePercent:1.0f];
            [_centerMiddleCustomerView addSubview:cellModel.centerModel.middleView];
            [self initFullViewConstraint:cellModel.centerModel.middleView backView:_centerMiddleCustomerView sizePercent:1.0f];
            break;
        case CenterModel3:
            [self setShowCenterAllViews];
            for (UIView *view in self.centerTopCustomerView.subviews) {
                [view removeFromSuperview];
            }
            for (UIView *view in self.centerMiddleCustomerView.subviews) {
                [view removeFromSuperview];
            }
            for (UIView *view in self.centerBottomCustomerView.subviews) {
                [view removeFromSuperview];
            }
            [_centerTopCustomerView addSubview:cellModel.centerModel.topView];
            [self initFullViewConstraint:cellModel.centerModel.topView backView:_centerTopCustomerView sizePercent:1.0f];
            [_centerMiddleCustomerView addSubview:cellModel.centerModel.middleView];
            [self initFullViewConstraint:cellModel.centerModel.middleView backView:_centerMiddleCustomerView sizePercent:1.0f];
            [_centerBottomCustomerView addSubview:cellModel.centerModel.bottomView];
            [self initFullViewConstraint:cellModel.centerModel.bottomView backView:_centerBottomCustomerView sizePercent:1.0f];
            break;
        case CenterModelNull:
        default:
            [self setHideCenterMiddleAndBottomView];
            for (UIView *view in self.centerTopCustomerView.subviews) {
                [view removeFromSuperview];
            }
            break;
    }
    
}

- (void)switchBtnValueChanged:(UISwitch *)switchBtn{
    self.cellModel.trailingModel.switchChangedHandle(self.cellModel, switchBtn.on);
}

- (void)initCenterModelConstraint{
    _centerTopCustomerView = [[UIView alloc]init];
    _centerTopCustomerView.clipsToBounds = YES;
//    _centerTopCustomerView.backgroundColor = [UIColor yellowColor];
    [_centerBasicView addSubview:_centerTopCustomerView];
    
    _centerMiddleCustomerView = [[UIView alloc]init];
    _centerMiddleCustomerView.clipsToBounds = YES;
//    _centerMiddleCustomerView.backgroundColor = [UIColor greenColor];
    [_centerBasicView addSubview:_centerMiddleCustomerView];
    
    _centerBottomCustomerView = [[UIView alloc]init];
    _centerBottomCustomerView.clipsToBounds = YES;
//    _centerBottomCustomerView.backgroundColor = [UIColor blueColor];
    [_centerBasicView addSubview:_centerBottomCustomerView];
    
    _centerTopCustomerView.translatesAutoresizingMaskIntoConstraints = NO;
    _centerMiddleCustomerView.translatesAutoresizingMaskIntoConstraints = NO;
    _centerBottomCustomerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat sizePercnet = (1 - CellContentSizePercent)/2 + CellContentSizePercent;
    
    NSLayoutConstraint *bcvLeading = [NSLayoutConstraint constraintWithItem:_centerBottomCustomerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_centerBasicView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *bcvTrailing = [NSLayoutConstraint constraintWithItem:_centerBottomCustomerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_centerBasicView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *bcvBottom = [NSLayoutConstraint constraintWithItem:_centerBottomCustomerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_centerBasicView attribute:NSLayoutAttributeBottom multiplier:sizePercnet constant:0.0f];
    
    _cbcvHeightConstraintNormal = [NSLayoutConstraint constraintWithItem:_centerBottomCustomerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_centerBasicView attribute:NSLayoutAttributeHeight multiplier:0.25f constant:0.0f];
    
    _cbcvHeightConstraintZero = [NSLayoutConstraint constraintWithItem:_centerBottomCustomerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
    
    bcvLeading.active = YES;
    bcvTrailing.active = YES;
    bcvBottom.active = YES;
    _cbcvHeightConstraintNormal.active = YES;
    _cbcvHeightConstraintZero.active = NO;
    
    NSLayoutConstraint *mcvLeading = [NSLayoutConstraint constraintWithItem:_centerMiddleCustomerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_centerBottomCustomerView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *mcvTrailing = [NSLayoutConstraint constraintWithItem:_centerMiddleCustomerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_centerBottomCustomerView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *mcvBottom = [NSLayoutConstraint constraintWithItem:_centerMiddleCustomerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_centerBottomCustomerView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    _cmcvHeightConstraintNormal = [NSLayoutConstraint constraintWithItem:_centerMiddleCustomerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_centerBasicView attribute:NSLayoutAttributeHeight multiplier:0.25f constant:0.0f];
    
    _cmcvHeightConstraintZero = [NSLayoutConstraint constraintWithItem:_centerMiddleCustomerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
    
    mcvLeading.active = YES;
    mcvTrailing.active = YES;
    mcvBottom.active = YES;
    _cmcvHeightConstraintNormal.active = YES;
    _cmcvHeightConstraintZero.active = NO;
    
    NSLayoutConstraint *tcvLeading = [NSLayoutConstraint constraintWithItem:_centerTopCustomerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_centerBottomCustomerView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tcvTrailing = [NSLayoutConstraint constraintWithItem:_centerTopCustomerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_centerBottomCustomerView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tcvTop = [NSLayoutConstraint constraintWithItem:_centerTopCustomerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_centerBasicView attribute:NSLayoutAttributeBottom multiplier:1.0f-sizePercnet constant:0.0f];
    
    NSLayoutConstraint *tcvBottom = [NSLayoutConstraint constraintWithItem:_centerTopCustomerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_centerMiddleCustomerView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    tcvLeading.active = YES;
    tcvTrailing.active = YES;
    tcvTop.active = YES;
    tcvBottom.active = YES;
}

- (void)initTrailingModelConstraint{
    _trailImgView = [[UIImageView alloc]init];
    _trailImgView.clipsToBounds = YES;
    _trailImgView.contentMode = UIViewContentModeScaleAspectFill;
//    _trailImgView.backgroundColor = [UIColor yellowColor];
    [_trailingBasicView addSubview:_trailImgView];
    [self initFullViewConstraint:_trailImgView backView:_trailingBasicView sizePercent:CellContentSizePercent];
    
    _trailCustomerView = [[UIView alloc]init];
    _trailCustomerView.clipsToBounds = YES;
//    _trailCustomerView.backgroundColor = [UIColor redColor];
    [_trailingBasicView addSubview:_trailCustomerView];
    [self initFullViewConstraint:_trailCustomerView backView:_trailingBasicView sizePercent:CellContentSizePercent];
}

- (void)initHeadingModelConstraint{
    _headImgView = [[UIImageView alloc]init];
    _headImgView.clipsToBounds = YES;
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
//    _headImgView.backgroundColor = [UIColor yellowColor];
    [_headingBasicView addSubview:_headImgView];
    [self initFullViewConstraint:_headImgView backView:_headingBasicView sizePercent:CellContentSizePercent];
    
    _headCustomerView = [[UIView alloc]init];
    _headCustomerView.clipsToBounds = YES;
//    _headCustomerView.backgroundColor = [UIColor redColor];
    [_headingBasicView addSubview:_headCustomerView];
    [self initFullViewConstraint:_headCustomerView backView:_headingBasicView sizePercent:CellContentSizePercent];
}

- (void)initFullViewConstraint:(UIView *)view backView:(UIView *)backView sizePercent:(CGFloat)sizePercent{
    if (!view || !backView) {
        YSJLOG(@"initFullViewConstraint 某个需要约束的view不存在");
        return;
    }
    view.translatesAutoresizingMaskIntoConstraints = NO;
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeWidth multiplier:sizePercent constant:0.0f];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeHeight multiplier:sizePercent constant:0.0f];
    
    centerX.active = YES;
    centerY.active = YES;
    width.active = YES;
    height.active = YES;
}

- (void)initBasicConstraint{
    _cellBackView = [[UIView alloc]init];
    _headingBasicView = [[UIView alloc]init];
    _centerBasicView = [[UIView alloc]init];
    _trailingBasicView = [[UIView alloc]init];
    
    _cellBackView.clipsToBounds = YES;
    _headingBasicView.clipsToBounds = YES;
    _centerBasicView.clipsToBounds = YES;
    _trailingBasicView.clipsToBounds = YES;
    
//    _cellBackView.backgroundColor = [UIColor whiteColor];
//    _headingBasicView.backgroundColor = [UIColor redColor];
//    _centerBasicView.backgroundColor = [UIColor whiteColor];
//    _trailingBasicView.backgroundColor = [UIColor purpleColor];
    
    [self.contentView addSubview:_cellBackView];
    [_cellBackView addSubview:_headingBasicView];
    [_cellBackView addSubview:_centerBasicView];
    [_cellBackView addSubview:_trailingBasicView];
    
    _cellBackView.translatesAutoresizingMaskIntoConstraints = NO;
    _headingBasicView.translatesAutoresizingMaskIntoConstraints = NO;
    _centerBasicView.translatesAutoresizingMaskIntoConstraints = NO;
    _trailingBasicView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *backViewCenterX = [NSLayoutConstraint constraintWithItem:_cellBackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *backViewCenterY = [NSLayoutConstraint constraintWithItem:_cellBackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *backViewWidth = [NSLayoutConstraint constraintWithItem:_cellBackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    
    _backViewHeightConstraintA = [NSLayoutConstraint constraintWithItem:_cellBackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    backViewCenterX.active = YES;
    backViewCenterY.active = YES;
    backViewWidth.active = YES;
    _backViewHeightConstraintA.active = YES;
    
    // _headingBasicView
    NSLayoutConstraint *hbvLeading = [NSLayoutConstraint constraintWithItem:_headingBasicView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *hbvTop = [NSLayoutConstraint constraintWithItem:_headingBasicView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *hbvBottom = [NSLayoutConstraint constraintWithItem:_headingBasicView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    // leadingBasicView宽度与_cellBackView的高度一致
    _hbvWidthConstraintA = [NSLayoutConstraint constraintWithItem:_headingBasicView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    hbvLeading.active = YES;
    hbvTop.active = YES;
    hbvBottom.active = YES;
    _hbvWidthConstraintA.active = YES;
    
    // _trailingBasicView
    NSLayoutConstraint *tbvTrailing = [NSLayoutConstraint constraintWithItem:_trailingBasicView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tbvTop = [NSLayoutConstraint constraintWithItem:_trailingBasicView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headingBasicView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *tbvBottom = [NSLayoutConstraint constraintWithItem:_trailingBasicView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_headingBasicView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    // trailingBasicView宽度与_cellBackView的高度一致
    _tbvWidthConstraintA = [NSLayoutConstraint constraintWithItem:_trailingBasicView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeHeight multiplier:1.5f constant:0.0f];
    
    tbvTrailing.active = YES;
    tbvTop.active = YES;
    tbvBottom.active = YES;
    _tbvWidthConstraintA.active = YES;
    
    // _centerBasicView
    NSLayoutConstraint *cbvLeading = [NSLayoutConstraint constraintWithItem:_centerBasicView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_headingBasicView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *cbvTrailing = [NSLayoutConstraint constraintWithItem:_centerBasicView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_trailingBasicView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *cbvTop = [NSLayoutConstraint constraintWithItem:_centerBasicView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headingBasicView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *cbvBottom = [NSLayoutConstraint constraintWithItem:_centerBasicView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_headingBasicView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    cbvLeading.active = YES;
    cbvTrailing.active = YES;
    cbvTop.active = YES;
    cbvBottom.active = YES;
}

- (void)setHideCenterBottomView{
    _cbcvHeightConstraintNormal.active = NO;
    _cbcvHeightConstraintZero.active = YES;
    _cmcvHeightConstraintZero.active = NO;
    _cmcvHeightConstraintNormal.active = YES;
}

- (void)setHideCenterMiddleAndBottomView{
    _cbcvHeightConstraintNormal.active = NO;
    _cbcvHeightConstraintZero.active = YES;
    _cmcvHeightConstraintNormal.active = NO;
    _cmcvHeightConstraintZero.active = YES;
}

- (void)setShowCenterAllViews{
    _cbcvHeightConstraintZero.active = NO;
    _cbcvHeightConstraintNormal.active = YES;
    _cmcvHeightConstraintZero.active = NO;
    _cmcvHeightConstraintNormal.active = YES;
}

- (void)updateCellContentHeightPercentDegree{
    NSLayoutConstraint *shouldEnableConstraint;
    NSLayoutConstraint *shouldUnEnableConstraint;
    CGFloat degree;
    if (self.cellModel.cellContentHeightPercentDegree > 1 || self.cellModel.cellContentHeightPercentDegree < 0) {
        degree = 1.0f;
    }else{
        degree = self.cellModel.cellContentHeightPercentDegree;
    }
    if (_backViewHeightConstraintA.active) {
        shouldUnEnableConstraint = _backViewHeightConstraintA;
        shouldEnableConstraint = _backViewHeightConstraintB;
    }else{
        shouldUnEnableConstraint = _backViewHeightConstraintB;
        shouldEnableConstraint = _backViewHeightConstraintA;
    }
    shouldEnableConstraint = nil;
    shouldEnableConstraint = [NSLayoutConstraint constraintWithItem:_cellBackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:degree constant:0.0f];
    shouldUnEnableConstraint.active = NO;
    shouldEnableConstraint.active = YES;
}

- (void)updateTrailingViewWHCompareDegree{
    NSLayoutConstraint *shouldEnableConstraint;
    NSLayoutConstraint *shouldUnEnableConstraint;
    CGFloat degree = 0.0f;
    if (self.cellModel.trailingModel) {
        degree = self.cellModel.trailingModel.trailViewWHCompareDegree;
    }
    
    if (_tbvWidthConstraintA.active) {
        shouldUnEnableConstraint = _tbvWidthConstraintA;
        shouldEnableConstraint = _tbvWidthConstraintB;
    }else{
        shouldUnEnableConstraint = _tbvWidthConstraintB;
        shouldEnableConstraint = _tbvWidthConstraintA;
    }
    shouldEnableConstraint = nil;
    shouldEnableConstraint = [NSLayoutConstraint constraintWithItem:_trailingBasicView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeHeight multiplier:degree constant:0.0f];
    shouldUnEnableConstraint.active = NO;
    shouldEnableConstraint.active = YES;
}

- (void)updateHeadingViewWHCompareDegree{
    NSLayoutConstraint *shouldEnableConstraint;
    NSLayoutConstraint *shouldUnEnableConstraint;
    CGFloat degree = 0.0f;
    if (self.cellModel.headingModel) {
        degree = self.cellModel.headingModel.headViewWHCompareDegree;
    }
    
    if (_hbvWidthConstraintA.active) {
        shouldUnEnableConstraint = _hbvWidthConstraintA;
        shouldEnableConstraint = _hbvWidthConstraintB;
    }else{
        shouldUnEnableConstraint = _hbvWidthConstraintB;
        shouldEnableConstraint = _hbvWidthConstraintA;
    }
    
    shouldEnableConstraint = nil;
    shouldEnableConstraint = [NSLayoutConstraint constraintWithItem:_headingBasicView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellBackView attribute:NSLayoutAttributeHeight multiplier:degree constant:0.0f];
    shouldUnEnableConstraint.active = NO;
    shouldEnableConstraint.active = YES;
}

@end
