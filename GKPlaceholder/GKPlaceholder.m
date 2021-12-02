//
//  GKPlaceholder.m
//  Example
//
//  Created by QuintGao on 2021/8/26.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import "GKPlaceholder.h"
#import <objc/runtime.h>

// 默认子控件间距
#define kSubViewMargin      20.0f

// 标题样式
#define kTitleFont          [UIFont systemFontOfSize:16.0f]
#define kTitleColor         [UIColor blackColor]

// 描述样式
#define kDetailFont         [UIFont systemFontOfSize:14.0f]
#define kDetailColor        [UIColor grayColor]

// 操作样式
#define kActionFont         [UIFont systemFontOfSize:14.0f]
#define kActionColor        [UIColor blackColor]
#define kActionBgColor      [UIColor whiteColor]
#define kActionWidth        120.0f
#define kActionHeight       40.0f

@interface GKPlaceholder()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *customView;

@end

@implementation GKPlaceholder

+ (instancetype)placeholder {
    return [[self alloc] init];
}

+ (instancetype)placeholderWithImage:(id)image title:(NSString *)title clickBlock:(void (^)(void))clickBlock {
    return [[self alloc] initWithImage:image title:title detail:nil clickBlock:clickBlock actionTitle:nil actionClickBlock:nil];
}

+ (instancetype)placeholderWithImage:(id)image title:(NSString *)title detail:(NSString *)detail clickBlock:(void (^)(void))clickBlock {
    return [[self alloc] initWithImage:image title:title detail:detail clickBlock:clickBlock actionTitle:nil actionClickBlock:nil];
}

+ (instancetype)placeholderWithImage:(id)image title:(NSString *)title detail:(NSString *)detail actionTitle:(NSString *)actionTitle actionClickBlock:(void (^)(void))actionClickBlock {
    return [[self alloc] initWithImage:image title:title detail:detail clickBlock:nil actionTitle:actionTitle actionClickBlock:actionClickBlock];
}

+ (instancetype)placeholderWithImage:(id)image title:(NSString *)title detail:(NSString *)detail actionTitle:(NSString *)actionTitle actionClickBlock:(void (^)(void))actionClickBlock clickBlock:(void (^)(void))clickBlock {
    return [[self alloc] initWithImage:image title:title detail:detail clickBlock:clickBlock actionTitle:actionTitle actionClickBlock:actionClickBlock];
}

+ (instancetype)placeholderWithCustomView:(UIView *)customView {
    return [[self alloc] initWithCustomView:customView];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.contentView];
        
        self.adapterSafeArea = YES;
        self.defaultMargin = kSubViewMargin;
    }
    return self;
}

