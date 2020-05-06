//
//  ShopCarModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/30.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ShopCarModel,ShopCarCourseModel;

@interface ShopCarModel : NSObject

@property (strong, nonatomic) NSArray *course_list;
@property (strong, nonatomic) NSString *school_name;
@property (assign, nonatomic) float total_price;
@property (strong, nonatomic) CouponModel *best_coupon;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) NSString *mhm_id;

@end

/**
 "id": 1,
 "course_type": 1,
 "category": 2,
 "fullcategorypath": ",1,2,",
 "title": "点播3级",
 "cover": 17,
 "price": "99.00",
 "scribing_price": "199.00",
 "status": 1,
 "section_level": 3,
 "mhm_id": 2,
 "teacher_id": 2,
 "user_id": 1,
 "info": "https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9356344456112208629%22%7D&n_type=0&p_from=1",
 "term_time": 10,
 "update_status": 1,
 "publish_status": 0,
 "score_average": 4,
 "score_nums": 0,
 "score_sums": 0,
 "view_count": 0,
 "sale_count": 5,
 "create_time": null,
 "update_time": 1585897018,
 "delete_time": null
 */

@interface ShopCarCourseModel : NSObject

@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSString *course_type;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *fullcategorypath;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) NSString *cover_url;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *scribing_price;
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSString *section_level;
@property (strong, nonatomic) NSString *mhm_id;
@property (strong, nonatomic) NSString *teacher_id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *term_time;
@property (assign, nonatomic) BOOL update_status;
@property (assign, nonatomic) BOOL publish_status;
@property (strong, nonatomic) NSString *score_average;
@property (strong, nonatomic) NSString *score_nums;
@property (strong, nonatomic) NSString *view_count;
@property (strong, nonatomic) NSString *sale_count;
@property (strong, nonatomic) NSString *section_count;
@property (strong, nonatomic) NSString *create_time;
@property (strong, nonatomic) NSString *update_time;
@property (strong, nonatomic) NSString *delete_time;
@property (assign, nonatomic) BOOL selected;


@end

NS_ASSUME_NONNULL_END
