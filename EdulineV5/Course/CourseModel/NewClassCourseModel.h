//
//  NewClassCourseModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseListModelFinal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewClassCourseModel : NSObject

/**
 "course_id": 1,
 "course_type": 1,
 "course_type_text": "点播",
 "title": "点播课程1级",
 "teacher_id": 1
 */

@property (strong, nonatomic) NSString *course_id;
@property (strong, nonatomic) NSString *course_type;
@property (strong, nonatomic) NSString *course_type_text;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *teacher_id;
@property (assign, nonatomic) BOOL isExpanded;
@property (assign, nonatomic) CourseListModelFinal *finalModel;

@end

NS_ASSUME_NONNULL_END
