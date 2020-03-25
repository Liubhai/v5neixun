//
//  CourseCommentCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "StarEvaluator.h"

NS_ASSUME_NONNULL_BEGIN

@class CourseCommentCell;

@protocol CourseCommentCellDelegate <NSObject>

@optional
- (void)replayComment:(CourseCommentCell *)cell;
- (void)zanComment:(CourseCommentCell *)cell;

@end

@interface CourseCommentCell : UITableViewCell

@property (assign, nonatomic) id<CourseCommentCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) StarEvaluator *scoreStar;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) YYLabel *tokenLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *commentCountButton;
@property (strong, nonatomic) UIButton *zanCountButton;
@property (strong, nonatomic) UIView *lineView;

@property (assign, nonatomic) BOOL cellType;// yes 是笔记 no 是点评

- (void)setCommentInfo:(NSDictionary *)info;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BOOL)cellType;

@end

NS_ASSUME_NONNULL_END
