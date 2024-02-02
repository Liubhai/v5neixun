//
//  ShopOrderSureVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/1.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ShopOrderSureVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "AddressListViewController.h"
#import "ScoreListViewController.h"
#import "ScoreListModel.h"
#import "OrderSureViewController.h"

@interface ShopOrderSureVC ()<ScoreListViewControllerDelegate> {
    NSInteger userScore;
    NSInteger shopScore;
    CGFloat shopPrice;
}

@property (strong, nonatomic) NSDictionary *shopInfoDict;
@property (strong, nonatomic) NSDictionary *addressInfoDict;

@property (strong, nonatomic) NSMutableArray *scoresArray;
@property (strong, nonatomic) ScoreListModel *currentScoreModel;

@property (strong, nonatomic) UIScrollView *mainScrollView;

// 选择地址板块儿视图
@property (strong, nonatomic) UIView *addressView;
@property (strong, nonatomic) UIImageView *addressIcon;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *addAddressTipLabel;
@property (strong, nonatomic) UIButton *addressRightIcon;
@property (strong, nonatomic) UIButton *chooseAddressBtn;

// 商品信息板块儿视图
@property (strong, nonatomic) UIView *shopInfoBackView;
@property (strong, nonatomic) UIImageView *shopFaceView;
@property (strong, nonatomic) UILabel *shopTitleLabel;
@property (strong, nonatomic) UILabel *shopPriceLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UILabel *numTipLabel;
@property (strong, nonatomic) UIView *numControlView;//66 + 2
@property (strong, nonatomic) UIButton *numMinusButton;
@property (strong, nonatomic) UIButton *numAddButton;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *yunfeiTipLabel;
@property (strong, nonatomic) UILabel *yunfeiLabel;

// 积分选择
@property (strong, nonatomic) UIView *scoreBackView;
@property (strong, nonatomic) UIButton *scoreRulerButton;
@property (strong, nonatomic) UILabel *scoreChooseLabel;
@property (strong, nonatomic) UILabel *scoreTipLabel;
@property (strong, nonatomic) UIButton *scoreRightIcon;

// 规则
@property (strong, nonatomic) UIView *rulerBack;
@property (strong, nonatomic) UIView *rulerWhiteBack;

// 底部视图
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *realTipLabel;
@property (strong, nonatomic) UILabel *finalPriceLabel;
@property (strong, nonatomic) UIButton *submitButton;


@end

@implementation ShopOrderSureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    userScore = 0;
    shopScore = 0;
    shopPrice = 0.0;
    
    _titleLabel.text = @"确认订单";
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    _shopInfoDict = [[NSDictionary alloc] init];
    _addressInfoDict = [[NSDictionary alloc] init];
    _scoresArray = [[NSMutableArray alloc] init];
    
    [self makeScrollView];
    
    [self getShopOrderInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddressViewUI:) name:@"changeAddressViewUI" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_mainScrollView];
}

