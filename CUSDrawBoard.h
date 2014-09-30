//
//  CUSDrawBoard.h
//  CUSUI
//
//  Created by wangjun on 14-9-18.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款简单的画板工具
 *  提供删除、撤销删除、绘图保存方法
 *  支持设置画布功能
 *
 */

#import <UIKit/UIKit.h>

@interface CUSDrawBoard : UIView

/**
 *  线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  删除
 */
- (void)backImage;

/**
 *  撤销删除
 */
- (void)forwardImage;

/**
 *  保存图片
 *
 *  @return 返回一张图
 */
- (UIImage *)saveImage;

/**
 *  设置画布，也就是底图
 *
 *  @param image 设置的画布图片
 */
- (void)setCanvas:(UIImage *)image;

@end
