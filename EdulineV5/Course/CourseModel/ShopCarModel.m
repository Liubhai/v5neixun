//
//  ShopCarModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/30.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShopCarModel.h"
#import "V5_Constant.h"

@implementation ShopCarModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"course_list":@"ShopCarCourseModel"};
}
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

@implementation ShopCarCourseModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"cover"] || [property.name isEqualToString:@"course_type"] || [property.name isEqualToString:@"mhm_id"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"courseId":@"id"};
}

@end
