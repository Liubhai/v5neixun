//
//  OrderDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/6.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "OrderDetailVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "V5_UserModel.h"
#import "OrderSureViewController.h"

#import "OrderDetailAsCellView.h"

#import "CourseMainViewController.h"
#import "ShopDetailViewController.h"

@interface OrderDetailVC () {
    BOOL showReload;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UIView *productInfoBackView;
@property (strong, nonatomic) UIView *orderInfoBackView;
@property (strong, nonatomic) UIView *logisticsInfoBackView;
@property (strong, nonatomic) UIView *priceInfoBackView;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) NSDictionary *orderDetailDict;

@end

@implementation OrderDetailVC

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (showReload) {
//        [self getOrderDetailInfoNet];
//    }
//    showReload = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = EdlineV5_Color.backColor;
    self.titleImage.backgroundColor = EdlineV5_Color.backColor;
    self.lineTL.backgroundColor = EdlineV5_Color.backColor;
    self.lineTL.hidden = NO;
    
    _statusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, _titleLabel.height)];
    [self.titleImage addSubview:_statusButton];
    
    [self makeScrollView];
    
    _orderDetailDict = [[NSDictionary alloc] init];
    [self getOrderDetailInfoNet];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetailInfoNet) name:@"getOrderDetailInfoNet" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_mainScrollView];
}

- (void)makeProductsInfoView {
    if (!_productInfoBackView) {
        _productInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - 30, 100)];
        _productInfoBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _productInfoBackView.layer.cornerRadius = 10;
        _productInfoBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0800].CGColor;
        _productInfoBackView.layer.shadowOffset = CGSizeMake(0,1);
        _productInfoBackView.layer.shadowOpacity = 1;
        _productInfoBackView.layer.shadowRadius = 12;
        [_mainScrollView addSubview:_productInfoBackView];
    }
    [_productInfoBackView removeAllSubviews];
    
    NSArray *productsArray = [NSArray arrayWithArray:_orderDetailDict[@"products"]];
    NSString *statusString = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status"]];
    CGFloat yy = 7.5;
    for (int i = 0; i < productsArray.count; i++) {
        OrderDetailAsCellView *view = [[OrderDetailAsCellView alloc] initWithFrame:CGRectMake(0, yy, _productInfoBackView.width, 1)];
        [view setOrderDetailFinalInfo:productsArray[i] orderStatus:statusString cellInfo:_orderDetailDict];
        [view setHeight:view.height];
        [_productInfoBackView addSubview:view];
        
        UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yy, _productInfoBackView.width, view.height)];
        clickBtn.backgroundColor = [UIColor clearColor];
        clickBtn.tag = i;
        [clickBtn addTarget:self action:@selector(jumpTodetaiPage:) forControlEvents:UIControlEventTouchUpInside];
        [_productInfoBackView addSubview:clickBtn];
        
        yy = yy + view.height;
        if (i == (productsArray.count - 1)) {
            [_productInfoBackView setHeight:yy + 7.5];
        }
    }
}

- (void)makeOrderInfoView {
    
    if (!_orderInfoBackView) {
        _orderInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _productInfoBackView.bottom + 8, MainScreenWidth - 30, 180)];
        _orderInfoBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _orderInfoBackView.layer.cornerRadius = 10;
        _orderInfoBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0800].CGColor;
        _orderInfoBackView.layer.shadowOffset = CGSizeMake(0,1);
        _orderInfoBackView.layer.shadowOpacity = 1;
        _orderInfoBackView.layer.shadowRadius = 12;
        [_mainScrollView addSubview:_orderInfoBackView];
    }
    _orderInfoBackView.frame = CGRectMake(15, _productInfoBackView.bottom + 8, MainScreenWidth - 30, 180);
    [_orderInfoBackView removeAllSubviews];
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",_orderDetailDict[@"order_no"]];
    NSString *userPhone = [NSString stringWithFormat:@"%@",[V5_UserModel userPhone]];
    NSString *userMethod = [NSString stringWithFormat:@"%@",_orderDetailDict[@"payway"]];
    if ([userMethod isEqualToString:@"lcnpay"]) {
        userMethod = @"余额";
    } else if ([userMethod isEqualToString:@"alipay"]) {
        userMethod = @"支付宝";
    } else if ([userMethod isEqualToString:@"wxpay"]) {
        userMethod = @"微信";
    } else if ([userMethod isEqualToString:@"<null>"] || [userMethod isEqualToString:@"null"] || !SWNOTEmptyStr(userMethod)) {
        userMethod = @"";
    }
