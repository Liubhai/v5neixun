//
//  PWResetViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "PWResetViewController.h"
#import "V5_Constant.h"
#import "SurePassWordView.h"
#import "Net_Path.h"

@interface PWResetViewController ()

@property (strong, nonatomic) SurePassWordView *passWordView;
@property (strong, nonatomic) UIButton *sureButton;

@end

@implementation PWResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"修改密码";
    _passWordView = [[SurePassWordView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 101) isReset:YES];
    [self.view addSubview:_passWordView];
    [_passWordView setHeight:_passWordView.height];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WidthRatio, _passWordView.bottom + 40, MainScreenWidth - 30 * WidthRatio, 40)];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    [_sureButton setTitle:@"确认修改" forState:0];
    _sureButton.titleLabel.font = SYSTEMFONT(18);
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    [self.view addSubview:_sureButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)sureButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![EdulineV5_Tool validatePassWord:_passWordView.firstPwTextField.text] || ![EdulineV5_Tool validatePassWord:_passWordView.surePwTextField.text] || ![EdulineV5_Tool validatePassWord:_passWordView.oldtPwTextField.text]) {
        [self showHudInView:self.view showHint:@"密码格式不正确"];
        return;
    }
    if ([_passWordView.firstPwTextField.text isEqualToString:_passWordView.surePwTextField.text]) {
        [self changePassWord];
    } else {
        [self showHudInView:self.view showHint:@"请确认两次密码一致"];
    }
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    UITextField *pass = (UITextField *)notice.object;
    if (_passWordView.firstPwTextField.text.length>=6 && _passWordView.surePwTextField.text.length>=6 && _passWordView.oldtPwTextField.text.length>=6) {
        _sureButton.enabled = YES;
        [_sureButton setBackgroundColor:EdlineV5_Color.themeColor];
    } else {
        _sureButton.enabled = NO;
        [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    }
}

- (void)changePassWord {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (SWNOTEmptyStr(_phoneNum)) {
        [param setObject:_phoneNum forKey:@"phone"];
    }
    if (SWNOTEmptyStr(_msgCode)) {
        [param setObject:_msgCode forKey:@"verify"];
    }
    if (_passWordView.oldtPwTextField.text.length>0) {
        [param setObject:[EdulineV5_Tool getmd5WithString:_passWordView.oldtPwTextField.text] forKey:@"ex_password"];
    }
    if (_passWordView.firstPwTextField.text.length>0) {
        [param setObject:[EdulineV5_Tool getmd5WithString:_passWordView.firstPwTextField.text] forKey:@"new_password"];
    }
    [Net_API requestPUTWithURLStr:[Net_Path userEditPwPath] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController popViewControllerAnimated:YES];
//                [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-3] animated:NO];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"修改失败"];
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
