//
//  LiveCourseListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LiveCourseListCellDelegate <NSObject>

@optional
- (void)jumpCourseDetailPage:(NSIndexPath *)cellIndexPath;

@end

@interface LiveCourseListCell : UITableViewCell

@property (assign, nonatomic) id<LiveCourseListCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIImageView *courseActivityIcon;
@property (strong, nonatomic) UIButton *buyButton;
@property (nonatomic, strong) NSIndexPath *cellIndex;

- (void)setLiveCourseListCellInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
