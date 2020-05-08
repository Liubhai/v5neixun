//
//  ShopCarManagerFinalVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShopCarManagerFinalVC.h"
#import "V5_Constant.h"
#import "ShitikaViewController.h"
#import "ShopCarCell.h"
#import "LingquanViewController.h"
#import "OrderSureViewController.h"
#import "Net_Path.h"

@interface ShopCarManagerFinalVC ()<UITableViewDelegate,UITableViewDataSource,LingquanViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

@end

@implementation ShopCarManagerFinalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSourse = [NSMutableArray new];
    _titleLabel.text = @"购物车";
//    [self makeTableFooterView];
    [self makeTableView];
    [self makeDownView];
    [self getOrderShopcarInfo];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.tableFooterView = _footerView;
    [self.view addSubview:_tableView];
}

- (void)makeTableFooterView {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    _footerView.backgroundColor = EdlineV5_Color.backColor;
    NSArray *titleArray = @[@"使用实体卡"];
    _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, titleArray.count * 55)];
    _otherView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_otherView];
    [_footerView setHeight:_otherView.bottom + 10];
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
            _shitikaLabel = themelabel;
        } else if (i == 1) {
            _shitikaLabel = themelabel;
        }
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 7, 0, 7, 13.5)];
        icon.image = Image(@"list_more");
        icon.centerY = themelabel.centerY;;
        [_otherView addSubview:icon];
        
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, youhui.top, MainScreenWidth, youhui.height)];
        clearBtn.backgroundColor = [UIColor clearColor];
        clearBtn.tag = 10 + i;
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherView addSubview:clearBtn];
    }
    /**
    _orderTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _otherView.bottom + 10, MainScreenWidth, 168)];
    _orderTypeView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_orderTypeView];
    
    [self makeOrderType1View1];
    [self makeOrderType1View2];
    [self makeOrderType1View3];
    [_orderTypeView setHeight:_orderTypeView3.bottom];
    
    _agreeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderTypeView.bottom +10, MainScreenWidth, 60)];
    _agreeBackView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_agreeBackView];
    [_footerView setHeight:_agreeBackView.bottom];
    
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
     */
}

