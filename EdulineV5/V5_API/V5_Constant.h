//
//  V5_Constant.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EdulineV5_Tool.h"
#import <YYKit.h>
#import <MJRefresh.h>
#import <SDWebImage.h>
#import "Net_API.h"
#import "Api_Config.h"
#import "ZLPhoto.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "MBProgressHUD+Add.h"
#import "UIViewController+HUD.h"
#import "UIView+HUD.h"

#ifndef V5_Constant_h
#define V5_Constant_h

#define MainScreenHeight [EdulineV5_Tool sharedInstance].tsShowWindowsHeight
#define MainScreenWidth [EdulineV5_Tool sharedInstance].tsShowWindowsWidth
#define HeightRatio MainScreenHeight / 667.0
#define WidthRatio MainScreenWidth / 375.0

#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)
#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)

#define ShowNetError    [self showHudInView:self.view showHint:TEXT_NETWORK_ERROR]
#define ShowHud(X) [self showHudInView:self.view hint:(X)]
#define ShowMissHid(X) [self showHudInView:self.view showHint:(X)]
#define ShowInViewHud(X) [self showHudInView:self hint:(X)]
#define ShowInViewMiss(X) [self showHint:(X)]

#define Image(name) [UIImage imageNamed:name]
#define BasidColor [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]
#define BackColor [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]
#define RGBA(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define ShowNetError    [self showHudInView:self.view showHint:TEXT_NETWORK_ERROR]
#define ShowHud(X) [self showHudInView:self.view hint:(X)]
#define ShowMissHid(X) [self showHudInView:self.view showHint:(X)]
#define ShowInViewHud(X) [self showHudInView:self hint:(X)]
#define ShowInViewMiss(X) [self showHint:(X)]

// iPhoneX状态栏增加的高度
#define MACRO_UI_STATUSBAR_ADD_HEIGHT [EdulineV5_Tool statusBarAddHeightWithIPhoneX]
// iPhoneX状态栏高度
#define MACRO_UI_STATUSBAR_HEIGHT [EdulineV5_Tool statusBarHeightWithIPhoneX]
// 判断iPhoneX 并返回顶部高度
#define MACRO_UI_UPHEIGHT [EdulineV5_Tool upHeightWithIPhoneX]
// 判断iPhoneX 并返回刘海高度(30dp)
#define MACRO_UI_LIUHAI_HEIGHT [EdulineV5_Tool liuhaiHeightWithIPhoneX]
// 判断iPhoneX 并返回底部高度
#define MACRO_UI_TABBAR_HEIGHT [EdulineV5_Tool bottomHeightWithIPhoneX]
// 判断iPhoneX 并返回安全区高度
#define MACRO_UI_SAFEAREA [EdulineV5_Tool safeAreaWithIPhoneX]

// 微信分享
#define WXAppId @"wxbbb961a0b0bf577a"
#define WXAppSecret @"7ea0101aeabd53bc32859370cde278cc"
// QQ分享
#define QQAppId @"101400042"
#define QQAppSecret @"a85c2fcd67839693d5c0bf13bec84779"
// 新浪分享
#define SinaAppId @"3997129963"
#define SinaAppSecret @"da07bcf6c9f30281e684f8abfd0b4fca"

// 支付宝h5支付之后需要回到app
#define AlipayBundleId @"com.saixin.eduline"

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#endif /* V5_Constant_h */
