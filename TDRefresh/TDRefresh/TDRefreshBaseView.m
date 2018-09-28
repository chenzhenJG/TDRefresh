//
//  TDRefreshBaseView.m
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//

#import "TDRefreshBaseView.h"
@interface TDRefreshBaseView() {
    __weak UILabel *_statusLabel;
    __weak UIActivityIndicatorView *_activityView;
}

@end
@implementation TDRefreshBaseView
-(instancetype)init{
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:16];
        statusLabel.text = @"刷新啦";
        statusLabel.textColor = [UIColor blackColor];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.bounds;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = refreshHeight;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        [self statusLabel];
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (![newSuperview isKindOfClass:[UIScrollView class]] && newSuperview) {
        return;
    }
    [self removeObservers];
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        
        [self updateRect];
        [self addObservers];
        
    }
    
}


- (void)updateRect{}

- (void)startRefreshing {
    
    if (_refreshingBlock) {
        _refreshingBlock();
    }
}

- (void)endRefreshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = TDRefreshStatePulling;
    });
}

#pragma mark - KVO
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:TDRefreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:TDRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:TDRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:TDRefreshKeyPathContentSize];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:TDRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }else if([keyPath isEqualToString:TDRefreshKeyPathContentSize]){
        [self scrollViewContentSizeDidChange:change];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
-(void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
@end
