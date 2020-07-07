//
//  MenberRecordCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenberRecordCell : UITableViewCell

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *whiteBackView;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *openTimeLabel;
@property (strong, nonatomic) UILabel *timeLineLabel;

- (void)setMemberInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
