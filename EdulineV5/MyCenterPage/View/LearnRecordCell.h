//
//  LearnRecordCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LearnRecordCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *dianView;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *courseTitle;
@property (strong, nonatomic) UILabel *courseHourseTitle;
@property (strong, nonatomic) UILabel *learnTime;

- (void)setLearnRecordInfo:(NSDictionary *)recordInfo;

@end

NS_ASSUME_NONNULL_END
