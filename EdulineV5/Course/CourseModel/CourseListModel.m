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
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"section_id"] || [property.name isEqualToString:@"pid"] || [property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"video_url"] || [property.name isEqualToString:@"course_type"] || [property.name isEqualToString:@"start_time"] || [property.name isEqualToString:@"end_time"]) {
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
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"uid"] || [property.name isEqualToString:@"attach_id"] || [property.name isEqualToString:@"fileurl"] || [property.name isEqualToString:@"data_type"] || [property.name isEqualToString:@"data_type_text"] || [property.name isEqualToString:@"data_txt"]) {
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

@implementation live_rate_model


@end

@implementation section_CCLive

/**
 "room_no": 24, //课时ID，声网房间ID
 "course_id": 4, //课程ID
 "live_type": 2, //直播方类型【1：声网；2：CC；】
 "cc_userid": "56761A7379431808", //CC账户ID
 "cc_room_id": "774F73163829E5D29C33DC5901307461", //直播间ID
 "authtype": 0, //验证方式【0：接口验证；1：密码验证；2：免密码验证】
 "attach_id": null,
 "cc_replay": "", //CC回放
 "create_time": 1607689317,
 "close_time": null,
 "update_time": 1607689317,
 "data_type": 1
 */

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"room_no"] || [property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"live_type"] || [property.name isEqualToString:@"cc_userid"] || [property.name isEqualToString:@"cc_room_id"] || [property.name isEqualToString:@"authtype"] || [property.name isEqualToString:@"attach_id"] || [property.name isEqualToString:@"cc_replay"] || [property.name isEqualToString:@"create_time"] || [property.name isEqualToString:@"close_time"] || [property.name isEqualToString:@"update_time"] || [property.name isEqualToString:@"data_type"] || [property.name isEqualToString:@"cc_replay_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end

@implementation section_face_data


@end

@implementation section_alert_data


@end

@implementation section_exam_data


@end
