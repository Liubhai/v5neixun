//
//  CourseCommentTopView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "StarEvaluator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCommentTopView : UIView

@property (strong, nonatomic) UILabel *courseScore;
@property (strong, nonatomic) StarEvaluator *courseStar;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *showOwnButton;
@property (strong, nonatomic) UILabel *showLabel;

- (void)setCourseCommentInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
