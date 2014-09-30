//
//  CUSInfiniteLoopScrollView.m
//  CUSUI
//
//  Created by wangjun on 14-7-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSInfiniteLoopScrollView.h"

@interface CUSInfiniteLoopScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;       // 当前页
@property (nonatomic, assign) NSInteger totalPageCount;         // 总页数
@property (nonatomic, strong) NSMutableArray *contentViews;     // 总页面数组
@property (nonatomic, strong) UIScrollView *scrollView;         // 用于加载滚动页面的 ScrollView
@property (nonatomic, strong) UIPageControl *pageControl;       // 用于展示页面

@property (nonatomic, strong) NSTimer *animationTimer;          // 定时器，用于自动滚动
@property (nonatomic, assign) NSTimeInterval animationDuration; // 时间间隔，用于自动滚动

@end

@implementation CUSInfiniteLoopScrollView
@synthesize currentPageIndex = _currentPageIndex;
@synthesize totalPageCount = _totalPageCount;
@synthesize contentViews = _contentViews;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize animationTimer = _animationTimer;
@synthesize animationDuration = _animationDuration;

- (void)dealloc
{
    self.delegate = nil;
    self.datasource = nil;
    self.contentViews = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    if ([self.animationTimer isValid])
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = YES;
        self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        
        CGPoint pageCenter = CGPointMake(CGRectGetWidth(self.scrollView.frame) / 2.0, CGRectGetHeight(self.scrollView.frame) - 10);
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _pageControl.currentPage = 0;
        _pageControl.center = pageCenter;
        [self addSubview:_pageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (self)
    {
        if (animationDuration > 0)
        {
            self.animationDuration = animationDuration;
            
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                                                   target:self
                                                                 selector:@selector(scrollViewAutoRun:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            
            [self pauseTimer];
        }
    }
    return self;
}

- (void)setDatasource:(id<CUSInfiniteLoopScrollViewDataSource>)datasource
{
    _datasource = datasource;
    
    [self reloadData];
}

- (void)reloadData
{
    self.totalPageCount = [_datasource numberOfPagesInCUSInfiniteLoopScrollView];
    self.pageControl.numberOfPages = self.totalPageCount;
    
    if (_totalPageCount <= 0)
    {
        return;
    }
    
    [self configAutoScrollViews];
    
    [self resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)hiddenNativePageControl
{
    self.pageControl.hidden = YES;
}

// 重载滚动视图
- (void)configAutoScrollViews
{
    // 移除所有子视图
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 重载数据源
    [self setAutoRunScrollViewsDatasource];
    
    for (int i = 0; i<self.contentViews.count; i++)
    {
        UIView *autoView = [self.contentViews objectAtIndex:i];
        autoView.userInteractionEnabled = YES;
        CGRect autoFrame = autoView.frame;
        autoFrame.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame)*i, 0);
        autoView.frame = autoFrame;
        autoView.tag = 1000+i;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoRunScrollViewTap:)];
        [autoView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        [self.scrollView addSubview:autoView];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
}

// 设置数据源，即需要滚动的视图
- (void)setAutoRunScrollViewsDatasource
{
    NSInteger previousPageIndex = [self getPreviousAndNextPageIndex:self.currentPageIndex - 1];
    NSInteger nextPageIndex = [self getPreviousAndNextPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil)
    {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.datasource)
    {
        [self.contentViews addObject:[self.datasource pageForIndexInCUSInfiniteLoopScrollView:previousPageIndex]];
        [self.contentViews addObject:[self.datasource pageForIndexInCUSInfiniteLoopScrollView:self.currentPageIndex]];
        [self.contentViews addObject:[self.datasource pageForIndexInCUSInfiniteLoopScrollView:nextPageIndex]];
    }
}

// 根据当前页，获取上一页、下一页下标，由于可循环，故不能单纯的加一减一
- (NSInteger)getPreviousAndNextPageIndex:(NSInteger)currentIndex
{
    if (currentIndex == -1)
    {
        return self.totalPageCount - 1;
    }
    else if (currentIndex == self.totalPageCount)
    {
        return 0;
    }
    else
    {
        return currentIndex;
    }
}

#pragma mark - NSTimer Control
- (void)clearTimer
{
    if ([self.animationTimer isValid])
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

- (void)pauseTimer
{
    if (![self.animationTimer isValid])
    {
        return;
    }
    [self.animationTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer
{
    if (![self.animationTimer isValid])
    {
        return;
    }
    [self.animationTimer setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self.animationTimer isValid])
    {
        return;
    }
    [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

#pragma mark - UIScrollView Delegate
// 手放上去，准备开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseTimer];
}

// 拖动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self resumeTimerAfterTimeInterval:self.animationDuration];
}

// 滑动减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int realOffsetX = scrollView.contentOffset.x;
    if (realOffsetX >= 2 * CGRectGetWidth(self.scrollView.frame))
    {
        self.currentPageIndex = [self getPreviousAndNextPageIndex:self.currentPageIndex + 1];
        
        [self configAutoScrollViews];
    }
    if (realOffsetX <= 0)
    {
        self.currentPageIndex = [self getPreviousAndNextPageIndex:self.currentPageIndex - 1];
        
        [self configAutoScrollViews];
    }
    [self.pageControl setCurrentPage:self.currentPageIndex];
}

#pragma mark -  Response Events
// 定时器自动滚动
- (void)scrollViewAutoRun:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    
    [self.scrollView setContentOffset:newOffset animated:YES];
    
    [self.pageControl setCurrentPage:self.currentPageIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cusInfiniteLoopScrollViewDidScroll:andCurrentPage:)])
    {
        [self.delegate cusInfiniteLoopScrollViewDidScroll:self andCurrentPage:self.currentPageIndex];
    }
}

// 点击触发委托方法
- (void)autoRunScrollViewTap:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cusInfiniteLoopScrollViewDidSelect:andTapIndex:)])
    {
        [self.delegate cusInfiniteLoopScrollViewDidSelect:self andTapIndex:self.currentPageIndex];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
