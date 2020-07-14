//
//  NewClassCourseModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "NewClassCourseModel.h"
#import "V5_Constant.h"

@implementation NewClassCourseModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"course_type"] || [property.name isEqualToString:@"course_type_text"] || [property.name isEqualToString:@"title"] || [property.name isEqualToString:@"teacher_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
