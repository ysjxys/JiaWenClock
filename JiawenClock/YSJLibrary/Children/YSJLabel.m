//
//  YSJLabel.m
//  JiawenClock
//
//  Created by ysj on 16/9/10.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "YSJLabel.h"

@implementation YSJLabel

- (instancetype)init{
    if (self = [super init]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}


-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment{
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];//重绘一下
}


-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch(self.verticalAlignment){
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y+(bounds.size.height-textRect.size.height)/2.0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y+bounds.size.height-textRect.size.height;
            break;
        default:
            textRect.origin.y = bounds.origin.y+(bounds.size.height-textRect.size.height)/2.0;
            break;
    }
    return textRect;
}


-(void)drawTextInRect:(CGRect)rect{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];//重新计算位置
    [super drawTextInRect:actualRect];
}

@end
