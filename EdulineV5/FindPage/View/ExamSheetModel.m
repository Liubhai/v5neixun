//
//  ExamSheetModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/29.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamSheetModel.h"
#import "V5_Constant.h"

@implementation ExamSheetModel

/**
 @property (strong, nonatomic) NSString *question_type;
 @property (strong, nonatomic) NSString *section_id;// 部分ID
 @property (strong, nonatomic) NSString *title;
 @property (strong, nonatomic) NSString *number;
 @property (strong, nonatomic) NSString *paper_id;
 @property (strong, nonatomic) NSString *section_description;
 @property (strong, nonatomic) NSMutableArray<ExamModel *> *child;
 */

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"section_id":@"id",@"child":@"value",@"section_description":@"description"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"ExamModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"question_type"] || [property.name isEqualToString:@"section_id"] || [property.name isEqualToString:@"title"] || [property.name isEqualToString:@"number"] || [property.name isEqualToString:@"paper_id"] || [property.name isEqualToString:@"section_description"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"child"] || [property.name isEqualToString:@"value"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end


@implementation ExamModel

/**
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
 */

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"epar_id"] || [property.name isEqualToString:@"epart_id"] || [property.name isEqualToString:@"topic_id"] || [property.name isEqualToString:@"topic_level"] || [property.name isEqualToString:@"unique_code"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"topics"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamTopicModel

/**
 "topic_id": 3,
 "answer_right": 1
 */

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"topic_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end

@implementation ExamResultDetailModel

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

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"examResultId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"paper_parts":@"ExamSheetModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"paper_id"] || [property.name isEqualToString:@"unique_code"] || [property.name isEqualToString:@"answer_times"] || [property.name isEqualToString:@"time_takes"] || [property.name isEqualToString:@"commit_time"] || [property.name isEqualToString:@"answer_status"] || [property.name isEqualToString:@"paper_score"] || [property.name isEqualToString:@"user_score"] || [property.name isEqualToString:@"paper_title"] || [property.name isEqualToString:@"total_count"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"paper_parts"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamResultPaperTestDetailModel

@end
