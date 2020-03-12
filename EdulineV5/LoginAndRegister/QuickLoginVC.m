//
//  QuickLoginVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "QuickLoginVC.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "Net_Path.h"

#define topspace 111.0 * HeightRatio
#define phoneNumSpace 67 * HeightRatio
#define loginBtnSpace 20 * HeightRatio
#define otherLoginBtnSapce 37.5 * HeightRatio

@interface QuickLoginVC ()<TYAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *logImageView;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *otherBtn;
@property (strong, nonatomic) UIButton *seleteBtn;

@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;


@end

@implementation QuickLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = [UIColor whiteColor];
    [self makeSubViews];
//    [self testRequest];
}

- (void)makeSubViews {
    _logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topspace, 121, 121)];
    _logImageView.centerX = MainScreenWidth / 2.0;
    _logImageView.image = Image(@"login_logobg");
    [self.view addSubview:_logImageView];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _logImageView.bottom + phoneNumSpace, MainScreenWidth, 30)];
    _phoneLabel.textColor = EdlineV5_Color.textFirstColor;//HEXCOLOR(0x303133);
    _phoneLabel.font = SYSTEMFONT(16);
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_phoneLabel];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _phoneLabel.bottom + loginBtnSpace, 280, 40)];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitle:@"本机号码一键登录" forState:0];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_loginBtn setBackgroundColor:EdlineV5_Color.themeColor];
    _loginBtn.titleLabel.font = SYSTEMFONT(18);
    _loginBtn.centerX = MainScreenWidth / 2.0;
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _loginBtn.bottom + 30, 100, 30)];
    [_otherBtn setTitle:@"其他方式登录" forState:0];
    [_otherBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    _otherBtn.titleLabel.font = SYSTEMFONT(14);
    _otherBtn.centerX = MainScreenWidth / 2.0;
    [_otherBtn addTarget:self action:@selector(otherLoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_otherBtn];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"《%@服务协议》",appName];
    NSString *netName = @"《中国移动认证服务条款》";
    NSString *fullString = [NSString stringWithFormat:@"   使用手机号码一键登录即代表您已同意%@和%@并使用本机号码登录",atr,netName];
    NSRange atrRange = [fullString rangeOfString:atr];
    NSRange netRange = [fullString rangeOfString:netName];
    
    _agreementTyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, MainScreenHeight - 70, MainScreenWidth - 30 * WidthRatio, 40)];
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
    
    TYLinkTextStorage *netTextStorage = [[TYLinkTextStorage alloc]init];
    netTextStorage.textColor = EdlineV5_Color.themeColor;
    netTextStorage.font = SYSTEMFONT(13);
    netTextStorage.linkData = @{@"type":@"netservice"};
    netTextStorage.underLineStyle = kCTUnderlineStyleNone;
    netTextStorage.range = netRange;
    netTextStorage.text = netName;
    
    // 属性文本生成器
    TYTextContainer *attStringCreater = [[TYTextContainer alloc]init];
    attStringCreater.text = fullString;
    _agreementTyLabel.textContainer = attStringCreater;
    _agreementTyLabel.textContainer.linesSpacing = 4;
    attStringCreater.font = SYSTEMFONT(13);
    attStringCreater.textAlignment = kCTTextAlignmentCenter;
    attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30 * WidthRatio, 1))];
    [_agreementTyLabel setHeight:_agreementTyLabel.textContainer.textHeight];
    [_agreementTyLabel setTop:MainScreenHeight - _agreementTyLabel.textContainer.textHeight - 30];
    [attStringCreater addTextStorageArray:@[textStorage,netTextStorage]];
    [self.view addSubview:_agreementTyLabel];
    
    _seleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [_seleteBtn setImage:Image(@"checkbox_nor") forState:0];
    [_seleteBtn setImage:Image(@"checkbox_sel") forState:UIControlStateSelected];
    [_seleteBtn addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
}

- (void)leftButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)otherLoginButtonClick:(UIButton *)sender {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.dissOrPop = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginBtnClick:(UIButton *)sender {
    if (!SWNOTEmptyStr(_phoneLabel.text)) {
        [self showHudInView:self.view showHint:@"暂未获取本机号码"];
        return;
    }
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请阅读协议并勾选"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"phone" forKey:@"logintype"];
    [dict setObject:_phoneLabel.text forKey:@"phone"];
    [Net_API requestPOSTWithURLStr:[Net_Path userLoginPath:nil] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSString *ak = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"ak"]];
                NSString *sk = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"sk"]];
                [UserModel saveUserPassportToken:ak andTokenSecret:sk];
                [UserModel saveUid:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]]];
                [UserModel saveAuth_scope:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"auth_scope"]]];
                [UserModel saveUname:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"user_name"]]];
                [UserModel saveNickName:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"nick_name"]]];
                [UserModel savePhone:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"phone"]]];
                [UserModel saveNeed_set_password:[[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_set_password"]] boolValue]];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
}

- (void)seleteButtonClick:(UIButton *)sender {
    _seleteBtn.selected = !_seleteBtn.selected;
}

- (void)testRequest {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path testApiPath] WithAuthorization:nil paramDic:@{@"phone":@"123456"} finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
