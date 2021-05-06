//
//  EXamRecordModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "EXamRecordModel.h"
#import "V5_Constant.h"

@implementation EXamRecordModel
/**
 "id": 1,
 "paper_id": 1,
 "unique_code": "6883c67c6babe7bd94ef51d8e857624d",
 "answer_times": 1,
 "time_takes": 1100,
 "commit_time": 1618826226,
 "answer_status": 0,
 "score": 0,
 "paper_title": "第一套试卷"
 */

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"topic_id":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"topic_id"] || [property.name isEqualToString:@"paper_id"] || [property.name isEqualToString:@"unique_code"] || [property.name isEqualToString:@"answer_times"] || [property.name isEqualToString:@"time_takes"] || [property.name isEqualToString:@"commit_time"] || [property.name isEqualToString:@"answer_status"] || [property.name isEqualToString:@"user_score"] || [property.name isEqualToString:@"paper_score"] || [property.name isEqualToString:@"paper_title"] || [property.name isEqualToString:@"answer_count"] || [property.name isEqualToString:@"right_count"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
