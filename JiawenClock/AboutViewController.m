//
//  AboutViewController.m
//  JiawenClock
//
//  Created by ysj on 16/10/24.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"关于";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, self.view.frame.size.width-30*2, 200)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    label.text = @"谨以此APP献给曾在客服岗位上努力奉献的筱雯同学";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
