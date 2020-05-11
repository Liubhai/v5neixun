//
//  CardInterVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CardInterVC.h"
#import "V5_Constant.h"

@interface CardInterVC ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *cardNumT;
@property (strong, nonatomic) UIButton *sureButton;

@end

@implementation CardInterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"充值卡";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    _cardNumT = [[UITextField alloc] initWithFrame:CGRectMake(15, 15 + MACRO_UI_UPHEIGHT, MainScreenWidth - 80 - 15 * 3, 36)];
    _cardNumT.layer.masksToBounds = YES;
    _cardNumT.layer.cornerRadius = 4;
    _cardNumT.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
    _cardNumT.layer.borderWidth = 1;
    _cardNumT.font = SYSTEMFONT(14);
    _cardNumT.textColor = EdlineV5_Color.textFirstColor;
    _cardNumT.returnKeyType = UIReturnKeyDone;
    _cardNumT.textAlignment = NSTextAlignmentLeft;
    _cardNumT.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入充值卡卡号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _cardNumT.delegate = self;
    [self.view addSubview:_cardNumT];
    
    UIView *leftMode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 36)];
    leftMode.backgroundColor = [UIColor whiteColor];
    _cardNumT.leftView = leftMode;
    _cardNumT.leftViewMode = UITextFieldViewModeAlways;
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_cardNumT.right + 15, 15 + MACRO_UI_UPHEIGHT, 80, 36)];
    [_sureButton setTitle:@"充值" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 4;
    [self.view addSubview:_sureButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textfieldDidChanged:(NSNotification *)notice {
    UITextField *textfield = (UITextField *)notice.object;
    if (textfield.text.length>0) {
        _sureButton.enabled = YES;
    } else {
        _sureButton.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_cardNumT resignFirstResponder];
        return NO;
    } else {
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
