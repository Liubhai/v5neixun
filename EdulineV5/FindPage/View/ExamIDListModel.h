//
//  ExamIDListModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/7.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ExamIDListModel, ExamIDModel, ExamDetailModel, ExamDetailOptionsModel, ExamPaperIDListModel;

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
@property (strong, nonatomic) NSString *score;

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
@property (strong, nonatomic) NSMutableAttributedString *titleMutable;
@property (strong, nonatomic) NSString *question_type;
@property (strong, nonatomic) NSString *analyze;
@property (strong, nonatomic) NSMutableAttributedString *analyzeMutable;
/** 【1：题干下即选项；2：题干下有小题，试题类型为材料题或完型填空】 */
@property (strong, nonatomic) NSString *topic_level;
@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) NSArray *options;
@property (assign, nonatomic) BOOL is_expand;
@property (assign, nonatomic) BOOL is_answer;// 是否已经作答
@property (assign, nonatomic) BOOL is_right;// 是否正确
@property (assign, nonatomic) BOOL collected;// 是否收藏
@property (strong, nonatomic) NSString *score;// 试题分数

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
@property (strong, nonatomic) NSMutableAttributedString *mutvalue;
@property (assign, nonatomic) BOOL is_right;
@property (assign, nonatomic) BOOL is_selected;
@property (strong, nonatomic) NSString *userAnswerValue;// 用户自己的答案 填空 解答类型


@end

/** 试卷里面题干ID列表 */
@interface ExamPaperIDListModel : NSObject

/**
 {
     "id": 257,
     "paper_id": 4,
     "number": 1,
     "title": "第一部分",
     "description": "23424234234324324234234",
     "value": [
         {
             "score": 10,
             "topic_id": 130
         }
     ]
 }
 */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *question_type;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *examPartId;
@property (strong, nonatomic) NSString *paper_id;
@property (strong, nonatomic) NSString *examPartDescription;
@property (strong, nonatomic) NSArray *child;

@end


NS_ASSUME_NONNULL_END
