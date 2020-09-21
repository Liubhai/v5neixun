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
#import "UserModel.h"
#import "SurePwViewController.h"
#import "UnBindMsgCodeVC.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMSocialQQHandler.h>


@interface LoginViewController ()<LoginMsgViewDelegate,ThirdLoginViewDelegate> {
    NSTimer *codeTimer;
    int remainTime;
    // 判断后台配置的登录方式
    BOOL hasPwType;
    BOOL hasMsg;
    BOOL hasThird;
}

@property (strong, nonatomic) UIButton *pwLoginBtn;
@property (strong, nonatomic) UIButton *msgLoginBtn;
@property (strong, nonatomic) LoginPwView *loginPw;
@property (strong, nonatomic) LoginMsgView *loginMsg;
@property (strong, nonatomic) ThirdLoginView *thirdLoginView;
@property (strong, nonatomic) UIButton *forgetPwBtn;
@property (strong, nonatomic) UIButton *registerBtn;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) NSDictionary *loginTypeDict;
@property (strong, nonatomic) NSMutableArray *otherTypeArray;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = [UIColor whiteColor];
    _otherTypeArray = [NSMutableArray new];
    _loginTypeDict = [NSDictionary new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_config"]) {
        _loginTypeDict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_config"]];
    }
    [self getLoginConfigNet];
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
    
    if (hasPwType && hasMsg) {
        //不作修改
    } else {
        if (hasPwType && !hasMsg) {
            // 只有账号密码登录
            _msgLoginBtn.hidden = YES;
            _loginMsg.hidden = YES;
            _pwLoginBtn.centerX = MainScreenWidth / 2.0;
        } else if (!hasPwType && hasMsg) {
            // 只有验证码登录
            _msgLoginBtn.selected = YES;
            _msgLoginBtn.centerX = MainScreenWidth / 2.0;
            _loginMsg.hidden = NO;
            _pwLoginBtn.hidden = YES;
            _loginPw.hidden = YES;
        } else {
            // 后台说这种情况不存在
        }
    }
    
}

