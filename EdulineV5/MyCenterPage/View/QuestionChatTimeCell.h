//
//  QuestionChatTimeCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionChatTimeCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;

- (void)setTimeInfo:(NSString *)timeString;

@end

NS_ASSUME_NONNULL_END
