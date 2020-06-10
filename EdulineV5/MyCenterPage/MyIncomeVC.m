//
//  MyIncomeVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyIncomeVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "IncomeDetailVC.h"

@interface MyIncomeVC ()<WKUIDelegate,WKNavigationDelegate,TYAttributedLabelDelegate,UITextFieldDelegate> {
    NSString *typeString;//方式
    NSString *sple_score_str;//比例
}

@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *userPriceLabel;
@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UIView *moneyView;
@property (strong, nonatomic) UILabel *needPriceLabel;
@property (strong, nonatomic) UITextField *scoreInputText;
@property (strong, nonatomic) UILabel *tipSwitchLabel;

@property (strong, nonatomic) UIView *orderTypeView;

@property (strong, nonatomic) UIView *orderTypeView1;
@property (strong, nonnull) UIImageView *orderLeftIcon1;
@property (strong, nonnull) UILabel *orderTitle1;
@property (strong, nonatomic) UIButton *orderRightBtn1;

@property (strong, nonatomic) UIView *orderTypeView2;
@property (strong, nonnull) UIImageView *orderLeftIcon2;
@property (strong, nonnull) UILabel *orderTitle2;
@property (strong, nonatomic) UIButton *orderRightBtn2;

@property (strong, nonatomic) UIView *orderTypeView3;
@property (strong, nonnull) UIImageView *orderLeftIcon3;
@property (strong, nonnull) UILabel *orderTitle3;
@property (strong, nonatomic) UIButton *orderRightBtn3;

@property (strong, nonatomic) UIView *orderTypeView4;
@property (strong, nonnull) UIImageView *orderLeftIcon4;
@property (strong, nonnull) UILabel *orderTitle4;
@property (strong, nonatomic) UIButton *orderRightBtn4;

@property (strong, nonatomic) UIView *agreeBackView;
@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;
@property (strong, nonatomic) UIButton *seleteBtn;

@property (strong, nonatomic) UIButton *submitButton;

@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) NSDictionary *balanceInfo;
@property (strong, nonatomic) WKWebView *wkWebView;

@end

@implementation MyIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    sple_score_str = @"10";
    
    _typeArray = [NSMutableArray new];
    _titleImage.backgroundColor = EdlineV5_Color.themeColor;
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _titleLabel.text = @"我的收入";
    _titleLabel.textColor = [UIColor whiteColor];
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"明细" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    _rightButton.hidden = NO;
    
    _lineTL.hidden = YES;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_mainScrollView];
    
    [self getUserIncomeInfo];
}

- (void)makeUserAccountUI {
    UIView *account = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 175 - 44)];
    account.backgroundColor = EdlineV5_Color.themeColor;
    [_mainScrollView addSubview:account];
    
    _userPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (account.height - 45 * 2)/2.0, MainScreenWidth, 45)];
    _userPriceLabel.font = SYSTEMFONT(32);
    _userPriceLabel.text = @"0.00";
    _userPriceLabel.textColor = [UIColor whiteColor];
    _userPriceLabel.textAlignment = NSTextAlignmentCenter;
    [account addSubview:_userPriceLabel];
    
    UILabel * priceType = [[UILabel alloc] initWithFrame:CGRectMake(0, _userPriceLabel.bottom, MainScreenWidth, 45)];
    priceType.font = SYSTEMFONT(15);
    priceType.text = @"账户收入";
    priceType.textAlignment = NSTextAlignmentCenter;
    priceType.textColor = [UIColor whiteColor];
    [account addSubview:priceType];
}

