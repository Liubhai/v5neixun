//
//  CCClassCodeView.h
//  CCClassRoom
//
//  Created by 刘强强 on 2021/6/25.
//  Copyright © 2021 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRoomDecModel.h"
#import "TextFieldUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CCClassCodeViewDelegate <NSObject>

@optional
- (void)getRoomIdAndDesc:(NSString *)classNo;
- (void)classCodeViewEditEndUpdateLogin:(BOOL)canLogin;
///YES 标识横屏
- (void)landSpaceSelect:(BOOL)isLandSpace;

@end

@interface CCClassCodeView : UIView
@property(nonatomic, weak)id<CCClassCodeViewDelegate> delegate;
@property (strong, nonatomic) TextFieldUserInfo *userNameTF;
@property (strong, nonatomic) TextFieldUserInfo *passWordTF;
@property (strong, nonatomic) TextFieldUserInfo *classCodeTF;
- (void)updateView:(CCRoomDecModel *)model;
- (void)scrollerViewUpdate;

- (void)reloadLanguage;
@end

NS_ASSUME_NONNULL_END
