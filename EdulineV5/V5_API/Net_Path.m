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

+ (NSString *)appConfig {
    return [Net_Path fullPath:@"config/init" repalce:@"" byReplece:@""];
}

+ (NSString *)layoutConfig {
    return [Net_Path fullPath:@"config/typeset" repalce:@"" byReplece:@""];
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

+ (NSString *)userEditPwPath {
    return [Net_Path fullPath:@"user/account/pwd/edit" repalce:@"" byReplece:@""];
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

+ (NSString *)smsCodeSend {
    return [Net_Path fullPath:@"sms/verify" repalce:@"" byReplece:@""];
}

+ (NSString *)userAccountChangePhone {
    return [Net_Path fullPath:@"user/account/phone" repalce:@"" byReplece:@""];
}

+ (NSString *)searchCourse {
    return [Net_Path fullPath:@"course/base/search" repalce:@"" byReplece:@""];
}

+ (NSString *)coursetypeList {
    return [Net_Path fullPath:@"course/base/type" repalce:@"" byReplece:@""];
}

+ (NSString *)courseClassifyList {
    return [Net_Path fullPath:@"course/base/category/tree" repalce:@"" byReplece:@""];
}

+ (NSString *)courseCommentList:(NSString *)courseId {
    return [Net_Path fullPath:@"course/base/{id}/comment" repalce:@"{id}" byReplece:courseId];
}

+ (NSString *)courseCommentReplayList:(NSString *)commentId {
    return [Net_Path fullPath:@"course/base/comment/{id}/reply" repalce:@"{id}" byReplece:commentId];
}

+ (NSString *)courseNoteList:(NSString *)courseId {
    return [Net_Path fullPath:@"course/base/{id}/note" repalce:@"{id}" byReplece:courseId];
}

+ (NSString *)userInfoEdition {
    return [Net_Path fullPath:@"user/account/edit" repalce:@"" byReplece:@""];
}

+ (NSString *)zanComment:(NSString *)commentId {
    return [Net_Path fullPath:@"course/base/comment/{id}/like" repalce:@"{id}" byReplece:commentId];
}

+ (NSString *)zanCommentReplay:(NSString *)commentReplayId {
    return [Net_Path fullPath:@"course/base/comment/reply/{id}/like" repalce:@"{id}" byReplece:commentReplayId];
}

+ (NSString *)verifyImageExit {
    return [Net_Path fullPath:@"upload/fast" repalce:@"" byReplece:@""];
}

+ (NSString *)uploadImageField {
    return [Net_Path fullPath:@"upload/putFile" repalce:@"" byReplece:@""];
}

+ (NSString *)courseHourseNoteList {
    return [Net_Path fullPath:@"course/base/note/list" repalce:@"" byReplece:@""];
}

+ (NSString *)addCourseHourseNote {
    return [Net_Path fullPath:@"course/base/note" repalce:@"" byReplece:@""];
}

+ (NSString *)modificationCourseNote:(NSString *)noteId {
    return [Net_Path fullPath:@"course/base/note/{id}" repalce:@"{id}" byReplece:noteId];
}

+ (NSString *)currentLoginUserInfo {
    return [Net_Path fullPath:@"user/account/info" repalce:@"" byReplece:@""];
}

+ (NSString *)courseOrderInfo {
    return [Net_Path fullPath:@"order/course/one" repalce:@"" byReplece:@""];
}

+ (NSString *)courseHourseOrderInfo {
    return [Net_Path fullPath:@"order/section" repalce:@"" byReplece:@""];
}

+ (NSString *)couponsUserList {
    return [Net_Path fullPath:@"course/coupon/school/user" repalce:@"" byReplece:@""];
}

+ (NSString *)schoolCouponList {
    return [Net_Path fullPath:@"course/coupon/school" repalce:@"" byReplece:@""];
}

+ (NSString *)courseCouponList {
    return [Net_Path fullPath:@"course/coupon/course" repalce:@"" byReplece:@""];
}

+ (NSString *)courseCouponUserList {
    return [Net_Path fullPath:@"course/coupon/course/user" repalce:@"" byReplece:@""];
}

+ (NSString *)getWhichCoupon:(NSString *)couponId {
    return [Net_Path fullPath:@"course/coupon/{id}/derive" repalce:@"{id}" byReplece:couponId];
}

+ (NSString *)creatSingleOrder {
    return [Net_Path fullPath:@"order/course/one" repalce:@"" byReplece:@""];
}

+ (NSString *)userMemberInfo {
    return [Net_Path fullPath:@"user/vip" repalce:@"" byReplece:@""];
}

+ (NSString *)userBalanceInfo {
    return [Net_Path fullPath:@"user/balance" repalce:@"" byReplece:@""];
}

+ (NSString *)userBalanceDetailInfo {
    return [Net_Path fullPath:@"user/balance/flow" repalce:@"" byReplece:@""];
}

+ (NSString *)userIncomeDetailInfo {
    return [Net_Path fullPath:@"user/income/flow" repalce:@"" byReplece:@""];
}

+ (NSString *)userPayInfo {
    return [Net_Path fullPath:@"order/pay" repalce:@"" byReplece:@""];
}

+ (NSString *)userShopcarInfo {
    return [Net_Path fullPath:@"course/payment/cart" repalce:@"" byReplece:@""];
}

+ (NSString *)shopcarOrderInfo {
    return [Net_Path fullPath:@"order/course/cart" repalce:@"" byReplece:@""];
}

+ (NSString *)addCourseIntoShopcar {
    return [Net_Path fullPath:@"course/payment/cart" repalce:@"" byReplece:@""];
}

+ (NSString *)deleteCourseFromShopcar {
    return [Net_Path fullPath:@"course/payment/cart" repalce:@"" byReplece:@""];
}

+ (NSString *)subMitOrder {
    return [Net_Path fullPath:@"order/pay" repalce:@"" byReplece:@""];
}

+ (NSString *)userOrderList:(NSString *)orderListType {
    return [Net_Path fullPath:@"user/order/{type}" repalce:@"{type}" byReplece:orderListType];
}

+ (NSString *)userCenterInfo {
    return [Net_Path fullPath:@"user/profile" repalce:@"" byReplece:@""];
}

+ (NSString *)myCouponsList:(NSString *)couponType {
    return [Net_Path fullPath:@"user/coupon/{type}" repalce:@"{type}" byReplece:couponType];
}

+ (NSString *)couponExchange {
    return [Net_Path fullPath:@"user/coupon/exchange" repalce:@"" byReplece:@""];
}

+ (NSString *)addRecord {
    return [Net_Path fullPath:@"course/base/record" repalce:@"" byReplece:@""];
}

+ (NSString *)learnRecordList {
    return [Net_Path fullPath:@"course/base/record/list" repalce:@"" byReplece:@""];
}

+ (NSString *)studyMainPageData {
    return [Net_Path fullPath:@"course/base/record/fetch" repalce:@"" byReplece:@""];
}

+ (NSString *)studyMainPageJoinCourseList {
    return [Net_Path fullPath:@"course/base/record/course" repalce:@"" byReplece:@""];
}

+ (NSString *)liveLoginInfo {
    return [Net_Path fullPath:@"course/live/tencent/v2/userSig" repalce:@"" byReplece:@""];
}

+ (NSString *)teacherList {
    return [Net_Path fullPath:@"user/teacher/list" repalce:@"" byReplece:@""];
}

+ (NSString *)teacherCourseListInfo:(NSString *)teacherId {
    return [Net_Path fullPath:@"user/teacher/{id}/course" repalce:@"{id}" byReplece:teacherId];
}

+ (NSString *)teacherMainInfo:(NSString *)teacherId {
    return [Net_Path fullPath:@"user/teacher/{id}/basic" repalce:@"{id}" byReplece:teacherId];
}

+ (NSString *)userFollowNet {
    return [Net_Path fullPath:@"user/follow" repalce:@"" byReplece:@""];
}

+ (NSString *)userFollowListNet {
    return [Net_Path fullPath:@"user/follow/follower" repalce:@"" byReplece:@""];
}

@end
