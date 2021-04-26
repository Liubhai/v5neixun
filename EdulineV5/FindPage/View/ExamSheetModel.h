//
//  ExamSheetModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/29.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamIDListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ExamSheetModel, ExamModel, ExamTopicModel, ExamResultDetailModel;

/**
 {
     "id": 316,
     "title": "第一部分",
     "value": [
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 26,
             "topic_level": 1,
             "answer_right": 1
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 3,
             "topic_level": 1,
             "answer_right": 0
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 4,
             "topic_level": 1,
             "answer_right": 0
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 6,
             "topic_level": 1,
             "answer_right": 1
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 7,
             "topic_level": 1,
             "answer_right": 1
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 10,
             "topic_level": 2,
             "topics": [
                 {
                     "topic_id": 5,
                     "answer_right": 0
                 },
                 {
                     "topic_id": 4,
                     "answer_right": 1
                 }
             ]
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 12,
             "topic_level": 2,
             "topics": [
                 {
                     "topic_id": 3,
                     "answer_right": 1
                 }
             ]
         },
         {
             "epar_id": 1,
             "epart_id": 316,
             "topic_id": 13,
             "topic_level": 1,
             "answer_right": 0
         }
     ],
     "number": 1,
     "paper_id": 1,
     "description": "固定卷第一部分"
 }
 */

/**
 整个试卷所有部分信息
 */
@interface ExamSheetModel : NSObject

@property (strong, nonatomic) NSString *question_type;
@property (strong, nonatomic) NSString *section_id;// 部分ID
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *paper_id;
@property (strong, nonatomic) NSString *section_description;
@property (strong, nonatomic) NSMutableArray<ExamModel *> *child;

@end

/**
 考试结果每个部分的信息
 */
@interface ExamModel : NSObject

@property (strong, nonatomic) NSString *topic_id;
@property (strong, nonatomic) NSString *epar_id;
@property (strong, nonatomic) NSString *part_id;
@property (strong, nonatomic) NSString *topic_level;
@property (strong, nonatomic) NSString *unique_code;
@property (assign, nonatomic) BOOL answer_right;
@property (assign, nonatomic) BOOL has_answered;
@property (strong, nonatomic) NSMutableArray<ExamTopicModel *> *topics;

@end

/**
 考试结果每个部分小题的信息(材料题)
 */
@interface ExamTopicModel : NSObject

@property (strong, nonatomic) NSString *topic_id;
@property (assign, nonatomic) BOOL selected;

@end

/**
 "id": 1,
 "paper_id": 1,
 "unique_code": "6883c67c6babe7bd94ef51d8e857624d",
 "paper_parts":
 "answer_times": 1,
 "time_takes": 1100,
 "commit_time": 1618995747,
 "answer_status": 1,
 "paper_score": 16,
 "user_score": 0,
 "paper_title": "第一套试卷",
 "total_count": 8
 */
/**
 考试结果解析
 */
@interface ExamResultDetailModel : NSObject

@property (strong, nonatomic) NSString *examResultId;
@property (strong, nonatomic) NSString *paper_id;
@property (strong, nonatomic) NSString *unique_code;
@property (strong, nonatomic) NSString *answer_times;
@property (strong, nonatomic) NSString *time_takes;
@property (strong, nonatomic) NSString *commit_time;
@property (strong, nonatomic) NSString *answer_status;
@property (strong, nonatomic) NSString *paper_score;
@property (strong, nonatomic) NSString *user_score;
@property (strong, nonatomic) NSString *paper_title;
@property (strong, nonatomic) NSString *total_count;
@property (strong, nonatomic) NSArray *paper_parts;

@end

/** 考试结果试题解析每道大题的信息 */
@interface ExamResultPaperTestDetailModel : NSObject

@property (strong, nonatomic) ExamModel *next;
@property (strong, nonatomic) ExamModel *prev;
@property (strong, nonatomic) ExamDetailModel *topic;

@end

NS_ASSUME_NONNULL_END