//    NSString *statusString = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status"]];
//
//    if ([statusString isEqualToString:@"20"] || [statusString isEqualToString:@"80"] || [statusString isEqualToString:@"70"]) {
//
//    } else {
//        userMethod = @"";
//    }
    NSString *orderTime = [EdulineV5_Tool formateYYYYMMDDHHMMTime:[NSString stringWithFormat:@"%@",_orderDetailDict[@"create_time"]]];
    NSString *dealTime = [NSString stringWithFormat:@"%@",_orderDetailDict[@"payment_time"]];
    if ([dealTime isEqualToString:@"<null>"] || [dealTime isEqualToString:@"null"] || !SWNOTEmptyStr(dealTime)) {
        dealTime = @"";
    } else {
        dealTime = [EdulineV5_Tool formateYYYYMMDDHHMMTime:[NSString stringWithFormat:@"%@",_orderDetailDict[@"payment_time"]]];
    }
    
    NSString *institution = [NSString stringWithFormat:@"%@",_orderDetailDict[@"mhm"]];
    if ([institution isEqualToString:@"<null>"] || [institution isEqualToString:@"null"] || !SWNOTEmptyStr(institution)) {
        institution = @"";
    }
    
    NSMutableArray *orderInfoArray = [NSMutableArray arrayWithArray:@[@{@"tip":@"订单编号：",@"valueString":orderNum},
                         @{@"tip":@"购买者手机号：",@"valueString":userPhone},
                         @{@"tip":@"支付方式：",@"valueString":userMethod},
                         @{@"tip":@"下单时间：",@"valueString":orderTime},
                         @{@"tip":@"支付时间：",@"valueString":dealTime},
                         @{@"tip":@"机构：",@"valueString":institution}
                         ]];
    
    for (int i = 0; i<orderInfoArray.count; i++) {
        // 订单编号
        UILabel *orderNumTip = [[UILabel alloc] initWithFrame:CGRectMake(12, 16 + (18 + 8) * i, 5 * 13 + 4, 18)];
        orderNumTip.textColor = EdlineV5_Color.textThirdColor;
        orderNumTip.font = SYSTEMFONT(13);
        orderNumTip.text = [NSString stringWithFormat:@"%@",orderInfoArray[i][@"tip"]];
        CGFloat orderTipWidth = [orderNumTip.text sizeWithFont:orderNumTip.font].width;
        [orderNumTip setWidth:orderTipWidth];
        [_orderInfoBackView addSubview:orderNumTip];
        
        UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderNumTip.right, orderNumTip.top, _orderInfoBackView.width - orderNumTip.right - 12, 18)];
        orderNumLabel.textColor = EdlineV5_Color.textFirstColor;
        orderNumLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        orderNumLabel.text = [NSString stringWithFormat:@"%@",orderInfoArray[i][@"valueString"]];
        orderNumLabel.numberOfLines = 0;
        if (i == 5) {
            [orderNumLabel sizeToFit];
            [orderNumLabel setHeight:orderNumLabel.height];
            // 这里要判断最终高度
            [_orderInfoBackView setHeight:(orderNumLabel.bottom + 16 > 180) ? (orderNumLabel.bottom + 16) : 180];
        } else {
            CGFloat orderNumLabelWidth = [orderNumLabel.text sizeWithFont:orderNumLabel.font].width;
            [orderNumLabel setWidth:orderNumLabelWidth];
        }
        [_orderInfoBackView addSubview:orderNumLabel];
        
        if (i == 0) {
            UIButton *orderNumButton = [[UIButton alloc] initWithFrame:CGRectMake(orderNumLabel.right, 0, 32, 32)];
            [orderNumButton setImage:Image(@"order_copy_icon") forState:0];
            [orderNumButton addTarget:self action:@selector(orderNumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            orderNumButton.centerY = orderNumTip.centerY;
            [_orderInfoBackView addSubview:orderNumButton];
        }
    }
    
}

