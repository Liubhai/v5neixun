//
//  QuestionListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QuestionListCellDelegate <NSObject>

- (void)showPic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(UIImageView *)toImageView;

@end

@interface QuestionListCell : UITableViewCell

@property (assign, nonatomic) id<QuestionListCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *pictureViews;

@property (strong, nonatomic) UILabel *scanCountLabel;
@property (strong, nonatomic) UIView *fengeLine;
@property (strong, nonatomic) UILabel *answerCountLabel;
@property (strong, nonatomic) UILabel *xuanshangLabel;//悬赏

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *questionCellInfo;

- (void)setQuestionListCellInfo:(NSDictionary *)dict;

- (void)setQustionDetailCellInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
