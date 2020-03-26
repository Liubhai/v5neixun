//
//  OrderViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _timeLabel.text = @"订单详情";
    [self makeScrollView];
    [self makeSubView];
    [self makeDownView];
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT)];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_mainScrollView];
}

- (void)makeSubView {
    _topContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 102)];
    _topContentView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_topContentView];
    
    _courseFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 130, 72)];
    _courseFaceImageView.image = DefaultImage;
    [_topContentView addSubview:_courseFaceImageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, 15, MainScreenWidth - (_courseFaceImageView.right + 8) - 15, 40)];
    _textLabel.textColor = EdlineV5_Color.textFirstColor;
    _textLabel.font = SYSTEMFONT(14);
    _textLabel.text = @"课程显示课程标题，课时显示课时名称";
    [_topContentView addSubview:_textLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, _courseFaceImageView.bottom - 15, 150, 15)];
    _timeLabel.font = SYSTEMFONT(11);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = @"有效期至2022.12.12";
    [_topContentView addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, _timeLabel.top, 150, 15)];
    _priceLabel.font = SYSTEMFONT(12);
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.text = @"VIP:¥200.00";
    [_topContentView addSubview:_priceLabel];
    
    _courseHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.top - 17, _timeLabel.width, 15)];
    _courseHourLabel.font = SYSTEMFONT(11);
    _courseHourLabel.textAlignment = NSTextAlignmentRight;
    _courseHourLabel.textColor = EdlineV5_Color.textThirdColor;
    _courseHourLabel.text = @"12课时";
    [_topContentView addSubview:_courseHourLabel];
    
    _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _topContentView.bottom + 10, MainScreenWidth, 168)];
    _orderTypeView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_orderTypeView];
    
    [self makeOrderType1View1];
    [self makeOrderType1View2];
    [self makeOrderType1View3];
    [_orderTypeView setHeight:_orderTypeView3.bottom];
    
    _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView.bottom + 10, MainScreenWidth, 110)];
    _otherView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_otherView];
    NSArray *titleArray = @[@"卡券",@"使用实体卡"];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *youhui = [[UILabel alloc] initWithFrame:CGRectMake(15, 55 * i, 100, 55)];
        youhui.text = titleArray[i];
        youhui.textColor = EdlineV5_Color.textSecendColor;
        youhui.font = SYSTEMFONT(15);
        [_otherView addSubview:youhui];
        
        UILabel *themelabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 32 - 200, youhui.top, 200, youhui.height)];
        themelabel.font = SYSTEMFONT(14);
        themelabel.textAlignment = NSTextAlignmentRight;
        [_otherView addSubview:themelabel];
        if (i==0) {
            _kaquanLabel = themelabel;
        } else if (i == 1) {
            _shitikaLabel = themelabel;
        }
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 7, 0, 7, 13.5)];
        icon.backgroundColor = EdlineV5_Color.faildColor;
        icon.centerY = themelabel.centerY;;
        [_otherView addSubview:icon];
        
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, youhui.top, MainScreenWidth, youhui.height)];
        clearBtn.backgroundColor = [UIColor clearColor];
        clearBtn.tag = 10 + i;
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherView addSubview:clearBtn];
    }
    
    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _otherView.bottom +10, MainScreenWidth, 60)];
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
    _orderTitle3.text = @"余额(11111.00)";
    [_orderTypeView3 addSubview:_orderTitle3];
    
    _orderRightBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn3 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn3 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
    [_orderRightBtn3 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView3 addSubview:_orderRightBtn3];
}

- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _youhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 49)];
    _youhuiLabel.text = @"优惠：¥10.00";
    _youhuiLabel.font = SYSTEMFONT(13);
    _youhuiLabel.textColor = EdlineV5_Color.textThirdColor;
    [_bottomView addSubview:_youhuiLabel];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 110, 0, 110, 36)];
    [_submitButton setTitle:@"提交订单" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerY = _youhuiLabel.centerY;
    [_bottomView addSubview:_submitButton];
    
    _finalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_submitButton.left - 200 - 15, 0, 200, 49)];
    _finalPriceLabel.textColor = EdlineV5_Color.faildColor;
    _finalPriceLabel.font = SYSTEMFONT(15);
    _finalPriceLabel.text = @"合计: ¥190.00";
    _finalPriceLabel.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:_finalPriceLabel];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
}

- (void)clearBtnClick:(UIButton *)sender {
    
}

- (void)seleteAgreementButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)seleteButtonClick:(UIButton *)sender {
    if (sender == _orderRightBtn1) {
        _orderRightBtn1.selected = YES;
        _orderRightBtn2.selected = NO;
        _orderRightBtn3.selected = NO;
    } else if (sender == _orderRightBtn2) {
        _orderRightBtn2.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn3.selected = NO;
    } else if (sender == _orderRightBtn3) {
        _orderRightBtn3.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
    }
}

@end
