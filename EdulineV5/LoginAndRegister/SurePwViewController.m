//
//  SurePwViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SurePwViewController.h"
#import "SurePassWordView.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface SurePwViewController ()

@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) SurePassWordView *passWordView;
@property (strong, nonatomic) UILabel *agreementLabel;

@end

@implementation SurePwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_registerOrForget) {
        _titleLabel.text = @"注册";
    } else {
        _titleLabel.text = @"找回密码";
    }
    [self makeSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeSubViews {
    
    _passWordView = [[SurePassWordView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 101)];
    [self.view addSubview:_passWordView];
    [_passWordView setHeight:_passWordView.height];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WidthRatio, _passWordView.bottom + 40, MainScreenWidth - 30 * WidthRatio, 40)];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    [_sureButton setTitle:@"确定" forState:0];
    _sureButton.titleLabel.font = SYSTEMFONT(18);
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    
    [self.view addSubview:_sureButton];
    
    if (_registerOrForget) {
        _passWordView.firstPwLabel.text = @"设置密码";
        _agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _sureButton.bottom + 15, MainScreenWidth, 20)];
        _agreementLabel.font = SYSTEMFONT(13);
        _agreementLabel.textColor = EdlineV5_Color.textThirdColor;
        _agreementLabel.textAlignment = NSTextAlignmentCenter;
        NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
        NSString *atr = [NSString stringWithFormat:@"《%@服务协议》",appName];
        NSString *final = [NSString stringWithFormat:@"注册即表示阅读并同意%@",atr];
        NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:final];
        [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.themeColor} range:[final rangeOfString:atr]];
        _agreementLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
        [self.view addSubview:_agreementLabel];
    }
    
}

- (void)sureButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_passWordView.firstPwTextField.text isEqualToString:_passWordView.surePwTextField.text]) {
        if (_registerOrForget) {
            [self setPassWordRequest];
        } else {
            [self reSetPassWordRequest];
        }
    } else {
        [self showHudInView:self.view showHint:@"请确认两次密码一致"];
    }
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    UITextField *pass = (UITextField *)notice.object;
    if (_passWordView.firstPwTextField.text.length>=6 && _passWordView.surePwTextField.text.length>=6) {
        _sureButton.enabled = YES;
        [_sureButton setBackgroundColor:EdlineV5_Color.themeColor];
    } else {
        _sureButton.enabled = NO;
        [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    }
}

- (void)setPassWordRequest {
    [Net_API requestPUTWithURLStr:[Net_Path userSetPwPath:nil] paramDic:@{@"password":_passWordView.surePwTextField.text} Api_key:nil finish:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)reSetPassWordRequest {
    [Net_API requestPOSTWithURLStr:[Net_Path userResetPwPath:nil] WithAuthorization:nil paramDic:@{@"phone":_phoneNum,@"password":_passWordView.surePwTextField.text} finish:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
