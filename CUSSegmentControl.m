//
//  CUSSegmentControl.m
//  CUSUI
//
//  Created by wangjun on 14-9-10.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSSegmentControl.h"

#define CUSSegmentedControl_Height 30
#define CUSSegmentedControl_Width  ([UIScreen mainScreen].bounds.size.width)
#define CUSButton_MinWidth         (CUSSegmentedControl_Width / 4)
#define CUSButton_DefaultTag       10086

@interface CUSSegmentControl()

@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) UIView *selectedLineView;
@property (nonatomic, assign) CGFloat segmentHeight;

@end

@implementation CUSSegmentControl

- (void)dealloc
{
    self.segmentScrollView = nil;
    self.buttonsArray = nil;
    self.titleArray = nil;
    self.selectedLineView = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect segmentFrame = CGRectMake(0, frame.origin.y, CUSSegmentedControl_Width, CUSSegmentedControl_Height);
    self = [super initWithFrame:segmentFrame];
    if (self)
    {
        self.segmentHeight = CUSSegmentedControl_Height;
        
        [self defaultSetting];
        
        self.titleArray = @[];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles
{
    CGRect segmentFrame = CGRectMake(0, 0, CUSSegmentedControl_Width, CUSSegmentedControl_Height);
    self = [super initWithFrame:segmentFrame];
    if (self)
    {
        self.segmentHeight = CUSSegmentedControl_Height;
        
        [self defaultSetting];
        
        self.titleArray = [NSArray arrayWithArray:titles];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    CGRect segmentFrame = CGRectMake(0, frame.origin.y, CUSSegmentedControl_Width, frame.size.height);
    self = [super initWithFrame:segmentFrame];
    if (self)
    {
        self.segmentHeight = frame.size.height;
        
        [self defaultSetting];
        
        self.titleArray = [NSArray arrayWithArray:titles];
    }
    return self;
}

- (void)defaultSetting
{
    self.normalTitleColor = [UIColor grayColor];
    self.selectedTitleColor = [UIColor blackColor];
    self.showDivider = YES;
    self.dividerLineColor = [UIColor grayColor];
    self.selectedLineColor = [UIColor blackColor];
}

- (void)deawUI
{
    self.userInteractionEnabled = YES;
    
    self.buttonsArray = [[NSMutableArray alloc] initWithCapacity:self.titleArray.count];
    
    CGFloat buttonWidth = CUSSegmentedControl_Width/[self.titleArray count];
    if (buttonWidth < CUSButton_MinWidth)
    {
        buttonWidth = CUSButton_MinWidth;
    }
    
    /**
     *  IOS7 上，在navigationBar，以及statusBar都显示的情况下，Navigation的当前VC，
     *  他的VC的view的子视图树的根部的第一个子视图，如果是Scrollview的话，
     *  这个scrollview的所有子视图都会被下移64个像素。
     *
     *  有两种处理方式：
     *  1: 将ScrollView的所有子视图上移64px
     *  2: 在ScrollView下面加一层View，代替为第一个子视图
     */
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    // 底部的ScrollView
    self.segmentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _segmentScrollView.backgroundColor = self.backgroundColor;
    _segmentScrollView.userInteractionEnabled = YES;
    _segmentScrollView.contentSize = CGSizeMake([self.titleArray count]*buttonWidth, self.segmentHeight);
    _segmentScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_segmentScrollView];
    
    // 按钮
    for (int i = 0; i<[self.titleArray count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, self.segmentHeight);
        [btn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = CUSButton_DefaultTag + i;
        btn.selected = (i == 0) ? YES : NO;
        [_segmentScrollView addSubview:btn];
        [_buttonsArray addObject:btn];
    }
    
    // 分割线，两个Title中间的分割竖线
    if (self.showDivider)
    {
        CGFloat deviderLineHeight = self.segmentHeight/3.0f;
        CGFloat originY = (self.segmentHeight - deviderLineHeight)/2;
        for (int i = 1; i<[self.titleArray count]; i++)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWidth-1.0f, originY, 1.0f, deviderLineHeight)];
            lineView.backgroundColor = self.dividerLineColor;
            [_segmentScrollView addSubview:lineView];
        }
    }
    
    // 选中线，当前选中的哪一个，下面有条线标识
    self.selectedLineView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, self.segmentHeight-1, buttonWidth-10.0f, 1.0f)];
    _selectedLineView.backgroundColor = self.selectedLineColor;
    [_segmentScrollView addSubview:_selectedLineView];
}

- (void)segmentControlSelectAtIndex:(NSInteger)index
{
    if (index <= [self.buttonsArray count] - 1)
    {
        UIButton *btn = [self.buttonsArray objectAtIndex:index];
        [self segmentedControlChange:btn];
    }
}

- (void)segmentedControlChange:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.buttonsArray)
    {
        if (subBtn != btn)
        {
            subBtn.selected = NO;
        }
    }
    
    CGRect rect4boottomLine = self.selectedLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x +5;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - CUSButton_DefaultTag) >= 2 &&
        [_buttonsArray count] > 4 &&
        [_buttonsArray count] >
        (btn.tag - CUSButton_DefaultTag + 2))
    {
        pt.x = btn.frame.origin.x - CUSButton_MinWidth*1.5f;
        canScrolle = YES;
    }
    else if ([_buttonsArray count] > 4 &&
             (btn.tag - CUSButton_DefaultTag + 2) >= [_buttonsArray count])
    {
        pt.x = (_buttonsArray.count - 4) * CUSButton_MinWidth;
        canScrolle = YES;
    }
    else if (_buttonsArray.count > 4 &&
             (btn.tag - CUSButton_DefaultTag) < 2)
    {
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _segmentScrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.selectedLineView.frame = rect4boottomLine;
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedLineView.frame = rect4boottomLine;
        }];
    }
    
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(segmentControl:didSelectAtIndex:)])
    {
        [self.delegate segmentControl:self
                     didSelectAtIndex:(btn.tag - CUSButton_DefaultTag)];
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