- (void)makeAddressView {
    if (!_addressView) {
        _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 90)];
        _addressView.backgroundColor = [UIColor whiteColor];
    }
    [_addressView removeAllSubviews];
    [_mainScrollView addSubview:_addressView];
    
    if ([[NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"fictitious"]] integerValue]) {
        [_addressView setHeight:0];
        return;
    }
    
    if (SWNOTEmptyDictionary(_shopInfoDict)) {
        _addressInfoDict = [NSDictionary dictionaryWithDictionary:_shopInfoDict[@"address"]];
        if (SWNOTEmptyDictionary(_addressInfoDict)) {
            [_addressView setHeight:90];
        } else {
            [_addressView setHeight:45];
        }
    }
    
    _addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 28, 28)];
    _addressIcon.image = [Image(@"store_address_icon") converToMainColor];
    _addressIcon.centerY = _addressView.height / 2.0;
    [_addressView addSubview:_addressIcon];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressIcon.right + 16, 13.5, 100, 21)];
    _userNameLabel.textColor = EdlineV5_Color.textFirstColor;
    _userNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [_addressView addSubview:_userNameLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.right + 12, 13.5, 100, 21)];
    _phoneLabel.textColor = EdlineV5_Color.textFirstColor;
    _phoneLabel.font = SYSTEMFONT(13);
    [_addressView addSubview:_phoneLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.left, _userNameLabel.bottom + 6, _addressView.width - _addressIcon.right - 16 - 42, 37)];
    _addressLabel.textColor = EdlineV5_Color.textThirdColor;
    _addressLabel.font = SYSTEMFONT(13);
    _addressLabel.numberOfLines = 0;
    [_addressView addSubview:_addressLabel];
    
    _addAddressTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressIcon.right + 16, 0, _addressView.width - _addressIcon.right - 16 - 42, 40)];
    _addAddressTipLabel.textColor = EdlineV5_Color.textFirstColor;
    _addAddressTipLabel.text = @"添加收货地址";
    _addAddressTipLabel.font = SYSTEMFONT(15);
    [_addressView addSubview:_addAddressTipLabel];
    _addAddressTipLabel.hidden = YES;
    _addAddressTipLabel.centerY = _addressIcon.centerY;
    
    _addressRightIcon = [[UIButton alloc] initWithFrame:CGRectMake(_addressView.width - 42, 0, 42, 42)];
    [_addressRightIcon setImage:Image(@"zhankai") forState:0];
    _addressRightIcon.centerY = _addressIcon.centerY;
//    [_addressRightIcon addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addressView addSubview:_addressRightIcon];
    
    _chooseAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _addressView.width, _addressView.height)];
    _chooseAddressBtn.backgroundColor = [UIColor clearColor];
    [_chooseAddressBtn addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addressView addSubview:_chooseAddressBtn];

    if (SWNOTEmptyDictionary(_shopInfoDict)) {
        _addressInfoDict = [NSDictionary dictionaryWithDictionary:_shopInfoDict[@"address"]];
        if (SWNOTEmptyDictionary(_addressInfoDict)) {
            _userNameLabel.text = [NSString stringWithFormat:@"%@",_addressInfoDict[@"consignee"]];
            [_userNameLabel setWidth:[_userNameLabel.text sizeWithFont:_userNameLabel.font].width];
            [_phoneLabel setLeft:_userNameLabel.right + 12];
            _phoneLabel.text = [[NSString stringWithFormat:@"%@",_addressInfoDict[@"phone"]] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [_phoneLabel setWidth:[_phoneLabel.text sizeWithFont:_phoneLabel.font].width + 4];
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@",_addressInfoDict[@"areatext"],_addressInfoDict[@"address"]];
            [_addressView setHeight:90];
            _addAddressTipLabel.hidden = YES;
        } else {
            [_addressView setHeight:45];
            _addAddressTipLabel.hidden = NO;
        }
    }
    [_chooseAddressBtn setHeight:_addressView.height];
}

- (void)makeShopInfoView {
    if (!_shopInfoBackView) {
        _shopInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _addressView.bottom + 10, MainScreenWidth, 192)];
        _shopInfoBackView.backgroundColor = [UIColor whiteColor];
    }
    [_shopInfoBackView removeAllSubviews];
    [_mainScrollView addSubview:_shopInfoBackView];
    
    if ([[NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"fictitious"]] integerValue]) {
        [_shopInfoBackView setTop:_addressView.bottom];
    }
    
    _shopFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 66, 66)];
    _shopFaceView.layer.masksToBounds = YES;
    _shopFaceView.layer.cornerRadius = 4;
    _shopFaceView.layer.borderColor = HEXCOLOR(0xDCDFE6).CGColor;
    _shopFaceView.layer.borderWidth = 1;
    [_shopInfoBackView addSubview:_shopFaceView];
    
    _shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopFaceView.right + 12, 16, _shopInfoBackView.width - (_shopFaceView.right + 12), 20)];
    _shopTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _shopTitleLabel.font = SYSTEMFONT(14);
    [_shopInfoBackView addSubview:_shopTitleLabel];
    
    _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopFaceView.right + 12, 60.5, _shopTitleLabel.width, 18.5)];
    _shopPriceLabel.textColor = EdlineV5_Color.textPriceColor;
    _shopPriceLabel.font = SYSTEMFONT(14);
    [_shopInfoBackView addSubview:_shopPriceLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopInfoBackView.width - 15 - 60, _shopPriceLabel.top, 60, _shopPriceLabel.height)];
    _dateLabel.font = SYSTEMFONT(11);
    _dateLabel.textColor = EdlineV5_Color.textThirdColor;
    _dateLabel.textAlignment = NSTextAlignmentRight;
