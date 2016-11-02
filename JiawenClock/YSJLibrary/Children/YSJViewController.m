//
//  YSJViewController.m
//  DOTA2Helper
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJViewController.h"
#import "MBProgressHUD.h"
#import "YSJNavigationController.h"
#import "UIImage+YSJ.h"
#import "YSJTabBarController.h"

@interface YSJViewController ()
@property (nonatomic, copy) ClickedOption titleBtnClickOption;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL isStatusBarHidden;
@property (nonatomic, assign) UIStatusBarAnimation statusBarAnimation;

@property (nonatomic, strong) UINavigationController *selfNavigationController;
@property (nonatomic, strong) UITabBarController *selfTabBarController;
@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientation;
@property (nonatomic, assign) BOOL shouldAutorotate;
@end

@implementation YSJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selfNavigationController = self.navigationController;
    _selfTabBarController  =self.tabBarController;
//    YSJNavigationController *nav = (YSJNavigationController *)self.navigationController;
//    
//    //设置标题颜色与字体
//    [nav setNavigationTitleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17.0f]];
//    
//    //设置背景颜色
//    [nav setBackGroundImage:[UIImage imageWithColor:RGBA(38, 46, 56, 1)]];
//    
//    //设置返回键 颜色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    
//    //设置返回键文字内容
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"";
//    self.navigationItem.backBarButtonItem = backItem;
//    
//    //设置statusbar style
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

#pragma mark - NavigationBar method
/**
 *  设置标题内容按钮
 */
- (void)navigationItemTitleViewWithButton:(UIButton *)btn option:(ClickedOption)option{
    [btn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
    _titleBtnClickOption = option;
}

/**
 *  设置标题内容、颜色、字体
 */
- (void)setTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font{
    self.navigationItem.title = title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color,                NSFontAttributeName:font};
}

/**
 *  设置下一ViewController返回按钮文本
 */
- (void)setBackBtnText:(NSString *)text{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = text?text:@"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)titleBtnClicked:(UIButton *)btn{
    _titleBtnClickOption(btn);
}

#pragma mark - StatusBar method
/**
 *  改变statusBarStyle
 */
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    
    if ([_selfNavigationController isKindOfClass:[YSJNavigationController class]]) {
        YSJNavigationController *nav = (YSJNavigationController *)_selfNavigationController;
        nav.statusBarStyle = statusBarStyle;
        [nav setNeedsStatusBarAppearanceUpdate];
        return;
    }
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}

/**
 *  改变状态栏是否隐藏
 */
- (void)setStatusBarHidden:(BOOL)shouldHidden{
    self.isStatusBarHidden = shouldHidden;
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (BOOL)prefersStatusBarHidden{
    return _isStatusBarHidden;
}

/**
 *  设置状态栏隐藏动画
 */
- (void)setStatusBarHideAnimation:(UIStatusBarAnimation)statusBarAnimation{
    self.statusBarAnimation = statusBarAnimation;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return _statusBarAnimation;
}


//- (void)changeScreenToHorizontal{
//    //ViewController
//    _orientationMask = UIInterfaceOrientationMaskLandscape;
//    
//    //NavigationController
//    [_nav setOrientationMask:_orientationMask];
//    
//    //TabBarController
//    [_tabBar setOrientationMask:_orientationMask];
//    [self changeInterfaceOrientation:UIInterfaceOrientationMaskLandscape];
//}
//

#pragma mark - DeviceOrientation method
//是否允许自动旋转
- (BOOL)shouldAutorotate{
    return _shouldAutorotate;
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

/**
 *  改变可供旋转的方向
 */
- (void)changeInterfaceOrientation:(UIInterfaceOrientationMask)interfaceOrientation{
    _interfaceOrientation = interfaceOrientation;
    
    if ([_selfNavigationController isKindOfClass:[YSJNavigationController class]]) {
        YSJNavigationController *nav = (YSJNavigationController *)_selfNavigationController;
        nav.interfaceOrientation = _interfaceOrientation;
    }
    
    if ([_selfTabBarController isKindOfClass:[YSJTabBarController class]]) {
        YSJTabBarController *tab = (YSJTabBarController *)_selfTabBarController;
        tab.interfaceOrientation = _interfaceOrientation;
    }
    [self changeInterfaceOrientationToDeviceOrientation:interfaceOrientation];
}

/**
 *  设置是否锁定屏幕旋转
 */
- (void)changeScreenLockState:(BOOL)isLock{
    _shouldAutorotate = !isLock;
    
    if ([_selfNavigationController isKindOfClass:[YSJNavigationController class]]) {
        YSJNavigationController *nav = (YSJNavigationController *)_selfNavigationController;
        nav.isAutorotate = _shouldAutorotate;
    }
    
    if ([_selfTabBarController isKindOfClass:[YSJTabBarController class]]) {
        YSJTabBarController *tab = (YSJTabBarController *)_selfTabBarController;
        tab.isAutorotate = _shouldAutorotate;
    }
}

/**
 *  强制改变屏幕方向
 */
- (void)changeDeviceOrientation:(UIDeviceOrientation)interfaceOrientation{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
}

/**
 *  根据重力感应改变屏幕方向
 */
- (void)changeDeviceOrientationSituable{
    [self changeDeviceOrientation:[UIDevice currentDevice].orientation];
}

- (void)changeInterfaceOrientationToDeviceOrientation:(UIInterfaceOrientationMask)interfaceOrientation{
    UIDeviceOrientation deviceOrientation = UIDeviceOrientationPortrait;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationMaskPortrait:
            deviceOrientation = UIDeviceOrientationPortrait;
            break;
        case UIInterfaceOrientationMaskLandscapeLeft:
            deviceOrientation = UIDeviceOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationMaskLandscapeRight:
            deviceOrientation = UIDeviceOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationMaskPortraitUpsideDown:
            deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationMaskLandscape:
            if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
                deviceOrientation = UIDeviceOrientationLandscapeRight;
            }else{
                deviceOrientation = UIDeviceOrientationLandscapeLeft;
            }
            break;
        case UIInterfaceOrientationMaskAll:
            deviceOrientation = [UIDevice currentDevice].orientation;
            break;
        case UIInterfaceOrientationMaskAllButUpsideDown:
            if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
                deviceOrientation = UIDeviceOrientationPortrait;
            }else{
                deviceOrientation = [UIDevice currentDevice].orientation;
            }
            break;
        default:
            break;
    }
    [self changeDeviceOrientation:deviceOrientation];
}



#pragma mark - HUD method
/**
 *  任意控制器的提示title
 */
+ (void)showHudWithTarget:(id)target title:(NSString *)title{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:[(UIViewController *)target view]];
    HUD.labelText = title;
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"X"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [[(UIViewController *)target view] addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5f);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

/**
 *  提示title
 */
- (void)showHudWithTitle:(NSString *)title{
    [YSJViewController showHudWithTarget:self title:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
