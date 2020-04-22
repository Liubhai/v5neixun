//
//  HomePageCourseTypeOneCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageCourseTypeOneCell : UITableViewCell

@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIImageView *courseActivityIcon;
@property (assign, nonatomic) BOOL cellType;
@property (nonatomic, strong) NSIndexPath *cellIndex;

- (void)setHomePageCourseTypeOneCellInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END