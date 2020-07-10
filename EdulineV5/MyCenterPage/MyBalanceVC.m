//
//  MyBalanceVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyBalanceVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "BalanceDetailVC.h"
#import "CardInterVC.h"
#import "WkWebViewController.h"
#import <WechatOpenSDK/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

@interface MyBalanceVC ()<WKUIDelegate,WKNavigationDelegate,TYAttributedLabelDelegate,UITextFieldDelegate> {
    NSString *typeString;//方式
    UIButton *moneySeleButton;//记录充值的button
    NSString *ratio_string;
}

@property (strong, nonatomic) UIView *account;

@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *userPriceLabel;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIView *moneyView;
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

@property (strong, nonatomic) UIView *agreeBackView;
@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;
@property (strong, nonatomic) UIButton *seleteBtn;

@property (strong, nonatomic) UIButton *submitButton;

@property (strong, nonatomic) NSMutableArray *typeArray;
@property (strong ,nonatomic) NSMutableArray *netWorkBalanceArray;//网络请求下来的个数
@property (strong ,nonatomic) NSMutableArray *iosArray;

@property (strong, nonatomic) NSDictionary *balanceInfo;
@property (strong, nonatomic) WKWebView *wkWebView;

@property (strong, nonatomic) UIButton *cardButton;
@property (strong, nonatomic) UITextField *otherMoneyText;



@end

@implementation MyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self.view addGestureRecognizer:tap];
    
    _typeArray = [NSMutableArray new];
    _netWorkBalanceArray = [NSMutableArray new];
    _iosArray = [NSMutableArray new];
    ratio_string = @"";
    
    _titleImage.backgroundColor = EdlineV5_Color.themeColor;
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _titleLabel.text = @"我的余额";
    _titleLabel.textColor = [UIColor whiteColor];
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"明细" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    _rightButton.hidden = NO;
    
    _lineTL.hidden = YES;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_mainScrollView];
    
    [self makeUserAccountUI];
    
    [self makeBottomView];
    
    [self getUserBalanceInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserBalanceInfo) name:@"orderFinished" object:nil];
}

- (void)makeUserAccountUI {
    _account = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 175 - 44)];
    _account.backgroundColor = EdlineV5_Color.themeColor;
    [_mainScrollView addSubview:_account];
    
    _userPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_account.height - 45 * 2)/2.0, MainScreenWidth, 45)];
    _userPriceLabel.font = SYSTEMFONT(32);
    _userPriceLabel.text = @"0.00";
    _userPriceLabel.textColor = [UIColor whiteColor];
    _userPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_account addSubview:_userPriceLabel];
    
    UILabel * priceType = [[UILabel alloc] initWithFrame:CGRectMake(0, _userPriceLabel.bottom, MainScreenWidth, 45)];
    priceType.font = SYSTEMFONT(15);
    priceType.text = @"余额(元)";
    priceType.textAlignment = NSTextAlignmentCenter;
    priceType.textColor = [UIColor whiteColor];
    [_account addSubview:priceType];
}