//    [_shopInfoBackView addSubview:_dateLabel];
    
    _numTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _shopFaceView.bottom + 22, 50, 20)];
    _numTipLabel.text = @"数量";
    _numTipLabel.textColor = EdlineV5_Color.textFirstColor;
    _numTipLabel.font = SYSTEMFONT(14);
    [_shopInfoBackView addSubview:_numTipLabel];
    
    _numControlView = [[UIView alloc] initWithFrame:CGRectMake(_shopInfoBackView.width - 15 - 66 - 2, _numTipLabel.centerY - 11, 68, 22)];
    _numControlView.backgroundColor = [UIColor whiteColor];
    _numControlView.layer.masksToBounds = YES;
    _numControlView.layer.cornerRadius = 2;
    _numControlView.layer.borderColor = HEXCOLOR(0xDCDFE6).CGColor;
    _numControlView.layer.borderWidth = 1;
    [_shopInfoBackView addSubview:_numControlView];
    
    _numMinusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_numMinusButton setImage:Image(@"reduce_icon") forState:0];
    [_numMinusButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_numControlView addSubview:_numMinusButton];
    
    UIView *numLine1 = [[UIView alloc] initWithFrame:CGRectMake(_numMinusButton.right, 0, 1, 22)];
    numLine1.backgroundColor = HEXCOLOR(0xDCDFE6);
    [_numControlView addSubview:numLine1];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(numLine1.right, 0, 22, 22)];
    _numLabel.text = @"1";
    _numLabel.font = SYSTEMFONT(13);
    _numLabel.textColor = EdlineV5_Color.textSecendColor;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [_numControlView addSubview:_numLabel];
    
    UIView *numLine2 = [[UIView alloc] initWithFrame:CGRectMake(_numLabel.right, 0, 1, 22)];
    numLine2.backgroundColor = HEXCOLOR(0xDCDFE6);
    [_numControlView addSubview:numLine2];
    
    _numAddButton = [[UIButton alloc] initWithFrame:CGRectMake(numLine2.right, 0, 22, 22)];
    [_numAddButton setImage:Image(@"add_icon") forState:0];
    [_numAddButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_numControlView addSubview:_numAddButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, _numTipLabel.bottom + 15.5, _shopInfoBackView.width - 15, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_shopInfoBackView addSubview:_lineView];
    
    _yunfeiTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _lineView.bottom, 50, _shopInfoBackView.height - _lineView.bottom)];
    _yunfeiTipLabel.text = @"运费";
    _yunfeiTipLabel.textColor = EdlineV5_Color.textFirstColor;
    _yunfeiTipLabel.font = SYSTEMFONT(14);
    [_shopInfoBackView addSubview:_yunfeiTipLabel];
    
    _yunfeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopInfoBackView.width - 15 - 70, _yunfeiTipLabel.top, 70, _yunfeiTipLabel.height)];
    _yunfeiLabel.font = SYSTEMFONT(13);
    _yunfeiLabel.textAlignment = NSTextAlignmentRight;
    _yunfeiLabel.textColor = EdlineV5_Color.textFirstColor;
    [_shopInfoBackView addSubview:_yunfeiLabel];
    
    if (SWNOTEmptyDictionary(_shopInfoDict)) {
        NSDictionary *addressInfo = [NSDictionary dictionaryWithDictionary:_shopInfoDict[@"product"]];
        if (SWNOTEmptyDictionary(addressInfo)) {
            [_shopFaceView sd_setImageWithURL:EdulineUrlString(addressInfo[@"cover_url"]) placeholderImage:DefaultImage];
            _shopTitleLabel.text = [NSString stringWithFormat:@"%@",addressInfo[@"title"]];
            _yunfeiLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,addressInfo[@"carriage"]];
            
            
            NSString *showCredit = [NSString stringWithFormat:@"%@",addressInfo[@"credit_price"]];
            NSString *singlePrice = [NSString stringWithFormat:@"%@",addressInfo[@"cash_price"]];
            NSString *iosMoney = [NSString stringWithFormat:@"%@",IOSMoneyTitle];
            
            if ([showCredit isEqualToString:@"0"] && ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"])) {
                _shopPriceLabel.text = @"免费";
                _shopPriceLabel.textColor = EdlineV5_Color.priceFreeColor;
            } else if ([showCredit isEqualToString:@"0"]) {
                NSString *showPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,addressInfo[@"cash_price"]];
                
                NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
                [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(0, [iosMoney length])];
                _shopPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
                
            } else if ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"]) {
                NSString *showPrice = [NSString stringWithFormat:@"%@积分",addressInfo[@"credit_price"]];
                
                NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
                [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(showPrice.length - 2, 2)];
                _shopPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
            } else {
                NSString *showPrice = [NSString stringWithFormat:@"%@积分+%@%@",addressInfo[@"credit_price"],IOSMoneyTitle,addressInfo[@"cash_price"]];
                
                NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
                [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(showCredit.length, [[NSString stringWithFormat:@"积分+%@",IOSMoneyTitle] length])];
                _shopPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
            }
        }
    }
}

