//
//  GKViewController.m
//  GKPlaceholder
//
//  Created by QuintGao on 08/30/2021.
//  Copyright (c) 2021 QuintGao. All rights reserved.
//

#import "GKViewController.h"
#import <Masonry/Masonry.h>
#import "GKListViewController.h"
#import "GKRefreshViewController.h"

@interface GKViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"GKPlaceholder";
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.whiteColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.dataSource = @[@"图片",@"图片+标题", @"图片+标题+描述", @"图片+标题+描述+按钮", @"自定义", @"MJRefresh刷新"];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = nil;
    if (indexPath.row == 4) {
        GKListViewController *listVC = [GKListViewController new];
        listVC.customView = [self customView];
        vc = listVC;
    }else if (indexPath.row == 5) {
        GKRefreshViewController *refreshVC = [GKRefreshViewController new];
        vc = refreshVC;
    }else {
        GKListViewController *listVC = [GKListViewController new];
        listVC.image = @"message_placeholder";
        if (indexPath.row > 0) {
            listVC.pTitle = @"暂无数据";
            if (indexPath.row > 1) {
                listVC.detail = @"请稍后再试！";
            }
            if (indexPath.row > 2) {
                listVC.button = @"点击重试";
            }
        }
        vc = listVC;
    }
    vc.title = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIView *)customView {
    UIView *customView = [UIView new];
    customView.backgroundColor = [UIColor colorWithRed:21/255.0 green:24/255.0 blue:34/255.0 alpha:1.0f];
    customView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);

    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"dy_holder"];
    imgView.frame = CGRectMake((customView.frame.size.width - imgView.image.size.width) * 0.5, 160, imgView.image.size.width, imgView.image.size.height);
    [customView addSubview:imgView];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = @"网络错误";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [customView addSubview:label];
    label.frame = CGRectMake((customView.frame.size.width - label.frame.size.width) * 0.5, CGRectGetMaxY(imgView.frame) + 20, label.frame.size.width, label.frame.size.height);
    
    UILabel *descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:12.0f];
    descLabel.textColor = [UIColor grayColor];
    descLabel.text = @"请检查网络连接后重试";
    [descLabel sizeToFit];
    [customView addSubview:descLabel];
    descLabel.frame = CGRectMake((customView.frame.size.width - descLabel.frame.size.width) * 0.5, CGRectGetMaxY(label.frame) + 10, descLabel.frame.size.width, descLabel.frame.size.height);
    
    UIButton *retryBtn = [UIButton new];
    retryBtn.frame = CGRectMake((customView.frame.size.width - 200) * 0.5, CGRectGetMaxY(descLabel.frame) + 200, 200, 40);
    [retryBtn setTitle:@"重试" forState:UIControlStateNormal];
    [retryBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    retryBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    retryBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [customView addSubview:retryBtn];
    
    UIButton *lookBtn = [UIButton new];
    lookBtn.frame = CGRectMake(0, CGRectGetMaxY(retryBtn.frame) + 30, customView.frame.size.width, 40);
    [lookBtn setTitle:@"查看解决方案" forState:UIControlStateNormal];
    [lookBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [customView addSubview:lookBtn];
    
    return customView;
}

@end
