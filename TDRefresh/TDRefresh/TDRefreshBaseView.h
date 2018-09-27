//
//  TDRefreshBaseView.h
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TDRefreshingBlock)(void);

@class TDRefreshBaseView;
typedef NS_ENUM(NSInteger,TDRefreshState) {
    TDRefreshStatePulling = 1,
    TDRefreshStateWillRefresh,//即将刷新
    TDRefreshStateRefreshing
};
//刷新控件高度
static CGFloat refreshHeight = 64.0;
//KVO
static NSString *TDRefreshKeyPathContentOffset = @"contentOffset";
static NSString *TDRefreshKeyPathContentSize = @"contentSize";

@interface TDRefreshBaseView : UIView {
    __weak UIScrollView *_scrollView;
    UIEdgeInsets _scrollViewOriginalInset;
}
/** 刷新状态 */
@property (nonatomic,assign) TDRefreshState state;
/** 刷新回调 */
@property (nonatomic,strong) TDRefreshingBlock refreshingBlock;

@property (nonatomic, weak, readonly) UILabel *statusLabel;

//开始刷新
-(void)startRefreshing NS_REQUIRES_SUPER;
//结束刷新
-(void)endRefreshing NS_REQUIRES_SUPER;

//更新Frame
-(void)updateRect NS_REQUIRES_SUPER;

//scrollView滚动
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
-(void)scrollViewContentSizeDidChange:(NSDictionary *)change;
@end

NS_ASSUME_NONNULL_END
