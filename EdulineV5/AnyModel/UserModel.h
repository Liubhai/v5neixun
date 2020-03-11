//
//  UserModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

// 用户通行证
+ (NSDictionary *)userPassport;
+ (void)saveUserPassportToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret;

+ (void)deleteUserPassport;

+(void)saveUname:(NSString *)uname;
+(void)savePhone:(NSString *)phone;
+(void)saveNickName:(NSString *)uname;
+(void)saveAvatar:(NSString *)avatar;
+(void)saveIntro:(NSString *)intro;
+(void)saveUid:(NSString *)uid;
+(void)saveAllInfo:(NSDictionary *)dic;
+(void)saveIsAdmin:(BOOL)isAdmin;
+(void)saveUsergroupId:(NSString *)usergroupId;
+(void)saveVerified:(NSString *)verified;
+(void)saveNeed_set_password:(BOOL)need_set_password;
+(void)saveAuth_scope:(NSString *)auth_scope;
// 备注
+(void)saveRemark:(NSString*)remark;
// 用户组图标
+ (void)saveUserGroupIcon:(NSArray*)gruopArray;

/**
 持久化提现账户

 @param accout 提现账户
 */
+ (void)saveWithdrawAccout:(NSString *)accout;
/**
 持久化提现平台

 @param platform 提现平台, 1 支付宝, 2 微信
 */
+ (void)saveWithdrawAccoutPlatform:(int)platform;
/**
*   保存用户权限
 */
+ (void)saveUserGroupPermission:(NSDictionary *)dict;


+(NSString *)uid;
+(NSString *)uname;
+(NSString *)avatar;
+(NSString *)intro;
+(NSString *)oauthToken;
+(NSString *)oauthTokenSecret;
+(NSString *)groupImg;
+(NSString *)weiboCount;
+(NSString *)followerCount;
+(NSString *)followingCount;
+(BOOL)isAdmin;
+(NSString*)remark;
+ (NSString *)withdrawAccout;
+ (int)WithdrawAccoutPlatform;
+(NSString *)usergroupId;
+(NSString *)verified;
+(NSArray *)userGroupIcon;
+ (NSDictionary *)groupPermission;
+(BOOL)need_set_password;
+ (NSString *)userPhone;
+ (NSString *)userNickName;
+(NSString *)userAuth_scope;


@end

NS_ASSUME_NONNULL_END
