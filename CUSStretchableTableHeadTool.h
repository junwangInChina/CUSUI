//
//  CUSStretchableTableHeadTool.h
//  CUSUI
//
//  Created by wangjun on 14-8-29.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  一款替换表格头的工具，用于将用户定制的View添加到表格头，主要功能是实现了表头的伸缩效果
 *  而不会随着表格向下滑动
 *
 *  使用方式:
 *  1:先分别定义一个表格、一个View
 *  2:调用 stretchTableHeadView: headView: 方法
 *
 *  self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)
 *                                                    style:UITableViewStylePlain];
 *  self.mainHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
 *
 *  self.stretTool = [CUSStretchableTableHeadTool new];
 *  [_stretTool stretchTableHeadView:_mainTableView headView:_mainHeadView];
 *  
 *  注意这个方法，主要靠它来实现拉伸效果
 *  - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *  {
 *      [_stretTool scrollViewDidScroll:scrollView];
 *  }
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CUSStretchableTableHeadTool : NSObject

/**
 *  设置方法，使用该方法，即可将定制好的表头设置到你自己的表格上，并且实现伸缩效果
 *
 *  @param tableView 需要设置的表格
 *  @param view      需要设置的表头
 */
- (void)stretchTableHeadView:(UITableView *)tableView headView:(UIView *)view;

/**
 *  滚动时的方法，用于实现表头的拉伸效果
 *
 *  @param scrollView scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 *  重置Frame
 */
- (void)resizeView;

@end
