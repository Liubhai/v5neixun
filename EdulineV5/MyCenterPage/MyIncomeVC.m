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
#import "WkWebViewController.h"
#import <UMShare/UMShare.h>
#import "V5_UserModel.h"
#import "MoubaoBindViewController.h"
#import "CourseSortVC.h"

#import "PromotionCourseCell.h"
#import "PromotionUserCell.h"

@interface MyIncomeVC ()<WKUIDelegate,WKNavigationDelegate,TYAttributedLabelDelegate,UITextFieldDelegate,CourseSortVCDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSString *typeString;//方式
    NSString *sple_score_str_first;//比例
    NSString *sple_score_str_second;//比例
    
    // 选择
    NSString *courseSortString;
    NSString *courseSortIdString;
    
    NSInteger page;

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

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *submitButton;

@property (strong, nonatomic) UIView *moubaoSureView;
@property (strong, nonatomic) UITextField *moubaoSureNameTextField;

@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) NSDictionary *balanceInfo;
@property (strong, nonatomic) WKWebView *wkWebView;

/** 头部按钮 */
@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MyIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserIncomeInfo) name:@"reloadIncomeData" object:nil];
    
    sple_score_str_first = @"";
    sple_score_str_second = @"";
    
    _typeArray = [NSMutableArray new];
    _titleImage.backgroundColor = EdlineV5_Color.themeColor;
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
//    _titleLabel.text = @"推广收入";
//    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.hidden = YES;
    
    _headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, _titleLabel.height)];
    [_headerButton setTitle:@"推广收入" forState:UIControlStateNormal];
    [_headerButton setImage:Image(@"income_down_icon") forState:UIControlStateNormal];
    [_headerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _headerButton.titleLabel.font = _titleLabel.font;
    [EdulineV5_Tool dealButtonImageAndTitleUI:_headerButton];
    [_headerButton addTarget:self action:@selector(headerButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_headerButton];
    _headerButton.center = _titleLabel.center;
    
    courseSortString = @"推广收入";
    courseSortIdString = @"all";
    
    _dataSource = [NSMutableArray new];
    
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
    [_mainScrollView removeAllSubviews];
    UIView *account = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 45 + 40 * 2)];
    account.backgroundColor = EdlineV5_Color.themeColor;
    [_mainScrollView addSubview:account];
    
    _userPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, 45)];
    _userPriceLabel.font = SYSTEMFONT(32);
    _userPriceLabel.text = @"0.00";
    _userPriceLabel.textColor = [UIColor whiteColor];
    _userPriceLabel.textAlignment = NSTextAlignmentCenter;
    [account addSubview:_userPriceLabel];
    
//    UILabel * priceType = [[UILabel alloc] initWithFrame:CGRectMake(0, _userPriceLabel.bottom, MainScreenWidth, 45)];
//    priceType.font = SYSTEMFONT(15);
//    priceType.text = @"账户收入";
//    priceType.textAlignment = NSTextAlignmentCenter;
//    priceType.textColor = [UIColor whiteColor];
//    [account addSubview:priceType];
}

