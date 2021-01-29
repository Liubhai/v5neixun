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

//+(NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"cateGoryId":@"id"};
//}

//+(NSDictionary *)mj_objectClassInArray
//{
//    return @{@"child":@"ExamModel"};
//}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"question_type"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"child"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end

@implementation ExamModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"title"] || [property.name isEqualToString:@"exam_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"child"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end
