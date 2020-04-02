//
//  CourseListModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CourseListModel;

@interface CourseListModel : NSObject

/**
 "id": 3,
 "name": "测试课时1-2",
 "pid": 1,
 "course_id": 1,
 "is_charge": 1,
 "price": "0.00",
 "status": 1,
 "level": 2,
 "child": []
 //
 {
     "course_id" = 1;
     "has_child" = 1;
     id = 1;
     "is_charge" = 1;
     name = "\U6d4b\U8bd5\U7ae0\U82821";
     pid = 0;
     price = "0.00";
     status = 1;
 }
 */

@property (strong, nonatomic) NSString *classHourId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *course_id;
@property (assign, nonatomic) BOOL is_charge;
@property (strong, nonatomic) NSString *price;
@property (assign, nonatomic) BOOL status;
@property (assign, nonatomic) BOOL has_child;

@end

NS_ASSUME_NONNULL_END
