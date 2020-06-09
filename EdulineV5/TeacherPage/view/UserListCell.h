//
//  UserListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserListCellDelegate <NSObject>

@optional
- (void)followAndUnFollow:(UIButton *)sender;

@end

@interface UserListCell : UITableViewCell

@property (weak, nonatomic) id<UserListCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *followButton;

- (void)setUserInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
