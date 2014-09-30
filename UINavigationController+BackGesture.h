//
//  UINavigationController+BackGesture.h
//  CUSUI
//
//  Created by wangjun on 14-7-25.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  扩展了UINavigationController，增加滑动手势返回
 *  功能需手动开启设置   enableBackGesture
 *  且支持设置滑动临界值
 *
 *  新增方法，可以同时移动导航标题，但是需要用户自定义的TitleView
 *  UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
 *  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
 *  titleLabel.textAlignment = NSTextAlignmentCenter;
 *  titleLabel.text = [NSString stringWithFormat:@"Custom Title %lu",arc4random()%colors.count];
 *  [titleView addSubview:titleLabel];
 *  self.navigationItem.titleView = titleView;
 *  这种类型的Title，是可以一起移动的
 */

#import <UIKit/UIKit.h>

@interface UINavigationController (BackGesture)<UIGestureRecognizerDelegate>

/**
 *  设置滑动临界值，默认80
 *
 */
@property (nonatomic, assign) CGFloat slidingThreshold;

/**
 *  设置是否开启滑动返回功能，默认不开启
 *
 */
@property (nonatomic, assign) BOOL enableBackGesture;

@end
