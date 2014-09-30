//
//  CUSAssistiveTouch.m
//  CUSUI
//
//  Created by wangjun on 14-9-30.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSAssistiveTouch.h"
#import <UIKit/UIKit.h>

#define DEFAULT_SCALE   60
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define MENU_TAG        10010

static CUSAssistiveTouch *assistiveTouch;

@interface CUSAssistiveTouch()

@property (nonatomic, retain) UIWindow *assisBoardWindow;       // 最底部的Window层，用于展示
@property (nonatomic, retain) UIView *assisBoardView;           // 中间的View层，用于管理上层UI
@property (nonatomic, retain) UIImageView *assisBoardImageView; // 最顶部的ImageView，用于展示与触发点击

@property (nonatomic, assign) BOOL keyBoardON;                          // 用于标识键盘是否弹出
@property (nonatomic, assign) AssistiveTouchLocationType locationType;  // 用于标识悬浮按钮贴在那个边

@property (nonatomic, assign) CGRect moveWindowFrame;           // 移动后，Window的Frame
@property (nonatomic, assign) CGRect keyBoardONAssisBoardFrame; // 键盘弹出后，Window的Frame
@property (nonatomic, assign) CGSize keyBoardSize;              // 弹出键盘的尺寸

@property (nonatomic, retain) NSMutableArray *menuButtonArray;  // 悬浮菜单按钮数组
@property (nonatomic, retain) NSArray *menuImageArray;          // 悬浮菜单图片数组

@property (nonatomic, assign) BOOL menuON;                      // 用于标识悬浮菜单是否展开
@property (nonatomic, assign) BOOL animationON;                 // 用于标识悬浮菜单正在展开或收起

@property (nonatomic, retain) NSString *homeImage;              // 静止时图标
@property (nonatomic, retain) NSString *moveImage;              // 移动视图标

@end

@implementation CUSAssistiveTouch

+ (CUSAssistiveTouch *)shareInstance
{
    static dispatch_once_t onesToken;
    dispatch_once(&onesToken, ^{
        assistiveTouch = [[CUSAssistiveTouch alloc] init];
    });
    return assistiveTouch;
}

- (void)dealloc
{
    self.assisBoardWindow = nil;
    self.assisBoardView = nil;
    self.assisBoardImageView = nil;
    self.menuImageArray = nil;
    self.menuButtonArray = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 默认值设置
        self.menuON = NO;
        self.animationON = NO;
        self.keyBoardON = NO;
        self.locationType = AssistiveTouchLocationLeft;
        self.menuButtonArray = [NSMutableArray array];
        
        // 底层Window
        self.assisBoardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_SCALE, DEFAULT_SCALE)];
        _assisBoardWindow.backgroundColor = [UIColor clearColor];
        _assisBoardWindow.windowLevel = 3000;
        _assisBoardWindow.clipsToBounds = YES;
        _assisBoardWindow.hidden = YES;
        [_assisBoardWindow makeKeyAndVisible];
        
        // 中层View
        self.assisBoardView = [[UIView alloc] initWithFrame:_assisBoardWindow.bounds];
        _assisBoardView.backgroundColor = [UIColor clearColor];
        _assisBoardView.clipsToBounds = YES;
        [_assisBoardWindow addSubview:_assisBoardView];
        
        // 展示层ImageView
        self.assisBoardImageView = [[UIImageView alloc] initWithFrame:_assisBoardView.bounds];
        [self setImageWithMove:NO];
        _assisBoardImageView.userInteractionEnabled = YES;
        [_assisBoardView addSubview:_assisBoardImageView];
        
        // 手势，点击与移动
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAssistiveTouch:)];
        [_assisBoardImageView addGestureRecognizer:panGesture];
#if !__has_feature(objc_arc)
        [panGesture release];
#endif
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAssistiveTouch:)];
        [_assisBoardImageView addGestureRecognizer:tapGesture];
#if !__has_feature(objc_arc)
        [tapGesture release];
#endif
        
        // 通知，监控键盘的弹出收起
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyBoardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyBoardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}

#pragma mark - Public Method
- (void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        self.assisBoardWindow.alpha = 1.0;
    }];
    
}

- (void)showAssistiveTouch:(NSArray *)images
{
    [self queryHomeImage:images];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.assisBoardWindow.alpha = 1.0;
    }];
}