- (void)makeMoneyView {
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 + 40 * 2, MainScreenWidth, 1)];
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
    
    UILabel *leftMode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
    leftMode.text = IOSMoneyTitle;
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
    
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seleteViewTapClick:)];
    [_orderTypeView1 addGestureRecognizer:selectTap];
    
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
    
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seleteViewTapClick:)];
    [_orderTypeView2 addGestureRecognizer:selectTap];
    
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
    
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seleteViewTapClick:)];
    [_orderTypeView3 addGestureRecognizer:selectTap];
    
    _orderLeftIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _orderLeftIcon3.image = Image(@"order_yue_icon");
    _orderLeftIcon3.centerY = 56 / 2.0;
    [_orderTypeView3 addSubview:_orderLeftIcon3];
    
    _orderTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(_orderLeftIcon3.right + 12, 0, 150, 56)];
    _orderTitle3.textColor = EdlineV5_Color.textSecendColor;
    _orderTitle3.font = SYSTEMFONT(15);
    _orderTitle3.text = [NSString stringWithFormat:@"余额(%@%@)",IOSMoneyTitle,[_balanceInfo[@"data"] objectForKey:@"balance"]];
    [_orderTypeView3 addSubview:_orderTitle3];
    
    _orderRightBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn3 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn3 setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_orderRightBtn3 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView3 addSubview:_orderRightBtn3];
    
    BOOL hasW = NO;

    if (SWNOTEmptyArr(_typeArray)) {
        if ([_typeArray containsObject:@"lcnpay"]) {
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

- (void)makeOrderType1View4 {
    _orderTypeView4 = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView3.bottom, MainScreenWidth, 56)];
    _orderTypeView4.backgroundColor = [UIColor whiteColor];
    [_orderTypeView addSubview:_orderTypeView4];
    
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seleteViewTapClick:)];
    [_orderTypeView4 addGestureRecognizer:selectTap];
    
    _orderLeftIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _orderLeftIcon4.image = Image(@"income");
    _orderLeftIcon4.centerY = 56 / 2.0;
    [_orderTypeView4 addSubview:_orderLeftIcon4];
    
    _orderTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(_orderLeftIcon4.right + 12, 0, 150, 56)];
    _orderTitle4.textColor = EdlineV5_Color.textSecendColor;
    _orderTitle4.font = SYSTEMFONT(15);
    _orderTitle4.text = [NSString stringWithFormat:@"收入(%@0.00)",IOSMoneyTitle];
    [_orderTypeView4 addSubview:_orderTitle4];
    
    _orderRightBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn4 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn4 setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
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
    _seleteBtn.selected = YES;
    [_seleteBtn addTarget:self action:@selector(seleteAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
    
    _mainScrollView.contentSize = CGSizeMake(0, _agreeBackView.bottom + 10);
}

- (void)makeBottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
    }
    
    [_bottomView removeAllSubviews];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32 + 15, 49)];
    label1.text = @"提现:";
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = SYSTEMFONT(15);
    label1.textColor = EdlineV5_Color.textFirstColor;
    [_bottomView addSubview:label1];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.right + 3, 0, 100, 49)];
    _priceLabel.text = [NSString stringWithFormat:@"%@0.00",IOSMoneyTitle];
    _priceLabel.font = SYSTEMFONT(16);
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [_bottomView addSubview:_priceLabel];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 130, (49 - 36)/2.0, 130, 36)];
    _submitButton.enabled = NO;
    _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    [_submitButton setTitle:@"提现" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height/2.0;
    [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
    
}

- (void)seleteAgreementButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_scoreInputText.text.length>0) {
            _submitButton.enabled = YES;
            _submitButton.backgroundColor = EdlineV5_Color.themeColor;
        } else {
            _submitButton.enabled = NO;
            _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    } else {
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    }
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

- (void)seleteViewTapClick:(UITapGestureRecognizer *)tap {
    if (tap.view == _orderTypeView1) {
        _orderRightBtn1.selected = YES;
        _orderRightBtn2.selected = NO;
        _orderRightBtn3.selected = NO;
        typeString = @"alipay";
    } else if (tap.view == _orderTypeView2) {
        _orderRightBtn2.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn3.selected = NO;
        typeString = @"wxpay";
    } else if (tap.view == _orderTypeView3) {
        _orderRightBtn3.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
        typeString = @"lcnpay";
    } else if (tap.view == _orderTypeView4) {
        _orderRightBtn3.selected = NO;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
        typeString = @"income";
    }
}

