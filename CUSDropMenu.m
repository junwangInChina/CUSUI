//
//  CUSDropMenu.m
//  CUSUI
//
//  Created by wangjun on 14-10-8.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSDropMenu.h"

#define DEFAULT_FONT        [UIFont systemFontOfSize:14.0]
#define DEFAULT_ROW_HEIGHT  38
#define DEFAULT_SIZE        [UIScreen mainScreen].bounds.size

#pragma mark - CUSDropMenuIndexPath

@implementation CUSDropMenuIndexPath

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row
{
    self = [super init];
    if (self)
    {
        _column = column;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathForColumn:(NSInteger)column row:(NSInteger)row
{
    CUSDropMenuIndexPath *indexPath = [[self alloc] initWithColumn:column row:row];
    return indexPath;
}

@end

#pragma mark - CUSDropMenu

@interface CUSDropMenu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) BOOL menuShow;
@property (nonatomic, assign) CGPoint menuOrigin;

@property (nonatomic, retain) UIView *backGroundView;
@property (nonatomic, retain) UITableView *menuTabView;

@property (nonatomic, copy) NSArray *menuTitles;
@property (nonatomic, copy) NSArray *menuIndicators;
@property (nonatomic, copy) NSArray *menuBgLayers;

/**
 *  创建大背景
 *
 *  @param color    设置颜色
 *  @param position 位置
 *
 *  @return 返回背景Layer
 */
- (CALayer *)createBgLayerWithColor:(UIColor *)color
                           position:(CGPoint)position;

/**
 *  创建表示展开状态的小三角
 *
 *  @param color    设置颜色
 *  @param position 位置
 *
 *  @return 返回小三角Layer
 */
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color
                                  position:(CGPoint)position;

/**
 *  创建分割线
 *
 *  @param color    设置颜色
 *  @param position 位置
 *
 *  @return 返回分割线Layer
 */
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color
                                      position:(CGPoint)position;

/**
 *  创建标题
 *
 *  @param string   标题展示文案
 *  @param color    设置颜色
 *  @param position 位置
 *
 *  @return 返回标题Layer
 */
- (CATextLayer *)createTextLayerWithText:(NSString *)string
                                   color:(UIColor *)color
                                position:(CGPoint)position;

/**
 *  计算文案所占的尺寸
 *
 *  @param string 需要计算的文案
 *
 *  @return 返回计算好的尺寸
 */
- (CGSize)calculateSize:(NSString *)string;

/**
 *  选中某一行
 *
 *  @param row 选中的行
 */
- (void)confirmDropMenu:(NSInteger)row;

/**
 *  总的动画执行方法
 *
 *  @param indicator  三角块
 *  @param background 背景图
 *  @param tableView  表格
 *  @param title      标题文案
 *  @param forward    展示or隐藏
 *  @param complete   回调代码块
 */
- (void)animationAllWithIndicator:(CAShapeLayer *)indicator
                            title:(CATextLayer *)title
                       background:(UIView *)background
                        tableView:(UITableView *)tableView
                          forward:(BOOL)forward
                         complete:(void(^)())complete;

/**
 *  三角块动画执行方法
 *
 *  @param indicator 需要执行动画操作的三角块
 *  @param forward   需要改变的方向
 *  @param complete  回调代码块，用户动画执行完成后回调
 */
- (void)animationIndicator:(CAShapeLayer *)indicator
                   forward:(BOOL)forward
                  complete:(void(^)())complete;

/**
 *  标题动画执行方法
 *
 *  @param title    需要执行动画操作的标题
 *  @param show     展示or隐藏
 *  @param complete 回调代码块，用户动画执行完成后回调
 */
- (void)animationTitle:(CATextLayer *)title
                  show:(BOOL)show
              complete:(void(^)())complete;

/**
 *  大背景动画执行方法
 *
 *  @param view     需要执行动画操作的大背景
 *  @param show     展示or隐藏
 *  @param complete 回调代码块，用户动画执行完成后回调
 */
- (void)animationBackGroundView:(UIView *)view
                           show:(BOOL)show
                       complete:(void(^)())complete;

/**
 *  表格动画执行方法
 *
 *  @param tableView 需要执行动画操作的表格
 *  @param show      展示or隐藏
 *  @param complete  回调代码块，用户动画执行完成后回调
 */
- (void)animationTableView:(UITableView *)tableView
                      show:(BOOL)show
                  complete:(void(^)())complete;



@end

@implementation CUSDropMenu

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = DEFAULT_SIZE.width;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.menuOrigin = CGPointMake(frame.origin.x, frame.origin.y);
        self.currentIndex = -1;
        self.menuShow = NO;
        
        // Choose Column Gesture
        UITapGestureRecognizer *chooseColumnGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCloumnGesture:)];
        [self addGestureRecognizer:chooseColumnGesture];
