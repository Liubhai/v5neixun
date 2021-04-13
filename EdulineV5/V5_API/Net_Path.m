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

+ (NSString *)touristLoginNet {
    return [Net_Path fullPath:@"ioslogin" repalce:@"" byReplece:@""];
}

+ (NSString *)appLoginTypeConfigNet {
    return [Net_Path fullPath:@"config/login" repalce:@"" byReplece:@""];
}

+ (NSString *)otherTypeLogin {
    return [Net_Path fullPath:@"user/account/thirdlogin" repalce:@"" byReplece:@""];
}

+ (NSString *)otherTypeBindNet {
    return [Net_Path fullPath:@"user/thirdlogin/bind" repalce:@"" byReplece:@""];
}

+ (NSString *)appthirdloginTypeConfigNet {
    return [Net_Path fullPath:@"config/thirdlogin" repalce:@"" byReplece:@""];
}

+ (NSString *)layoutConfig {
    return [Net_Path fullPath:@"config/typeset" repalce:@"" byReplece:@""];
}

+ (NSString *)shengwangConfig {
    return [Net_Path fullPath:@"course/live/agora/config" repalce:@"" byReplece:@""];
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
    return [Net_Path fullPath:@"user/admin/account" repalce:@"" byReplece:@""];
}

+ (NSString *)courseInfo:(NSString *)courseId {
    return [Net_Path fullPath:@"course/base/{id}" repalce:@"{id}" byReplece:courseId];
}

+ (NSString *)courseCollectionNet {
    return [Net_Path fullPath:@"user/collection" repalce:@"" byReplece:@""];
}

+ (NSString *)userCollectionListNet {
    return [Net_Path fullPath:@"user/collection" repalce:@"" byReplece:@""];
}

+ (NSString *)unCollectNet {
    return [Net_Path fullPath:@"user/collection/batch" repalce:@"" byReplece:@""];
}

+ (NSString *)courseList:(NSString *)courseId pid:(nonnull NSString *)pid {
    return [Net_Path fullPath:@"course/base/{id}/section/{pid}" repalceArray:@[@"{id}",@"{pid}"] byRepleceArray:@[courseId,pid]];
}

+ (NSString *)courseHourseUrlNet:(NSString *)courseId pid:(NSString *)pid {
    return [Net_Path fullPath:@"course/base/{id}/section/{sid}/fileurl" repalceArray:@[@"{id}",@"{sid}"] byRepleceArray:@[courseId,pid]];
}

+ (NSString *)classCourseList:(NSString *)classCourseId {
    return [Net_Path fullPath:@"course/classes/{id}/menu" repalce:@"{id}" byReplece:classCourseId];
}

