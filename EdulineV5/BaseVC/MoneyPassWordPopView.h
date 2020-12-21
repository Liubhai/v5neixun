//
//  MoneyPassWordPopView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/21.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPasswordTextView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MoneyPassWordPopViewDelegate <NSObject>

@optional
- (void)getMoneyPasWordString:(NSString *)pw;
- (void)jumpSetPwPage;

@end

@interface MoneyPassWordPopView : UIView

@property (strong, nonatomic) id<MoneyPassWordPopViewDelegate> delegate;

@property (strong, nonatomic) UIView *whiteBackView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *forgetBtn;
@property (nonatomic, strong) SHPasswordTextView *passwordTextView;

@end

NS_ASSUME_NONNULL_END
