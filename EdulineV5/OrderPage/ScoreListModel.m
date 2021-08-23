//
//  ScoreListModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ScoreListModel.h"
#import "V5_Constant.h"

@implementation ScoreListModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"scoreCount"] || [property.name isEqualToString:@"moneyCount"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    }
    return oldValue;
}

@end
