//
//  QuickLoginVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "QuickLoginVC.h"

#define topspace 111.0 * HeightRatio
#define phoneNumSpace 67 * HeightRatio
#define loginBtnSpace 20 * HeightRatio
#define otherLoginBtnSapce 37.5 * HeightRatio

@interface QuickLoginVC ()

@property (strong, nonatomic) UIImageView *logImageView;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *otherBtn;


@end

@implementation QuickLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = [UIColor whiteColor];
    [self makeSubViews];
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
    [self.view addSubview:_loginBtn];
    
    _otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _loginBtn.bottom + 30, 100, 30)];
    [_otherBtn setTitle:@"其他方式登录" forState:0];
    [_otherBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    _otherBtn.titleLabel.font = SYSTEMFONT(14);
    _otherBtn.centerX = MainScreenWidth / 2.0;
    [self.view addSubview:_otherBtn];
}

- (void)leftButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