- (void)makeLogisticsInfoBackView {
    if (!_logisticsInfoBackView) {
        _logisticsInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _productInfoBackView.bottom + 8, MainScreenWidth - 30, 147)];
        _logisticsInfoBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _logisticsInfoBackView.layer.cornerRadius = 10;
        _logisticsInfoBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0800].CGColor;
        _logisticsInfoBackView.layer.shadowOffset = CGSizeMake(0,1);
        _logisticsInfoBackView.layer.shadowOpacity = 1;
        _logisticsInfoBackView.layer.shadowRadius = 12;
        [_mainScrollView addSubview:_logisticsInfoBackView];
    }
    _logisticsInfoBackView.frame = CGRectMake(15, _orderInfoBackView.bottom + 8, MainScreenWidth - 30, 180);
    [_logisticsInfoBackView removeAllSubviews];
    
    NSString *statusString = [NSString stringWithFormat:@"%@",_orderDetailDict[@"order_type"]];
    NSString *statusText = [NSString stringWithFormat:@"%@",_orderDetailDict[@"fictitious"]];
    if (!([statusString isEqualToString:@"11"] && ![statusText integerValue])) {
        _logisticsInfoBackView.frame = CGRectMake(15, _orderInfoBackView.bottom, MainScreenWidth - 30, 0);
        return;
    }
    
    NSString *logisticName = @"未发货";
    if (_orderDetailDict[@"ext_data"][@"title"]) {
        logisticName = [NSString stringWithFormat:@"%@",_orderDetailDict[@"ext_data"][@"title"]];
    }
    
    NSString *logisticNum = @"未发货";
    if (_orderDetailDict[@"ext_data"][@"order"]) {
        logisticNum = [NSString stringWithFormat:@"%@",_orderDetailDict[@"ext_data"][@"order"]];
    }
    NSString *consignee = @"";
    NSString *phone = @"";
    NSString *areatext = @"";
    NSString *address = @"";
    if (SWNOTEmptyDictionary(_orderDetailDict[@"addrinfo"])) {
        consignee = [NSString stringWithFormat:@"%@",_orderDetailDict[@"addrinfo"][@"consignee"]];
        phone = [NSString stringWithFormat:@"%@",_orderDetailDict[@"addrinfo"][@"phone"]];
        areatext = [NSString stringWithFormat:@"%@",_orderDetailDict[@"addrinfo"][@"areatext"]];
        address = [NSString stringWithFormat:@"%@",_orderDetailDict[@"addrinfo"][@"address"]];
    }
    
    NSString *logisticAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@",consignee,phone,areatext,address];
    
    NSMutableArray *orderInfoArray = [NSMutableArray arrayWithArray:
                       @[@{@"tip":@"配送信息",@"valueString":@""},
                         @{@"tip":@"配送快递：",@"valueString":logisticName},
                         @{@"tip":@"快递单号：",@"valueString":logisticNum},
                         @{@"tip":@"收货地址：",@"valueString":logisticAddress},
                         ]];
    
    for (int i = 0; i<orderInfoArray.count; i++) {
        // 订单编号
        UILabel *orderNumTip = [[UILabel alloc] initWithFrame:CGRectMake(12, 16 + (18 + 8) * i, 5 * 13 + 4, 18)];
        if (i == 0) {
            orderNumTip.textColor = EdlineV5_Color.textFirstColor;
            orderNumTip.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        } else {
            orderNumTip.textColor = EdlineV5_Color.textThirdColor;
            orderNumTip.font = SYSTEMFONT(13);
        }
        orderNumTip.text = [NSString stringWithFormat:@"%@",orderInfoArray[i][@"tip"]];
        CGFloat orderTipWidth = [orderNumTip.text sizeWithFont:orderNumTip.font].width;
        [orderNumTip setWidth:orderTipWidth];
        [_logisticsInfoBackView addSubview:orderNumTip];
        
        UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderNumTip.right, orderNumTip.top, _logisticsInfoBackView.width - orderNumTip.right - 12, 18)];
        orderNumLabel.textColor = EdlineV5_Color.textFirstColor;
        orderNumLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        orderNumLabel.text = [NSString stringWithFormat:@"%@",orderInfoArray[i][@"valueString"]];
        orderNumLabel.numberOfLines = 0;
        if (i == 3) {
            [orderNumLabel sizeToFit];
            [orderNumLabel setHeight:orderNumLabel.height];
            // 这里要判断最终高度
            [_logisticsInfoBackView setHeight:(orderNumLabel.bottom + 16 > 147) ? (orderNumLabel.bottom + 16) : 147];
        } else {
            CGFloat orderNumLabelWidth = [orderNumLabel.text sizeWithFont:orderNumLabel.font].width;
            [orderNumLabel setWidth:orderNumLabelWidth];
        }
        [_logisticsInfoBackView addSubview:orderNumLabel];
        
        if (i == 2 && ![logisticNum isEqualToString:@"未发货"]) {
            UIButton *orderNumButton = [[UIButton alloc] initWithFrame:CGRectMake(orderNumLabel.right, 0, 32, 32)];
            [orderNumButton setImage:Image(@"order_copy_icon") forState:0];
            [orderNumButton addTarget:self action:@selector(logisticsNumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            orderNumButton.centerY = orderNumTip.centerY;
            [_logisticsInfoBackView addSubview:orderNumButton];
        }
    }
}

