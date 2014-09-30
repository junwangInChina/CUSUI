//
//  CUSInfiniteLoopScrollView.h
//  CUSUI
//
//  Created by wangjun on 14-7-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  自定义的一款无限循环的ScrollView
 *  支持定时器自动滚动与手动滑动
 *  支持设定定时器自动滚动时间
 *  封装原生的PageControl，指示页数
 *  支持封装的原生PageControl，方便用户定制
 *
 *  使用方法与表格类似，分Delegate与Datasource
 */

#import <UIKit/UIKit.h>

@protocol CUSInfiniteLoopScrollViewDelegate;
@protocol CUSInfiniteLoopScrollViewDataSource;

@interface CUSInfiniteLoopScrollView : UIView

@property (nonatomic, assign, setter = setDelegate:) id <CUSInfiniteLoopScrollViewDelegate> delegate;
@property (nonatomic, assign, setter = setDataSource:) id <CUSInfiniteLoopScrollViewDataSource> datasource;

/**
 *  初始化方法
 *
 *  @param  frame               尺寸
 *  @param  animationDuration   自动滚动时间间隔，若设置 <= 0，则不自动滚动
 *
 *  @return 当前实例
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
            animationDuration:(NSTimeInterval)animationDuration;

/**
 *  重载方法,刷新页面
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)reloadData;

/**
 *  移除定时器
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)clearTimer;

/**
 *  隐藏自带的PageControl，方便用户定制
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)hiddenNativePageControl;

@end

@protocol CUSInfiniteLoopScrollViewDelegate <NSObject>

@optional
/**
 *  无限循环自动滚动，选中的委托方法，非必须实现
 *
 *  @param  view    当前滚动视图对象
 *  @param  index   点击的视图下标，也就是第几张图
 *  @return 无
 *
 */
- (void)cusInfiniteLoopScrollViewDidSelect:(CUSInfiniteLoopScrollView *)view
                               andTapIndex:(NSInteger)index;

/**
 *  无限循环自动滚动，滚动完成的委托方法，非必须实现
 *
 *  @param  view    当前滚动视图对象
 *  @param  index   当前滚动到第几页
 *  @return 无
 *
 */
- (void)cusInfiniteLoopScrollViewDidScroll:(CUSInfiniteLoopScrollView *)view
                            andCurrentPage:(NSInteger)index;

@end

@protocol CUSInfiniteLoopScrollViewDataSource <NSObject>

@required
/**
 *  无限循环自动滚动，数据源方法，获取当前滚动视图有几页，必须实现
 *
 *  @param  无
 *  @return 返回当前滚动视图有几页
 *
 */
- (NSInteger)numberOfPagesInCUSInfiniteLoopScrollView;

/**
 *  无限循环自动滚动，数据源方法，获取当前页，必须实现
 *
 *  @param  index   需要展示的页面
 *  @return 返回传入 index 下的页面
 *
 */
- (UIView *)pageForIndexInCUSInfiniteLoopScrollView:(NSInteger)index;


@end
