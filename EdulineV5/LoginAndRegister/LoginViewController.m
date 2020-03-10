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
#import "LoginMsgView.h"
#import "AreaNumListVC.h"
#import "RegisterAndForgetPwVC.h"
#import "Net_Path.h"

@interface LoginViewController ()<LoginMsgViewDelegate>

@property (strong, nonatomic) UIButton *pwLoginBtn;
@property (strong, nonatomic) UIButton *msgLoginBtn;
@property (strong, nonatomic) LoginPwView *loginPw;
@property (strong, nonatomic) LoginMsgView *loginMsg;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

// MARK: - 子视图创建
- (void)makeSubViews {
    
    _pwLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 15, MainScreenWidth / 2.0, 30)];
    [_pwLoginBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [_pwLoginBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [_pwLoginBtn setTitle:@"密码登录" forState:0];
    _pwLoginBtn.titleLabel.font = SYSTEMFONT(16);
    [_pwLoginBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pwLoginBtn];
    _pwLoginBtn.selected = YES;
    
    _msgLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2.0, MACRO_UI_UPHEIGHT + 15, MainScreenWidth / 2.0, 30)];
    [_msgLoginBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [_msgLoginBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [_msgLoginBtn setTitle:@"验证码登录" forState:0];
    _msgLoginBtn.titleLabel.font = SYSTEMFONT(16);
    [_msgLoginBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_msgLoginBtn];
    
    _loginPw = [[LoginPwView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 60, MainScreenWidth, 102.5)];
    [self.view addSubview:_loginPw];
    
    _loginMsg = [[LoginMsgView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 60, MainScreenWidth, 102.5)];
    _loginMsg.hidden = YES;
    _loginMsg.delegate = self;
    [self.view addSubview:_loginMsg];
    
    _forgetPwBtn = [[UIButton alloc] initWithFrame:CGRectMake(48 * WidthRatio, _loginPw.bottom + 8, 70, 30)];
    [_forgetPwBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [_forgetPwBtn setTitle:@"忘记密码?" forState:0];
    _forgetPwBtn.titleLabel.font = SYSTEMFONT(14);
    [_forgetPwBtn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPwBtn];
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (48 + 28) * WidthRatio, _loginPw.bottom + 8, 30, 30)];
    [_registerBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_registerBtn setTitle:@"注册" forState:0];
    _registerBtn.titleLabel.font = SYSTEMFONT(14);
    [_registerBtn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _forgetPwBtn.bottom + 40, 280, 40)];
    _loginBtn.centerX = MainScreenWidth / 2.0;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_loginBtn setTitle:@"登录" forState:0];
    _loginBtn.titleLabel.font = SYSTEMFONT(18);
    _loginBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
    [_loginBtn addTarget:self action:@selector(loginRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _thirdLoginView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, _loginBtn.bottom + 32, MainScreenWidth, 90)];
    [self.view addSubview:_thirdLoginView];
    
}

// MARK: - 返回按钮判断
- (void)leftButtonClick:(id)sender {
    if (_dissOrPop) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// MARK: - 顶部不同登录类型选择切换
- (void)topButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender == _pwLoginBtn) {
        _pwLoginBtn.selected = YES;
        _msgLoginBtn.selected = NO;
        _loginPw.hidden = NO;
        _loginMsg.hidden = YES;
        if (_loginPw.accountTextField.text.length>0 && _loginPw.pwTextField.text.length>0) {
            _loginBtn.enabled = YES;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonNormalColor;
        } else {
            _loginBtn.enabled = NO;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    } else {
        _pwLoginBtn.selected = NO;
        _msgLoginBtn.selected = YES;
        _loginPw.hidden = YES;
        _loginMsg.hidden = NO;
        if (_loginMsg.phoneNumTextField.text.length>0 && _loginMsg.codeTextField.text.length>0) {
            _loginBtn.enabled = YES;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonNormalColor;
        } else {
            _loginBtn.enabled = NO;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    }
}

// MARK: - LoginMsgViewDelegate(验证码登录号码归属地选择)
- (void)jumpAreaNumList {
    AreaNumListVC *vc = [[AreaNumListVC alloc] init];
    __typeof (self) __weak weakSelf = self;
    vc.areaNumCodeBlock = ^(NSString *codeNum){
        [weakSelf.loginMsg setAreaNumLabelText:codeNum];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerButtonClick:(UIButton *)sender {
    RegisterAndForgetPwVC *vc = [[RegisterAndForgetPwVC alloc] init];
    vc.registerOrForget = ((sender == _registerBtn) ? YES : NO);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    if (_pwLoginBtn.selected) {
        if (_loginPw.accountTextField.text.length>0 && _loginPw.pwTextField.text.length>0) {
            _loginBtn.enabled = YES;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonNormalColor;
        } else {
            _loginBtn.enabled = NO;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    } else if(_msgLoginBtn.selected) {
        if (_loginMsg.phoneNumTextField.text.length>0 && _loginMsg.codeTextField.text.length>0) {
            _loginBtn.enabled = YES;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonNormalColor;
        } else {
            _loginBtn.enabled = NO;
            _loginBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    }
}

- (void)loginRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_pwLoginBtn.selected) {
        [dict setObject:@"user" forKey:@"logintype"];
        [dict setObject:_loginPw.accountTextField.text forKey:@"user"];
        [dict setObject:_loginPw.pwTextField.text forKey:@"password"];
    }
    if (_msgLoginBtn.selected) {
        [dict setObject:@"verify" forKey:@"logintype"];
        [dict setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
        [dict setObject:_loginMsg.codeTextField.text forKey:@"verify"];
    }
    [Net_API requestPOSTWithURLStr:[Net_Path userLoginPath:nil] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