- (void)submitButtonClick:(UIButton *)sender {
    if (!SWNOTEmptyStr(_scoreInputText.text)) {
        [self showHudInView:self.view showHint:@"请输入提现金额"];
        _submitButton.enabled = YES;
        return;
    }
    
    if (!SWNOTEmptyStr(typeString)) {
        [self showHudInView:self.view showHint:@"请选择提现方式"];
        _submitButton.enabled = YES;
        return;
    }
    
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请勾选并确认阅读用户服务协议"];
        _submitButton.enabled = YES;
        return;
    }
    
    if ([_scoreInputText.text floatValue] > [_userPriceLabel.text floatValue]) {
        [self showHudInView:self.view showHint:@"余额不足"];
        _submitButton.enabled = YES;
        return;
    }
    
    if ([typeString isEqualToString:@"lcnpay"]) {
        [self toBalance];
    } else if ([typeString isEqualToString:@"wxpay"]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            if (!error) {
                UMSocialUserInfoResponse *resp = result;
                // 第三方登录数据(为空表示平台未提供)
                // 授权数据
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@", resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                // 用户数据
                NSLog(@" name: %@", resp.name);
                NSLog(@" iconurl: %@", resp.iconurl);
                NSLog(@" gender: %@", resp.unionGender);
                // 第三方平台SDK原始数据
                NSLog(@" originalResponse: %@", resp.originalResponse);
                [self toMouxin:resp.openid];
            }
        }];
    } else if ([typeString isEqualToString:@"alipay"]) {
        _submitButton.enabled = YES;
        [self showMoubaoSureView];
    }
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
    NSString *atr = [NSString stringWithFormat:@"%@用户服务协议",appName];
    WkWebViewController *vc = [[WkWebViewController alloc] init];
    vc.titleString = atr;
    vc.agreementKey = @"proService";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textfieldDidChanged:(NSNotification *)notice {
    UITextField *textfield = (UITextField *)notice.object;
    if (textfield == _scoreInputText) {
        if (textfield.text.length>0) {
            _needPriceLabel.text = [NSString stringWithFormat:@"需花费%@%.2f",IOSMoneyTitle,[textfield.text floatValue] * [sple_score_str_first integerValue] / [sple_score_str_second integerValue]];
            _priceLabel.text = [NSString stringWithFormat:@"%@%.2f",IOSMoneyTitle,[textfield.text floatValue] * [sple_score_str_first integerValue] / [sple_score_str_second integerValue]];
            if (_seleteBtn.selected) {
                _submitButton.enabled = YES;
                _submitButton.backgroundColor = EdlineV5_Color.themeColor;
            } else {
                _submitButton.enabled = NO;
                _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
            }
        } else {
            _needPriceLabel.text = [NSString stringWithFormat:@"需花费%@0.00",IOSMoneyTitle];
            _priceLabel.text = [NSString stringWithFormat:@"%@0.00",IOSMoneyTitle];
            _submitButton.enabled = NO;
            _submitButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _scoreInputText) {
        if ([string isEqualToString:@"\n"]) {
            [_scoreInputText resignFirstResponder];
            return NO;
        } else {
            return [self validateNumber:string];
        }
        return YES;
    } else {
        if ([string isEqualToString:@"\n"]) {
            [_moubaoSureNameTextField resignFirstResponder];
            return NO;
        }
        return YES;
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
                    [_typeArray removeAllObjects];
                    [_typeArray addObjectsFromArray:[_balanceInfo[@"data"] objectForKey:@"encashment_way"]];
                    
                    NSString *ratio = [NSString stringWithFormat:@"%@",[_balanceInfo[@"data"] objectForKey:@"ratio"]];
                    NSArray *ratioArray = [ratio componentsSeparatedByString:@":"];
                    if (SWNOTEmptyArr(ratioArray)) {
                        sple_score_str_first = [NSString stringWithFormat:@"%@",ratioArray[0]];
                        sple_score_str_second = [NSString stringWithFormat:@"%@",ratioArray[1]];
                    }
                    
                    [self makeUserAccountUI];
                    
                    _userPriceLabel.text = [NSString stringWithFormat:@"%@",[_balanceInfo[@"data"] objectForKey:@"income"]];
                    
                    if (![ShowAudit isEqualToString:@"1"]) {
                        [self makeMoneyView];
                        
                        [self makeOrderView];
                        
                        [self makeOrderType1View1];
                        [self makeOrderType1View2];
                        [self makeOrderType1View3];
                        [_orderTypeView setHeight:_orderTypeView3.bottom];
                        
                        [self makeAgreeView];
                        
                        [self makeBottomView];
                    }
                    if (!_tableView) {
                        [self makeTableView];
                    }
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)toBalance {
    [Net_API requestPOSTWithURLStr:[Net_Path incomeForBalance] WithAuthorization:nil paramDic:@{@"from":@"ios",@"money":[_priceLabel.text substringFromIndex:1]} finish:^(id  _Nonnull responseObject) {
        _submitButton.enabled = YES;
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self getUserIncomeInfo];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        _submitButton.enabled = YES;
        [self showHudInView:self.view showHint:@"提现失败"];
    }];
}

- (void)toMouxin:(NSString *)mouxinId {
    if (SWNOTEmptyStr(mouxinId)) {
        [Net_API requestPOSTWithURLStr:[Net_Path incomeForMouxin] WithAuthorization:nil paramDic:@{@"from":@"ios",@"money":[_priceLabel.text substringFromIndex:1],@"wxpay_openid":mouxinId} finish:^(id  _Nonnull responseObject) {
            _submitButton.enabled = YES;
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [self getUserIncomeInfo];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            _submitButton.enabled = YES;
            [self showHudInView:self.view showHint:@"提现失败"];
        }];
    }
}

- (void)showMoubaoSureView {
    if (!_moubaoSureView) {
        _moubaoSureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _moubaoSureView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [_moubaoSureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moubaoSureViewTap)]];
    }
    _moubaoSureView.hidden = NO;
    [self.view addSubview:_moubaoSureView];
    [_moubaoSureView removeAllSubviews];
    
    UIView *whiteBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 105, 240)];
    whiteBack.backgroundColor = [UIColor whiteColor];
    whiteBack.layer.masksToBounds = YES;
    whiteBack.layer.cornerRadius = 7;
    [_moubaoSureView addSubview:whiteBack];
    whiteBack.center = CGPointMake(MainScreenWidth / 2.0, MainScreenHeight / 2.0);
    
    UILabel *tip = [[UILabel alloc] initWithFrame: CGRectMake(0, 12, whiteBack.width, 36)];
    tip.text = @"账户确认";
    tip.font = SYSTEMFONT(18);
    tip.textColor = EdlineV5_Color.textFirstColor;
    tip.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:tip];
    
    UILabel *tip1 = [[UILabel alloc] initWithFrame: CGRectMake(0, tip.bottom, whiteBack.width, 22.5)];
    tip1.text = @"是否提现到默认账号：";
    tip1.font = SYSTEMFONT(15);
    tip1.textColor = EdlineV5_Color.textSecendColor;
    tip1.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:tip1];
    
    UILabel *phoneL = [[UILabel alloc] initWithFrame: CGRectMake(0, tip1.bottom + 5, whiteBack.width, 22.5)];
    if (SWNOTEmptyStr([V5_UserModel userPhone])) {
        if ([V5_UserModel userPhone].length > 7) {
            phoneL.text = [[V5_UserModel userPhone] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }
    phoneL.font = SYSTEMFONT(15);
    phoneL.textColor = EdlineV5_Color.textFirstColor;
    phoneL.textAlignment = NSTextAlignmentCenter;
    [whiteBack addSubview:phoneL];
    
    _moubaoSureNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, phoneL.bottom + 8, whiteBack.width - 42, 36)];
    _moubaoSureNameTextField.layer.masksToBounds = YES;
    _moubaoSureNameTextField.layer.cornerRadius = 4;
    _moubaoSureNameTextField.layer.borderWidth = 0.5;
    _moubaoSureNameTextField.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
    _moubaoSureNameTextField.font = SYSTEMFONT(14);
    _moubaoSureNameTextField.textColor = HEXCOLOR(0xBBBBBB);
    _moubaoSureNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入姓名" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:HEXCOLOR(0xBBBBBB)}];
    _moubaoSureNameTextField.returnKeyType = UIReturnKeyDone;
    _moubaoSureNameTextField.delegate = self;
    _moubaoSureNameTextField.centerX = whiteBack.width / 2.0;
    [whiteBack addSubview:_moubaoSureNameTextField];
    
    UIButton *moubaoSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_moubaoSureNameTextField.left, _moubaoSureNameTextField.bottom + 14.5, _moubaoSureNameTextField.width, 36)];
    moubaoSureBtn.layer.cornerRadius = 4;
    [moubaoSureBtn setTitle:@"立即提现" forState:0];
    [moubaoSureBtn setTitleColor:[UIColor whiteColor] forState:0];
    moubaoSureBtn.backgroundColor = EdlineV5_Color.themeColor;
    moubaoSureBtn.titleLabel.font = SYSTEMFONT(16);
    [moubaoSureBtn addTarget:self action:@selector(moubaoSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:moubaoSureBtn];
    
    UIButton *moubaoOtherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moubaoSureBtn.bottom + 12, 200, 22.5)];
    [moubaoOtherBtn setTitle:@"提现至其他账户 >" forState:0];
    [moubaoOtherBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    moubaoOtherBtn.titleLabel.font = SYSTEMFONT(15);
    moubaoOtherBtn.centerX = whiteBack.width / 2.0;
    [moubaoOtherBtn addTarget:self action:@selector(moubaoOtherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:moubaoOtherBtn];
}

- (void)moubaoSureBtnClick:(UIButton *)sender {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([V5_UserModel userPhone]) {
        [param setObject:[V5_UserModel userPhone] forKey:@"alipay_account"];
    }
    if (SWNOTEmptyStr(_moubaoSureNameTextField.text)) {
        [param setObject:_moubaoSureNameTextField.text forKey:@"alipay_user_name"];
    }
    if (SWNOTEmptyStr(_priceLabel.text)) {
        [param setObject:[_priceLabel.text substringFromIndex:1] forKey:@"money"];
    }
    [param setObject:@"ios" forKey:@"from"];
    NSString *name = _moubaoSureNameTextField.text;
    [self moubaoSureViewTap];
    if (!SWNOTEmptyStr(name)) {
        [self showHudInView:self.view showHint:@"请输入中文姓名"];
        return;
    }
    [Net_API requestPOSTWithURLStr:[Net_Path incomeForMoubao] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        _submitButton.enabled = YES;
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self getUserIncomeInfo];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        _submitButton.enabled = YES;
        [self showHudInView:self.view showHint:@"提现失败"];
    }];
}

