//
//  OrderSureViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderSureViewController.h"
#import "Net_Path.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>
#import "WkWebViewController.h"
#import "V5_UserModel.h"
#import "MyBalanceVC.h"
#import "MoneyPassWordPopView.h"
#import "SetMoneyPwFirstVC.h"
#import "ModifyMoneyPwVC.h"

@interface OrderSureViewController ()<WKUIDelegate,WKNavigationDelegate,MoneyPassWordPopViewDelegate> {
    NSString *typeString;
    BOOL shouldPop;// 是否需要返回到课程详情页面
    BOOL showReload;// 在余额不足跳转到充值页面后  充值成功后 是否需要刷新余额数据
}

@property (strong, nonatomic) NSDictionary *balanceInfo;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) NSMutableArray *typeArray;

@end

@implementation OrderSureViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (shouldPop) {
        [self popVcToWhich];
    }
    if (showReload) {
        showReload = NO;
        [self getUserPayInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    typeString = @"lcnpay";
    _typeArray = [NSMutableArray new];
    _titleLabel.text = @"订单支付";
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 10, MainScreenWidth, 75)];
    _priceLabel.backgroundColor = [UIColor whiteColor];
    _priceLabel.font = SYSTEMFONT(20);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    if (SWNOTEmptyDictionary(_orderSureInfo) && !SWNOTEmptyStr(_payment) && !SWNOTEmptyStr(_order_no)) {
        _payment = [NSString stringWithFormat:@"育币%@",[_orderSureInfo[@"data"] objectForKey:@"payment"]];
        if ([[V5_UserModel vipStatus] isEqualToString:@"1"]) {
            _payment = [NSString stringWithFormat:@"VIP:育币%@",[_orderSureInfo[@"data"] objectForKey:@"payment"]];
        }
        _order_no = [NSString stringWithFormat:@"%@",[[_orderSureInfo objectForKey:@"data"] objectForKey:@"order_no"]];
    }
    _priceLabel.text = _payment;
    [self.view addSubview:_priceLabel];
    _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _priceLabel.bottom, MainScreenWidth, 168)];
    _orderTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderTypeView];
    
    [self makeDownView];
    [self getUserPayInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVcToWhich) name:@"orderFinished" object:nil];
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
    _orderTitle3.text = @"余额(育币0.00)";
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
//        [_orderTypeView1 setHeight:0];
//        _orderTypeView1.hidden = YES;
//
//        _orderTypeView2.frame = CGRectMake(0, _orderTypeView1.bottom, MainScreenWidth, 56);
//        [_orderTypeView2 setHeight:0];
//        _orderTypeView2.hidden = YES;
//
//        _orderTypeView3.frame = CGRectMake(0, _orderTypeView2.bottom, MainScreenWidth, 56);
//        [self seleteButtonClick:_orderRightBtn3];
        if (_orderTypeView1.height == 0 && _orderTypeView2.height == 0) {
            [self seleteButtonClick:_orderRightBtn3];
        }
    }
}

- (void)makeAgreeView {
    if (!_agreeBackView) {
        _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView.bottom +10, MainScreenWidth, 60)];
        _agreeBackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_agreeBackView];
    } else {
        _agreeBackView.frame = CGRectMake(0, _orderTypeView.bottom +10, MainScreenWidth, 60);
        return;
    }
    
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
}

- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6.5, 320, 36)];
    [_submitButton setTitle:@"去支付" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerX = _bottomView.width/2.0;
    [_submitButton addTarget:self action:@selector(subMitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
}

- (void)seleteAgreementButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)seleteButtonClick:(UIButton *)sender {
    if (sender == _orderRightBtn1) {
        _orderRightBtn1.selected = YES;
        _orderRightBtn2.selected = NO;
        _orderRightBtn3.selected = NO;
        typeString = @"alipay";
    } else if (sender == _orderRightBtn2) {
        _orderRightBtn2.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn3.selected = NO;
        typeString = @"wxpay";
    } else if (sender == _orderRightBtn3) {
        _orderRightBtn3.selected = YES;
        _orderRightBtn1.selected = NO;
        _orderRightBtn2.selected = NO;
        typeString = @"lcnpay";
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
    }
}

- (void)getUserPayInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userPayInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _balanceInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                if (SWNOTEmptyDictionary(_balanceInfo[@"data"])) {
                    [_typeArray removeAllObjects];
                    [_typeArray addObjectsFromArray:[_balanceInfo[@"data"] objectForKey:@"payway"]];
                    
                    [_orderTypeView removeAllSubviews];
                    
                    [self makeOrderType1View1];
                    [self makeOrderType1View2];
                    [self makeOrderType1View3];
                    [_orderTypeView setHeight:_orderTypeView3.bottom];
                    
                    _orderTitle3.text = [NSString stringWithFormat:@"余额(育币%@)",[_balanceInfo[@"data"] objectForKey:@"balance"]];
                    
                    [self makeAgreeView];
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)subMitButtonClick:(UIButton *)sender {
    _submitButton.enabled = NO;
    if (!_seleteBtn.selected) {
        [self showHudInView:self.view showHint:@"请勾选并确认阅读用户服务协议"];
        _submitButton.enabled = YES;
        return;
    }
    if ([typeString isEqualToString:@"lcnpay"] && SWNOTEmptyStr([V5_UserModel userPhone])) {
        if ([V5_UserModel userPhone].length >= 11) {
            MoneyPassWordPopView *vc = [[MoneyPassWordPopView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            vc.delegate = self;
            [self.view addSubview:vc];
            _submitButton.enabled = YES;
        } else {
            [self getMoneyPasWordString:@""];
        }
    } else {
        [self getMoneyPasWordString:@""];
    }
}

// MARK: - 密码输入完成代理
- (void)getMoneyPasWordString:(NSString *)pw {
    if (SWNOTEmptyStr(typeString) && SWNOTEmptyStr(_order_no)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:typeString forKey:@"pay_type"];
        [param setObject:_order_no forKey:@"order_no"];
        if (SWNOTEmptyStr(pw)) {
            [param setObject:[[EdulineV5_Tool getmd5WithString:pw] lowercaseString] forKey:@"password"];
        }
        [Net_API requestPOSTWithURLStr:[Net_Path subMitOrder] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    if ([typeString isEqualToString:@"lcnpay"]) {
                        [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self popVcToWhich];
                        });
                        return;
                    } else if ([typeString isEqualToString:@"alipay"]) {
                        shouldPop = YES;
                        [self orderFinish:[[responseObject objectForKey:@"data"] objectForKey:@"paybody"]];
                    } else if ([typeString isEqualToString:@"wxpay"]) {
                        [self otherOrderTypeWx:[[responseObject objectForKey:@"data"] objectForKey:@"paybody"]];
                        shouldPop = YES;
                    }
                } else {
                    _submitButton.enabled = YES;
                    NSString *msg = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
                    if ([msg isEqualToString:@"余额不足"]) {
                        // 弹框提示跳转到余额充值页面
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"余额不足,立即去充值?" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            showReload = YES;
                            MyBalanceVC *vc = [[MyBalanceVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                            }];
                        [alertController addAction:commentAction];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:YES];
                            }];
                        [alertController addAction:cancelAction];
                        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self presentViewController:alertController animated:YES completion:nil];
                    } else {
                        [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    }
                }
            } else {
                _submitButton.enabled = YES;
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络飞走了"];
            _submitButton.enabled = YES;
        }];
    } else {
        _submitButton.enabled = YES;
    }
}

// MARK: - 设置密码
- (void)jumpSetPwPage {
    if ([V5_UserModel need_set_paypwd]) {
        SetMoneyPwFirstVC *vc = [[SetMoneyPwFirstVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ModifyMoneyPwVC *vc = [[ModifyMoneyPwVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)orderFinish:(NSString *)orderS {
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderS fromScheme:PayBundleId callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

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

- (void)popVcToWhich {
    if ([_orderTypeString isEqualToString:@"course"]) {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:NO];
    } else if ([_orderTypeString isEqualToString:@"shopcar"]) {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 4] animated:NO];
    } else if ([_orderTypeString isEqualToString:@"orderList"]) {
        // 刷新订单所有页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderList" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([_orderTypeString isEqualToString:@"member"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMember" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)leftButtonClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃本次付款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"继续付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        }];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
