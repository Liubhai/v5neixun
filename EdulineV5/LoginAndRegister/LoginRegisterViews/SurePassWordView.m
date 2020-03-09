//
//  SurePassWordView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SurePassWordView.h"
#import "V5_Constant.h"

@implementation SurePassWordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _firstPwLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, 0, 90, 50)];
    _firstPwLabel.text = @"设置新密码";
    _firstPwLabel.font = SYSTEMFONT(14);
    _firstPwLabel.textColor = EdlineV5_Color.textSecendColor;
    [self addSubview:_firstPwLabel];
    
    _firstPwTextField = [[UITextField alloc] initWithFrame:CGRectMake(_firstPwLabel.right, 0, MainScreenWidth - 15 * WidthRatio - _firstPwLabel.right, 50)];
    _firstPwTextField.font = SYSTEMFONT(14);
    _firstPwTextField.secureTextEntry = YES;
    _firstPwTextField.textColor = EdlineV5_Color.textFirstColor;
    _firstPwTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:_firstPwTextField];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(_firstPwLabel.left, _firstPwLabel.bottom, MainScreenWidth - 30 * WidthRatio, 0.5)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line1];
    
    _surePwLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, _line1.bottom, 90, 50)];
    _surePwLabel.text = @"确认密码";
    _surePwLabel.font = SYSTEMFONT(14);
    _surePwLabel.textColor = EdlineV5_Color.textSecendColor;
    [self addSubview:_surePwLabel];
    
    _surePwTextField = [[UITextField alloc] initWithFrame:CGRectMake(_surePwLabel.right, _surePwLabel.top, MainScreenWidth - 15 * WidthRatio - _surePwLabel.right, 50)];
    _surePwTextField.font = SYSTEMFONT(14);
    _surePwTextField.secureTextEntry = YES;
    _surePwTextField.textColor = EdlineV5_Color.textFirstColor;
    _surePwTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:_surePwTextField];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(_surePwLabel.left, _surePwLabel.bottom, MainScreenWidth - 30 * WidthRatio, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line2];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WidthRatio, _line2.bottom + 10, 16, 16)];
    _iconView.image = Image(@"tips");
    [self addSubview:_iconView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 5, _line2.bottom + 8, MainScreenWidth - 30 * WidthRatio - (_iconView.right + 5), 40)];
    _tipLabel.text = @"密码长度为8～16个字符，密码必须包含大、小写字母和阿拉伯数字";
    _tipLabel.font = SYSTEMFONT(13);
    _tipLabel.textColor = EdlineV5_Color.textThirdColor;
    _tipLabel.numberOfLines = 0;
    [self addSubview:_tipLabel];
    [_tipLabel sizeToFit];
    _tipLabel.frame = CGRectMake(_iconView.right + 5, _line2.bottom + 8, _tipLabel.width, _tipLabel.height);
    [self setHeight:_tipLabel.bottom];
}

@end
