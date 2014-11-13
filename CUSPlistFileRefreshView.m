//
//  CUSPlistFileRefreshView.m
//  CUSUI
//
//  Created by wangjun on 14-11-13.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSPlistFileRefreshView.h"

static const CGFloat kLoadingIndividualAnimationTiming = 0.8;   // 加载在独特的动画时机
static const CGFloat kLineDarkAlpha = 0.4;                      // 线条透明度
static const CGFloat kLoadingTimingOffset = 0.1;                // 加载动画时间偏移量
static const CGFloat kDisappearDuration = 1.2;                  // 消失时间
static const CGFloat kRelativeHeightFactor = 2.f/5.f;           // 相对高度的因素

// LOVE 文字
#define DEFAULT_START_POINTS_LOVE    @[@"{0,0}",@"{0,20}",@"{30,0}",@"{30,20}",@"{50,20}",@"{50,0}",@"{60,0}",@"{70,20}",@"{90,0}",@"{90,0}",@"{90,10}",@"{90,10}",@"{90,20}"]
#define DEFAULT_END_POINTS_LOVE     @[@"{0,20}",@"{20,20}",@"{30,20}",@"{50,20}",@"{50,0}",@"{30,0}",@"{70,20}",@"{80,0}",@"{110,0}",@"{90,10}",@"{110,10}",@"{90,20}",@"{110,20}"]

// 小房子图案
#define DEFAULT_START_POINTS_HOUSE   @[@"{0,35}",@"{12,42}",@"{24,35}",@"{0,35}",@"{0,21}",@"{12,28}",@"{24,35}",@"{24,21}",@"{0,21}",@"{0,21}",@"{12,14}",@"{12,14}",@"{24,7}",@"{0,7}"]
#define DEFAULT_END_POINTS_HOUSE    @[@"{12,42}",@"{24,35}",@"{12,28}",@"{12,28}",@"{12,28}",@"{24,21}",@"{24,21}",@"{12,14}",@"{12,14}",@"{0,7}",@"{0,7}",@"{24,7}",@"{12,0}",@"{12,0}"]

// 六边形
#define DEFAULT_START_POINTS_HEXAGON    @[@"{0,17.3}",@"{0,17.3}",@"{0,17.3}",@"{10,0}",@"{10,0}",@"{10,34.6}",@"{10,34.6}",@"{20,17.3}",@"{20,17.3}",@"{20,17.3}",@"{30,0}",@"{30,34.6}"]
#define DEFAULT_END_POINTS_HEXAGON  @[@"{10,0}",@"{20,17.3}",@"{10,34.6}",@"{30,0}",@"{20,17.3}",@"{30,34.6}",@"{20,17.3}",@"{30,0}",@"{40,17.3}",@"{30,34.6}",@"{40,17.3}",@"{40,17.3}"]

// 五角星
#define DEFAULT_START_POINTS_FIVESTAR   @[@"{50,0}",@"{67.63,25.73}",@"{97.55,34.55}",@"{78.53,59.27}",@"{79.39,90.45}",@"{50,80}",@"{20.61,90.45}",@"{21.47,59.27}",@"{2.45,34.55}",@"{32.37,25.73}"]
#define DEFAULT_END_POINTS_FIVESTAR     @[@"{67.63,25.73}",@"{97.55,34.55}",@"{78.53,59.27}",@"{79.39,90.45}",@"{50,80}",@"{20.61,90.45}",@"{21.47,59.27}",@"{2.45,34.55}",@"{32.37,25.73}",@"{50,0}"]

typedef NS_ENUM(NSInteger, CUSPlistFileRefreshState)
{
    CUSPlistFileRefreshStateIdle = 0,       // 闲置状态
    CUSPlistFileRefreshStateRefreshing,     // 刷新状态
    CUSPlistFileRefreshStateDisappearing    // 消失状态
};

NSString *const startPointKey = @"startPoints";
NSString *const endPointKey = @"endPoints";
NSString *const xKey = @"x";
NSString *const yKey = @"y";

#pragma mark - CUSRefreshLineView

@interface CUSRefreshLineView : UIView

/**
 *  线条颜色    default:[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  线条宽度    default:1.0pt
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  线条起点坐标
 */
@property (nonatomic, assign) CGPoint startPoint;

/**
 *  线条终点坐标
 */
@property (nonatomic, assign) CGPoint endPoint;