- (void)makeScoreView {
    if (!_scoreBackView) {
        _scoreBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _shopInfoBackView.bottom + 10, MainScreenWidth, 50)];
        _scoreBackView.backgroundColor = [UIColor whiteColor];
    }
    [_mainScrollView addSubview:_scoreBackView];
    [_scoreBackView removeAllSubviews];
    
    _scoreRulerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15 + 30 + 5 + 12 + 15, 50)];
    [_scoreRulerButton setTitle:@"积分" forState:0];
    [_scoreRulerButton setImage:Image(@"explain_icon") forState:0];
    _scoreRulerButton.titleLabel.font = SYSTEMFONT(14);
    [_scoreRulerButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    
    CGFloat imageWith = _scoreRulerButton.imageView.frame.size.width;
    CGFloat labelWidth = _scoreRulerButton.titleLabel.intrinsicContentSize.width;
    _scoreRulerButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+5/2.0, 0, -labelWidth-5/2.0);
    _scoreRulerButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith-5/2.0, 0, imageWith+5/2.0);
    
    [_scoreRulerButton addTarget:self action:@selector(rulerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scoreBackView addSubview:_scoreRulerButton];
    
    _scoreChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scoreBackView.width - 50 - 200, 0, 200, 50)];
    _scoreChooseLabel.textAlignment = NSTextAlignmentRight;
    _scoreChooseLabel.font = SYSTEMFONT(14);
    _scoreChooseLabel.textColor = EdlineV5_Color.textFirstColor;
//    _scoreChooseLabel.text = @"共100，本次最高可用100";
    [_scoreBackView addSubview:_scoreChooseLabel];
    
//    _scoreTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scoreBackView.width - 37 - 200, 40, 200, 15)];
//    _scoreTipLabel.text = @"共100，本次最高可用100";
//    _scoreTipLabel.font = SYSTEMFONT(11);
//    _scoreTipLabel.textColor = EdlineV5_Color.textThirdColor;
//    _scoreTipLabel.textAlignment = NSTextAlignmentRight;
//    [_scoreBackView addSubview:_scoreTipLabel];
    
    _scoreRightIcon = [[UIButton alloc] initWithFrame:CGRectMake(_scoreBackView.width - 50, 0, 50, 50)];
    [_scoreRightIcon setImage:Image(@"checkbox_def") forState:0];
    [_scoreRightIcon setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_scoreRightIcon addTarget:self action:@selector(scoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scoreBackView addSubview:_scoreRightIcon];
    
    if (SWNOTEmptyDictionary(_shopInfoDict)) {
        [self dealPriceUI];
    }
}

- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _realTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 67, 49)];
    _realTipLabel.text = @"实付金额：";
    _realTipLabel.font = SYSTEMFONT(13);
    _realTipLabel.textColor = EdlineV5_Color.textFirstColor;
    [_bottomView addSubview:_realTipLabel];
    
    _finalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_realTipLabel.right - 2, 0, 200, 49)];
    _finalPriceLabel.textColor = EdlineV5_Color.faildColor;
    _finalPriceLabel.font = SYSTEMFONT(15);
    _finalPriceLabel.text = [NSString stringWithFormat:@"%@9999",IOSMoneyTitle];
    [_bottomView addSubview:_finalPriceLabel];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 110, 0, 110, 36)];
    [_submitButton setTitle:@"去支付" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerY = _realTipLabel.centerY;
    [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
    
    if (SWNOTEmptyDictionary(_shopInfoDict)) {
        [self dealPriceUI];
    }
    
    
}

- (NSString *)dealShopPrice:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.00"];
    formatter.maximumFractionDigits = 2;
    formatter.roundingMode = NSNumberFormatterRoundDown;
    NSLog(@"%@", [formatter stringFromNumber:number]);
    return [formatter stringFromNumber:number];
}


// MARK: - 构建规则弹框视图
- (void)makeRulerView {
    _rulerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _rulerBack.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3000].CGColor;
    [self.view addSubview:_rulerBack];
    _rulerBack.hidden = YES;
    
    _rulerWhiteBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 204)];
    _rulerWhiteBack.backgroundColor = [UIColor whiteColor];
    _rulerWhiteBack.layer.masksToBounds = YES;
    _rulerWhiteBack.layer.cornerRadius = 7;
    _rulerWhiteBack.center = CGPointMake(MainScreenWidth / 2.0, MainScreenHeight / 2.0);
    [_rulerBack addSubview:_rulerWhiteBack];
    
    UILabel *rulerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _rulerWhiteBack.width, 18)];
    rulerTitle.text = @"积分使用规则";
    rulerTitle.textColor = EdlineV5_Color.textFirstColor;
    rulerTitle.textAlignment = NSTextAlignmentCenter;
    rulerTitle.font = SYSTEMFONT(15);
    [_rulerWhiteBack addSubview:rulerTitle];
    
    UILabel *lll = [[UILabel alloc] initWithFrame:CGRectMake(20, rulerTitle.bottom + 14, _rulerWhiteBack.width - 40, 80)];
    
    lll.text = @"1，订单可使用积分； \n2，订单抵扣积分不能超过商品最高积分抵扣数量。";
//    if (SWNOTEmptyDictionary(_shopInfoDict)) {
//        if ([[NSString stringWithFormat:@"%@",IOSMoneyTitle] isEqualToString:@"￥"]) {
//            lll.text = [NSString stringWithFormat:@"1，订单可使用积分+现金支付； \n2，订单抵扣积分不能超过商品最高积分抵扣数量； \n3，%@积分抵扣1元。",_shopInfoDict[@"credit"][@"ratio"]];
//        } else {
//            lll.text = [NSString stringWithFormat:@"1，订单可使用积分+现金支付； \n2，订单抵扣积分不能超过商品最高积分抵扣数量； \n3，%@积分抵扣1%@。",_shopInfoDict[@"credit"][@"ratio"],IOSMoneyTitle];
//        }
//    }
    
