//
//  StudyCourseCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudyCourseCell : UITableViewCell

@property (strong, nonatomic) UILabel *outDateL;
@property (strong, nonatomic) UIView *outDateLineLeft;
@property (strong, nonatomic) UIView *outDateLineRight;

@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *timedate;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UIProgressView *learnProgress;

/** 内训 */
@property (strong, nonatomic) UILabel *learnStatusLabel;
 
- (void)setStudyCourseInfo:(NSDictionary *)courseInfo showOutDate:(BOOL)showOutDate isOutDate:(BOOL)isOutDate;

- (void)setJoinStudyCourseInfo:(NSDictionary *)courseInfo;

@end

NS_ASSUME_NONNULL_END