- (void)makeOtherType {
    _thirdLoginView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, _loginBtn.bottom + 32, MainScreenWidth, 90) methodTypeConfigArray:_otherTypeArray];
    _thirdLoginView.delegate = self;
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
    [self.view endEditing:YES];
    AreaNumListVC *vc = [[AreaNumListVC alloc] init];
    __typeof (self) __weak weakSelf = self;
    vc.areaNumCodeBlock = ^(NSString *codeNum){
        [weakSelf.loginMsg setAreaNumLabelText:codeNum];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getMsgCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *param;
    if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
        [param setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
    }
    [param setObject:@"login" forKey:@"type"];
//    if (_loginMsg.phoneNumTextField.text.length<11) {
//        [self showHudInView:self.view showHint:@"请正确填写手机号"];
//        return;
//    }
    [Net_API requestPOSTWithURLStr:[Net_Path smsCodeSend] WithAuthorization:nil paramDic:@{@"phone":_loginMsg.phoneNumTextField.text,@"type":@"login"} finish:^(id  _Nonnull responseObject) {
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

- (void)registerButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    RegisterAndForgetPwVC *vc = [[RegisterAndForgetPwVC alloc] init];
    vc.registerOrForget = ((sender == _registerBtn) ? YES : NO);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    if (_pwLoginBtn.selected) {
        if (_loginPw.accountTextField.text.length>0 && _loginPw.pwTextField.text.length>=6) {
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
    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_pwLoginBtn.selected) {
        if (![EdulineV5_Tool validatePassWord:_loginPw.pwTextField.text]) {
            [self showHudInView:self.view showHint:@"请输入正确格式的密码"];
            return;
        }
        if (SWNOTEmptyStr(_loginPw.pwTextField.text)) {
            [dict setObject:_loginPw.accountTextField.text forKey:@"user"];
        }
        [dict setObject:@"user" forKey:@"logintype"];
        [dict setObject:[[EdulineV5_Tool getmd5WithString:_loginPw.pwTextField.text] lowercaseString] forKey:@"password"];
    }
    if (_msgLoginBtn.selected) {
        if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
            [dict setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
        }
        if (SWNOTEmptyStr(_loginMsg.codeTextField.text)) {
            [dict setObject:_loginMsg.codeTextField.text forKey:@"verify"];
        }
        [dict setObject:@"verify" forKey:@"logintype"];
    }
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
                if ([[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue] && self.msgLoginBtn.selected) {
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

// MARK: - 其他login
- (void)loginButtonClickKKK:(NSString *)typeString {
    if ([typeString isEqualToString:@"weixin"]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            if (!error) {
                UMSocialUserInfoResponse *resp = result;
                // 第三方登录数据(为空表示平台未提供)
                // 授权数据
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@", resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                // 用户数据
                NSLog(@" name: %@", resp.name);
                NSLog(@" iconurl: %@", resp.iconurl);
                NSLog(@" gender: %@", resp.unionGender);
                // 第三方平台SDK原始数据
                NSLog(@" originalResponse: %@", resp.originalResponse);
                [self otherTypeLoginNet:@"weixin" unionId:resp.unionId];
            }
        }];
    } else if ([typeString isEqualToString:@"qq"]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
            if (!error) {
                UMSocialUserInfoResponse *resp = result;
                // 第三方登录数据(为空表示平台未提供)
                // 授权数据
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@", resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                // 用户数据
                NSLog(@" name: %@", resp.name);
                NSLog(@" iconurl: %@", resp.iconurl);
                NSLog(@" gender: %@", resp.unionGender);
                // 第三方平台SDK原始数据
                NSLog(@" originalResponse: %@", resp.originalResponse);
//                [self otherTypeLoginNet:@"weixin" unionId:resp.usid];
                [self getTCUnionId:resp];
            }
        }];
    }
}

// MARK: - 请求登录配置
- (void)getLoginConfigNet {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path appLoginTypeConfigNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"data"] forKey:@"login_config"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                _loginTypeDict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                if (SWNOTEmptyDictionary(_loginTypeDict)) {
                    if ([[_loginTypeDict objectForKey:@"user"] integerValue]) {
                        hasPwType = YES;
                    }
                    if ([[_loginTypeDict objectForKey:@"verify"] integerValue]) {
                        hasMsg = YES;
                    }
                }
                [self makeSubViews];
                [self getOtherTypeConfigNet];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

// MARK: - 其他方式配置
- (void)getOtherTypeConfigNet {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path appthirdloginTypeConfigNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_otherTypeArray removeAllObjects];
                [_otherTypeArray addObjectsFromArray:responseObject[@"data"]];
                [self makeOtherType];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getTCUnionId:(UMSocialUserInfoResponse *)rep {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    [manager GET:@"https://graph.qq.com/oauth2.0/me" parameters:@{@"access_token":rep.accessToken} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"EdulineV4 GET request succece \n%@\n%@",task.currentRequest.URL.absoluteString,responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     #ifdef DEBUG
         NSLog(@"EdulineV4 GET request failure \n%@",task.currentRequest.URL.absoluteString);
     #endif
         // 失败回调
         NSData *errorData = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
         NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
         NSRange range = [errorString rangeOfString:@"{"];
         NSRange range1 = [errorString rangeOfString:@"}"];
         NSString *ppp = [errorString substringWithRange:NSMakeRange(range.location, range1.location - range.location + 1)];
         NSData *jsonData = [ppp dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
         if (SWNOTEmptyDictionary(dic)) {
             [self otherTypeLoginNet:@"qq" unionId:dic[@"openid"]];
         }
     }];
}

- (void)otherTypeLoginNet:(NSString *)type unionId:(NSString *)unionId {
    [Net_API requestPOSTWithURLStr:[Net_Path otherTypeLogin] WithAuthorization:nil paramDic:@{@"type":type,@"oauth":unionId} finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
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
                if ([[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue] && self.msgLoginBtn.selected) {
                    SurePwViewController *vc = [[SurePwViewController alloc] init];
                    vc.phoneNum = self.loginMsg.phoneNumTextField.text;
                    vc.msgCode = self.loginMsg.codeTextField.text;
                    vc.registerOrForget = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                // 没有绑定账号 此时需要去绑定账号(绑定成功会在绑定接口返回用户信息) 绑定逻辑: 手机号没有注册账号 后台处理注册加绑定 ; 手机号注册了账号,就直接绑定账号
                UnBindMsgCodeVC *vc = [[UnBindMsgCodeVC alloc] init];
                vc.unbindParamString = type;
                vc.other_union_id = unionId;
                if ([type isEqualToString:@"weixin"]) {
                    vc.unbindType = @"bind_weixin";
                } else if ([type isEqualToString:@"qq"]) {
                    vc.unbindType = @"bind_qq";
                } else if ([type isEqualToString:@"sina"]) {
                    vc.unbindType = @"bind_sina";
                }
                [self.navigationController pushViewController:vc animated:YES];
//                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
