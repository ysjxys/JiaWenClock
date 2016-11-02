//
//  YSJScrollRoundView.h
//  ysjLib
//
//  Created by ysj on 16/7/22.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImgSelectedHandle)(NSUInteger index);

@interface YSJScrollRoundView : UIView
@property (nonatomic, strong) UIPageControl *pageControl;

+ (instancetype)viewWithRect:(CGRect)rect imgsStrArr:(NSArray *)imgsStrArr autoRun:(BOOL)autoRun timeInterval:(NSTimeInterval)timeInterval imgSelectedHandle:(ImgSelectedHandle)handle;

+ (instancetype)viewWithRect:(CGRect)rect imgsArr:(NSArray *)imgsArr autoRun:(BOOL)autoRun timeInterval:(NSTimeInterval)timeInterval imgSelectedHandle:(ImgSelectedHandle)handle;


@end