- (void)makeMoneyView {
    
    if (_moneyView == nil) {
        _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, _account.bottom, MainScreenWidth, 300)];
        _moneyView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:_moneyView];
    }
    [_moneyView removeAllSubviews];
    
    //名字
    UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(15, 10 , 100, 20)];
    title.text = @"充值";
    title.textColor = EdlineV5_Color.textFirstColor;
    title.font = SYSTEMFONT(15);
    [_moneyView addSubview:title];
    
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _typeArray) {
        if ([payStr isEqualToString:@"alipay"]) {
            isAddAilpayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _typeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddApplepayView = NO;
    for (NSString *payStr in _typeArray) {
        if ([payStr isEqualToString:@"applepay"]) {
            isAddApplepayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddRechargeCardView = NO;
    for (NSString *payStr in _typeArray) {
        if ([payStr isEqualToString:@"cardpay"]) {
            isAddRechargeCardView = YES;
        }
    }
    
    [_netWorkBalanceArray removeAllObjects];
    if (_orderRightBtn3.selected || (!isAddAilpayView && !isAddWxpayView && !isAddRechargeCardView)) {
        [_netWorkBalanceArray addObjectsFromArray:_iosArray];
    } else {
        [_netWorkBalanceArray addObjectsFromArray:[[_balanceInfo[@"data"] objectForKey:@"recharge"] objectForKey:@"public"]];
    }
    
    //添加充值界面
    
    CGFloat buttonW = (MainScreenWidth - 30 - 20) / 3.0;
    CGFloat buttonH = 64;
    NSArray *titleArray = nil;
    NSArray *additionArray = nil;
    NSInteger allNumber = 0;
    if (_netWorkBalanceArray.count == 0) {
        titleArray = @[@"育币20",@"",@"",@"育币   "];
        additionArray = @[@"",@"充50送10",@"充100送30",@""];
        allNumber = 4;
    } else {
        allNumber = _netWorkBalanceArray.count;
    }
    for (int i  = 0 ; i < _netWorkBalanceArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 + (buttonW + 10) * (i % 3), 40 + (buttonH + 15) * (i / 3), buttonW, buttonH)];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 4;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_moneyView addSubview:button];
        
        //钱的数字
        UILabel *number1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 10 , buttonW, 20)];
        number1.text = [NSString stringWithFormat:@"%@育币",[[_netWorkBalanceArray objectAtIndex:i] objectForKey:@"balance"]];
        number1.textColor = EdlineV5_Color.textSecendColor;
        number1.font = SYSTEMFONT(15);
        number1.textAlignment = NSTextAlignmentCenter;
        number1.tag = 100;
        [button addSubview:number1];
        
        //提示
        UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(0, 34 , buttonW, 15)];
        title.tag = 4;
        title.text = @"充50送10";
        if (_netWorkBalanceArray.count == 0) {
            title.text = @"充50送10";
        } else {
            
            if ([[[_netWorkBalanceArray objectAtIndex:i] objectForKey:@"give_balance"] integerValue] == 0 || _orderRightBtn3.selected) {
                title.text = @"";
                number1.frame = CGRectMake(0, 0, buttonW, buttonH);
            } else {
                title.text = [NSString stringWithFormat:@"充%@送%@",[[_netWorkBalanceArray objectAtIndex:i] objectForKey:@"balance"],[[_netWorkBalanceArray objectAtIndex:i] objectForKey:@"give_balance"]];
            }
        }
        title.textColor = EdlineV5_Color.textThirdColor;
        title.font = SYSTEMFONT(12);
        title.textAlignment = NSTextAlignmentCenter;
        [button addSubview:title];
    }
    
    if ((isAddAilpayView || isAddWxpayView || isAddRechargeCardView) && !_orderRightBtn3.selected) {
        _cardButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 40 + (buttonH + 15) * (_netWorkBalanceArray.count % 3 == 0 ? (_netWorkBalanceArray.count / 3) : (_netWorkBalanceArray.count / 3 + 1)), buttonW, 50)];
        _cardButton.backgroundColor = [UIColor whiteColor];
        _cardButton.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
        _cardButton.layer.borderWidth = 1;
        _cardButton.layer.cornerRadius = 4;
        [_cardButton setTitle:@"充值卡" forState:UIControlStateNormal];
        [_cardButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        [_cardButton addTarget:self action:@selector(cardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moneyView addSubview:_cardButton];
        
        _otherMoneyText = [[UITextField alloc] initWithFrame:CGRectMake(_cardButton.right + 10, _cardButton.top, buttonW * 2 + 10, _cardButton.height)];
        _otherMoneyText.backgroundColor = [UIColor whiteColor];
        _otherMoneyText.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
        _otherMoneyText.layer.borderWidth = 1;
        _otherMoneyText.layer.cornerRadius = 4;
        _otherMoneyText.font = SYSTEMFONT(14);
        _otherMoneyText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入其他金额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _otherMoneyText.delegate = self;
        _otherMoneyText.textColor = EdlineV5_Color.textSecendColor;
        _otherMoneyText.returnKeyType = UIReturnKeyDone;
        _otherMoneyText.leftViewMode = UITextFieldViewModeAlways;
        [_moneyView addSubview:_otherMoneyText];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, _otherMoneyText.height)];
        tip.text = @"¥";
        tip.font = SYSTEMFONT(18);
        tip.textColor = EdlineV5_Color.textFirstColor;
        tip.textAlignment = NSTextAlignmentCenter;
        _otherMoneyText.leftView = tip;
    }
    
    if (_netWorkBalanceArray.count % 3 == 0) {//能整除的时候
        _moneyView.frame = CGRectMake(0, CGRectGetMaxY(_account.frame), MainScreenWidth, 40 + (_netWorkBalanceArray.count / 3) * (buttonH + 15) + 50 + 30);
        if (_iosArray.count>0 && (_orderRightBtn3.selected || (!isAddAilpayView && !isAddWxpayView && !isAddRechargeCardView))) {
            _moneyView.frame = CGRectMake(0, CGRectGetMaxY(_account.frame), MainScreenWidth, 40 + (_netWorkBalanceArray.count / 3) * (buttonH + 15) + 30);
        }
    } else {//不能整除的时候
        _moneyView.frame = CGRectMake(0, CGRectGetMaxY(_account.frame), MainScreenWidth, 40 + (_netWorkBalanceArray.count / 3 + 1) * (buttonH + 15) + 50 + 30);
        if (_iosArray.count>0 && (_orderRightBtn3.selected || (!isAddAilpayView && !isAddWxpayView && !isAddRechargeCardView))) {
            _moneyView.frame = CGRectMake(0, CGRectGetMaxY(_account.frame), MainScreenWidth, 40 + (_netWorkBalanceArray.count / 3) * (buttonH + 15) + 30);
        }
    }
    
    _tipSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _moneyView.height - 25, _moneyView.width - 15, 20)];
    _tipSwitchLabel.text = [NSString stringWithFormat:@"注：充值比例为%@",[_balanceInfo[@"data"][@"recharge"] objectForKey:@"ratio"]];
    _tipSwitchLabel.font = SYSTEMFONT(12);
    _tipSwitchLabel.textColor = EdlineV5_Color.textThirdColor;
    [_moneyView addSubview:_tipSwitchLabel];
    _tipSwitchLabel.hidden = YES;
    if (_orderRightBtn3.selected) {
        _tipSwitchLabel.hidden = YES;
    } else {
        _tipSwitchLabel.hidden = NO;
    }
    
    [_orderTypeView setTop:CGRectGetMaxY(_moneyView.frame) + 10];
    [_agreeBackView setTop:CGRectGetMaxY(_orderTypeView.frame) + 10];
    
}

