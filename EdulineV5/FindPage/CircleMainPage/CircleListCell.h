//
//  CircleListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "V5_UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CircleListCell;

@protocol CircleListCellDelegate <NSObject>

@optional
- (void)showCirclePic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(UIImageView *)toImageView;

- (void)followUser:(CircleListCell *)cell;
- (void)likeCircleClick:(CircleListCell *)cell;
- (void)shareCircleClick:(CircleListCell *)cell;
- (void)deleteCircleClick:(CircleListCell *)cell;

- (void)goToUserHomePage:(CircleListCell *)cell;
- (void)jumpToForwarOriginCircleDetailVC:(CircleListCell *)cell;

@end

@interface CircleListCell : UITableViewCell<TYAttributedLabelDelegate>

@property (assign, nonatomic) id<CircleListCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *guanzhuButton;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) UIView *pictureBackView;

// 转发信息板块儿视图(产品说的是整个板块儿点击 跳转到原动态详情页)
@property (strong, nonatomic) UIView *forwardBackView;
@property (strong, nonatomic) TYAttributedLabel *forwardContentLabel;
@property (strong, nonatomic) UIView *forwardPictureBackView;

@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *commentCountButton;
@property (strong, nonatomic) UIButton *zanCountButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *userCommentInfo;

- (void)setCircleCellInfo:(NSDictionary *)dict circleType:(NSString *)circleType isDetail:(BOOL)isDetail;

@end

NS_ASSUME_NONNULL_END
