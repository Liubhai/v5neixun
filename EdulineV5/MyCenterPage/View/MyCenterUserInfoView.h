//
//  MyCenterUserInfoView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCenterUserInfoViewDelegate <NSObject>

@optional
- (void)goToUserInfoVC;
- (void)goToSetingVC;

@end

@interface MyCenterUserInfoView : UIView

@property (weak, nonatomic) id<MyCenterUserInfoViewDelegate> delegate;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIButton *setBtn;
@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) UIImageView *userFaceImageView;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UIImageView *menberImageView;
@property (strong, nonatomic) UIButton *menberBtn;

- (void)setUserInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
