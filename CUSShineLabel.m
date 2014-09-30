//
//  CUSShineLabel.m
//  CUSUI
//
//  Created by wangjun on 14-8-4.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSShineLabel.h"


@interface CUSShineLabel()

@property (nonatomic, strong) NSMutableAttributedString *attributeString;
@property (nonatomic, strong) NSMutableArray *animationDurationArray;
@property (nonatomic, strong) NSMutableArray *animationDelaysArray;
@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign, getter = isFadeOut) BOOL fadeOut;
@property (nonatomic, copy) void (^complete)();

@end

@implementation CUSShineLabel
@synthesize shineDuration = _shineDuration;
@synthesize fadeDuration = _fadeDuration;
@synthesize autoShine = _autoShine;
@synthesize attributeString = _attributeString;
@synthesize animationDurationArray = _animationDurationArray;
@synthesize animationDelaysArray = _animationDelaysArray;
@synthesize displaylink = _displaylink;
@synthesize beginTime = _beginTime;

- (void)dealloc
{
    self.attributeString = nil;
    self.animationDurationArray = nil;
    self.animationDelaysArray = nil;
    self.complete = nil;
    [self stopCADisplayLink];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadDefaultConfiguration];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self loadDefaultConfiguration];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadDefaultConfiguration];
    }
    return self;
}

- (void)loadDefaultConfiguration
{
    self.shineDuration = 2.5;
    self.fadeDuration = 2.5;
    self.autoShine = NO;
    self.fadeOut = YES;
    
    self.animationDurationArray = [NSMutableArray array];
    self.animationDelaysArray = [NSMutableArray array];
    
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttribute)];
    _displaylink.paused = YES;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark System Method
- (void)setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.attributeString = [self initialAttributedStringFromAttributedString:attributedText];
    [super setAttributedText:self.attributeString];
    
    for (NSUInteger i = 0; i < attributedText.length; i++)
    {
        self.animationDelaysArray[i] = @(arc4random_uniform(self.shineDuration / 2 * 100) / 100.0);
        CGFloat remind = self.shineDuration - [self.animationDelaysArray[i] floatValue];
        self.animationDurationArray[i] = @(arc4random_uniform(remind * 100) / 100.0);
    }
}

- (void)didMoveToWindow
{
    if (nil != self.window && self.autoShine)
    {
        [self shine];
    }
}

#pragma mark Getter Method
- (BOOL)isShining
{
    return !self.displaylink.isPaused;
}

- (BOOL)isVisible
{
    return NO == self.isFadeOut;
}

#pragma mark Shine Method
- (void)shine
{
    if (!self.isShining && self.isFadeOut)
    {
        self.fadeOut = NO;
        
        [self startAnimation];
    }
}

- (void)shineWithComplete:(void (^)())complete
{
    self.complete = complete;
    
    [self shine];
}

- (void)fadeOut
{
    [self fadeOutWithComplete:NULL];
}

- (void)fadeOutWithComplete:(void (^)())complete
{
    if (!self.isShining && !self.isFadeOut)
    {
        self.fadeOut = YES;
        
        self.complete = complete;
        
        [self startAnimation];
    }
    
}

- (void)changeShineText:(NSString *)shineText
{
    if (self.isVisible)
    {
        [self fadeOutWithComplete:^{
            self.text = shineText;
            [self shine];
        }];
    }
    else
    {
        [self shine];
    }
}

#pragma mark - Private Method
- (void)startAnimation
{
    self.beginTime = CACurrentMediaTime();
    
    self.displaylink.paused = NO;
}

- (void)stopAnimation
{
    self.displaylink.paused = YES;
    
    if (self.complete)
    {
        self.complete();
        self.complete = NULL;
    }
}

- (void)stopCADisplayLink
{
    [self.displaylink invalidate];
    self.displaylink = nil;
}

- (void)updateAttribute
{
    CFTimeInterval nowTime = CACurrentMediaTime();
    for (NSUInteger i = 0; i < self.attributeString.length; i++)
    {
        [self.attributeString enumerateAttribute:NSForegroundColorAttributeName
                                         inRange:NSMakeRange(i, 1)
                                         options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop)
         {
             if ((nowTime - self.beginTime) <
                 [self.animationDelaysArray[i] floatValue])
             {
                 return ;
             }
             
             CGFloat percent = (nowTime - self.beginTime - [self.animationDelaysArray[i] floatValue]) / ([self.animationDurationArray[i] floatValue]);
             percent = self.isFadeOut ? (1 - percent) : percent;
             
             UIColor *color = [self.textColor colorWithAlphaComponent:percent];
             [self.attributeString addAttribute:NSForegroundColorAttributeName
                                          value:color
                                          range:range];
         }];
        
        [super setAttributedText:self.attributeString];
        
        if (nowTime > (self.beginTime + (self.isFadeOut ? self.fadeDuration : self.shineDuration)))
        {
            [self stopAnimation];
        }
    }
}

- (NSMutableAttributedString *)initialAttributedStringFromAttributedString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    UIColor *color = [self.textColor colorWithAlphaComponent:0];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                    value:color
                                    range:NSMakeRange(0, mutableAttributedString.length)];
    return mutableAttributedString;
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
