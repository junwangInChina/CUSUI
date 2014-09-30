//
//  UIColor+HexColor.h
//  CUSUI
//
//  Created by wangjun on 14-9-5.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  整合网上的颜色扩展
 *  支持通过十进制颜色字符串获取颜色
 *  支持通过颜色获取其互补色
 *  支持通过颜色获取其对应的十进制字符串
 */

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

/**
 *  通过一个十进制字符串，获取对应的颜色，透明度默认1
 *
 *  @param hexString 十进制字符串
 *
 *  @return 颜色
 */
- (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  通过一个十进制字符串，获取对应的颜色，透明度可设定
 *
 *  @param hexString 十进制字符串
 *  @param alpha     透明度
 *
 *  @return 颜色
 */
- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  通过一个颜色，获取它的互补色
 *
 *  @param color 颜色
 *
 *  @return 互补色
 */
- (UIColor *)colorWithComplementaryColor:(UIColor *)color;

/**
 *  通过一个颜色，获取它对应的十进制字符串
 *
 *  @param color 颜色
 *
 *  @return 十进制字符串
 */
- (NSString *)hexValuesWithColor:(UIColor *)color;

@end
