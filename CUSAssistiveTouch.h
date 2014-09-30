//
//  CUSAssistiveTouch.h
//  CUSUI
//
//  Created by wangjun on 14-9-30.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款类似苹果AssistiveTouch的控件
 *  支持悬浮按钮，点击事件由通知传出
 *  扩展了菜单功能，支持传入多个图标时，自动生成菜单
 *  增加了隐藏功能，可支持任意的展示隐藏
 *
 */

#import <Foundation/Foundation.h>

// 通知，传递点击事件
#define CUSASSISTIVETOUCHNOTIFICATION       @"CUSASSISTIVETOUCHNOTIFICATION"
#define TAP_INDEX                           @"button_tap_index"

typedef NS_ENUM(NSInteger, AssistiveTouchLocationType)
{
    AssistiveTouchLocationTop = 1,
    AssistiveTouchLocationLeft,
    AssistiveTouchLocationBottom,
    AssistiveTouchLocationRight
};

@interface CUSAssistiveTouch : NSObject

+ (CUSAssistiveTouch *)shareInstance;

/**
 *  展示功能，默认展示按钮，切默认黑色，移动时红色
 */
- (void)show;

/**
 *  展示功能，默认展示悬浮按钮，可配置按钮图片
 *
 *  @param images 图片数组，第一张为普通状态，第二张为移动状态
 */
- (void)showAssistiveTouch:(NSArray *)images;

/**
 *  扩展功能，展示悬浮菜单，将按钮扩展为一个菜单
 *
 *  @param menus 按钮数组，前两张默认为原始悬浮按钮的普通状态与移动状态
 */
- (void)showFloatMenu:(NSArray *)menus;

/**
 *  隐藏功能
 */
- (void)hidden;

@end