- (void)makePriceInfoBackView {
    if (!_priceInfoBackView) {
        _priceInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _productInfoBackView.bottom + 8, MainScreenWidth - 30, 110)];
        _priceInfoBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _priceInfoBackView.layer.cornerRadius = 10;
        _priceInfoBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0800].CGColor;
        _priceInfoBackView.layer.shadowOffset = CGSizeMake(0,1);
        _priceInfoBackView.layer.shadowOpacity = 1;
        _priceInfoBackView.layer.shadowRadius = 12;
        [_mainScrollView addSubview:_priceInfoBackView];
    }
    _priceInfoBackView.frame = CGRectMake(15, _logisticsInfoBackView.bottom + 8, MainScreenWidth - 30, 110);
    [_priceInfoBackView removeAllSubviews];
    
    NSString *statusString = [NSString stringWithFormat:@"%@",_orderDetailDict[@"order_type"]];
    NSString *statusS = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status"]];
    NSString *tipString = @"实付款：";
    if ([statusS isEqualToString:@"20"] || [statusS isEqualToString:@"80"] || [statusS isEqualToString:@"70"] || [statusS isEqualToString:@"50"]) {
        tipString = @"实付款：";
    } else if ([statusS isEqualToString:@"10"]) {
        tipString = @"需付款：";
    } else {
        tipString = @"应付款：";
    }
    
    NSMutableArray *orderInfoArray = [[NSMutableArray alloc] init];
    NSString *productTotal = @"";
    NSString *finalPrice = @"";
    if ([statusString isEqualToString:@"11"]) {
        
        NSArray *product = [NSArray arrayWithArray:_orderDetailDict[@"products"]];
        NSString *carriage = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,product[0][@"carriage"]];
        NSString *singlePrice = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:_orderDetailDict[@"ext_data"][@"cash_price"]]];
        NSString *singleCredit = [NSString stringWithFormat:@"%@",_orderDetailDict[@"ext_data"][@"credit_price"]];
        NSString *productCount = [NSString stringWithFormat:@"%@",_orderDetailDict[@"ext_data"][@"num"]];
        productTotal = [NSString stringWithFormat:@"%@积分+%@%@",@([productCount integerValue] * [singleCredit integerValue]),IOSMoneyTitle,[self dealShopPrice:@([singlePrice floatValue] * [productCount integerValue])]];
        
        if ([singleCredit isEqualToString:@"0"] && ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"])) {
            productTotal = @"免费";
        } else if ([singleCredit isEqualToString:@"0"]) {
            productTotal = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[self dealShopPrice:@([singlePrice floatValue] * [productCount integerValue])]];
        } else if ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"]) {
            productTotal = [NSString stringWithFormat:@"%@积分",@([productCount integerValue] * [singleCredit integerValue])];
        }
        
        NSString *finalCredit = [NSString stringWithFormat:@"%@",_orderDetailDict[@"credit"][@"credit"]];
        NSString *finalPayment = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:_orderDetailDict[@"payment"]]];
        finalPrice = [NSString stringWithFormat:@"%@积分+%@%@",finalCredit,IOSMoneyTitle,finalPayment];
        if (([finalCredit isEqualToString:@"0"] && ([finalPayment isEqualToString:@"0.00"] || [finalPayment isEqualToString:@"0.0"] || [finalPayment isEqualToString:@"0"]))) {
            finalPrice = @"免费";
        } else if ([finalCredit isEqualToString:@"0"]) {
            finalPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,finalPayment];
        } else if ([finalPayment isEqualToString:@"0.00"] || [finalPayment isEqualToString:@"0.0"] || [finalPayment isEqualToString:@"0"]) {
            finalPrice = [NSString stringWithFormat:@"%@积分",finalCredit];
        }
        NSString *finalPriceString = [NSString stringWithFormat:@"%@%@",tipString,finalPrice];
        
        orderInfoArray = [NSMutableArray arrayWithArray:@[
                                          @{@"tip":@"商品总价",@"valueString":productTotal},
                                          @{@"tip":@"运费",@"valueString":carriage},
                                          @{@"tip":@"",@"valueString":finalPriceString}]];
    } else {
        
        NSString *courseTtotal = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:_orderDetailDict[@"total_price"]]];
        NSString *youhui = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,_orderDetailDict[@"fee_price"]];
        
        NSString *payment = [NSString stringWithFormat:@"%@%@%@",tipString,IOSMoneyTitle,_orderDetailDict[@"payment"]];
        orderInfoArray = [NSMutableArray arrayWithArray:
                          @[@{@"tip":@"课程总价",@"valueString":courseTtotal},
                            @{@"tip":@"优惠价格",@"valueString":youhui},
                            @{@"tip":@"",@"valueString":payment},
                          ]];
    }
    
    for (int i = 0; i<orderInfoArray.count; i++) {
        // 订单编号
        UILabel *orderNumTip = [[UILabel alloc] initWithFrame:CGRectMake(12, 16 + (18 + 8) * i, 5 * 13 + 4, 18)];
        if (i == (orderInfoArray.count - 1)) {
            orderNumTip.frame = CGRectMake(12, 16 + (18 + 8) * i + 8, 5 * 13 + 4, 18);
        }
        orderNumTip.textColor = EdlineV5_Color.textThirdColor;
        orderNumTip.font = SYSTEMFONT(13);
        orderNumTip.text = [NSString stringWithFormat:@"%@",orderInfoArray[i][@"tip"]];
        CGFloat orderTipWidth = [orderNumTip.text sizeWithFont:orderNumTip.font].width;
        [orderNumTip setWidth:orderTipWidth];
        [_priceInfoBackView addSubview:orderNumTip];
        
        UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderNumTip.right, orderNumTip.top, _priceInfoBackView.width - orderNumTip.right - 12, 18)];
        orderNumLabel.textColor = EdlineV5_Color.textFirstColor;
        orderNumLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        orderNumLabel.text = [NSString stringWithFormat:@"%@",orderInfoArray[i][@"valueString"]];
        
        if ([statusString isEqualToString:@"11"]) {
            if ([orderNumLabel.text isEqualToString:@"免费"]) {
                orderNumLabel.textColor = EdlineV5_Color.priceFreeColor;
            }
        }
        
        orderNumLabel.textAlignment = NSTextAlignmentRight;
        [_priceInfoBackView addSubview:orderNumLabel];
        
        if (i == (orderInfoArray.count - 1)) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, orderNumTip.top - 8, _priceInfoBackView.width, 0.5)];
            line.backgroundColor = EdlineV5_Color.backColor;
            [_priceInfoBackView addSubview:line];
            
            if ([statusString isEqualToString:@"11"] && [finalPrice isEqualToString:@"免费"]) {
                // 处理富文本
                NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:orderNumLabel.text];
                [showPriceAtt addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.priceFreeColor} range:NSMakeRange(4, orderNumLabel.text.length - 4)];
                orderNumLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
            } else {
                // 处理富文本
                NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:orderNumLabel.text];
                [showPriceAtt addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textPriceColor} range:NSMakeRange(4, orderNumLabel.text.length - 4)];
                orderNumLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
            }
        }
    }
}

