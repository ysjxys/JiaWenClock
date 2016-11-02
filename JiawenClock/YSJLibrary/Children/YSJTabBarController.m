//
//  YSJTabBarController.m
//  ysjLib
//
//  Created by ysj on 16/6/6.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJTabBarController.h"

@interface YSJTabBarController()

@end

@implementation YSJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _interfaceOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
    _isAutorotate = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
