//
//  YSJLabel.h
//  JiawenClock
//
//  Created by ysj on 16/9/10.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VerticalAlignment){
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle,//default
    VerticalAlignmentBottom,
};

@interface YSJLabel : UILabel
//{
//@private
//    VerticalAlignment _verticalAlignment;
//}

@property(nonatomic, assign) VerticalAlignment verticalAlignment;

@end