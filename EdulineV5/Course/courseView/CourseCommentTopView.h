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

@protocol CourseCommentTopViewDelegate <NSObject>

@optional
- (void)jumpToCommentVC;

@end

@interface CourseCommentTopView : UIView

@property (assign, nonatomic) id<CourseCommentTopViewDelegate> delegate;
@property (strong, nonatomic) UILabel *courseScore;
@property (strong, nonatomic) StarEvaluator *courseStar;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *showOwnButton;
@property (strong, nonatomic) UILabel *showLabel;
@property (assign, nonatomic) BOOL commentOrRecord;

/**
 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame commentOrRecord:(BOOL)commentOrRecord;


/**
 commentOrRecord: no 点评 yes 笔记
 */
- (void)setCourseCommentInfo:(NSDictionary *)info commentOrRecord:(BOOL)commentOrRecord;

@end

NS_ASSUME_NONNULL_END
