//
//  CUSTouchScrollView.m
//  CUSUI
//
//  Created by wangjun on 14-7-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSTouchScrollView.h"

@implementation CUSTouchScrollView
@synthesize touchDelegate = _touchDelegate;

- (void)dealloc
{
    self.touchDelegate = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [self.nextResponder touchesEnded:touches withEvent:event];
        
        if (self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(scrollViewTouchsEnded:withEvent:witchView:)])
        {
            [self.touchDelegate scrollViewTouchsEnded:touches withEvent:event witchView:self];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

@end
