//
//  YSJNavigationController.h
//  ysjLib
//
//  Created by ysj on 16/5/17.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSJNavigationController : UINavigationController

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientation;
@property (nonatomic, assign) BOOL isAutorotate;

/**
 *  设置背景图
 */
- (void)setBackGroundImage:(UIImage *)image;

/**
 *  设置标题颜色与字体
 */
- (void)setNavigationTitleColor:(UIColor *)color font:(UIFont *)font;

/**
 *  设置TabBarItem
 */
- (void)setTabBarItemWithImage:(UIImage *)image SelectedImage:(UIImage *)selectedImage renderingMode:(UIImageRenderingMode)renderingMode title:(NSString *)title titleColor:(UIColor *)titleColor;

@end