- (void)makeMoneyView {
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 175 - 44, MainScreenWidth, 1)];
    _moneyView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_moneyView];
    
    UILabel *tip1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 100, 21)];
    tip1.text = @"提现";
    tip1.textColor = EdlineV5_Color.textFirstColor;
    tip1.font = SYSTEMFONT(15);
    [_moneyView addSubview:tip1];
    
    _scoreInputText = [[UITextField alloc] initWithFrame:CGRectMake(15, tip1.bottom + 15, MainScreenWidth - 30, 24)];
    _scoreInputText.font = SYSTEMFONT(14);
    _scoreInputText.textColor = EdlineV5_Color.textFirstColor;
    _scoreInputText.returnKeyType = UIReturnKeyDone;
    _scoreInputText.textAlignment = NSTextAlignmentLeft;
    _scoreInputText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入提现金额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _scoreInputText.centerX = _moneyView.width / 2.0;
    _scoreInputText.delegate = self;
    [_moneyView addSubview:_scoreInputText];
    
    UILabel *leftMode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftMode.text = @"¥";
    leftMode.textColor = EdlineV5_Color.textFirstColor;
    leftMode.font = SYSTEMFONT(14);
    _scoreInputText.leftView = leftMode;
    _scoreInputText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _scoreInputText.bottom + 5, _scoreInputText.width, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    line.centerX = _scoreInputText.centerX;
    [_moneyView addSubview:line];
    
    _tipSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(tip1.left, line.bottom + 15, _moneyView.width - tip1.left, 20)];
    _tipSwitchLabel.text = [NSString stringWithFormat:@"注：提现到余额后不能再转至银行卡或支付宝，转账比例为%@",[_balanceInfo[@"data"] objectForKey:@"ratio"]];
    _tipSwitchLabel.font = SYSTEMFONT(12);
    _tipSwitchLabel.textColor = EdlineV5_Color.textThirdColor;
    [_moneyView addSubview:_tipSwitchLabel];
    
    [_moneyView setHeight:_tipSwitchLabel.bottom + 10];
}

- (void)makeOrderView {
    _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _moneyView.bottom + 10, MainScreenWidth, 168)];
    _orderTypeView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_orderTypeView];
}

- (void)makeOrderType1View1 {
    _orderTypeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 56)];
    _orderTypeView1.backgroundColor = [UIColor whiteColor];
    
    [_orderTypeView addSubview:_orderTypeView1];
    
    _orderLeftIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _orderLeftIcon1.image = Image(@"order_zhifubao_icon");
    _orderLeftIcon1.centerY = 56 / 2.0;
    [_orderTypeView1 addSubview:_orderLeftIcon1];
    
    _orderTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(_orderLeftIcon1.right + 12, 0, 100, 56)];
    _orderTitle1.textColor = EdlineV5_Color.textSecendColor;
    _orderTitle1.font = SYSTEMFONT(15);
    _orderTitle1.text = @"支付宝";
    [_orderTypeView1 addSubview:_orderTitle1];
    
    _orderRightBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn1 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn1 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
    [_orderRightBtn1 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView1 addSubview:_orderRightBtn1];
    
//    BOOL hasMoubao = NO;
//
//    if (SWNOTEmptyArr(_typeArray)) {
//        if ([_typeArray containsObject:@"alipay"]) {
//            hasMoubao = YES;
//        } else {
//            hasMoubao = NO;
//        }
//    } else {
//        hasMoubao = NO;
//    }
//
//    if (!hasMoubao) {
//        [_orderTypeView1 setHeight:0];
//        _orderTypeView1.hidden = YES;
//    } else {
//        [self seleteButtonClick:_orderRightBtn1];
//    }
}

- (void)makeOrderType1View2 {
    _orderTypeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView1.bottom, MainScreenWidth, 56)];
    _orderTypeView2.backgroundColor = [UIColor whiteColor];
    [_orderTypeView addSubview:_orderTypeView2];
    
    _orderLeftIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _orderLeftIcon2.image = Image(@"order_wechat_icon");
    _orderLeftIcon2.centerY = 56 / 2.0;
    [_orderTypeView2 addSubview:_orderLeftIcon2];
    
    _orderTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(_orderLeftIcon2.right + 12, 0, 100, 56)];
    _orderTitle2.textColor = EdlineV5_Color.textSecendColor;
    _orderTitle2.font = SYSTEMFONT(15);
    _orderTitle2.text = @"微信";
    [_orderTypeView2 addSubview:_orderTitle2];
    
    _orderRightBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn2 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn2 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
    [_orderRightBtn2 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView2 addSubview:_orderRightBtn2];
    
