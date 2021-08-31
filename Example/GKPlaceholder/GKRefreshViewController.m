//
//  GKRefreshViewController.m
//  GKPlaceholder_Example
//
//  Created by gaokun on 2021/8/31.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import "GKRefreshViewController.h"
#import <Masonry/Masonry.h>
#import <GKPlaceholder/GKPlaceholder.h>
#import <MJRefresh/MJRefresh.h>

@interface GKRefreshViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GKRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf) self = weakSelf;
        self.tableView.gk_isRefreshing = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.gk_isRefreshing = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    self.tableView.gk_isRefreshing = YES;
    self.tableView.gk_placeholder = [GKPlaceholder placeholderWithImage:@"message_placeholder" title:nil detail:@"当前页面暂无数据" clickBlock:^{
        __strong __typeof(weakSelf) self = weakSelf;
        self.tableView.gk_isRefreshing = YES;
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
