//
//  NewClassCourseCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "CourseListModel.h"
#import "CourseListModelFinal.h"
#import "playAnimationView.h"
#import "NewClassCourseModel.h"
#import "CourseCatalogCell.h"

NS_ASSUME_NONNULL_BEGIN

@class NewClassCourseCell;

@protocol NewClassCourseCellDelegate <NSObject>

@optional
- (void)getCourseFirstList:(NewClassCourseCell *)cell;

@end

@interface NewClassCourseCell : UITableViewCell<CourseCatalogCellDelegate>


@property (strong, nonatomic) UIImageView *CourseTypeIcon;
@property (strong, nonatomic) UIView *blueView;
@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UIImageView *lockIcon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *freeImageView;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIImageView *courseRightBtn;
@property (strong, nonatomic) UIImageView *learnIcon;
@property (strong, nonatomic) UILabel *learnTimeLabel;
@property (strong, nonatomic) playAnimationView *isLearningIcon;
@property (strong, nonatomic) CourseListModel *treeItem;
@property (strong, nonatomic) UIView *cellTableViewSpace;
@property (assign, nonatomic) BOOL courseIsBuy;

- (void)updateItem;

- (void)setCourseInfo:(CourseListModel *)model isMainPage:(BOOL)isMainPage;

@end

NS_ASSUME_NONNULL_END
