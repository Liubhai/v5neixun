//
//  StudyTimeCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudyTimeCell : UITableViewCell

@property (strong, nonatomic) UIView *whiteView;

@property (strong, nonatomic) UIImageView *studyIcon;

@property (strong, nonatomic) UILabel *todayLearnTime;
@property (strong, nonatomic) UILabel *todayLearn;

@property (strong, nonatomic) UILabel *continuousLearnTime;
@property (strong, nonatomic) UILabel *continuousLearn;

@property (strong, nonatomic) UILabel *allLearnTime;
@property (strong, nonatomic) UILabel *allLearn;

@end

NS_ASSUME_NONNULL_END
