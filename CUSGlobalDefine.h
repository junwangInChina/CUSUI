//
//  CUSGlobalDefine.h
//  CUSUI
//
//  Created by wangjun on 14-7-14.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 版本判断
/**
 *	@brief  版本判断
 */
#define CUS_Device  [[[UIDevice currentDevice] systemVersion] floatValue]
#define CUS_IOS7    CUS_Device >= 7.0

#define CUS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define CUS_iPhone  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define CUS_iPad    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#pragma mark - 屏幕尺寸
/**
 *	@brief  屏幕尺寸
 */
#define CUS_SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)
#define CUS_STATUS_BAR_HEIGHT   20
#define CUS_NAVIGATION_HEIGHT   44
#define CUS_TABBAR_HEIGHT       48
#define CUS_MAIN_BOUNDS         CGRectMake(0, IOS7 ? CUS_STATUS_BAR_HEIGHT : 0, 320, CUS_SCREEN_HEIGHT - CUS_STATUS_BAR_HEIGHT)
#define CUS_MAIN_NAV_BOUNDS     CGRectMake(0, IOS7 ? (CUS_STATUS_BAR_HEIGHT + CUS_NAVIGATION_HEIGHT) : 0, 320, CUS_SCREEN_HEIGHT - (CUS_STATUS_BAR_HEIGHT + CUS_NAVIGATION_HEIGHT))
#define CUS_MAIN_TAB_BOUNDS     CGRectMake(0, IOS7 ? (CUS_STATUS_BAR_HEIGHT + CUS_NAVIGATION_HEIGHT) : 0, 320, CUS_SCREEN_HEIGHT - (CUS_STATUS_BAR_HEIGHT + CUS_NAVIGATION_HEIGHT + CUS_TABBAR_HEIGHT))

#pragma mark - Color
/**
 *	@brief  Color
 */
#define CUS_color_b2b2b2 [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0]
#define CUS_color_e3e3e3 [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0]
#define CUS_color_007aff [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]

#pragma mark - Font
/**
 *	@brief  Font
 */
#define CUS_HELVETICANEUEBOLD_FONT(font)		[UIFont fontWithName:@"HelveticaNeue-Bold" size:font]	//加粗
#define CUS_HELVETICANEUE_FONT(font)			[UIFont fontWithName:@"HelveticaNeue" size:font]		//不加粗
