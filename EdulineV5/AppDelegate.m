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

@interface AppDelegate ()

@property (weak, nonatomic) NTESQuickLoginManager *quickLoginManager;


@property (nonatomic, assign) BOOL shouldQL;
@property (nonatomic, assign) BOOL precheckSuccess;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *accessToken;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UserModel saveAuth_scope:@"app"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tabbar = [RootV5VC sharedBaseTabBarViewController];
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    _hasPhone = YES;
    self.quickLoginManager = [NTESQuickLoginManager sharedInstance];
    [self registerQuickLogin];
    return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


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
    [AppDelegate delegate].currentViewController = currentViewController;
    if ([currentViewController isKindOfClass:[UINavigationController class]]) {
        if ([AppDelegate delegate].hasPhone) {
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
        if ([AppDelegate delegate].hasPhone) {
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

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (__allowRotation == YES) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

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
        _hasPhone = success;
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
    NSDictionary *dict = @{
        @"accessToken":self.accessToken?:@"",
        @"token":self.token?:@"",
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        return;
    }
    
//    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_TOKEN_QLCHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:YES completion:nil];
//            if (data) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                NSNumber *code = [dict objectForKey:@"code"];
//
//                if ([code integerValue] == 200) {
//                    NSDictionary *data = [dict objectForKey:@"data"];
//                    NSString *phoneNum = [data objectForKey:@"phone"];
//                    if (phoneNum && phoneNum.length > 0) {
//                        NTESQPLoginSuccessViewController *vc = [[NTESQPLoginSuccessViewController alloc] init];
//                        vc.themeTitle = title;
//                        vc.type = NTESQuickLoginType;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    } else {
//                        [self.navigationController pushViewController:self.loginViewController animated:YES];
//                        [self.loginViewController updateView];
//
//                        #ifdef TEST_MODE_QA
//                        [self.loginViewController showToastWithMsg:@"一键登录失败"];
//                        #endif
//                    }
//                } else if ([code integerValue] == 1003){
//                    [self.navigationController pushViewController:self.loginViewController animated:YES];
//                    [self.loginViewController updateView];
//                } else {
//                    [self.navigationController pushViewController:self.loginViewController animated:YES];
//                    [self.loginViewController updateView];
//
//                    #ifdef TEST_MODE_QA
//                    [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"错误，code=%@", code]];
//                    #endif
//                }
//            } else {
//                [self.navigationController pushViewController:self.loginViewController animated:YES];
//                [self.loginViewController updateView];
//
//                #ifdef TEST_MODE_QA
//                [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
//                #endif
//            }
//        });
//    }];
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

@end
