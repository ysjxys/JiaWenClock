//
//  UIBarButtonItem+YSJ.h
//  ysjLib
//
//  Created by ysj on 16/5/16.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YSJ)

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton，frame为image的frame
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets higlightedImage:(UIImage *)higlightedImage alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action;

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets bounds:(CGRect)frame higlightedImage:(UIImage *)higlightedImage alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action;

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton 根据title设置button标题
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title color:(UIColor *)color textSize:(CGFloat)textSize bounds:(CGRect)bound  alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action;

/**
 *  修改自己创建的导航栏按钮标题
 */
- (void)chanegCustomerBarBtnTitle:(NSString *)title;

@end
