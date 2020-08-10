//
//  CommentBaseView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/18.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@class CommentBaseView;

@protocol CommentBaseViewDelegate <NSObject>

@optional
- (void)sendReplayMsg:(CommentBaseView *)view;
- (void)judgeLogin;

@end

@interface CommentBaseView : UIView<UITextViewDelegate>

@property (assign, nonatomic) id<CommentBaseViewDelegate> delegate;
@property (strong, nonatomic) UILabel *placeHoderLab;
@property (strong, nonatomic) UITextView *inputTextView;

@end

NS_ASSUME_NONNULL_END
