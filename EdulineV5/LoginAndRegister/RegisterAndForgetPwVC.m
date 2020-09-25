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
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *topLabel;

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
            if (_changePhone) {
                if (_hasPhone) {
                    _titleLabel.text = @"更换手机号";
                } else {
                    _titleLabel.text = @"手机号绑定";
                }
            } else {
                _titleLabel.text = @"找回密码";
            }
        }
    }
    [self makeSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSubViews {
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 0)];
    _topView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_topView];
    
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, MainScreenWidth - 30, 18)];
    _topLabel.font = SYSTEMFONT(13);
    _topLabel.textColor = EdlineV5_Color.textThirdColor;
    [_topView addSubview:_topLabel];
    
    if (SWNOTEmptyStr(_topTitle)) {
        _topLabel.text = _topTitle;
        [_topLabel sizeToFit];
        [_topLabel setHeight:_topLabel.height];
        [_topView setHeight:_topLabel.bottom + 10];
    } else {
        [_topLabel setHeight:0];
        [_topView setHeight:0];
        _topLabel.hidden = YES;
        _topView.hidden = YES;
    }
    
    _loginMsg = [[LoginMsgView alloc] initWithFrame:CGRectMake(0, _topView.bottom, MainScreenWidth, 102.5)];
    _loginMsg.delegate = self;
    if (_changePhone) {
        if (_hasPhone) {
            if (_oldPhone) {
                if (SWNOTEmptyStr([UserModel userPhone])) {
                    if ([UserModel userPhone].length > 7) {
                        _loginMsg.phoneNumTextField.text = [[UserModel userPhone] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    }
                }
                [_loginMsg.phoneNumTextField setEnabled:NO];
                _loginMsg.areaBtn.enabled = NO;
            } else {
                _loginMsg.phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入要绑定的新手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            }
        } else {
        }
    }
    [self.view addSubview:_loginMsg];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _loginMsg.bottom + 40, 280, 40)];
    _nextButton.centerX = MainScreenWidth / 2.0;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 5;
    [_nextButton setTitleColor:[UIColor whiteColor] forState:0];
    if (_registerOrForget) {
        [_nextButton setTitle:@"下一步" forState:0];
    } else {
        if (_editPw) {
            [_nextButton setTitle:@"下一步" forState:0];
        } else {
            if (_changePhone) {
                if (_hasPhone) {
                    if (_oldPhone) {
                        [_nextButton setTitle:@"下一步" forState:0];
                    } else {
                        [_nextButton setTitle:@"确认验证" forState:0];
                    }
                } else {
                    [_nextButton setTitle:@"完成绑定" forState:0];
                }
            } else {
                [_nextButton setTitle:@"下一步" forState:0];
            }
        }
    }
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
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
        if (_changePhone && _hasPhone && _oldPhone) {
            [param setObject:[UserModel userPhone] forKey:@"phone"];
        } else {
            [param setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
        }
    }
    if (_registerOrForget) {
        [param setObject:@"login" forKey:@"type"];
    } else {
        if (_editPw) {
            [param setObject:@"retrieve" forKey:@"type"];
        } else {
            [param setObject:@"phone" forKey:@"type"];
        }
    }
    [Net_API requestPOSTWithURLStr:[Net_Path smsCodeSend] WithAuthorization:nil paramDic:@{@"phone":_loginMsg.phoneNumTextField.text,@"type":(_registerOrForget ? @"login" : @"retrieve")} finish:^(id  _Nonnull responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self showHudInView:self.view showHint:@"发送成功，请等待短信验证码"];
                remainTime = 59;
                sender.enabled = NO;
                codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBegin:) userInfo:nil repeats:YES];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)nextButtonClick:(UIButton *)sender {
    if (_registerOrForget) {
        [self loginRequest];
    } else {
        if (_changePhone) {
            if (_hasPhone) {
                // 如果是验证旧手机号页面 就要验证完了以后跳转到新手机号验证页面
                if (_oldPhone) {
                    [self userChangePhone:NO];
                } else {
                    // 验证新手机号 返回新手机号给个人信息页面 完成ui更新 并在保存编辑用户信息的接口传值
                    [self userChangePhone:YES];
                }
            } else {
                // 直接验证新手机号绑定
                [self userChangePhone:YES];
            }
        } else {
            [self jumpPassWordSetVc];
        }
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
                [UserModel saveAvatar:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"avatar_url"]]];
                [UserModel saveNickName:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"user_name"]]];
                [UserModel savePhone:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"phone"]]];
                [UserModel saveNeed_set_password:[[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINFINISH" object:nil];
                if ([[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue]) {
                    SurePwViewController *vc = [[SurePwViewController alloc] init];
                    vc.phoneNum = self.loginMsg.phoneNumTextField.text;
                    vc.msgCode = self.loginMsg.codeTextField.text;
                    vc.registerOrForget = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
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
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)userChangePhone:(BOOL)newOrOld {
    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:newOrOld ? @"0" : @"1" forKey:@"original"];
    [dict setObject:newOrOld ? _loginMsg.phoneNumTextField.text : [UserModel userPhone] forKey:@"phone"];
    [dict setObject:_loginMsg.codeTextField.text forKey:@"verify"];
    [Net_API requestPOSTWithURLStr:[Net_Path userAccountChangePhone] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                
                if (_changePhone) {
                    if (_hasPhone) {
                        // 如果是验证旧手机号页面 就要验证完了以后跳转到新手机号验证页面
                        if (_oldPhone) {
                            RegisterAndForgetPwVC *vc = [[RegisterAndForgetPwVC alloc] init];
                            vc.changePhone = YES;
                            vc.hasPhone = YES;
                            vc.oldPhone = NO;
                            [self.navigationController pushViewController:vc animated:YES];
                            return;
                        } else {
                            // 验证新手机号 返回新手机号给个人信息页面 完成ui更新 并在保存编辑用户信息的接口传值
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfoPagePhone" object:nil userInfo:@{@"phone":_loginMsg.phoneNumTextField.text}];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2 - 1] animated:NO];
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        }
                    } else {
                        // 直接验证新手机号绑定
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfoPagePhone" object:nil userInfo:@{@"phone":_loginMsg.phoneNumTextField.text}];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
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
