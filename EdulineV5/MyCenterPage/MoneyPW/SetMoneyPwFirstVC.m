//
//  SetMoneyPwFirstVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/21.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SetMoneyPwFirstVC.h"
#import "V5_Constant.h"
#import "SHPasswordTextView.h"
#import "LoginMsgView.h"
#import "Net_Path.h"
#import "V5_UserModel.h"

@interface SetMoneyPwFirstVC ()<LoginMsgViewDelegate> {
    NSTimer *codeTimer;
    int remainTime;
}


@property (strong, nonatomic) LoginMsgView *loginMsg;

@property (strong, nonatomic) UILabel *tip1;
@property (strong, nonatomic) UILabel *tip2;
@property (strong, nonatomic) UILabel *tip3;

@property (strong, nonatomic) SHPasswordTextView *firstPw;
@property (strong, nonatomic) SHPasswordTextView *secondPw;

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *finishButton;

@end

@implementation SetMoneyPwFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"设置支付密码";
    [self makeSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSubView {
    
    _tip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 20, MainScreenWidth, 21)];
    _tip1.textColor = EdlineV5_Color.textThirdColor;
    _tip1.font = SYSTEMFONT(15);
    _tip1.textAlignment = NSTextAlignmentCenter;
    _tip1.text = [NSString stringWithFormat:@"为帐号%@****%@",[[V5_UserModel userPhone] substringToIndex:3],[[V5_UserModel userPhone] substringFromIndex:7]];//@"为帐号132****0000";
    _tip1.hidden = YES;
    [self.view addSubview:_tip1];
    
    _tip2 = [[UILabel alloc] initWithFrame:CGRectMake(0, _tip1.bottom + 5, MainScreenWidth, 25)];
    _tip2.textColor = EdlineV5_Color.textFirstColor;
    _tip2.font = SYSTEMFONT(18);
    _tip2.textAlignment = NSTextAlignmentCenter;
    _tip2.text = @"设置6位数字支付密码";
    _tip2.hidden = YES;
    [self.view addSubview:_tip2];
    
    _tip3 = [[UILabel alloc] initWithFrame:CGRectMake(0, _tip1.bottom + 5, MainScreenWidth, 25)];
    _tip3.textColor = EdlineV5_Color.textFirstColor;
    _tip3.font = SYSTEMFONT(18);
    _tip3.textAlignment = NSTextAlignmentCenter;
    _tip3.text = @"再次输入支付密码";
    _tip3.hidden = YES;
    [self.view addSubview:_tip3];
    
    _firstPw = [[SHPasswordTextView alloc] initWithFrame:CGRectMake(25, _tip2.bottom + 27, MainScreenWidth - 50, 44) count:6 margin:0.1 passwordFont:15 forType:SHPasswordTextTypeRectangle block:^(NSString * _Nonnull passwordStr) {
        NSLog(@"%@",passwordStr);
        if (passwordStr.length >= 6) {
            self.loginMsg.hidden = YES;
            self.nextButton.hidden = YES;
            
            self.firstPw.hidden = YES;
            self.tip1.hidden = YES;
            self.tip2.hidden = YES;
            
            self.secondPw.hidden = NO;
            self.tip3.hidden = NO;
            self.finishButton.hidden = NO;
            self.finishButton.enabled = NO;
            [self.secondPw.textField becomeFirstResponder];
        }
    }];
    _firstPw.hidden = YES;
    [self.view addSubview:_firstPw];
    
    _secondPw = [[SHPasswordTextView alloc] initWithFrame:CGRectMake(25, _tip2.bottom + 27, MainScreenWidth - 50, 44) count:6 margin:0.1 passwordFont:15 forType:SHPasswordTextTypeRectangle block:^(NSString * _Nonnull passwordStr) {
        NSLog(@"%@",passwordStr);
        if (passwordStr.length >= 6) {
            self.finishButton.enabled = YES;
            [self.finishButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
        } else {
            self.finishButton.enabled = NO;
            [self.finishButton setBackgroundColor:EdlineV5_Color.buttonDisableColor];
        }
        // 请求接口
    }];
    _secondPw.hidden = YES;
    [self.view addSubview:_secondPw];
    
    _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _secondPw.bottom + 60, 280, 40)];
    _finishButton.centerX = MainScreenWidth / 2.0;
    _finishButton.layer.masksToBounds = YES;
    _finishButton.layer.cornerRadius = 5;
    [_finishButton setTitleColor:[UIColor whiteColor] forState:0];
    [_finishButton setTitle:@"完成" forState:0];
    _finishButton.titleLabel.font = SYSTEMFONT(18);
    _finishButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    _finishButton.enabled = NO;
    _finishButton.hidden = YES;
    [_finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishButton];
    
    _loginMsg = [[LoginMsgView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 102.5)];
    _loginMsg.delegate = self;
    _loginMsg.phoneNumTextField.text = [NSString stringWithFormat:@"%@****%@",[[V5_UserModel userPhone] substringToIndex:3],[[V5_UserModel userPhone] substringFromIndex:7]];
    _loginMsg.phoneNumTextField.textColor = EdlineV5_Color.textThirdColor;
    [_loginMsg.phoneNumTextField setEnabled:NO];
    _loginMsg.areaBtn.enabled = NO;
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

- (void)nextButtonClick:(UIButton *)sender {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
        [param setObject:[V5_UserModel userPhone] forKey:@"phone"];
    }
    [param setObject:_loginMsg.codeTextField.text forKey:@"code"];
    [Net_API requestPOSTWithURLStr:[Net_Path userVerifyMoneyPwNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                self.loginMsg.hidden = YES;
                self.nextButton.hidden = YES;
                
                self.firstPw.hidden = NO;
                self.tip1.hidden = NO;
                self.tip2.hidden = NO;
                
                self.secondPw.hidden = YES;
                self.finishButton.hidden = YES;
                self.tip3.hidden = YES;
                [self.firstPw.textField becomeFirstResponder];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {

    }];
}

- (void)finishButtonClick:(UIButton *)sender {
    // 先判断两次密码是否一致
    if (![_firstPw.textField.text isEqualToString:_secondPw.textField.text]) {
        [self showHudInView:self.view showHint:@"两次输入密码不一致"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
        [param setObject:[V5_UserModel userPhone] forKey:@"phone"];
    }
    [param setObject:_loginMsg.codeTextField.text forKey:@"code"];
    [param setObject:[[EdulineV5_Tool getmd5WithString:_secondPw.textField.text] lowercaseString] forKey:@"password"];
    [Net_API requestPOSTWithURLStr:[Net_Path moneyPwSetNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } enError:^(NSError * _Nonnull error) {

    }];
    
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    UITextField *pass = (UITextField *)notice.object;
    if ([V5_UserModel userPhone].length>0 && _loginMsg.codeTextField.text.length>0) {
        _nextButton.enabled = YES;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
    } else {
        _nextButton.enabled = NO;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonDisableColor];
    }
}

- (void)getMsgCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_loginMsg.phoneNumTextField.text)) {
        [param setObject:[V5_UserModel userPhone] forKey:@"phone"];
    }
    [param setObject:@"bpwd" forKey:@"type"];
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
