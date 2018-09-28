//
//  TDRefreshFooterView.h
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//  上拉刷新视图

#import "TDRefreshBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TDRefreshFooterView : TDRefreshBaseView
@property (nonatomic,assign) BOOL isAuto;//是否滑动加载
+ (instancetype)footer;
@end

NS_ASSUME_NONNULL_END
