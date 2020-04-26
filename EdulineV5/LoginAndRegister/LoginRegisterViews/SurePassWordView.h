//
//  SurePassWordView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurePassWordView : UIView

@property (strong, nonatomic) UILabel *oldPwLabel;
@property (strong, nonatomic) UITextField *oldtPwTextField;
@property (strong, nonatomic) UIView *line0;

@property (strong, nonatomic) UILabel *firstPwLabel;
@property (strong, nonatomic) UITextField *firstPwTextField;
@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UILabel *surePwLabel;
@property (strong, nonatomic) UITextField *surePwTextField;
@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *tipLabel;

@property (assign, nonatomic) BOOL isReset;

- (instancetype)initWithFrame:(CGRect)frame isReset:(BOOL)isReset;

@end

