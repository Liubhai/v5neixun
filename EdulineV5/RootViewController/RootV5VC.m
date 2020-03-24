//
//  RootV5VC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "RootV5VC.h"
#import <YYKit.h>
#import "HomeRootViewController.h"
#import "CourseRootViewController.h"
#import "FindRootViewController.h"
#import "MyRootViewController.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import "AVC_VP_VideoPlayViewController.h"
#import "CourseSearchListVC.h"

@interface RootV5VC ()

@property (strong ,nonatomic)UIButton *seledButton;

@end

@implementation RootV5VC

static RootV5VC *sharedBaseTabBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewController];
    //隐藏系统tabbar
    [self.tabBar setHidden:YES];
}

- (void)createViewController
{
    HomeRootViewController *homeVc = [[HomeRootViewController alloc] init];
    homeVc.notHiddenNav = YES;
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    
    CourseSearchListVC *courseVC = [[CourseSearchListVC alloc] init];
    courseVC.notHiddenNav = YES;
    courseVC.isSearch = NO;
    UINavigationController *courseNav = [[UINavigationController alloc] initWithRootViewController:courseVC];
    
    FindRootViewController *findVC = [[FindRootViewController alloc] init];
    findVC.notHiddenNav = YES;
    UINavigationController *findNav = [[UINavigationController alloc] initWithRootViewController:findVC];
    
    MyRootViewController *myVC = [[MyRootViewController alloc]init];
    myVC.notHiddenNav = YES;
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNav,courseNav,findNav,myNav, nil];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 49 - MACRO_UI_SAFEAREA, self.view.frame.size.width, 49 + MACRO_UI_SAFEAREA)];
    _imageView.tag = 100;
    [self.view addSubview:_imageView];
    
    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    XLabel.backgroundColor = EdlineV5_Color.layarLineColor;//[UIColor colorWithRed:143.f / 255 green:143.f / 255 blue:143.f / 255 alpha:0.5];
    [_imageView addSubview:XLabel];
    
    NSArray *imageArray = @[@"tab_home",@"tab_course",@"tab_found",@"tab_my"];
    NSArray *selectedArray = @[@"tab_home_pre",@"tab_course_pre",@"tab_found_pre",@"tab_my_pre"];
    
    //添加按钮
    CGFloat space = (self.view.frame.size.width-40*4)/5;
    for(int i=0;i<4;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space+(space+40)*i, 0, 40, 49);
        //常态时按钮的图片
        UIImage * imageNol = [UIImage imageNamed:imageArray[i]];
        [btn setImage:imageNol forState:UIControlStateNormal];
        //选中状态时的图片
        UIImage * imageSelected = [UIImage imageNamed:selectedArray[i]];
        [btn setImage:imageSelected forState:UIControlStateSelected];
        
        [_imageView addSubview:btn];
        btn.tag= i+1;
        
        //设置第一个按钮为选中状态
        if (btn.tag==1) {
            [self pressBtn:btn];
        }
        //开启交互
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)pressBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.selectedIndex = btn.tag-1;
    self.seledButton.selected = NO;
    btn.selected = YES;
    self.seledButton = btn;
    if (btn.tag == 4) {
        [AppDelegate presentLoginNav:sharedBaseTabBar.viewControllers.lastObject];
    }
}

-(void)isHiddenCustomTabBarByBoolean:(BOOL)boolean
{
    _imageView.hidden = boolean;
}

- (void)rootVcIndexWithNum:(NSInteger)Num {
    
    UIButton *button =(UIButton *) _imageView.subviews[Num];
    [self pressBtn:button];
    
}

+ (RootV5VC *)sharedBaseTabBarViewController {
    if (!sharedBaseTabBar) {
        sharedBaseTabBar = [[RootV5VC alloc] init];
        NSLog(@"初始化");
    }
    return sharedBaseTabBar;
}

+(RootV5VC *)destoryShared{
    for (UIViewController *baseV in sharedBaseTabBar.viewControllers) {
        [baseV.view removeAllSubviews];
        [baseV removeFromParentViewController];
        [[NSNotificationCenter defaultCenter]removeObserver:baseV];
    }
    sharedBaseTabBar.viewControllers = nil;
    return sharedBaseTabBar = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