/**
 *  线条中心点坐标
 */
@property (nonatomic, assign) CGPoint middlePoint;

/**
 *  TransForm x
 */
@property (nonatomic, assign) CGFloat transFormX;

/**
 *  初始化方法
 *
 *  @param frame frame
 *
 *  @return 返回该类的实例
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  改变线条的Frame
 *
 *  @param lineFrame Frame
 */
- (void)updateLineFrmae:(CGRect)lineFrame;

/**
 *  改变线条的位置
 *
 *  @param horizontalRandomness 水平随机离散数，用于动画
 *  @param height               下拉高度
 */
- (void)updateHorizontalRandomness:(int)horizontalRandomness drop:(CGFloat)height;

@end

@implementation CUSRefreshLineView

- (void)dealloc
{
    self.lineColor = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSetting];
    }
    return self;
}

#pragma mark - Default Setting
- (void)defaultSetting
{
    self.lineColor = [UIColor whiteColor];
    self.lineWidth = 1.0;
    self.startPoint = CGPointMake(0, 0);
    self.endPoint = CGPointMake(0, 0);
}

#pragma mark - Property Setting
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    
    [self setNeedsDisplay];
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    
    [self setNeedsDisplay];
}

- (void)queryMiddlePoint
{
    CGFloat middle_X = (self.startPoint.x + self.endPoint.x)/2.f;
    CGFloat middle_Y = (self.startPoint.y + self.endPoint.y)/2.f;
    self.middlePoint = CGPointMake(middle_X, middle_Y);
}

#pragma mark - Public Control
- (void)updateLineFrmae:(CGRect)lineFrame
{
    [self queryMiddlePoint];
    
    self.layer.anchorPoint = CGPointMake(self.middlePoint.x/self.frame.size.width,
                                         self.middlePoint.y/self.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x + self.middlePoint.x - self.frame.size.width/2,
                            self.frame.origin.y + self.middlePoint.y - self.frame.size.height/2,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (void)updateHorizontalRandomness:(int)horizontalRandomness drop:(CGFloat)height
{
    int randomNumber = -horizontalRandomness + arc4random()%horizontalRandomness*2;
    self.transFormX = randomNumber;
    self.transform = CGAffineTransformMakeTranslation(randomNumber, -height);
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:self.startPoint];
    [bezierPath addLineToPoint:self.endPoint];
    [self.lineColor setStroke];
    bezierPath.lineWidth = self.lineWidth;
    [bezierPath stroke];
}

@end

#pragma mark - CUSPlistFileRefreshView

@interface CUSPlistFileRefreshView()

/**
 *  原始位置
 */
@property (nonatomic, assign) CGFloat originalTopContentInset;

/**
 *  消失的进展
 */
@property (nonatomic, assign) CGFloat disappearProgress;

/**
 *  ScrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  图形线条数组
 */
@property (nonatomic, strong) NSArray *lineArray;

/**
 *  定时器
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 *  当前View的状态
 */
@property (nonatomic, assign) CUSPlistFileRefreshState refreshState;

@end

@implementation CUSPlistFileRefreshView

- (void)dealloc
{
    [self.displayLink invalidate];
    self.lineArray = nil;
    self.scrollView = nil;
    self.lineColor = nil;
    self.delegate = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)initWithPlist:(NSString *)plist
{
    self = [super init];
    if (self)
    {
        [self defaultSetting];
        
        CGFloat width = 0;
        CGFloat height = 0;
        
        NSDictionary *rootDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
        NSArray *startPoints = [rootDictionary objectForKey:startPointKey];
        NSArray *endPoints = [rootDictionary objectForKey:endPointKey];
        if (!(startPoints && startPoints.count > 0 && endPoints && endPoints.count > 0))
        {
            startPoints = DEFAULT_START_POINTS_FIVESTAR;
            endPoints = DEFAULT_END_POINTS_FIVESTAR;
        }
        
        for (int i=0; i<startPoints.count; i++)
        {
            CGPoint startPoint = CGPointFromString(startPoints[i]);
            CGPoint endPoint = CGPointFromString(endPoints[i]);
            
            if (startPoint.x > width) width = startPoint.x;
            if (endPoint.x > width) width = endPoint.x;
            if (startPoint.y > height) height = startPoint.y;
            if (endPoint.y > height) height = endPoint.y;
        }
        self.frame = CGRectMake(0, 0, width, height);
        
        // Create bar items
        NSMutableArray *mutableBarItems = [[NSMutableArray alloc] init];
        for (int i=0; i<startPoints.count; i++)
        {
            CGPoint startPoint = CGPointFromString(startPoints[i]);
            CGPoint endPoint = CGPointFromString(endPoints[i]);
            
            CUSRefreshLineView *lineItem = [[CUSRefreshLineView alloc] initWithFrame:self.frame];
            lineItem.tag = i;
            lineItem.backgroundColor=[UIColor clearColor];
            lineItem.alpha = 0;
            lineItem.startPoint = startPoint;
            lineItem.endPoint = endPoint;
            lineItem.lineColor = self.lineColor;
            lineItem.lineWidth = self.lineWidth;
            [mutableBarItems addObject:lineItem];
            [self addSubview:lineItem];
            
            [lineItem updateHorizontalRandomness:self.horizontalRandomness
                                            drop:self.dropHeight];
        }
        
        self.lineArray = [NSArray arrayWithArray:mutableBarItems];
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, 0);
        for (CUSRefreshLineView *line in self.lineArray)
        {
            [line updateLineFrmae:self.frame];
        }
        self.transform = CGAffineTransformMakeScale(self.zoomScale, self.zoomScale);
    }
    return self;
}

