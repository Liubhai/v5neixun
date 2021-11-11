//
//  CCBaseViewController.m
//  CCClassRoom
//
//  Created by cc on 17/3/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "AppDelegate.h"

@interface CCBaseViewController ()

@end

@implementation CCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *aimage = [UIImage imageNamed:@"nav_ic_back_nor"];
    UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSelectVC)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FontSizeClass_16],NSFontAttributeName,nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:
     [self createImageWithColor:MainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FontSizeClass_18],NSFontAttributeName,nil]];
    self.view.backgroundColor = CCRGBColor(250, 250, 250);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [AppDelegate delegate];
    if (app.window.rootViewController) {
        if ([app.window.rootViewController isKindOfClass:[RootV5VC class]]) {
            RootV5VC * nv = (RootV5VC *)app.window.rootViewController;
            [nv isHiddenCustomTabBarByBoolean:!_notHiddenNav];
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)onSelectVC
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    UIViewController *vc = [self.navigationController.viewControllers firstObject];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
//    if (![vc isKindOfClass:NSClassFromString(@"CCLoginScanViewController")]) {
////        [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
//    }else {
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    if (app.window.rootViewController) {
        if ([app.window.rootViewController isKindOfClass:[RootV5VC class]]) {
            RootV5VC * nv = (RootV5VC *)app.window.rootViewController;
            [nv isHiddenCustomTabBarByBoolean:_hiddenNavDisappear];
        }
    }
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
