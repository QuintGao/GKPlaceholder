//
//  GKListViewController.h
//  GKPlaceholder_Example
//
//  Created by QuintGao on 2021/8/31.
//  Copyright © 2021 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKListViewController : UIViewController

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *pTitle;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *button;
@property (nonatomic, strong) UIView *customView;

@end

NS_ASSUME_NONNULL_END
