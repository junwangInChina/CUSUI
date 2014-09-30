//
//  CUSShineLabel.h
//  CUSUI
//
//  Created by wangjun on 14-8-4.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的UILabel，实现了文案的渐入渐出效果
 *  支持分别设置渐入、渐出的动画执行时间，默认2.5s，建议两个时间保持一致
 *  支持设置添加到试图上时，自动执行渐入效果，默认不自动执行。
 *
 *  实现方法
 *  1：设置文案后，调用[self shine]方法
 *  if (self.shineLabel.visible)
 *  {
 *      [self.shineLabel fadeOutWithComplete:^{
 *          self.shineLabel.text = self.textArray[(++self.textIndex) % self.textArray.count];
 *          [self.shineLabel shine];
 *      }];
 *  }
 *  else
 *  {
 *      [self.shineLabel shine];
 *  }
 *
 *  2：使用封装的 changeShineText: 方法
 *  [self.shineLabel changeShineText:self.textArray[(++self.textIndex) % self.textArray.count]];
 */

#import <UIKit/UIKit.h>

@interface CUSShineLabel : UILabel

/**
 *  Label文案闪耀展示动画执行时间
 *  默认 2.5s
 */
@property (nonatomic, readwrite, assign) NSTimeInterval shineDuration;

/**
 *  Label文案隐藏动画执行时间
 *  默认 2.5s
 */
@property (nonatomic, readwrite, assign) NSTimeInterval fadeDuration;

/**
 *  Label设置是否自动闪耀
 *  默认为 NO，需要手动调用shine方法。
 */
@property (nonatomic, readwrite, assign) BOOL autoShine;

/**
 *  当前Label文案是否正在闪耀
 */
@property (nonatomic, readonly, assign, getter = isShining) BOOL shining;

/**
 *  当前Label文案闪耀功能是否可用
 */
@property (nonatomic, readonly, assign, getter = isVisible) BOOL visible;

/**
 *  开始闪耀，一般赋值后，手动调用
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)shine;

/**
 *  开始闪耀，一般赋值后，手动调用
 *
 *  @param  complete: 用于回掉，闪耀完成后
 *  @return 无
 *
 */
- (void)shineWithComplete:(void(^)())complete;

/**
 *  停止闪耀，一般开始闪耀后，手动调用
 *
 *  @param  无
 *  @return 无
 *
 */
- (void)fadeOut;

/**
 *  停止闪耀，一般开始闪耀后，手动调用
 *
 *  @param  complete: 用于回掉，停止闪耀完成后
 *  @return 无
 *
 */
- (void)fadeOutWithComplete:(void(^)())complete;

/**
 *  封装了文案变更，Label文案消失展示的方法
 *
 *  @param  shineText: 变更的文案
 *  @return 无
 *
 */
- (void)changeShineText:(NSString *)shineText;

@end
