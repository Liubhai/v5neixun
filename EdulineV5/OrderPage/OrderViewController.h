//
//  OrderViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderViewController : BaseViewController<UIScrollViewDelegate,TYAttributedLabelDelegate>

@property (strong, nonatomic) NSDictionary *orderInfo;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong,nonatomic) UIView *topContentView;
@property (strong,nonatomic) UIImageView *courseFaceImageView;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UIImageView *courseActivityIcon;

@property (strong,nonatomic) UILabel *textLabel;
@property (strong,nonatomic) UILabel *courseHourLabel;
@property (strong,nonatomic) UILabel *priceLabel;
@property (strong,nonatomic) UILabel *timeLabel;

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

@property (strong, nonatomic) UIView *otherView;

@property (strong, nonatomic) UILabel *kaquanLabel;
@property (strong, nonatomic) UILabel *shitikaLabel;

@property (strong, nonatomic) UIView *scoreOtherView;
@property (strong, nonatomic) UILabel *scoreLabel;

@property (strong, nonatomic) UIView *agreeBackView;
@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;
@property (strong, nonatomic) UIButton *seleteBtn;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *youhuiLabel;
@property (strong, nonatomic) UILabel *finalPriceLabel;
@property (strong, nonatomic) UIButton *submitButton;


@property (strong, nonatomic) NSString *orderTypeString;
@property (strong, nonatomic) NSString *orderId;

/** 公开考试ID */
@property (strong, nonatomic) NSString *publicExamId;


@property (strong, nonatomic) CouponModel *couponModel;

@property (assign, nonatomic) BOOL ignoreActivity;// 是不是不顾活动 按照正常购买显示

@property (assign, nonatomic) BOOL isTuanGou;// 是不是团购(团购只需要调用开团拼团前接口就获取到订单信息)

@property (strong, nonatomic) NSString *promotion_id;

@end

NS_ASSUME_NONNULL_END
