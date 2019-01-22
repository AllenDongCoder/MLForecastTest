//
//  IDCMConfig.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#ifndef IDCMConfig_h
#define IDCMConfig_h
// 是否横竖屏
// 用户界面横屏了才会返回YES
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

// 屏幕宽度，跟横竖屏无关
#define DEVICE_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

// 屏幕高度，跟横竖屏无关
#define DEVICE_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
////============颜色
#define SetAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SetColor(r, g, b) SetAColor(r, g, b, 1)
//颜色RGB 16进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 随机色
#define SWRandomColor SetColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//黑色
#define textColor333333 UIColorFromRGB(0x333333)
//浅灰色
#define textColor666666 UIColorFromRGB(0x666666)
//淡灰色
#define textColor999999 UIColorFromRGB(0x999999)
//白色
#define textColorFFFFFF UIColorFromRGB(0xffffff)
//黑色
#define textColor000000 UIColorFromRGB(0x000000)

#define KPlaceHolderTwo             SetColor(128, 145, 156)
#define KPlaceHolderColor           SetColor(195, 205, 212)
#define KSecurityPlaceHolderColor   SetColor(128, 145, 156)

#define KBtnableColor               SetColor(46, 127, 208)
#define KBtnDisableColor            SetColor(91, 101, 113)
#define KBtnNormalColor             SetColor(36, 52, 71)
#define KBtnUnSelectColor           SetColor(110, 128, 139)

#define KPinGrayColor               SetColor(42, 52, 65)//PIN 灰色

#define BUYColor                    SetColor(26, 189, 147)//绿色
#define SELLColor                   SetColor(233, 122, 94)//红色

#define KCellBGColor                SetColor(18, 42, 76)
#define KbgViweColor                SetColor(8, 22, 41)

#define KLineColor                  SetColor(232, 232, 232)
#define KAppColor                   SetColor(32, 40, 51)
#define KGNavagationBarColor        SetColor(14, 33, 60)
#define KGrayColor                  SetColor(138, 138, 138)

////============字体
// 设置字体
#define SetFont(fontName,font)    [UIFont fontWithName:(fontName) size:(font)]
#define SetPingFangSCMedium(size) SetFont(@"PingFang-SC-Medium", (size))
#define SetPingFangSCRegular(size) SetFont(@"PingFang-SC-Regular", (size))
//字体 Medium
#define textFontPingFangMediumFont(fontsize)  SetFont(@"PingFang-SC-Medium", fontsize)
//字体 Regular
#define textFontPingFangRegularFont(fontsize)  SetFont(@"PingFang-SC-Regular", fontsize)
//字体 Helvetica-Light
#define textFontHelveticaLightFont(fontsize)  SetFont(@"HelveticaNeue-Light", fontsize)
//字体 Helvetica
#define textFontHelveticaMediumFont(fontsize)  SetFont(@"HelveticaNeue", fontsize)


// 懒加载
#define SW_LAZY(object, assignment) (object = object ?: assignment)

//国际化
#define LocalizedString(sting)    NSLocalizedString((sting), nil)?:@""

//获取服务地址
#define C2CAddressWithURL(URL) [[IDCMServerConfig getC2CServerAddr] stringByAppendingString:(URL)]

//获取storyBoad里控制器
#define GetVCFromSecurityStoryBoard(identifer)   [[UIStoryboard storyboardWithName:@"MeSecurity" bundle:nil] instantiateViewControllerWithIdentifier:(identifer)]
#define GetVCFromFindPasswordStoryBoard(identifer)   [[UIStoryboard storyboardWithName:@"ForgetPassword" bundle:nil] instantiateViewControllerWithIdentifier:(identifer)]
#define GetVCFromAssetsStoryBoard(identifer)   [[UIStoryboard storyboardWithName:@"Assets" bundle:nil] instantiateViewControllerWithIdentifier:(identifer)]

#define GetVCFromStoryBoard(identifer)   [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:(identifer)]
#define GetVCFromAssistantStoryBoard(identifer)   [[UIStoryboard storyboardWithName:@"Assistant" bundle:nil] instantiateViewControllerWithIdentifier:(identifer)]
#define GetVCFromCTCStoryBoard(identifer)   [[UIStoryboard storyboardWithName:@"CTC" bundle:nil] instantiateViewControllerWithIdentifier:(identifer)]

// 是否iPhone
#define IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define ISHaveFaceID  ([IDCMBioMetricAuthenticator faceIDAvailable])

#define IDCM_APPDelegate  ((AppDelegate*)[UIApplication sharedApplication].delegate)

// 获取屏幕宽度，高度
#define MainScreenRect       [UIScreen mainScreen].bounds

#define SCREEN_WIDTH_IDCW ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT_IDCW ([UIScreen mainScreen].bounds.size.height)


#define kIsIphoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kSafeAreaTop        kWindowSafeAreaInset.top
#define kSafeAreaBottom     kWindowSafeAreaInset.bottom
#define kTabBarHeight       49
#define kNavigationBarHeight            44
#define kWindowSafeAreaInset \
({\
UIEdgeInsets returnInsets = UIEdgeInsetsMake(20, 0, 0, 0);\
UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")] && kIsIphoneX) {\
UIEdgeInsets inset = [[keyWindow valueForKeyPath:@"safeAreaInsets"] UIEdgeInsetsValue];\
returnInsets = inset;\
}\
_Pragma("clang diagnostic pop") \
(returnInsets);\
})\
////============字体
// 设置字体
#define SetFont(fontName,font)    [UIFont fontWithName:(fontName) size:(font)]
#define SetPingFangSCMedium(size) SetFont(@"PingFang-SC-Medium", (size))
#define SetPingFangSCRegular(size) SetFont(@"PingFang-SC-Regular", (size))
//字体 Medium
#define textFontPingFangMediumFont(fontsize)  SetFont(@"PingFang-SC-Medium", fontsize)
//字体 Regular
#define textFontPingFangRegularFont(fontsize)  SetFont(@"PingFang-SC-Regular", fontsize)
//字体 Helvetica-Light
#define textFontHelveticaLightFont(fontsize)  SetFont(@"HelveticaNeue-Light", fontsize)
//字体 Helvetica
#define textFontHelveticaMediumFont(fontsize)  SetFont(@"HelveticaNeue", fontsize)
#ifndef weakify
#if __has_feature(objc_arc)

#define weakify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \\
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \\
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)

#define strongify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
try{} @finally{} __typeof__(x) x = __weak_##x##__; \\
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
try{} @finally{} __typeof__(x) x = __block_##x##__; \\
_Pragma("clang diagnostic pop")

#endif
#endif


#import "UIView+Extension.h"
#import "IDCMConfigBaseNavigationController.h"
#import "CityViewController.h"
#import "AreaModel.h"
#import "ForecastModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#endif /* IDCMConfig_h */