- (void)showFloatMenu:(NSArray *)menus
{
    [self queryHomeImage:menus];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:menus];
    if (array.count > 1)
    {
        [array removeObjectAtIndex:0];
        [array removeObjectAtIndex:0];
    }
    self.menuImageArray = array;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.assisBoardWindow.alpha = 1.0;
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        self.assisBoardWindow.alpha = 0.0;
    }];
}

#pragma mark - Private Method
- (void)queryHomeImage:(NSArray *)images
{
    if (images && images.count > 1)
    {
        self.homeImage = images[0];
        self.moveImage = images[1];
    }
    else if (images && images.count > 0)
    {
        self.homeImage = images[0];
        self.moveImage = images[0];
    }
    else
    {
        self.homeImage = nil;
        self.moveImage = nil;
    }
    
    [self setImageWithMove:NO];
}

- (void)setImageWithMove:(BOOL)isMove
{
    if (isMove)
    {
        if (self.moveImage && self.moveImage.length > 0)
        {
            _assisBoardImageView.backgroundColor = [UIColor clearColor];
            _assisBoardImageView.image = [UIImage imageNamed:self.moveImage];
        }
        else
        {
            _assisBoardImageView.backgroundColor = [UIColor redColor];
        }
        
    }
    else
    {
        if (self.homeImage && self.homeImage.length > 0)
        {
            _assisBoardImageView.backgroundColor = [UIColor clearColor];
            _assisBoardImageView.image = [UIImage imageNamed:self.homeImage];
        }
        else
        {
            _assisBoardImageView.backgroundColor = [UIColor blackColor];
        }
    }
}

- (void)shake:(UIView *)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-5, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+5, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    [animation setValue:@"toViewValue" forKey:@"toViewKey"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.1];
    [animation setRepeatCount:1];
    [lbl addAnimation:animation forKey:nil];
}

- (void)moveEnd:(UIView *)moveEndView
{
    if (moveEndView.frame.origin.y <= 40)
    {
        if (moveEndView.frame.origin.x < 0)
        {
            [moveEndView setCenter:(CGPoint){moveEndView.frame.size.width / 2.0, moveEndView.frame.size.height / 2.0}];
            self.locationType = AssistiveTouchLocationLeft;
        }
        else if (moveEndView.frame.origin.x + moveEndView.frame.size.width > SCREEN_WIDTH)
        {
            [moveEndView setCenter:(CGPoint){SCREEN_WIDTH - moveEndView.frame.size.width / 2.0, moveEndView.frame.size.height / 2.0}];
            self.locationType = AssistiveTouchLocationRight;
        }
        else
        {
            [moveEndView setCenter:(CGPoint){moveEndView.center.x,moveEndView.frame.size.height / 2.0}];
            self.locationType = AssistiveTouchLocationTop;
        }
    }
    else if (moveEndView.frame.origin.y + moveEndView.frame.size.height >= SCREEN_HEIGHT - 40)
    {
        if (moveEndView.frame.origin.x < 0)
        {
            [moveEndView setCenter:(CGPoint){moveEndView.frame.size.width / 2.0, SCREEN_HEIGHT - moveEndView.frame.size.height / 2.0}];
            self.locationType = AssistiveTouchLocationLeft;
        }
        else if (moveEndView.frame.origin.x + moveEndView.frame.size.width > SCREEN_WIDTH)
        {
            [moveEndView setCenter:(CGPoint){SCREEN_WIDTH - moveEndView.frame.size.width / 2.0, SCREEN_HEIGHT - moveEndView.frame.size.height / 2.0}];
            self.locationType = AssistiveTouchLocationRight;
        }
        else
        {
            [moveEndView setCenter:(CGPoint){moveEndView.center.x, SCREEN_HEIGHT - moveEndView.frame.size.height / 2.0}];
            self.locationType = AssistiveTouchLocationBottom;
        }
    }
    else
    {
        if (moveEndView.frame.origin.x + moveEndView.frame.size.width / 2.0 < SCREEN_WIDTH / 2.0)
        {
            if (moveEndView.frame.origin.x != 0)
            {
                [moveEndView setCenter:(CGPoint){moveEndView.frame.size.width / 2.0, moveEndView.center.y}];
            }
            self.locationType = AssistiveTouchLocationLeft;
        }
        else
        {
            if (moveEndView.frame.origin.x + moveEndView.frame.size.width != SCREEN_WIDTH)
            {
                [moveEndView setCenter:(CGPoint){SCREEN_WIDTH - moveEndView.frame.size.width / 2.0, moveEndView.center.y}];
            }
            self.locationType = AssistiveTouchLocationRight;
        }
    }
}

