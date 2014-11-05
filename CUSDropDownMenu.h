//
//  CUSDropDownMenu.h
//  CUSUI
//
//  Created by wangjun on 14-11-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款下拉展示选项的菜单封装
 *  有多种组合展现形式
 *  CUSDropDownMenuOpenType、CUSDropDownMenuRotateType组合使用，会有不同的展示效果
 *  提供了4个委托方法，不够可扩展
 *  
 *  NSArray *dataArray = @[@{@"image":@"sun.png",@"title":@"Sun",@"detail":@"sun shine"},
                         @{@"image":@"clouds.png",@"title":@"Clouds",@"detail":@"more clouds"},
                         @{@"image":@"snow.png",@"title":@"Snow",@"detail":@"down snow"},
                         @{@"image":@"rain.png",@"title":@"Rain",@"detail":@"down rain"},
                         @{@"image":@"windy.png",@"title":@"Windy",@"detail":@"big windy"},];
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++)
    {
        NSDictionary *dict = dataArray[i];
 
        CUSDropDownItem *item = [[CUSDropDownItem alloc] init];
        [item setTextMessage:dict[@"title"]];
        [item setDetailMessage:dict[@"detail"]];
        [dropdownItems addObject:item];
    }
 
    self.dropMenu = [[CUSDropDownMenu alloc] initWithFrame:CGRectMake(60, 200, 200, 45)];
    _dropMenu.menuItem.textMessage = @"Choose Weather";
    _dropMenu.dropDownItems = dropdownItems;
    _dropMenu.paddingLeft = 15;
    _dropMenu.delegate = self;
    [_dropMenu reloadMenu];
 *
 */

#import <UIKit/UIKit.h>
#import "CUSDropDownItem.h"

/**
 *  枚举，菜单展开类型
 */
typedef NS_ENUM(NSInteger, CUSDropDownMenuOpenType)
{
    CUSDropDownMenuOpenTypeNormal,          /* 普通类型 */
    CUSDropDownMenuOpenTypeStack,           /* 堆栈式 向下拉开 */
    CUSDropDownMenuOpenTypeSlidingInBoth,   /* 从两侧滑入 */
    CUSDropDownMenuOpenTypeSlidingInLeft,   /* 从左侧滑入 */
    CUSDropDownMenuOpenTypeSlidingInRight,  /* 从右侧滑入 */
};

/**
 *  枚举，菜单展示类型
 */
typedef NS_ENUM(NSInteger, CUSDropDownMenuRotateType)
{
    CUSDropDownMenuRotateTypeNormal,        /* 普通类型，竖直向下展开 */
    CUSDropDownMenuRotateTypeLeft,          /* 向左，向左偏移 */
    CUSDropDownMenuRotateTypeRight,         /* 向右，向右偏移 */
    CUSDropDownMenuRotateTypeRandom         /* 随机，随机排列展开 */
};

@protocol CUSDropDownMenuDelegate;

@interface CUSDropDownMenu : UIControl

/**
 *  菜单主Item，收起时展示的那个
 */
@property (nonatomic, strong) CUSDropDownItem *menuItem;

/**
 *  Item的Size
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 *  Item中，控件坐偏移量 Default: 5pt
 */
@property (nonatomic, assign) CGFloat paddingLeft;

/**
 *  所有展开的Item数组
 */
@property (nonatomic, copy) NSArray *dropDownItems;

/**
 *  动画时间 Default: 0.3s
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 *  动画Options Default: UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
 */
@property (nonatomic, assign) UIViewAnimationOptions animationOption;

/**
 *  多个item动画执行延迟时间 Default: 0s
 */
@property (nonatomic, assign) CGFloat itemAnimationDelay;

/**
 *  展开后类型 Default: CUSDropDownMenuOpenTypeNormal
 */
@property (nonatomic, assign) CUSDropDownMenuOpenType openType;

/**
 *  展开时，翻转类型 Default: CUSDropDownMenuRotateTypeNormal
 */
@property (nonatomic, assign) CUSDropDownMenuRotateType rotateType;

/**
 *  滑动偏移量 Default: -1
 */
@property (nonatomic, assign) CGFloat slidingInOffset;

/**
 *  每个Item之间的间距 Default: 5pt
 */
@property (nonatomic, assign) CGFloat gutterY;                          // Item之间的间距

/**
 *  Item收起时，褶皱透明度 Default: －1
 */
@property (nonatomic, assign) CGFloat alphaOnFold;                      // 收起时，褶皱透明度

/**
 *  是否已经展开 Default: NO
 */
@property (nonatomic, assign, getter = isExpanding) BOOL expanding;     // 是否已经展开

/**
 *  Item，展开or收起时，是否翻转 Default: NO
 */
@property (nonatomic, assign, getter = shouldFlipWhenToggleView) BOOL flipWhenToggleView;

/**
 *  Item，展开or收起时，是否使用弹跳动画，7.0之后才支持 Default: YES
 */
@property (nonatomic, assign, getter = shouldSpringAnimation) BOOL springAnimation;

/**
 *  委托
 */
@property (nonatomic, assign) id<CUSDropDownMenuDelegate> delegate;   

/**
 *  重载菜单
 */
- (void)reloadMenu;

/**
 *  重置设置
 */
- (void)resetParams;

@end

@protocol CUSDropDownMenuDelegate <NSObject>

@optional

/**
 *  菜单将要展开
 *
 *  @return 返回是否允许展开
 */
- (void)dropDownMenuWillOpen;

/**
 *  菜单已经展开
 */
- (void)dropDownMenuDidOpen;

/**
 *  委托方法，将要点击某个item
 *
 *  @param menu 菜单
 *  @param item 点击的item
 *
 *  @return 返回是否允许继续
 */
- (void)dropDownMenu:(CUSDropDownMenu *)menu willSelectedItem:(CUSDropDownItem *)item;

/**
 *  委托方法，已经点击某个item
 *
 *  @param menu 菜单
 *  @param item 点击的item
 */
- (void)dropDownMenu:(CUSDropDownMenu *)menu DidSelectedItem:(CUSDropDownItem *)item;

@end

