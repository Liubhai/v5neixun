//
//  SurePwViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SurePwViewController.h"
#import "SurePassWordView.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "EdulineV5_Tool.h"
#import "WkWebViewController.h"

@interface SurePwViewController ()<TYAttributedLabelDelegate>

@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) SurePassWordView *passWordView;
@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;
@property (strong, nonatomic) UIButton *seleteBtn;

@end

@implementation SurePwViewController

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
    
    _passWordView = [[SurePassWordView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 101) isReset:NO];
    [self.view addSubview:_passWordView];
    [_passWordView setHeight:_passWordView.height];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WidthRatio, _passWordView.bottom + 40, MainScreenWidth - 30 * WidthRatio, 40)];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    [_sureButton setTitle:_registerOrForget ? @"注册" : @"确定" forState:0];
    _sureButton.titleLabel.font = SYSTEMFONT(18);
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    
    [self.view addSubview:_sureButton];
    
    if (_registerOrForget) {
        
        _passWordView.firstPwLabel.text = @"设置密码";
        
        NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
        NSString *atr = [NSString stringWithFormat:@"《%@用户使用协议》",appName];
        NSString *fullString = [NSString stringWithFormat:@"   注册即表示阅读并同意%@",atr];
        NSRange atrRange = [fullString rangeOfString:atr];
        
        _agreementTyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, _sureButton.bottom + 15, MainScreenWidth - 30 * WidthRatio, 20)];
        _agreementTyLabel.font = SYSTEMFONT(13);
        _agreementTyLabel.textAlignment = kCTTextAlignmentCenter;
        _agreementTyLabel.textColor = EdlineV5_Color.textSecendColor;
        _agreementTyLabel.delegate = self;
        _agreementTyLabel.numberOfLines = 0;
        
        TYLinkTextStorage *textStorage = [[TYLinkTextStorage alloc]init];
        textStorage.textColor = EdlineV5_Color.themeColor;
        textStorage.font = SYSTEMFONT(13);
        textStorage.linkData = @{@"type":@"service"};
        textStorage.underLineStyle = kCTUnderlineStyleNone;
        textStorage.range = atrRange;
        textStorage.text = atr;
        
        // 属性文本生成器
        TYTextContainer *attStringCreater = [[TYTextContainer alloc]init];
        attStringCreater.text = fullString;
        _agreementTyLabel.textContainer = attStringCreater;
        _agreementTyLabel.textContainer.linesSpacing = 4;
        attStringCreater.font = SYSTEMFONT(13);
        attStringCreater.textAlignment = kCTTextAlignmentCenter;
        attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30 * WidthRatio, 1))];
        [_agreementTyLabel setHeight:_agreementTyLabel.textContainer.textHeight];
        [_agreementTyLabel setTop:_sureButton.bottom + 15];
        [attStringCreater addTextStorageArray:@[textStorage]];
        [self.view addSubview:_agreementTyLabel];
        
        _seleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [_seleteBtn setImage:Image(@"checkbox_nor") forState:0];
        [_seleteBtn setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
        [_seleteBtn addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
        
    }
    
}

- (void)sureButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_registerOrForget) {
        if (!_seleteBtn.selected) {
            NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
            NSString *atr = [NSString stringWithFormat:@"请同意《%@用户使用协议》",appName];
            [self showHudInView:self.view showHint:atr];
            return;
        }
    }
    if (![EdulineV5_Tool validatePassWord:_passWordView.firstPwTextField.text] || ![EdulineV5_Tool validatePassWord:_passWordView.surePwTextField.text]) {
        [self showHudInView:self.view showHint:@"密码格式不正确"];
        return;
    }
    if ([_passWordView.firstPwTextField.text isEqualToString:_passWordView.surePwTextField.text]) {
        if (_registerOrForget) {
            [self setPassWordRequest];
        } else {
            [self reSetPassWordRequest];
        }
    } else {
        [self showHudInView:self.view showHint:@"请确认两次密码一致"];
    }
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    UITextField *pass = (UITextField *)notice.object;
    if (_passWordView.firstPwTextField.text.length>=6 && _passWordView.surePwTextField.text.length>=6) {
        _sureButton.enabled = YES;
        [_sureButton setBackgroundColor:EdlineV5_Color.themeColor];
    } else {
        _sureButton.enabled = NO;
        [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    }
}

- (void)setPassWordRequest {
    [Net_API requestPUTWithURLStr:[Net_Path userSetPwPath:nil] paramDic:@{@"password":[EdulineV5_Tool getmd5WithString:_passWordView.surePwTextField.text]} Api_key:nil finish:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)reSetPassWordRequest {
    [Net_API requestPUTWithURLStr:[Net_Path userResetPwPath:nil] paramDic:@{@"phone":_phoneNum,@"password":[EdulineV5_Tool getmd5WithString:_passWordView.surePwTextField.text],@"pk":_pkString} Api_key:nil finish:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)seleteButtonClick:(UIButton *)sender {
    _seleteBtn.selected = !_seleteBtn.selected;
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    //非文本/比如表情什么的
    if (![textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        return;
    }
    id linkContain = ((TYLinkTextStorage *)textStorage).linkData;
    if ([linkContain isKindOfClass:[NSDictionary class]]) {
        NSString *typeS = [linkContain objectForKey:@"type"];
        if ([typeS isEqualToString:@"service"]) {
            NSLog(@"TYLinkTouch = service");
        } else if ([typeS isEqualToString:@"netservice"]) {
            NSLog(@"TYLinkTouch = netservice");
        }
    }
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"%@用户使用协议",appName];
    WkWebViewController *vc = [[WkWebViewController alloc] init];
    vc.titleString = atr;
    vc.agreementKey = @"agreement";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
