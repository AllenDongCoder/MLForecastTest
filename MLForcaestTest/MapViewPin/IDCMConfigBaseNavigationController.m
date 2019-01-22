//
//  IDCMConfigBaseNavigationController.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMConfigBaseNavigationController.h"


@interface IDCMConfigBaseNavigationController ()

@end

@implementation IDCMConfigBaseNavigationController

#pragma mark - Life CyCle
- (void)didInitialize
{
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = KGNavagationBarColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark - setView
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - Public Method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self setUpNavigationBarAppearance];
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = CGRectGetWidth([UIScreen mainScreen].bounds)/3;
    }

    [super pushViewController:viewController animated:YES];
}

#pragma mark - 设置全局的导航栏属性
- (void)setUpNavigationBarAppearance
{
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    NSDictionary *textAttributes = @{NSFontAttributeName:SetFont(@"PingFangSC-Medium", 18),
                                     NSForegroundColorAttributeName: UIColor.whiteColor
                                     };
    
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    navigationBarAppearance.translucent = NO;
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-MAXFLOAT, 0) forBarMetrics:UIBarMetricsDefault];
    // 全局设置去除导航栏底部的线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

}
#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
