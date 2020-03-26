//
//  OrderViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderViewController : BaseViewController<UIScrollViewDelegate,TYAttributedLabelDelegate>

@property (strong, nonatomic) NSDictionary *orderInfo;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong,nonatomic) UIView *topContentView;
@property (strong,nonatomic) UIImageView *courseFaceImageView;
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

@property (strong, nonatomic) UIView *agreeBackView;
@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;
@property (strong, nonatomic) UIButton *seleteBtn;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *youhuiLabel;
@property (strong, nonatomic) UILabel *finalPriceLabel;
@property (strong, nonatomic) UIButton *submitButton;

@end

NS_ASSUME_NONNULL_END
