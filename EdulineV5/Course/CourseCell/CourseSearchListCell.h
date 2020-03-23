//
//  CourseSearchListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseSearchListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIImageView *courseActivityIcon;
@property (assign, nonatomic) BOOL cellType;
@property (nonatomic, strong) NSIndexPath *cellIndex;

- (void)setCourseListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex cellType:(BOOL)cellType;

@end

NS_ASSUME_NONNULL_END
