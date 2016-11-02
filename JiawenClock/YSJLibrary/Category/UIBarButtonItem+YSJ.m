//
//  UIBarButtonItem+YSJ.m
//  ysjLib
//
//  Created by ysj on 16/5/16.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "UIBarButtonItem+YSJ.h"

@implementation UIBarButtonItem (YSJ)

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton，frame为image的frame
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets higlightedImage:(UIImage *)higlightedImage alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action{
    return [self itemWithImage:image edgeInsets:edgeInsets bounds:CGRectNull higlightedImage:higlightedImage alignment:alignment target:target action:action];
}

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets bounds:(CGRect)frame higlightedImage:(UIImage *)higlightedImage alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 2.设置按钮背景图片
    UIImage *normal = image;
    [btn setImage:normal forState:UIControlStateNormal];
    [btn setImage:higlightedImage forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = alignment;
    
    // 3.设置按钮的尺寸
    [btn setImageEdgeInsets:edgeInsets];
    btn.bounds = CGRectIsEmpty(frame) ? CGRectMake(0, 0, normal.size.width, normal.size.height) : frame;
    
    // 4.监听按钮点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 5.返回创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/**
 *  创建一个指定的UIBarButtonItem 内部封装一个UIButton 根据title设置button标题
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title color:(UIColor *)color textSize:(CGFloat)textSize bounds:(CGRect)bound alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 2.设置标题及颜色
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    btn.contentHorizontalAlignment = alignment;
    
    // 3.设置按钮的尺寸
    btn.frame = bound;
    
    // 4.监听按钮点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 5.返回创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/**
 *  修改自己创建的导航栏按钮标题
 */
- (void)chanegCustomerBarBtnTitle:(NSString *)title{
    UIButton *btn = (UIButton *)self.customView;
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
