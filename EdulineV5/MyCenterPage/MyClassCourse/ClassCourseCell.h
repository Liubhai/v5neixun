//
//  ClassCourseCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ClassCourseCellDelegate <NSObject>

@optional
- (void)jumpStudentManageVC:(NSDictionary *)info;

@end

@interface ClassCourseCell : UITableViewCell

@property (assign, nonatomic) id<ClassCourseCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UIButton *manageButton;
@property (strong, nonatomic) NSDictionary *classCourseInfo;

- (void)setClassCourseInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
