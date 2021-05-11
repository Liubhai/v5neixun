//
//  MoneyPassWordPopView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/21.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MoneyPassWordPopView.h"
#import "V5_Constant.h"

@implementation MoneyPassWordPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 164)];
    _whiteBackView.layer.masksToBounds = YES;
    _whiteBackView.layer.cornerRadius = 7;
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    _whiteBackView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    [self addSubview:_whiteBackView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((_whiteBackView.width - 200) / 2.0, 20, 200, 20)];
    _tipLabel.text = @"请输入支付密码";
    _tipLabel.textColor = EdlineV5_Color.textFirstColor;
    _tipLabel.font = SYSTEMFONT(18);
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_whiteBackView addSubview:_tipLabel];
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(_whiteBackView.width - 30, 0, 30, 30)];
    [_closeButton setImage:Image(@"money_close") forState:0];
    [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_closeButton];
    
    _passwordTextView = [[SHPasswordTextView alloc]initWithFrame:CGRectMake(15, _tipLabel.bottom + 25, _whiteBackView.width - 30, 35) count:6 margin:0.1 passwordFont:15 forType:SHPasswordTextTypeRectangle block:^(NSString * _Nonnull passwordStr) {
        NSLog(@"shihu___passwordStr == %@",passwordStr);
        if (passwordStr.length>=6) {
            if (self->_delegate && [self->_delegate respondsToSelector:@selector(getMoneyPasWordString:)]) {
                [self->_delegate getMoneyPasWordString:passwordStr];
            }
        }
    }];
    _passwordTextView.passwordSecureEntry = YES;//安全密码
    [_passwordTextView.textField becomeFirstResponder];
    [_whiteBackView addSubview:_passwordTextView];
    
    _forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _passwordTextView.bottom + 25, 70, 20)];
    [_forgetBtn setTitle:@"忘记密码" forState:0];
    [_forgetBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    _forgetBtn.titleLabel.font = SYSTEMFONT(16);
    [_forgetBtn addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_forgetBtn];
    _forgetBtn.centerX = _whiteBackView.width / 2.0;
}

- (void)closeButtonClick {
    [self removeFromSuperview];
    [self removeAllSubviews];
}

- (void)forgetButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpSetPwPage)]) {
        [_delegate jumpSetPwPage];
    }
}

@end
