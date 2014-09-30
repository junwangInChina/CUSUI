//
//  CUSPopView.m
//  CUSUI
//
//  Created by wangjun on 14-9-28.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSPopView.h"

#define ROW_HEIGHT      44
#define ROW_WIDTH       250
#define ARROE_HEIGHT    10
#define MARGIN          5
#define LINE_WIDTH      1
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

@interface CUSPopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSArray *titlesArray;
@property (nonatomic, retain) NSArray *imagesArray;
@property (nonatomic, assign) CGPoint topPoint;
@property (nonatomic, retain) UIButton *handerView;
@property (nonatomic, retain) UITableView *popTabView;
@property (nonatomic, assign) CUSPopViewOrientation popviewOrientation;

@end

@implementation CUSPopView
@synthesize titlesArray = _titlesArray;
@synthesize imagesArray = _imagesArray;
@synthesize handerView = _handerView;
@synthesize popTabView = _popTabView;
@synthesize delegate = _delegate;

- (void)dealloc
{
    self.titlesArray = nil;
    self.imagesArray = nil;
    self.handerView = nil;
    self.popTabView = nil;
    self.delegate = nil;
    
#if !__has_feature(objc_arc)
    Block_release(popBlock);
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.topPoint = point;
        self.titlesArray = titles;
        self.imagesArray = images;
        self.lineColor = [UIColor grayColor];
        self.fillColor = [UIColor whiteColor];
        
        [self reloadFrame];
        
        [self initTableView];
    }
    return self;
}

- (void)reloadFrame
{
    CGRect frame = CGRectZero;
    
    frame.size.height = (self.titlesArray.count > 6 ? 6 : self.titlesArray.count) * ROW_HEIGHT;
    frame.size.width = ROW_WIDTH;
    frame.origin.x = self.topPoint.x - frame.size.width/2.0;
    frame.origin.y = self.topPoint.y;
    
    if (frame.origin.x > MARGIN &&
        frame.origin.x + frame.size.width <= SCREEN_WIDTH - MARGIN &&
        frame.origin.y > MARGIN &&
        frame.origin.y + frame.size.height <= SCREEN_HEIGHT - MARGIN)
    {
        self.popviewOrientation = CUSPopViewOrientationPortrait;
    }
    else if (frame.origin.x > MARGIN &&
             frame.origin.x + frame.size.width <= SCREEN_WIDTH - MARGIN &&
             frame.origin.y > MARGIN &&
             frame.origin.y + frame.size.height > SCREEN_HEIGHT - MARGIN)
    {
        self.popviewOrientation = CUSPopViewOrientationPortraitUpsideDown;
        frame.origin.y = self.topPoint.y - frame.size.height;
    }
    else if (frame.origin.y > MARGIN &&
             frame.origin.y + frame.size.height <= SCREEN_HEIGHT - MARGIN &&
             frame.origin.x < MARGIN &&
             frame.origin.x + frame.size.width <= SCREEN_WIDTH - MARGIN)
    {
        self.popviewOrientation = CUSPopViewOrientationLandscapeLeft;
        frame.origin.x = self.topPoint.x + MARGIN;
        frame.origin.y = self.topPoint.y - frame.size.height / 2.0;
    }
    else if (frame.origin.y > MARGIN &&
             frame.origin.y + frame.size.height <= SCREEN_HEIGHT - MARGIN &&
             frame.origin.x > MARGIN &&
             frame.origin.x + frame.size.width > SCREEN_WIDTH - MARGIN)
    {
        self.popviewOrientation = CUSPopViewOrientationLandscapeRight;
        frame.origin.x = self.topPoint.x - MARGIN - frame.size.width;
        frame.origin.y = self.topPoint.y - frame.size.height / 2.0;
    }
    else
    {
        self.popviewOrientation = CUSPopViewOrientationPortrait;
    }
    
    
    switch (self.popviewOrientation)
    {
        case CUSPopViewOrientationPortrait:
        case CUSPopViewOrientationPortraitUpsideDown:
            frame.size.height += ARROE_HEIGHT;
            break;
        case CUSPopViewOrientationLandscapeLeft:
        case CUSPopViewOrientationLandscapeRight:
            frame.size.width += ARROE_HEIGHT;
            break;
            
        default:
            break;
    }
    /*
     // 控制左边不超过边界
     if (frame.origin.x <= MARGIN)
     {
     frame.origin.x = MARGIN;
     }
     // 控制右边不超过边界
     if (frame.origin.x + frame.size.width >= SCREEN_WIDTH - MARGIN)
     {
     frame.origin.x = SCREEN_WIDTH - MARGIN - frame.size.width;
     }
     // 控制顶部，不超过边界
     if (frame.origin.y <= MARGIN)
     {
     frame.origin.y = MARGIN;
     }
     // 控制底部，不超过边界
     if (frame.origin.y + frame.size.height > SCREEN_HEIGHT - MARGIN)
     {
     frame.origin.y = SCREEN_HEIGHT - MARGIN - frame.size.height;
     }
     */
    self.frame = frame;
}

