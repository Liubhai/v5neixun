//
//  CCRoomDecModel.h
//  CCClassRoom
//
//  Created by 刘强强 on 2021/6/25.
//  Copyright © 2021 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCRoomDecDataModel : NSObject
@property(nonatomic, assign)NSInteger audience_authtype;
@property(nonatomic, assign)NSInteger classtype;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, assign)NSInteger inspector_authtype;
@property(nonatomic, assign)BOOL is_follow;
@property(nonatomic, assign)NSInteger layout_mode;
@property(nonatomic, copy)NSString *live_roomid;
@property(nonatomic, assign)NSInteger max_streams;
@property(nonatomic, assign)NSInteger max_users;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger platform;
@property(nonatomic, assign)NSInteger publisher_authtype;
@property(nonatomic, assign)NSInteger publisher_bitrate;
@property(nonatomic, assign)NSInteger room_mode;
@property(nonatomic, assign)NSInteger room_type;
@property(nonatomic, copy)NSString *schedule_live_end;
@property(nonatomic, copy)NSString *schedule_live_start;
@property(nonatomic, assign)int schedule_switch;
@property(nonatomic, assign)int screen_lock;
@property(nonatomic, assign)int talker_authtype;
@property(nonatomic, assign)NSInteger talker_bitrate;
@property(nonatomic, assign)NSInteger templatetype;
@property(nonatomic, copy)NSString *userid;
@property(nonatomic, copy)NSString *classNo;
@end

@interface CCRoomDecModel : NSObject
@property(nonatomic, strong)CCRoomDecDataModel *data;
@property(nonatomic, copy)NSString *result;
@property(nonatomic, copy)NSString *errorMsg;

+ (NSInteger)authTypeKeyForRole:(NSString *)role model:(CCRoomDecDataModel *)model;
+ (void)getRoomDescWithRoomID:(NSString *)roomId classCode:(NSString *)classCode completion:(CCComletionBlock)completion;
@end

NS_ASSUME_NONNULL_END
