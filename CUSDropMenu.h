//
//  CUSDropMenu.h
//  CUSUI
//
//  Created by wangjun on 14-10-8.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款下拉悬浮菜单控件
 *  使用方式类似表格
 *  有Delegate与DataSource
 *  开放了部分属性控制
 *
 */

#import <UIKit/UIKit.h>

@interface CUSDropMenuIndexPath : NSObject

/**
 *  列
 */
@property (nonatomic, assign) NSInteger column;

/**
 *  行
 */
@property (nonatomic, assign) NSInteger row;

/**
 *  初始化方法
 *
 *  @param column 列
 *  @param row    行
 *
 *  @return 返回当前实例
 */
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;

/**
 *  类方法，获取行、列对应的IndexPath
 *
 *  @param column 列
 *  @param row    行
 *
 *  @return 返回对应的IndexPath
 */
+ (instancetype)indexPathForColumn:(NSInteger)column row:(NSInteger)row;

@end

@protocol CUSDropMenuDelegate;
@protocol CUSDropMenuDataSource;

@interface CUSDropMenu : UIView

/**
 *  箭头颜色 Default:blackColor
 */
@property (nonatomic, retain) UIColor *indicatorColor;

/**
 *  文案颜色 Default:blackColor
 */
@property (nonatomic, retain) UIColor *textColor;

/**
 *  分割线颜色 Default:blackColor
 */
@property (nonatomic, retain) UIColor *separatorColor;

/**
 *  CUSDropMenuDelegate
 */
@property (nonatomic, assign) id<CUSDropMenuDelegate> delegate;

/**
 *  CUSDropMenuDataSource
 */
@property (nonatomic, assign) id<CUSDropMenuDataSource> dataSource;

/**
 *  获取IndexPath对应的标题
 *
 *  @param indexPath IndexPath
 *
 *  @return 返回对应文案
 */
- (NSString *)titleForRowAtIndexPath:(CUSDropMenuIndexPath *)indexPath;

@end

@protocol CUSDropMenuDelegate <NSObject>

@optional
/**
 *  CUSDropMenuDelegate 方法，非必须实现
 *
 *  @param menu      当前菜单
 *  @param indexPath 点击的IndexPath
 */
- (void)dropMenu:(CUSDropMenu *)menu didSelectRowAtIndexPath:(CUSDropMenuIndexPath *)indexPath;

@end

@protocol CUSDropMenuDataSource <NSObject>

@optional
/**
 *  设置下拉菜单有几列，非必须实现，默认1列
 *
 *  @param menu 菜单
 *
 *  @return 返回设置的列数
 */
- (NSInteger)numberOfColumnsInDropMenu:(CUSDropMenu *)menu;

/**
 *  获取当前下拉菜单选中的那一栏，当栏目比较多，可自动滚动到下面，避免被挡住
 *
 *  @param menu   菜单
 *  @param column 第几列
 *  @param string 当前选中的文案，需要用来对比数据源，获取IndexPath
 *
 *  @return 返回选中那行的IndexPath
 */
- (NSIndexPath *)dropMenu:(CUSDropMenu *)menu
                   column:(NSInteger)column
                   string:(NSString *)string;

@required
/**
 *  设置下拉菜单每一列有几行，必须实现
 *
 *  @param menu   菜单
 *  @param column 列数
 *
 *  @return 返回当前列数对应的行数
 */
- (NSInteger)dropMenu:(CUSDropMenu *)menu numberOfRowsInColumn:(NSInteger)column;

/**
 *  设置下拉菜单每一行的标题文案，必须实现
 *
 *  @param menu      菜单
 *  @param indexPath CUSDropMenuIndexPath
 *
 *  @return 返回每一列、每一行，需要展示的文案
 */
- (NSString *)dropMenu:(CUSDropMenu *)menu titleForRowAtIndexPath:(CUSDropMenuIndexPath *)indexPath;

@end
