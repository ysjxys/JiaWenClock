//
//  YSJCellGroupModel.h
//  ysjLib
//
//  Created by ysj on 16/9/8.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSJCellGroupModel : NSObject


@property (nonatomic, copy) NSArray *modelArr;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) CGFloat headViewHeight;
@property (nonatomic, assign) CGFloat footViewHeight;

@end