- (void)makeBottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
        _bottomView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0600].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0,1);
        _bottomView.layer.shadowOpacity = 1;
        _bottomView.layer.shadowRadius = 7;
        [self.view addSubview:_bottomView];
    }
    
    [_bottomView removeAllSubviews];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(MainScreenWidth - 15 - 85, 6.5, 85, 32);
    [button2 setTitle:@"去支付" forState:0];
    button2.titleLabel.font = SYSTEMFONT(14);
    [button2 setTitleColor:[UIColor whiteColor] forState:0];
    button2.backgroundColor = EdlineV5_Color.baseColor;
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = button2.height / 2.0;
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:button2];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(button2.left - 12 - 85, 6.5, 85, 32);
    button1.titleLabel.font = SYSTEMFONT(14);
    [button1 setTitle:@"删除订单" forState:0];
    [button1 setTitleColor:EdlineV5_Color.baseColor forState:0];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = button1.height / 2.0;
    button1.layer.borderWidth = 1;
    button1.layer.borderColor = EdlineV5_Color.baseColor.CGColor;
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:button1];
    
    button1.hidden = NO;
    button2.hidden = NO;
    
    // 支付状态:0-已取消 10-未付款 20-已付款 30-已申请退款,待确认 40-退款已确认,退款中 50-已退款 60-交易被关闭  70:已支付,但被管理员移除 80:拼团已支付，未成团
    
    NSString *orderStatus = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status"]];
    if ([orderStatus isEqualToString:@"0"]) {
        // 已取消
        button2.hidden = YES;
        button1.frame = CGRectMake(MainScreenWidth - 15 - 85, 6.5, 85, 32);
        [button1 setTitle:@"删除订单" forState:0];
    } else if ([orderStatus isEqualToString:@"10"]) {
        // 待支付
        [button2 setTitle:@"去支付" forState:0];
        [button1 setTitle:@"取消订单" forState:0];
    } else if ([orderStatus isEqualToString:@"20"] || [orderStatus isEqualToString:@"80"] || [orderStatus isEqualToString:@"60"] || [orderStatus isEqualToString:@"50"]) {
        // 已完成
        button2.hidden = YES;
        button1.hidden = YES;
        _bottomView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 0);
        _bottomView.hidden = YES;
    } else if ([orderStatus isEqualToString:@"30"]) {
        
    } else if ([orderStatus isEqualToString:@"40"]) {
        
    } else if ([orderStatus isEqualToString:@"50"]) {
        
    } else if ([orderStatus isEqualToString:@"60"]) {
        
    }
    [_mainScrollView setHeight:_bottomView.top - MACRO_UI_UPHEIGHT];
    _mainScrollView.contentSize = CGSizeMake(0, _priceInfoBackView.bottom);
}

