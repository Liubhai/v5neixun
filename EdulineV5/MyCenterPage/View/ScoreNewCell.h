//
//  ScoreNewCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/24.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreNewCell : UITableViewCell

@property (strong, nonatomic) UILabel *scoreTitle;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *scoreCountLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setScoreInfo:(NSDictionary *)dict isCredit:(BOOL)isCredit;

@end

NS_ASSUME_NONNULL_END
