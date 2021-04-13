//
//  QuestionAnswerReplyListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/13.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionAnswerReplyListCell : UITableViewCell<TYAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *userCommentInfo;
@property (assign, nonatomic) BOOL cellType;// 是什么身份 提问者  回答者  普通浏览者

- (void)setQuestionAnswerCommentInfo:(NSDictionary *)info showAllContent:(BOOL)showAllContent;

@end

NS_ASSUME_NONNULL_END