- (void)button1Click:(UIButton *)sender {
    NSString *orderStatus = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status"]];
    if ([orderStatus isEqualToString:@"0"]) {
        // 已取消
        // 去删除订单
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self doDeleteOrder:_orderDetailDict[@"order_no"]];
        }];
        [commentAction setValue:EdlineV5_Color.textFirstColor forKey:@"titleTextColor"];
        [cancelAction setValue:EdlineV5_Color.themeColor forKey:@"titleTextColor"];
        [alertController addAction:commentAction];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([orderStatus isEqualToString:@"10"]) {
        // 待支付
        // 去取消订单
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self doCancelOrder:_orderDetailDict[@"order_no"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [commentAction setValue:EdlineV5_Color.themeColor forKey:@"titleTextColor"];
        [cancelAction setValue:EdlineV5_Color.textFirstColor forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
        [alertController addAction:commentAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([orderStatus isEqualToString:@"20"]) {
        // 已完成
        // 不做任何操作
    }
}

- (void)button2Click:(UIButton *)sender {
    OrderSureViewController *vc = [[OrderSureViewController alloc] init];
    vc.order_no = [NSString stringWithFormat:@"%@",_orderDetailDict[@"order_no"]];
    vc.payment = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,_orderDetailDict[@"payment"]];
    vc.orderTypeString = @"orderDetail";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doDeleteOrder:(NSString *)order_num {
    if (SWNOTEmptyStr(order_num)) {
        [Net_API requestDeleteWithURLStr:[Net_Path deleteOrderNet] paramDic:@{@"order_no":order_num} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"删除订单超时,请稍后重试"];
        }];
    } else {
        [self showHudInView:self.view showHint:@"订单号有误"];
    }
}

- (void)doCancelOrder:(NSString *)order_num {
    if (SWNOTEmptyStr(order_num)) {
        [Net_API requestPUTWithURLStr:[Net_Path cancelOrder] paramDic:@{@"order_no":order_num} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [self getOrderDetailInfoNet];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"取消订单超时,请稍后重试"];
        }];
    } else {
        [self showHudInView:self.view showHint:@"订单号有误"];
    }
}

