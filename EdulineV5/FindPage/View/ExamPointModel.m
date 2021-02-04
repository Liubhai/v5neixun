//
//  ExamPointModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/25.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamPointModel.h"
#import "V5_Constant.h"

@implementation ExamPointModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cateGoryId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"ExamPointModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"cateGoryId"] || [property.name isEqualToString:@"pid"]) {
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
