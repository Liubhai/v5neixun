//
//  Net_Path.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "Net_Path.h"
#import "V5_Constant.h"

@implementation Net_Path

+ (NSString *)fullPath:(NSString *)path repalceArray:(NSArray *)replace byRepleceArray:(NSArray *)byReplace {
    if (replace.count == byReplace.count) {
        for (int i = 0; i<replace.count; i++) {
            path = [[NSString stringWithFormat:@"%@",path] stringByReplacingOccurrencesOfString:replace[i] withString:byReplace[i]];
        }
    }
    return path;
}

+ (NSString *)fullPath:(NSString *)path repalce:(NSString *)replace byReplece:(NSString *)byReplace {
    return [[NSString stringWithFormat:@"%@",path] stringByReplacingOccurrencesOfString:replace withString:byReplace];
}

+ (NSString *)userCreatePath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/create" repalce:@"" byReplece:@""];
}

+ (NSString *)userLoginPath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/login" repalce:@"" byReplece:@""];
}

+ (NSString *)userEditPath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/{{id}}/edit" repalce:@"{{id}}" byReplece:userId];
}

+ (NSString *)userDeletePath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/{{id}}/delete" repalce:@"{{id}}" byReplece:userId];
}

+ (NSString *)userResetPwPath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/pwd/reset" repalce:@"" byReplece:@""];
}

+ (NSString *)userSetPwPath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/pwd/set" repalce:@"" byReplece:@""];
}

+ (NSString *)userVerifyPath:(NSString *)userId {
    return [Net_Path fullPath:@"user/account/pwd/verify" repalce:@"" byReplece:@""];
}

+ (NSString *)testApiPath {
    return [Net_Path fullPath:@"/user/admin/account" repalce:@"" byReplece:@""];
}

+ (NSString *)courseInfo:(NSString *)courseId {
    return [Net_Path fullPath:@"/course/base/{id}" repalce:@"{id}" byReplece:courseId];
}

+ (NSString *)courseList:(NSString *)courseId pid:(nonnull NSString *)pid {
    return [Net_Path fullPath:@"/course/base/{id}/section/{pid}" repalceArray:@[@"{id}",@"{pid}"] byRepleceArray:@[courseId,pid]];
}

+ (NSString *)courseMainList {
    return [Net_Path fullPath:@"/course/base/list" repalce:@"" byReplece:@""];
}

@end