//    lll.text = @"1，订单可使用积分+现金支付； \n2，订单抵扣积分不能超过商品最高积分抵扣数量； \n3，1积分抵扣1元。";
//    if (SWNOTEmptyDictionary(_shopInfoDict)) {
//        if ([[NSString stringWithFormat:@"%@",IOSMoneyTitle] isEqualToString:@"￥"]) {
//            lll.text = [NSString stringWithFormat:@"1，订单可使用积分+现金支付； \n2，订单抵扣积分不能超过商品最高积分抵扣数量； \n3，%@积分抵扣1元。",_shopInfoDict[@"credit"][@"ratio"]];
//        } else {
//            lll.text = [NSString stringWithFormat:@"1，订单可使用积分+现金支付； \n2，订单抵扣积分不能超过商品最高积分抵扣数量； \n3，%@积分抵扣1%@。",_shopInfoDict[@"credit"][@"ratio"],IOSMoneyTitle];
//        }
//    }
    lll.textColor = EdlineV5_Color.textFirstColor;
    lll.numberOfLines = 0;
    lll.font = SYSTEMFONT(12);
    [_rulerWhiteBack addSubview:lll];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, lll.bottom + 24, 130, 32)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 16;
    btn.centerX = _rulerWhiteBack.width / 2.0;
    [btn setTitle:@"我知道了" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = SYSTEMFONT(14);
    btn.backgroundColor = EdlineV5_Color.themeColor;
    [btn addTarget:self action:@selector(hiddenRulerView) forControlEvents:UIControlEventTouchUpInside];
    [_rulerWhiteBack addSubview:btn];
}

// MARK: - 数量增减按钮点击事件
- (void)numButtonClick:(UIButton *)sender {
    if (sender == _numMinusButton) {
        if ([_numLabel.text integerValue] <= 1) {
            return;
        } else {
            _numLabel.text = [NSString stringWithFormat:@"%d",[_numLabel.text intValue] - 1];
        }
    } else {
        _numLabel.text = [NSString stringWithFormat:@"%d",[_numLabel.text intValue] + 1];
    }
    [self dealPriceUI];
}

// MARK: - 处理页面价格UI
- (void)dealPriceUI {
    _scoreChooseLabel.text = [NSString stringWithFormat:@"共%@，本次可用%@",_shopInfoDict[@"credit"][@"user_credit"],userScore >= (shopScore * [_numLabel.text integerValue]) ? @(shopScore * [_numLabel.text integerValue]) : @(userScore)];
    if (_scoreRightIcon.selected) {
//        NSString *ratio = [NSString stringWithFormat:@"%@",_shopInfoDict[@"credit"][@"ratio"]];
        NSString *carriage = [NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"carriage"]];
        _finalPriceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,userScore >= (shopScore * [_numLabel.text integerValue]) ? [self dealShopPrice:@(shopPrice * [_numLabel.text integerValue] + [carriage floatValue])] : [self dealShopPrice:@(shopPrice * [_numLabel.text integerValue] + ((shopScore * [_numLabel.text integerValue]) - userScore) + [carriage floatValue])]];
    } else {
//        NSString *ratio = [NSString stringWithFormat:@"%@",_shopInfoDict[@"credit"][@"ratio"]];
        NSString *carriage = [NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"carriage"]];
        _finalPriceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[self dealShopPrice:@(shopPrice * [_numLabel.text integerValue] + ((shopScore * [_numLabel.text integerValue]) - 0) + [carriage floatValue])]];
    }
}

