//
//  AppDelegate.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "AppDelegate.h"
#import "QuickLoginVC.h"
#import "LoginViewController.h"
#import "NTESQLHomePageCustomUIModel.h"
#import "UserModel.h"
#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMShare/UMSocialManager.h>
#import <WXApi.h>
//#import <WechatOpenSDK/WXApi.h>

#import <AlipaySDK/AlipaySDK.h>
//
#import "Net_Path.h"
#import "SurePwViewController.h"

// 直播
#import "TICManager.h"
#import "TICConfig.h"

#import "LanchAnimationVC.h"
#import "HcdGuideView.h"

//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//         .............................................
//
//                  佛祖保佑            永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

@interface AppDelegate ()<BuglyDelegate,TICStatusListener,UIAlertViewDelegate,WXApiDelegate>

@property (weak, nonatomic) NTESQuickLoginManager *quickLoginManager;


@property (nonatomic, assign) BOOL shouldQL;
@property (nonatomic, assign) BOOL precheckSuccess;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *accessToken;
@property (strong, nonatomic) NSDictionary *loginTypeDict;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UserModel saveAuth_scope:@"app"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    self.tabbar = [RootV5VC sharedBaseTabBarViewController];
//    self.window.rootViewController = self.tabbar;
//    [self.window makeKeyAndVisible];
    [self configureBugly];
    // 分享
    // U-Share 平台设置
    [UMConfigure initWithAppkey:@"574e8829e0f55a12f8001790" channel:@"App Store"];
    [self confitUShareSettings];
    [self configUSharePlatforms];
    _hasPhone = NO;
    _loginTypeDict = [NSDictionary new];
    self.quickLoginManager = [NTESQuickLoginManager sharedInstance];
    [self registerQuickLogin];
    
    [self appConfigInfo];
    [self layoutConfig];
    
    _noticeLogoutAlert = [[UIAlertView alloc]initWithTitle:LoginInvalid_TXT message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    _noticeLogoutAlert.tag = 101;
    
    LanchAnimationVC* lanchVC = [[LanchAnimationVC alloc]init];
    
    self.window.rootViewController = lanchVC;
    [self.window makeKeyAndVisible];
    lanchVC.animationFinished = ^(BOOL successed){
        if ([Show_Config isEqualToString:@"1"]) {
//            InstitutionsChooseVC* institutionsVC = [[InstitutionsChooseVC alloc]init];
//            self.window.rootViewController = institutionsVC;
//            [self.window makeKeyAndVisible];
//            institutionsVC.institutionChooseFinished = ^(BOOL succesed) {
//                self.tabbar = [rootViewController sharedBaseTabBarViewController];
//                self.window.rootViewController = self.tabbar;
//                [self.window makeKeyAndVisible];
//            };
        } else {
            self.tabbar = [RootV5VC sharedBaseTabBarViewController];
            self.window.rootViewController = self.tabbar;
            [self.window makeKeyAndVisible];
        }
        
        NSMutableArray *images = [NSMutableArray new];
        
        [images addObject:[UIImage imageNamed:@"guide1.png"]];
        [images addObject:[UIImage imageNamed:@"guide2.png"]];
        [images addObject:[UIImage imageNamed:@"guide3.png"]];
        
        HcdGuideView *guideView = [HcdGuideView sharedInstance];
        guideView.window = self.window;
        [guideView showGuideViewWithImages:images
                            andButtonTitle:@""
                       andButtonTitleColor:[UIColor clearColor]
                          andButtonBGColor:[UIColor clearColor]
                      andButtonBorderColor:[UIColor clearColor]];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLogin) name:@"LOGINFINISH" object:nil];
    
    return YES;
}

- (void)logout {
    [UserModel deleteUserPassport];
    [RootV5VC destoryShared];
    if (self.window.rootViewController) {
        [self.window.rootViewController removeFromParentViewController];
        self.window.rootViewController = nil;
    }
    self.tabbar = [RootV5VC sharedBaseTabBarViewController];
    self.tabbar.selectedIndex = [self.tabbar.childViewControllers count] - 1;
    [self.tabbar rootVcIndexWithNum:[self.tabbar.childViewControllers count]];
    self.window.rootViewController = self.tabbar;
}

