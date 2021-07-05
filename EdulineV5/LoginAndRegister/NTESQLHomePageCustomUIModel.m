//
//  NTESQLHomePageCustomUIModel.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageCustomUIModel.h"
#import "V5_Constant.h"

@implementation NTESQLHomePageCustomUIModel

+ (NTESQuickLoginCustomModel *)configCustomUIModel {
    
    NTESQuickLoginCustomModel *model = [[NTESQuickLoginCustomModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPresent;//NTESPresentDirectionPush;
    model.backgroundColor = [UIColor whiteColor];
    model.authWindowPop = NTESAuthWindowPopFullScreen;
//    model.faceOrientation = UIInterfaceOrientationPortrait;
    model.loginDidDisapperfaceOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
    model.navBarHidden = NO;
//    model.navTextFont = [UIFont systemFontOfSize:18];
//    model.navTextColor = [UIColor redColor];
    model.navTextHidden = YES;
    model.navReturnImgLeftMargin = 6;
    model.navBgColor = [UIColor whiteColor];
//    model.navText = @"一键登录";
//    model.navTextHidden = NO;
    model.navReturnImg = [UIImage imageNamed:@"login-back"];

   /// logo
    model.logoImg = [UIImage imageNamed:@"login_logobg"];
    model.logoWidth = 121;
    model.logoHeight = 121;
    model.logoOffsetX = 0;
    model.logoOffsetX = 0;
    model.logoHidden = NO;

   /// 手机号码
    model.numberColor = [UIColor blackColor];
    model.numberFont = [UIFont systemFontOfSize:16];
    model.numberOffsetX = 0;
    model.numberOffsetTopY = 178;
    model.numberHeight = 30;

   ///  品牌
    model.brandColor = [UIColor redColor];
    model.brandFont = [UIFont systemFontOfSize:12];
    model.brandWidth = 200;
    model.brandHeight = 20;
    model.brandOffsetX = 0;
    model.brandOffsetTopY = model.numberOffsetTopY + 30 + 10;
    
    model.logBtnTextFont = [UIFont systemFontOfSize:16];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnRadius = 12;
    model.logBtnOffsetTopY = model.brandOffsetTopY + model.brandHeight + 10;
    model.logBtnText = @"本机号码一键登录";
    model.logBtnUsableBGColor = EdlineV5_Color.themeColor;
    model.logBtnHeight = 44;

    UIButton *wechatButton = [[UIButton alloc] init];
    wechatButton.backgroundColor = [UIColor redColor];
    [wechatButton setBackgroundImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
    UIButton *paypalButton = [[UIButton alloc] init];
    [paypalButton setBackgroundImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
    paypalButton.backgroundColor = [UIColor redColor];
    UIButton *qqButton = [[UIButton alloc] init];
    [qqButton setBackgroundImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
    qqButton.backgroundColor = [UIColor redColor];

    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"《%@注册协议》",appName];
    NSString *netName = @"《中国移动认证服务条款》";
    NSString *fullString = [NSString stringWithFormat:@"登录即同意《默认》和%@并使用本机号码登录",atr];
    
    model.appPrivacyText = fullString;//@"登录即同意《默认》和《用户隐私协议》";
    model.appFPrivacyText = atr;//@"《用户隐私协议》";
    model.appFPrivacyURL = QuickLoginUrl;//@"http://www.baidu.com";
    model.appSPrivacyText = @"《用户服务条款》";
    model.appSPrivacyURL = QuickLoginUrl;//@"http://www.baidu.com";
    model.appFPrivacyTitleText = @"hhahha";
    model.appPrivacyTitleText = @"认证服务协议";
    model.appSPrivacyTitleText = atr;
//    model.privacyColor = EdlineV5_Color.themeColor;
    model.protocolColor = EdlineV5_Color.themeColor;
 
    model.uncheckedImg = [UIImage imageNamed:@"checkbox_nor"];
    model.checkedImg = [[UIImage imageNamed:@"checkbox_sel1"] converToMainColor];
//    model.checkboxWH = 20;
    model.privacyState = YES;
    model.checkedHidden = NO;
    model.isOpenSwipeGesture = NO;

//    if (@available(iOS 13.0, *)) {
//       model.currentStatusBarStyle = UIStatusBarStyleDarkContent;
//       model.otherStatusBarStyle = UIStatusBarStyleDarkContent;
//    } else {
//       model.currentStatusBarStyle = UIStatusBarStyleDefault;
//       model.otherStatusBarStyle = UIStatusBarStyleLightContent;
//    }
    model.currentStatusBarStyle = UIStatusBarStyleDefault;
    model.otherStatusBarStyle = UIStatusBarStyleDefault;
    return model;
}

@end
