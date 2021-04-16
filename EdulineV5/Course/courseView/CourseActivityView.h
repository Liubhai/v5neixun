//
//  CourseActivityView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseActivityView : UIView

@property (strong, nonatomic) UIImageView *backIconImage;

@property (strong, nonatomic) UILabel *groupSellPriceLabel;
@property (strong, nonatomic) UILabel *groupOriginPriceLabel;
@property (strong, nonatomic) UILabel *groupTimeTipLabel;

// 倒计时UI
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *hourLabel;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *minuteLabel;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *secondLabel;

- (void)setActivityInfo:(NSDictionary *)activityInfo;

@end

NS_ASSUME_NONNULL_END
