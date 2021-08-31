//
//  GKListViewController.m
//  GKPlaceholder_Example
//
//  Created by QuintGao on 2021/8/31.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import "GKListViewController.h"
#import <Masonry/Masonry.h>
#import <GKPlaceholder/GKPlaceholder.h>

@interface GKListViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation GKListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.customView) {
        self.tableView.gk_placeholder = [GKPlaceholder placeholderWithCustomView:self.customView];
    }else {
        GKPlaceholder *placeholder = [GKPlaceholder placeholder];
        placeholder.image = self.image;
        placeholder.title = self.pTitle;
        placeholder.detail = self.detail;
        placeholder.actionTitle = self.button;
        self.tableView.gk_placeholder = placeholder;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)headerShowOrHide {
    self.rightBtn.selected = !self.rightBtn.selected;
    if (self.rightBtn.selected) {
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.gk_placeholder.headerHeight = self.headerView.frame.size.height;
        [self.tableView.gk_placeholder resetLayout];
    }else {
        self.tableView.tableHeaderView = nil;
        self.tableView.gk_placeholder.headerHeight = 0;
        [self.tableView.gk_placeholder resetLayout];
    }
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _headerView.backgroundColor = UIColor.redColor;
    }
    return _headerView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"显示header" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"隐藏header" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(headerShowOrHide) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn sizeToFit];
    }
    return _rightBtn;
}

@end
