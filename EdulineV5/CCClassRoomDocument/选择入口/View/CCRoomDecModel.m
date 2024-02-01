//
//  CCRoomDecModel.m
//  CCClassRoom
//
//  Created by 刘强强 on 2021/6/25.
//  Copyright © 2021 cc. All rights reserved.
//

#import "CCRoomDecModel.h"
#import <MJExtension/MJExtension.h>

@implementation CCRoomDecDataModel

@end

@implementation CCRoomDecModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"data" : @"CCRoomDecDataModel",
             };
}

+ (NSInteger)authTypeKeyForRole:(NSString *)role model:(CCRoomDecDataModel *)model {
    if (!role || role.length == 0)
    {
        return model.publisher_authtype;
    }
    if ([role isEqualToString:KKEY_CCRole_Teacher])
    {
        return model.publisher_authtype;
    }
    if ([role isEqualToString:KKEY_CCRole_Student]) {
        return model.talker_authtype;
    }
    if ([role isEqualToString:KKEY_HDRole_au_low]) {
           return model.talker_authtype;
    }
    if ([role isEqualToString:KKEY_CCRole_Watcher]) {
        return model.audience_authtype;
    }
    if ([role isEqualToString:KKEY_CCRole_Inspector]) {
        return model.inspector_authtype;
    }
    return model.publisher_authtype;
}

+ (void)getRoomDescWithRoomID:(NSString *)roomId classCode:(NSString *)classCode completion:(CCComletionBlock)completion {
    
    [[CCStreamerBasic sharedStreamer] getRoomDescWithRoomID:roomId classNo:classCode completion:^(BOOL result, NSError *error, id info) {
        NSLog(@"%s__%d__%@__%@__%@", __func__, __LINE__, @(result), error, info);
        if (result) {
            CCRoomDecModel *model = [CCRoomDecModel mj_objectWithKeyValues:info];
            completion(result, error, model);
        }else {
            completion(result, error, nil);
        }
    }];
}

@end
