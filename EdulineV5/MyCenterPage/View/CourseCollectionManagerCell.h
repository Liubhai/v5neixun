//
//  CourseCollectionManagerCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CourseCollectionManagerCell;

@protocol CourseCollectionManagerCellDelegate <NSObject>

@optional
- (void)courseManagerSelectButtonClick:(CourseCollectionManagerCell *)cell;

@end

@interface CourseCollectionManagerCell : UITableViewCell

@property (weak, nonatomic) id<CourseCollectionManagerCellDelegate> delegate;
@property (strong, nonatomic) UIButton *selectedIconBtn;
@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIImageView *courseActivityIcon;
@property (assign, nonatomic) BOOL cellType;
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (strong, nonatomic) ShopCarCourseModel *courseModel;


- (void)setCourseCollectionManagerModel:(ShopCarCourseModel *)model;

@end

NS_ASSUME_NONNULL_END
