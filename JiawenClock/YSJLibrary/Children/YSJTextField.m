//
//  YSJTextField.m
//  JiawenClock
//
//  Created by ysj on 16/9/29.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJTextField.h"

@implementation YSJTextField
//设置默认文字的显示区域
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(10, 0, bounds.size.width-20, bounds.size.height);
}

//设置文本显示的区域
- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(10, 0, bounds.size.width-20, bounds.size.height);
}

//编辑区域，即光标的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(10, 0, bounds.size.width-20, bounds.size.height);
}


@end