#if !__has_feature(objc_arc)
        [chooseColumnGesture release];
#endif
        // Background
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, DEFAULT_SIZE.width, DEFAULT_SIZE.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        
        // Background Gesture
        UITapGestureRecognizer *backgroundGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundGesture:)];
        [_backGroundView addGestureRecognizer:backgroundGesture];
        
        // Table
        _menuTabView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x,
                                                                     frame.origin.y + frame.size.height,
                                                                     frame.size.width,
                                                                     0)
                                                    style:UITableViewStylePlain];
        _menuTabView.rowHeight = DEFAULT_ROW_HEIGHT;
        _menuTabView.delegate = self;
        _menuTabView.dataSource = self;
        _menuTabView.separatorColor = self.separatorColor;
        
        // bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        bottomShadow.backgroundColor = self.separatorColor;
        [self addSubview:bottomShadow];
    }
    return self;
}

- (CALayer *)createBgLayerWithColor:(UIColor *)color
                           position:(CGPoint)position
{
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0,
                              0,
                              self.frame.size.width / _numOfMenu,
                              self.frame.size.height - 1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color
                                  position:(CGPoint)position
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 画线，画一个三角形
    UIBezierPath *path = [UIBezierPath new];
    // 设置起点
    [path moveToPoint:CGPointMake(0, 0)];
    // 第一条边
    [path addLineToPoint:CGPointMake(8, 0)];
    // 第二条边
    [path addLineToPoint:CGPointMake(4, 5)];
    // 设置闭合，第三条边
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path,
                                                     nil,
                                                     layer.lineWidth,
                                                     kCGLineCapButt,
                                                     kCGLineJoinMiter,
                                                     layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    layer.position = position;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color
                                      position:(CGPoint)position
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 画线
    UIBezierPath *path = [UIBezierPath new];
    // 设置起点
    [path moveToPoint:CGPointMake(160, 0)];
    // 画线
    [path addLineToPoint:CGPointMake(160, 20)];
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path,
                                                     nil,
                                                     layer.lineWidth,
                                                     kCGLineCapButt,
                                                     kCGLineJoinMiter,
                                                     layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    layer.position = position;
    
    return layer;
}

- (CATextLayer *)createTextLayerWithText:(NSString *)string
                                   color:(UIColor *)color
                                position:(CGPoint)position
{
    CGSize size = [self calculateSize:string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : ((self.frame.size.width / _numOfMenu) - 25);
    
    CATextLayer *layer = [CATextLayer new];
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.position = position;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    return layer;
}

- (CGSize)calculateSize:(NSString *)string
{
    NSDictionary *dic = @{NSFontAttributeName:DEFAULT_FONT};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:dic
                                       context:nil].size;
    return size;
}

