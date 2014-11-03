//
//  CUSDropDownMenu.m
//  CUSUI
//
//  Created by wangjun on 14-11-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSDropDownMenu.h"

@interface CUSDropDownMenu()

@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, strong) CUSDropDownItem *chooseItem;

@end

@implementation CUSDropDownMenu

- (void)dealloc
{
    self.menuItem = nil;
    self.dropDownItems = nil;
    self.chooseItem = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.menuItem = [[CUSDropDownItem alloc] init];
        [self resetParams];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.menuItem = [[CUSDropDownItem alloc] init];
        [self resetParams];
        
        [self setFrame:frame];
    }
    return self;
}

#pragma mark - Public Method
- (void)setExpanding:(BOOL)expanding
{
    _expanding = expanding;
    
    [self updateView];
}

- (CGFloat)alphaOnFold
{
    if (_alphaOnFold != -1)
    {
        return _alphaOnFold;
    }
    else if ([self chooseSlideType])
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

- (void)resetParams
{
    self.frame = _oldFrame;
    self.offsetX = 0;
    
    self.animationDuration = 0.3;
    self.itemAnimationDelay = 0.0;
    self.animationOption = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState;
    self.openType = CUSDropDownMenuOpenTypeNormal;
    self.rotateType = CUSDropDownMenuRotateTypeNormal;
    self.slidingInOffset = -1;
    self.alphaOnFold = -1;
    self.gutterY = 0;
    self.flipWhenToggleView = NO;
    self.expanding = NO;
    self.chooseItem = nil;
}

- (void)reloadMenu
{
    if (self.isExpanding)
    {
        self.frame = self.oldFrame;
    }
    else
    {
        self.oldFrame = self.frame;
    }
    self.itemSize = self.frame.size;
    
    // Clear All Subviews
    for (UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    if (self.rotateType == CUSDropDownMenuRotateTypeLeft)
    {
        self.offsetX = self.dropDownItems.count * self.dropDownItems.count * self.itemSize.height / 28;
    }
    [self setFrame:CGRectMake(self.frame.origin.x - self.offsetX,
                              self.frame.origin.y,
                              self.frame.size.width + _gutterY,
                              self.frame.size.height)];
    
    for (int i = (int)self.dropDownItems.count - 1; i >= 0; i--)
    {
        CUSDropDownItem *item = self.dropDownItems[i];
        item.index = i;
        item.paddingLeft = _paddingLeft;
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setUpFoldItem:item];
        [self addSubview:item];
    }
    
    _menuItem.paddingLeft = self.paddingLeft;
    _menuItem.layer.anchorPoint = CGPointMake(0.5, 0);
    [_menuItem setFrame:CGRectMake(self.offsetX + 0, 0, self.itemSize.width, self.itemSize.height)];
    [_menuItem addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_menuItem];
    
    [self updateSelfFrame];
}

#pragma mark - Private Method
- (BOOL)chooseSlideType
{
    switch (self.openType)
    {
        case CUSDropDownMenuOpenTypeNormal:
        case CUSDropDownMenuOpenTypeStack:
            return NO;
            break;
        case CUSDropDownMenuOpenTypeSlidingInBoth:
        case CUSDropDownMenuOpenTypeSlidingInLeft:
        case CUSDropDownMenuOpenTypeSlidingInRight:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (void)updateSelfFrame
{
    CGFloat self_X = self.frame.origin.x;
    CGFloat self_Y = self.frame.origin.y;
    CGFloat self_Width = CGRectGetWidth(self.menuItem.frame);
    CGFloat self_Height = CGRectGetHeight(self.menuItem.frame);
    if (self.isExpanding)
    {
        for (CUSDropDownItem *item in self.dropDownItems)
        {
            if (item.alpha > 0)
            {
                self_Width = MAX(self_Width, CGRectGetMaxX(item.frame));
                self_Height = MAX(self_Height, CGRectGetMaxY(item.frame));
            }
        }
    }
    [self setFrame:CGRectMake(self_X, self_Y, self_Width, self_Height)];
}

- (void)updateView
{
    if (self.shouldFlipWhenToggleView)
    {
        [self flipMenuMainItem];
    }
    
    if (self.isExpanding)
    {
        [self expandView];
    }
    else
    {
        [self foldView];
    }
}

#pragma mark - Update UI

- (void)setUpFoldItem:(CUSDropDownItem *)item
{
    item.transform = CGAffineTransformMakeRotation(0);
    
    [item setFrame:[self itemFrameOnFoldAtIndex:item.index]];
    
    item.alpha = self.alphaOnFold;
}

- (void)setUpExpandItem:(CUSDropDownItem *)item
{
    item.alpha = 1.0;
    
    [item setFrame:[self itemFrameOnExpandAtIndex:item.index]];
    
    item.transform = [self itemTransformAtInxex:item.index];
}

- (CGRect)itemFrameOnFoldAtIndex:(NSInteger)index
{
    CGFloat item_X = self.offsetX;
    CGFloat item_Y = 0;
    CGFloat item_Width = self.itemSize.width;
    CGFloat item_Height = self.itemSize.height;
    
    NSInteger count = index >= 2 ? 2 : index;
    CGFloat slidingInOffect = self.slidingInOffset != -1 ? self.slidingInOffset : self.itemSize.width / 2;
    
    switch (self.openType) {
        case CUSDropDownMenuOpenTypeNormal:
            
            break;
        case CUSDropDownMenuOpenTypeStack:
            item_X += count * 2;
            item_Y = (count + 1) * 3;
            item_Width -= count * 4;
            break;
        case CUSDropDownMenuOpenTypeSlidingInBoth:
            if (index % 2 != 0)
            {
                slidingInOffect = -slidingInOffect;
            }
            item_X = slidingInOffect;
            item_Y = (index + 1) * (item_Height + self.gutterY);
            break;
        case CUSDropDownMenuOpenTypeSlidingInLeft:
            item_X = -slidingInOffect;
            item_Y = (index + 1) * (item_Height + self.gutterY);
            break;
        case CUSDropDownMenuOpenTypeSlidingInRight:
            item_X = slidingInOffect;
            item_Y = (index + 1) * (item_Height + self.gutterY);
            break;
        default:
            break;
    }
    return CGRectMake(item_X, item_Y, item_Width, item_Height);
}

- (CGRect)itemFrameOnExpandAtIndex:(NSInteger)index
{
    CGFloat item_X = 0;
    CGFloat item_Y = (index + 1) * (self.itemSize.height + self.gutterY);
    CGFloat item_Width = self.itemSize.width;
    CGFloat item_Height = self.itemSize.height;
    
    switch (self.rotateType)
    {
        case CUSDropDownMenuRotateTypeNormal:
            
            break;
        case CUSDropDownMenuRotateTypeLeft:
            item_X = self.offsetX + (-index * index * self.itemSize.height / 20.0);
            break;
        case CUSDropDownMenuRotateTypeRight:
            item_X = index * index * self.itemSize.height / 20.0;
            break;
        case CUSDropDownMenuRotateTypeRandom:
            item_X = floor([self randomAngle] * 11 -5);
            break;
            
        default:
            break;
    }
    return CGRectMake(item_X, item_Y, item_Width, item_Height);
}

- (CGAffineTransform)itemTransformAtInxex:(NSInteger)index
{
    CGFloat item_angle = 0;
    switch (self.rotateType)
    {
        case CUSDropDownMenuRotateTypeNormal:
            
            break;
        case CUSDropDownMenuRotateTypeLeft:
            item_angle = 5.0 * index / 180.0 * M_PI;
            break;
        case CUSDropDownMenuRotateTypeRight:
            item_angle = -5.0 * index / 180.0 * M_PI;
            break;
        case CUSDropDownMenuRotateTypeRandom:
            item_angle = floor([self randomAngle] * 11 - 5) / 180.0 * M_PI;
            break;
            
        default:
            break;
    }
    return CGAffineTransformMakeRotation(item_angle);
}

// 翻转Menu
- (void)flipMenuMainItem
{
    CABasicAnimation *menuItemAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    menuItemAnimation.autoreverses = YES;
    menuItemAnimation.duration = self.animationDuration;
    menuItemAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DPerspect(CATransform3DMakeRotation((M_PI_2/3*2), 1, 0, 0), CGPointMake(0, 0), 400)];
    [self.menuItem.layer addAnimation:menuItemAnimation forKey:nil];
}

// 展开菜单
- (void)expandView
{
    // 将要展开
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dropDownMenuWillOpen)])
    {
        [self.delegate dropDownMenuWillOpen];
    }
    
    // 展开操作
    for (int i = (int)self.dropDownItems.count - 1; i >= 0; i--)
    {
        CUSDropDownItem *item = self.dropDownItems[i];
        CGFloat delay = 0;
        if (self.shouldFlipWhenToggleView)
        {
            delay += 0.1;
        }
        if ([self chooseSlideType])
        {
            delay += self.itemAnimationDelay * i;
        }
        else
        {
            delay += self.itemAnimationDelay * (self.dropDownItems.count - i - 1);
        }
        
        [UIView animateWithDuration:self.animationDuration delay:delay options:self.animationOption animations:^{
            
            [self setUpExpandItem:item];
            
        } completion:^(BOOL finished) {
            
            [self updateSelfFrame];
        }];
    }
    
    // 已经展开
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dropDownMenuDidOpen)])
    {
        [self.delegate dropDownMenuDidOpen];
    }
}

