//
//  Net_Path.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface Net_Path : NSObject

struct NetWorkUrl {
    NSString *version;
    NSString *path;
    NSString *replace;
};

+ (NSString *)fullPath:(NSString *)path repalce:(NSString *)replace byReplece:(NSString *)byReplace;

/** 创建账号 */
+ (NSString *)userCreatePath:(NSString *)userId;

/** 账号登录 */
/** 登录方式【phone:手机一键登录；user:账号密码登录；verify:手机验证码登录】 */
+ (NSString *)userLoginPath:(NSString *)userId;

/** 账号信息编辑 */
+ (NSString *)userEditPath:(NSString *)userId;

/** 注销账号 */
+ (NSString *)userDeletePath:(NSString *)userId;

/** 重置密码 */
+ (NSString *)userResetPwPath:(NSString *)userId;

/** 短信验证 */
+ (NSString *)userVerifyPath:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
