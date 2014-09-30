//
//  CUSToast.m
//  CUSUI
//
//  Created by wangjun on 14-7-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSToast.h"

#define DEVICE [[[UIDevice currentDevice] systemVersion] intValue]

#define IOS7   DEVICE > 7.0
#define IOS6   DEVICE > 6.0

#ifdef IOS6
#define UILINEBREAKMODEWORDWRAP NSLineBreakByWordWrapping
#else
#define UILINEBREAKMODEWORDWRAP UILineBreakModeWordWrap
#endif

#define TOAST_VIEW_TAG  10012358
#define TEXT_FONT [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define MAX_SIZE    CGSizeMake(260, 400)
#define TOAST_SIZE  CGSizeMake(28, 32)
#define SHADOW_SIZE CGSizeMake(2, 2)
#define MARGIN_TOP  16
#define MARGIN_LEFT 14
#define BACKGROUND_COLOR [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.6f]

@interface CUSToast()

@property (nonatomic, assign) CGFloat animationDurition;

@end

@implementation CUSToast
@synthesize animationDurition = _animationDurition;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.animationDurition = 1.0;
        self.tag = TOAST_VIEW_TAG;
    }
    return self;
}

- (void)clearSuperView
{
    UIWindow *rootView = [[UIApplication sharedApplication] keyWindow];
    UIView *toastView = [rootView viewWithTag:TOAST_VIEW_TAG];
    if (nil != toastView)
    {
        [toastView setHidden:TRUE];
        
        NSInteger subViewCount = [toastView.subviews count];
        while (subViewCount -- > 0)
        {
            UIView *subView = [toastView.subviews objectAtIndex:subViewCount];
            [subView removeFromSuperview];
        }
        [toastView removeFromSuperview];
    }
}

- (void)show:(NSString *)toastMessage
{
    [self clearSuperView];
    
    [self invalizeToastView:toastMessage andHeight:0];
    
    [self performSelector:@selector(beginAnimation:) withObject:nil afterDelay:self.animationDurition];
}

- (void)show:(NSString *)toastMessage andHeight:(CGFloat)height
{
    [self clearSuperView];
    
    [self invalizeToastView:toastMessage andHeight:height];
    
    [self performSelector:@selector(beginAnimation:) withObject:nil afterDelay:self.animationDurition];
}

- (void)show:(NSString *)toastMessage afterDaily:(CGFloat)time
{
    [self clearSuperView];
    
    [self invalizeToastView:toastMessage andHeight:0];
    
    [self performSelector:@selector(beginAnimation:) withObject:nil afterDelay:time];
}

- (void)invalizeToastView:(NSString *)message andHeight:(CGFloat)height
{
    UIWindow *rootView = [UIApplication sharedApplication].keyWindow;
    CGRect rect = rootView.screen.bounds;
    CGSize messageFrame = [message sizeWithFont:TEXT_FONT constrainedToSize:MAX_SIZE lineBreakMode:UILINEBREAKMODEWORDWRAP];
    CGSize size = TOAST_SIZE;
    messageFrame.width += size.width;
    messageFrame.height += size.height;
    
    if (height < 0 || height > rect.size.height)
    {
        height = 0;
    }
    
    self.frame = CGRectMake((rect.size.width - messageFrame.width) / 2.0,
                            height == 0 ? (rect.size.height - messageFrame.height) / 2.0 : height,
                            messageFrame.width,
                            messageFrame.height);
    self.layer.cornerRadius = 6.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowOffset = SHADOW_SIZE;
    self.backgroundColor = BACKGROUND_COLOR;
    
    UILabel *label_ = [[UILabel alloc] init];
    [label_ setFrame:CGRectMake(MARGIN_LEFT,
                                MARGIN_TOP,
                                messageFrame.width - 2*MARGIN_LEFT,
                                messageFrame.height - 2*MARGIN_TOP)];
    label_.textAlignment = UITextAlignmentCenter;
    label_.backgroundColor = [UIColor clearColor];
    label_.textColor = [UIColor whiteColor];
    label_.text = message;
    label_.font = TEXT_FONT;
    label_.lineBreakMode = UILineBreakModeWordWrap;
    label_.numberOfLines = 0;
    [self addSubview:label_];
    [label_ release];
    
    [rootView addSubview:self];
}

- (void)beginAnimation:(CGFloat)duration
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:self.alpha = 1.0 ? self.animationDurition : 0];
    self.alpha = self.alpha = 1.0 ? 0.0 : 1.0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismiss)];
    [UIView commitAnimations];
}

- (void)dismiss
{
    if (self.alpha != 1.0)
    {
        NSInteger viewCount = [self.subviews count];
        while (viewCount-->0)
        {
            UIView *currView = [self.subviews objectAtIndex:viewCount];
            [currView removeFromSuperview];
        }
        [self removeFromSuperview];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
