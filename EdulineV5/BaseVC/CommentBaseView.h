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
- (void)commentLeftButtonClick:(CommentBaseView *)view sender:(UIButton *)sender;

@end

@interface CommentBaseView : UIView<UITextViewDelegate>

@property (assign, nonatomic) id<CommentBaseViewDelegate> delegate;
@property (strong, nonatomic) UILabel *placeHoderLab;
@property (strong, nonatomic) UITextView *inputTextView;
@property (strong, nonatomic) UIButton *giftButton;// 打赏按钮
@property (strong, nonatomic) UIButton *goodsButton;// 直播带货按钮
@property (strong, nonatomic) UIButton *sendButton;// 发送按钮
@property (strong, nonatomic) NSArray *leftButtonImageArray;// 左边按钮的图片集
@property (strong, nonatomic) NSString *sendButtonTitle;// 发送按钮文字
@property (strong, nonatomic) NSString *placeHolderTitle;//

- (instancetype)initWithFrame:(CGRect)frame leftButtonImageArray:(nullable NSArray *)leftButtonImageArray placeHolderTitle:(nullable NSString *)placeHolderTitle sendButtonTitle:(nullable NSString *)sendButtonTitle;

@end

NS_ASSUME_NONNULL_END
