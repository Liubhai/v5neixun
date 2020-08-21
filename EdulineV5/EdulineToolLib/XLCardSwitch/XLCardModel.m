//
//  CardModel.m
//  CardSwitchDemo
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XLCardModel.h"
#import "V5_Constant.h"

@implementation XLCardModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"imageName":@"cover_url",@"course_id":@"id"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"id"] || [property.name isEqualToString:@"sale_count"] || [property.name isEqualToString:@"course_type_text"] || [property.name isEqualToString:@"price"] || [property.name isEqualToString:@"cover_url"] || [property.name isEqualToString:@"course_type"] || [property.name isEqualToString:@"user_price"] || [property.name isEqualToString:@"title"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
