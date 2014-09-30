//
//  CUSToast.h
//  CUSUI
//
//  Created by wangjun on 14-7-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的仿Android中Toast效果
 *  展示层高度动态计算。
 *  默认展示时间1秒，1秒后消失，消失时间为1秒，总计2秒
 *  支持展示时设定消失时间
 *  支持展示时，高度设定，默认居中
 *
 */

#import <UIKit/UIKit.h>

@interface CUSToast : UIView

/**
 *  展示Toast，默认时间2s，默认高度居中
 *
 *  @param  toastMessage: 需要展示的内容
 *  @return 无
 *
 */
- (void)show:(NSString *)toastMessage;

/**
 *  展示Toast，默认时间2s，高度自己设置（设置负值或超过屏幕范围的，会自己修改为0，置顶）
 *
 *  @param  toastMessage: 需要展示的内容
 *  @param  height      : 高度
 *  @return 无
 *
 */
- (void)show:(NSString *)toastMessage andHeight:(CGFloat)height;

/**
 *  展示Toast，自己设定展示时间，默认高度居中
 *
 *  @param  toastMessage: 需要展示的内容
 *  @param  time        : 展示时间
 *  @return 无
 *
 */
- (void)show:(NSString *)toastMessage afterDaily:(CGFloat)time;

@end
