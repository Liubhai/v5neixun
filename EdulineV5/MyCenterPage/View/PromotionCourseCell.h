//
//  PromotionCourseCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromotionCourseCell : UITableViewCell

@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *promotionIncome;

- (void)setPromotionCourseCellInfo:(NSDictionary *)promotionInfo;

@end

NS_ASSUME_NONNULL_END
