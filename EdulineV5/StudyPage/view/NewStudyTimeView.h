//
//  NewStudyTimeView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewStudyTimeView : UIView

@property (strong, nonatomic) UIView *whiteView;

@property (strong, nonatomic) UIImageView *studyIcon;

@property (strong, nonatomic) UILabel *courseCount;
@property (strong, nonatomic) UILabel *courseLabel;

@property (strong, nonatomic) UILabel *planCount;
@property (strong, nonatomic) UILabel *planLabel;

@property (strong, nonatomic) UILabel *certificateCount;
@property (strong, nonatomic) UILabel *certificateLabel;

@property (strong, nonatomic) UILabel *todayLearnTime;
@property (strong, nonatomic) UILabel *todayLearn;

@property (strong, nonatomic) UILabel *continuousLearnTime;
@property (strong, nonatomic) UILabel *continuousLearn;

@property (strong, nonatomic) UILabel *allLearnTime;
@property (strong, nonatomic) UILabel *allLearn;

- (void)newStudyPageTimeInfo:(NSDictionary *)timeInfo;

@end

NS_ASSUME_NONNULL_END
