//
//  CUSBasePopupViewController.h
//  CUSUI
//
//  Created by wangjun on 14-7-14.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  UIViewController的子类
 *  用于定制UIAlertView UIActionSheet等弹出框
 *
 *  PS:弹出时，实际是在当前Windows上增加子类的Controller的方式实现的
 */

#import <UIKit/UIKit.h>

@interface CUSBasePopupViewController : UIViewController

/**
 *  创建内容层，用于子类重写该方法，以便定制每个子类需要展示的内容
 *
 *  @param  无
 *  @return 返回子类需要展示的内容 View
 *
 */
- (UIView *)createContentView;

/**
 *  设置PopupView中心点，用于子类定制，默认在屏幕中间
 *
 *  @param  无
 *  @return 返回子类需要展示的中心点坐标
 *
 */
- (CGPoint)popupViewCenter;

/**
 *  设置弧度
 *
 *  @param  无
 *  @return 返回弧度值
 *
 */
- (CGFloat)cornerRadius;

/**
 *  展示方法
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)show;

/**
 *  关闭方法
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)dismiss;

@end
