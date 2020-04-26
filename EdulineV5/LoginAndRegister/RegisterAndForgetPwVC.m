//
//  RegisterAndForgetPwVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "RegisterAndForgetPwVC.h"
#import "LoginMsgView.h"
#import "V5_Constant.h"
#import "AreaNumListVC.h"
#import "SurePwViewController.h"
#import "Net_Path.h"
#import "UserModel.h"
#import "PWResetViewController.h"

@interface RegisterAndForgetPwVC ()<LoginMsgViewDelegate> {
    NSTimer *codeTimer;
    int remainTime;
}

@property (strong, nonatomic) LoginMsgView *loginMsg;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation RegisterAndForgetPwVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_registerOrForget) {
        _titleLabel.text = @"注册";
    } else {
        if (_editPw) {
            _titleLabel.text = @"修改密码";
        } else {
            _titleLabel.text = @"找回密码";
        }
    }
    [self makeSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSubViews {
    
    _loginMsg = [[LoginMsgView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 102.5)];
    _loginMsg.delegate = self;
    [self.view addSubview:_loginMsg];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _loginMsg.bottom + 40, 280, 40)];
    _nextButton.centerX = MainScreenWidth / 2.0;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 5;
    [_nextButton setTitleColor:[UIColor whiteColor] forState:0];
    [_nextButton setTitle:@"下一步" forState:0];
    _nextButton.titleLabel.font = SYSTEMFONT(18);
    _nextButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    _nextButton.enabled = NO;
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
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

- (void)getMsgCode:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_loginMsg.phoneNumTextField.text.length<11) {
        [self showHudInView:self.view showHint:@"请正确填写手机号"];
        return;
    }
    // reset 重置密码
    [Net_API requestPOSTWithURLStr:[Net_Path smsCodeSend] WithAuthorization:nil paramDic:@{@"phone":_loginMsg.phoneNumTextField.text,@"type":(_registerOrForget ? @"login" : @"retrieve")} finish:^(id  _Nonnull responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self showHudInView:self.view showHint:@"发送成功，请等待短信验证码"];
                remainTime = 59;
                sender.enabled = NO;
                codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBegin:) userInfo:nil repeats:YES];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)nextButtonClick:(UIButton *)sender {
    if (_registerOrForget) {
        [self loginRequest];
    } else {
        [self jumpPassWordSetVc];
    }
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    UITextField *pass = (UITextField *)notice.object;
    if (_loginMsg.phoneNumTextField.text.length>0 && _loginMsg.codeTextField.text.length>0) {
        _nextButton.enabled = YES;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
    } else {
        _nextButton.enabled = NO;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonDisableColor];
    }
}

- (void)jumpPassWordSetVc {
    [self verifyPhone];
}

- (void)loginRequest {
    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"verify" forKey:@"logintype"];
    [dict setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
    [dict setObject:_loginMsg.codeTextField.text forKey:@"verify"];
    [Net_API requestPOSTWithURLStr:[Net_Path userLoginPath:nil] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSString *ak = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"ak"]];
                NSString *sk = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"sk"]];
                [UserModel saveUserPassportToken:ak andTokenSecret:sk];
                [UserModel saveUid:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]]];
                [UserModel saveAuth_scope:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"auth_scope"]]];
                [UserModel saveUname:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"nick_name"]]];
                [UserModel saveNickName:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"user_name"]]];
                [UserModel savePhone:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"phone"]]];
                [UserModel saveNeed_set_password:[[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINFINISH" object:nil];
                SurePwViewController *vc = [[SurePwViewController alloc] init];
                vc.phoneNum = self.loginMsg.phoneNumTextField.text;
                vc.msgCode = self.loginMsg.codeTextField.text;
                vc.registerOrForget = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)verifyPhone {
    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"verify" forKey:@"logintype"];
    [dict setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
    [dict setObject:_loginMsg.codeTextField.text forKey:@"verify"];
    [Net_API requestPOSTWithURLStr:[Net_Path userVerifyPath:nil] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                if (_editPw) {
                    PWResetViewController *vc = [[PWResetViewController alloc] init];
                    vc.phoneNum = self.loginMsg.phoneNumTextField.text;
                    vc.msgCode = self.loginMsg.codeTextField.text;
                    vc.pkString = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"pk"]];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    SurePwViewController *vc = [[SurePwViewController alloc] init];
                    vc.registerOrForget = self.registerOrForget;
                    vc.phoneNum = self.loginMsg.phoneNumTextField.text;
                    vc.msgCode = self.loginMsg.codeTextField.text;
                    vc.pkString = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"pk"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)timerBegin:(NSTimer *)timer
{
    self.loginMsg.senderCodeBtn.enabled = NO;
    [self.loginMsg.senderCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ds)",remainTime] forState:UIControlStateDisabled];//注意此处状态为UIControlStateDisabled
    
    remainTime -= 1;
    
    if (remainTime == -1)
    {
        [codeTimer invalidate];
        codeTimer = nil;
        
        remainTime = 59;
        self.loginMsg.senderCodeBtn.enabled = YES;
        [self.loginMsg.senderCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

@end
