//
//  UIView+Additions.m
//  CUSUI
//
//  Created by wangjun on 14-7-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (float)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(float)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (float)right
{
    return (self.frame.origin.x + self.frame.size.width);
}

- (void)setRight:(float)right
{
    CGRect frame = self.frame;
    frame.origin.x = (right - self.frame.size.width);
    self.frame = frame;
}

- (float)top
{
    return self.frame.origin.y;
}

- (void)setTop:(float)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (float)bottom
{
    return (self.frame.origin.y + self.frame.size.height);
}

- (void)setBottom:(float)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = (bottom - self.frame.size.height);
    self.frame = frame;
}

- (float)width
{
    return self.frame.size.width;
}

- (void)setWidth:(float)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (float)height
{
    return self.frame.size.height;
}

- (void)setHeight:(float)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (float)centerX
{
    return (self.frame.origin.x + self.frame.size.width / 2.0);
}

- (void)setCenterX:(float)centerX
{
    CGRect frame = self.frame;
    frame.origin.x = (centerX - self.frame.size.width / 2.0);
    self.frame = frame;
}

- (float)centerY
{
    return (self.frame.origin.y + self.frame.size.height / 2.0);
}

- (void)setCenterY:(float)centerY
{
    CGRect frame = self.frame;
    frame.origin.y = (centerY - self.frame.size.height / 2.0);
    self.frame = frame;
}

@end
