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
#import <WebKit/WebKit.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SDWebImage.h>
#import <NTESQuickPass/NTESQuickPass.h>
#import "Net_API.h"
#import "Api_Config.h"
#import "ZLPhoto.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "MBProgressHUD+Add.h"
#import "UIViewController+HUD.h"
#import "UIView+HUD.h"
#import "EdlineV5_Color.h"
#import "TYAttributedLabel.h"
#import "LBHTableView.h"
#import "UIViewController+Utils.h"
#import "UIImage+Util.h"
#import "WKWebIntroview.h"
#import "UITableView+EmptyData.h"
#import "UICollectionView+EmptyData.h"

#ifndef V5_Constant_h
#define V5_Constant_h

#define Institution_Id [[NSUserDefaults standardUserDefaults] objectForKey:@"institutionId"] == nil ? @ "1" : [[NSUserDefaults standardUserDefaults] objectForKey:@"institutionId"]

#define ShowAudit [[NSUserDefaults standardUserDefaults] objectForKey:@"ShowAudit"] == nil ? @ "1" : [[NSUserDefaults standardUserDefaults] objectForKey:@"ShowAudit"]

#define WebTitleContenDistance 10
#define WebDistanceLeft 15//内容和左右的边距

#define APP_NAME [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"]

#define regardlessOrNot [[NSUserDefaults standardUserDefaults] objectForKey:@"regardless_mhm_id"] == nil ? @"0" : [[NSUserDefaults standardUserDefaults] objectForKey:@"regardless_mhm_id"]

#define Show_Config [[NSUserDefaults standardUserDefaults] objectForKey:@"show_config"] == nil ? @"0" : [[NSUserDefaults standardUserDefaults] objectForKey:@"show_config"]

#define TXSDKID [[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_appid"]

#define PROFILELAYOUT [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]
#define COURSELAYOUT [[NSUserDefaults standardUserDefaults] objectForKey:@"course"]

#define LoginInvalid_TXT @"账号已在另一台设备登录,\n请重新登录。"

#define MainScreenHeight [EdulineV5_Tool sharedInstance].tsShowWindowsHeight
#define MainScreenWidth [EdulineV5_Tool sharedInstance].tsShowWindowsWidth
#define HeightRatio MainScreenHeight / 667.0
#define WidthRatio MainScreenWidth / 375.0

#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[(NSArray *)X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length&&(![X isEqualToString:@"<null>"])&&(![X isEqualToString:@"(null)"]&&(![X isEqualToString:@"null"])))
#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)
#define EdulineUrlString(X) [NSURL URLWithString:[NSString stringWithFormat:@"%@",X]]

#define ShowNetError    [self showHudInView:self.view showHint:TEXT_NETWORK_ERROR]
#define ShowHud(X) [self showHudInView:self.view hint:(X)]
#define ShowMissHid(X) [self showHudInView:self.view showHint:(X)]
#define ShowInViewHud(X) [self showHudInView:self hint:(X)]
#define ShowInViewMiss(X) [self showHint:(X)]

#define Image(name) [UIImage imageNamed:name]
#define DefaultImage [UIImage imageNamed:@"placeholder_logo"]
#define DefaultUserImage [UIImage imageNamed:@"pre_touxaing"]
#define BasidColor EdlineV5_Color.themeColor
#define BackColor [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]
#define RGBA(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define ShowNetError    [self showHudInView:self.view showHint:TEXT_NETWORK_ERROR]
#define ShowHud(X) [self showHudInView:self.view hint:(X)]
#define ShowMissHid(X) [self showHudInView:self.view showHint:(X)]
#define ShowInViewHud(X) [self showHudInView:self hint:(X)]
#define ShowInViewMiss(X) [self showHint:(X)]

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define iPhoneX [EdulineV5_Tool judgeIphoneX]

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

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

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 微信分享
#define WXAppId @"wx05293bb7051162ea"
#define WXAppSecret @"5b0e9f51e4d35e8d15152fdbedaa9690"
// QQ分享
#define QQAppId @"101864714"
#define QQAppSecret @"a5ced4fcf5a1b8dab7404e817b31cb56"
// 新浪分享
#define SinaAppId @"3997129963"
#define SinaAppSecret @"da07bcf6c9f30281e684f8abfd0b4fca"

// 支付宝h5支付之后需要回到app
#define PayBundleId @"com.seition.edulineV5"

#define WangyiQuickLoginBusenissID @"0956a7a27f934c8dabeb19e598852111"
#define WangyiId @"abea082ce1e2211c0aa721126d900928"
#define WangyiSecretKey @"ba17623110a38d970f0c8fd9f2736aed"

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

// 输入框之类的
#define CommenViewHeight 50
#define CommentInputHeight 36
#define CommentViewMaxHeight 180
#define CommentViewLeftButtonWidth 28

// 课程cell布局所需
#define singleLeftSpace 15
#define topSpace 20
#define bottomSpace 7
#define singleRightSpace 3
#define faceImageHeight (MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace) * 90 / 165

// 提问对话框消息内容最大宽度
#define questionChatContentWidth 182

// 发现页面宏
#define findSingleLeftSpace 6
#define findTopSpace 3
#define findBottomSpace 3
#define findSingleRightSpace 3
#define findFaceImageHeight (MainScreenWidth/2.0 - findSingleRightSpace - findSingleLeftSpace)

// `APP_ID`:`WASD123456`

// `APP_KEY`:`7WFDuCGYa1XEBj6Y`

#endif /* V5_Constant_h */
