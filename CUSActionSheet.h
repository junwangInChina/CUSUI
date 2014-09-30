//
//  CUSActionSheet.h
//  CUSUI
//
//  Created by wangjun on 14-7-29.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的ActionSheet，兼容iOS7以下的版本
 *  支持多按钮
 *  支持无标题
 *  最底部的按钮Tag默认为-1
 *
 *  PS，有个bug，就是按钮太多了，后面几个按钮的tag会找不到，不知道为什么
 */

#import <UIKit/UIKit.h>

@protocol CUSActionSheetDelegate;

@interface CUSActionSheet : UIView

@property (nonatomic, assign) id <CUSActionSheetDelegate> delegate;

/**
 *  重写初始化方法，DEPRECATED_IN_MAC_OS_X_VERSION_10_0_AND_LATER 表示方法弃用
 *
 *  @return 当前实例
 *
 */
- (id)initWithFrame:(CGRect)frame DEPRECATED_IN_MAC_OS_X_VERSION_10_0_AND_LATER;

/**
 *  初始化方法
 *
 *  @param  title       :Action标题
 *  @param  buttons     :选择按钮，可以有多个
 *  @param  otherButton :最底部的按钮，通常用于取消
 *  @param  delegate    :委托
 *  @return 当前实例
 *
 */
- (instancetype)initWithTitle:(NSString *)title
                      buttons:(NSArray *)buttons
                  otherButton:(NSString *)otherButton
                     delegate:(id<CUSActionSheetDelegate>)delegate;

/**
 *  展示方法
 *
 *  @param  view    :需要展示在哪个视图上
 *  @return 无
 *
 */
- (void)showInView:(UIView *)view;

@end

@protocol CUSActionSheetDelegate <NSObject>

/**
 *  委托方法
 *
 *  @param  action :当前Action本身
 *  @param  index  :点击的按钮下标
 *  @return 无
 *
 */
- (void)actionSheet:(CUSActionSheet *)action clickIndex:(NSInteger)index;

@end