//
//  UnBindMsgCodeVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/9/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "UnBindMsgCodeVC.h"
#import "LoginMsgView.h"
#import "V5_Constant.h"
#import "AreaNumListVC.h"
#import "SurePwViewController.h"
#import "Net_Path.h"
#import "UserModel.h"

@interface UnBindMsgCodeVC ()<LoginMsgViewDelegate> {
    NSTimer *codeTimer;
    int remainTime;
}

@property (strong, nonatomic) LoginMsgView *loginMsg;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation UnBindMsgCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"解除绑定";
    if (_unBindOrBind) {
        _titleLabel.text = @"绑定账号";
    }
    [self makeSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSubViews {
    
    _loginMsg = [[LoginMsgView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 102.5)];
    _loginMsg.delegate = self;
    _loginMsg.phoneNumTextField.textColor = EdlineV5_Color.textThirdColor;
    if (_unBindOrBind) {
        
    } else {
        _loginMsg.phoneNumTextField.text = [UserModel userPhone];
        [_loginMsg.phoneNumTextField setEnabled:NO];
        _loginMsg.areaBtn.enabled = NO;
    }
    [self.view addSubview:_loginMsg];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _loginMsg.bottom + 40, 280, 40)];
    _nextButton.centerX = MainScreenWidth / 2.0;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 5;
    [_nextButton setTitleColor:[UIColor whiteColor] forState:0];
    [_nextButton setTitle:@"解除绑定" forState:0];
    if (_unBindOrBind) {
        [_nextButton setTitle:@"绑定账号" forState:0];
    }
    _nextButton.titleLabel.font = SYSTEMFONT(18);
    _nextButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    _nextButton.enabled = NO;
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
}

- (void)nextButtonClick:(UIButton *)sender {
    if (_unBindOrBind) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        if (SWNOTEmptyStr(_unbindParamString)) {
            [param setObject:_unbindParamString forKey:@"type"];
        }
        if (SWNOTEmptyStr(_loginMsg.codeTextField.text)) {
            [param setObject:_loginMsg.codeTextField.text forKey:@"verify"];
        }
        if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
            [param setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
        }
        if (SWNOTEmptyStr(_other_union_id)) {
            [param setObject:_other_union_id forKey:@"oauth"];
        }
        [Net_API requestPOSTWithURLStr:[Net_Path otherTypeBindNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    // 保存用户信息并且返回到个人中心页面
                    
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
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    });
                } else {
                    [self showHudInView:self.view showHint:responseObject[@"msg"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络请求超时"];
        }];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary new];
        if (SWNOTEmptyStr(_unbindParamString)) {
            [param setObject:_unbindParamString forKey:@"type"];
        }
        if (SWNOTEmptyStr(_loginMsg.codeTextField.text)) {
            [param setObject:_loginMsg.codeTextField.text forKey:@"verify"];
        }
        [Net_API requestDeleteWithURLStr:[Net_Path otherTypeBindNet] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络请求超时"];
        }];
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

- (void)getMsgCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *param;
    if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
        [param setObject:_loginMsg.phoneNumTextField.text forKey:@"phone"];
    }
    if (SWNOTEmptyStr(_unbindType)) {
        [param setObject:_unbindType forKey:@"type"];
    }
    [Net_API requestPOSTWithURLStr:[Net_Path smsCodeSend] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