#pragma mark - Getter Method
- (UIColor *)indicatorColor
{
    if (!_indicatorColor)
    {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

- (UIColor *)textColor
{
    if (!_textColor)
    {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor
{
    if (!_separatorColor)
    {
        _separatorColor = [UIColor lightGrayColor];
    }
    return _separatorColor;
}

- (NSString *)titleForRowAtIndexPath:(CUSDropMenuIndexPath *)indexPath
{
    return [self.dataSource dropMenu:self titleForRowAtIndexPath:indexPath];
}

#pragma mark - Setter Method
- (void)setDataSource:(id<CUSDropMenuDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInDropMenu:)])
    {
        _numOfMenu = [_dataSource numberOfColumnsInDropMenu:self];
    }
    else
    {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / (_numOfMenu * 2);
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++)
    {
        // BgLayer
        CGPoint bglayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height / 2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor]
                                               position:bglayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        
        // Title
        CGPoint titlePosition = CGPointMake((i * 2 + 1) * textLayerInterval, self.frame.size.height / 2.0);
        NSString *titleString = [_dataSource dropMenu:self
                               titleForRowAtIndexPath:[CUSDropMenuIndexPath indexPathForColumn:i row:0]];
        CATextLayer *textLayer = [self createTextLayerWithText:titleString
                                                         color:self.textColor
                                                      position:titlePosition];
        [self.layer addSublayer:textLayer];
        [tempTitles addObject:textLayer];
        
        // Indicator 小三角
        CGPoint indicatorPosition = CGPointMake(titlePosition.x + textLayer.bounds.size.width / 2.0 + 8,
                                                self.frame.size.height / 2.0);
        CAShapeLayer *indicatorLayer = [self createIndicatorWithColor:self.indicatorColor
                                                             position:indicatorPosition];
        [self.layer addSublayer:indicatorLayer];
        [tempIndicators addObject:indicatorLayer];
        
        // 分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / _numOfMenu)*i,
                                                                    4,
                                                                    0.5,
                                                                    self.frame.size.height - 8)];
        lineView.backgroundColor = self.separatorColor;
        [self.layer addSublayer:lineView.layer];
        
#if !__has_feature(objc_arc)
        [lineView release];
#endif
    }
    
    _menuTitles = [tempTitles copy];
    _menuIndicators = [tempIndicators copy];
    _menuBgLayers = [tempBgLayers copy];
    
#if !__has_feature(objc_arc)
    [tempTitles release];
    [tempIndicators release];
    [tempBgLayers release];
#endif
}

#pragma mark - Animation Method
- (void)animationAllWithIndicator:(CAShapeLayer *)indicator
                            title:(CATextLayer *)title
                       background:(UIView *)background
                        tableView:(UITableView *)tableView
                          forward:(BOOL)forward
                         complete:(void(^)())complete
{
    [self animationIndicator:indicator forward:forward complete:^{
        
        [self animationTitle:title show:forward complete:^{
            
            [self animationBackGroundView:background show:forward complete:^{
                
                [self animationTableView:tableView show:forward complete:^{
                    
                }];
                
            }];
            
        }];
        
    }];
    complete();
}

- (void)animationIndicator:(CAShapeLayer *)indicator
                   forward:(BOOL)forward
                  complete:(void(^)())complete
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = forward ? @[@0, @(M_PI)] : @[@(M_PI), @0];
    if (!animation.removedOnCompletion)
    {
        [indicator addAnimation:animation forKey:animation.keyPath];
    }
    else
    {
        [indicator addAnimation:animation forKey:animation.keyPath];
        [indicator setValue:animation.values.lastObject forKeyPath:animation.keyPath];
    }
    [CATransaction commit];
    
    complete();
}

- (void)animationTitle:(CATextLayer *)title
                  show:(BOOL)show
              complete:(void(^)())complete
{
    CGSize size = [self calculateSize:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : ((self.frame.size.width / _numOfMenu) - 25);
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    complete();
}

- (void)animationBackGroundView:(UIView *)view
                           show:(BOOL)show
                       complete:(void(^)())complete
{
    if (show)
    {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            
        } completion:^(BOOL finished) {
            
            [view removeFromSuperview];
            
        }];
    }
    
    complete();
}

- (void)animationTableView:(UITableView *)tableView
                      show:(BOOL)show
                  complete:(void(^)())complete
{
    if (show)
    {
        tableView.frame = CGRectMake(self.menuOrigin.x,
                                     self.frame.origin.y + self.frame.size.height,
                                     self.frame.size.width,
                                     0);
        [self.superview addSubview:tableView];
        
        CGFloat tableHeight = ([tableView numberOfRowsInSection:0] > 5) ? (5 * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _menuTabView.frame = CGRectMake(self.menuOrigin.x,
                                            self.frame.origin.y + self.frame.size.height,
                                            self.frame.size.width,
                                            tableHeight);
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            _menuTabView.frame = CGRectMake(self.menuOrigin.x,
                                            self.frame.origin.y + self.frame.size.height,
                                            self.frame.size.width,
                                            
                                            0);
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
        }];
    }
    complete();
}

