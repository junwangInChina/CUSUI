//
//  UILabel+Attribute.h
//  CUSUI
//
//  Created by wangjun on 14-7-15.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  UILabel的扩展
 *  扩展了Label的一些属性，行间距、段落间距、字符间距、下划线、删除线。。。等扩展
 *  为了避免越界，只能在Label先设置好Text后，再设置以下属性，才有作用
 *  否则不起作用
 *  重写setText: 方法可解决问题，但是会影响其他，所以未重写。
 *
 *  PS:因为是类别，苹果自身存在bug。
 *  所以在引入此Framework的项目中，若需要使用到这个类别，必须在该项目的
 *  Other Link Flags 中加入 -Objc 、-all_load 两项
 */

#import <UIKit/UIKit.h>

@interface UILabel (Attribute)

/**
 *  UILabel类别，文案展示扩展方法。设置行间距
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的行间距
 *  @return 无
 *
 */
- (void)setLineSpacing:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置首行缩进
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的首行缩进值
 *  @return 无
 *
 */
- (void)setFirstLineHeadIndent:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置整体文案缩进
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的整体文案缩进值
 *  @return 无
 *
 */
- (void)setHeadIndent:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置段尾缩进，实际效果时设置整个文案显示的宽度
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的段尾缩进值
 *  @return 无
 *
 */
- (void)setTailIndent:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置最大行高
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的最大行高的值
 *  @return 无
 *
 */
- (void)setMaximumLineHeight:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置最小行高
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的最小行高的值
 *  @return 无
 *
 */
- (void)setMinimumLineHeight:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置多行高(可变行高,乘因数。暂时还不懂与设置行高有什么区别)
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的多行高的值
 *  @return 无
 *
 */
- (void)setLineHeightMultiple:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置段落间距
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的段落间距
 *  @return 无
 *
 */
- (void)setParagraphSpacing:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置段首空间(感觉应该是每一段的首行缩进)
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要设置的段首空间的值
 *  @return 无
 *
 */
- (void)setParagraphSpacingBefore:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。设置文案书写方向
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  writeDirection:需要设置的文案的书写方向
 *  @return 无
 *
 */
- (void)setWritingDirection:(NSWritingDirection)writeDirection;

/**
 *  UILabel类别，文案展示扩展方法。添加下划线，默认全部文案添加
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)addUnderLine;

/**
 *  UILabel类别，文案展示扩展方法。添加下划线，根据传入的范围添加
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  range:需要添加下划线的范围
 *  @return 无
 *
 */
- (void)addUnderLineWithRange:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。添加删除线，默认全部文案添加
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)addDeleteLine;

/**
 *  UILabel类别，文案展示扩展方法。添加删除线，根据传入的范围添加
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  range:需要添加删除线的范围
 *  @return 无
 *
 */
- (void)addDeleteLineWithRange:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。修改字体颜色，根据传入的范围添加（用于不同颜色文案展示在同一Label上）
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  color:需要改变的颜色
 *  @param  range:需要修改文案颜色的范围
 *  @return 无
 *
 */
- (void)changeCharacterColor:(UIColor *)color range:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。修改背景颜色，根据传入的范围添加（用于不同颜色文案展示在同一Label上）
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  color:需要改变的颜色
 *  @param  range:需要修改背景颜色的范围
 *  @return 无
 *
 */
- (void)changeBackgroundColor:(UIColor *)color range:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。修改字符字体，根据传入的范围修改。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  font :需要改变的字体
 *  @param  range:需要修改间距的范围
 *  @return 无
 *
 */
- (void)changeCharacterFont:(UIFont *)font range:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。修改字符间距。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要改变的间距
 *  @return 无
 *
 */
- (void)changeCharacterSpacing:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。修改字符间距，根据传入的范围修改。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要改变的间距
 *  @param  range:需要修改间距的范围
 *  @return 无
 *
 */
- (void)changeCharacterSpacing:(CGFloat)space range:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。修改字体为空心，默认修改全部文案为空心字。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要改变的程度
 *  @return 无
 *
 */
- (void)changeCharacterHollow:(CGFloat)space;

/**
 *  UILabel类别，文案展示扩展方法。修改字体为空心，同时修改颜色。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要改变的程度
 *  @param  color:要修改的颜色
 *  @return 无
 *
 */
- (void)changeCharacterHollow:(CGFloat)space color:(UIColor *)color;

/**
 *  UILabel类别，文案展示扩展方法。修改字体为空心，根据传入的范围修改。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要改变的程度
 *  @param  range:需要修改空心的范围
 *  @return 无
 *
 */
- (void)changeCharacterHollow:(CGFloat)space range:(NSRange)range;

/**
 *  UILabel类别，文案展示扩展方法。修改字体为空心，同时修改颜色，根据传入的范围修改。
 *  PS:前提条件是明确知道当前Label的Text
 *
 *  @param  space:需要改变的程度
 *  @param  range:需要修改空心的范围
 *  @param  color:要修改的颜色
 *  @return 无
 *
 */
- (void)changeCharacterHollow:(CGFloat)space range:(NSRange)range color:(UIColor *)color;



@end
