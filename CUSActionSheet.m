//
//  CUSActionSheet.m
//  CUSUI
//
//  Created by wangjun on 14-7-29.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSActionSheet.h"

#define kCUSPhoneActionSheetTitleHeight  48.0f   //标题高度
#define kCUSPhoneActionSheetButtonHeight 42.0f   //按钮高度
#define kCUSPhoneActionSheetBroderSpace  6.0f    //边框间距
#define kCUSPhoneActionSheetButtonSpace  1.0f    //按钮间距

#define kCUSPadActionSheetTitleHeight  80.0f     //标题高度
#define kCUSPadActionSheetButtonHeight 72.0f     //按钮高度
#define kCUSPadActionSheetBroderSpace  12.0f     //边框间距
#define kCUSPadActionSheetButtonSpace  1.0f      //按钮间距

#define kCUSPhoneMaskCornerRadii CGSizeMake(4, 4)    //圆角
#define kCUSPadMaskCornerRadii CGSizeMake(8, 8)      //圆角

#define kCUSBlurRadius  10.0f
#define kCUSDeltaFactor 2.0f
#define kCUSNormalClickColor        [UIColor colorWithWhite:1.0f alpha:0.9f]
#define kCUSHightlightClickColor    [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.9f]


@interface CUSActionSheet()
{
    CGFloat _actionScrollHeight;
    CGFloat _actionScrollWidth;
    
    CGFloat _actionViewHeight;
    CGFloat _actionViewWidth;
}

@property (nonatomic, strong) NSString *titleString;            // 标题
@property (nonatomic, strong) NSMutableArray *buttonTitleArray; // 按钮名称数组
@property (nonatomic, strong) NSString *otherButtonTitle;       // 其他按钮名称，最底部的一个按钮

@property (nonatomic, strong) UIButton *backGroundButton;       // 背景按钮，用于触发点击背景收起ActionSheet
@property (nonatomic, strong) UIView *actionView;               // ActionView
@property (nonatomic, strong) UIScrollView *actionScrollView;   // 加载按钮的ScrollView，按钮数量较多时，便于滑动
@property (nonatomic, strong) UILabel *titleLabel;              // 标题
@property (nonatomic, strong) UIButton *otherButton;            // 最底部的按钮
@property (nonatomic, strong) NSMutableArray *buttonArray;      // 中间按钮数组

@end

@implementation CUSActionSheet
@synthesize titleString = _titleString;
@synthesize buttonTitleArray = _buttonTitleArray;
@synthesize otherButtonTitle = _otherButtonTitle;
@synthesize backGroundButton = _backGroundButton;
@synthesize actionView = _actionView;
@synthesize actionScrollView = _actionScrollView;
@synthesize titleLabel = _titleLabel;
@synthesize otherButton = _otherButton;
@synthesize buttonArray = _buttonArray;
@synthesize delegate = _delegate;

- (void)dealloc
{
    self.titleString = nil;
    self.buttonTitleArray = nil;
    self.otherButtonTitle = nil;
    self.backGroundButton = nil;
    self.actionView = nil;
    self.actionScrollView = nil;
    self.titleLabel = nil;
    self.otherButton = nil;
    self.buttonArray = nil;
    self.delegate = nil;
    
#if !__has_feature(objc_arc)
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

- (instancetype)initWithTitle:(NSString *)title
                      buttons:(NSArray *)buttons
                  otherButton:(NSString *)otherButton
                     delegate:(id<CUSActionSheetDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.titleString = title;
        self.buttonTitleArray = [buttons mutableCopy];
        self.otherButtonTitle = otherButton;
        self.delegate = delegate;
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    if (!view) return;
    if (self.buttonTitleArray.count <= 0) return;
    
    UIWindow *currWindow = [UIApplication sharedApplication].keyWindow;
    [currWindow addSubview:view];
    
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:self];
    
    // 背景Button，用于点击背景，收起Action
    self.backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backGroundButton.frame = self.bounds;
    _backGroundButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    _backGroundButton.alpha = 0;
    _backGroundButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_backGroundButton];
    
    // ActionView 加载展示控件
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _actionView.backgroundColor = [UIColor clearColor];
    _actionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_actionView];
#if !__has_feature(objc_arc)
    [_actionView release];
#endif
    
    // ScrollView，加载中间的Button
    self.actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    _actionScrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _actionScrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [self.actionView addSubview:_actionScrollView];
#if !__has_feature(objc_arc)
    [_actionScrollView release];
