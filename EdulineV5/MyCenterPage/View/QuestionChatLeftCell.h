//
//  QuestionChatLeftCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionChatLeftCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *contentBackView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, copy) MessageInfoModel *messageModel;

- (void)setQuestionChatLeftInfo:(NSDictionary *)info;
- (void)setQuestionChatLeftModel:(MessageInfoModel *)info;

@end

NS_ASSUME_NONNULL_END
