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

@interface CourseCommentCell : UITableViewCell

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) StarEvaluator *scoreStar;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *commentCountButton;
@property (strong, nonatomic) UIButton *zanCountButton;
@property (strong, nonatomic) UIView *lineView;

- (void)setCommentInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
