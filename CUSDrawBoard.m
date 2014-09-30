//
//  CUSDrawBoard.m
//  CUSUI
//
//  Created by wangjun on 14-9-18.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSDrawBoard.h"

@interface CUSDrawBoard()

/**
 *  线
 */
@property (nonatomic, strong) UIBezierPath *bezierPath;

/**
 *  所有操作步骤
 */
@property (nonatomic, strong) NSMutableArray *allLineArray;

/**
 *  删除的所有操作
 */
@property (nonatomic, strong) NSMutableArray *cancelArray;

@end

@implementation CUSDrawBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.lineColor = [UIColor redColor];
        self.lineWidth = 1;
        self.allLineArray = [NSMutableArray arrayWithCapacity:50];
        self.cancelArray = [NSMutableArray arrayWithCapacity:50];
    }
    return self;
}

- (void)backImage
{
    if (self.allLineArray.count > 0)
    {
        NSInteger index = [self.allLineArray count] - 1;
        
        [self.cancelArray addObject:self.allLineArray[index]];
        
        [self.allLineArray removeObjectAtIndex:index];
        
        [self setNeedsDisplay];
    }
}

- (void)forwardImage
{
    if (self.cancelArray.count > 0)
    {
        NSInteger index = [self.cancelArray count] - 1;
        
        [self.allLineArray addObject:self.cancelArray[index]];
        
        [self.cancelArray removeObjectAtIndex:index];
        
        [self setNeedsDisplay];
    }
}

- (UIImage *)saveImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setCanvas:(UIImage *)image
{
    if (image)
    {
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 新建贝塞尔曲线
    self.bezierPath = [UIBezierPath bezierPath];
    
    // 获取触摸点
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentPoint = [currentTouch locationInView:self];
    
    // 将触摸点设置到贝塞尔曲线
    [self.bezierPath moveToPoint:currentPoint];
    
    // 将线存入数组
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [tempDic setObject:self.lineColor forKey:@"lineColor"];
    [tempDic setObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"lineWidth"];
    [tempDic setObject:self.bezierPath forKey:@"line"];
    [self.allLineArray addObject:tempDic];
    
    [tempDic release];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取触摸点
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentPoint = [currentTouch locationInView:self];
    
    // 将移动的点，加入贝塞尔曲线
    [self.bezierPath addLineToPoint:currentPoint];
    
    // 边移动，边绘制
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < self.allLineArray.count; i++)
    {
        NSDictionary *tempDic = self.allLineArray[i];
        UIColor *color = tempDic[@"lineColor"];
        CGFloat width = [tempDic[@"lineWidth"] floatValue];
        UIBezierPath *path = tempDic[@"line"];
        
        [color setStroke];
        [path setLineWidth:width];
        [path stroke];
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