/**
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
*/

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
    [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    if (sender.tag == 10) {
        ShitikaViewController *vc = [[ShitikaViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)kaquanClearBtnClick:(UIButton *)sender {
    LingquanViewController *vc = [[LingquanViewController alloc] init];
    ShopCarModel *model = _dataSourse[sender.tag];
    vc.shopCarFinalIndexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    vc.mhm_id = model.mhm_id;
    vc.delegate = self;
    vc.couponModel = model.best_coupon;
    vc.carModel = model;
    vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
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
    NSMutableArray *paramArray = [NSMutableArray new];
    if (SWNOTEmptyArr(_dataSourse)) {
        for (int i = 0; i<_dataSourse.count; i++) {
            ShopCarModel *carmodel = _dataSourse[i];
            NSString *courseIdString = @"";
            NSMutableDictionary *param = [NSMutableDictionary new];
            if (carmodel.best_coupon.couponId) {
                [param setObject:carmodel.best_coupon.couponId forKey:@"coupon"];
            }
            for (int j = 0; j<carmodel.course_list.count; j++) {
                ShopCarCourseModel *model = carmodel.course_list[j];
                if (SWNOTEmptyStr(courseIdString)) {
                    courseIdString = [NSString stringWithFormat:@"%@,%@",courseIdString,model.courseId];
                } else {
                    courseIdString = [NSString stringWithFormat:@"%@",model.courseId];
                }
            }
            if (SWNOTEmptyStr(courseIdString)) {
                [param setObject:courseIdString forKey:@"course_ids"];
            }
            [paramArray addObject:[NSDictionary dictionaryWithDictionary:param]];
        }
    }
//    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSArray arrayWithArray:paramArray]
//                                                   options:NSJSONWritingPrettyPrinted
//                                                     error:nil];
//    NSString *string = [[NSString alloc] initWithData:data
//                                             encoding:NSUTF8StringEncoding];
    if (SWNOTEmptyArr(paramArray)) {
        [Net_API requestPOSTWithURLStr:[Net_Path shopcarOrderInfo] WithAuthorization:nil paramDic:@{@"course":paramArray} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    OrderSureViewController *vc = [[OrderSureViewController alloc] init];
                    vc.orderSureInfo = responseObject;
                    vc.orderTypeString = @"shopcar";
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourse.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShopCarModel *model = _dataSourse[section];
    return model.course_list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShopCarModel *model = _dataSourse[section];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 70)];
    head.backgroundColor = [UIColor whiteColor];
    UIView *jiange = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 9.5)];
    jiange.backgroundColor = EdlineV5_Color.fengeLineColor;
    [head addSubview:jiange];
    UILabel *jigouTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 9.5, 150, 60)];
    jigouTitle.textColor = EdlineV5_Color.textFirstColor;
    jigouTitle.text = [NSString stringWithFormat:@"%@",model.school_name];
    [head addSubview:jigouTitle];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [head addSubview:line];
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    footer.backgroundColor = [UIColor whiteColor];
    UILabel *youhui = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    youhui.text = @"卡券";
    youhui.textColor = EdlineV5_Color.textSecendColor;
    youhui.font = SYSTEMFONT(14);
    [footer addSubview:youhui];
    
    UILabel *themelabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 32 - 200, youhui.top, 200, youhui.height)];
    themelabel.font = SYSTEMFONT(14);
    themelabel.textAlignment = NSTextAlignmentRight;
    [footer addSubview:themelabel];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 7, 0, 7, 13.5)];
    icon.image = Image(@"list_more");
    icon.centerY = themelabel.centerY;
    [footer addSubview:icon];
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, youhui.top, MainScreenWidth, youhui.height)];
    clearBtn.backgroundColor = [UIColor clearColor];
    clearBtn.tag = section;
    [clearBtn addTarget:self action:@selector(kaquanClearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:clearBtn];
    
    UILabel *sectionFinalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 200 - 15, youhui.bottom, 200, 40)];
    sectionFinalPriceLabel.textColor = EdlineV5_Color.faildColor;
    sectionFinalPriceLabel.font = SYSTEMFONT(15);
    sectionFinalPriceLabel.text = @"合计: ¥0.00";
    sectionFinalPriceLabel.textAlignment = NSTextAlignmentRight;
    [footer addSubview:sectionFinalPriceLabel];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:sectionFinalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    sectionFinalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    
    CGFloat finalWidth = [sectionFinalPriceLabel.text sizeWithFont:sectionFinalPriceLabel.font].width + 4;
    
    UILabel *sectionYouhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - finalWidth - 16 - 150, 0, 150, 40)];
    sectionYouhuiLabel.text = @"优惠：¥0.00";
    sectionYouhuiLabel.font = SYSTEMFONT(13);
    sectionYouhuiLabel.textAlignment = NSTextAlignmentRight;
    sectionYouhuiLabel.textColor = EdlineV5_Color.textThirdColor;
    sectionYouhuiLabel.centerY = sectionFinalPriceLabel.centerY;
    [footer addSubview:sectionYouhuiLabel];
    
    ShopCarModel *carModel = _dataSourse[section];
    CouponModel *model = carModel.best_coupon;
    
    if (model.couponId) {
        if ([model.coupon_type isEqualToString:@"1"]) {
            themelabel.text = [NSString stringWithFormat:@"满%@减%@",model.maxprice,model.price];
            float max_price = carModel.total_price;
            if (max_price>=[model.maxprice floatValue]) {
                sectionFinalPriceLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f",carModel.total_price - [model.price floatValue]];
                sectionYouhuiLabel.text = [NSString stringWithFormat:@"优惠：¥%@",model.price];
            } else {
                themelabel.text = [NSString stringWithFormat:@"满%@减%@(不满足要求,无法使用)",model.maxprice,model.price];
                sectionFinalPriceLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f",carModel.total_price];
                sectionYouhuiLabel.text = @"优惠：¥0.00";
            }
        } else if ([model.coupon_type isEqualToString:@"2"]) {
            themelabel.text = [NSString stringWithFormat:@"%@折",model.discount];
            float discount1 = [model.discount floatValue];
            sectionFinalPriceLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f",carModel.total_price * discount1 / 10];
            sectionYouhuiLabel.text = [NSString stringWithFormat:@"优惠：¥%.2f",carModel.total_price - carModel.total_price * discount1 / 10];
        } else if ([model.coupon_type isEqualToString:@"3"]) {
            themelabel.text = @"课程卡";
        }
    } else {
        themelabel.text = @"无卡券可使用";
        sectionFinalPriceLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f",carModel.total_price];
        sectionYouhuiLabel.text = @"优惠：¥0.00";
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ShopCarCell1";
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShopCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellType:NO];
    }
    ShopCarModel *model = _dataSourse[indexPath.section];
    ShopCarCourseModel *courseModel = model.course_list[indexPath.row];
    [cell setShopCarCourseInfo:courseModel cellIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (void)getOrderShopcarInfo {
    if (SWNOTEmptyStr(_course_ids)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path shopcarOrderInfo] WithAuthorization:nil paramDic:@{@"course_ids":_course_ids} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSourse removeAllObjects];
                    [_dataSourse addObjectsFromArray:[ShopCarModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
                    [_tableView reloadData];
                }
            }
            [self setBottomViewData];
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK - 使用或者取消使用回调
- (void)chooseWhichCoupon:(CouponModel *)coupon shopCarFinalIndexPath:(NSIndexPath *)shopCarFinalIndexPath {
    if (_dataSourse.count>=(shopCarFinalIndexPath.section + 1)) {
        ShopCarModel *carModel = _dataSourse[shopCarFinalIndexPath.section];
        if (carModel.best_coupon.couponId) {
            if ([carModel.best_coupon.couponId isEqualToString:coupon.couponId]) {
                carModel.best_coupon = nil;
            } else {
                carModel.best_coupon = coupon;
            }
        } else {
            carModel.best_coupon = coupon;
        }
        [_dataSourse replaceObjectAtIndex:shopCarFinalIndexPath.section withObject:carModel];
        [_tableView reloadData];
        [self setBottomViewData];
    }
}

- (void)setBottomViewData {
    if (SWNOTEmptyArr(_dataSourse)) {
        float youhui = 0.00;
        float totalPrice = 0.00;
        for (int i = 0; i<_dataSourse.count; i++) {
            ShopCarModel *carModel = _dataSourse[i];
            CouponModel *model = carModel.best_coupon;
            
            if (model.couponId) {
                if ([model.coupon_type isEqualToString:@"1"]) {
                    float max_price = carModel.total_price;
                    if (max_price>=[model.maxprice floatValue]) {
                        youhui = youhui + model.price.floatValue;
                        totalPrice = totalPrice + (carModel.total_price - [model.price floatValue]);
                    } else {
                        youhui = youhui;
                        totalPrice = totalPrice + carModel.total_price;
                    }
                } else if ([model.coupon_type isEqualToString:@"2"]) {
                    float discount1 = [model.discount floatValue];
                    totalPrice = totalPrice + carModel.total_price * discount1 / 10;
                    youhui = youhui + (carModel.total_price - carModel.total_price * discount1 / 10);
                } else if ([model.coupon_type isEqualToString:@"3"]) {
                    // 机构没有课程卡
                }
            } else {
                youhui = youhui;
                totalPrice = totalPrice + carModel.total_price;
            }
        }
        _youhuiLabel.text = [NSString stringWithFormat:@"优惠：¥%.2f",youhui];
        _finalPriceLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f",totalPrice];
    } else {
        _youhuiLabel.text = @"优惠：¥0.00";
        
        _finalPriceLabel.text = @"合计: ¥0.00";
    }
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
}

@end
