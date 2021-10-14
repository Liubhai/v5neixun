//
//  CourseMakeNoteVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/10/13.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseMakeNoteVC : BaseViewController

@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSDictionary *originCommentInfo;

@property (strong, nonatomic) NSString *courseHourseId;// 课时id
@property (strong, nonatomic) NSString *courseType;

@end

NS_ASSUME_NONNULL_END
