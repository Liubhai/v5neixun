//
//  ExamCollectCellModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamCollectCellModel.h"
#import "V5_Constant.h"

@implementation ExamCollectCellModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"topic_id"] || [property.name isEqualToString:@"allCount"] || [property.name isEqualToString:@"rightCount"] || [property.name isEqualToString:@"qustion_type"] || [property.name isEqualToString:@"title"] || [property.name isEqualToString:@"examTime"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
