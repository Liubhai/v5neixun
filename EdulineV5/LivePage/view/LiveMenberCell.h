//
//  LiveMenberCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LiveMenberCell;

@protocol LiveMenberCellDelegate <NSObject>

@optional
- (void)liveMenberCellButtonClick:(LiveMenberCell *)cell buttonSender:(UIButton *)sender;

@end

@interface LiveMenberCell : UITableViewCell

@property (copy, nonatomic) id<LiveMenberCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *microButton;
@property (strong, nonatomic) UIButton *camButton;
@property (strong, nonatomic) UIView *fengeLine;

- (void)setLiveMenberCellInfo:(UserModel *)user_model;

@end

NS_ASSUME_NONNULL_END
