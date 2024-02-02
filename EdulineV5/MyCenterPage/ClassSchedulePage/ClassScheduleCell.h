//
//  ClassScheduleCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/20.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassScheduleCell : UITableViewCell

@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UIImageView *liveIcon;
@property (strong, nonatomic) UILabel *fromLabel;

@property (strong, nonatomic) UIImageView *liveingIcon;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *hourseLabel;
@property (strong, nonatomic) UILabel *teacherName;

- (void)setClassScheduleCellInfo:(NSDictionary *)dict isTeacher:(BOOL)isTeacher;

@end

NS_ASSUME_NONNULL_END
