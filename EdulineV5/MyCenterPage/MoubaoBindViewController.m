//
//  MoubaoBindViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MoubaoBindViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "UserModel.h"

@interface MoubaoBindViewController ()<UITextFieldDelegate> {
    NSTimer *codeTimer;
    int remainTime;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UILabel *nameTip;
@property (strong, nonatomic) UITextField *nameTextField;

@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UILabel *accuntTip;
@property (strong, nonatomic) UITextField *accuntTextField;

@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UILabel *phoneTip;
@property (strong, nonatomic) UILabel *phoneL;

@property (strong, nonatomic) UIView *line3;

@property (strong, nonatomic) UILabel *codeNumTip;
@property (strong, nonatomic) UITextField *codeNumField;

@property (strong, nonatomic) UIButton *senderCodeBtn;

@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation MoubaoBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"支付宝绑定";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_mainScrollView];
    
    UIView *whiteBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    whiteBack.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:whiteBack];
    
    _nameTip = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
    _nameTip.text = @"真实姓名";
    _nameTip.font = SYSTEMFONT(15);
    _nameTip.textColor = EdlineV5_Color.textFirstColor;
    [whiteBack addSubview:_nameTip];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, 0, 200, 50)];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    _nameTextField.delegate = self;
    _nameTextField.font = SYSTEMFONT(15);
    _nameTextField.textColor = EdlineV5_Color.textSecendColor;
    _nameTextField.textAlignment = NSTextAlignmentRight;
    [whiteBack addSubview:_nameTextField];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(15, _nameTip.bottom, MainScreenWidth - 15, 0.5)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [whiteBack addSubview:_line1];
    
    _accuntTip = [[UILabel alloc] initWithFrame:CGRectMake(15, _line1.bottom, 200, 50)];
    _accuntTip.text = @"账号";
    _accuntTip.font = SYSTEMFONT(15);
    _accuntTip.textColor = EdlineV5_Color.textFirstColor;
    [whiteBack addSubview:_accuntTip];
    
    _accuntTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _line1.bottom, 200, 50)];
    _accuntTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    _accuntTextField.returnKeyType = UIReturnKeyDone;
    _accuntTextField.delegate = self;
    _accuntTextField.font = SYSTEMFONT(15);
    _accuntTextField.textColor = EdlineV5_Color.textSecendColor;
    _accuntTextField.textAlignment = NSTextAlignmentRight;
    [whiteBack addSubview:_accuntTextField];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(15, _accuntTip.bottom, MainScreenWidth - 15, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [whiteBack addSubview:_line2];
    
    _phoneTip = [[UILabel alloc] initWithFrame:CGRectMake(15, _line2.bottom, 200, 50)];
    _phoneTip.text = @"手机号";
    _phoneTip.font = SYSTEMFONT(15);
    _phoneTip.textColor = EdlineV5_Color.textFirstColor;
    [whiteBack addSubview:_phoneTip];
    
    _phoneL = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _line2.bottom, 200, 50)];
    if (SWNOTEmptyStr([UserModel userPhone])) {
        if ([UserModel userPhone].length > 7) {
            _phoneL.text = [[UserModel userPhone] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }
    _phoneL.font = SYSTEMFONT(15);
    _phoneL.textColor = EdlineV5_Color.textSecendColor;
    _phoneL.textAlignment = NSTextAlignmentRight;
    [whiteBack addSubview:_phoneL];
    
    _line3 = [[UIView alloc] initWithFrame:CGRectMake(15, _phoneTip.bottom, MainScreenWidth - 15, 0.5)];
    _line3.backgroundColor = EdlineV5_Color.fengeLineColor;
    [whiteBack addSubview:_line3];
    
    _codeNumTip = [[UILabel alloc] initWithFrame:CGRectMake(15, _line3.bottom, 97 - 15, 50)];
    _codeNumTip.text = @"验证码";
    _codeNumTip.font = SYSTEMFONT(15);
    _codeNumTip.textColor = EdlineV5_Color.textFirstColor;
    [whiteBack addSubview:_codeNumTip];
    
    _codeNumField = [[UITextField alloc] initWithFrame:CGRectMake(_codeNumTip.right, _line3.bottom, 200, 50)];
    _codeNumField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    _codeNumField.returnKeyType = UIReturnKeyDone;
    _codeNumField.delegate = self;
    _codeNumField.font = SYSTEMFONT(15);
    _codeNumField.textColor = EdlineV5_Color.textSecendColor;
    [whiteBack addSubview:_codeNumField];
    
    _senderCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 0, 100, 20)];
    [_senderCodeBtn setTitle:@"获取验证码" forState:0];
    _senderCodeBtn.titleLabel.font = SYSTEMFONT(14);
    [_senderCodeBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_senderCodeBtn setTitleColor:EdlineV5_Color.textThirdColor forState:UIControlStateDisabled];
    _senderCodeBtn.centerY = _codeNumField.centerY;
    [_senderCodeBtn addTarget:self action:@selector(getMsgCode:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:_senderCodeBtn];
    
    [whiteBack setHeight:_codeNumTip.bottom];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, whiteBack.bottom + 28, MainScreenWidth - 30, 40)];
    _nextButton.centerX = MainScreenWidth / 2.0;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 5;
    NSMutableAttributedString *passAtr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ 提现",_priceString]];
    [passAtr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 1)];
    [passAtr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [NSString stringWithFormat:@"¥%@ 提现",_priceString].length)];
    [_nextButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:passAtr] forState:0];
    _nextButton.titleLabel.font = SYSTEMFONT(18);
    _nextButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    _nextButton.enabled = NO;
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_nextButton];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    if (_nameTextField.text.length>0 && _accuntTextField.text.length>0 && _codeNumField.text.length>0) {
        _nextButton.enabled = YES;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
    } else {
        _nextButton.enabled = NO;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonDisableColor];
    }
}

- (void)nextButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    _nextButton.enabled = NO;
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_accuntTextField.text)) {
        [param setObject:_accuntTextField.text forKey:@"alipay_account"];
    }
    if (SWNOTEmptyStr(_nameTextField.text)) {
        [param setObject:_nameTextField.text forKey:@"alipay_user_name"];
    }
    if (SWNOTEmptyStr(_priceString)) {
        [param setObject:_priceString forKey:@"money"];
    }
    if (SWNOTEmptyStr(_codeNumField.text)) {
        [param setObject:_codeNumField.text forKey:@"verify_code"];
    }
    [Net_API requestPOSTWithURLStr:[Net_Path incomeForMoubao] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        _nextButton.enabled = YES;
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadIncomeData" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } enError:^(NSError * _Nonnull error) {
        _nextButton.enabled = YES;
        [self showHudInView:self.view showHint:@"提现失败"];
    }];
}

- (void)timerBegin:(NSTimer *)timer
{
    _senderCodeBtn.enabled = NO;
    [_senderCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ds)",remainTime] forState:UIControlStateDisabled];//注意此处状态为UIControlStateDisabled
    
    remainTime -= 1;
    
    if (remainTime == -1)
    {
        [codeTimer invalidate];
        codeTimer = nil;
        
        remainTime = 59;
        _senderCodeBtn.enabled = YES;
        [_senderCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)getMsgCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr([UserModel userPhone])) {
        [param setObject:[UserModel userPhone] forKey:@"phone"];
    }
    [param setObject:@"alipay" forKey:@"type"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
