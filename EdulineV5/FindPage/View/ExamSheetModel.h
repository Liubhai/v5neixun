//
//  ExamSheetModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/29.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ExamSheetModel, ExamModel, ExamTopicModel;

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
@property (strong, nonatomic) NSString *epart_id;
@property (strong, nonatomic) NSString *topic_level;
@property (assign, nonatomic) BOOL answer_right;
@property (strong, nonatomic) NSMutableArray<ExamTopicModel *> *topics;

@end

/**
 考试结果每个部分小题的信息(材料题)
 */
@interface ExamTopicModel : NSObject

@property (strong, nonatomic) NSString *topic_id;
@property (assign, nonatomic) BOOL selected;

@end

NS_ASSUME_NONNULL_END
