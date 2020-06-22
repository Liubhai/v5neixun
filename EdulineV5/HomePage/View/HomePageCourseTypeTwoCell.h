//
//  HomePageCourseTypeTwoCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageCourseTypeTwoCellDelegate <NSObject>

@optional
- (void)categoryCourseTapJump:(NSDictionary *)courseInfo;

@end

@interface HomePageCourseTypeTwoCell : UITableViewCell

//@property (strong, nonatomic) UIImageView *courseFace;
//@property (strong, nonatomic) UIImageView *courseTypeImage;
//@property (strong, nonatomic) UILabel *titleL;
//@property (strong, nonatomic) UILabel *learnCountLabel;
//@property (strong, nonatomic) UILabel *priceLabel;
//@property (strong, nonatomic) UIImageView *courseActivityIcon;
//@property (assign, nonatomic) BOOL cellType;
//@property (nonatomic, strong) NSIndexPath *cellIndex;

@property (weak, nonatomic) id<HomePageCourseTypeTwoCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *categoryCourseArray;

- (void)setHomePageCourseTypeTwoCellInfo:(NSMutableArray *)infoArray;

@end

NS_ASSUME_NONNULL_END
