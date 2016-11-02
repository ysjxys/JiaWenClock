//
//  YSJLoadingView.m
//  ysjLib
//
//  Created by ysj on 16/7/22.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJLoadingView.h"
#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高

@interface YSJLoadingView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YSJLoadingView

+ (instancetype)viewWithImgArr:(NSArray *)imgArr{
    return [[self alloc]initWithImgArr:imgArr];
}

- (instancetype)initWithImgArr:(NSArray *)imgArr{
    if (self = [super init]) {
        _imageArray = imgArr;
        self.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height)];
        
        scrollView.contentSize = CGSizeMake((_imageArray.count + 1)*MainScreen_width, MainScreen_height);
        //设置反野效果，不允许反弹，不显示水平滑动条，设置代理为自己
        scrollView.pagingEnabled = YES;//设置分页
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _bigScrollView = scrollView;
        
        for (int i = 0; i < imgArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(i * MainScreen_width, 0, MainScreen_width, MainScreen_height);
            if ([imgArr[i] isKindOfClass:[UIImage class]]) {
                imageView.image = imgArr[i];
            }else{
                imageView.image = [UIImage imageNamed:imgArr[i]];
            }
            [scrollView addSubview:imageView];
        }
        
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreen_width/2, MainScreen_height - 60, 0, 40)];
        pageControl.numberOfPages = imgArr.count;
        pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:pageControl];
        
        _pageControl = pageControl;
        
        //添加手势
        UITapGestureRecognizer *singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1;
        [scrollView addGestureRecognizer:singleRecognizer];
    }
    return self;
}


-(void)handleSingleTapFrom{
    if (_pageControl.currentPage == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bigScrollView) {
        CGPoint offSet = scrollView.contentOffset;
        _pageControl.currentPage = offSet.x/(self.bounds.size.width);//计算当前的页码
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * (_pageControl.currentPage), scrollView.contentOffset.y) animated:YES];
    }
    if (scrollView.contentOffset.x == (_imageArray.count) *MainScreen_width) {
        self.hidden = YES;
    }
}

@end