+ (NSString *)courseMainList {
    return [Net_Path fullPath:@"course/base/list" repalce:@"" byReplece:@""];
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

/** 免费课程加入学习 */
+ (NSString *)joinFreeCourseNet {
    return [Net_Path fullPath:@"course/student/join" repalce:@"" byReplece:@""];
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

+ (NSString *)userMemberRecord {
    return [Net_Path fullPath:@"user/vip/log" repalce:@"" byReplece:@""];
}

+ (NSString *)userBalanceInfo {
    return [Net_Path fullPath:@"user/balance" repalce:@"" byReplece:@""];
}

+ (NSString *)balanceOrderCreate {
    return [Net_Path fullPath:@"user/balance/order" repalce:@"" byReplece:@""];
}

+ (NSString *)userIncomeDetail {
    return [Net_Path fullPath:@"user/income" repalce:@"" byReplece:@""];
}

+ (NSString *)userScoreDetail {
    return [Net_Path fullPath:@"user/credit" repalce:@"" byReplece:@""];
}

+ (NSString *)userBalanceDetailInfo {
    return [Net_Path fullPath:@"user/balance/flow" repalce:@"" byReplece:@""];
}

+ (NSString *)userIncomeDetailInfo {
    return [Net_Path fullPath:@"user/income/flow" repalce:@"" byReplece:@""];
}

+ (NSString *)userScoreDetailInfo {
    return [Net_Path fullPath:@"user/credit/flow" repalce:@"" byReplece:@""];
}

+ (NSString *)incomeForMouxin {
    return [Net_Path fullPath:@"user/income/encashment/wxpay" repalce:@"" byReplece:@""];
}

+ (NSString *)incomeForMoubao {
    return [Net_Path fullPath:@"user/income/encashment/alipay" repalce:@"" byReplece:@""];
}

+ (NSString *)incomeForBalance {
    return [Net_Path fullPath:@"user/income/encashment/balance" repalce:@"" byReplece:@""];
}

+ (NSString *)userPayInfo {
    return [Net_Path fullPath:@"order/pay" repalce:@"" byReplece:@""];
}

+ (NSString *)userShopcarInfo {
    return [Net_Path fullPath:@"course/payment/cart" repalce:@"" byReplece:@""];
}

+ (NSString *)userShopCarCountNet {
    return [Net_Path fullPath:@"user/cart/num" repalce:@"" byReplece:@""];
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

+ (NSString *)cancelOrder {
    return [Net_Path fullPath:@"user/order/cancel" repalce:@"" byReplece:@""];
}

+ (NSString *)deleteOrderNet {
    return [Net_Path fullPath:@"user/order" repalce:@"" byReplece:@""];
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

+ (NSString *)couponDirectExchangeNet {
    return [Net_Path fullPath:@"course/coupon/exchange" repalce:@"" byReplece:@""];
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

+ (NSString *)shengwangLiveInfo:(NSString *)liveId {
    return [Net_Path fullPath:@"course/live/agora/room/{id}" repalce:@"{id}" byReplece:liveId];
}

+ (NSString *)liveCourseListData {
    return [Net_Path fullPath:@"course/live/room/coursedatas" repalce:@"" byReplece:@""];
}

+ (NSString *)noteLiveSucNet {
    return [Net_Path fullPath:@"course/live/room/start" repalce:@"" byReplece:@""];
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

+ (NSString *)teacherApplyInfoNet {
    return [Net_Path fullPath:@"user/teacher/auth" repalce:@"" byReplece:@""];
}

+ (NSString *)teacherApplySubmiteNet {
    return [Net_Path fullPath:@"user/teacher/auth" repalce:@"" byReplece:@""];
}

+ (NSString *)userFollowNet {
    return [Net_Path fullPath:@"user/follow" repalce:@"" byReplece:@""];
}

+ (NSString *)userFollowListNet {
    return [Net_Path fullPath:@"user/follow/follower" repalce:@"" byReplece:@""];
}

+ (NSString *)userLastVisitorList {
    return [Net_Path fullPath:@"user/visitor/recent" repalce:@"" byReplece:@""];
}

+ (NSString *)institutionListNet {
    return [Net_Path fullPath:@"school/list" repalce:@"" byReplece:@""];
}

+ (NSString *)institutionSearchNet {
    return [Net_Path fullPath:@"school/search" repalce:@"" byReplece:@""];
}

+ (NSString *)institutionMainPageNet:(NSString *)institutionId {
    return [Net_Path fullPath:@"school/{id}/home" repalce:@"{id}" byReplece:institutionId];
}

+ (NSString *)institutionCourseListNet:(NSString *)institutionId {
    return [Net_Path fullPath:@"school/{id}/course" repalce:@"{id}" byReplece:institutionId];
}

+ (NSString *)institutionApplyNet {
    return [Net_Path fullPath:@"school/auth" repalce:@"" byReplece:@""];
}

+ (NSString *)commonCategoryNet {
    return [Net_Path fullPath:@"category/tree" repalce:@"" byReplece:@""];
}

+ (NSString *)findPageNet {
    return [Net_Path fullPath:@"config/discovery" repalce:@"" byReplece:@""];
}

+ (NSString *)homePageInfoNet {
    return [Net_Path fullPath:@"home" repalce:@"" byReplece:@""];
}

+ (NSString *)hotSearchNet {
    return [Net_Path fullPath:@"course/base/search/hot" repalce:@"" byReplece:@""];
}

+ (NSString *)favoriteCourseChangeNet {
    return [Net_Path fullPath:@"user/course/favorite" repalce:@"" byReplece:@""];
}

+ (NSString *)agreementContentNet:(NSString *)agreementKey {
    return [Net_Path fullPath:@"content/agreement/{key}/fetch" repalce:@"{key}" byReplece:agreementKey];
}

+ (NSString *)zixunListPageNet {
    return [Net_Path fullPath:@"topic/list" repalce:@"" byReplece:@""];
}

+ (NSString *)zixunDetailNet:(NSString *)zixunId {
    return [Net_Path fullPath:@"topic/{id}/fetch" repalce:@"{id}" byReplece:zixunId];
}

+ (NSString *)zixunPostComment:(NSString *)zixunId {
    return [Net_Path fullPath:@"topic/{id}/comment" repalce:@"{id}" byReplece:zixunId];
}

+ (NSString *)zixunCommentLikeNet:(NSString *)zixunId {
    return [Net_Path fullPath:@"topic/comment/{id}/like" repalce:@"{id}" byReplece:zixunId];
}

+ (NSString *)zixunCommentReplayLikeNet:(NSString *)zixunId {
    return [Net_Path fullPath:@"topic/reply/{id}/like" repalce:@"{id}" byReplece:zixunId];
}

+ (NSString *)zixunPostCommentReplay:(NSString *)zixunId {
    return [Net_Path fullPath:@"topic/comment/{id}/reply" repalce:@"{id}" byReplece:zixunId];
}

/** 互动消息 */
+ (NSString *)notifyCommentMessageNet {
    return [Net_Path fullPath:@"user/notify/comment" repalce:@"" byReplece:@""];
}
/** 提问消息 */
+ (NSString *)notifyQuestionMessageNet {
    return [Net_Path fullPath:@"user/notify/question" repalce:@"" byReplece:@""];
}
/** 系统消息 */
+ (NSString *)notifySystemMessageNet {
    return [Net_Path fullPath:@"user/system/message" repalce:@"" byReplece:@""];
}
/** 互动消息 */
+ (NSString *)notifyCourseMessageNet {
    return [Net_Path fullPath:@"user/system/course" repalce:@"" byReplece:@""];
}

/** 提问会话框内容列表 */
+ (NSString *)questionChatListNet:(NSString *)chatId {
    return [Net_Path fullPath:@"user/question/{id}" repalce:@"{id}" byReplece:chatId];
}

/** 提问 */
+ (NSString *)askQuestionNet {
    return [Net_Path fullPath:@"user/question" repalce:@"" byReplece:@""];
}

/** 提问回复 */
+ (NSString *)questionReplayNet {
    return [Net_Path fullPath:@"user/question/reply" repalce:@"" byReplece:@""];
}

+ (NSString *)messageReadNet {
    return [Net_Path fullPath:@"user/message/read" repalce:@"" byReplece:@""];
}

/** 任教授课列表 */
+ (NSString *)classCourseListNet {
    return [Net_Path fullPath:@"course/classes/teach" repalce:@"" byReplece:@""];
}

/** 班级课下学员列表 */
+ (NSString *)classCourseStudentListNet:(NSString *)courseId {
    return [Net_Path fullPath:@"course/classes/{id}/students" repalce:@"{id}" byReplece:courseId];
}

/** 移除班级课里面的学员 */
+ (NSString *)removeClassCourseStudent:(NSString *)courseId studentId:(NSString *)studentId {
    return [Net_Path fullPath:@"course/classes/{id}/student/{user_id}" repalceArray:@[@"{id}",@"{user_id}"] byRepleceArray:@[courseId,studentId]];
}

/** banner图 */
+ (NSString *)commenBannerInfoNet {
    return [Net_Path fullPath:@"config/banner" repalce:@"" byReplece:@""];
}

/** 我的授课 */
+ (NSString *)myTeacherCourseNet:(NSString *)courseType {
    return [Net_Path fullPath:@"user/teacher/course/{type}" repalce:@"{type}" byReplece:courseType];
}

/** 凭证校验 */
+ (NSString *)checkVoucher:(NSString *)orderNumber {
    return [Net_Path fullPath:@"user/balance/applepay/{order_no}/order" repalce:@"{order_no}" byReplece:orderNumber];
}

+ (NSString *)userVerifyMoneyPwNet {
    return [Net_Path fullPath:@"user/balance/pwd/verify" repalce:@"" byReplece:@""];
}

+ (NSString *)verifyOldMoneyPwNet {
    return [Net_Path fullPath:@"user/balance/pwd/before" repalce:@"" byReplece:@""];
}

/** money密码设置 */
+ (NSString *)moneyPwSetNet {
    return [Net_Path fullPath:@"user/balance/pwd" repalce:@"" byReplece:@""];
}

/** 分享内容接口 */
+ (NSString *)shareContentInfoNet {
    return [Net_Path fullPath:@"share/info" repalce:@"" byReplece:@""];
}

/** 考试主页面板块儿接口 */
+ (NSString *)examMainPageNet {
    return [Net_Path fullPath:@"exam/module/list" repalce:@"" byReplece:@""];
}

/** 知识点列表 */
+ (NSString *)examPointListNet {
    return [Net_Path fullPath:@"exam/point/category" repalce:@"" byReplece:@""];
}

/** 知识点选择类型后请求练习题号ID列表接口 */
+ (NSString *)examPointIdListNet {
    return [Net_Path fullPath:@"exam/point/prictice/basic" repalce:@"" byReplece:@""];
}

/** 通过题号请求知识点题型详情接口 */
+ (NSString *)examPointDetailDataNet {
    return [Net_Path fullPath:@"exam/point/prictice/topic" repalce:@"" byReplece:@""];
}

/** 知识点提交答案接口 post */
+ (NSString *)examPointPostAnswerNet {
    return [Net_Path fullPath:@"exam/point/prictice/topic" repalce:@"" byReplece:@""];
}

/** 专项练习列表 */
+ (NSString *)specialExamList {
    return [Net_Path fullPath:@"exam/special/list" repalce:@"" byReplece:@""];
}

/** 专项练习搜索接口 */
+ (NSString *)specialExamSearchListNet {
    return [Net_Path fullPath:@"exam/special/search" repalce:@"" byReplece:@""];
}

/** 专项练习试题题号ID列表接口 */
+ (NSString *)specialExamIdListNet {
    return [Net_Path fullPath:@"exam/special/base" repalce:@"" byReplece:@""];
}

/** 专项练习试题详情 通过题号ID请求接口获取 */
+ (NSString *)specialExamDetailDataNet {
    return [Net_Path fullPath:@"exam/special/topic" repalce:@"" byReplece:@""];
}

/** 专项练习提交答案接口 post */
+ (NSString *)specialExamPostAnswerNet {
    return [Net_Path fullPath:@"exam/special/topic" repalce:@"" byReplece:@""];
}

/** 公开考试列表 */
+ (NSString *)openingExamListNet {
    return [Net_Path fullPath:@"exam/paper/list" repalce:@"" byReplece:@""];
}

/** 公开考试列表搜索接口 */
+ (NSString *)openingExamListSearchNet {
    return [Net_Path fullPath:@"exam/paper/search" repalce:@"" byReplece:@""];
}

/** 公开考试分类接口 */
+ (NSString *)openingExamCategoryNet {
    return [Net_Path fullPath:@"exam/paper/category" repalce:@"" byReplece:@""];
}

/** 公开考试整套试卷每道题ID */
+ (NSString *)openingExamIdListNet {
    return [Net_Path fullPath:@"exam/paper/base" repalce:@"" byReplece:@""];
}

/** 公开考试获取试题 */
+ (NSString *)openingExamDetailNet {
    return [Net_Path fullPath:@"exam/paper/topic" repalce:@"" byReplece:@""];
}

/** 试卷提交答案 */
+ (NSString *)submitPaperNet {
    return [Net_Path fullPath:@"exam/paper/answer" repalce:@"" byReplece:@""];
}

/** 考试收藏 */
+ (NSString *)examCollectionNet {
    return [Net_Path fullPath:@"exam/topic/collect" repalce:@"" byReplece:@""];
}

/** 考试收藏列表 */
+ (NSString *)examCollectionListNet {
    return [Net_Path fullPath:@"exam/topic/collect/list" repalce:@"" byReplece:@""];
}

/** 考试错题本 */
+ (NSString *)examWrongListNet {
    return [Net_Path fullPath:@"exam/topic/wrong/list" repalce:@"" byReplece:@""];
}

/** 错题本获取试题 */
+ (NSString *)examWrongDetailNet {
    return [Net_Path fullPath:@"exam/topic/wrong" repalce:@"" byReplece:@""];
}

/** 公共获取试题 */
/*
 origin
 5
 必填
 Number
 来源【1：知识点；2：专项；3：考试；4：套卷；5错题；6：收藏；】
 */
+ (NSString *)examPublicDetailNet {
    return [Net_Path fullPath:@"exam/topic" repalce:@"" byReplece:@""];
}

/** 考试获取资格 */
+ (NSString *)examGetByMoney {
    return [Net_Path fullPath:@"order/exam" repalce:@"" byReplece:@""];
}

/** 公开考试订单生成 */
+ (NSString *)examOrderNet {
    return [Net_Path fullPath:@"order/exam/paper" repalce:@"" byReplece:@""];
}

/** 专项列表订单生成 */
+ (NSString *)examSpecialOrderNet {
    return [Net_Path fullPath:@"order/exam/special" repalce:@"" byReplece:@""];
}

/** 套卷练习订单生成 */
+ (NSString *)examVolumeOrderNet {
    return [Net_Path fullPath:@"order/exam/rollup" repalce:@"" byReplece:@""];
}

/** 套卷搜索接口 */
+ (NSString *)setOfVolumeSearchNet {
    return [Net_Path fullPath:@"exam/rollup/search" repalce:@"" byReplece:@""];
}

/** 套卷列表接口 */
+ (NSString *)setOfVolumeListNet {
    return [Net_Path fullPath:@"exam/rollup/list" repalce:@"" byReplece:@""];
}

/** 套卷详情接口 */
+ (NSString *)volumePaperDetailNet {
    return [Net_Path fullPath:@"exam/rollup/detail" repalce:@"" byReplece:@""];
}

/** 砍价活动详情 */
+ (NSString *)kanjiaDetailInfoNet {
    return [Net_Path fullPath:@"promotion/bargain/detail" repalce:@"" byReplece:@""];
}

/** 好友砍价详情 */
+ (NSString *)kanjiaDetailByFriendNet {
    return [Net_Path fullPath:@"promotion/bargain/doit" repalce:@"" byReplece:@""];
}

@end
