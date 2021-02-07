//
//  ExamIDListModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/7.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ExamIDListModel, ExamIDModel, ExamDetailModel, ExamDetailOptionsModel;

@interface ExamIDListModel : NSObject

/**
 {
     "title": "单选",
     "question_type": 1,
     "num": 1,
     "data": [
         {
             "topic_id": 2,
             "has_answered": 1
         }
     ]
 }
 */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *question_type;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSArray *child;

@end

@interface ExamIDModel : NSObject

/**
 {
     "topic_id": 2,
     "has_answered": 1
 }
 */
@property (strong, nonatomic) NSString *topic_id;
@property (assign, nonatomic) BOOL has_answered;

@end

@interface ExamDetailModel : NSObject

/**
 "id": 12,
 "title": "<p>完形填空</p>",
 "question_type": 7,
 "analyze": "<p>填空题填空题填空题填空题填空题填空题</p>",
 "topic_level": 2,
 "topics": [
     {
         "id": 3,
         "title": "电饭锅第三个水电费",
         "question_type": 1,
         "analyze": "<p>完型填空完型填空完型填空</p>",
         "options": [
             {
                 "id": 21,
                 "key": "A",
                 "value": "<p>选项A</p>",
                 "is_right": 1
             },
 */
@property (strong, nonatomic) NSString *examDetailId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *question_type;
@property (strong, nonatomic) NSString *analyze;
/** 【1：题干下即选项；2：题干下有小题，试题类型为材料题或完型填空】 */
@property (strong, nonatomic) NSString *topic_level;
@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) NSArray *options;

@end

@interface ExamDetailOptionsModel : NSObject

/**
 {
     "id": 21,
     "key": "A",
     "value": "<p>选项A</p>",
     "is_right": 1
 },
 */
@property (strong, nonatomic) NSString *examDetailOptionId;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (assign, nonatomic) BOOL is_right;

@end


NS_ASSUME_NONNULL_END
