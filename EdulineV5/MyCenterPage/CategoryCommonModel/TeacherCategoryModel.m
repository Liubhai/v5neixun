//
//  TeacherCategoryModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeacherCategoryModel.h"
#import "V5_Constant.h"

@implementation TeacherCategoryModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cateGoryId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"CateGoryModelSecond"};
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

@implementation CateGoryModelSecond

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cateGoryId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"CateGoryModelThird"};
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

@implementation CateGoryModelThird

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cateGoryId":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"cateGoryId"] || [property.name isEqualToString:@"pid"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
