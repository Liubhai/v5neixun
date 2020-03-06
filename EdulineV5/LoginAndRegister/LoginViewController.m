//
//  LoginViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LoginViewController.h"
#import "V5_Constant.h"
#import "LoginPwView.h"
#import "ThirdLoginView.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIButton *pwLoginBtn;
@property (strong, nonatomic) UIButton *msgLoginBtn;
@property (strong, nonatomic) LoginPwView *loginPw;
@property (strong, nonatomic) ThirdLoginView *thirdLoginView;
@property (strong, nonatomic) UIButton *forgetPwBtn;
@property (strong, nonatomic) UIButton *registerBtn;
@property (strong, nonatomic) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = [UIColor whiteColor];
    [self makeSubViews];
}

- (void)makeSubViews {
    
    _pwLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 15, MainScreenWidth / 2.0, 30)];
    [_pwLoginBtn setTitleColor:HEXCOLOR(0x5191FF) forState:UIControlStateSelected];
    [_pwLoginBtn setTitleColor:HEXCOLOR(0x909399) forState:0];
    [_pwLoginBtn setTitle:@"密码登录" forState:0];
    _pwLoginBtn.titleLabel.font = SYSTEMFONT(16);
    [_pwLoginBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pwLoginBtn];
    _pwLoginBtn.selected = YES;
    
    _msgLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2.0, MACRO_UI_UPHEIGHT + 15, MainScreenWidth / 2.0, 30)];
    [_msgLoginBtn setTitleColor:HEXCOLOR(0x5191FF) forState:UIControlStateSelected];
    [_msgLoginBtn setTitleColor:HEXCOLOR(0x909399) forState:0];
    [_msgLoginBtn setTitle:@"验证码登录" forState:0];
    _msgLoginBtn.titleLabel.font = SYSTEMFONT(16);
    [_msgLoginBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_msgLoginBtn];
    
    _loginPw = [[LoginPwView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 60, MainScreenWidth, 102.5)];
    [self.view addSubview:_loginPw];
    
    _forgetPwBtn = [[UIButton alloc] initWithFrame:CGRectMake(48 * WidthRatio, _loginPw.bottom + 8, 70, 30)];
    [_forgetPwBtn setTitleColor:HEXCOLOR(0x909399) forState:0];
    [_forgetPwBtn setTitle:@"忘记密码?" forState:0];
    _forgetPwBtn.titleLabel.font = SYSTEMFONT(14);
    [_forgetPwBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPwBtn];
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (48 + 28) * WidthRatio, _loginPw.bottom + 8, 30, 30)];
    [_registerBtn setTitleColor:HEXCOLOR(0x5191FF) forState:0];
    [_registerBtn setTitle:@"注册" forState:0];
    _registerBtn.titleLabel.font = SYSTEMFONT(14);
    [_registerBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _forgetPwBtn.bottom + 40, 280, 40)];
    _loginBtn.centerX = MainScreenWidth / 2.0;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_loginBtn setTitle:@"登录" forState:0];
    _loginBtn.titleLabel.font = SYSTEMFONT(18);
    _loginBtn.backgroundColor = HEXCOLOR(0x5191FF);
    [_loginBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _thirdLoginView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, _loginBtn.bottom + 32, MainScreenWidth, 90)];
    [self.view addSubview:_thirdLoginView];
    
}

- (void)leftButtonClick:(id)sender {
    if (_dissOrPop) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)topButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender == _pwLoginBtn) {
        _pwLoginBtn.selected = YES;
        _msgLoginBtn.selected = NO;
        _loginPw.hidden = NO;
    } else {
        _pwLoginBtn.selected = NO;
        _msgLoginBtn.selected = YES;
        _loginPw.hidden = YES;
    }
}



@end