- (void)changeThemeColor {
    [RootV5VC destoryShared];
    if (self.window.rootViewController) {
        [self.window.rootViewController removeFromParentViewController];
        self.window.rootViewController = nil;
    }
    self.tabbar = [RootV5VC sharedBaseTabBarViewController];
    self.tabbar.selectedIndex = [self.tabbar.childViewControllers count] - 1;
    [self.tabbar rootVcIndexWithNum:[self.tabbar.childViewControllers count]];
    self.window.rootViewController = self.tabbar;
}

- (void)didFinishLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUserInfo" object:nil];
}

+(AppDelegate *)delegate
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (RootV5VC *)rootVC
{
    return (RootV5VC *)_window.rootViewController;
}

+(void)presentLoginNav:(UIViewController *)currentViewController {
    if (!currentViewController) {
        return;
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_config"]) {
        [AppDelegate delegate].loginTypeDict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_config"]];
    }
    [AppDelegate delegate].hasPhoneLoginType = NO;
    if (SWNOTEmptyDictionary([AppDelegate delegate].loginTypeDict)) {
        if ([[[AppDelegate delegate].loginTypeDict objectForKey:@"phone"] integerValue]) {
            [AppDelegate delegate].hasPhoneLoginType = YES;
        }
    }
    
    [AppDelegate delegate].currentViewController = currentViewController;
    if ([currentViewController isKindOfClass:[UINavigationController class]]) {
        if ([AppDelegate delegate].hasPhone && [AppDelegate delegate].hasPhoneLoginType) {
            [[AppDelegate delegate] setCustomUI];
            if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 1) {
                [[AppDelegate delegate] authorizeCTLoginWithText:nil];
            } else if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 2) {
                [[AppDelegate delegate] authorizeCMLoginWithText:nil];
            } else {
                [[AppDelegate delegate] authorizeCULoginWithText:nil];
            }
//            QuickLoginVC *vc = [[QuickLoginVC alloc] init];
//            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
//            [currentViewController presentViewController:Nav animated:YES completion:nil];
        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.dissOrPop = YES;
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentViewController presentViewController:Nav animated:YES completion:nil];
        }
    } else if ([currentViewController isKindOfClass:[UIViewController class]]) {
        if ([AppDelegate delegate].hasPhone && [AppDelegate delegate].hasPhoneLoginType) {
            [[AppDelegate delegate] setCustomUI];
            if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 1) {
                [[AppDelegate delegate] authorizeCTLoginWithText:nil];
            } else if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 2) {
                [[AppDelegate delegate] authorizeCMLoginWithText:nil];
            } else {
                [[AppDelegate delegate] authorizeCULoginWithText:nil];
            }
//            QuickLoginVC *vc = [[QuickLoginVC alloc] init];
//            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
//            [currentViewController presentViewController:Nav animated:YES completion:nil];
        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.dissOrPop = YES;
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentViewController.navigationController presentViewController:Nav animated:YES completion:nil];
        }
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

#else

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

#endif
{
    if (__allowRotation == YES) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

//使用第三方登录需要重写下面两个方法

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result == FALSE) {
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            return YES;
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            return YES;
        }
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderFinished" object:nil];
            }];
        }
    } else if ([url.host isEqualToString:WXAppId]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        return YES;
    }
    return YES;
}

//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (__allowRotation == YES) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}

