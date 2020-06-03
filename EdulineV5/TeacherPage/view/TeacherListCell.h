//
//  TeacherListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setTeacherListInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END