- (void)moubaoOtherBtnClick:(UIButton *)sender {
    [self moubaoSureViewTap];
    MoubaoBindViewController *vc = [[MoubaoBindViewController alloc] init];
    vc.priceString = [_priceLabel.text substringFromIndex:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moubaoSureViewTap {
    _moubaoSureView.hidden = YES;
    [_moubaoSureView removeAllSubviews];
    [_moubaoSureView removeFromSuperview];
}

// MARK: - 顶部分类按钮点击事件
- (void)headerButtonCilck:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    sender.selected = !sender.selected;
    if (sender.selected) {
        CourseSortVC *vc = [[CourseSortVC alloc] init];
        vc.notHiddenNav = NO;
        vc.hiddenNavDisappear = YES;
        vc.isMainPage = NO;
        vc.pageClass =  @"incomeMainType";
        vc.delegate = self;
        vc.typeId = courseSortIdString;
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

// MARK: - CourseSortVCDelegate(顶部分类选择)
- (void)sortTypeChoose:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        courseSortString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        courseSortIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _headerButton.selected = NO;
        [_headerButton setTitle:courseSortString forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:_headerButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        if ([courseSortIdString isEqualToString:@"course"] || [courseSortIdString isEqualToString:@"user"]) {
            if (_tableView) {
                _tableView.hidden = NO;
                [_tableView.mj_header beginRefreshing];
            }
        } else {
            _tableView.hidden = YES;
        }
    }
}

// MARK: - 创建table
- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    _tableView.hidden = YES;
//    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([courseSortIdString isEqualToString:@"course"]) {
        static NSString *reuse = @"PromotionCourseCell";
        PromotionCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[PromotionCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setPromotionCourseCellInfo:_dataSource[indexPath.row]];
        return cell;
    } else {
        static NSString *reuse = @"PromotionUserCell";
        PromotionUserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[PromotionUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setPromotionUserCellInfo:_dataSource[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([courseSortIdString isEqualToString:@"course"]) {
        return 101;
    }
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - 获取推广列表(用户和课程共用)
- (void)getFirstData {
    page = 1;
    NSString *getUrl = [Net_Path userIncomeUser];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if ([courseSortIdString isEqualToString:@"user"]) {
        getUrl = [Net_Path userIncomeUser];
    } else if ([courseSortIdString isEqualToString:@"course"]) {
        getUrl = [Net_Path userIncomeCourse];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                    _tableView.mj_footer.hidden = NO;
                }
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreDataList {
    page = page + 1;
    NSString *getUrl = [Net_Path userIncomeUser];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if ([courseSortIdString isEqualToString:@"user"]) {
        getUrl = [Net_Path userIncomeUser];
    } else if ([courseSortIdString isEqualToString:@"course"]) {
        getUrl = [Net_Path userIncomeCourse];
    }
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

@end