#endif
    
    [self initActionSize];
    [self resetActionFrame];
    [self resetScrollFrame];
    
    // 加载Title
    if (self.titleString && self.titleString.length > 0)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    _actionViewWidth,
                                                                    [self actionSheetTitleHeight])];
        _titleLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        _titleLabel.text = self.titleString;
        _titleLabel.textColor = [UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1];
        if (CUS_iPhone)
        {
            _titleLabel.font = [UIFont systemFontOfSize:13];
        }
        else
        {
            _titleLabel.font = [UIFont systemFontOfSize:20];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleTopMargin;
        [_actionView addSubview:_titleLabel];
#if !__has_feature(objc_arc)
        [_titleLabel release];
#endif
    }
    
    // 中间按钮，加载在ScrollView上的
    for (int i = 0; i < [self.buttonTitleArray count]; i++)
    {
        NSString *currentTitle = self.buttonTitleArray[i];
        UIButton *btn = [self createButtonWithTitle:currentTitle tag:i];
        CGFloat y = [self actionSheetButtonSpace] +
        ([self actionSheetButtonHeight] + [self actionSheetButtonSpace]) * i;
        btn.frame = CGRectMake(0, y, _actionScrollWidth, [self actionSheetButtonHeight]);
        
        if (!self.buttonArray)
        {
            self.buttonArray = [NSMutableArray array];
        }
        [self.buttonArray addObject:btn];
        [self.actionScrollView addSubview:btn];
    }
    
    // Other 按钮，最底部的按钮
    self.otherButton = [self createButtonWithTitle:self.otherButtonTitle tag:-1];
    _otherButton.frame = CGRectMake(0,
                                    _actionViewHeight - [self actionSheetButtonHeight] - [self actionSheetBrodeSpace],
                                    _actionViewWidth,
                                    [self actionSheetButtonHeight]);
    [self.actionView addSubview:_otherButton];
    
    // 绘制各控件弧度
    [self drawCorner];
    
    // 展示
    [self appearAnimation:^{
        [self.backGroundButton addTarget:self
                                  action:@selector(btnTouchIn:)
                        forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    [button setTitleColor:[UIColor colorWithRed:28.0/255.0 green:130.0/255.0 blue:231.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button setTag:tag];
    if (CUS_iPhone)
    {
        button.titleLabel.font = [UIFont systemFontOfSize:21];
    }
    else
    {
        button.titleLabel.font = [UIFont systemFontOfSize:30];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [button addTarget:self action:@selector(btnTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(btnTouchDwon:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(btnTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    [button addTarget:self action:@selector(btnTouchOut:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(btnTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    return button;
}

- (void)initActionSize
{
    CGFloat maxHeight = self.bounds.size.height - ([self actionSheetBrodeSpace] * 2) - 20 - [self actionSheetButtonHeight] - [self actionSheetTitleHeight];
    
    _actionScrollHeight = (self.buttonTitleArray.count * [self actionSheetButtonSpace]) +
    (self.buttonTitleArray.count * [self actionSheetButtonHeight]);
    
    _actionScrollWidth = self.bounds.size.width - [self actionSheetBrodeSpace] * 2;
    
    if (_actionScrollHeight >= maxHeight)
    {
        _actionScrollHeight = maxHeight;
    }
    
    _actionViewHeight = [self actionSheetBrodeSpace] * 2 +
    [self actionSheetButtonHeight] +
    _actionScrollHeight +
    ((self.titleString && self.titleString.length > 0) ? [self actionSheetTitleHeight] : 0);
    
    _actionViewWidth = self.bounds.size.width - [self actionSheetBrodeSpace] * 2;
}

- (void)resetActionFrame
{
    self.actionView.frame = CGRectMake([self actionSheetBrodeSpace],
                                       self.bounds.size.height,
                                       _actionViewHeight,
                                       _actionViewWidth);
}

// 初始化ScrollView尺寸
- (void)resetScrollFrame
{
    CGFloat maxHeight = self.bounds.size.height - ([self actionSheetBrodeSpace] * 2) - 20 - [self actionSheetButtonHeight] - [self actionSheetTitleHeight];
    
    _actionScrollHeight = (self.buttonTitleArray.count * [self actionSheetButtonSpace]) +
    (self.buttonTitleArray.count * [self actionSheetButtonHeight]);
    
    CGFloat scrollY = (self.titleString && self.titleString.length > 0) ? [self actionSheetTitleHeight] : 0;
    
    if (_actionScrollHeight >= maxHeight)
    {
        self.actionScrollView.contentSize = CGSizeMake(_actionScrollWidth, _actionScrollHeight);
        
        _actionScrollHeight = maxHeight;
    }
    
    self.actionScrollView.frame = CGRectMake(0, scrollY, _actionScrollWidth, _actionScrollHeight);
}

// 绘制角度
- (void)drawCorner
{
    //    [self initActionSize];
    
    CGSize cornerSize = CGSizeZero;
    if (CUS_iPhone)
    {
        cornerSize = kCUSPhoneMaskCornerRadii;
    }
    else
    {
        cornerSize = kCUSPadMaskCornerRadii;
    }
    
    // 如果有标题，则需要绘制标题
    if (self.titleString && self.titleString.length > 0)
    {
        CAShapeLayer *titleLayer = [CAShapeLayer layer];
        titleLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.titleLabel.bounds
                                                 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                       cornerRadii:cornerSize] CGPath];
        self.titleLabel.layer.mask = titleLayer;
        
        // 绘制ScrollView
        CAShapeLayer *scrollLayer = [CAShapeLayer layer];
        scrollLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.actionScrollView.bounds
                                                  byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                        cornerRadii:cornerSize] CGPath];
        self.actionScrollView.layer.mask = scrollLayer;
    }
    // 没标题，则需要绘制ScrollView上第一个按钮
    else
    {
        UIButton *button = [self.buttonArray objectAtIndex:0];
        CAShapeLayer *buttonLayer = [CAShapeLayer layer];
        buttonLayer.path = [[UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                        cornerRadii:cornerSize] CGPath];
        button.layer.mask = buttonLayer;
        
        // 绘制ScrollView
        CAShapeLayer *scrollLayer = [CAShapeLayer layer];
        scrollLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.actionScrollView.bounds
                                                  byRoundingCorners:UIRectCornerAllCorners
                                                        cornerRadii:cornerSize] CGPath];
        self.actionScrollView.layer.mask = scrollLayer;
    }
    
    // 绘制ScrollView上最后一个按钮
    UIButton *lastButton = [self.buttonArray lastObject];
    CAShapeLayer *lastLayer = [CAShapeLayer layer];
    lastLayer.path = [[UIBezierPath bezierPathWithRoundedRect:lastButton.bounds
                                            byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                  cornerRadii:cornerSize] CGPath];
    lastButton.layer.mask = lastLayer;
    
    // 绘制ScrollView上的中间按钮
    int startIndex = 1;
    if (self.titleString && self.titleString.length > 0)
    {
        startIndex = 0;
    }
    for (int i = startIndex; i < [self.buttonArray count] - 1; i ++)
    {
        UIButton *middleButton = [self.buttonArray objectAtIndex:i];
        CAShapeLayer *middleLayer = [CAShapeLayer layer];
        middleLayer.path = CGPathCreateWithRect(middleButton.bounds, NULL);
        middleButton.layer.mask = middleLayer;
    }
    
    // 绘制最底部的Other按钮
    CAShapeLayer *otherLayer = [CAShapeLayer layer];
    otherLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.otherButton.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:cornerSize] CGPath];
    self.otherButton.layer.mask = otherLayer;
}

- (void)appearAnimation:(void(^)())completed
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.actionView.frame = CGRectMake([self actionSheetBrodeSpace],
                                           (self.bounds.size.height - _actionViewHeight),
                                           _actionViewHeight,
                                           _actionViewWidth);
        self.backGroundButton.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        if (completed)
        {
            completed();
        }
        
    }];
}

