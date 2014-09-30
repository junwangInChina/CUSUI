//
//  UINavigationController+BackGesture.m
//  CUSUI
//
//  Created by wangjun on 14-7-25.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "UINavigationController+BackGesture.h"
#import <objc/runtime.h>
#import "UIView+Additions.h"

static const char *sliderKey = "slidingThreshold";
static const char *enableKey = "EnableBackGesture";
static const char *backGestureKey = "PanGestureRecognizer";
static const char *startPointKey = "StartPanGestureTouchPoint";

@implementation UINavigationController (BackGesture)

- (CGFloat)slidingThreshold
{
    // 获取被绑定的滑动临界值
    NSNumber *sliderNumber = objc_getAssociatedObject(self, sliderKey);
    if (sliderNumber)
    {
        return [sliderNumber floatValue];
    }
    return 80;
}

- (void)setSlidingThreshold:(CGFloat)slidingThreshold
{
    NSNumber *sliderNumber = [NSNumber numberWithFloat:slidingThreshold];
    
    // 绑定操作
    objc_setAssociatedObject(self, sliderKey, sliderNumber, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)enableBackGesture
{
    NSNumber *enableNumber = objc_getAssociatedObject(self, enableKey);
    if (enableNumber)
    {
        return [enableNumber boolValue];
    }
    return NO;
}

// 开启or关闭滑动手势
- (void)setEnableBackGesture:(BOOL)enableBackGesture
{
    NSNumber *enableNumber = [NSNumber numberWithBool:enableBackGesture];
    
    // 绑定是否允许手势返回操作
    objc_setAssociatedObject(self, enableKey, enableNumber, OBJC_ASSOCIATION_RETAIN);
    
    if (enableBackGesture)
    {
        [self.view addGestureRecognizer:[self backPanGesture]];
    }
    else
    {
        [self.view removeGestureRecognizer:[self backPanGesture]];
    }
}

// 获取滑动手势
- (UIPanGestureRecognizer *)backPanGesture
{
    // 获取被绑定的返回手势
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, backGestureKey);
    // 不存在，则创建
    if (!panGesture)
    {
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureToBack:)];
        panGesture.delegate = self;
        
        // 创建好了之后，直接绑定
        objc_setAssociatedObject(self, backGestureKey, panGesture, OBJC_ASSOCIATION_RETAIN);
    }
    return panGesture;
}

// 绑定滑动初始point值
- (void)setStartPanGesturePoint:(CGPoint)point
{
    NSValue *startValue = [NSValue valueWithCGPoint:point];
    
    // 将开始滑动的point值，绑定到当前页
    objc_setAssociatedObject(self, startPointKey, startValue, OBJC_ASSOCIATION_RETAIN);
}

// 获取被绑定的滑动初始值
- (CGPoint)startPanGesturePoint
{
    // 获取到绑定到当前页上的开始滑动point
    NSValue *startValue = objc_getAssociatedObject(self, startPointKey);
    if (!startValue)
    {
        return CGPointZero;
    }
    return [startValue CGPointValue];
}

// 开始滑动
- (void)panGestureToBack:(UIPanGestureRecognizer *)panGesture
{
    UIView *currentView = self.topViewController.view;
    if ([self backPanGesture].state == UIGestureRecognizerStateBegan)
    {
        [self setStartPanGesturePoint:currentView.frame.origin];
        CGPoint velocity = [panGesture velocityInView:self.view];
        if (velocity.x != 0)
        {
            [self willShowPreviousViewController];
            
            return;
        }
    }
    CGPoint currentPosition = [panGesture translationInView:self.view];
    CGFloat xOffSet = [self startPanGesturePoint].x + currentPosition.x;
    CGFloat yOffSet = [self startPanGesturePoint].y + currentPosition.y;
    
    // 从左向右划，不处理
    if (xOffSet > 0)
    {
        
    }
    // 从右向左划
    else
    {
        if (currentView.frame.origin.x > 0)
        {
            xOffSet = xOffSet < -self.view.frame.size.width ? -self.view.frame.size.width:xOffSet;
        }
        else
        {
            xOffSet = 0;
        }
    }
    
    if (!CGPointEqualToPoint(CGPointMake(xOffSet, yOffSet), currentView.frame.origin))
    {
        [self layoutCurrentViewWithOffset:UIOffsetMake(xOffSet, yOffSet)];
        [self layoutCurrentNavigationWithOffset:UIOffsetMake(xOffSet, yOffSet)];
    }
    
    // 滑动结束，放开手势时
    if ([self backPanGesture].state == UIGestureRecognizerStateEnded)
    {
        if (currentView.frame.origin.x == 0)
        {
            
        }
        else
        {
            // 滑动未超过临界值，放弃继续滑动，还原
            if (currentView.frame.origin.x < [self slidingThreshold])
            {
                [self cancelShowPreviousViewController];
            }
            // 滑动超过临界值，自动滑动结束，退到前一页
            else
            {
                [self showPreviousViewController];
            }
        }
    }
        
}

/**
 *  将要展示前一页
 *  将前一页的View插入到当前页的View下面
 *
 */
