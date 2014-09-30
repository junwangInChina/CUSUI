//
//  CUSPopView.h
//  CUSUI
//
//  Created by wangjun on 14-9-28.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款PopView，类似iPad设备上的PopViewController
 *  支持传入Title数组、Icon数组
 *  支持定制线条颜色，箭头颜色
 *  支持自动适配方向，避免出界
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CUSPopViewOrientation)
{
    CUSPopViewOrientationPortrait = 1,
    CUSPopViewOrientationPortraitUpsideDown,
    CUSPopViewOrientationLandscapeLeft,
    CUSPopViewOrientationLandscapeRight,
};

typedef void(^PopViewBlock)(NSIndexPath *indexPath);

@protocol CUSPopViewDelegate;

@interface CUSPopView : UIView
{
    PopViewBlock popBlock;
}

/**
 *  委托
 */
@property (nonatomic, assign) id<CUSPopViewDelegate> delegate;

/**
 *  线的颜色
 */
@property (nonatomic, retain) UIColor *lineColor;

/**
 *  箭头填充色
 */
@property (nonatomic, retain) UIColor *fillColor;
/**
 *  初始化方法
 *
 *  @param point  弹出的原点，即箭头位置
 *  @param titles 标题数组
 *  @param images 图标数组
 *
 *  @return 返回该实例
 */
- (instancetype)initWithPoint:(CGPoint)point
                       titles:(NSArray *)titles
                       images:(NSArray *)images;

/**
 *  展示方法
 */
- (void)show;

/**
 *  隐藏方法
 */
- (void)dismiss;

/**
 *  Block回调方法
 *
 *  @param block 传入Block
 */
- (void)popDidSelectBlock:(PopViewBlock)block;

@end

@protocol CUSPopViewDelegate <NSObject>

/**
 *  委托方法，回调
 *
 *  @param popView   当前视图
 *  @param indexPath 点击的IndexPath
 */
- (void)popView:(CUSPopView *)popView didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

