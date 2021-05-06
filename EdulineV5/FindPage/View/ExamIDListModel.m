//
//  ExamIDListModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/7.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamIDListModel.h"
#import "V5_Constant.h"

@implementation ExamIDListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"child":@"data"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"ExamIDModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"title"] || [property.name isEqualToString:@"question_type"] || [property.name isEqualToString:@"num"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"child"] || [property.name isEqualToString:@"data"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamIDModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"sub_topics":@"ExamIDModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"topic_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }else if ([property.name isEqualToString:@"sub_topics"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamDetailModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"examDetailId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"topics":@"ExamDetailModel",@"options":@"ExamDetailOptionsModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"title"] || [property.name isEqualToString:@"question_type"] || [property.name isEqualToString:@"id"] || [property.name isEqualToString:@"analyze"] || [property.name isEqualToString:@"topic_level"] || [property.name isEqualToString:@"next_topic_id"] || [property.name isEqualToString:@"examAnswer"] || [property.name isEqualToString:@"reference_answer"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"options"] || [property.name isEqualToString:@"topics"] || [property.name isEqualToString:@"answer_data"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamDetailOptionsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"examDetailOptionId":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"key"] || [property.name isEqualToString:@"id"] || [property.name isEqualToString:@"examDetailOptionId"] || [property.name isEqualToString:@"value"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"values"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamPaperDetailModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"paper_id":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"parts":@"ExamPaperIDListModel"};
}

/**
 @property (strong, nonatomic) NSString *paper_id;//id
 @property (strong, nonatomic) NSString *mhm_id;
 @property (strong, nonatomic) NSString *title;
 @property (strong, nonatomic) NSString *info;
 @property (strong, nonatomic) NSString *cate;
 @property (strong, nonatomic) NSString *paper_type;
 @property (strong, nonatomic) NSString *question_rand;
 @property (strong, nonatomic) NSString *answer_options_rand;
 @property (strong, nonatomic) NSString *start_time;
 @property (strong, nonatomic) NSString *end_time;
 @property (strong, nonatomic) NSString *total_time;
 @property (strong, nonatomic) NSString *exam_number;
 @property (strong, nonatomic) NSString *visible_answer;
 @property (strong, nonatomic) NSString *total_count;
 @property (strong, nonatomic) NSString *total_score;
 @property (strong, nonatomic) NSString *topic_md5;
 @property (strong, nonatomic) NSArray *parts;
 */
-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"mhm_id"] || [property.name isEqualToString:@"title"] || [property.name isEqualToString:@"info"] || [property.name isEqualToString:@"cate"] || [property.name isEqualToString:@"paper_type"] || [property.name isEqualToString:@"question_rand"]  || [property.name isEqualToString:@"answer_options_rand"]  || [property.name isEqualToString:@"start_time"]  || [property.name isEqualToString:@"end_time"]  || [property.name isEqualToString:@"total_time"]  || [property.name isEqualToString:@"exam_number"]  || [property.name isEqualToString:@"visible_answer"]  || [property.name isEqualToString:@"total_count"]  || [property.name isEqualToString:@"total_score"]  || [property.name isEqualToString:@"unique_code"] ) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"parts"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamPaperIDListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"child":@"value",@"examPartId":@"id",@"examPartDescription":@"description"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"ExamIDModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"title"] || [property.name isEqualToString:@"question_type"] || [property.name isEqualToString:@"num"] || [property.name isEqualToString:@"id"] || [property.name isEqualToString:@"description"] || [property.name isEqualToString:@"paper_id"]) {
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
