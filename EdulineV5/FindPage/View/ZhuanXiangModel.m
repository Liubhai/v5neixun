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

//+(NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"classHourId":@"id"};
//}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"course_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
