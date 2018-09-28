//
//  UIScrollView+TDRefresh.h
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TDRefresh)
- (void)addFooterWithCallbak:(void (^)(void))callback;
- (void)addAutoFooterWithCallbak:(void (^)(void))callback isAuto:(BOOL)isAuto;
- (void)footerStartRefreshing;
- (void)footerEndRefreshing;


- (void)addHeaderWithCallback:(void (^)(void))callback;
- (void)headerStartRefreshing;
- (void)headerEndRefreshing;
@end

NS_ASSUME_NONNULL_END
