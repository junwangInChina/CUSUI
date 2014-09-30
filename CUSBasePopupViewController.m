//
//  CUSBasePopupViewController.m
//  CUSUI
//
//  Created by wangjun on 14-7-14.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSBasePopupViewController.h"

#define BASEPOPVIEW_HEIGHT  CUS_iPhone5 ? 568 : 480

@interface CUSBasePopupViewController ()

@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) UIView *popupView;
@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, assign) BOOL isDismiss;

@end

@implementation CUSBasePopupViewController

- (void)dealloc
{
    self.coverView = nil;
    self.popupView = nil;
    self.rootViewController = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)createContentView
{
    return nil;
}

- (CGPoint)popupViewCenter
{
    return CGPointMake(self.coverView.bounds.size.width / 2.0, self.coverView.bounds.size.height / 2.0);
}

- (CGFloat)cornerRadius
{
    return 1.0;
}

- (void)show
{
    [self presentView:[self createContentView]];
}

- (void)presentView:(UIView *)view
{
    UIWindow *window;
    
    // 获取 Window
    window = [UIApplication sharedApplication].keyWindow;
    // 如果已经弹出，则不再弹
    if ([window.rootViewController isKindOfClass:[self class]])
    {
        return;
    }
    
    UIViewController *controller = [window rootViewController];
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    self.view.frame = controller.view.bounds;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 设置背景
    self.coverView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, BASEPOPVIEW_HEIGHT)] autorelease];
    self.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.coverView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    [self.view addSubview:self.coverView];
    
    // 设置内容 View 与 TitleView
    self.popupView = [[[UIView alloc] initWithFrame:view.bounds] autorelease];
    self.popupView.layer.masksToBounds = YES;
    self.popupView.layer.cornerRadius = [self cornerRadius];
    self.popupView.clipsToBounds = YES;
    [self.popupView addSubview:view];
    self.popupView.center = [self popupViewCenter];
    [self.coverView addSubview:self.popupView];
    
    self.coverView.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.coverView.alpha = 1.0;
        
    }];
}

- (void)dismiss
{
    if (self.isDismiss)
    {
        return;
    }
    
    self.isDismiss = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.coverView.alpha = 0.0;
                         self.rootViewController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         
                         [self resertRootViewController];
                     }];
}

// 还原 RootViewController
- (void)resertRootViewController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
