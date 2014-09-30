//
//  CUSSegmentControl.h
//  CUSUI
//
//  Created by wangjun on 14-9-10.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUSSegmentControlDelegate;

@interface CUSSegmentControl : UIView

/**
 *  标题数组
 */
@property (nonatomic, strong) NSArray *titleArray;

/**
 *  普通状态下，标题颜色  默认[UIColor grayColor]
 */
@property (nonatomic, strong) UIColor *normalTitleColor;

/**
 *  选中状态下，标题颜色  默认[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/**
 *  是否显示分割线，两个Title之间的 |  ，默认展示
 */
@property (nonatomic, assign) BOOL showDivider;

/**
 *  分割线颜色   默认[UIColor grayColor]
 */
@property (nonatomic, strong) UIColor *dividerLineColor;

/**
 *  选中页切下的展示线  ___  默认[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *selectedLineColor;

/**
 *  委托
 */
@property (nonatomic, assign) id<CUSSegmentControlDelegate> delegate;

/**
 *  初始化方法，控件宽高默认  屏幕宽度*30
 *
 *  @param titles 标题数组
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithTitles:(NSArray *)titles;

/**
 *  初始化方法，控件高度可定制。由于这种控件一般都是跟屏幕一样宽的，这里就设定宽度固定为屏幕宽度了。高度可定制
 *
 *  @param frame  用户设置的尺寸
 *  @param titles 标题数组
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;

/**
 *  开放外部的Change方法，传入一个下标，自动滑动到改页切
 *
 *  @param index 需要滑动到的页切
 */
- (void)segmentControlSelectAtIndex:(NSInteger)index;

/**
 *  开始绘制方法，由于开放了其他的属性设置，所以需要在设置好之后，调用以下该方法
 */
- (void)deawUI;

@end

@protocol CUSSegmentControlDelegate <NSObject>

/**
 *  委托方法，选中
 *
 *  @param segment 当前实例
 *  @param index   选中的下标
 */
- (void)segmentControl:(CUSSegmentControl *)segment didSelectAtIndex:(NSInteger)index;

@end