#pragma mark - Default Setting
- (void)defaultSetting
{
    self.dropHeight = 80;
    self.lineColor = [UIColor whiteColor];
    self.lineWidth = 1.0;
    self.zoomScale = 1.0;
    self.horizontalRandomness = 180;
    self.reverseLoadingAnimation = YES;
    self.internalAnimationFactor = 0.5;
}

#pragma mark - Property Setting
- (void)setDropHeight:(CGFloat)dropHeight
{
    _dropHeight = dropHeight;
    
    for (CUSRefreshLineView *line in self.lineArray)
    {
        [line updateHorizontalRandomness:self.horizontalRandomness drop:dropHeight];
    }
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    
    for (CUSRefreshLineView *line in self.lineArray)
    {
        line.lineColor = lineColor;
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    for (CUSRefreshLineView *line in self.lineArray)
    {
        line.lineWidth = lineWidth;
    }
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    
    self.transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
}

- (void)setHorizontalRandomness:(int)horizontalRandomness
{
    _horizontalRandomness = horizontalRandomness;
    
    for (CUSRefreshLineView *line in self.lineArray)
    {
        [line updateHorizontalRandomness:horizontalRandomness drop:self.dropHeight];
    }
}

- (void)setInternalAnimationFactor:(CGFloat)internalAnimationFactor
{
    _internalAnimationFactor = internalAnimationFactor;
}

- (void)setReverseLoadingAnimation:(BOOL)reverseLoadingAnimation
{
    _reverseLoadingAnimation = reverseLoadingAnimation;
}

#pragma mark - Public Control Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    if (self.originalTopContentInset == 0)
    {
        self.originalTopContentInset = self.scrollView.contentInset.top;
    }
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0,
                              self.realContentOffsetY * kRelativeHeightFactor);
    
    if (self.refreshState == CUSPlistFileRefreshStateIdle)
    {
        [self updateLineWithProgress:self.animationProgress];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    if (self.refreshState == CUSPlistFileRefreshStateIdle &&
        self.realContentOffsetY < -self.dropHeight)
    {
        if (self.animationProgress == 1) self.refreshState = CUSPlistFileRefreshStateRefreshing;
        
        if (self.refreshState == CUSPlistFileRefreshStateRefreshing)
        {
            UIEdgeInsets newInset = self.scrollView.contentInset;
            newInset.top = self.originalTopContentInset + self.dropHeight;
            CGPoint contentOffSet = self.scrollView.contentOffset;
            
            [UIView animateWithDuration:0 animations:^{
                self.scrollView.contentInset = newInset;
                self.scrollView.contentOffset = contentOffSet;
            }];
            
            // 开始Refresh，发送Delegate方法
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(cusplistRefeshViewDidStarRefresh:)])
            {
                [self.delegate cusplistRefeshViewDidStarRefresh:self];
            }
            
            [self startLoadingAnimation];
        }
    }
}

