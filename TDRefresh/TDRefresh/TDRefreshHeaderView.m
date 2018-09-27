//
//  TDRefreshHeaderView.m
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//  下拉刷新视图

#import "TDRefreshHeaderView.h"
#import "TDRefreshConst.h"
@interface TDRefreshHeaderView() {
    
}
@end
@implementation TDRefreshHeaderView

+ (instancetype)header {
    return [[TDRefreshHeaderView alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
    }
    return self;
}

- (void)updateRect {
    [super updateRect];
    self.backgroundColor = [UIColor redColor];
    self.statusLabel.frame = CGRectMake(0, 0, self.bounds.size.width, refreshHeight);
    self.center = CGPointMake(self.center.x, -refreshHeight/2);
}



- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    //向上滑动不执行下拉刷新方法
    if (_scrollView.contentOffset.y > 0) return;
    //当前拖拽的距离
    CGFloat distance = fabs(_scrollView.contentOffset.y + _scrollViewOriginalInset.top);
    NSLog(@"%f",distance);
    //如果当前状态在刷新中不执行后续方法
    if (self.state == TDRefreshStateRefreshing) return;
    //拖拽时，当拖拽距离大于高度时候切换成准备刷新状态
    if (_scrollView.isDragging) {
        if (distance <= refreshHeight) {
            self.state = TDRefreshStatePulling;
        }else {
            self.state = TDRefreshStateWillRefresh;
        }
    }
    //松开，如果是准备刷新状态，则刷新
    else {
        if (self.state == TDRefreshStateWillRefresh) {
            
            [self startRefreshing];
        }
    }
}

- (void)setState:(TDRefreshState)state {
    [super setState:state];
    switch (state) {
        case TDRefreshStatePulling:
            self.statusLabel.text = TDRefreshHeaderStatePulling;
            break;
        case TDRefreshStateWillRefresh:
            self.statusLabel.text = TDRefreshHeaderStateWillRefresh;
            break;
        case TDRefreshStateRefreshing:
            self.statusLabel.text = TDRefreshStateRefreshingRefresh;
            break;
        default:
            break;
    }
}

-(void)startRefreshing{
    [super startRefreshing];
    self.state = TDRefreshStateRefreshing;
    UIScrollView *scrollView = _scrollView;
    UIEdgeInsets edg = _scrollViewOriginalInset;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat top = edg.top + self.bounds.size.height;
        scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
        [scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
    }];
}

-(void)endRefreshing{
    [super endRefreshing];
    self.state = TDRefreshStatePulling;
    UIScrollView *scrollView = _scrollView;
    UIEdgeInsets edg = _scrollViewOriginalInset;
    [UIView animateWithDuration:0.3 animations:^{
        [scrollView setContentInset:edg];
        self.frame = CGRectMake(0, -refreshHeight, self.bounds.size.width, self.bounds.size.height);
    }];
}
@end