- (void)showMenu
{
    // 将最底层的Window铺满屏幕，中层用于展示的View保持不变
    self.moveWindowFrame = self.assisBoardWindow.frame;
    self.assisBoardWindow.frame = [[UIScreen mainScreen] bounds];
    self.assisBoardView.frame = self.moveWindowFrame;
    
    [self shake:self.assisBoardView];
    
    for (int i = 0; i < self.menuImageArray.count; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:self.moveWindowFrame];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:self.menuImageArray[i]] forState:UIControlStateNormal];
        [self.assisBoardWindow insertSubview:button aboveSubview:_assisBoardView];
        [self.menuButtonArray addObject:button];
        button.tag = i + MENU_TAG;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
#if !__has_feature(objc_arc)
        [button release];
#endif
    }
    [UIView animateWithDuration:0.25 animations:^{
        
        for (int i = 0; i < self.menuButtonArray.count; i++)
        {
            UIButton *tempButton = self.menuButtonArray[i];
            
            switch (self.locationType)
            {
                case AssistiveTouchLocationTop:
                    [tempButton setFrame:CGRectMake(self.moveWindowFrame.origin.x,
                                                    60 + 5 + 5 * i + 60 * i,
                                                    DEFAULT_SCALE,
                                                    DEFAULT_SCALE)];
                    break;
                case AssistiveTouchLocationLeft:
                    [tempButton setFrame:CGRectMake(60 + 5 + 5 * i + 60 * i,
                                                    self.moveWindowFrame.origin.y,
                                                    DEFAULT_SCALE,
                                                    DEFAULT_SCALE)];
                    break;
                case AssistiveTouchLocationBottom:
                    if (self.keyBoardON)
                    {
                        [tempButton setFrame:CGRectMake(self.moveWindowFrame.origin.x,
                                                        SCREEN_HEIGHT - self.keyBoardSize.height - 60 - 60 - 5 - (5 * i + 60 * i),
                                                        DEFAULT_SCALE,
                                                        DEFAULT_SCALE)];
                    }
                    else
                    {
                        [tempButton setFrame:CGRectMake(self.moveWindowFrame.origin.x,
                                                        SCREEN_HEIGHT - 60 - 60 - 5 - (5 * i + 60 * i),
                                                        DEFAULT_SCALE,
                                                        DEFAULT_SCALE)];
                    }
                    break;
                case AssistiveTouchLocationRight:
                    [tempButton setFrame:CGRectMake(SCREEN_WIDTH - 60 - 60 - 5 - (5 * i + 60 * i),
                                                    self.moveWindowFrame.origin.y,
                                                    DEFAULT_SCALE,
                                                    DEFAULT_SCALE)];
                    break;
                    
                default:
                    break;
            }
        }
        self.animationON = YES;
        
    } completion:^(BOOL finished) {
        
        // 完全展开后，在Window上加上点击手势，用于收起菜单
        UITapGestureRecognizer *windodTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTap:)];
        [self.assisBoardWindow addGestureRecognizer:windodTap];
#if !__has_feature(objc_arc)
        [windodTap release];
#endif
        self.menuON = YES;
        self.animationON = NO;
        
    }];
    
}

- (void)hiddenMenu
{
    [self shake:_assisBoardView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        for (int i = 0; i < self.menuButtonArray.count; i++)
        {
            UIButton *tempButton = self.menuButtonArray[i];
            [tempButton setFrame:CGRectMake(self.moveWindowFrame.origin.x,
                                            self.moveWindowFrame.origin.y,
                                            DEFAULT_SCALE,
                                            DEFAULT_SCALE)];
        }
        self.animationON = YES;
        
    } completion:^(BOOL finished) {
        
        for (int i = 0; i < self.menuButtonArray.count; i++)
        {
            UIButton *tempButton = self.menuButtonArray[i];
            [tempButton removeFromSuperview];
        }
        self.assisBoardWindow.frame = self.moveWindowFrame;
        self.assisBoardView.frame = CGRectMake(0, 0, DEFAULT_SCALE, DEFAULT_SCALE);
        [self.menuButtonArray removeAllObjects];
        [self.assisBoardWindow removeGestureRecognizer:[[_assisBoardWindow gestureRecognizers] lastObject]];
        
        self.menuON = NO;
        self.animationON = NO;
    }];
}

