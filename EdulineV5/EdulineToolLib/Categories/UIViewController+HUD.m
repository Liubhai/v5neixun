/************************************************************
  *  * EaseMob CONFIDENTIAL
  * __________________
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
  *
  * NOTICE: All information contained herein is, and remains
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "UIViewController+HUD.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    HUD.customView.backgroundColor = [UIColor blackColor];
    HUD.contentColor = [UIColor whiteColor];
    HUD.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.label.text = hint;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHudInView:(UIView *)view showHint:(NSString *)hint{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.customView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    [hud setOffset:CGPointMake(0, 100.f)];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}

- (void)showHudInView:(UIView *)view showHint:(NSString *)hint timeInt:(NSTimeInterval)timeInt {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.customView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    [hud setOffset:CGPointMake(0, 100.f)];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:timeInt];
}

@end
