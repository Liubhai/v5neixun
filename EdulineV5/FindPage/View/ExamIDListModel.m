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
    if ([property.name isEqualToString:@"title"] || [property.name isEqualToString:@"question_type"] || [property.name isEqualToString:@"id"] || [property.name isEqualToString:@"analyze"] || [property.name isEqualToString:@"topic_level"] ) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"options"] || [property.name isEqualToString:@"topics"]) {
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