// MARK: - 手机一键登录
/// 使用易盾提供的businessID进行初始化业务，回调中返回初始化结果
- (void)registerQuickLogin {
    // 在使用一键登录之前，请先调用shouldQuickLogin方法，判断当前上网卡的网络环境和运营商是否可以一键登录
    self.shouldQL = [[NTESQuickLoginManager sharedInstance] shouldQuickLogin];
    if (self.shouldQL) {
        [[NTESQuickLoginManager sharedInstance] registerWithBusinessID:WangyiQuickLoginBusenissID timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            if (success) {
                self.token = [params objectForKey:@"token"];
                self.precheckSuccess = YES;
                [self getPhoneNumberWithText:@""];
            } else {
                NSLog(@"precheck失败");
                self.precheckSuccess = NO;
            }
        }];
    }
}

- (void)getPhoneNumberWithText:(NSString *)title {
    if (!self.shouldQL || !self.precheckSuccess) {
        NSLog(@"不允许一键登录");
        return;
    }
    [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        self->_hasPhone = success;
    }];
}

/// 电信授权认证接口
- (void)authorizeCTLoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            // 取号失败
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
            }
        }
    }];
}

/// 移动授权认证接口
- (void)authorizeCMLoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
            }
        }
    }];
}

/// 联通授权认证接口
- (void)authorizeCULoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"10104"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"10105"]) {
                NSLog(@"切换登录方式");
            }
        }
    }];
}

