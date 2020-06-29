//
//  LoginPwView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LoginPwView.h"
#import "V5_Constant.h"

@implementation LoginPwView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubviews];
    }
    return self;
}

- (void)makeSubviews {
    _accountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(48.5 * WidthRatio, 0, 20, 18)];
    _accountIcon.image = Image(@"login_icon_account");
    [self addSubview:_accountIcon];
    
    _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(_accountIcon.right + 14 * WidthRatio, 0, MainScreenWidth - 48 * 2 * WidthRatio - 18 - 14 * WidthRatio, 50)];
    _accountTextField.delegate = self;
    _accountTextField.returnKeyType = UIReturnKeyDone;
    _accountTextField.font = SYSTEMFONT(14);
    _accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:_accountTextField];
    _accountIcon.centerY = _accountTextField.centerY;
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(48 * WidthRatio, _accountTextField.bottom, MainScreenWidth - 48 * 2 * WidthRatio, 0.5)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line1];
    
    /// 这个过度的 UITextField 是为了解决 12系统上 当手机只有搜狗输入法的时候,页面有两个或者两个以上的 UITextField 设置了 secureTextEntry 之后,相邻的 UITextField 也会被系统判定成 secureTextEntry 从而导致切换不到搜狗输入法
    UITextField *pass = [[UITextField alloc] initWithFrame:CGRectMake(0, _line1.bottom, MainScreenWidth, 0.5)];
    [self addSubview:pass];
    
    _pwIcon = [[UIImageView alloc] initWithFrame:CGRectMake(48.5 * WidthRatio, 0, 20, 20)];
    _pwIcon.image = Image(@"login_icon_password");
    [self addSubview:_pwIcon];
    
    _pwTextField = [[UITextField alloc] initWithFrame:CGRectMake(_pwIcon.right + 14 * WidthRatio, pass.bottom, MainScreenWidth - 48 * 2 * WidthRatio - 18 - 14 * WidthRatio, 50)];
    _pwTextField.delegate = self;
    _pwTextField.returnKeyType = UIReturnKeyDone;
    _pwTextField.font = SYSTEMFONT(14);
    _pwTextField.secureTextEntry = YES;
    _pwTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:_pwTextField];
    _pwIcon.centerY = _pwTextField.centerY;
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(48 * WidthRatio, _pwTextField.bottom, MainScreenWidth - 48 * 2 * WidthRatio, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line2];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_accountTextField resignFirstResponder];
        [_pwTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
