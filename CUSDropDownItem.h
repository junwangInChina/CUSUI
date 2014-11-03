//
//  CUSDropDownItem.h
//  CUSUI
//
//  Created by wangjun on 14-11-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUSDropDownItem : UIControl

@property (nonatomic, assign) NSInteger index;          // Item下标
@property (nonatomic, assign) CGFloat paddingLeft;      // 左侧偏移量
@property (nonatomic, assign) UIImage *iconImage;       // Icon
@property (nonatomic, copy) NSString *textMessage;      // 主标题文案
@property (nonatomic, copy) NSString *detailMessage;    // 副标题文案

@end
