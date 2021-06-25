//
//  CircleDetailCommentCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/31.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@class CircleDetailCommentCell;

@protocol CircleDetailCommentCellDelegate <NSObject>

@optional
- (void)replayComment:(CircleDetailCommentCell *)cell;
- (void)zanComment:(CircleDetailCommentCell *)cell;
- (void)editContent:(CircleDetailCommentCell *)cell;
- (void)deleteComment:(CircleDetailCommentCell *)cell;

- (void)showCircleDetailCommentPic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(UIImageView *)toImageView;

- (void)circleDetailCommentUserFaceTapjump:(CircleDetailCommentCell *)cell;

@end

@interface CircleDetailCommentCell : UITableViewCell<TYAttributedLabelDelegate>

@property (assign, nonatomic) id<CircleDetailCommentCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) UIView *pictureBackView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *zanCountButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *userCommentInfo;

- (void)setCommentInfo:(NSDictionary *)info circle_userId:(NSString *)circle_userId;

@end

NS_ASSUME_NONNULL_END
