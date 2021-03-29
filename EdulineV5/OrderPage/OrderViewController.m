//
//  OrderViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderViewController.h"
#import "ShitikaViewController.h"
#import "OrderSureViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "LingquanViewController.h"
#import "V5_UserModel.h"

@interface OrderViewController ()<LingquanViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *couponsArray;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _couponsArray = [NSMutableArray new];
    _titleLabel.text = @"确认订单";
    [self makeScrollView];
    [self makeSubView];
    [self makeDownView];
    [self getCourseOrderInfo];
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
    _courseFaceImageView.layer.masksToBounds = YES;
    _courseFaceImageView.layer.cornerRadius = 2;
    if (![_orderTypeString isEqualToString:@"course"]) {
        _courseFaceImageView.frame = CGRectMake(15, 15, 32, 16);
    }
    [_topContentView addSubview:_courseFaceImageView];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFaceImageView.left, _courseFaceImageView.top, 33, 20)];
    _courseTypeImage.image = Image(@"class_icon");
    _courseTypeImage.layer.masksToBounds = YES;
    _courseTypeImage.layer.cornerRadius = 2;
    [_topContentView addSubview:_courseTypeImage];
    _courseTypeImage.hidden = YES;
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, 15, MainScreenWidth - (_courseFaceImageView.right + 8) - 15, 40)];
    _textLabel.textColor = EdlineV5_Color.textFirstColor;
    _textLabel.font = SYSTEMFONT(14);
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_topContentView addSubview:_textLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, _courseFaceImageView.bottom - 15, 150, 15)];
    if (![_orderTypeString isEqualToString:@"course"]) {
        _timeLabel.frame = CGRectMake(MainScreenWidth - 15 - 150, 15 + 72 - 15, 150, 15);
    }
    _timeLabel.font = SYSTEMFONT(11);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_topContentView addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, _timeLabel.top, 150, 15)];
    _priceLabel.font = SYSTEMFONT(12);
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [_topContentView addSubview:_priceLabel];
    
    _courseHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.top - 17, _timeLabel.width, 15)];
    _courseHourLabel.font = SYSTEMFONT(11);
    _courseHourLabel.textAlignment = NSTextAlignmentRight;
    _courseHourLabel.textColor = EdlineV5_Color.textThirdColor;
    [_topContentView addSubview:_courseHourLabel];
    _courseHourLabel.hidden = ![_orderTypeString isEqualToString:@"course"];
    
//    _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _topContentView.bottom + 10, MainScreenWidth, 168)];
//    _orderTypeView.backgroundColor = [UIColor whiteColor];
//    [_mainScrollView addSubview:_orderTypeView];
//
//    [self makeOrderType1View1];
//    [self makeOrderType1View2];
//    [self makeOrderType1View3];
//    [_orderTypeView setHeight:_orderTypeView3.bottom];
    
    if ([_orderTypeString isEqualToString:@"course"]) {
        _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, _topContentView.bottom + 10, MainScreenWidth, 110)];
        _otherView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:_otherView];
        NSArray *titleArray = @[@"卡券"];
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
                _kaquanLabel.text = @"未使用卡券";
                _kaquanLabel.textColor = EdlineV5_Color.youhuijuanColor;
            } else if (i == 1) {
                _shitikaLabel = themelabel;
            }
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 7, 0, 7, 13.5)];
            icon.image = Image(@"list_more");
            icon.centerY = themelabel.centerY;
            [_otherView addSubview:icon];
            
            UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, youhui.top, MainScreenWidth, youhui.height)];
            clearBtn.backgroundColor = [UIColor clearColor];
            clearBtn.tag = 10 + i;
            [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_otherView addSubview:clearBtn];
            if (i == titleArray.count - 1) {
                [_otherView setHeight:clearBtn.bottom];
            }
        }
    }
    
