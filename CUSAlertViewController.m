//
//  CUSAlertViewController.m
//  CUSUI
//
//  Created by wangjun on 14-7-14.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSAlertViewController.h"

#define CANCEL_TAG              2012000
#define OK_TAG                  2012001

#define DEFAULT_WIDTH           270
#define DEFAULT_HEIGHT          CUS_iPhone5 ? 538 : 450
#define DEFAULT_TITLE_MARGIN    15
#define DEFAULT_TITLE_TOP       20
#define DEFAULT_MESSAGE_MARGIN  15
#define DEFAULT_MESSAGE_TOP     5
#define DEFAULT_BUTTON_HEIGHT   44

@interface CUSAlertViewController ()

@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *messageString;
@property (nonatomic, retain) NSString *okString;
@property (nonatomic, retain) NSString *cancelString;
@property (nonatomic, assign) BOOL isShowCancel;

@end

@implementation CUSAlertViewController
@synthesize delegate = _delegate;
@synthesize titleString = _titleString;
@synthesize messageString = _messageString;
@synthesize okString = _okString;
@synthesize cancelString = _cancelString;
@synthesize isShowCancel = _isShowCancel;

- (void)dealloc
{
    self.titleString = nil;
    self.messageString = nil;
    self.okString = nil;
    self.cancelString = nil;
    
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

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<CUSAlertViewControllerDelegate>)delegate
             otherButtonTitle:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        
        self.titleString = title;
        self.messageString = message;
        self.okString = otherButtonTitle;
        
        self.isShowCancel = NO;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<CUSAlertViewControllerDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        
        self.titleString = title;
        self.messageString = message;
        self.cancelString = cancelButtonTitle;
        self.okString = otherButtonTitle;
        
        self.isShowCancel = YES;
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
    // 背景
    UIView *alertView_ = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  DEFAULT_WIDTH,
                                                                  DEFAULT_HEIGHT)];
    alertView_.backgroundColor = CUS_color_e3e3e3;
    
    // ScrollView
    UIScrollView *scrollView_ = [[[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                DEFAULT_WIDTH,
                                                                                484)]
                                 autorelease];
    scrollView_.backgroundColor = [UIColor clearColor];
    [alertView_ addSubview:scrollView_];
    
    // Title
    UILabel *titleLabel = nil;
    CGSize titleSize;
    if (self.titleString && self.titleString.length > 0)
    {
        titleLabel = [self createLabelWithFrame:CGRectMake(DEFAULT_TITLE_MARGIN,
                                                           DEFAULT_TITLE_TOP,
                                                           DEFAULT_WIDTH - (2 * DEFAULT_TITLE_MARGIN),
                                                           50)
                                       andTitle:self.titleString];
        titleLabel.font = CUS_HELVETICANEUEBOLD_FONT(18);
        titleSize = [self getTitleLabelSize];
        
        CGFloat titleLeft;
        if (titleSize.width == DEFAULT_WIDTH - (2 * DEFAULT_TITLE_MARGIN))
        {
            titleLeft = DEFAULT_TITLE_MARGIN;
        }
        else
        {
            titleLeft = (DEFAULT_WIDTH - titleSize.width) / 2.0;
        }
        titleLabel.frame = CGRectMake(titleLeft,
                                      DEFAULT_TITLE_TOP,
                                      titleSize.width,
                                      titleSize.height);
        [scrollView_ addSubview:titleLabel];
    }
    
    // Message
    UILabel *messageLabel = [self createLabelWithFrame:CGRectMake(DEFAULT_MESSAGE_MARGIN,
                                                                  DEFAULT_MESSAGE_TOP,
                                                                  DEFAULT_WIDTH - (2 * DEFAULT_MESSAGE_MARGIN),
                                                                  50)
                                              andTitle:self.messageString];
    CGSize messageSize = [self getMessageLabelSize];
    
    messageLabel.frame = CGRectMake(DEFAULT_MESSAGE_MARGIN,
                                    DEFAULT_MESSAGE_TOP + DEFAULT_TITLE_TOP + titleSize.height,
                                    messageSize.width,
                                    messageSize.height);
    [scrollView_ addSubview:messageLabel];
    
    // Size 判断
    CGFloat realHeight = DEFAULT_TITLE_TOP + titleSize.height + DEFAULT_MESSAGE_TOP + messageSize.height;
    if (realHeight > scrollView_.frame.size.height)
    {
        scrollView_.contentSize = CGSizeMake(DEFAULT_WIDTH, realHeight);
        scrollView_.scrollEnabled = YES;
    }
    else
    {
        scrollView_.frame = CGRectMake(0, 0, DEFAULT_WIDTH, realHeight);
        scrollView_.contentSize = CGSizeMake(DEFAULT_WIDTH, realHeight);
        scrollView_.scrollEnabled = NO;
    }
    if (CUS_IOS7)
    {
        scrollView_.contentOffset = CGPointMake(0, 64);
    }
    
    // 分割线
    UIView *widthLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 scrollView_.frame.size.height + 5,
                                                                 DEFAULT_WIDTH,
                                                                 0.5)];
    widthLine.backgroundColor = CUS_color_b2b2b2;
    [alertView_ addSubview:widthLine];
    [widthLine release];
    
    // Button
    if (self.isShowCancel)
    {
        CGRect cancelFrame = CGRectMake(0,
                                        scrollView_.frame.size.height + widthLine.frame.size.height + 5,
                                        DEFAULT_WIDTH / 2,
                                        DEFAULT_BUTTON_HEIGHT);
        CGRect okFrame = CGRectMake(cancelFrame.size.width,
                                    cancelFrame.origin.y,
                                    DEFAULT_WIDTH / 2,
                                    DEFAULT_BUTTON_HEIGHT);
        CGRect lineFrame = CGRectMake(cancelFrame.size.width,
                                      cancelFrame.origin.y,
                                      0.5,
                                      DEFAULT_BUTTON_HEIGHT);
        
        UIButton *cancelButton = [self createButtonWithFrame:cancelFrame
                                                    andTitle:self.cancelString
                                                      andTag:CANCEL_TAG
                                                 andSelector:@selector(cancelButtonPress:)];
        [alertView_ addSubview:cancelButton];
        
        UIView *heightLine = [[UIView alloc] initWithFrame:lineFrame];
        heightLine.backgroundColor = CUS_color_b2b2b2;
        [alertView_ addSubview:heightLine];
        [heightLine release];
        
        UIButton *okButton = [self createButtonWithFrame:okFrame
                                                andTitle:self.okString
                                                  andTag:OK_TAG
                                             andSelector:@selector(okPress:)];
        [alertView_ addSubview:okButton];
    }
    else
    {
        CGRect okFrame = CGRectMake(0,
                                    scrollView_.frame.size.height + widthLine.frame.size.height + 5,
                                    DEFAULT_WIDTH,
                                    DEFAULT_BUTTON_HEIGHT);
        
        UIButton *okButton = [self createButtonWithFrame:okFrame
                                                andTitle:self.okString
                                                  andTag:OK_TAG
                                             andSelector:@selector(okPress:)];
        [alertView_ addSubview:okButton];
    }
    
    // 重新计算高度
    alertView_.frame = CGRectMake(0, 0, DEFAULT_WIDTH,scrollView_.frame.size.height + DEFAULT_BUTTON_HEIGHT + 5);
    
    return [alertView_ autorelease];
}

