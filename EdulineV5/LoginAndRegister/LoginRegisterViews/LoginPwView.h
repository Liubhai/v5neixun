//
//  LoginPwView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginPwView : UIView<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *accountIcon;
@property (strong, nonatomic) UIImageView *pwIcon;
@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *pwTextField;
@property (strong, nonatomic) UIView *line2;


@end

NS_ASSUME_NONNULL_END