// 收起菜单
- (void)foldView
{
    // 开始收起
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dropDownMenu:willSelectedItem:)])
    {
        [self.delegate dropDownMenu:self willSelectedItem:self.chooseItem];
    }
    
    // 收起操作
    for (int i = (int)self.dropDownItems.count - 1; i >= 0; i--)
    {
        CUSDropDownItem *item = self.dropDownItems[i];
        CGFloat delay = 0;
        if (self.shouldFlipWhenToggleView)
        {
            delay += 0.1;
        }
        if ([self chooseSlideType])
        {
            delay += self.itemAnimationDelay * (self.dropDownItems.count - i - 1);
        }
        else
        {
            delay += self.itemAnimationDelay * i;
        }
        
        [UIView animateWithDuration:self.animationDuration delay:delay options:self.animationOption animations:^{
            
            [self setUpFoldItem:item];
            
        } completion:^(BOOL finished) {
            
            [self updateSelfFrame];
        }];
    }
}

#pragma mark - Touch Event Method

- (void)itemClick:(id)sender
{
    if (self.isExpanding)
    {
        CUSDropDownItem *item = (CUSDropDownItem *)sender;
        
        self.expanding = NO;
        self.chooseItem = item;
        
        // 收起完成
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(dropDownMenu:DidSelectedItem:)])
        {
            [self.delegate dropDownMenu:self DidSelectedItem:self.chooseItem];
        }
    }
}

- (void)toggleView:(id)sender
{
    self.expanding = !self.isExpanding;
}

#pragma mark - Tool Method

- (CGFloat)randomAngle
{
    return [self randomFloatBetween:0.0 andLarger:1.0];
}

- (CGFloat)randomFloatBetween:(CGFloat)startNum andLarger:(CGFloat)endNum
{
    int startVal = startNum * 10000;
    int endVal = endNum * 10000;
    
    int randomValue = startVal + (arc4random()%(endVal - startVal));
    
    float random_angle = randomValue / 10000.0;
    
    return random_angle;
}

CATransform3D CATransform3DPerspect(CATransform3D trans, CGPoint center, float disZ)
{
    return CATransform3DConcat(trans, CATransform3DMakePerspective(center, disZ));
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f / disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
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