// MARK: - 复制订单号
- (void)orderNumButtonClick:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",_orderDetailDict[@"order_no"]];
    [self showHudInView:self.view showHint:@"订单号复制成功"];
}

// MARK: - 复制快递单号
- (void)logisticsNumButtonClick:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",_orderDetailDict[@"ext_data"][@"order"]];
    [self showHudInView:self.view showHint:@"快递单号复制成功"];
}

// MARK: - 点击课程或者商品跳转到对应的详情页面去
- (void)jumpTodetaiPage:(UIButton *)sender {
    NSDictionary *pass = _orderDetailDict[@"products"][sender.tag];
    
    NSString *typeString = [NSString stringWithFormat:@"%@",[pass objectForKey:@"type_id"]];
    
    NSString *courseType = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]];
    
    if ([typeString isEqualToString:@"11"]) {
        // 商品详情
        ShopDetailViewController *vc = [[ShopDetailViewController alloc] init];
        vc.shopId = [NSString stringWithFormat:@"%@",pass[@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //课程类型【1：点播；2：直播；3：面试；4：班级；】
    if ([courseType isEqualToString:@"1"]) {
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]];
        if ([typeString isEqualToString:@"101"] || [typeString isEqualToString:@"102"] || [typeString isEqualToString:@"103"] || [typeString isEqualToString:@"104"]) {
            vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_id"]];
        }
        vc.courselayer = [NSString stringWithFormat:@"%@",[pass objectForKey:@"section_level"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
        vc.courseType = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([courseType isEqualToString:@"2"]) {
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]];
        if ([typeString isEqualToString:@"101"] || [typeString isEqualToString:@"102"] || [typeString isEqualToString:@"103"] || [typeString isEqualToString:@"104"]) {
            vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_id"]];
        }
        vc.isLive = [[NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
        vc.courseType = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([courseType isEqualToString:@"3"]) {
        
    } else if ([courseType isEqualToString:@"4"]) {
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]];
        if ([typeString isEqualToString:@"101"] || [typeString isEqualToString:@"102"] || [typeString isEqualToString:@"103"] || [typeString isEqualToString:@"104"]) {
            vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_id"]];
        }
        vc.isLive = [[NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
        vc.courseType = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getOrderDetailInfoNet {
    if (SWNOTEmptyStr(_orderNum)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path orderDetailPageNet:_orderNum] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _orderDetailDict = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    [self dealPageUI];
                } else {
                    [self showHudInView:self.view showHint:responseObject[@"msg"]];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络飞走了"];
        }];
    }
}

- (void)dealPageUI {
    if (SWNOTEmptyDictionary(_orderDetailDict)) {
        NSString *statusString = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status"]];
        NSString *statusText = [NSString stringWithFormat:@"%@",_orderDetailDict[@"status_text"]];
        
        // 处理顶部状态显示
        CGFloat statusWidth = [statusText sizeWithFont:SYSTEMFONT(18)].width + 7 + 18;
        CGFloat space = 2.0;
        _statusButton.frame = CGRectMake(0, 0, statusWidth, _titleLabel.height);
        if ([statusString isEqualToString:@"20"] || [statusString isEqualToString:@"80"] || [statusString isEqualToString:@"70"]) {
            [_statusButton setImage:Image(@"order_paid_icon") forState:0];
        } else {
            [_statusButton setImage:Image(@"order_cancel_icon") forState:0];
        }
        [_statusButton setTitle:statusText forState:0];
        [_statusButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        _statusButton.titleLabel.font = SYSTEMFONT(18);
        _statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
        _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        _statusButton.center = _titleLabel.center;
        
        // 构建订单信息
        [self makeProductsInfoView];
        [self makeOrderInfoView];
        [self makeLogisticsInfoBackView];
        [self makePriceInfoBackView];
        [self makeBottomView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
