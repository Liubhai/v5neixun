//
//  LingquanViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/31.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponModel.h"

@protocol LingquanViewControllerDelegate <NSObject>

@optional
- (void)chooseWhichCoupon:(CouponModel *)coupon;

@end

@interface LingquanViewController : BaseViewController

@property (weak, nonatomic) id<LingquanViewControllerDelegate> delegate;

@property (strong, nonatomic) CouponModel *couponModel;
@property (strong, nonatomic) NSString *mhm_id;//机构id

@property (assign, nonatomic) BOOL getOrUse; //yes 领取 no 使用

@end
