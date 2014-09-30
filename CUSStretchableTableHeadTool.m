//
//  CUSStretchableTableHeadTool.m
//  CUSUI
//
//  Created by wangjun on 14-8-29.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSStretchableTableHeadTool.h"

@interface CUSStretchableTableHeadTool()
{
    CGRect initialFrame;
    CGFloat defaultHeight;
}

@property (nonatomic, strong) UITableView *userTableView;
@property (nonatomic, strong) UIView *userView;

@end

@implementation CUSStretchableTableHeadTool
@synthesize userTableView = _userTableView;
@synthesize userView = _userView;

- (void)dealloc
{
    self.userTableView = nil;
    self.userView = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)stretchTableHeadView:(UITableView *)tableView headView:(UIView *)view
{
    _userTableView = tableView;
    _userView = view;
    
    initialFrame = view.frame;
    defaultHeight = initialFrame.size.height;
    
    UIView *emptyHeadView = [[UIView alloc] initWithFrame:initialFrame];
    _userTableView.tableHeaderView = emptyHeadView;
    
    [_userTableView addSubview:_userView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect headFrame = _userView.frame;
    headFrame.size.width = _userTableView.frame.size.width;
    _userView.frame = headFrame;
    
    if (scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initialFrame.origin.y = offsetY * -1;
        initialFrame.size.height = defaultHeight + offsetY;
        _userView.frame = initialFrame;
    }
}

- (void)resizeView
{
    initialFrame.size.width = _userTableView.frame.size.width;
    _userView.frame = initialFrame;
}

@end