- (void)buttonAction:(UIButton *)button
{
    [self windowTap:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSASSISTIVETOUCHNOTIFICATION object:nil userInfo:@{TAP_INDEX:@(button.tag - MENU_TAG)}];
}

#pragma mark - UIGestureRecognizer
- (void)moveAssistiveTouch:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (self.menuON) return;
    
    UIView *moveView = panGestureRecognizer.view.superview.superview;
    [UIView animateWithDuration:0.25 animations:^{
        
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan ||
            panGestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
            CGPoint translation = [panGestureRecognizer translationInView:moveView.superview];
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:moveView.superview];
            [self setImageWithMove:YES];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if (self.assisBoardWindow.frame.origin.y + self.assisBoardWindow.frame.size.height >
                SCREEN_HEIGHT - self.keyBoardSize.height)
            {
                if (self.keyBoardON)
                {
                    if (moveView.frame.origin.x < 0)
                    {
                        [moveView setCenter:(CGPoint){moveView.frame.size.width / 2.0 , SCREEN_HEIGHT - self.keyBoardSize.height - self.assisBoardWindow.frame.size.height / 2.0}];
                    }
                    else if (moveView.frame.origin.x + moveView.frame.size.width > SCREEN_WIDTH)
                    {
                        [moveView setCenter:(CGPoint){SCREEN_WIDTH - moveView.frame.size.width / 2.0 , SCREEN_HEIGHT - self.keyBoardSize.height - self.assisBoardWindow.frame.size.height / 2.0}];
                    }
                    else
                    {
                        [moveView setCenter:(CGPoint){moveView.center.x , SCREEN_HEIGHT - self.keyBoardSize.height - self.assisBoardWindow.frame.size.height / 2.0}];
                    }
                    self.keyBoardONAssisBoardFrame = CGRectMake(self.assisBoardWindow.frame.origin.x,
                                                                SCREEN_HEIGHT - moveView.frame.size.height,
                                                                DEFAULT_SCALE,
                                                                DEFAULT_SCALE);
                    self.locationType = AssistiveTouchLocationBottom;
                }
                else
                {
                    [self moveEnd:moveView];
                    self.keyBoardONAssisBoardFrame = self.assisBoardWindow.frame;
                }
            }
            else
            {
                [self moveEnd:moveView];
                self.keyBoardONAssisBoardFrame = self.assisBoardWindow.frame;
            }
            [self setImageWithMove:NO];
        }
        
    }];
}

- (void)tapAssistiveTouch:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // 悬浮菜单数组有值，标识需要展开悬浮菜单
    if (self.menuImageArray && self.menuImageArray.count > 0)
    {
        if (!self.animationON)
        {
            if (!self.menuON)
            {
                [self showMenu];
            }
            else
            {
                [self hiddenMenu];
            }
        }
        _menuON = !_menuON;
    }
    // 悬浮菜单数组不存在，标识只是一个悬浮按钮
    else
    {
        [self shake:_assisBoardView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSASSISTIVETOUCHNOTIFICATION object:nil userInfo:@{TAP_INDEX:@0}];
    }
}

- (void)windowTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hiddenMenu];
    
    _menuON = !_menuON;
}

#pragma mark - NSNotificationCenter
-(void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *keyBoardDic = [notification userInfo];
    CGSize keySize = [[keyBoardDic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.keyBoardSize = keySize;
    self.keyBoardON = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.assisBoardWindow.frame.origin.y + self.assisBoardWindow.frame.size.height >
            SCREEN_HEIGHT - keySize.height)
        {
            [self.assisBoardWindow setFrame:CGRectMake(_assisBoardWindow.frame.origin.x,
                                                       SCREEN_HEIGHT - keySize.height - _assisBoardWindow.frame.size.height,
                                                       DEFAULT_SCALE,
                                                       DEFAULT_SCALE)];
        }
        
    }];
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    self.keyBoardON = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.assisBoardWindow setFrame:self.keyBoardONAssisBoardFrame];
    }];
}

@end