//    BOOL hasW = NO;
//
//    if (SWNOTEmptyArr(_typeArray)) {
//        if ([_typeArray containsObject:@"wxpay"]) {
//            hasW = YES;
//        } else {
//            hasW = NO;
//        }
//    } else {
//        hasW = NO;
//    }
//
//    if (!hasW) {
//        [_orderTypeView2 setHeight:0];
//        _orderTypeView2.hidden = YES;
//    } else {
//        if (_orderTypeView1.height == 0) {
//            [self seleteButtonClick:_orderRightBtn2];
//        }
//    }
}

- (void)makeOrderType1View3 {
    _orderTypeView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView2.bottom, MainScreenWidth, 56)];
    _orderTypeView3.backgroundColor = [UIColor whiteColor];
    [_orderTypeView addSubview:_orderTypeView3];
    
    _orderLeftIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _orderLeftIcon3.image = Image(@"order_yue_icon");
    _orderLeftIcon3.centerY = 56 / 2.0;
    [_orderTypeView3 addSubview:_orderLeftIcon3];
    
    _orderTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(_orderLeftIcon3.right + 12, 0, 150, 56)];
    _orderTitle3.textColor = EdlineV5_Color.textSecendColor;
    _orderTitle3.font = SYSTEMFONT(15);
    _orderTitle3.text = [NSString stringWithFormat:@"余额(¥%@)",[_balanceInfo[@"data"] objectForKey:@"balance"]];//@"余额(¥0.00)";
    [_orderTypeView3 addSubview:_orderTitle3];
    
    _orderRightBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn3 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn3 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
    [_orderRightBtn3 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView3 addSubview:_orderRightBtn3];
    
//    BOOL hasW = NO;
//
//    if (SWNOTEmptyArr(_typeArray)) {
//        if ([_typeArray containsObject:@"applepay"]) {
//            hasW = YES;
//        } else {
//            hasW = NO;
//        }
//    } else {
//        hasW = NO;
//    }
//
//    if (!hasW) {
//        [_orderTypeView3 setHeight:0];
//        _orderTypeView3.hidden = YES;
//    } else {
//        if (_orderTypeView1.height == 0 && _orderTypeView2.height == 0) {
//            [self seleteButtonClick:_orderRightBtn3];
//        }
//    }
}

- (void)makeOrderType1View4 {
    _orderTypeView4 = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView3.bottom, MainScreenWidth, 56)];
    _orderTypeView4.backgroundColor = [UIColor whiteColor];
    [_orderTypeView addSubview:_orderTypeView4];
    
    _orderLeftIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _orderLeftIcon4.image = Image(@"income");
    _orderLeftIcon4.centerY = 56 / 2.0;
    [_orderTypeView4 addSubview:_orderLeftIcon4];
    
    _orderTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(_orderLeftIcon4.right + 12, 0, 150, 56)];
    _orderTitle4.textColor = EdlineV5_Color.textSecendColor;
    _orderTitle4.font = SYSTEMFONT(15);
    _orderTitle4.text = @"收入(¥0.00)";
    [_orderTypeView4 addSubview:_orderTitle4];
    
    _orderRightBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn4 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn4 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
    [_orderRightBtn4 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView4 addSubview:_orderRightBtn4];
    
//    BOOL hasW = NO;
//
//    if (SWNOTEmptyArr(_typeArray)) {
//        if ([_typeArray containsObject:@"income"]) {
//            hasW = YES;
//        } else {
//            hasW = NO;
//        }
//    } else {
//        hasW = NO;
//    }
//
//    if (!hasW) {
//        [_orderTypeView4 setHeight:0];
//        _orderTypeView4.hidden = YES;
//    } else {
//        if (_orderTypeView1.height == 0 && _orderTypeView2.height == 0 && _orderTypeView3.height == 0) {
//            [self seleteButtonClick:_orderRightBtn4];
//        }
//    }
}

