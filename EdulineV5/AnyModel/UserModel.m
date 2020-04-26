//
//  UserModel.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "UserModel.h"

#define SWToStr(X) [UserModel replaceNilStr:X nilStr:@""]

@implementation UserModel

+ (NSDictionary *)userPassport {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"sw_UserModelPassport"];
    if (SWNOTEmptyDictionary(dic)) {
        return dic;
    }
    return @{};
}

+ (void)saveUserPassportToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret
{
    NSDictionary *rootParam = @{@"oauthToken": token, @"oauthTokenSecret": tokenSecret};
//    [TSNetwork configRootParameter:rootParam];
    
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    if (SWNOTEmptyStr(token)) {
        [uDic setObject:token forKey:@"oauthToken"];
    }
    if (SWNOTEmptyStr(tokenSecret)) {
        [uDic setObject:tokenSecret forKey:@"oauthTokenSecret"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteUserPassport {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveUname:(NSString *)uname
{
    if (!SWNOTEmptyStr(uname)) {
        return;
    }
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    [uDic setObject:uname forKey:@"uname"];
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveGender:(NSString *)gender {
    
    if (!SWNOTEmptyStr(gender)) {
        return;
    }
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    [uDic setObject:gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveUid:(NSString *)uid
{
    if ([uid integerValue]==0) {
        return;
    }
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    [uDic setObject:SWToStr(uid) forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)savePhone:(NSString *)phone {
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"user_phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveNickName:(NSString *)uname {
    [[NSUserDefaults standardUserDefaults] setObject:uname forKey:@"user_nickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveAllInfo:(NSDictionary *)dic
{
    if (!SWNOTEmptyDictionary(dic)) {
        return;
    }
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    [uDic setObject:SWToStr(dic[@"following_count"]) forKey:@"user_followingCount"];
    [uDic setObject:SWToStr(dic[@"follower_count"]) forKey:@"user_followerCount"];
    [uDic setObject:SWToStr(dic[@"weibo_count"]) forKey:@"weibo_count"];
    if (SWNOTEmptyArr(dic[@"user_group"])) {
        [uDic setObject:dic[@"user_group"] forKey:@"user_group"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)saveIntro:(NSString *)intro
{
    if (!SWNOTEmptyStr(intro)) {
        return;
    }
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    [uDic setObject:intro forKey:@"intro"];
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveAvatar:(NSString *)avatar
{
    if (!SWNOTEmptyStr(avatar)) {
        return;
    }
    NSMutableDictionary *uDic = [NSMutableDictionary dictionaryWithDictionary:[self userPassport]];
    [uDic setObject:avatar forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] setObject:uDic forKey:@"sw_UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveIsAdmin:(BOOL)isAdmin
{
    [[NSUserDefaults standardUserDefaults] setObject:@(isAdmin) forKey:@"sw_UserModelisAdmin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)saveRemark:(NSString *)remark{
    [[NSUserDefaults standardUserDefaults] setObject:remark forKey:@"sw_UserModelRemark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveWithdrawAccout:(NSString *)accout {
    [[NSUserDefaults standardUserDefaults] setObject:accout forKey:@"sw_UserModelAccout"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveWithdrawAccoutPlatform:(int)platform {
    [[NSUserDefaults standardUserDefaults] setInteger:platform forKey:@"sw_UserModelPlatform"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveAuth_scope:(NSString *)auth_scope {
    [[NSUserDefaults standardUserDefaults] setObject:auth_scope forKey:@"user_auth_scope"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isAdmin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"sw_UserModelisAdmin"]boolValue];
}

+(void)saveUsergroupId:(NSString *)usergroupId {
    [[NSUserDefaults standardUserDefaults] setObject:usergroupId forKey:@"sw_UserModelUsergroupId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveVerified:(NSString *)verified {
    [[NSUserDefaults standardUserDefaults] setObject:verified forKey:@"sw_UserModelVerified"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveUserGroupIcon:(NSArray*)gruopArray{
    [[NSUserDefaults standardUserDefaults] setObject:gruopArray forKey:@"sw_UserModelUserGroupIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveUserGroupPermission:(NSDictionary *)dict {
    [[NSUserDefaults standardUserDefaults] setObject: dict forKey:@"groupPermission"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveNeed_set_password:(BOOL)need_set_password {
    [[NSUserDefaults standardUserDefaults] setObject: @(need_set_password) forKey:@"need_set_password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (NSDictionary *)groupPermission {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"groupPermission"];
}

+ (NSString*)remark{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sw_UserModelRemark"];
}

+(NSString *)uname
{
    return [UserModel replaceNilStr:[self userPassport][@"uname"] nilStr:@""];
}

+(NSString *)uid
{
    return [UserModel replaceNilStr:SWToStr([self userPassport][@"uid"]) nilStr:@""];
}

+(NSString *)gender {
    return [UserModel replaceNilStr:SWToStr([self userPassport][@"gender"]) nilStr:@""];
}

+(NSString *)avatar
{
    return [UserModel replaceNilStr:[self userPassport][@"avatar"] nilStr:@""];
}

+(NSString *)intro
{
    return [UserModel replaceNilStr:[self userPassport][@"intro"] nilStr:@""];
}

+(NSString *)oauthToken
{
    return [UserModel replaceNilStr:[self userPassport][@"oauthToken"] nilStr:@""];
}

+(NSString *)oauthTokenSecret
{
    return [UserModel replaceNilStr:[self userPassport][@"oauthTokenSecret"] nilStr:@""];
}

+(NSString *)groupImg
{
    NSDictionary *dic = [self userPassport];
    if (SWNOTEmptyDictionary(dic)) {
        if (SWNOTEmptyArr(dic[@"user_group"])) {
            return dic[@"user_group"][0];
        }
    }
    return @"";
}

+(NSString *)weiboCount
{
    NSDictionary *dic = [self userPassport];
    if (SWNOTEmptyDictionary(dic)) {
        if (SWNOTEmptyStr(dic[@"weibo_count"])) {
            return dic[@"weibo_count"];
        }
    }
    return @"";
}

+(NSString *)followerCount
{
    NSDictionary *dic = [self userPassport];
    if (SWNOTEmptyDictionary(dic)) {
        if (SWNOTEmptyStr(dic[@"user_followerCount"])) {
            return dic[@"user_followerCount"];
        }
    }
    return @"";
}

+(NSString *)followingCount
{
    NSDictionary *dic = [self userPassport];
    if (SWNOTEmptyDictionary(dic)) {
        if (SWNOTEmptyStr(dic[@"user_followingCount"])) {
            return dic[@"user_followingCount"];
        }
    }
    return @"";
}

+ (NSString *)withdrawAccout {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sw_UserModelAccout"];
}

+ (int)WithdrawAccoutPlatform {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sw_UserModelPlatform"];
}

+(NSString *)usergroupId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sw_UserModelUsergroupId"];
}

+(NSString *)verified {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sw_UserModelVerified"];
}
+(NSArray *)userGroupIcon {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sw_UserModelUserGroupIcon"];
}

+(BOOL)need_set_password {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"need_set_password"] boolValue];
}

+ (NSString *)userPhone {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_phone"];
}

+ (NSString *)userNickName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_nickName"];
}

+ (NSString *)userAuth_scope {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_auth_scope"];
}

+(NSString *)replaceNilStr:(id)str nilStr:(NSString *)str2
{
    if ([str isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",str];
    }
    if (SWNOTEmptyStr(str)) {
        return str;
    }else{
        return str2;
    }
}

@end
