//
//  CUSZoomView.h
//  CUSUI
//
//  Created by wangjun on 14-12-17.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款放大镜的应用
 *
 *  CUSZoomView *zoomView = [[CUSZoomView alloc] init];
 *  zoomView.frame = CGRectMake(10, 20, 150, 150);
 *  [zoomView setZoomScale:2.5];
 *  [zoomView setDragingEnable:YES];
 *  [self.view addSubview:zoomView];
 */

#import <UIKit/UIKit.h>

@interface CUSZoomView : UIView

/**
 *  设置放大倍数  默认2.0
 */
@property (nonatomic, assign) CGFloat zoomScale;

/**
 *  设置是否允许拖动，默认YES
 */
@property (nonatomic, assign) BOOL dragingEnable;

@end