// MARK: - 地址选择按钮点击事件
- (void)addressButtonClick:(UIButton *)sender {
    AddressListViewController *vc = [[AddressListViewController alloc] init];
    vc.addressSelect = ^(NSDictionary * _Nonnull addressInfo) {
        if (SWNOTEmptyDictionary(addressInfo)) {
            
            NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_shopInfoDict];
            [pass setObject:addressInfo forKey:@"address"];
            _shopInfoDict = [NSDictionary dictionaryWithDictionary:pass];
            _addressInfoDict = [[NSDictionary alloc] init];
            
            [self makeAddressView];
            [_shopInfoBackView setTop:_addressView.bottom + 10];
            [_scoreBackView setTop:_shopInfoBackView.bottom + 10];
            
//            _addressInfoDict = [NSDictionary dictionaryWithDictionary:addressInfo];
//            _userNameLabel.text = [NSString stringWithFormat:@"%@",addressInfo[@"consignee"]];
//
//            [_userNameLabel setWidth:[_userNameLabel.text sizeWithFont:_userNameLabel.font].width];
//            [_phoneLabel setLeft:_userNameLabel.right + 12];
//            _phoneLabel.text = [[NSString stringWithFormat:@"%@",addressInfo[@"phone"]] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//            [_phoneLabel setWidth:[_phoneLabel.text sizeWithFont:_phoneLabel.font].width + 4];
//
//            _addressLabel.text = [NSString stringWithFormat:@"%@ %@",addressInfo[@"areatext"],addressInfo[@"address"]];
//            [_addressView setHeight:90];
//            _addAddressTipLabel.hidden = YES;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 积分规则按钮点击事件
- (void)rulerButtonClick:(UIButton *)sender {
    if (_rulerBack) {
        _rulerBack.hidden = NO;
    }
}

// MARK: - 我知道了
- (void)hiddenRulerView {
    _rulerBack.hidden = YES;
}

// MARK: - 积分选择展开按钮点击事件
- (void)scoreButtonClick:(UIButton *)sender {
    _scoreRightIcon.selected = !_scoreRightIcon.selected;
    [self dealPriceUI];
    /**
    ScoreListViewController *vc = [[ScoreListViewController alloc] init];
    vc.hiddenRightLabel = YES;
    vc.currentSelectModel = _currentScoreModel;
    vc.dataSource = [NSMutableArray arrayWithArray:_scoresArray];
    vc.delegate = self;
    vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    */
}

// MARK: - 选择积分抵扣后代理
- (void)scoreChooseModel:(ScoreListModel *)model {
    if (model.is_selected) {
        _currentScoreModel = model;
        _scoreChooseLabel.text = [NSString stringWithFormat:@"共%@，已选%@",_shopInfoDict[@"credit"][@"user_credit"],model.credit];
    } else {
        _currentScoreModel = nil;
        _scoreChooseLabel.text = [NSString stringWithFormat:@"共%@，已选0",_shopInfoDict[@"credit"][@"user_credit"]];
    }
}

- (void)getShopOrderInfo {
    if (SWNOTEmptyStr(_shopID)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path shopOrderInfoNet] WithAuthorization:nil paramDic:@{@"product":_shopID} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _shopInfoDict = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    _scoresArray = [NSMutableArray arrayWithArray:[ScoreListModel mj_objectArrayWithKeyValuesArray:_shopInfoDict[@"credit"][@"arr"]]];
                    _currentScoreModel = nil;
                    if (SWNOTEmptyArr(_scoresArray)) {
                        _currentScoreModel = _scoresArray[0];
                        _currentScoreModel.is_default = YES;
                        _currentScoreModel.is_selected = YES;
                    }
                    
                    userScore = [[NSString stringWithFormat:@"%@",_shopInfoDict[@"credit"][@"user_credit"]] integerValue];
                    shopScore = [[NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"credit_price"]] integerValue];
                    shopPrice = [[NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"cash_price"]] floatValue];
                    
                    [self makeRulerView];
                    
                    [self makeAddressView];
                    [self makeShopInfoView];
                    [self makeScoreView];
                    [self makeDownView];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 请求积分列表
- (void)getScoreListNet {
    NSString *courseOrderInfoUrl = [Net_Path courseOrderScoreListNet];
    NSMutableDictionary *pass = [[NSMutableDictionary alloc] init];
    [pass setObject:@"293" forKey:@"course_id"];
    [Net_API requestGETSuperAPIWithURLStr:courseOrderInfoUrl WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _scoresArray = [NSMutableArray arrayWithArray:[ScoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                _currentScoreModel = nil;
                if (SWNOTEmptyArr(_scoresArray)) {
                    _currentScoreModel = _scoresArray[0];
                    _currentScoreModel.is_default = YES;
                    _currentScoreModel.is_selected = YES;
                    _scoreChooseLabel.text = [NSString stringWithFormat:@"共100，已选%@",_currentScoreModel.num];
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

// MARK: - 去支付按钮点击事件
- (void)submitButtonClick:(UIButton *)sender {
    NSMutableDictionary *pass = [[NSMutableDictionary alloc] init];
    [pass setObject:_shopID forKey:@"id"];
    [pass setObject:@([_numLabel.text integerValue]) forKey:@"num"];
    if (_scoreRightIcon.selected) {
        [pass setObject:userScore >= (shopScore * [_numLabel.text integerValue]) ? @(shopScore * [_numLabel.text integerValue]) : @(userScore) forKey:@"credit"];
    } else {
        [pass setObject:@"0" forKey:@"credit"];
    }
    
    if ([[NSString stringWithFormat:@"%@",_shopInfoDict[@"product"][@"fictitious"]] integerValue]) {
        //  虚拟商品
    } else {
        // 实体商品 必须要提供地址
        if (SWNOTEmptyDictionary(_addressInfoDict) && _addressInfoDict[@"id"]) {
            [pass setObject:[NSString stringWithFormat:@"%@",_addressInfoDict[@"id"]] forKey:@"addr_id"];
        } else {
            [self showHudInView:self.view showHint:@"请填写收货地址"];
            return;
        }
    }
    
    [Net_API requestPOSTWithURLStr:[Net_Path shopOrderCreate] WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
        
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                if ([[responseObject objectForKey:@"data"] objectForKey:@"need_pay"]) {
                    NSString *need_pay = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"need_pay"]];
                    if ([need_pay isEqualToString:@"0"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        return;
                    }
                }
                OrderSureViewController *vc = [[OrderSureViewController alloc] init];
                vc.orderSureInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                vc.orderTypeString = @"shop";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
        
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"网络飞走了"];
    }];
}

- (void)changeAddressViewUI:(NSNotification *)notice {
    
    if (SWNOTEmptyDictionary(_shopInfoDict)) {
        if (SWNOTEmptyDictionary(_addressInfoDict)) {
            NSString *currentAddID = [NSString stringWithFormat:@"%@",_addressInfoDict[@"id"]];
            NSDictionary *noticeInfo = [NSDictionary dictionaryWithDictionary:notice.userInfo];
            if (SWNOTEmptyDictionary(noticeInfo)) {
                NSString *noticeType = [NSString stringWithFormat:@"%@",noticeInfo[@"type"]];
                NSDictionary *addInfo = [NSDictionary dictionaryWithDictionary:noticeInfo[@"addressInfo"]];
                NSString *addID = [NSString stringWithFormat:@"%@",addInfo[@"id"]];
                if ([addID isEqualToString:currentAddID]) {
                    // 确实是删除或者修改的是当前选中的地址信息
                    if ([noticeType isEqualToString:@"delete"]) {
                        // 删除了当前地址 需要更换当前商品信息里面的地址信息 并且处理地址UI
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_shopInfoDict];
                        [pass setObject:@{} forKey:@"address"];
                        _shopInfoDict = [NSDictionary dictionaryWithDictionary:pass];
                        _addressInfoDict = [[NSDictionary alloc] init];
                    } else {
                        // 修改了当前地址 需要更换当前商品信息里面的地址信息 并且处理地址UI
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_shopInfoDict];
                        [pass setObject:addInfo forKey:@"address"];
                        _shopInfoDict = [NSDictionary dictionaryWithDictionary:pass];
                        _addressInfoDict = [[NSDictionary alloc] init];
                    }
                    [self makeAddressView];
                    [_shopInfoBackView setTop:_addressView.bottom + 10];
                    [_scoreBackView setTop:_shopInfoBackView.bottom + 10];
                }
            }
        }
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