- (void)refreshFinished
{
    // 状态，置为消失中
    self.refreshState = CUSPlistFileRefreshStateDisappearing;
    UIEdgeInsets newInsets = self.scrollView.contentInset;
    newInsets.top = self.originalTopContentInset;
    [UIView animateWithDuration:kDisappearDuration animations:^{
        self.scrollView.contentInset = newInsets;
    } completion:^(BOOL finished) {
        // 动画执行完成，状态置为闲置
        self.refreshState = CUSPlistFileRefreshStateIdle;
        [self.displayLink invalidate];
        self.disappearProgress = 1;
    }];
    
    for (CUSRefreshLineView *lineView in self.lineArray)
    {
        [lineView.layer removeAllAnimations];
        lineView.alpha = kLineDarkAlpha;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(updateDisappearAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.disappearProgress = 1;
}

#pragma mark - Private Method
- (CGFloat)realContentOffsetY
{
    return self.scrollView.contentOffset.y + self.originalTopContentInset;
}

- (CGFloat)animationProgress
{
    return MIN(1.f, MAX(0, fabsf(self.realContentOffsetY)/self.dropHeight));
}

- (void)updateLineWithProgress:(CGFloat)progress
{
    for (CUSRefreshLineView *line in self.lineArray)
    {
        NSInteger index = [self.lineArray indexOfObject:line];
        CGFloat startPadding = (1 - self.internalAnimationFactor) / self.lineArray.count * index;
        CGFloat endPadding = 1 - self.internalAnimationFactor - startPadding;
        
        if (progress == 1 || progress >= (1 - endPadding))
        {
            line.transform = CGAffineTransformIdentity;
            line.alpha = kLineDarkAlpha;
        }
        else if (progress == 0)
        {
            [line updateHorizontalRandomness:self.horizontalRandomness drop:self.dropHeight];
        }
        else
        {
            CGFloat realProgress;
            if (progress <= startPadding)
            {
                realProgress = 0;
            }
            else
            {
                realProgress = MIN(1, (progress - startPadding) / self.internalAnimationFactor);
            }
            line.transform = CGAffineTransformMakeTranslation(line.transFormX * (1 - realProgress),
                                                              -self.dropHeight * (1 - realProgress));
            line.transform = CGAffineTransformRotate(line.transform, M_PI * (realProgress));
            line.transform = CGAffineTransformScale(line.transform, realProgress, realProgress);
            line.alpha = realProgress * kLineDarkAlpha;
        }
    }
}

- (void)startLoadingAnimation
{
    if (self.reverseLoadingAnimation)
    {
        for (int i = (int)(self.lineArray.count - 1); i >= 0; i--)
        {
            CUSRefreshLineView *line = self.lineArray[i];
            
            [self performSelector:@selector(everyLineAnimation:)
                       withObject:line
                       afterDelay:((self.lineArray.count - i - 1) * kLoadingTimingOffset)
                          inModes:@[NSRunLoopCommonModes]];
        }
    }
    else
    {
        for (int i = 0; i < self.lineArray.count; i++)
        {
            CUSRefreshLineView *line = self.lineArray[i];
            [self performSelector:@selector(everyLineAnimation:)
                       withObject:line
                       afterDelay:(i * kLoadingTimingOffset)
                          inModes:@[NSRunLoopCommonModes]];
        }
    }
}

- (void)everyLineAnimation:(CUSRefreshLineView *)lineView
{
    if (self.refreshState == CUSPlistFileRefreshStateRefreshing)
    {
        lineView.alpha = 1;
        [lineView.layer removeAllAnimations];
        [UIView animateWithDuration:kLoadingIndividualAnimationTiming animations:^{
            lineView.alpha = kLineDarkAlpha;
        } completion:^(BOOL finished) {
            
        }];
        
        BOOL isLastLine;
        if (self.reverseLoadingAnimation)
        {
            isLastLine = lineView.tag == 0;
        }
        else
        {
            isLastLine = lineView.tag == self.lineArray.count - 1;
        }
        
        if (isLastLine && self.refreshState == CUSPlistFileRefreshStateRefreshing)
        {
            [self startLoadingAnimation];
        }
    }
}

- (void)updateDisappearAnimation
{
    if (self.disappearProgress >= 0 && self.disappearProgress <= 1)
    {
        self.disappearProgress -= 1/60.f/kDisappearDuration;
        [self updateLineWithProgress:self.disappearProgress];
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
