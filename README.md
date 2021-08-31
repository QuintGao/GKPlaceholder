# GKPlaceholder

[![CI Status](https://img.shields.io/travis/1094887059@qq.com/GKPlaceholder.svg?style=flat)](https://travis-ci.org/1094887059@qq.com/GKPlaceholder)
[![Version](https://img.shields.io/cocoapods/v/GKPlaceholder.svg?style=flat)](https://cocoapods.org/pods/GKPlaceholder)
[![License](https://img.shields.io/cocoapods/l/GKPlaceholder.svg?style=flat)](https://cocoapods.org/pods/GKPlaceholder)
[![Platform](https://img.shields.io/cocoapods/p/GKPlaceholder.svg?style=flat)](https://cocoapods.org/pods/GKPlaceholder)

## 一行代码实现UIScrollView空数据占位图

* 1、支持图片、标题、描述、按钮多种组合方式    
* 2、支持动态设置显示位置  
* 3、自动适配安全区域
* 4、支持自定义视图显示

## Uses

```
self.tableView.gk_placeholder = [GKPlaceholder placeholderWithImage:@"message_placeholder" title:nil    detail:@"当前页面暂无数据" clickBlock:^{
    __strong __typeof(weakSelf) self = weakSelf;
    self.tableView.gk_isRefreshing = YES;
    [self.tableView.mj_header beginRefreshing];
}];
```

## Installation

GKPlaceholder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GKPlaceholder'
```

## Author

[QuintGao](https://github.com/QuintGao)

## License

GKPlaceholder is available under the MIT license. See the LICENSE file for more info.
