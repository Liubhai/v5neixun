//
//  ExamCollectCellModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamCollectCellModel.h"
#import "V5_Constant.h"

@implementation ExamCollectCellModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"errorId":@"id"};
}

/*
"id": 2,
"topic_type": 1,
"topic_id": 3,
"wrong_count": 11,
"answer_count": 13,
"wrong_time": 1614740800,
"topic_title": "<p>判断题</p>"
*/
-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"topic_id"] || [property.name isEqualToString:@"topic_id"] || [property.name isEqualToString:@"answer_count"] || [property.name isEqualToString:@"wrong_count"] || [property.name isEqualToString:@"topic_type"] || [property.name isEqualToString:@"topic_title"] || [property.name isEqualToString:@"wrong_time"] || [property.name isEqualToString:@"question_type"] || [property.name isEqualToString:@"question_type_text"] || [property.name isEqualToString:@"create_time"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
