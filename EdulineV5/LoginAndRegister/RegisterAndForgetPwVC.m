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

@interface RegisterAndForgetPwVC ()<LoginMsgViewDelegate>

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
        _titleLabel.text = @"找回密码";
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

- (void)nextButtonClick:(UIButton *)sender {
    SurePwViewController *vc = [[SurePwViewController alloc] init];
    vc.registerOrForget = _registerOrForget;
    vc.phoneNum = _loginMsg.phoneNumTextField.text;
    vc.msgCode = _loginMsg.codeTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    UITextField *pass = (UITextField *)notice.object;
    if (_loginMsg.phoneNumTextField.text.length>=0 && _loginMsg.codeTextField.text>=0) {
        _nextButton.enabled = YES;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
    } else {
        _nextButton.enabled = NO;
        [_nextButton setBackgroundColor:EdlineV5_Color.buttonDisableColor];
    }
}

@end
