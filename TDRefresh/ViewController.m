//
//  ViewController.m
//  TDRefresh
//
//  Created by chenzhen on 2018/9/27.
//  Copyright © 2018 站在巨人肩膀. All rights reserved.
//
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)
#import "ViewController.h"
#import "TDRefresh.h"

@interface ViewController ()
@property (nonatomic,strong) UIScrollView *tableview;
@end

@implementation ViewController
- (UIScrollView *)tableview {
    if (!_tableview) {
        _tableview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _tableview.backgroundColor = [UIColor orangeColor];
        _tableview.contentSize = CGSizeMake(0, 10000);
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    adjustsScrollViewInsets_NO(self.tableview, self);
     __unsafe_unretained typeof(self) vc = self;
    [self.tableview addHeaderWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.tableview headerEndRefreshing];
        });
    }];
}


@end
