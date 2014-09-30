//
//  UIView+Additions.h
//  CUSUI
//
//  Created by wangjun on 14-7-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  UIView的扩展
 *  可获取到当前的top、left、right、width、height等信息
 *  同样可以直接设置那些值，达到改变View位置or尺寸的目的
 *  
 *  PS:因为是类别，苹果自身存在bug。
 *  所以在引入此Framework的项目中，若需要使用到这个类别，必须在该项目的
 *  Other Link Flags 中加入 -Objc 、-all_load 两项
 */

#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property float left;
@property float right;
@property float top;
@property float bottom;
@property float width;
@property float height;
@property float centerX;
@property float centerY;

@end
