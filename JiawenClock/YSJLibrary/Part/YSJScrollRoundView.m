//
//  YSJScrollRoundView.m
//  ysjLib
//
//  Created by ysj on 16/7/22.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJScrollRoundView.h"
#import "UIView+YSJ.h"

@interface YSJScrollRoundView()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imgsArr;
@property (nonatomic, assign) BOOL autoRun;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, copy) ImgSelectedHandle handle;

@property (nonatomic, copy) NSArray *viewArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgViewLeft;
@property (nonatomic, strong) UIImageView *imgViewCenter;
@property (nonatomic, strong) UIImageView *imgViewRight;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation YSJScrollRoundView

#pragma mark - init method
+ (instancetype)viewWithRect:(CGRect)rect imgsStrArr:(NSArray *)imgsStrArr autoRun:(BOOL)autoRun timeInterval:(NSTimeInterval)timeInterval imgSelectedHandle:(ImgSelectedHandle)handle{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < imgsStrArr.count; i++) {
        UIImage *image = [UIImage imageNamed:imgsStrArr[i]];
        [tempArr addObject:image];
    }
    return [self viewWithRect:rect imgsArr:tempArr autoRun:autoRun timeInterval:timeInterval imgSelectedHandle:handle];
}

+ (instancetype)viewWithRect:(CGRect)rect imgsArr:(NSArray *)imgsArr autoRun:(BOOL)autoRun timeInterval:(NSTimeInterval)timeInterval imgSelectedHandle:(ImgSelectedHandle)handle{
    YSJScrollRoundView *view = [[YSJScrollRoundView alloc]initWithFrame:rect];
    view.frameWidth = rect.size.width;
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    scroll.contentSize = CGSizeMake(view.frameWidth*3, 0);
    scroll.contentOffset = CGPointMake(view.frameWidth, 0);
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = view;
    view.scrollView = scroll;
    [view addSubview:scroll];
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, rect.size.height-20, rect.size.width, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = imgsArr.count;
    pageControl.currentPage = 0;
    pageControl.tintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    [view addSubview:pageControl];
    
    view.pageControl = pageControl;
    view.imgsArr = imgsArr;
    view.handle = handle;
    view.viewArr = [view viewArrInit:rect.size imgsArr:imgsArr];
    
    if (autoRun) {
        view.autoRun = autoRun;
        view.timeInterval = timeInterval;
        [view addTimer];
    }
    return view;
}

- (NSMutableArray *)viewArrInit:(CGSize)size imgsArr:(NSArray *)imgsArr{
    if (imgsArr.count < 1) {
        return nil;
    }
    NSMutableArray *viewArr = [NSMutableArray array];
    
    UIImageView *imgViewLeft = [[UIImageView alloc]initWithImage:imgsArr[imgsArr.count-1]];
    imgViewLeft.frame = CGRectMake(0, 0, size.width, size.height);
    [viewArr addObject:imgViewLeft];
    [self.scrollView addSubview:imgViewLeft];
    self.imgViewLeft = imgViewLeft;
    
    
    UIImageView *imgViewCenter = [[UIImageView alloc]initWithImage:imgsArr[0]];
    imgViewCenter.frame = CGRectMake(size.width, 0, size.width, size.height);
    if (self.handle) {
        imgViewCenter.userInteractionEnabled = YES;
        [imgViewCenter addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewSelected)]];
    }
    [viewArr addObject:imgViewCenter];
    [self.scrollView addSubview:imgViewCenter];
    self.imgViewCenter = imgViewCenter;
    
    
    UIImage *rightImg = imgsArr.count>1?imgsArr[1]:imgsArr[0];
    UIImageView *imgViewRight = [[UIImageView alloc]initWithImage:rightImg];
    imgViewRight.frame = CGRectMake(2*size.width, 0, size.width, size.height);
    [viewArr addObject:imgViewRight];
    [self.scrollView addSubview:imgViewRight];
    self.imgViewRight = imgViewRight;
    
    return viewArr;
}

#pragma mark - UITapGestureRecognizer
- (void)imgViewSelected{
    UIImage *showImg = self.imgViewCenter.image;
    NSUInteger showIndex = [self.imgsArr indexOfObject:showImg];
    self.handle(showIndex);
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.autoRun) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoRun) {
        [self addTimer];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    scrollView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self changePic];
}

#pragma mark - Timer
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - changeMethod
- (void)nextPage{
    [self scrollViewWillBeginDecelerating:self.scrollView];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.frameWidth*2, 0);
    }];
    [self scrollViewDidEndDecelerating:self.scrollView];
}

- (void)changePic{
    if (self.scrollView.contentOffset.x == 0) {
        UIImage *showImg = self.imgViewLeft.image;
        NSUInteger showIndex = [self.imgsArr indexOfObject:showImg];
        self.imgViewCenter.image = showImg;
        if (showIndex+1 < self.imgsArr.count) {
            self.imgViewRight.image = self.imgsArr[showIndex+1];
        }else{
            self.imgViewRight.image = self.imgsArr[0];
        }
        self.scrollView.contentOffset = CGPointMake(self.frameWidth, 0);
        if (showIndex == 0) {
            self.imgViewLeft.image = self.imgsArr[self.imgsArr.count-1];
        }else{
            self.imgViewLeft.image = self.imgsArr[showIndex-1];
        }
        [self changeCurrentPageNumIsAdd:NO];
    }
    if (self.scrollView.contentOffset.x == self.frameWidth*2) {
        UIImage *showImg = self.imgViewRight.image;
        NSUInteger showIndex = [self.imgsArr indexOfObject:showImg];
        self.imgViewCenter.image = showImg;
        if (showIndex == 0) {
            self.imgViewLeft.image = self.imgsArr[self.imgsArr.count-1];
        }else{
            self.imgViewLeft.image = self.imgsArr[showIndex-1];
        }
        self.scrollView.contentOffset = CGPointMake(self.frameWidth, 0);
        if (showIndex+1 < self.imgsArr.count) {
            self.imgViewRight.image = self.imgsArr[showIndex+1];
        }else{
            self.imgViewRight.image = self.imgsArr[0];
        }
        [self changeCurrentPageNumIsAdd:YES];
    }
    //self.scrollView.contentOffset.x = self.frameWidth  说明并没有滑动，不做处理
    self.scrollView.scrollEnabled = YES;
}

- (void)changeCurrentPageNumIsAdd:(BOOL)isAdd{
    NSInteger currentPage = self.pageControl.currentPage;
    if (isAdd) {
        if (currentPage + 1 >= _imgsArr.count) {
            currentPage = 0;
        }else{
            currentPage = currentPage + 1;
        }
    }else{
        if (currentPage - 1 < 0) {
            currentPage = _imgsArr.count - 1;
        }else{
            currentPage = currentPage - 1;
        }
    }
    self.pageControl.currentPage = currentPage;
}

@end
