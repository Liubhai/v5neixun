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
#import "StudyRootVC.h"
#import "MyRootViewController.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import "AVC_VP_VideoPlayViewController.h"
#import "CourseSearchListVC.h"
#import "NSObject+PYThemeExtension.h"
#import "UIImage+Util.h"

@interface RootV5VC ()

@property (strong ,nonatomic)UIButton *seledButton;

@end

@implementation RootV5VC

static RootV5VC *sharedBaseTabBar;

//- (UIViewController *)childViewControllerForStatusBarStyle{
//    return self.selectedViewController;
//}

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

    StudyRootVC *studyVC = [[StudyRootVC alloc] init];
    studyVC.notHiddenNav = YES;
    UINavigationController *studyNav = [[UINavigationController alloc] initWithRootViewController:studyVC];

    MyRootViewController *myVC = [[MyRootViewController alloc]init];
    myVC.notHiddenNav = YES;
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNav,courseNav,findNav,studyNav,myNav, nil];
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 49 - MACRO_UI_SAFEAREA, self.view.frame.size.width, 49 + MACRO_UI_SAFEAREA)];
    _imageView.tag = 100;
    [self.view addSubview:_imageView];
    
    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    XLabel.backgroundColor = EdlineV5_Color.layarLineColor;//[UIColor colorWithRed:143.f / 255 green:143.f / 255 blue:143.f / 255 alpha:0.5];
    [_imageView addSubview:XLabel];
    
    NSArray *imageArray = @[@"tabbar_home_nor",@"tabbar_lesson_nor",@"tabbar_find_nor",@"tabbar_study_nor",@"tabbar_pre_nor"];
    NSArray *selectedArray = @[@"tabbar_home_pre",@"tabbar_lesson_pre",@"tabbar_find_pre",@"tabbar_study_pre",@"tabbar_pre_pre"];
    NSArray *normalTitleArray = @[@"首页",@"课程",@"发现",@"学习",@"我的"];
    
    //添加按钮
    CGFloat space = (self.view.frame.size.width-40*imageArray.count)/(imageArray.count + 1);
    CGFloat imageTitleSpace = 0.5;
    for(int i=0;i<imageArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space+(space+40)*i, 0, 40, 49);
        //常态时按钮的图片
        UIImage * imageNol = [UIImage imageNamed:imageArray[i]];
        [btn setImage:imageNol forState:UIControlStateNormal];
        //选中状态时的图片
        UIImage * imageSelected = [UIImage imageNamed:selectedArray[i]];
//        [imageSelected py_addToThemeColorPoolWithSelector:@selector(converToOtherColor:) objects:@[PYTHEME_THEME_COLOR]];
        
        [btn setImage:[imageSelected converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateSelected];
//        [btn py_addToThemeColorPoolWithSelector:@selector(setImage:forState:) objects:@[imageSelected, @(UIControlStateSelected)]];
        
        [btn setTitle:normalTitleArray[i] forState:0];
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        btn.titleLabel.font = SYSTEMFONT(12);
//        [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = btn.titleLabel.frame.size.width;
            labelHeight = btn.titleLabel.frame.size.height;
        }

        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imageTitleSpace/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-imageTitleSpace/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        
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
