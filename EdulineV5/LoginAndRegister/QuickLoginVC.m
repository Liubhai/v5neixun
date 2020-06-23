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
#import "NTESQLHomePageCustomUIModel.h"

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

@property (weak, nonatomic) NTESQuickLoginManager *quickLoginManager;


@property (nonatomic, assign) BOOL shouldQL;
@property (nonatomic, assign) BOOL precheckSuccess;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *accessToken;

@end

@implementation QuickLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = [UIColor whiteColor];
    self.quickLoginManager = [NTESQuickLoginManager sharedInstance];
    [self registerQuickLogin];
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
    [_seleteBtn setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
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

- (void)otherLoginButtonClicked:(UIButton *)sender {
    if ([NTESQuickLoginManager sharedInstance].model.currentVC) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.dissOrPop = NO;
        [self.navigationController.presentedViewController.navigationController pushViewController:vc animated:YES];
    }
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
    [dict setObject:_phoneLabel.text forKey:@"token"];
    [dict setObject:_phoneLabel.text forKey:@"accessToken"];
    [Net_API requestPOSTWithURLStr:[Net_Path userLoginPath:nil] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSString *ak = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"ak"]];
                NSString *sk = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"auth_token"] objectForKey:@"sk"]];
                [UserModel saveUserPassportToken:ak andTokenSecret:sk];
                [UserModel saveUid:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"id"]]];
                [UserModel saveAuth_scope:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"auth_scope"]]];
                [UserModel saveUname:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"nick_name"]]];
                [UserModel saveAvatar:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"avatar_url"]]];
                [UserModel saveNickName:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"user_name"]]];
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

/// 使用易盾提供的businessID进行初始化业务，回调中返回初始化结果
- (void)registerQuickLogin {
    // 在使用一键登录之前，请先调用shouldQuickLogin方法，判断当前上网卡的网络环境和运营商是否可以一键登录
    self.shouldQL = [[NTESQuickLoginManager sharedInstance] shouldQuickLogin];
    
    if (self.shouldQL) {
        [[NTESQuickLoginManager sharedInstance] registerWithBusinessID:WangyiQuickLoginBusenissID timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            if (success) {
                self.token = [params objectForKey:@"token"];
                self.precheckSuccess = YES;
                [self getPhoneNumberWithText:@""];
            } else {
                NSLog(@"precheck失败");
                self.precheckSuccess = NO;
            }
        }];
    }
}

- (void)getPhoneNumberWithText:(NSString *)title {
    if (!self.shouldQL || !self.precheckSuccess) {
        NSLog(@"不允许一键登录");
        return;
    }
    
    [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            [self setCustomUI];
            if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 1) {
                [self authorizeCTLoginWithText:title];
            } else if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 2) {
                [self authorizeCMLoginWithText:title];
            } else {
                [self authorizeCULoginWithText:title];
            }
        } else {
            
        }
    }];
}

/// 电信授权认证接口
- (void)authorizeCTLoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            // 取号失败
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
            }
        }
    }];
}

/// 移动授权认证接口
- (void)authorizeCMLoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
            }
        }
    }];
}

/// 联通授权认证接口
- (void)authorizeCULoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"10104"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"10105"]) {
                NSLog(@"切换登录方式");
            }
        }
    }];
}

/// 调用服务端接口进行校验
- (void)startCheckWithText:(NSString *)title {
    NSDictionary *dict = @{
        @"accessToken":self.accessToken?:@"",
        @"token":self.token?:@"",
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        return;
    }
    
//    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_TOKEN_QLCHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:YES completion:nil];
//            if (data) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                NSNumber *code = [dict objectForKey:@"code"];
//
//                if ([code integerValue] == 200) {
//                    NSDictionary *data = [dict objectForKey:@"data"];
//                    NSString *phoneNum = [data objectForKey:@"phone"];
//                    if (phoneNum && phoneNum.length > 0) {
//                        NTESQPLoginSuccessViewController *vc = [[NTESQPLoginSuccessViewController alloc] init];
//                        vc.themeTitle = title;
//                        vc.type = NTESQuickLoginType;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    } else {
//                        [self.navigationController pushViewController:self.loginViewController animated:YES];
//                        [self.loginViewController updateView];
//
//                        #ifdef TEST_MODE_QA
//                        [self.loginViewController showToastWithMsg:@"一键登录失败"];
//                        #endif
//                    }
//                } else if ([code integerValue] == 1003){
//                    [self.navigationController pushViewController:self.loginViewController animated:YES];
//                    [self.loginViewController updateView];
//                } else {
//                    [self.navigationController pushViewController:self.loginViewController animated:YES];
//                    [self.loginViewController updateView];
//
//                    #ifdef TEST_MODE_QA
//                    [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"错误，code=%@", code]];
//                    #endif
//                }
//            } else {
//                [self.navigationController pushViewController:self.loginViewController animated:YES];
//                [self.loginViewController updateView];
//
//                #ifdef TEST_MODE_QA
//                [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
//                #endif
//            }
//        });
//    }];
}

/// 授权页面自定义
- (void)setCustomUI {
    NTESQuickLoginCustomModel *model = [NTESQLHomePageCustomUIModel configCustomUIModel];
    model.currentVC = self;
    
    model.customViewBlock = ^(UIView * _Nullable customView) {
        UIButton *otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 100, 30)];
        [otherBtn setTitle:@"其他方式登录" forState:0];
        [otherBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
        otherBtn.titleLabel.font = SYSTEMFONT(14);
        otherBtn.centerX = MainScreenWidth / 2.0;
        [otherBtn addTarget:self action:@selector(otherLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:otherBtn];
    };
    [[NTESQuickLoginManager sharedInstance] setupModel:model];
}

@end
