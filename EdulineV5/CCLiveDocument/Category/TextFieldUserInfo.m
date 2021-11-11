//
//  LabelUserInfo.m
//  NewCCDemo
//
//  Created by cc on 2016/11/23.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "TextFieldUserInfo.h"

@interface TextFieldUserInfo()

@property(nonatomic,strong)UIView               *upLine;
@property(nonatomic,strong)UIView               *customRightView;

@end

@implementation TextFieldUserInfo

//- (void)textFieldWithLeftText:(NSString *)leftText placeholder:(NSString *)placeholder lineLong:(BOOL)lineLong text:(NSString *)text {
//    WS(ws);
//
//    self.borderStyle = UITextBorderStyleNone;
//    self.backgroundColor = [UIColor whiteColor];
//    self.placeholder = placeholder;
//    self.font = [UIFont systemFontOfSize:FontSize_28];
//    self.placeholder = placeholder;
//    self.text = text;
//    self.textColor = CCRGBColor(51, 51, 51);
//    self.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.autocorrectionType = UITextAutocorrectionTypeDefault;
//    self.clearsOnBeginEditing = NO;
//    self.textAlignment = NSTextAlignmentLeft;
//    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.keyboardType = UIKeyboardTypeDefault;
//    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    self.returnKeyType =UIReturnKeyDone;
//    self.keyboardAppearance=UIKeyboardAppearanceDefault;
//    self.leftViewMode = UITextFieldViewModeAlways;
//
//    [self addSubview:self.upLine];
//    self.leftView = self.leftLabelView;
//    [_leftLabelView addSubview:self.leftLabel];
//    [self.leftLabel setText:leftText];
//
//    if(lineLong) {
//        [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(ws);
//            make.top.mas_equalTo(ws.mas_top);
//            make.height.mas_equalTo(1);
//        }];
//    } else {
//        [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(ws).offset(20);
//            make.right.mas_equalTo(ws).offset(-20);
//            make.top.mas_equalTo(ws.mas_top);
//            make.height.mas_equalTo(1);
//        }];
//    }
//
//    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(ws.leftLabelView).with.offset(20);
//        make.right.top.mas_equalTo(ws.leftLabelView);
//        make.bottom.mas_equalTo(ws.leftLabelView).offset(-1);
//    }];
//}
//
//-(UIView *)upLine {
//    if(_upLine == nil) {
//        _upLine = [[UIView alloc] init];
//        [_upLine setBackgroundColor:CCRGBColor(238,238,238)];
//    }
//    return _upLine;
//}
//
//-(UIView *)leftLabelView {
//    if(_leftLabelView == nil) {
//        _leftLabelView = [[UIView alloc] init];
//        [_leftLabelView setBackgroundColor:[UIColor whiteColor]];
//        [_leftLabelView setFrame:CGRectMake(0, 2, 95, 46 - 2)];
//    }
//    return _leftLabelView;
//}
//
//-(UILabel *)leftLabel {
//    if(_leftLabel == nil) {
//        _leftLabel = [[UILabel alloc] init];
//        [_leftLabel setBackgroundColor:[UIColor whiteColor]];
//        [_leftLabel setTextColor:[UIColor blackColor]];
//        [_leftLabel setFont:[UIFont systemFontOfSize:FontSize_28]];
//        _leftLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _leftLabel;
//}

- (void)textFieldWithLeftText:(NSString *)leftText placeholderAttri:(NSAttributedString *)placeholder lineLong:(BOOL)lineLong text:(NSString *)text
{
    WS(ws);
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.attributedPlaceholder = placeholder;
    self.font = [UIFont systemFontOfSize:FontSizeClass_13];
    self.text = text;
    self.textColor = CCRGBColor(51, 51, 51);
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.clearsOnBeginEditing = NO;
    self.textAlignment = NSTextAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.keyboardType = UIKeyboardTypeDefault;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.returnKeyType =UIReturnKeyDone;
    self.keyboardAppearance=UIKeyboardAppearanceDefault;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:self.upLine];
    self.leftView = self.leftLabelView;
    [_leftLabelView addSubview:self.leftLabel];
    [self.leftLabel setText:leftText];
    
    self.rightView = self.customRightView;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    if (leftText.length > 0)
    {
        if(lineLong) {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws);
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        } else {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws).offset(CCGetRealFromPt(40));
                make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(40));
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        }
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.leftLabelView).with.offset(CCGetRealFromPt(40));
            make.right.and.top.mas_equalTo(ws.leftLabelView);
            make.bottom.mas_equalTo(ws.leftLabelView).offset(-1);
        }];
    }
    else
    {
        if(lineLong) {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws);
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        } else {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws).offset(CCGetRealFromPt(40));
                make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(40));
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        }
        [_leftLabelView setFrame:CGRectMake(0, 2, CCGetRealFromPt(40), CCGetRealFromPt(92) - 2)];
    }
}

