//
//  CUSPulsingHaloLayer.h
//  CUSUI
//
//  Created by wangjun on 14-11-4.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  一款脉冲动画的Layer，有几个开放的属性，可以自由设置
 *
 *  添加
 *  CUSPulsingHaloLayer *haloLayer = [[CUSPulsingHaloLayer alloc] init];
 *  haloLayer.position = tpoint;
 *  haloLayer.animationRepeatCount = count;
 *  [self.view.layer addSublayer:haloLayer];
 *  [haloLayer beginAnimation];
 *
 *  移除
 *- (void)clearn
 *  {
 *      NSArray *sublayers = [self.view.layer.sublayers mutableCopy];
 *      for(CUSPulsingHaloLayer *obj in sublayers)
 *      {
 *          if([obj isKindOfClass:[CUSPulsingHaloLayer class]] && obj.superlayer == self.view.layer)
 *          {
 *              [obj stopAnimation];
 *              [obj removeFromSuperlayer];
 *          }
 *      }
 *  }
 */

#import <QuartzCore/QuartzCore.h>

@interface CUSPulsingHaloLayer : CALayer

/**
 *  脉冲半径大小  Default:30pt
 */
@property (nonatomic, assign) CGFloat radius;

/**
 *  动画执行时间  Default:0.5s
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 *  动画暂停时间  Default:0s
 */
@property (nonatomic, assign) NSTimeInterval pulseInterval;

/**
 *  动画重复次数  Default:0 表示无限次数
 */
@property (nonatomic, assign) NSInteger animationRepeatCount;

/**
 *  脉冲颜色  Default:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1]
 */
@property (nonatomic, assign) UIColor *pulsingHaloColor;

/**
 *  开始动画
 */
- (void)beginAnimation;

/**
 *  延迟开始动画，并指定延迟时间
 *
 *  @param delayTime 指定的延迟时间
 */
- (void)beginAnimationWithDelayTime:(NSTimeInterval)delayTime;

/**
 *  停止动画
 */
- (void)stopAnimation;

/**
 *  延迟停止动画，并指定延迟时间
 *
 *  @param delayTime 指定的延迟时间
 */
- (void)stopAnimationWithDelayTime:(NSTimeInterval)delayTime;


@end
