//
//  UploadImageModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/24.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "UploadImageModel.h"
#import "V5_Constant.h"

@implementation UploadImageModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"imageId"]) {
        if (NOTNULL(oldValue)&&![oldValue isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",oldValue];
        }else if (!NOTNULL(oldValue)){
            return @"";
        }
    } else if ([property.name isEqualToString:@"imageArray"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end