- (void)textFieldWithLeftText:(NSString *)leftText placeholder:(NSString *)placeholder lineLong:(BOOL)lineLong text:(NSString *)text {
    WS(ws);
    
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.placeholder = placeholder;
    self.font = [UIFont systemFontOfSize:FontSizeClass_13];
    self.placeholder = placeholder;
    self.text = text;
    self.textColor = CCRGBColor(51, 51, 51);
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.clearsOnBeginEditing = NO;
    self.textAlignment = NSTextAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.keyboardType = UIKeyboardTypeDefault;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.returnKeyType =UIReturnKeyDone;
    self.keyboardAppearance=UIKeyboardAppearanceDefault;
    self.leftViewMode = UITextFieldViewModeAlways;

    [self addSubview:self.upLine];
    self.leftView = self.leftLabelView;
    [_leftLabelView addSubview:self.leftLabel];
    [self.leftLabel setText:leftText];
    
    self.rightView = self.customRightView;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    if (leftText.length > 0)
    {
        if(lineLong) {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws);
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        } else {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws).offset(CCGetRealFromPt(40));
                make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(40));
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        }
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.leftLabelView).with.offset(CCGetRealFromPt(40));
            make.right.and.top.mas_equalTo(ws.leftLabelView);
            make.bottom.mas_equalTo(ws.leftLabelView).offset(-1);
        }];
    }
    else
    {
        if(lineLong) {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws);
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        } else {
            [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws).offset(CCGetRealFromPt(40));
                make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(40));
                make.top.mas_equalTo(ws.mas_top);
                make.height.mas_equalTo(1);
            }];
        }
        [_leftLabelView setFrame:CGRectMake(0, 2, CCGetRealFromPt(40), CCGetRealFromPt(92) - 2)];
    }
}

-(UIView *)upLine {
    if(_upLine == nil) {
        _upLine = [UIView new];
        [_upLine setBackgroundColor:CCRGBColor(238,238,238)];
    }
    return _upLine;
}

-(UIView *)leftLabelView {
    if(_leftLabelView == nil) {
        _leftLabelView = [UIView new];
        [_leftLabelView setBackgroundColor:[UIColor whiteColor]];
        [_leftLabelView setFrame:CGRectMake(0, 2, CCGetRealFromPt(190), CCGetRealFromPt(92) - 2)];
    }
    return _leftLabelView;
}

-(UILabel *)leftLabel {
    if(_leftLabel == nil) {
        _leftLabel = [UILabel new];
        [_leftLabel setBackgroundColor:[UIColor whiteColor]];
        [_leftLabel setTextColor:[UIColor blackColor]];
        [_leftLabel setFont:[UIFont systemFontOfSize:FontSizeClass_13]];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UIView *)customRightView
{
    if (_customRightView == nil)
    {
        UIButton *rigthView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [rigthView setBackgroundColor:[UIColor clearColor]];
        [rigthView setBackgroundImage:[UIImage imageNamed:@"x-1"] forState:UIControlStateNormal];
        [rigthView setTitle:nil forState:UIControlStateNormal];
        [rigthView sizeToFit];
        [rigthView setFrame:CGRectMake(0, 0, rigthView.frame.size.width, rigthView.frame.size.height)];
        [rigthView addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *backView = [UIView new];
        CGFloat width = rigthView.frame.size.width + 5;
        CGFloat height = rigthView.frame.size.height;
        backView.frame = CGRectMake(self.frame.size.width - width, (self.frame.size.height - height)/2.f, width, height);
        [backView addSubview:rigthView];
        _customRightView = backView;
    }
    return _customRightView;
}

- (void)rightBtnClicked:(UIButton *)btn
{
    if (self.text.length > 0)
    {
        self.text = @"";
    }
}

@end
