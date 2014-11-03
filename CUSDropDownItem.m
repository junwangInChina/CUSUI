//
//  CUSDropDownItem.m
//  CUSUI
//
//  Created by wangjun on 14-11-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSDropDownItem.h"

@interface CUSDropDownItem()

@property (nonatomic, retain) UIView *itemBgView;           // 背景图
@property (nonatomic, strong) UIImageView *iconImageView;   // Icon
@property (nonatomic, strong) UILabel *textLabel;           // 主标题
@property (nonatomic, strong) UILabel *detailTextLabel;     // 副标题

@end

@implementation CUSDropDownItem
@synthesize index = _index;
@synthesize iconImage = _iconImage;
@synthesize textMessage = _textMessage;
@synthesize detailMessage = _detailMessage;
@synthesize paddingLeft = _paddingLeft;
@synthesize itemBgView = _itemBgView;
@synthesize iconImageView = _iconImageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (void)dealloc
{
    self.iconImageView = nil;
    self.textLabel = nil;
    self.detailTextLabel = nil;
    self.itemBgView = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    
}

#pragma mark - UI
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.paddingLeft = 5;
        
        [self initView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.itemBgView setFrame:self.bounds];
    
    [self updateLayout];
}

- (void)initView
{
    _itemBgView = [[UIView alloc] init];
    _itemBgView.userInteractionEnabled = NO;
    _itemBgView.backgroundColor = [UIColor whiteColor];
    _itemBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _itemBgView.layer.shadowOffset = CGSizeMake(0, 0);
    _itemBgView.layer.shadowOpacity = 0.2;
    _itemBgView.layer.shouldRasterize = YES;
    [_itemBgView setFrame:self.bounds];
    [self addSubview:_itemBgView];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_iconImageView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.numberOfLines = 1;
    _textLabel.textColor = [UIColor grayColor];
    [self addSubview:_textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    _detailTextLabel.numberOfLines = 1;
    _detailTextLabel.textColor = [UIColor grayColor];
    [self addSubview:_detailTextLabel];
    
    [self updateLayout];
}

#pragma mark - Update Layout
- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    [self.iconImageView setImage:iconImage];
    
    [self updateLayout];
}

- (void)setTextMessage:(NSString *)textMessage
{
    _textMessage = textMessage;
    [self.textLabel setText:textMessage];
    
    [self updateLayout];
}

- (void)setDetailMessage:(NSString *)detailMessage
{
    _detailMessage = detailMessage;
    [self.detailTextLabel setText:detailMessage];
    
    [self updateLayout];
}

- (void)setPaddingLeft:(CGFloat)paddingLeft
{
    _paddingLeft = paddingLeft;
    
    [self updateLayout];
}

- (void)updateLayout
{
    //CGFloat self_Width = CGRectGetWidth(self.bounds);
    CGFloat self_Height = CGRectGetHeight(self.bounds);
    
    if (self.iconImage && self.textMessage && self.detailMessage)
    {
        /*
         [self.iconImageView setFrame:CGRectMake(_paddingLeft, 0, self_Width, self_Height)];
         */
        
        [self.iconImageView setFrame:CGRectMake(_paddingLeft,
                                                8,
                                                30,
                                                30)];
        CGFloat labelLeft = CGRectGetMaxX(self.iconImageView.frame) + _paddingLeft;
        /*
         [self.textLabel setFrame:CGRectMake(labelLeft,
                                             0 ,
                                             selfWidth - labelLeft,
                                             selfHeight / 2.0)];
         [self.detailTextLabel setFrame:CGRectMake(labelLeft,
                                                   selfHeight / 2.0,
                                                   selfWidth - labelLeft,
                                                   selfHeight / 2.0)];
         */
        _textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        _detailTextLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        [_textLabel sizeToFit];
        [_detailTextLabel sizeToFit];
        
        [self.textLabel setFrame:CGRectMake(labelLeft,
                                            self_Height / 2.0 - CGRectGetHeight(_textLabel.frame) ,
                                            CGRectGetWidth(_textLabel.frame),
                                            CGRectGetHeight(_textLabel.frame))];
        [self.detailTextLabel setFrame:CGRectMake(labelLeft,
                                                  self_Height / 2.0,
                                                  CGRectGetWidth(_detailTextLabel.frame),
                                                  CGRectGetHeight(_detailTextLabel.frame))];
        
        
    }
    else if (!self.iconImage && self.textMessage && self.detailMessage)
    {
        /*
         [self.textLabel setFrame:CGRectMake(_paddingLeft,
                                             0 ,
                                             selfWidth - _paddingLeft,
                                             selfHeight / 2.0)];
         [self.detailTextLabel setFrame:CGRectMake(_paddingLeft,
                                                   selfHeight / 2.0,
                                                   selfWidth - _paddingLeft,
                                                   selfHeight / 2.0)];
         */
        _textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        _detailTextLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        [_textLabel sizeToFit];
        [_detailTextLabel sizeToFit];
        
        [self.textLabel setFrame:CGRectMake(_paddingLeft,
                                            self_Height / 2.0 - CGRectGetHeight(_textLabel.frame),
                                            CGRectGetWidth(_textLabel.frame),
                                            CGRectGetHeight(_textLabel.frame))];
        [self.detailTextLabel setFrame:CGRectMake(_paddingLeft,
                                                  self_Height / 2.0,
                                                  CGRectGetWidth(_detailTextLabel.frame),
                                                  CGRectGetHeight(_detailTextLabel.frame))];
        
        
    }
    else if (self.iconImage && self.textMessage && !self.detailMessage)
    {
        /*
         [self.iconImageView setFrame:CGRectMake(_paddingLeft, 0, self_Width, self_Height)];
         */
        
        [self.iconImageView setFrame:CGRectMake(_paddingLeft,
                                                8,
                                                30,
                                                30)];
        
        CGFloat labelLeft = CGRectGetMaxX(self.iconImageView.frame) + _paddingLeft;
        /*
         [self.textLabel setFrame:CGRectMake(labelLeft,
                                             0 ,
                                             selfWidth - labelLeft,
                                             selfHeight)];
         */
        
        _textLabel.font = [UIFont fontWithName:@"Arial" size:18];
        
        [_textLabel sizeToFit];
        
        [self.textLabel setFrame:CGRectMake(labelLeft,
                                            self_Height / 2.0 - CGRectGetHeight(_textLabel.frame) / 2.0 ,
                                            CGRectGetWidth(_textLabel.frame),
                                            CGRectGetHeight(_textLabel.frame))];
        
        
    }
    else if (!self.iconImage && self.textMessage && !self.detailMessage)
    {
        /*
         [self.textLabel setFrame:CGRectMake(_paddingLeft,
                                             0 ,
                                             selfWidth - _paddingLeft,
                                             selfHeight)];
         */
        
        _textLabel.font = [UIFont fontWithName:@"Arial" size:18];
        
        [_textLabel sizeToFit];
        
        [self.textLabel setFrame:CGRectMake(_paddingLeft,
                                            self_Height / 2.0 - CGRectGetHeight(_textLabel.frame) / 2.0 ,
                                            CGRectGetWidth(_textLabel.frame),
                                            CGRectGetHeight(_textLabel.frame))];
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
