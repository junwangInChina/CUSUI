//
//  CUSPulsingHaloLayer.m
//  CUSUI
//
//  Created by wangjun on 14-11-4.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUSPulsingHaloLayer.h"

#define kAnimationKey   @"CUSPulsingHaloLayerAnimation"

@interface CUSPulsingHaloLayer()

@property (nonatomic, strong) CAAnimationGroup *animationGruop;

@end

@implementation CUSPulsingHaloLayer

- (void)dealloc
{
    [self removeAnimationForKey:kAnimationKey];
    self.pulsingHaloColor = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        self.radius = 30;
        self.animationDuration = 0.5;
        self.pulseInterval = 0.0;
        self.animationRepeatCount = 0;
        self.pulsingHaloColor = [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1];
    }
    return self;
}

#pragma mark - Public Method

- (void)setRadius:(CGFloat)radius
{
    if (radius)
    {
        _radius = radius;
        
        CGPoint tempPos = self.position;
        CGFloat diameter = self.radius * 2;
        
        self.bounds = CGRectMake(0, 0, diameter, diameter);
        self.cornerRadius = self.radius;
        self.position = tempPos;
    }
}

- (void)setPulsingHaloColor:(UIColor *)pulsingHaloColor
{
    if (pulsingHaloColor)
    {
        _pulsingHaloColor = pulsingHaloColor;
        
        self.backgroundColor = pulsingHaloColor.CGColor;
    }
}

- (void)beginAnimation
{
    if (!self.animationGruop)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self createAnimationGroup];
            
            if (self.pulseInterval != INFINITY)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self addAnimation:self.animationGruop forKey:kAnimationKey];
                });
            }
        });
    }
    else
    {
        if (self.pulseInterval != INFINITY)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self addAnimation:self.animationGruop forKey:kAnimationKey];
            });
        }
    }
}

- (void)beginAnimationWithDelayTime:(NSTimeInterval)delayTime
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginAnimation];
    });
}

- (void)stopAnimation
{
    // 移除所有动画
    [self removeAllAnimations];
    
    // 取消执行延迟函数
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginAnimation) object:nil];
}

- (void)stopAnimationWithDelayTime:(NSTimeInterval)delayTime
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimation];
    });
}

#pragma mark - Private Method

- (void)createAnimationGroup
{
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGruop = [CAAnimationGroup animation];
    _animationGruop.duration = self.animationDuration + self.pulseInterval;
    _animationGruop.repeatCount = self.animationRepeatCount > 0 ? self.animationRepeatCount : INFINITY;
    _animationGruop.removedOnCompletion = NO;
    _animationGruop.timingFunction = defaultCurve;
    _animationGruop.delegate = self;
    
    //关键帧动画 放大
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.duration = self.animationDuration;
    scaleAnimation.values = @[@0.9, @1.2, @1.5];
    scaleAnimation.keyTimes = @[@0, @0.5, @1];
    scaleAnimation.removedOnCompletion = NO;
    
    //关键帧动画 透明度和时间复合
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@1, @0.8,@0.6,@0.4,@0.2, @0];
    opacityAnimation.keyTimes = @[@0, @0.2, @0.4,@0.6,@0.8,@1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGruop.animations = animations;
    
    [self setNeedsDisplay];
}

#pragma mark - CAAnimationGroup Delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        [self removeAnimationForKey:kAnimationKey];
        [self removeFromSuperlayer];
    }
}


@end