- (void)makeAgreeView {
    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView.bottom +10, MainScreenWidth, 60)];
    _agreeBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_agreeBackView];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"《%@购买协议》",appName];
    NSString *fullString = [NSString stringWithFormat:@"   我已阅读并同意%@",atr];
    NSRange atrRange = [fullString rangeOfString:atr];
    
    _agreementTyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 20)];
    _agreementTyLabel.centerY = 60 / 2.0;
    _agreementTyLabel.font = SYSTEMFONT(13);
    _agreementTyLabel.textAlignment = kCTTextAlignmentLeft;
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
    attStringCreater.textAlignment = kCTTextAlignmentLeft;
    attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30, 1))];
    [_agreementTyLabel setHeight:_agreementTyLabel.textContainer.textHeight];
    _agreementTyLabel.centerY = 60 / 2.0;
    [attStringCreater addTextStorageArray:@[textStorage]];
    [_agreeBackView addSubview:_agreementTyLabel];
    
    _seleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [_seleteBtn setImage:Image(@"checkbox_nor") forState:0];
    [_seleteBtn setImage:Image(@"checkbox_sel") forState:UIControlStateSelected];
    [_seleteBtn addTarget:self action:@selector(seleteAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
    
    _mainScrollView.contentSize = CGSizeMake(0, _agreeBackView.bottom + 10);
}

- (void)makeBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32 + 15, 49)];
    label1.text = @"提现:";
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = SYSTEMFONT(15);
    label1.textColor = EdlineV5_Color.textFirstColor;
    [bottomView addSubview:label1];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.right + 3, 0, 100, 49)];
    _priceLabel.text = @"¥0.00";
    _priceLabel.font = SYSTEMFONT(16);
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [bottomView addSubview:_priceLabel];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 130, (49 - 36)/2.0, 130, 36)];
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    [_submitButton setTitle:@"提现" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height/2.0;
    [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_submitButton];
    
}

- (void)seleteAgreementButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)seleteButtonClick:(UIButton *)sender {
    if (sender == _orderRightBtn1) {
        _orderRightBtn1.selected = YES;
        _orderRightBtn2.selected = NO;
        _orderRightBtn3.selected = NO;
//        _orderRightBtn4.selected = NO;
        typeString = @"alipay";
    } else if (sender == _orderRightBtn2) {
        _orderRightBtn2.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn3.selected = NO;
//        _orderRightBtn4.selected = NO;
        typeString = @"wxpay";
    } else if (sender == _orderRightBtn3) {
        _orderRightBtn3.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
//        _orderRightBtn4.selected = NO;
        typeString = @"lcnpay";
    } else if (sender == _orderRightBtn4) {
//        _orderRightBtn4.selected = YES;
        _orderRightBtn3.selected = NO;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
        typeString = @"income";
    }
}

- (void)submitButtonClick:(UIButton *)sender {
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请勾选并确认阅读购买协议"];
        _submitButton.enabled = YES;
        return;
    }
}

- (void)textfieldDidChanged:(NSNotification *)notice {
    UITextField *textfield = (UITextField *)notice.object;
    if (textfield.text.length>0) {
        _needPriceLabel.text = [NSString stringWithFormat:@"需花费¥%.2f",[textfield.text floatValue] / [sple_score_str integerValue]];
        _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[textfield.text floatValue] / [sple_score_str integerValue]];
    } else {
        _needPriceLabel.text = @"需花费¥0.00";
        _priceLabel.text = @"¥0.00";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_scoreInputText resignFirstResponder];
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

- (void)rightButtonClick:(id)sender {
    IncomeDetailVC *vc = [[IncomeDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getUserIncomeInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userIncomeDetail] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _balanceInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                if (SWNOTEmptyDictionary(_balanceInfo[@"data"])) {
                    _userPriceLabel.text = [NSString stringWithFormat:@"%@",[_balanceInfo[@"data"] objectForKey:@"income"]];
                    [_typeArray removeAllObjects];
                    [_typeArray addObjectsFromArray:[_balanceInfo[@"data"] objectForKey:@"encashment_way"]];
                    
                    [self makeUserAccountUI];
                    [self makeMoneyView];
                    
                    [self makeOrderView];
                    
                    [self makeOrderType1View1];
                    [self makeOrderType1View2];
                    [self makeOrderType1View3];
                    [_orderTypeView setHeight:_orderTypeView3.bottom];
                    
                    [self makeAgreeView];
                    
                    [self makeBottomView];
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
