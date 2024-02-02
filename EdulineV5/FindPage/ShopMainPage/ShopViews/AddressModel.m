//
//  AddressModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/27.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "AddressModel.h"
#import "V5_Constant.h"

@implementation AddressModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"children":@"AddressModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"children"]) {
        if (!NOTNULL(oldValue)){
            return @[];
        }
    }
    return oldValue;
}

@end
