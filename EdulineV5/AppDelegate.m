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

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tabbar = [RootV5VC sharedBaseTabBarViewController];
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    _hasPhone = YES;
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
    if ([currentViewController isKindOfClass:[UINavigationController class]]) {
        if ([AppDelegate delegate].hasPhone) {
            QuickLoginVC *vc = [[QuickLoginVC alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentViewController presentViewController:Nav animated:YES completion:nil];
        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.dissOrPop = YES;
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentViewController presentViewController:Nav animated:YES completion:nil];
        }
    } else if ([currentViewController isKindOfClass:[UIViewController class]]) {
        if ([AppDelegate delegate].hasPhone) {
            QuickLoginVC *vc = [[QuickLoginVC alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentViewController presentViewController:Nav animated:YES completion:nil];
        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.dissOrPop = YES;
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            Nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentViewController presentViewController:Nav animated:YES completion:nil];
        }
    }
}

@end
