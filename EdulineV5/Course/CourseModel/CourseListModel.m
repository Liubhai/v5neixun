//
//  CourseListModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseListModel.h"
#import "V5_Constant.h"

@implementation CourseListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"classHourId":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"pid"] || [property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"video_url"] || [property.name isEqualToString:@"course_type"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end

@implementation section_data_model

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"fileId":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"uid"] || [property.name isEqualToString:@"attach_id"] || [property.name isEqualToString:@"fileurl"] || [property.name isEqualToString:@"data_type"] || [property.name isEqualToString:@"data_type_text"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end

@implementation section_rate_model


@end