- (void)makeOrderView {
    if (!_orderTypeView) {
        _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _moneyView.bottom + 10, MainScreenWidth, 168)];
        _orderTypeView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:_orderTypeView];
    }
    [_orderTypeView removeAllSubviews];
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
    [_orderRightBtn1 setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_orderRightBtn1 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView1 addSubview:_orderRightBtn1];
    
    BOOL hasMoubao = NO;
    
    if (SWNOTEmptyArr(_typeArray)) {
        if ([_typeArray containsObject:@"alipay"]) {
            hasMoubao = YES;
        } else {
            hasMoubao = NO;
        }
    } else {
        hasMoubao = NO;
    }
    
    if (!hasMoubao) {
        [_orderTypeView1 setHeight:0];
        _orderTypeView1.hidden = YES;
    } else {
        [self seleteButtonClick:_orderRightBtn1];
    }
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
    [_orderRightBtn2 setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_orderRightBtn2 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView2 addSubview:_orderRightBtn2];
    
    BOOL hasW = NO;
    
    if (SWNOTEmptyArr(_typeArray)) {
        if ([_typeArray containsObject:@"wxpay"]) {
            hasW = YES;
        } else {
            hasW = NO;
        }
    } else {
        hasW = NO;
    }
    
    if (!hasW) {
        [_orderTypeView2 setHeight:0];
        _orderTypeView2.hidden = YES;
    } else {
        if (_orderTypeView1.height == 0) {
            [self seleteButtonClick:_orderRightBtn2];
        }
    }
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
    _orderTitle3.text = @"苹果支付";
    [_orderTypeView3 addSubview:_orderTitle3];
    
    _orderRightBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn3 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn3 setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_orderRightBtn3 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView3 addSubview:_orderRightBtn3];
    
    BOOL hasW = NO;
    
    if (SWNOTEmptyArr(_typeArray)) {
        if ([_typeArray containsObject:@"applepay"]) {
            hasW = YES;
        } else {
            hasW = NO;
        }
    } else {
        hasW = NO;
    }
    
    if (!hasW) {
        [_orderTypeView3 setHeight:0];
        _orderTypeView3.hidden = YES;
    } else {
        if (_orderTypeView1.height == 0 && _orderTypeView2.height == 0) {
            [self seleteButtonClick:_orderRightBtn3];
        }
    }
}