- (void)willShowPreviousViewController
{
    NSInteger counts = self.viewControllers.count;
    if (counts > 1)
    {
        UIViewController *currentController = [self topViewController];
        UIViewController *previousController = [self.viewControllers objectAtIndex:(counts - 2)];
        
        [currentController.view.superview insertSubview:previousController.view belowSubview:currentController.view];
        
        [currentController.navigationItem.titleView.superview insertSubview:previousController.navigationItem.titleView belowSubview:currentController.navigationItem.titleView];
    }
}

/**
 *  取消展示前一页
 *  滑动一点点，然后放手，放弃返回前一页
 *  此时需要将willShowPreviousViewController方法里准备好的前一页View移除
 *
 */
- (void)cancelShowPreviousViewController
{
    NSInteger counts = self.viewControllers.count;
    if (counts > 1)
    {
        UIView *currentView = [[self topViewController] view];
        UIViewController *previousController = [self.viewControllers objectAtIndex:(counts - 2)];
        NSTimeInterval animatedTime = 0;
        animatedTime = ABS(self.view.frame.size.width - currentView.frame.origin.x) / self.view.frame.size.width * 0.35;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:animatedTime animations:^{
            [self layoutCurrentViewWithOffset:UIOffsetMake(0, 0)];
            [self layoutCurrentNavigationWithOffset:UIOffsetMake(0, 0)];
        } completion:^(BOOL finished) {
            [previousController.view removeFromSuperview];
            [previousController.navigationItem.titleView removeFromSuperview];
        }];
    }
}

/**
 *  展示前一页
 *  实际实现方式是在当前Controller上，在当前View下面，插入一层上一页的View
 *  然后向左滑动时，两层View开始移动
 *  移动完成后，还是利用导航的pop方法，退到前一页
 */
- (void)showPreviousViewController
{
    NSInteger counts = self.viewControllers.count;
    if (counts > 1)
    {
        UIView *currentView = [[self topViewController] view];
        NSTimeInterval animatedTime = 0;
        animatedTime = ABS(self.view.frame.size.width - currentView.frame.origin.x) / self.view.frame.size.width * 0.35;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:animatedTime animations:^{
            [self layoutCurrentViewWithOffset:UIOffsetMake(self.view.frame.size.width, 0)];
            [self layoutCurrentNavigationWithOffset:UIOffsetMake(self.view.frame.size.width, 0)];
        } completion:^(BOOL finished) {
            [self popViewControllerAnimated:false];
        }];
    }
}

/**
 *  刷新View的位置
 *  通过手势滑动偏移量，不断的刷新两层View的位置，造成视差滑动的效果
 *
 */
- (void)layoutCurrentViewWithOffset:(UIOffset)offset
{
    NSInteger counts = self.viewControllers.count;
    if (counts > 1)
    {
        UIViewController *currentController = [self topViewController];
        UIViewController *previousController = [self.viewControllers objectAtIndex:(counts - 2)];
        
        // 修改快速向左划，然后放手，页面右边出现白条的bug。
        offset.horizontal = offset.horizontal > 0 ? offset.horizontal : 0;
        
        [currentController.view setFrame:CGRectMake(offset.horizontal,
                                                    self.view.bounds.origin.y,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height)];
        [previousController.view setFrame:CGRectMake(offset.horizontal/2-self.view.frame.size.width/2,
                                                     self.view.bounds.origin.y,
                                                     self.view.frame.size.width,
                                                     self.view.frame.size.height)];
    }
}

/**
 *  通过View滑动偏移量，改变导航的移动、透明度，形成导航也一起移动的效果
 *
 *  @param offset 偏移量
 */
- (void)layoutCurrentNavigationWithOffset:(UIOffset)offset
{
    NSInteger counts = self.viewControllers.count;
    if (counts > 1)
    {
        UIViewController *currentController = [self topViewController];
        UIViewController *previousController = [self.viewControllers objectAtIndex:(counts - 2)];
        
        // 修改快速向左划，然后放手，页面右边出现白条的bug。
        offset.horizontal = offset.horizontal > 0 ? offset.horizontal : 0;
        
        CGFloat moveProportion = offset.horizontal / 320;
        CGFloat defaultProportion = self.slidingThreshold / 320;
        
        currentController.navigationItem.titleView.alpha = offset.horizontal == 0 ? 1 : (1 - defaultProportion - moveProportion);
        previousController.navigationItem.titleView.alpha = offset.horizontal == 0 ? 0 : (moveProportion + defaultProportion * 0.3);
        
        CGFloat previoustitleOffset = moveProportion * (self.view.width / 2.0 - 77);
        CGFloat currentTitleOffset = moveProportion * self.view.width / 2.0;
        
        currentController.navigationItem.titleView.centerX = offset.horizontal == 0 ? self.view.width / 2.0 : self.view.width / 2.0 + currentTitleOffset;
        previousController.navigationItem.titleView.centerX = offset.horizontal == 0 ? self.view.width / 2.0 : 77 + previoustitleOffset;
        
    }
}

@end