- (void)disappearAnimation:(void(^)())completed
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self resetActionFrame];
        
        self.backGroundButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        if (completed)
        {
            completed();
        }
        
    }];
}

#pragma mark - ActionView Size
- (CGFloat)actionSheetBrodeSpace
{
    if (CUS_iPhone)
    {
        return kCUSPhoneActionSheetBroderSpace;
    }
    else
    {
        return kCUSPadActionSheetBroderSpace;
    }
}

- (CGFloat)actionSheetButtonHeight
{
    if (CUS_iPhone)
    {
        return kCUSPhoneActionSheetButtonHeight;
    }
    else
    {
        return kCUSPadActionSheetButtonHeight;
    }
}

- (CGFloat)actionSheetTitleHeight
{
    if (CUS_iPhone)
    {
        return kCUSPhoneActionSheetTitleHeight;
    }
    else
    {
        return kCUSPadActionSheetTitleHeight;
    }
}

- (CGFloat)actionSheetButtonSpace
{
    if (CUS_iPhone)
    {
        return kCUSPhoneActionSheetButtonSpace;
    }
    else
    {
        return kCUSPadActionSheetButtonSpace;
    }
}

#pragma mark Button Event
- (void)btnTouchIn:(UIButton *)btn
{
    btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    [self disappearAnimation:^{
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(actionSheet:clickIndex:)])
        {
            [self.delegate actionSheet:self
                            clickIndex:(btn.tag/* - kCUSDefaultTag*/)];
        }
        [self removeFromSuperview];
    }];
}

- (void)btnTouchDwon:(UIButton *)btn
{
    btn.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:0.8];
}

- (void)btnTouchOut:(UIButton *)btn
{
    btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
}

- (void)btnTouchCancel:(UIButton *)btn
{
    btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
}

- (void)btnTouchDragExit:(UIButton *)btn
{
    btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
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
