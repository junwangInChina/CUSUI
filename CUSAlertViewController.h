//
//  CUSAlertViewController.h
//  CUSUI
//
//  Created by wangjun on 14-7-14.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的AlertView，继承于CUSBasePopupViewController
 *  仿iOS7上的原生警告框
 *  有单独按钮与两个按钮两种模式
 *  委托的形式回掉
 */

#import "CUSBasePopupViewController.h"

@protocol CUSAlertViewControllerDelegate;

@interface CUSAlertViewController : CUSBasePopupViewController

@property (nonatomic, assign) id <CUSAlertViewControllerDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param  title               :标题
 *  @param  message             :内容
 *  @param  cancelButtonTitle   :取消按钮，名称
 *  @param  otherButtonTitle    :按钮名称
 *  @return 返回该实例
 *
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<CUSAlertViewControllerDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle;

/**
 *  初始化方法
 *
 *  @param  title               :标题
 *  @param  message             :内容
 *  @param  otherButtonTitle    :按钮名称
 *  @return 返回该实例
 *
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<CUSAlertViewControllerDelegate>)delegate
             otherButtonTitle:(NSString *)otherButtonTitle;

@end

@protocol CUSAlertViewControllerDelegate <NSObject>

@optional
/**
 *  定制的AlertView的委托方法，触发选择or取消
 *
 *  @param  alertViewController :当前实例
 *  @param  buttonIndex         :点击的第几个按钮
 *  @return 无
 *
 */
- (void)alertViewController:(CUSAlertViewController *)alertViewController
       clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
