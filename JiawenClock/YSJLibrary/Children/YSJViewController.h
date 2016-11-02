//
//  YSJViewController.h
//  ysjLib
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickedOption)(UIButton *btn);
@interface YSJViewController : UIViewController

#pragma mark - NavigationBar method
/**
 *  任意控制器的提示title
 */
+ (void)showHudWithTarget:(id)target title:(NSString *)title;
/**
 *  提示title
 */
- (void)showHudWithTitle:(NSString *)title;

/**
 *  设置标题内容按钮
 */
- (void)navigationItemTitleViewWithButton:(UIButton *)btn option:(ClickedOption)option;

/**
 *  设置标题内容、颜色、字体
 */
- (void)setTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font;

/**
 *  设置下一ViewController返回按钮文本
 */
- (void)setBackBtnText:(NSString *)text;

#pragma mark - StatusBar method
/**
 *  改变statusBarStyle
 */
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

/**
 *  改变状态栏是否隐藏
 */
- (void)setStatusBarHidden:(BOOL)shouldHidden;

/**
 *  设置状态栏隐藏动画
 */
- (void)setStatusBarHideAnimation:(UIStatusBarAnimation)statusBarAnimation;

#pragma mark - DeviceOrientation method
/**
 *  改变可供旋转的方向
 */
- (void)changeInterfaceOrientation:(UIInterfaceOrientationMask)interfaceOrientation;

/**
 *  设置是否锁定屏幕旋转
 */
- (void)changeScreenLockState:(BOOL)isLock;

/**
 *  强制改变屏幕方向
 */
- (void)changeDeviceOrientation:(UIDeviceOrientation)interfaceOrientation;

/**
 *  根据重力感应改变屏幕方向
 */
- (void)changeDeviceOrientationSituable;
@end
