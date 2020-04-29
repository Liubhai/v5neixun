//
//  CouponModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/29.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CouponModel,CouponArrayModel;

@interface CouponModel : NSObject

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
 "school_name": "测试机构1",
 "user_has": 1
*/

@property (strong, nonatomic) NSString *couponId;
@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) BOOL online;
@property (strong, nonatomic) NSString *coupon_type;
@property (strong, nonatomic) NSString *mhm_id;
@property (strong, nonatomic) NSString *maxprice;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *discount;
@property (strong, nonatomic) NSString *vip_date;
@property (strong, nonatomic) NSString *recharge_price;
@property (strong, nonatomic) NSString *course_id;
@property (strong, nonatomic) NSString *use_stime;
@property (strong, nonatomic) NSString *use_etime;
@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSString *rest;
@property (strong, nonatomic) NSString *derive_etime;
@property (strong, nonatomic) NSString *create_time;
@property (strong, nonatomic) NSString *school_name;
@property (assign, nonatomic) BOOL user_has;
@property (assign, nonatomic) BOOL IsUsed;

@end

@interface CouponArrayModel : NSObject

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

@property (strong, nonatomic) NSArray *list;//数组
@property (strong, nonatomic) NSString *coupon_type_text;

@end

NS_ASSUME_NONNULL_END
