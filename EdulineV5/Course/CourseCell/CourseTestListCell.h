//
//  CourseTestListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseTestListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *testTitle;
@property (strong, nonatomic) UIView *lineView;

- (void)setCourseTestCellInfoData:(NSDictionary *)dict course_can_exam:(BOOL)courseCanExam;

@end

NS_ASSUME_NONNULL_END
