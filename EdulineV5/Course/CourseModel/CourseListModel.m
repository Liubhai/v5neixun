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
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"pid"] || [property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"video_url"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