//    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _otherView.bottom +10, MainScreenWidth, 60)];
//    _agreeBackView.backgroundColor = [UIColor whiteColor];
//    [_mainScrollView addSubview:_agreeBackView];
//
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
//    NSString *atr = [NSString stringWithFormat:@"《%@购买协议》",appName];
//    NSString *fullString = [NSString stringWithFormat:@"   我已阅读并同意%@",atr];
//    NSRange atrRange = [fullString rangeOfString:atr];
//
//    _agreementTyLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 20)];
//    _agreementTyLabel.centerY = 60 / 2.0;
//    _agreementTyLabel.font = SYSTEMFONT(13);
//    _agreementTyLabel.textAlignment = kCTTextAlignmentLeft;
//    _agreementTyLabel.textColor = EdlineV5_Color.textSecendColor;
//    _agreementTyLabel.delegate = self;
//    _agreementTyLabel.numberOfLines = 0;
//
//    TYLinkTextStorage *textStorage = [[TYLinkTextStorage alloc]init];
//    textStorage.textColor = EdlineV5_Color.themeColor;
//    textStorage.font = SYSTEMFONT(13);
//    textStorage.linkData = @{@"type":@"service"};
//    textStorage.underLineStyle = kCTUnderlineStyleNone;
//    textStorage.range = atrRange;
//    textStorage.text = atr;
//
//    // 属性文本生成器
//    TYTextContainer *attStringCreater = [[TYTextContainer alloc]init];
//    attStringCreater.text = fullString;
//    _agreementTyLabel.textContainer = attStringCreater;
//    _agreementTyLabel.textContainer.linesSpacing = 4;
//    attStringCreater.font = SYSTEMFONT(13);
//    attStringCreater.textAlignment = kCTTextAlignmentLeft;
//    attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30, 1))];
//    [_agreementTyLabel setHeight:_agreementTyLabel.textContainer.textHeight];
//    _agreementTyLabel.centerY = 60 / 2.0;
//    [attStringCreater addTextStorageArray:@[textStorage]];
//    [_agreeBackView addSubview:_agreementTyLabel];
//
//    _seleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
//    [_seleteBtn setImage:Image(@"checkbox_nor") forState:0];
//    [_seleteBtn setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
//    [_seleteBtn addTarget:self action:@selector(seleteAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_agreementTyLabel addView:_seleteBtn range:NSMakeRange(0, 2) alignment:TYDrawAlignmentCenter];
    
    
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
    [_orderRightBtn3 setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_orderRightBtn3 addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_orderTypeView3 addSubview:_orderRightBtn3];
}

- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _youhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 49)];
    _youhuiLabel.text = [NSString stringWithFormat:@"优惠：%@0.00",IOSMoneyTitle];
    _youhuiLabel.font = SYSTEMFONT(13);
    _youhuiLabel.textColor = EdlineV5_Color.textThirdColor;
    [_bottomView addSubview:_youhuiLabel];
    _youhuiLabel.hidden = ![_orderTypeString isEqualToString:@"course"];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 110, 0, 110, 36)];
    [_submitButton setTitle:@"提交订单" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerY = _youhuiLabel.centerY;
    [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
    
    _finalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_submitButton.left - 200 - 15, 0, 200, 49)];
    _finalPriceLabel.textColor = EdlineV5_Color.faildColor;
    _finalPriceLabel.font = SYSTEMFONT(15);
    _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@0.00",IOSMoneyTitle];
    _finalPriceLabel.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:_finalPriceLabel];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
}

