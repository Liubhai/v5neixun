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

@protocol CourseContentViewDelegate <NSObject>

@optional
- (void)popToCourseDetailVC;

@end

@interface CourseContentView : UIView

@property (assign, nonatomic) id<CourseContentViewDelegate> delegate;

@property (strong, nonatomic) UIImageView *lianzaiIcon;
@property (strong, nonatomic) UILabel *courseTitleLabel;
@property (strong, nonatomic) UILabel *courseScore;
@property (strong, nonatomic) StarEvaluator *courseStar;
@property (strong, nonatomic) UILabel *courseLearn;
@property (strong, nonatomic) UILabel *coursePrice;
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) UILabel *sectionCountLabel;
@property (strong, nonatomic) NSDictionary *courseInfo;

- (void)setCourseContentInfo:(NSDictionary *)contentInfo showTitleOnly:(BOOL)showTitleOnly;

@end

NS_ASSUME_NONNULL_END