- (void)initTableView
{
    CGRect tableFrame;
    switch (self.popviewOrientation)
    {
        case CUSPopViewOrientationPortrait:
            tableFrame = CGRectMake(LINE_WIDTH,
                                    ARROE_HEIGHT,
                                    self.frame.size.width  - LINE_WIDTH*2,
                                    self.frame.size.height - ARROE_HEIGHT);
            break;
        case CUSPopViewOrientationPortraitUpsideDown:
            tableFrame = CGRectMake(LINE_WIDTH,
                                    LINE_WIDTH,
                                    self.frame.size.width - LINE_WIDTH*2,
                                    self.frame.size.height - ARROE_HEIGHT - LINE_WIDTH*2);
            break;
        case CUSPopViewOrientationLandscapeLeft:
            tableFrame = CGRectMake(ARROE_HEIGHT + LINE_WIDTH,
                                    LINE_WIDTH,
                                    self.frame.size.width - LINE_WIDTH*2 - ARROE_HEIGHT,
                                    self.frame.size.height - LINE_WIDTH*2);
            break;
        case CUSPopViewOrientationLandscapeRight:
            tableFrame = CGRectMake(LINE_WIDTH,
                                    LINE_WIDTH,
                                    self.frame.size.width - LINE_WIDTH*2 - ARROE_HEIGHT,
                                    self.frame.size.height - LINE_WIDTH*2);
            break;
            
        default:
            break;
    }
    
    self.popTabView = [[UITableView alloc] initWithFrame:tableFrame
                                                   style:UITableViewStylePlain];
    _popTabView.delegate = self;
    _popTabView.dataSource = self;
    _popTabView.alwaysBounceHorizontal = NO;
    _popTabView.alwaysBounceVertical = NO;
    _popTabView.showsHorizontalScrollIndicator = NO;
    _popTabView.showsVerticalScrollIndicator = NO;
    _popTabView.scrollEnabled = NO;
    _popTabView.backgroundColor = [UIColor whiteColor];
    _popTabView.separatorColor = self.lineColor;
    [self addSubview:_popTabView];
    
#if !__has_feature(objc_arc)
    [_popTabView release];
#endif
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame;
    switch (self.popviewOrientation)
    {
        case CUSPopViewOrientationPortrait:
            frame = CGRectMake(0,
                               ARROE_HEIGHT,
                               self.bounds.size.width,
                               self.bounds.size.height - ARROE_HEIGHT);
            break;
        case CUSPopViewOrientationPortraitUpsideDown:
            frame = CGRectMake(0,
                               0,
                               self.bounds.size.width,
                               self.bounds.size.height - ARROE_HEIGHT);
            break;
        case CUSPopViewOrientationLandscapeLeft:
            frame = CGRectMake(ARROE_HEIGHT,
                               0,
                               self.bounds.size.width - ARROE_HEIGHT,
                               self.bounds.size.height);
            break;
        case CUSPopViewOrientationLandscapeRight:
            frame = CGRectMake(0,
                               0,
                               self.bounds.size.width - ARROE_HEIGHT,
                               self.bounds.size.height);
            break;
        default:
            break;
    }
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = [self convertPoint:self.topPoint fromView:_handerView];
    
    // 外框曲线
    UIBezierPath *popviewPath = [UIBezierPath bezierPath];
    // 线宽
    popviewPath.lineWidth = 1;
    // 曲线起始点
    [popviewPath moveToPoint:CGPointMake(xMin, yMin)];
    switch (self.popviewOrientation)
    {
            // 箭头朝上
        case CUSPopViewOrientationPortrait:
        {
            /***向上的箭头，上边线***/
            [popviewPath addLineToPoint:CGPointMake(arrowPoint.x - ARROE_HEIGHT, yMin)];
            [popviewPath addLineToPoint:CGPointMake(arrowPoint.x, yMin - ARROE_HEIGHT)];
            [popviewPath addLineToPoint:CGPointMake(arrowPoint.x + ARROE_HEIGHT, yMin)];
            [popviewPath addLineToPoint:CGPointMake(xMax, yMin)];
            /***其他三边***/
            // 右边
            [popviewPath addLineToPoint:CGPointMake(xMax, yMax)];
            // 底边
            [popviewPath addLineToPoint:CGPointMake(xMin, yMax)];
            // 左边，回到起始点，可不设置，调用closePath 方法也可自动闭环
            [popviewPath addLineToPoint:CGPointMake(xMin, yMin)];
        }
            break;
            // 箭头朝下
        case CUSPopViewOrientationPortraitUpsideDown:
        {
            // 上边
            [popviewPath addLineToPoint:CGPointMake(xMax, yMin)];
            // 右边
            [popviewPath addLineToPoint:CGPointMake(xMax, yMax)];
            /***向下的箭头，底边线***/
            [popviewPath addLineToPoint:CGPointMake(arrowPoint.x+ARROE_HEIGHT, yMax)];
            [popviewPath addLineToPoint:CGPointMake(arrowPoint.x, yMax+ARROE_HEIGHT)];
            [popviewPath addLineToPoint:CGPointMake(arrowPoint.x-ARROE_HEIGHT, yMax)];
            [popviewPath addLineToPoint:CGPointMake(xMin, yMax)];
            // 左边，回到起始点，可不设置，调用closePath 方法也可自动闭环
            [popviewPath addLineToPoint:CGPointMake(xMin, yMin)];
        }
            break;
            // 箭头朝左
        case CUSPopViewOrientationLandscapeLeft:
        {
            // 上边
            [popviewPath addLineToPoint:CGPointMake(xMax, yMin)];
            // 右边
            [popviewPath addLineToPoint:CGPointMake(xMax, yMax)];
            // 底边
            [popviewPath addLineToPoint:CGPointMake(xMin, yMax)];
            /***向左的箭头，左边线***/
            // 左边，回到起始点，可不设置，调用closePath 方法也可自动闭环
            [popviewPath addLineToPoint:CGPointMake(xMin, arrowPoint.y + ARROE_HEIGHT)];
            [popviewPath addLineToPoint:CGPointMake(xMin-ARROE_HEIGHT, arrowPoint.y)];
            [popviewPath addLineToPoint:CGPointMake(xMin, arrowPoint.y - ARROE_HEIGHT)];
            [popviewPath addLineToPoint:CGPointMake(xMin, yMin)];
        }
            break;
            // 箭头朝右
        case CUSPopViewOrientationLandscapeRight:
        {
            // 上边
            [popviewPath addLineToPoint:CGPointMake(xMax, yMin)];
            /***向右的箭头，右边线***/
            [popviewPath addLineToPoint:CGPointMake(xMax, arrowPoint.y-ARROE_HEIGHT)];
            [popviewPath addLineToPoint:CGPointMake(xMax+ARROE_HEIGHT, arrowPoint.y)];
            [popviewPath addLineToPoint:CGPointMake(xMax, arrowPoint.y+ARROE_HEIGHT)];
            [popviewPath addLineToPoint:CGPointMake(xMax, yMax)];
            // 底边
            [popviewPath addLineToPoint:CGPointMake(xMin, yMax)];
            // 左边，回到起始点，可不设置，调用closePath 方法也可自动闭环
            [popviewPath addLineToPoint:CGPointMake(xMin, yMin)];
        }
            break;
            
        default:
            break;
    }
    // 线条颜色
    [self.lineColor set];
    // 箭头填充颜色
    [self.fillColor setFill];
    [popviewPath fill];
    
    // 闭环，否则就会缺一边，若不调用，则需要设置4边闭合
    //[popviewPath closePath];
    [popviewPath stroke];
}

#pragma mark Public Method
- (void)show
{
    self.popTabView.separatorColor = self.lineColor;
    
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.topPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    [self reloadFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
}

- (void)popDidSelectBlock:(PopViewBlock)block
{
    popBlock = Block_copy(block);
}

#pragma mark UITableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CUSPopViewTableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.imagesArray.count > 0 && self.imagesArray.count > indexPath.row)
    {
        cell.imageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    }
    if (self.titlesArray.count > indexPath.row)
    {
        cell.textLabel.text = self.titlesArray[indexPath.row];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
#if !__has_feature(objc_arc)
    return [cell autorelease];
#else
    return cell;
#endif
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didSelectAtIndexPath:)])
    {
        [self.delegate popView:self didSelectAtIndexPath:indexPath];
    }
    if (popBlock)
    {
        popBlock(indexPath);
    }
    [self dismiss];
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
