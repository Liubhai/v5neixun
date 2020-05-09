//
//  MyCenterBalanceView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCenterBalanceViewDelegate <NSObject>

@optional
- (void)jumpToOtherVC:(UIButton *)sender;

@end

@interface MyCenterBalanceView : UIView

@property (weak, nonatomic) id<MyCenterBalanceViewDelegate> delegate;

@property (strong, nonatomic) UILabel *balanceTitleLabel;
@property (strong, nonatomic) UILabel *balanceLabel;
@property (strong, nonatomic) UILabel *incomeTitleLabel;
@property (strong, nonatomic) UILabel *incomeLabel;
@property (strong, nonatomic) UILabel *scoreTitleLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
//@property (strong, nonatomic) UILabel *shopCarTitleLabel;
//@property (strong, nonatomic) UILabel *shopCarLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setBalanceInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
