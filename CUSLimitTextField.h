//
//  CUSLimitTextField.h
//  CUSUI
//
//  Created by wangjun on 14-7-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的UITextField，继承于UITextField
 *  实现了TextField输入框字数的限制，支持中文联想、复制粘贴
 */

#import <UIKit/UIKit.h>

@interface CUSLimitTextField : UITextField

/**
 *  限制的输入字数
 */
@property (nonatomic, assign) NSInteger limit;

@end
