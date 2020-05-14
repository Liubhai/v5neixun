//
//  AppDelegate.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootV5VC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL _allowRotation;
@property (nonatomic, strong) RootV5VC * tabbar;
@property (assign, nonatomic) BOOL hasPhone;
@property (weak, nonatomic) UIViewController *currentViewController;

+(AppDelegate *)delegate;

- (RootV5VC *)rootVC;

- (void)changeThemeColor;

+(void)presentLoginNav:(UIViewController *)currentViewController;

@end

