//
//  BaseViewController.m
//  zlydoc-iphone
//  Parent View Controller
//  Created by Ryan on 14-5-23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "V5_Constant.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UITextField appearance] setTintColor:EdlineV5_Color.themeColor];
    [[UITextView appearance] setTintColor:EdlineV5_Color.themeColor];
    
    self.navigationController.navigationBar.hidden =YES;
    
    _titleImage = [[UIImageView alloc]init];
    _titleImage.frame = CGRectMake(0, 0, MainScreenWidth, 44);
    _titleImage.backgroundColor = EdlineV5_Color.statebarColor;
    _titleImage.userInteractionEnabled = YES;
    [self.view addSubview:_titleImage];
    
    _lineTL = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, MainScreenWidth, 0.5)];
    _lineTL.backgroundColor = [UIColor whiteColor];
    [_titleImage addSubview:_lineTL];
    
    _titleLabel = [[UILabel alloc]init];
    [_titleLabel setTextColor:EdlineV5_Color.textFirstColor];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    _titleLabel.frame = CGRectMake(50, 10, MainScreenWidth-100, 34);
    [_titleImage addSubview:_titleLabel];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 11, 44, 44);
    [_leftButton setTitleColor:BackColor forState:0];
    [_leftButton setImage:[UIImage imageNamed:@"nav_back_grey"] forState:0];
    [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(MainScreenWidth-52, 11, 44, 44);
    _rightButton.titleLabel.font = SYSTEMFONT(15);
    [_rightButton setTitleColor:[UIColor blueColor] forState:0];
    [_rightButton setImage:Image(@"nav_more_white") forState:0];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.hidden = YES;
    [_titleImage addSubview:_rightButton];
    
    // 这里对顶部所有控件重新调整了frame以适配iPhoneX
    _titleImage.frame = CGRectMake(0, 0, MainScreenWidth, 64+MACRO_UI_STATUSBAR_ADD_HEIGHT);
    _titleLabel.frame = CGRectMake(50, 27+MACRO_UI_STATUSBAR_ADD_HEIGHT, MainScreenWidth-100, 34);
    _leftButton.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    _rightButton.frame = CGRectMake(MainScreenWidth-52, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 53, 44);
    _lineTL.frame = CGRectMake(0, 63.5+MACRO_UI_STATUSBAR_ADD_HEIGHT, MainScreenWidth, 0.5);

}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}

-(void)leftButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick:(id)sender {
    
}

- (void)showAlert:(NSString * _Nonnull)message handle:(void (^_Nullable)(UIAlertAction * _Nullable))handle {
    [self.view endEditing:true];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handle];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlert:(NSString * _Nonnull)message; {
    [self showAlert:message handle:nil];
}

@end
