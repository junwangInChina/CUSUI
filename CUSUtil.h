//
//  CUSUtil.h
//  CUSUI
//
//  Created by wangjun on 14-10-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  工具类
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CUSUtil : NSObject

/**
 *  类方法，单例模式获取工具类
 *
 *  @return 返回工具类对象
 */
+ (CUSUtil *)shareInstance;

/**
 *  获取当前设备名称  iPhone5、iPhone5s、iPhone6、iPhone6Plus
 *
 *  @return 返回当前设备的名称
 */
- (NSString *)machineName;

/**
 *  屏幕截图，默认截全屏
 *
 *  @return 返回截取的Image
 */
- (UIImage *)takeSnapshot;

/**
 *  屏幕截图，截取传入的View的图片，不传的话，就截全屏
 *
 *  @param view 需要截取图片的View，传入nil，表示截取全屏
 *
 *  @return 返回截取后的Image
 */
- (UIImage *)takeSnapshotOfView:(UIView *)view;

/**
 *  屏幕截图，截取传入的View的图片，支持制定区域截图，不传就截去全屏
 *
 *  @param view 需要截图的View，传入nil，表示截取全屏
 *  @param rect 需要截取的区域，传入CGRectZero 表示截取全部尺寸
 *
 *  @return 返回截取后的Image
 */
- (UIImage *)takeSnapshotOfView:(UIView *)view InRect:(CGRect)rect;



@end
