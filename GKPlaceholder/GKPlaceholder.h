//
//  GKPlaceholder.h
//  Example
//
//  Created by QuintGao on 2021/8/26.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKPlaceholder : UIView

/// headerView的高度
@property (nonatomic, assign) CGFloat headerHeight;

/// 占位视图的y值，默认居中
@property (nonatomic, assign) CGFloat contentY;

/// 是否适配安全区域，默认YES
@property (nonatomic, assign) BOOL adapterSafeArea;

/// 每个控件之前的间距，默认20
@property (nonatomic, assign) CGFloat defaultMargin;

/// 占位图点击回调
@property (nonatomic, copy) void(^clickBlock)(void);

#pragma mark - imageView
/// 图片对象（UIImage）或名称（NSString）
@property (nonatomic, strong) id image;

/// 图片大小，默认图片实际大小
@property (nonatomic, assign) CGSize imageSize;

#pragma mark - titleLabel
/// 标题文字
@property (nonatomic, copy) NSString *title;

/// 标题字体，默认16
@property (nonatomic, strong) UIFont *titleFont;

/// 标题文字颜色，默认
@property (nonatomic, strong) UIColor *titleColor;

/// 标题与图片间距，默认defaultMargin
@property (nonatomic, assign) CGFloat titleTopMargin;

#pragma mark - detailLabel
/// 描述文字
@property (nonatomic, strong) NSString *detail;

/// 详细描述字体，默认14
@property (nonatomic, strong) UIFont *detailFont;

/// 详细描述文字颜色
@property (nonatomic, strong) UIColor *detailColor;

/// 详细默认行数，默认2
@property (nonatomic, assign) NSInteger detailNumberOfLines;

/// 详细描述最大宽度，默认父视图宽度-40
@property (nonatomic, assign) CGFloat detailMaxWidth;

/// 详细描述与顶部控件的间距
@property (nonatomic, assign) CGFloat detailTopMargin;

#pragma mark - actionBtn
/// 操作按钮，需传入btnTitle才会创建
@property (nonatomic, strong) UIButton *actionBtn;

/// 操作按钮文字
@property (nonatomic, copy) NSString *actionTitle;

/// 操作按钮点击回调
@property (nonatomic, copy) void(^actionClickBlock)(void);

/// 操作按钮的宽度，直接设置actionBtn的frame无效
@property (nonatomic, assign) CGFloat actionBtnWidth;

/// 操作按钮的高度，直接设置actionBtn的frame无效
@property (nonatomic, assign) CGFloat actionBtnHeight;

/// 操作按钮与顶部控件的间距
@property (nonatomic, assign) CGFloat actionTopMargin;

#pragma mark - 初始化方法
/// 快速创建占位图
+ (instancetype)placeholder;

/// 快速创建占位图
/// @param image 图片对象或名称
/// @param title 标题
/// @param detail 描述
/// @param clickBlock 点击回调
+ (instancetype)placeholderWithImage:(id _Nullable)image title:(NSString *_Nullable)title detail:(NSString *_Nullable)detail clickBlock:(void(^_Nullable)(void))clickBlock;

/// 快速创建占位图
/// @param image 图片对象或名称
/// @param title 标题
/// @param detail 描述
/// @param actionTitle 操作按钮标题
/// @param actionClickBlock 操作按钮点击回调
+ (instancetype)placeholderWithImage:(id _Nullable)image title:(NSString *_Nullable)title detail:(NSString *_Nullable)detail actionTitle:(NSString *_Nullable)actionTitle actionClickBlock:(void(^_Nullable)(void))actionClickBlock;

/// 快速创建占位图
/// @param image 图片对象或名称
/// @param title 标题
/// @param detail 描述
/// @param actionTitle 操作按钮标题
/// @param actionClickBlock 操作按钮点击回调
/// @param clickBlock 占位图点击回调
+ (instancetype)placeholderWithImage:(id _Nullable)image title:(NSString *_Nullable)title detail:(NSString *_Nullable)detail actionTitle:(NSString *_Nullable)actionTitle actionClickBlock:(void (^)(void))actionClickBlock clickBlock:(void(^_Nullable)(void))clickBlock;

/// 快速创建自定义占位图
/// @param customView 自定义view
+ (instancetype)placeholderWithCustomView:(UIView *)customView;

/// 重新布局
- (void)resetLayout;

@end

@interface UIScrollView (GKPlaceholder)

/// 为UIScrollView添加占位图
@property (nonatomic, strong) GKPlaceholder *gk_placeholder;

/// UIScrollView是否正在刷新，如果为YES，占位图将不显示
@property (nonatomic, assign) BOOL gk_isRefreshing;

/// UITableView或UICollectionView数据源个数
- (NSInteger)gk_totalDataCount;

@end

NS_ASSUME_NONNULL_END
