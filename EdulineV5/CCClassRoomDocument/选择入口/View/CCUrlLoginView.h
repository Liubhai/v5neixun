//
//  CCUrlLoginView.h
//  CCClassRoom
//
//  Created by 刘强强 on 2021/6/25.
//  Copyright © 2021 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CCUrlLoginViewDelegate <NSObject>

@optional
- (void)urlPathEditUpdateLogin:(BOOL)canLogin;

@end

@interface CCUrlLoginView : UIView

@property(nonatomic, weak)id<CCUrlLoginViewDelegate> delegate;

@property (strong, nonatomic) TextFieldUserInfo *textFieldUserName;

- (void)scrollerViewUpdate;

- (void)reloadLanguage;
@end

NS_ASSUME_NONNULL_END
