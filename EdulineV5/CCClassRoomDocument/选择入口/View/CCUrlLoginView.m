//
//  CCUrlLoginView.m
//  CCClassRoom
//
//  Created by 刘强强 on 2021/6/25.
//  Copyright © 2021 cc. All rights reserved.
//

#import "CCUrlLoginView.h"


@interface CCUrlLoginView ()<UITextFieldDelegate>



@end

@implementation CCUrlLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    
    [self addSubview:self.textFieldUserName];
    [self.textFieldUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)textFieldDidChange:(UITextField *) TextField
{
    [self updateLogin];
}

- (void)updateLogin {
    BOOL canLogin = NO;
    if(StrNotEmpty(_textFieldUserName.text))
    {
        canLogin = YES;
    }
    if ([self.delegate respondsToSelector:@selector(urlPathEditUpdateLogin:)]) {
        [self.delegate urlPathEditUpdateLogin:canLogin];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollerViewUpdate {
    [self updateLogin];
}

- (TextFieldUserInfo *)textFieldUserName
{
    if(_textFieldUserName == nil) {
        _textFieldUserName = [TextFieldUserInfo new];
        NSString *str = HDClassLocalizeString(@"请输入课堂链接") ;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        [text addAttribute:NSForegroundColorAttributeName value:CCRGBColor(153,153,153) range:NSMakeRange(0, str.length)];
        [_textFieldUserName textFieldWithLeftText:@"" placeholderAttri:text lineLong:NO text:nil];
        _textFieldUserName.delegate = self;
        _textFieldUserName.tag = 3;
        _textFieldUserName.font = [UIFont systemFontOfSize:FontSizeClass_16];
        [_textFieldUserName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldUserName.layer.cornerRadius = 25;
        _textFieldUserName.layer.masksToBounds = YES;
        _textFieldUserName.backgroundColor = CCRGBColor(243, 243, 243);
        _textFieldUserName.leftLabel.backgroundColor = CCRGBColor(243, 243, 243);
        _textFieldUserName.leftLabelView.backgroundColor = CCRGBColor(243, 243, 243);
//        _textFieldUserName.layer.borderColor = CCRGBColor(218, 218, 218).CGColor;
//        _textFieldUserName.layer.borderWidth = 1.f;
    }
    return _textFieldUserName;
}

- (void)reloadLanguage {
    NSString *str = HDClassLocalizeString(@"请输入课堂链接") ;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName value:CCRGBColor(153,153,153) range:NSMakeRange(0, str.length)];
    [self.textFieldUserName textFieldWithLeftText:@"" placeholderAttri:text lineLong:NO text:nil];
    _textFieldUserName.layer.cornerRadius = 25;
    _textFieldUserName.layer.masksToBounds = YES;
    _textFieldUserName.backgroundColor = CCRGBColor(243, 243, 243);
    _textFieldUserName.leftLabel.backgroundColor = CCRGBColor(243, 243, 243);
    _textFieldUserName.leftLabelView.backgroundColor = CCRGBColor(243, 243, 243);
}
@end
