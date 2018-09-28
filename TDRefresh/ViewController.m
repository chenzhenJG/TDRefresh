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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) int count;
@end

@implementation ViewController
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 20;
    [self.view addSubview:self.tableview];
    adjustsScrollViewInsets_NO(self.tableview, self);
     __unsafe_unretained typeof(self) vc = self;
    [self.tableview addHeaderWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.tableview headerEndRefreshing];
        });
    }];
    [self.tableview addAutoFooterWithCallbak:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.tableview footerEndRefreshing];
            vc.count += 5;
            [vc.tableview reloadData];
        });
    } isAuto:NO];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    return cell;
}

@end
