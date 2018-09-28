//
//  UIScrollView+TDRefresh.m
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//

#import "UIScrollView+TDRefresh.h"
#import "TDRefreshFooterView.h"
#import "TDRefreshHeaderView.h"
#import <objc/runtime.h>
@interface UIScrollView()
@property (nonatomic,weak) TDRefreshHeaderView *header;
@property (nonatomic,weak) TDRefreshFooterView *footer;
@end

@implementation UIScrollView (TDRefresh)

static const char TDRefreshHeaderViewKey = '\0';
static const char TDRefreshFooterViewKey = '\0';


- (void)setFooter:(TDRefreshFooterView *)footer {
    [self willChangeValueForKey:@"TDRefreshFooterViewKey"];
    objc_setAssociatedObject(self, &TDRefreshFooterViewKey, footer, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TDRefreshFooterViewKey"];
}

- (TDRefreshFooterView *)footer {
    return objc_getAssociatedObject(self, &TDRefreshFooterViewKey);
}

#pragma mark -
#pragma mark - 下拉刷新
- (void)setHeader:(TDRefreshHeaderView *)header {
    [self willChangeValueForKey:@"TDRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &TDRefreshHeaderViewKey, header, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TDRefreshHeaderViewKey"];
}

- (TDRefreshHeaderView *)header {
    return objc_getAssociatedObject(self, &TDRefreshHeaderViewKey);
}
/**
 *  添加一个下拉刷新头部控件
 */
- (void)addHeaderWithCallback:(void (^)(void))callback {
    if (!self.header) {
        TDRefreshHeaderView *header = [TDRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    self.header.refreshingBlock = callback;
}

/**
 *  添加一个上拉刷新控件
 */
- (void)addAutoFooterWithCallbak:(void (^)(void))callback isAuto:(BOOL)isAuto {
    if (!self.footer) {
        TDRefreshFooterView *footer = [TDRefreshFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    self.footer.isAuto = isAuto;
    self.footer.refreshingBlock = callback;
}

- (void)addFooterWithCallbak:(void (^)(void))callback {
    [self addAutoFooterWithCallbak:callback isAuto:NO];
}



- (void)headerStartRefreshing {
    [self.header startRefreshing];
}

- (void)headerEndRefreshing {
    [self.header endRefreshing];
}

- (void)footerStartRefreshing {
    [self.header startRefreshing];
}

- (void)footerEndRefreshing {
    [self.footer endRefreshing];
}
@end
