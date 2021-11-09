//
//  CCClassCodeView.m
//  CCClassRoom
//
//  Created by 刘强强 on 2021/6/25.
//  Copyright © 2021 cc. All rights reserved.
//

#import "CCClassCodeView.h"

#import "CCTool.h"
#import "HDSTool.h"

@interface CCClassCodeView ()<UITextFieldDelegate>
@property(nonatomic, strong)UIButton *verticalScreenBtn;
@property(nonatomic, strong)UIButton *landscapeBtn;
@property(nonatomic, assign)BOOL needPassword;
@end

@implementation CCClassCodeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    
    [self addSubview:self.classCodeTF];
    [self.classCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.userNameTF];
    [self.userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.classCodeTF.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.passWordTF];
    [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.userNameTF.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.verticalScreenBtn];
    [self addSubview:self.landscapeBtn];
    NSArray *btns = [NSArray arrayWithObjects:self.verticalScreenBtn, self.landscapeBtn, nil];
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(self.passWordTF.mas_bottom).offset(15);
    }];
}
- (void)textFieldDidChange:(UITextField *) TextField
{
    if (TextField.tag == 1001) {
        ///需要请求接口
        if (TextField.text.length == 9) {
            [self getRoomidDesc];
        }else if (TextField.text.length > 9) {
            TextField.text = [TextField.text substringToIndex:9];
            [self getRoomidDesc];
        }
    }
}


//textfield例子
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect pFrame = [textField convertRect:textField.frame toView:self.superview.superview.superview];
    CGFloat offset = SCREEN_HEIGHT - (pFrame.origin.y+pFrame.size.height+216+50);
    if(offset<=0){
      [UIView animateWithDuration:0.3 animations:^{
          UIScrollView *scrollView = (UIScrollView *)self.superview.superview;
          scrollView.contentOffset = CGPointMake(0, offset*-1);
      }];
    }
    return  YES;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
//    if (textField.tag == 1001) {
        ///需要请求接口
//        [self getRoomidDesc];
//    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    if (textField.tag == 1001) {
//        ///需要请求接口
//        [self getRoomidDesc];
//    }
    [UIView animateWithDuration:0.3 animations:^{
        UIScrollView *scrollView = (UIScrollView *)self.superview.superview;
        scrollView.contentOffset = CGPointMake(0, 0);
    }];
    [self updateLogin];
    return YES;
}

- (void)updateLogin {
    BOOL canLogin = NO;
    if (self.needPassword) {
        if(StrNotEmpty(_classCodeTF.text) && StrNotEmpty(_userNameTF.text) && StrNotEmpty(_passWordTF.text))
        {
            canLogin = YES;
        } else {
            canLogin = NO;
        }
        
    }else {
        if(StrNotEmpty(_classCodeTF.text) && StrNotEmpty(_userNameTF.text))
        {
            canLogin = YES;
        } else {
            canLogin = NO;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(classCodeViewEditEndUpdateLogin:)]) {
        [self.delegate classCodeViewEditEndUpdateLogin:canLogin];
    }
}

- (void)scrollerViewUpdate {
    [self updateLogin];
}

- (void)verticalScreenBtnAction:(UIButton *)btn {
    [self selectVerticalScreen:YES];
}

- (void)landscapeBtnAction:(UIButton *)btn {
    [self selectVerticalScreen:NO];
}

- (void)getRoomidDesc {
    if ([self.delegate respondsToSelector:@selector(getRoomIdAndDesc:)]) {
        [self.delegate getRoomIdAndDesc:self.classCodeTF.text];
    }
}

- (void)updateView:(CCRoomDecModel *)model {
    BOOL isNeedPassword = YES;
    if (self.classCodeTF.text.length == 9) {
        if ([self.classCodeTF.text hasSuffix:@"0"] || [self.classCodeTF.text hasSuffix:@"4"]) {///老师 助教
            ///需要密码
            isNeedPassword = YES;
        }else if ([self.classCodeTF.text hasSuffix:@"1"]) {///学生
            isNeedPassword = model.data.talker_authtype == 2 ? NO : YES;
        }else if ([self.classCodeTF.text hasSuffix:@"3"]) {///隐身者
            isNeedPassword = model.data.inspector_authtype == 2 ? NO : YES;
        }
    }else {
        ///异常数据 不需要显示密码
        isNeedPassword = NO;
    }
    self.needPassword = isNeedPassword;
    if (isNeedPassword) {
        ///需要密码
        [self.passWordTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameTF.mas_bottom).offset(15);
            make.height.mas_equalTo(50);
        }];
        self.passWordTF.hidden = NO;
    }else {
        [self.passWordTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameTF.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        self.passWordTF.hidden = YES;
    }
    
    if (model.data.templatetype == 32) {
        self.verticalScreenBtn.hidden = YES;
        self.landscapeBtn.hidden = YES;
    }else {
        self.verticalScreenBtn.hidden = NO;
        self.landscapeBtn.hidden = NO;
    }
    
    [self selectVerticalScreen:YES];
}

