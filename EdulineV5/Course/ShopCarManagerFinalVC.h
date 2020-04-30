//
//  ShopCarManagerFinalVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "TYAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCarManagerFinalVC : BaseViewController<TYAttributedLabelDelegate>

@property (strong, nonatomic) NSString *course_ids;//课程ID拼接 ,

@property (strong, nonatomic) UIView *footerView;
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
