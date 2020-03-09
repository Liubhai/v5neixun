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

@interface SurePwViewController ()

@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) SurePassWordView *passWordView;
@property (strong, nonatomic) UILabel *agreementLabel;

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
}

- (void)makeSubViews {
    
    _passWordView = [[SurePassWordView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 101)];
    [self.view addSubview:_passWordView];
    [_passWordView setHeight:_passWordView.height];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WidthRatio, _passWordView.bottom + 40, MainScreenWidth - 30 * WidthRatio, 40)];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    [_sureButton setTitle:_titleLabel.text forState:0];
    _sureButton.titleLabel.font = SYSTEMFONT(18);
    [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    [self.view addSubview:_sureButton];
    
    if (_registerOrForget) {
        _passWordView.firstPwLabel.text = @"设置密码";
        _agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _sureButton.bottom + 15, MainScreenWidth, 20)];
        _agreementLabel.font = SYSTEMFONT(13);
        _agreementLabel.textColor = EdlineV5_Color.textThirdColor;
        _agreementLabel.textAlignment = NSTextAlignmentCenter;
        NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleDisplayName"];
        NSString *atr = [NSString stringWithFormat:@"《%@服务协议》",appName];
        NSString *final = [NSString stringWithFormat:@"注册即表示阅读并同意%@",atr];
        NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:final];
        [mut addAttributes:@{@"NSForegroundColorAttributeName":EdlineV5_Color.themeColor} range:[final rangeOfString:atr]];
        _agreementLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
        [self.view addSubview:_agreementLabel];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