- (void)selectVerticalScreen:(BOOL)isSelect {
    self.verticalScreenBtn.selected = isSelect;
    self.landscapeBtn.selected = !isSelect;
    if ([self.delegate respondsToSelector:@selector(landSpaceSelect:)]) {
        [self.delegate landSpaceSelect:!isSelect];
    }
}

#pragma mark - 懒加载
- (TextFieldUserInfo *)classCodeTF
{
    if(_classCodeTF == nil) {
        _classCodeTF = [self getTextField:1001 placeholder:HDClassLocalizeString(@"请输入参课码") ];
        _classCodeTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _classCodeTF;
}

- (TextFieldUserInfo *)userNameTF
{
    if(_userNameTF == nil) {
        _userNameTF = [self getTextField:1002 placeholder:HDClassLocalizeString(@"请输入用户名") ];
    }
    return _userNameTF;
}

- (TextFieldUserInfo *)passWordTF
{
    if(_passWordTF == nil) {
        _passWordTF = [self getTextField:1003 placeholder:HDClassLocalizeString(@"请输入密码") ];
        _passWordTF.hidden = YES;
        _passWordTF.secureTextEntry = YES;
    }
    return _passWordTF;
}

- (TextFieldUserInfo *)getTextField:(NSInteger)tag placeholder:(NSString *)placeholder {
    TextFieldUserInfo *TF = [self viewWithTag:tag];
    if (!TF) {
        TF = [TextFieldUserInfo new];
    }
    NSString *str = placeholder;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName value:CCRGBColor(153,153,153) range:NSMakeRange(0, str.length)];
    [TF textFieldWithLeftText:@"" placeholderAttri:text lineLong:NO text:nil];
    TF.backgroundColor = CCRGBColor(243, 243, 243);
    TF.delegate = self;
    TF.tag = tag;
    TF.font = [UIFont systemFontOfSize:FontSizeClass_16];
    [TF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    TF.layer.cornerRadius = 25;
    TF.layer.masksToBounds = YES;
    TF.leftLabel.backgroundColor = CCRGBColor(243, 243, 243);
    TF.leftLabelView.backgroundColor = CCRGBColor(243, 243, 243);
    
    return TF;
}

- (UIButton *)verticalScreenBtn {
    if (!_verticalScreenBtn) {
        _verticalScreenBtn = [[UIButton alloc] init];
        _verticalScreenBtn.layer.cornerRadius = 25;
        _verticalScreenBtn.layer.masksToBounds = YES;
        [_verticalScreenBtn setTitle:HDClassLocalizeString(@"竖屏模式") forState:UIControlStateNormal];
        [_verticalScreenBtn setTitleColor:CCRGBColor(51, 51, 51) forState:UIControlStateNormal];
        [_verticalScreenBtn setTitleColor:CCRGBColor(51, 51, 51) forState:UIControlStateSelected];
        [_verticalScreenBtn setImage:[UIImage imageNamed:(@"未选") ] forState:UIControlStateNormal];
        [_verticalScreenBtn setImage:[UIImage imageNamed:(@"已选") ] forState:UIControlStateSelected];
        [_verticalScreenBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255, 255, 255)] forState:UIControlStateNormal];
        [_verticalScreenBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:255/255.0 green:132/255.0 blue:47/255.0 alpha:0.2]] forState:UIControlStateSelected];
        [_verticalScreenBtn addTarget:self action:@selector(verticalScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _verticalScreenBtn.hidden = YES;
        _verticalScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return _verticalScreenBtn;
}

- (UIButton *)landscapeBtn {
    if (!_landscapeBtn) {
        _landscapeBtn = [[UIButton alloc] init];
        _landscapeBtn.layer.cornerRadius = 25;
        _landscapeBtn.layer.masksToBounds = YES;
        [_landscapeBtn setTitle:HDClassLocalizeString(@"横屏模式") forState:UIControlStateNormal];
        [_landscapeBtn setTitleColor:CCRGBColor(51, 51, 51) forState:UIControlStateNormal];
        [_landscapeBtn setTitleColor:CCRGBColor(51, 51, 51) forState:UIControlStateSelected];
        [_landscapeBtn setImage:[UIImage imageNamed:(@"未选") ] forState:UIControlStateNormal];
        [_landscapeBtn setImage:[UIImage imageNamed:(@"已选") ] forState:UIControlStateSelected];
        [_landscapeBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255, 255, 255)] forState:UIControlStateNormal];
        [_landscapeBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:255/255.0 green:132/255.0 blue:47/255.0 alpha:0.2]] forState:UIControlStateSelected];
        [_landscapeBtn addTarget:self action:@selector(landscapeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _landscapeBtn.hidden = YES;
        _landscapeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return _landscapeBtn;
}

- (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)reloadLanguage {
    [self getTextField:1001 placeholder:HDClassLocalizeString(@"请输入参课码") ];
    [self getTextField:1002 placeholder:HDClassLocalizeString(@"请输入用户名") ];
    [self getTextField:1003 placeholder:HDClassLocalizeString(@"请输入密码") ];
    [self.landscapeBtn setTitle:HDClassLocalizeString(@"横屏模式") forState:UIControlStateNormal];
    [self.verticalScreenBtn setTitle:HDClassLocalizeString(@"竖屏模式") forState:UIControlStateNormal];
}
@end
