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

@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UIProgressView *learnProgress;

- (void)setStudyCourseInfo:(NSDictionary *)courseInfo;

@end

NS_ASSUME_NONNULL_END