- (CGFloat)cornerRadius
{
    return 10.0;
}

- (UILabel *)createLabelWithFrame:(CGRect)labelFrame andTitle:(NSString *)text_
{
    UILabel *label_ = [[UILabel alloc] initWithFrame:labelFrame];
    label_.text = text_;
    label_.backgroundColor = [UIColor clearColor];
    label_.textColor = [UIColor blackColor];
    label_.textAlignment = NSTextAlignmentCenter;
    label_.font = CUS_HELVETICANEUE_FONT(13);
    label_.numberOfLines = 0;
    
    return [label_ autorelease];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame
                           andTitle:(NSString *)title
                             andTag:(NSInteger)tag
                        andSelector:(SEL)selector
{
    UIButton *button_ = [[UIButton alloc] initWithFrame:frame];
    [button_ setTitle:title forState:UIControlStateNormal];
    [button_ setTitleColor:CUS_color_007aff forState:UIControlStateNormal];
    [button_ setTag:tag];
    [button_ setShowsTouchWhenHighlighted:YES];
    [button_ addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [button_ autorelease];
}

- (CGSize)getTitleLabelSize
{
    if (self.titleString && self.titleString.length > 0)
    {
        CGSize maxSize = CGSizeMake(DEFAULT_WIDTH - (2 * DEFAULT_TITLE_MARGIN), DEFAULT_HEIGHT);
        CGSize realSize = [self.titleString sizeWithFont:CUS_HELVETICANEUEBOLD_FONT(18)
                                       constrainedToSize:maxSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
        return realSize;
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)getMessageLabelSize
{
    CGSize maxSize = CGSizeMake(DEFAULT_WIDTH - (2 * DEFAULT_MESSAGE_MARGIN), DEFAULT_HEIGHT);
    CGSize realSize = [self.messageString sizeWithFont:CUS_HELVETICANEUE_FONT(13)
                                     constrainedToSize:maxSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
    
    return realSize;
}

- (void)cancelButtonPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewController:clickedButtonAtIndex:)])
    {
        [self.delegate alertViewController:self clickedButtonAtIndex:(btn.tag-CANCEL_TAG)];
    }
    [self dismiss];
}

- (void)okPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewController:clickedButtonAtIndex:)])
    {
        [self.delegate alertViewController:self clickedButtonAtIndex:(btn.tag-CANCEL_TAG)];
    }
    [self dismiss];
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
