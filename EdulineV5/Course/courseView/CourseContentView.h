//
//  CourseContentView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "StarEvaluator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseContentView : UIView

@property (strong, nonatomic) UIImageView *lianzaiIcon;
@property (strong, nonatomic) UILabel *courseTitleLabel;
@property (strong, nonatomic) UILabel *courseScore;
@property (strong, nonatomic) StarEvaluator *courseStar;
@property (strong, nonatomic) UILabel *courseLearn;
@property (strong, nonatomic) UILabel *coursePrice;
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) NSDictionary *courseInfo;

- (void)setCourseContentInfo:(NSDictionary *)contentInfo;

@end

NS_ASSUME_NONNULL_END
