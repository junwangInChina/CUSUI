//
//  CUSPlistFileRefreshView.h
//  CUSUI
//
//  Created by wangjun on 14-11-13.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  新增一个下拉刷新的控件，该控件可由plist文件配置刷新时的图形
 *  使用时，若不传入plist文件，或者传入的plist文件不存在，会使用默认图形
 *  PS: IOS7上还有问题，暂时兼容IOS8
 *      要有导航
 *  self.refreshView = [[CUSPlistFileRefreshView alloc] initWithPlist:@""];
 *  _refreshView.delegate = self;
 *  _refreshView.lineColor = [UIColor redColor];
 *  _refreshView.zoomScale = 0.8;
 *  [_mainTable addSubview:_refreshView];
 *
 *  #pragma mark - UIScrollViewDelegate
 *  // 需要实现的ScrollView的滚动方法
 *  - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *  {
 *      [self.refreshView scrollViewDidScroll:scrollView];
 *  }
 *
 *  - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 *  {
 *      [self.refreshView scrollViewDidEndDragging:scrollView];
 *  }
 *
 *  // 下拉刷新的委托方法
 *  - (void)cusplistRefeshViewDidStarRefresh:(CUSPlistFileRefreshView *)view
 *  {
 *      NSLog(@"start loading");
 *
 *      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),   dispatch_get_main_queue(), ^{
 *          [self.refreshView refreshFinished];
 *          NSLog(@"end loading");
 *      });
 *  }
 */

#import <UIKit/UIKit.h>

#pragma mark - CUSPlistFileRefreshView

@protocol CUSPlistFileRefreshViewDelegate;

@interface CUSPlistFileRefreshView : UIView

/**
 *  下拉高度，下拉多少后，执行刷新方法   default:80pt
 */
@property (nonatomic, assign) CGFloat dropHeight;

/**
 *  线条颜色    default:[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  线条宽度    default:1.0pt
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  缩放比例    default:1.0
 */
@property (nonatomic, assign) CGFloat zoomScale;

/**
 *  水平随机离散数，用于动画    default:180
 */
@property (nonatomic, assign) int horizontalRandomness;

/**
 *  反向执行动画，用于动画开始结束时，动画执行顺序颠倒   default:YES
 */
@property (nonatomic, assign) BOOL reverseLoadingAnimation;

/**
 *  动画属性，用于控制动画效果   default:0.5
 */
@property (nonatomic, assign) CGFloat internalAnimationFactor;

/**
 *  委托方法
 */
@property (nonatomic, assign) id<CUSPlistFileRefreshViewDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param plist 传入Plist文件名，不传，或者传入的plist文件不存在时，有默认的图形
 *
 *  @return 返回该类的实例
 */
- (instancetype)initWithPlist:(NSString *)plist;

/**
 *  公共方法, UIScrollView滚动完成时调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 *  公共方法, UIScrollView拖动完成时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

/**
 *  公共方法, 刷新完成时调用
 */
- (void)refreshFinished;

@end

#pragma mark - CUSPlistFileRefreshViewDelegate
@protocol CUSPlistFileRefreshViewDelegate <NSObject>

/**
 *  委托方法，开始刷新
 *
 *  @param view 当前View
 */
- (void)cusplistRefeshViewDidStarRefresh:(CUSPlistFileRefreshView *)view;

@end

