//
//  CUSZoomView.m
//  CUSUI
//
//  Created by wangjun on 14-12-17.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSZoomView.h"
#import <QuartzCore/QuartzCore.h>

@interface CUSZoomView()

// 原视图
@property (nonatomic, strong) UIView *parentView;

@end

@implementation CUSZoomView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    self.zoomScale = 2.0;
    self.dragingEnable = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMove:)];
    [self addGestureRecognizer:panGesture];
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    
    [self setNeedsDisplay];
}

- (void)setDragingEnable:(BOOL)dragingEnable
{
    _dragingEnable = dragingEnable;
    self.userInteractionEnabled = dragingEnable;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    _parentView = newSuperview;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, (self.frame.size.width / 2), (self.frame.size.height / 2));
    CGContextScaleCTM(context, _zoomScale, _zoomScale);
    CGContextTranslateCTM(context,
                          (-(self.frame.origin.x) - (self.frame.size.width / 2)),
                          (-(self.frame.origin.y) - (self.frame.size.height)));
    [self setHidden:YES];
    
    [_parentView.layer.superlayer renderInContext:context];
    
    [self setHidden:NO];
}

- (void)panMove:(UIPanGestureRecognizer *)panGesture
{
    // 移动中
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint moveCenter = panGesture.view.center;
        CGPoint translation = [panGesture translationInView:panGesture.view];
        moveCenter = CGPointMake(moveCenter.x + translation.x, moveCenter.y + translation.y);
        panGesture.view.center = moveCenter;
        [panGesture setTranslation:CGPointZero inView:panGesture.view];
        [self setNeedsDisplay];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
