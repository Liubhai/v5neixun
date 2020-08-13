//
//  CouponModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/29.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CouponModel.h"
#import "V5_Constant.h"

@implementation CouponModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"couponId":@"id"};
}

/**
"id": 1,
"code": "111",
"online": 1,
"coupon_type": 3,
"mhm_id": 1,
"maxprice": "0.00",
"price": "0.00",
"discount": "0.00",
"vip_date": 0,
"recharge_price": "0.00",
"course_id": 10,
"use_stime": 1587702400,
"use_etime": 1607702400,
"count": 10,
"rest": 9,
"derive_etime": 1607702400,
"create_time": 0
*/

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"code"] || [property.name isEqualToString:@"coupon_type"] || [property.name isEqualToString:@"mhm_id"] || [property.name isEqualToString:@"course_id"] || [property.name isEqualToString:@"course_title"] || [property.name isEqualToString:@"count"] || [property.name isEqualToString:@"rest"] || [property.name isEqualToString:@"user_price"] || [property.name isEqualToString:@"vip_price"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end

@implementation CouponArrayModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"CouponModel"};
}

@end

@implementation UserCouponModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"listId":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"user_id"] || [property.name isEqualToString:@"coupon_id"] || [property.name isEqualToString:@"mhm_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
