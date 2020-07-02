//
//  ZixunCommentCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarEvaluator.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@class ZixunCommentCell;

@protocol ZixunCommentCellDelegate <NSObject>

@optional
- (void)replayComment:(ZixunCommentCell *)cell;
- (void)zanComment:(ZixunCommentCell *)cell;
- (void)editContent:(ZixunCommentCell *)cell;

@end

@interface ZixunCommentCell : UITableViewCell<TYAttributedLabelDelegate>

@property (assign, nonatomic) id<ZixunCommentCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) StarEvaluator *scoreStar;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) YYLabel *tokenLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *commentCountButton;
@property (strong, nonatomic) UIButton *zanCountButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *userCommentInfo;

@property (assign, nonatomic) BOOL cellType;// yes 是笔记 no 是点评
@property (assign, nonatomic) BOOL commentOrReplay;// yes 回复 no 是点评

- (void)setCommentInfo:(NSDictionary *)info showAllContent:(BOOL)showAllContent;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BOOL)cellType;

- (void)changeZanButtonInfo:(NSString *)zanCount zanOrNot:(BOOL)zanOrNot;

@end

NS_ASSUME_NONNULL_END
