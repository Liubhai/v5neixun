//
//  ZhuanXiangModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ZhuanXiangModel.h"
#import "V5_Constant.h"

@implementation ZhuanXiangModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"course_id":@"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"child":@"ZhuanXiangModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"id"] || [property.name isEqualToString:@"topic_count"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
