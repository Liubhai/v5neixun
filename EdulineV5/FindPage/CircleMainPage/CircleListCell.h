//
//  CircleListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@class CircleListCell;

@protocol CircleListCellDelegate <NSObject>

- (void)showCirclePic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(UIImageView *)toImageView;

- (void)likeCircleClick:(CircleListCell *)cell;

@end

@interface CircleListCell : UITableViewCell<TYAttributedLabelDelegate>

@property (assign, nonatomic) id<CircleListCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *guanzhuButton;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) UIView *pictureBackView;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *commentCountButton;
@property (strong, nonatomic) UIButton *zanCountButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *userCommentInfo;

- (void)setCircleCellInfo:(NSDictionary *)dict circleType:(NSString *)circleType;

@end

NS_ASSUME_NONNULL_END