- (instancetype)initWithImage:(id)image title:(NSString *)title detail:(NSString *)detail clickBlock:(void(^)(void))clickBlock actionTitle:(NSString *)actionTitle actionClickBlock:(void(^)(void))actionClickBlock {
    if ([self init]) {
        self.clickBlock = clickBlock;
        // 图片
        self.image = image;
        // 标题
        self.title = title;
        // 详细描述
        self.detail = detail;
        // 操作按钮
        self.actionTitle = actionTitle;
        self.actionClickBlock = actionClickBlock;
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView {
    if ([self init]) {
        self.customView = customView;
        [self.contentView addSubview:customView];
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        [self addObservers];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.scrollView.frame.size.width == 0 || self.scrollView.frame.size.height == 0) return;
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height - self.headerHeight;
    self.frame = CGRectMake(0, self.headerHeight, width, height);
    
    CGFloat contentH = 0;
    
    if (self.customView) {
        CGRect frame = self.customView.frame;
        frame.origin.x = (width - self.customView.frame.size.width) * 0.5;
        frame.origin.y = 0;
        self.customView.frame = frame;
        contentH = frame.size.height;
        
        CGFloat contentY = self.contentY != 0 ? self.contentY : (height - contentH) * 0.5;
        if (@available(iOS 11.0, *)) {
            contentY = self.adapterSafeArea ? (contentY - self.scrollView.adjustedContentInset.top + self.scrollView.adjustedContentInset.bottom) : contentY;
        }
        self.contentView.frame = CGRectMake(0, contentY, width, contentH);
        return;
    }
    
    if (self.imageView) {
        CGSize imgSize = self.imageSize;
        if (CGSizeEqualToSize(imgSize, CGSizeZero)) {
            imgSize = self.imageView.image.size;
        }
        CGFloat imageX = (width - imgSize.width) * 0.5;
        self.imageView.frame = CGRectMake(imageX, 0, imgSize.width, imgSize.height);
        contentH += imgSize.height;
    }
    
    if (self.titleLabel) {
        contentH += self.titleTopMargin == 0 ? self.defaultMargin : self.titleTopMargin;
        self.titleLabel.font = self.titleFont ?: kTitleFont;
        self.titleLabel.textColor = self.titleColor ?: kTitleColor;
        self.titleLabel.frame = CGRectMake(0, contentH, width, self.titleLabel.font.lineHeight);
        contentH += self.titleLabel.font.lineHeight;
    }
    
    if (self.detailLabel) {
        contentH += self.detailTopMargin == 0 ? self.defaultMargin : self.detailTopMargin;
        self.detailLabel.font = self.detailFont ?: kDetailFont;
        self.detailLabel.textColor = self.detailColor ?: kDetailColor;
        
        CGFloat maxWidth = self.detailMaxWidth > 0 ? self.detailMaxWidth : (width - 40);
        CGSize detailSize = [self.detailLabel.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.detailLabel.font} context:nil].size;
        CGFloat detailX = (width - maxWidth) * 0.5;
        self.detailLabel.frame = CGRectMake(detailX, contentH, maxWidth, detailSize.height);
        contentH += detailSize.height;
    }
    
    if (self.actionBtn) {
        contentH += self.actionTopMargin == 0 ? self.defaultMargin : self.actionTopMargin;
        
        CGFloat btnW = self.actionBtnWidth == 0 ? kActionWidth : self.actionBtnWidth;
        CGFloat btnH = self.actionBtnHeight == 0 ? kActionHeight : self.actionBtnHeight;
        CGFloat btnX = (width - btnW) * 0.5;
        self.actionBtn.frame = CGRectMake(btnX, contentH, btnW, btnH);
        contentH += btnH;
    }
    
    CGFloat contentY = self.contentY != 0 ? self.contentY : (height - contentH) * 0.5;
    if (@available(iOS 11.0, *)) {
        CGFloat diff = self.scrollView.adjustedContentInset.top - self.scrollView.adjustedContentInset.bottom;
        if (contentY > diff) {
            contentY = self.adapterSafeArea ? (contentY - diff) : contentY;
        }
    }
    self.contentView.frame = CGRectMake(0, contentY, width, contentH);
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    !self.clickBlock ?: self.clickBlock();
}

- (void)btnAction:(id)sender {
    !self.actionClickBlock ?: self.actionClickBlock();
}

- (void)resetLayout {
    [self layoutSubviews];
}

#pragma mark - Setter
- (void)setClickBlock:(void (^)(void))clickBlock {
    _clickBlock = clickBlock;
    
    if (clickBlock) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setImage:(id)image {
    _image = image;
    
    UIImage *img = image;
    if ([image isKindOfClass:[NSString class]] && [image length] > 0) {
        img = [UIImage imageNamed:image];
    }
    if (!image) return;
    
    if (!self.imageView) {
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    self.imageView.image = img;
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (title.length == 0) return;
    
    if (!self.titleLabel) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    self.titleLabel.text = title;
    [self layoutSubviews];
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    
    if (detail.length == 0) return;
    
    if (!self.detailLabel) {
        self.detailLabel = [UILabel new];
        self.detailLabel.numberOfLines = 2;
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.detailLabel];
    }
    self.detailLabel.text = detail;
    [self layoutSubviews];
}

- (void)setDetailNumberOfLines:(NSInteger)detailNumberOfLines {
    NSAssert(self.detailLabel, @"请先设置detail属性");
    
    self.detailLabel.numberOfLines = detailNumberOfLines;
}

- (void)setActionTitle:(NSString *)actionTitle {
    _actionTitle = actionTitle;
    
    if (actionTitle.length == 0) return;
    
    if (!self.actionBtn) {
        self.actionBtn = [UIButton new];
        [self.actionBtn setTitleColor:kActionColor forState:UIControlStateNormal];
        self.actionBtn.titleLabel.font = kActionFont;
        self.actionBtn.backgroundColor = kActionBgColor;
        self.actionBtn.layer.borderColor = kActionColor.CGColor;
        self.actionBtn.layer.borderWidth = 1.0f;
        [self.contentView addSubview:self.actionBtn];
    }
    
    [self.actionBtn setTitle:actionTitle forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)setActionClickBlock:(void (^)(void))actionClickBlock {
    _actionClickBlock = actionClickBlock;
    
    if (actionClickBlock) {
        [self.actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - KVO
- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.scrollView addObserver:self forKeyPath:@"gk_isRefreshing" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"gk_isRefreshing"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.userInteractionEnabled) return;
    if ([keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"gk_isRefreshing"]) {
        if (self.scrollView.gk_isRefreshing) {
            self.hidden = YES;
            return;
        }
        
        if ([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]]) {
            if (self.scrollView.gk_totalDataCount == 0) {
                self.hidden = NO;
            }else {
                self.hidden = YES;
            }
        }else {
            if ((int)self.scrollView.contentSize.height > (int)self.headerHeight) {
                self.hidden = YES;
            }else {
                self.hidden = NO;
            }
        }
    }
}

@end

@implementation UIScrollView (GKPlaceholder)

static const char GKPlaceholderKey = '\0';
- (void)setGk_placeholder:(GKPlaceholder *)gk_placeholder {
    if (gk_placeholder != self.gk_placeholder) {
        // 移除旧的，添加新的
        [self.gk_placeholder removeFromSuperview];
        [self addSubview:gk_placeholder];
        
        // 存储新的
        objc_setAssociatedObject(self, &GKPlaceholderKey, gk_placeholder, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (GKPlaceholder *)gk_placeholder {
    return objc_getAssociatedObject(self, &GKPlaceholderKey);
}

static const char GKIsRefreshingKey = '\0';
- (void)setGk_isRefreshing:(BOOL)gk_isRefreshing {
    objc_setAssociatedObject(self, &GKIsRefreshingKey, @(gk_isRefreshing), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)gk_isRefreshing {
    return [objc_getAssociatedObject(self, &GKIsRefreshingKey) boolValue];
}

- (NSInteger)gk_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end