#pragma mark Gesture Method
- (void)chooseCloumnGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint touchPoint = [tapGesture locationInView:self];
    
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    for (int i = 0 ; i < _numOfMenu; i++)
    {
        if (i != tapIndex)
        {
            [self animationIndicator:_menuIndicators[i] forward:NO complete:^{
                
                [self animationTitle:_menuTitles[i] show:NO complete:^{
                    
                }];
                
            }];
            [(CALayer *)self.menuBgLayers[i] setBackgroundColor:[UIColor whiteColor].CGColor];
        }
    }
    
    if (tapIndex == _currentIndex && _menuShow)
    {
        [self animationAllWithIndicator:_menuIndicators[_currentIndex]
                                  title:_menuTitles[_currentIndex]
                             background:_backGroundView
                              tableView:_menuTabView
                                forward:NO
                               complete:^{
                                   _menuShow = NO;
                               }];
        [(CALayer *)self.menuBgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    }
    else
    {
        _currentIndex = tapIndex;
        [_menuTabView reloadData];
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenu:column:string:)])
        {
            NSIndexPath *indexPath = [self.dataSource dropMenu:self
                                                        column:tapIndex
                                                        string:[(CATextLayer *)[self.menuTitles objectAtIndex:tapIndex] string]];
            [_menuTabView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        [self animationAllWithIndicator:_menuIndicators[tapIndex]
                                  title:_menuTitles[tapIndex]
                             background:_backGroundView
                              tableView:_menuTabView
                                forward:YES
                               complete:^{
                                   _menuShow = YES;
                               }];
        [(CALayer *)self.menuBgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    }
}

- (void)backgroundGesture:(UITapGestureRecognizer *)tapGesture
{
    [self animationAllWithIndicator:_menuIndicators[_currentIndex]
                              title:_menuTitles[_currentIndex]
                         background:_backGroundView
                          tableView:_menuTabView
                            forward:NO
                           complete:^{
                               _menuShow = NO;
                           }];
    
    [(CALayer *)self.menuBgLayers[_currentIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
}

#pragma mark - Private Method
- (void)confirmDropMenu:(NSInteger)row
{
    CATextLayer *titleLayer = (CATextLayer *)_menuTitles[_currentIndex];
    titleLayer.string = [self.dataSource dropMenu:self
                           titleForRowAtIndexPath:[CUSDropMenuIndexPath indexPathForColumn:_currentIndex
                                                                                       row:row]];
    [self animationAllWithIndicator:_menuIndicators[_currentIndex]
                              title:_menuTitles[_currentIndex]
                         background:_backGroundView
                          tableView:_menuTabView
                            forward:NO
                           complete:^{
                               self.menuShow = NO;
                           }];
    
    [(CALayer *)self.menuBgLayers[_currentIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    
    CAShapeLayer *indicatorLayer = (CAShapeLayer *)_menuIndicators[_currentIndex];
    indicatorLayer.position = CGPointMake(titleLayer.position.x + titleLayer.frame.size.width / 2 + 8,
                                          indicatorLayer.position.y);
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert(self.dataSource != nil, @"CUSDropMenu DataSource Should Not Be Nil");
    if ([self.dataSource respondsToSelector:@selector(dropMenu:numberOfRowsInColumn:)])
    {
        return [self.dataSource dropMenu:self
                    numberOfRowsInColumn:self.currentIndex];
    }
    else
    {
        NSAssert(0 == 1, @"Required Method Of DataSource Protocol Should Be Implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CUSDropMenuTableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSAssert(self.dataSource != nil, @"CUSDropMenu DataSource Should Not Be Nil");
    if ([self.dataSource respondsToSelector:@selector(dropMenu:titleForRowAtIndexPath:)])
    {
        cell.textLabel.text = [self.dataSource dropMenu:self titleForRowAtIndexPath:[CUSDropMenuIndexPath indexPathForColumn:self.currentIndex row:indexPath.row]];
    }
    else
    {
        NSAssert(0 == 1, @"Required Method Of DataSource Protocol Should Be Implemented");
    }
    
    cell.textLabel.font = DEFAULT_FONT;
    cell.separatorInset = UIEdgeInsetsZero;
    if (cell.textLabel.text == [(CATextLayer *)[self.menuTitles objectAtIndex:_currentIndex] string])
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self confirmDropMenu:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:didSelectRowAtIndexPath:)])
    {
        [self.delegate dropMenu:self
        didSelectRowAtIndexPath:[CUSDropMenuIndexPath indexPathForColumn:self.currentIndex
                                                                     row:indexPath.row]];
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
