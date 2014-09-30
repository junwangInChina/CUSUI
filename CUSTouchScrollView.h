//
//  CUSTouchScrollView.h
//  CUSUI
//
//  Created by wangjun on 14-7-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的UIScrollView，继承于UIScrollView
 *  当用户底层视图需要允许滑动，此时使用UIScrollView的话，上层视图的Touch事件会被UIScrollView捕获
 *  故需要定制，将捕获到的Touch事件传递下去
 */

#import <UIKit/UIKit.h>

@protocol CUSTouchScrollViewDelegate;

@interface CUSTouchScrollView : UIScrollView

@property (nonatomic, assign) id <CUSTouchScrollViewDelegate> touchDelegate;

@end

@protocol CUSTouchScrollViewDelegate <NSObject>

/**
 *  定制的ScrollView的传递Touch事件的委托方法
 *
 *  @param  touches
 *  @param  event
 *  @param  scrollView
 *  @return 无
 *
 */
- (void)scrollViewTouchsEnded:(NSSet *)touches
                    withEvent:(UIEvent *)event
                    witchView:(id)scrollView;

@end
