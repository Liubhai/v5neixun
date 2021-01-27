//
//  LoginMsgView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LoginMsgView.h"
#import "V5_Constant.h"

@implementation LoginMsgView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _areaNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(48 * WidthRatio, 0, 33, 50)];
    _areaNumLabel.font = SYSTEMFONT(14);
    _areaNumLabel.textColor = EdlineV5_Color.textSecendColor;
    _areaNumLabel.text = @"+86";
    [self addSubview:_areaNumLabel];
    
    _jiantouImage = [[UIImageView alloc] initWithFrame:CGRectMake(_areaNumLabel.right, 0, 11, 6)];
    _jiantouImage.centerY = _areaNumLabel.centerY;
    _jiantouImage.image = Image(@"login-down");
    [self addSubview:_jiantouImage];
    
    _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(_areaNumLabel.left, 0, _jiantouImage.right - _areaNumLabel.left, 50)];
    _areaBtn.backgroundColor = [UIColor clearColor];
    [_areaBtn addTarget:self action:@selector(areaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _areaBtn.enabled = NO;
    [self addSubview:_areaBtn];
    
    _phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(_jiantouImage.right + 15 * WidthRatio, 0, MainScreenWidth - 48 * WidthRatio - (_jiantouImage.right + 15 * WidthRatio), 50)];
    _phoneNumTextField.delegate = self;
    _phoneNumTextField.returnKeyType = UIReturnKeyDone;
    _phoneNumTextField.font = SYSTEMFONT(14);
    _phoneNumTextField.textColor = EdlineV5_Color.textFirstColor;
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:_phoneNumTextField];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(48 * WidthRatio, _phoneNumTextField.bottom, MainScreenWidth - 48 * 2 * WidthRatio, 0.5)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line1];
    
    /// 这个过度的 UITextField 是为了解决 12系统上 当手机只有搜狗输入法的时候,页面有两个或者两个以上的 UITextField 设置了 secureTextEntry 之后,相邻的 UITextField 也会被系统判定成 secureTextEntry 从而导致切换不到搜狗输入法
    UITextField *pass = [[UITextField alloc] initWithFrame:CGRectMake(0, _line1.bottom, MainScreenWidth, 0.5)];
    [self addSubview:pass];
    
    _yanzhengCode = [[UILabel alloc] initWithFrame:CGRectMake(48 * WidthRatio, pass.bottom, 62, 50)];
    _yanzhengCode.font = SYSTEMFONT(14);
    _yanzhengCode.textColor = EdlineV5_Color.textSecendColor;
    _yanzhengCode.text = @"验证码";
    [self addSubview:_yanzhengCode];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(_yanzhengCode.right, pass.bottom, MainScreenWidth - 48 * WidthRatio - _yanzhengCode.right, 50)];
    _codeTextField.delegate = self;
    _codeTextField.returnKeyType = UIReturnKeyDone;
    _codeTextField.font = SYSTEMFONT(14);
    _codeTextField.textColor = EdlineV5_Color.textFirstColor;
    _codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_codeTextField];
    
    _senderCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 48 * WidthRatio - 100, 0, 100, 20)];
    [_senderCodeBtn setTitle:@"获取验证码" forState:0];
    _senderCodeBtn.titleLabel.font = SYSTEMFONT(14);
    [_senderCodeBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_senderCodeBtn setTitleColor:EdlineV5_Color.textThirdColor forState:UIControlStateDisabled];
    _senderCodeBtn.centerY = _codeTextField.centerY;
    [_senderCodeBtn addTarget:self action:@selector(senderCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_senderCodeBtn];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(48 * WidthRatio, _codeTextField.bottom, MainScreenWidth - 48 * 2 * WidthRatio, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line2];
}

- (void)areaBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpAreaNumList)]) {
        [_delegate jumpAreaNumList];
    }
}

- (void)setAreaNumLabelText:(NSString *)num {
    
    CGFloat numWidth = [num sizeWithFont:_areaNumLabel.font].width + 4;
    [_areaNumLabel setWidth: (numWidth<=33) ? 33 : numWidth];
    _areaNumLabel.text = num;
    [_jiantouImage setLeft:_areaNumLabel.right];
    [_phoneNumTextField setLeft:_jiantouImage.right + 15 * WidthRatio];
}

- (void)senderCodeButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(getMsgCode:)]) {
        [_delegate getMsgCode:sender];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_phoneNumTextField resignFirstResponder];
        [_codeTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