- (void)makeAgreeView {
    if (!_agreeBackView) {
        _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView.bottom +10, MainScreenWidth, 60)];
        _agreeBackView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:_agreeBackView];
    }
    
    [_agreeBackView removeAllSubviews];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
    NSString *atr = [NSString stringWithFormat:@"《%@用户服务协议》",appName];
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
    [_seleteBtn setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
    [_seleteBtn addTarget:self action:@selector(seleteAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
    
    _mainScrollView.contentSize = CGSizeMake(0, _agreeBackView.bottom + 10);
}

- (void)makeBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32 + 15, 49)];
    label1.text = @"实付:";
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
    [_submitButton setTitle:@"去支付" forState:0];
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
        if ([typeString isEqualToString:@"applepay"]) {
            [self makeMoneyView];
            _priceLabel.text = @"¥0.00";
        }
        typeString = @"alipay";
    } else if (sender == _orderRightBtn2) {
        _orderRightBtn2.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn3.selected = NO;
        if ([typeString isEqualToString:@"applepay"]) {
            [self makeMoneyView];
            _priceLabel.text = @"¥0.00";
        }
        typeString = @"wxpay";
    } else if (sender == _orderRightBtn3) {
        _orderRightBtn3.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
        if (![typeString isEqualToString:@"applepay"]) {
            [self makeMoneyView];
            _priceLabel.text = @"¥0.00";
        }
        typeString = @"applepay";
    }
}

- (void)viewTap {
    [_otherMoneyText resignFirstResponder];
}

