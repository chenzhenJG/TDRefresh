//
//  TDRefreshFooterView.m
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//

#import "TDRefreshFooterView.h"
#import "TDRefreshConst.h"
@implementation TDRefreshFooterView
+ (instancetype)footer {
    return [[TDRefreshFooterView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)updateRect {
    [super updateRect];
    
     self.frame = CGRectMake(0,_scrollView.contentSize.height,_scrollView.bounds.size.width, refreshHeight);
    self.activityView.frame = CGRectMake(0, 0, self.bounds.size.width, refreshHeight);
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    CGFloat distance = 0;
    //内容高度小于屏幕高度
    if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
        CGFloat actionY = _scrollView.contentOffset.y;
        BOOL action = actionY != refreshHeight && actionY > 0;
        if (action) {
            distance = actionY;
            self.center = CGPointMake(self.center.x, _scrollView.bounds.size.height + distance/2.0f);
        }
    }else {//否则内容高度大于屏幕高度
        CGFloat targetOffsetY = _scrollView.contentSize.height - _scrollView.bounds.size.height;
        //当前滑动未超过底部
        if (_scrollView.contentOffset.y < targetOffsetY) {
            return;
        }
        distance = fabs(targetOffsetY - _scrollView.contentOffset.y);
        self.center = CGPointMake(self.center.x, _scrollView.contentSize.height + distance/2.0f);
    }
    if (self.state == TDRefreshStateRefreshing) {//如果是正在刷新就不执行后续方法
        return;
    }
    
//    _scrollViewOriginalInset = _scrollView.contentInset;
    NSLog(@"%f",distance);
    if (self.isAuto) {
        [self automaticRefreshing:distance];//自动刷新
    }else {
        [self manualRefreshing:distance];//手动刷新
    }
    
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    if (![[change objectForKey:@"new"] isEqual:[change objectForKey:@"old"]]) {
        CGFloat Y = _scrollView.bounds.size.height > _scrollView.contentSize.height ? _scrollView.bounds.size.height : _scrollView.contentSize.height;
        UIScrollView *scrollView = _scrollView;
        self.frame = CGRectMake(0,Y,scrollView.bounds.size.width, refreshHeight);
    }
}

- (void)startRefreshing {
    [super startRefreshing];
    self.state = TDRefreshStateRefreshing;
    UIScrollView *scrollView = _scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bounds.size.height, 0)];
        if (scrollView.contentSize.height < scrollView.bounds.size.height) {
             [scrollView setContentOffset:CGPointMake(0,self.bounds.size.height) animated:false];
        }else{
             [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height + self.bounds.size.height) animated:false];
        }
    }];
}

- (void)endRefreshing {
    [super endRefreshing];
    self.state = TDRefreshStatePulling;
    UIScrollView *scrollView = _scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        if (scrollView.contentSize.height < scrollView.bounds.size.height) {
            self.frame = CGRectMake(0, scrollView.bounds.size.height + refreshHeight, self.bounds.size.width, self.bounds.size.height);
        }else{
            self.frame = CGRectMake(0, scrollView.contentSize.height + refreshHeight, self.bounds.size.width, self.bounds.size.height);
        }
    }];
}

- (void)setState:(TDRefreshState)state {
    [super setState:state];
    switch (state) {
        case TDRefreshStatePulling:
            self.statusLabel.text = TDRefreshFooterStatePulling;
            [self.activityView stopAnimating];
            break;
        case TDRefreshStateWillRefresh:
            self.statusLabel.text = TDRefreshFooterStateWillRefresh;
            [self.activityView startAnimating];
            break;
        case TDRefreshStateRefreshing:
            self.statusLabel.text = TDRefreshFooterStateRefreshingRefresh;
            [self.activityView startAnimating];
            break;
        default:
            break;
    }
}

/**
 *  自动刷新，滑动超过10自动执行刷新
 */
- (void)automaticRefreshing:(CGFloat)distance {
    if (distance >= 10) {
        self.state = TDRefreshStateWillRefresh;
        [self startRefreshing];
    }else {
        self.state = TDRefreshStatePulling;
    }
}
/**
 *  手动刷新，滑动超过refreshHeight高度并且手指放开才执行刷新
 */
- (void)manualRefreshing :(CGFloat)distance{
    if (_scrollView.isDragging) {
        if (distance >= refreshHeight) {
            self.state = TDRefreshStateWillRefresh;
        }else {
            self.state = TDRefreshStatePulling;
        }
    }else {
        if (self.state == TDRefreshStateWillRefresh) {
            [self startRefreshing];
        }
    }
}
@end
