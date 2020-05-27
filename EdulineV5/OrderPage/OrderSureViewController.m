//
//  OrderSureViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderSureViewController.h"
#import "Net_Path.h"

@interface OrderSureViewController ()<WKUIDelegate,WKNavigationDelegate> {
    NSString *typeString;//支付方式【lcnpay：余额；alipay：支付宝；wxpay：微信；】
    BOOL shouldPop;// 是否需要返回到课程详情页面
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
        _payment = [NSString stringWithFormat:@"¥%@",[_orderSureInfo[@"data"] objectForKey:@"payment"]];
        _order_no = [NSString stringWithFormat:@"%@",[[_orderSureInfo objectForKey:@"data"] objectForKey:@"order_no"]];
    }
    _priceLabel.text = _payment;
    [self.view addSubview:_priceLabel];
    _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _priceLabel.bottom, MainScreenWidth, 168)];
    _orderTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderTypeView];
    
    [self makeDownView];
    [self getUserPayInfo];
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
    [_orderRightBtn2 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
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
    _orderTitle3.text = @"余额(¥0.00)";
    [_orderTypeView3 addSubview:_orderTitle3];
    
    _orderRightBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 56, 0, 56, 56)];
    [_orderRightBtn3 setImage:Image(@"checkbox_def") forState:0];
    [_orderRightBtn3 setImage:Image(@"checkbox_blue") forState:UIControlStateSelected];
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

- (void)makeAgreeView {
    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView.bottom +10, MainScreenWidth, 60)];
    _agreeBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_agreeBackView];
    
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

- (void)makeWkWebView {
    if (!_wkWebView) {
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;

        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, MainScreenHeight) configuration:wkWebConfig];
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.userInteractionEnabled = YES;
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    NSString *allStr = @"alipay://alipayclient/?%7B%22requestType%22%3A%22SafePay%22%2C%22fromAppUrlScheme%22%3A%22openshare%22%2C%22dataString%22%3A%22alipay_sdk%3Dalipay-sdk-php-20161101%26app_id%3D2017101909381859%26biz_content%3D%257B%2522body%2522%253A%2522Eduline%255Cu5728%255Cu7ebf%255Cu6559%255Cu80b2-%255Cu8d2d%255Cu4e70%255Cu8bfe%255Cu7a0b%255Cuff1a%255Cu4eba%255Cu529b%255Cu5fc5...%2522%252C%2522subject%2522%253A%2522Eduline%255Cu5728%255Cu7ebf%255Cu6559%255Cu80b2-%255Cu8d2d%255Cu4e70%255Cu8bfe%255Cu7a0b%255Cuff1a%255Cu4eba%255Cu529b%255Cu5fc5...%2522%252C%2522out_trade_no%2522%253A%25222020050715150986574456161875%2522%252C%2522total_amount%2522%253A%25220.01%2522%252C%2522product_code%2522%253A%2522QUICK_MSECURITY_PAY%2522%252C%2522passback_params%2522%253A%2522nekKOU0VfNlKINFVluCBfb4n4I7qgX0CpKELKdtmiHWN3HprNXOOeG1SwYZO2LoK7V70ta47ZaIR6wnG6%2522%257D%26charset%3DUTF-8%26format%3Djson%26method%3Dalipay.trade.app.pay%26notify_url%3Dhttps%253A%252F%252Ft.v4.51eduline.com%252Falipay_alinu.html%26sign_type%3DRSA2%26timestamp%3D2020-05-07%2B15%253A15%253A09%26version%3D1.0%26sign%3DwBm5c5%252FSBk4iLbMvPqfaVTXz3r0tJ7M3wJR22kPbIQsv93w%252BwDZirOyTMXE3rr4dF%252FuOc0EML6zZmP0Z6LPQQF0dY%252BXhvsgo3%252BXf%252B3dAYjQrmCte4PpDMssdnWhSzKwjCe7C%252F7qQZFJlzzgK42qNNz%252BuVCtTsx8o2c6moCxkjal4oS6BRZDbvAyFcIEwrKgdPXwDbryIveHnu8%252FHOZdytgnVerlhvwWBYh%252BRMaOtq0uhBckc71IPgZx%252F%252BQd8LWiw1ewBKNhcIB1MfXxdoHs%252BrsSh2UQq4T8be4pbC85WsVa1vceuE7gcRUsV4TXqVFT2hW6wMPFbPfjVi3HbSZng5w%253D%253D%22%7D";
    [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:allStr]]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    NSString *schme = [navigationAction.request.URL scheme];
    if ([url containsString:@"alipay://alipayclient"]) {
        NSMutableString *param = [NSMutableString stringWithFormat:@"%@", (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)url, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))];

        NSRange range = [param rangeOfString:@"{"];
        // 截取 json 部分
        NSString *param1 = [param substringFromIndex:range.location];
        if ([param1 rangeOfString:@"\"fromAppUrlScheme\":"].length > 0) {
            NSData *data = [param1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            if (![tempDic isKindOfClass:[NSDictionary class]]) {
                WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyCancel;
                //这句是必须加上的，不然会异常
                decisionHandler(actionPolicy);
                return;
            }

            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:tempDic];
            dicM[@"fromAppUrlScheme"] = AlipayBundleId;

            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicM options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

            NSString *encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                           (CFStringRef)jsonStr, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));

            // 只替换 json 部分
            [param replaceCharactersInRange:NSMakeRange(range.location, param.length - range.location)  withString:encodedString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
        }
    }
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
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

- (void)getUserPayInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userPayInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _balanceInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                if (SWNOTEmptyDictionary(_balanceInfo[@"data"])) {
                    [_typeArray removeAllObjects];
                    [_typeArray addObjectsFromArray:[_balanceInfo[@"data"] objectForKey:@"payway"]];
                    
                    [self makeOrderType1View1];
                    [self makeOrderType1View2];
                    [self makeOrderType1View3];
                    [_orderTypeView setHeight:_orderTypeView3.bottom];
                    
                    _orderTitle3.text = [NSString stringWithFormat:@"余额(¥%@)",[_balanceInfo[@"data"] objectForKey:@"balance"]];
                    
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
        [self showHudInView:self.view showHint:@"请勾选并确认阅读购买协议"];
        _submitButton.enabled = YES;
        return;
    }
    if (SWNOTEmptyStr(typeString) && SWNOTEmptyStr(_order_no)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:typeString forKey:@"pay_type"];
        [param setObject:_order_no forKey:@"order_no"];
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
                    } else if ([typeString isEqualToString:@"wxpay"]) {
                        shouldPop = YES;
                    }
                } else {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    _submitButton.enabled = YES;
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

- (void)popVcToWhich {
    if ([_orderTypeString isEqualToString:@"course"]) {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:NO];
    } else if ([_orderTypeString isEqualToString:@"shopcar"]) {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:NO];
    } else if ([_orderTypeString isEqualToString:@"orderList"]) {
        // 刷新订单所有页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderList" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