- (void)buttonCilck:(UIButton *)button {
    [_otherMoneyText resignFirstResponder];
    NSLog(@"----%ld",button.tag);
    moneySeleButton.selected = NO;
    moneySeleButton.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
    if ([moneySeleButton viewWithTag:100]) {
        ((UILabel *)[moneySeleButton viewWithTag:100]).textColor = EdlineV5_Color.textSecendColor;
    }
    button.selected = YES;
    moneySeleButton = button;
    
    if (button.selected == YES) {
        button.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
        if ([button viewWithTag:100]) {
            ((UILabel *)[button viewWithTag:100]).textColor = EdlineV5_Color.themeColor;
        }
        
    } else {
        button.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
        if ([button viewWithTag:100]) {
            ((UILabel *)[button viewWithTag:100]).textColor = EdlineV5_Color.textSecendColor;
        }
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",[[_netWorkBalanceArray objectAtIndex:button.tag] objectForKey:@"price"]];
    
}

- (void)cardButtonClick:(UIButton *)sender {
    CardInterVC *vc = [[CardInterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    moneySeleButton.selected = NO;
    moneySeleButton.layer.borderColor = EdlineV5_Color.fengeLineColor.CGColor;
    if ([moneySeleButton viewWithTag:100]) {
        ((UILabel *)[moneySeleButton viewWithTag:100]).textColor = EdlineV5_Color.textSecendColor;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else {
        return [self validateNumber:string];
    }
}

- (void)textfieldDidChanged:(NSNotification *)notice {
    UITextField *textfield = (UITextField *)notice.object;
    if (textfield.text.length>0) {
        if (textfield.text.length == 1) {
            if ([textfield.text isEqualToString:@"0"]) {
                textfield.text = @"";
            }
        }
        if (textfield.text.length>5) {
            textfield.text = [textfield.text substringToIndex:5];
        }
        _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[textfield.text floatValue] * [ratio_string floatValue] / 100.00];
    } else {
        _priceLabel.text = @"¥0.00";
    }
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


- (void)submitButtonClick:(UIButton *)sender {
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请勾选并确认阅读用户服务协议"];
        _submitButton.enabled = YES;
        return;
    }
    
    if (![typeString isEqualToString:@"applepay"]) {
        // 这里先处理普通流程
        NSMutableDictionary *param = [NSMutableDictionary new];
        
        if (moneySeleButton) {
            if (moneySeleButton.selected) {
                NSDictionary *pass = _netWorkBalanceArray[moneySeleButton.tag];
                NSString *pass_balance = [NSString stringWithFormat:@"%@",pass[@"balance"]];
                NSString *pass_chargeId = [NSString stringWithFormat:@"%@",pass[@"id"]];
                [param setObject:@([pass_balance floatValue]) forKey:@"balance"];
                NSString *price = [_priceLabel.text substringFromIndex:1];
                [param setObject:@([price floatValue]) forKey:@"payment"];
                [param setObject:pass_chargeId forKey:@"recharge_id"];
                [param setObject:@"ios" forKey:@"from"];
            } else {
                if (SWNOTEmptyStr(_otherMoneyText.text)) {
                    [param setObject:@([_otherMoneyText.text floatValue]) forKey:@"balance"];
                    NSString *price = [_priceLabel.text substringFromIndex:1];
                    [param setObject:@([price floatValue]) forKey:@"payment"];
                    [param setObject:@"0" forKey:@"recharge_id"];
                    [param setObject:@"ios" forKey:@"from"];
                } else {
                    [self showHudInView:self.view showHint:@"请选择或者输入需要充值的金额"];
                    _submitButton.enabled = YES;
                    return;
                }
            }
        } else {
            if (SWNOTEmptyStr(_otherMoneyText.text)) {
                [param setObject:_otherMoneyText.text forKey:@"balance"];//@([_otherMoneyText.text floatValue])
                NSString *price = [_priceLabel.text substringFromIndex:1];
                [param setObject:price forKey:@"payment"];//
                [param setObject:@"0" forKey:@"recharge_id"];
                [param setObject:@"ios" forKey:@"from"];
            } else {
                [self showHudInView:self.view showHint:@"请选择或者输入需要充值的金额"];
                _submitButton.enabled = YES;
                return;
            }
        }
        // 生成余额订单
        [self createBalanceOrder:param];
    }
    
    
}

// MARK: - 生成余额订单
- (void)createBalanceOrder:(NSDictionary *)dict {
    if (SWNOTEmptyDictionary(dict)) {
        [Net_API requestPOSTWithURLStr:[Net_Path balanceOrderCreate] WithAuthorization:nil paramDic:dict finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [self submiteOrder:[responseObject objectForKey:@"data"]];
                } else {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 支付
- (void)submiteOrder:(NSDictionary *)dict {
    if (SWNOTEmptyDictionary(dict) && SWNOTEmptyStr(typeString)) {
        NSMutableDictionary *pass = [NSMutableDictionary new];
        [pass setObject:[dict objectForKey:@"order_no"] forKey:@"order_no"];
        [pass setObject:typeString forKey:@"pay_type"];
        [Net_API requestPOSTWithURLStr:[Net_Path subMitOrder] WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    if ([typeString isEqualToString:@"wxpay"]) {
                        [self otherOrderTypeWx:[[responseObject objectForKey:@"data"] objectForKey:@"paybody"]];
                    } else if ([typeString isEqualToString:@"alipay"]) {
                        [self orderFinish:[[responseObject objectForKey:@"data"] objectForKey:@"paybody"]];
                    }
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)orderFinish:(NSString *)orderS {
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderS fromScheme:AlipayBundleId callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

//- (void)addWkWebView:(NSString *)urlS {
//    if (_wkWebView && [_wkWebView superview]) {
//        [_wkWebView removeFromSuperview];
//    }
//    if (!_wkWebView) {
//        _wkWebView = [[WKWebIntroview alloc] initWithFrame:CGRectMake(0, MainScreenHeight * 2, MainScreenWidth,MainScreenHeight)];
//        _wkWebView.backgroundColor = [UIColor whiteColor];
//        [_wkWebView setUserInteractionEnabled:YES];
//        _wkWebView.scrollView.scrollEnabled = NO;
//        _wkWebView.UIDelegate = self;
//        _wkWebView.navigationDelegate = self;
//    }
//    [self.view addSubview:_wkWebView];
//    NSString *allStr = [NSString stringWithFormat:@"%@",urlS];
//    [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:allStr]]];
//}
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSString *url = navigationAction.request.URL.absoluteString;
//    NSString *schme = [navigationAction.request.URL scheme];
//    if ([url containsString:@"alipay://alipayclient"]) {
//        NSMutableString *param = [NSMutableString stringWithFormat:@"%@", (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)url, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))];
//
//        NSRange range = [param rangeOfString:@"{"];
//        // 截取 json 部分
//        NSString *param1 = [param substringFromIndex:range.location];
//        if ([param1 rangeOfString:@"\"fromAppUrlScheme\":"].length > 0) {
//            NSData *data = [param1 dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//            if (![tempDic isKindOfClass:[NSDictionary class]]) {
//                WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyCancel;
//                //这句是必须加上的，不然会异常
//                decisionHandler(actionPolicy);
//                return;
//            }
//
//            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:tempDic];
//            dicM[@"fromAppUrlScheme"] = AlipayBundleId;
//
//            NSError *error;
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicM options:NSJSONWritingPrettyPrinted error:&error];
//            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//            NSString *encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                           (CFStringRef)jsonStr, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//
//            // 只替换 json 部分
//            [param replaceCharactersInRange:NSMakeRange(range.location, param.length - range.location)  withString:encodedString];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
//        }
//    }
//    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
//    //这句是必须加上的，不然会异常
//    decisionHandler(actionPolicy);
//}

- (void)otherOrderTypeWx:(NSString *)str {
    NSString * timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"=====%@",timeString);
    str = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
    str = [str stringByReplacingOccurrencesOfString:@"”" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"”" withString:@""];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"partnerid"]];
    request.prepayId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"prepayid"]];
    request.package = [NSString stringWithFormat:@"%@",[dict objectForKey:@"package"]];
    request.nonceStr= [NSString stringWithFormat:@"%@",[dict objectForKey:@"noncestr"]];
    request.timeStamp= timeString.intValue;
    request.timeStamp= [[NSString stringWithFormat:@"%@",[dict objectForKey:@"timestamp"]] intValue];
    request.sign= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sign"]];
    [WXApi sendReq:request completion:^(BOOL success) {
        if (success) {

        }
    }];
}

// MARK: - 协议点击代理
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
    NSString *atr = [NSString stringWithFormat:@"%@用户服务协议",appName];
    WkWebViewController *vc = [[WkWebViewController alloc] init];
    vc.titleString = atr;
    vc.agreementKey = @"proService";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightButtonClick:(id)sender {
    BalanceDetailVC *vc = [[BalanceDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getUserBalanceInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userBalanceInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _balanceInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                if (SWNOTEmptyDictionary(_balanceInfo[@"data"])) {
                    _userPriceLabel.text = [NSString stringWithFormat:@"%@",[_balanceInfo[@"data"] objectForKey:@"balance"]];
                    [_typeArray removeAllObjects];
                    [_typeArray addObjectsFromArray:[_balanceInfo[@"data"] objectForKey:@"payway"]];
                    [_typeArray addObject:@"applepay"];
                    
                    [_netWorkBalanceArray removeAllObjects];
                    [_netWorkBalanceArray addObjectsFromArray:[[_balanceInfo[@"data"] objectForKey:@"recharge"] objectForKey:@"public"]];
                    
                    NSString *ratio = [NSString stringWithFormat:@"%@",[[_balanceInfo[@"data"] objectForKey:@"recharge"] objectForKey:@"ratio"]];
                    NSArray *ratioArray = [ratio componentsSeparatedByString:@":"];
                    if (SWNOTEmptyArr(ratioArray)) {
                        ratio_string = [NSString stringWithFormat:@"%@",ratioArray[0]];
                    }
                    
                    [_iosArray removeAllObjects];
                    [_iosArray addObjectsFromArray:[[_balanceInfo[@"data"] objectForKey:@"recharge"] objectForKey:@"ios"]];
                    
                    [self makeMoneyView];
                    [self makeOrderView];
                    
                    [self makeOrderType1View1];
                    [self makeOrderType1View2];
                    [self makeOrderType1View3];
                    [_orderTypeView setHeight:_orderTypeView3.bottom];
                    
                    [self makeAgreeView];
                    
                    _priceLabel.text = @"¥0.00";
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
