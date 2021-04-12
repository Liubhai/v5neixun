//
//  QuestionAnswerCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QuestionAnswerCellDelegate <NSObject>

- (void)questionDetailCellPicTap:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(UIImageView *)toImageView;

@end

@interface QuestionAnswerCell : UITableViewCell

@property (assign, nonatomic) id<QuestionAnswerCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIView *bestBack;
@property (strong, nonatomic) UIImageView *bestIcon;
@property (strong, nonatomic) UILabel *bestLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIButton *seeButton;

@property (strong, nonatomic) UIView *pictureViews;

@property (strong, nonatomic) UIImageView *replyIcon;
@property (strong, nonatomic) UILabel *replyCountLabel;
@property (strong, nonatomic) UIImageView *zanIcon;
@property (strong, nonatomic) UILabel *zanCountLabel;

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *questionAnswerCellInfo;

- (void)setQuestionAnswerListCellInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
