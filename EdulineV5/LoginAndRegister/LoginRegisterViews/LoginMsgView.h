//
//  LoginMsgView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol LoginMsgViewDelegate <NSObject>

- (void)jumpAreaNumList;

@end

@interface LoginMsgView : UIView

@property (assign, nonatomic) id<LoginMsgViewDelegate> delegate;
@property (strong, nonatomic) UILabel *areaNumLabel;
@property (strong, nonatomic) UIImageView *jiantouImage;
@property (strong, nonatomic) UIButton *areaBtn;
@property (strong, nonatomic) UITextField *phoneNumTextField;
@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UILabel *yanzhengCode;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UIButton *senderCodeBtn;
@property (strong, nonatomic) UIView *line2;

- (void)setAreaNumLabelText:(NSString *)num;

@end

NS_ASSUME_NONNULL_END
