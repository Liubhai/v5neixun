//
//  CourseCouponView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CourseCouponViewDelegate <NSObject>

@optional
- (void)jumpToCouponsVC;

@end

@interface CourseCouponView : UIView

@property (assign, nonatomic) id<CourseCouponViewDelegate> delegate;

@property (strong, nonatomic) UIImageView *couponIcon;
@property (strong, nonatomic) UIView *couponsBackView;
@property (strong, nonatomic) UILabel *couponLabel;
@property (strong, nonatomic) UIImageView *couponRightIcon;
@property (strong, nonatomic) UIView *lineView2;
@property (strong, nonatomic) UIButton *tapButton;

- (void)setCouponsListInfo:(NSArray *)couponsList;

@end

NS_ASSUME_NONNULL_END
