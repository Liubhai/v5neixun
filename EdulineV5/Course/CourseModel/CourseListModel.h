//
//  CourseListModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CourseListModel,section_data_model;

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
@property (strong, nonatomic) section_data_model *section_data;


@end

@interface section_data_model : NSObject
/*
"id": 2,
"title": "视频课件1",
"uid": 1,
"attach_id": 15,
"status": 1,
"data_type": 1,
"data_type_text": "视频",
"fileurl": "http://eduline-t.oss-cn-shenzhen.aliyuncs.com/upload/20200403/397f6d579183329d921b683f4016ae43.mp4?OSSAccessKeyId=LTAI4FcRKUNNtncbdrPXNsar&Expires=1588982304&Signature=g8kLTQX78PQElpRRXCT6dApiXQc%3D"
*/

@property (strong, nonatomic) NSString *fileId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *attach_id;
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSString *data_type;
@property (strong, nonatomic) NSString *data_type_text;
@property (strong, nonatomic) NSString *fileurl;

@end

NS_ASSUME_NONNULL_END