/// 调用服务端接口进行校验
- (void)startCheckWithText:(NSString *)title {
    if (!SWNOTEmptyStr(self.token)) {
        return;
    }
    if (!SWNOTEmptyStr(self.accessToken)) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.token forKey:@"token"];
    [param setObject:self.accessToken forKey:@"accessToken"];
    [param setObject:@"phone" forKey:@"logintype"];
    [Net_API requestPOSTWithURLStr:[Net_Path userLoginPath:nil] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSString *ak = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"ak"]];
                NSString *sk = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"sk"]];
                [UserModel saveUserPassportToken:ak andTokenSecret:sk];
                [UserModel saveUid:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]]];
                [UserModel saveAuth_scope:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"auth_scope"]]];
                [UserModel saveUname:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"nick_name"]]];
                [UserModel saveNickName:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"user_name"]]];
                [UserModel savePhone:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"phone"]]];
                [UserModel saveNeed_set_password:[[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINFINISH" object:nil];
                if ([[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue]) {
                    
                    if ([NTESQuickLoginManager sharedInstance].model.currentVC) {
                        if ([[NTESQuickLoginManager sharedInstance].model.currentVC isKindOfClass:[UINavigationController class]]) {
                            [[NTESQuickLoginManager sharedInstance].model.currentVC.presentedViewController dismissViewControllerAnimated:YES completion:^{
                                SurePwViewController *vc = [[SurePwViewController alloc] init];
                                vc.registerOrForget = YES;
                                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                Nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                [_currentViewController presentViewController:Nav animated:YES completion:nil];
                            }];
                        } else if ([[NTESQuickLoginManager sharedInstance].model.currentVC isKindOfClass:[UIViewController class]]) {
                            [[NTESQuickLoginManager sharedInstance].model.currentVC.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:^{
                                SurePwViewController *vc = [[SurePwViewController alloc] init];
                                vc.registerOrForget = YES;
                                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                Nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                [_currentViewController.navigationController presentViewController:Nav animated:YES completion:nil];
                            }];
                        }
                    }
                } else {
                    if ([NTESQuickLoginManager sharedInstance].model.currentVC) {
                        if ([[NTESQuickLoginManager sharedInstance].model.currentVC isKindOfClass:[UINavigationController class]]) {
                            [[NTESQuickLoginManager sharedInstance].model.currentVC.presentedViewController dismissViewControllerAnimated:YES completion:^{
                            }];
                        } else if ([[NTESQuickLoginManager sharedInstance].model.currentVC isKindOfClass:[UIViewController class]]) {
                            [[NTESQuickLoginManager sharedInstance].model.currentVC.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:^{
                            }];
                        }
                    }
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
    
}

/// 授权页面自定义
- (void)setCustomUI {
    if (_currentViewController) {
        NTESQuickLoginCustomModel *model = [NTESQLHomePageCustomUIModel configCustomUIModel];
        model.currentVC = _currentViewController;
        
        model.customViewBlock = ^(UIView * _Nullable customView) {
            UIButton *otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 100, 30)];
            [otherBtn setTitle:@"其他方式登录" forState:0];
            [otherBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
            otherBtn.titleLabel.font = SYSTEMFONT(14);
            otherBtn.centerX = MainScreenWidth / 2.0;
            [otherBtn addTarget:self action:@selector(otherLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [customView addSubview:otherBtn];
        };
        [[NTESQuickLoginManager sharedInstance] setupModel:model];
    }
}

- (void)otherLoginButtonClicked:(UIButton *)sender {
    if ([NTESQuickLoginManager sharedInstance].model.currentVC) {
        if ([[NTESQuickLoginManager sharedInstance].model.currentVC isKindOfClass:[UINavigationController class]]) {
            [[NTESQuickLoginManager sharedInstance].model.currentVC.presentedViewController dismissViewControllerAnimated:YES completion:^{
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.dissOrPop = YES;
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                Nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [_currentViewController presentViewController:Nav animated:YES completion:nil];
            }];
        } else if ([[NTESQuickLoginManager sharedInstance].model.currentVC isKindOfClass:[UIViewController class]]) {
            [[NTESQuickLoginManager sharedInstance].model.currentVC.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:^{
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.dissOrPop = YES;
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                Nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [_currentViewController.navigationController presentViewController:Nav animated:YES completion:nil];
            }];
        }
    }
}

//Bugly
- (void)configureBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    
    config.unexpectedTerminatingDetectionEnable = YES; //非正常退出事件记录开关，默认关闭
    config.reportLogLevel = BuglyLogLevelWarn; //报告级别
    config.deviceIdentifier = [UIDevice currentDevice].identifierForVendor.UUIDString; //设备标识
    config.blockMonitorEnable = YES; //开启卡顿监控
    config.blockMonitorTimeout = 5; //卡顿监控判断间隔，单位为秒
    config.delegate = self;
    
#if DEBUG
    config.debugMode = YES; //SDK Debug信息开关, 默认关闭
    config.channel = @"debug";
#else
    config.channel = @"release";
#endif
    
    [Bugly startWithAppId:@"433cae6801"
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
}

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    return [NSString stringWithFormat:@"exceptionInfo:\nname:%@\nreason:%@",exception.name,exception.reason];
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
        //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    
//    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/", @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139"};
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppId appSecret:WXAppSecret redirectURL:@"https://api.weixin.qq.com/cgi-bin/menu/create?access_token="];
    [WXApi registerApp:WXAppId universalLink:@"https://api.weixin.qq.com/cgi-bin/menu/create?access_token="];
//    /*设置小程序回调app的回调*/
//        [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse, NSError *error) {
//        NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
//    }];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppId  appSecret:QQAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

#pragma mark - status listener
- (void)onTICForceOffline {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"账号被踢" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    UIViewController *currentVC = ((UINavigationController *)self.window.rootViewController).topViewController;
    [currentVC presentViewController:alert animated:YES completion:nil];
}
- (void)onTICUserSigExpired
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

// MARK: - 初始化信息
- (void)appConfigInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path appConfig] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"sdk_appid"] forKey:@"sdk_appid"];
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"theme_color"] forKey:@"color"];
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"login_config"] forKey:@"login_config"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)layoutConfig {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path layoutConfig] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"profile"]] forKey:@"profile"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"course"]] forKey:@"course"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

// MARK: - 初始化TX直播
- (void)intTXSDK {
    __weak typeof(self) weakSelf = self;
    if (SWNOTEmptyStr(TXSDKID)) {
        int sdkAppid = [TXSDKID intValue];
        [[TICManager sharedInstance] init:sdkAppid callback:^(TICModule module, int code, NSString *desc) {
            if(code == 0){
                [[TICManager sharedInstance] addStatusListener:self];
                weakSelf.configTXSDK(@"1");
            }
        }];
    }
}

@end