- (void)clearBtnClick:(UIButton *)sender {
    if (sender.tag == 11) {
        ShitikaViewController *vc = [[ShitikaViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LingquanViewController *vc = [[LingquanViewController alloc] init];
        vc.courseId = _orderId;
        vc.couponModel = _couponModel;
        vc.getOrUse = NO;
        vc.delegate = self;
        vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
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

- (void)submitButtonClick:(UIButton *)sender {
    
    if (!SWNOTEmptyDictionary(_orderInfo)) {
        return;
    }
    
    if (_couponModel) {
        if ([_couponModel.coupon_type isEqualToString:@"3"]) {
            // 直接兑换
            [self couponDirectExchange:_couponModel.couponId];
            return;
        }
    }
    
    NSString *courseOrderInfoUrl = [Net_Path courseOrderInfo];
    if ([_orderTypeString isEqualToString:@"course"]) {
        courseOrderInfoUrl = [Net_Path courseOrderInfo];
    } else if ([_orderTypeString isEqualToString:@"courseHourse"] || [_orderTypeString isEqualToString:@"liveHourse"]) {
        courseOrderInfoUrl = [Net_Path courseHourseOrderInfo];
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_orderId)) {
        if ([_orderTypeString isEqualToString:@"course"]) {
            [param setObject:_orderId forKey:@"course_id"];
        } else if ([_orderTypeString isEqualToString:@"courseHourse"] || [_orderTypeString isEqualToString:@"liveHourse"]) {
            [param setObject:_orderId forKey:@"section_id"];
        }
    }
    if (_couponModel) {
        [param setObject:_couponModel.couponId forKey:@"coupon_id"];
    }
    [param setObject:@"ios" forKey:@"from"];
    [Net_API requestPOSTWithURLStr:courseOrderInfoUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                OrderSureViewController *vc = [[OrderSureViewController alloc] init];
                vc.orderSureInfo = responseObject;
                vc.orderTypeString = @"course";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"订单生成失败"];
    }];
}

- (void)getCourseOrderInfo {
    if (!SWNOTEmptyStr(_orderId)) {
        return;
    }
    NSString *courseOrderInfoUrl = [Net_Path courseOrderInfo];
    if ([_orderTypeString isEqualToString:@"course"]) {
        courseOrderInfoUrl = [Net_Path courseOrderInfo];
    } else if ([_orderTypeString isEqualToString:@"courseHourse"] || [_orderTypeString isEqualToString:@"liveHourse"]) {
        courseOrderInfoUrl = [Net_Path courseHourseOrderInfo];
    } else if ([_orderTypeString isEqualToString:@"exam"]) {
        courseOrderInfoUrl = [Net_Path examOrderNet];
    } else {
        
    }
    
    NSMutableDictionary *pass = [[NSMutableDictionary alloc] init];
    if ([_orderTypeString isEqualToString:@"course"]) {
        [pass setObject:_orderId forKey:@"course_id"];
    } else if ([_orderTypeString isEqualToString:@"courseHourse"] || [_orderTypeString isEqualToString:@"liveHourse"]) {
        [pass setObject:_orderId forKey:@"section_id"];
    } else if ([_orderTypeString isEqualToString:@"exam"]) {
        [pass setObject:_orderId forKey:@"section_id"];
    } else {
        [pass setObject:_orderId forKey:@"section_id"];
    }
    
    [Net_API requestGETSuperAPIWithURLStr:courseOrderInfoUrl WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _orderInfo = [NSDictionary dictionaryWithDictionary:responseObject];
            } else {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }
        [self setCourseUIData];
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setCourseUIData {
    if (SWNOTEmptyDictionary(_orderInfo)) {
        _textLabel.text = [NSString stringWithFormat:@"%@",[[_orderInfo objectForKey:@"data"] objectForKey:@"title"]];
        [_textLabel sizeToFit];
        if (_textLabel.height > 40) {
            [_textLabel setHeight:40];
        } else {
            [_textLabel setHeight:_textLabel.height];
        }
        
        if ([_orderTypeString isEqualToString:@"course"]) {
            _courseTypeImage.hidden = NO;
            [_courseFaceImageView sd_setImageWithURL:EdulineUrlString([[_orderInfo objectForKey:@"data"] objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
            // 1 点播 2 直播 3 面授 4 专辑
            NSString *courseType = [NSString stringWithFormat:@"%@",[[_orderInfo objectForKey:@"data"] objectForKey:@"course_type"]];
            if ([courseType isEqualToString:@"1"]) {
                _courseTypeImage.image = Image(@"dianbo");
            } else if ([courseType isEqualToString:@"2"]) {
                _courseTypeImage.image = Image(@"live");
            } else if ([courseType isEqualToString:@"3"]) {
                _courseTypeImage.image = Image(@"mianshou");
            } else if ([courseType isEqualToString:@"4"]) {
                _courseTypeImage.image = Image(@"class_icon");
            }
            _courseHourLabel.text = [NSString stringWithFormat:@"%@课时",[[_orderInfo objectForKey:@"data"] objectForKey:@"section_count"]];
        } else if ([_orderTypeString isEqualToString:@"courseHourse"]) {
            NSString *courseHourseType = [NSString stringWithFormat:@"%@",[[_orderInfo objectForKey:@"data"] objectForKey:@"data_type"]];
            if ([courseHourseType isEqualToString:@"1"]) {
                _courseFaceImageView.image = Image(@"contents_icon_video");
            } else if ([courseHourseType isEqualToString:@"2"]) {
                _courseFaceImageView.image = Image(@"contents_icon_vioce");
            } else if ([courseHourseType isEqualToString:@"3"]) {
                _courseFaceImageView.image = Image(@"img_text_icon");
            } else if ([courseHourseType isEqualToString:@"4"]) {
                _courseFaceImageView.image = Image(@"ebook_icon_word");
            } else {
                _courseFaceImageView.image = Image(@"contents_icon_video");
            }
        } else if ([_orderTypeString isEqualToString:@"exam"]) {
            _courseFaceImageView.image = Image(@"contents_icon_test");
        }
        
        _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"]];
        if ([[V5_UserModel vipStatus] isEqualToString:@"1"]) {
            _priceLabel.text = [NSString stringWithFormat:@"VIP:%@%@",IOSMoneyTitle,[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"]];
        }
        _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@%@",IOSMoneyTitle,[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"]];
        NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
        [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
        _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
        
        NSString *timeLine = [NSString stringWithFormat:@"%@",[[_orderInfo objectForKey:@"data"] objectForKey:@"term_time"]];
        if ([timeLine isEqualToString:@"0"]) {
            _timeLabel.text = @"永久有效";
        } else {
            _timeLabel.text = [NSString stringWithFormat:@"有效期至%@",[EdulineV5_Tool timeForYYYYMMDD:timeLine]];
        }
    }
}

// MARK: - LingquanViewControllerDelegate(选择了之后的代理)
- (void)chooseWhichCoupon:(CouponModel *)coupon {
    if (_couponModel) {
        if ([_couponModel.couponId isEqualToString:coupon.couponId]) {
            _couponModel = nil;
        } else {
            _couponModel = coupon;
        }
    } else {
        _couponModel = coupon;
    }
    if (_couponModel) {
        if ([_couponModel.coupon_type isEqualToString:@"1"]) {
            _kaquanLabel.text = [NSString stringWithFormat:@"满%@减%@",_couponModel.maxprice,_couponModel.price];
            float max_price = [[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"] floatValue];
            if (max_price>=[_couponModel.maxprice floatValue]) {
                _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@%.2f",IOSMoneyTitle,[[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"] floatValue] - [_couponModel.price floatValue]];
                _youhuiLabel.text = [NSString stringWithFormat:@"优惠：%@%@",IOSMoneyTitle,_couponModel.price];
            } else {
                _kaquanLabel.text = [NSString stringWithFormat:@"满%@减%@(不满足要求,无法使用)",_couponModel.maxprice,_couponModel.price];
                _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@%@",IOSMoneyTitle,[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"]];
                _youhuiLabel.text = [NSString stringWithFormat:@"优惠：%@0.00",IOSMoneyTitle];
            }
        } else if ([_couponModel.coupon_type isEqualToString:@"2"]) {
            _kaquanLabel.text = [NSString stringWithFormat:@"%@折",_couponModel.discount];
            float discount1 = [_couponModel.discount floatValue];
            _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@%.2f",IOSMoneyTitle,[[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"] floatValue] * discount1 / 10];
            _youhuiLabel.text = [NSString stringWithFormat:@"优惠：%@%.2f",IOSMoneyTitle,[[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"] floatValue] - [[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"] floatValue] * discount1 / 10];
        } else if ([_couponModel.coupon_type isEqualToString:@"3"]) {
            _kaquanLabel.text = @"课程卡";
            _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@0.00",IOSMoneyTitle];
            _youhuiLabel.text = [NSString stringWithFormat:@"优惠：%@%@",IOSMoneyTitle,[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"]];
        }
    } else {
        _kaquanLabel.text = @"未使用卡券";
        _finalPriceLabel.text = [NSString stringWithFormat:@"合计: %@%@",IOSMoneyTitle,[[_orderInfo objectForKey:@"data"] objectForKey:@"user_price"]];
        _youhuiLabel.text = [NSString stringWithFormat:@"优惠：%@0.00",IOSMoneyTitle];
    }
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
}

// MARK: - 课程卡的时候直接兑换课程 不需要生成订单
- (void)couponDirectExchange:(NSString *)couponCode {
    if (SWNOTEmptyStr(couponCode)) {
        [Net_API requestPOSTWithURLStr:[Net_Path couponDirectExchangeNet] WithAuthorization:nil paramDic:@{@"id":couponCode} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"卡券使用失败"];
        }];
    }
}

@end
