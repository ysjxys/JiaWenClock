//
//  YSJNavigationController.m
//  ysjLib
//
//  Created by ysj on 16/5/17.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJNavigationController.h"
#import "YSJTabBarController.h"

@interface YSJNavigationController()
@end
@implementation YSJNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    _interfaceOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
    _isAutorotate = NO;
}

#pragma mark - rotato method
//是否允许自动旋转
- (BOOL)shouldAutorotate{
    return _isAutorotate;
}

//支持哪些方向的旋转
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return _interfaceOrientation;
}

#pragma mark - StatusBarStyle method
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}

/**
 *  设置背景图
 */
- (void)setBackGroundImage:(UIImage *)image{
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

/**
 *  设置标题颜色与字体
 */
- (void)setNavigationTitleColor:(UIColor *)color font:(UIFont *)font{
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color,                NSFontAttributeName:font};
    //    [UIFont boldSystemFontOfSize:font]
}

/**
 *  设置TabBarItem
 */
- (void)setTabBarItemWithImage:(UIImage *)image SelectedImage:(UIImage *)selectedImage renderingMode:(UIImageRenderingMode)renderingMode title:(NSString *)title titleColor:(UIColor *)titleColor{
    image = [image imageWithRenderingMode:renderingMode];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:image selectedImage:selectedImage];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.tabBarItem = item;
}
@end
