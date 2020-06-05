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

+ (NSString *)fullPath:(NSString *)path repalceArray:(NSArray *)replace byRepleceArray:(NSArray *)byReplace;

+ (NSString *)fullPath:(NSString *)path repalce:(NSString *)replace byReplece:(NSString *)byReplace;

/** app初始化信息 */
+ (NSString *)appConfig;

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

/** 设置密码 */
+ (NSString *)userSetPwPath:(NSString *)userId;

/** 修改密码 */
+ (NSString *)userEditPwPath;

/** 短信验证 */
+ (NSString *)userVerifyPath:(NSString *)userId;

/** 测试接口 */
+ (NSString *)testApiPath;

/** 课程详情数据接口 */
+ (NSString *)courseInfo:(NSString *)courseId;

/** 课程课时目录列表 */
+ (NSString *)courseList:(NSString *)courseId pid:(NSString *)pid;

/** 课程主页课程列表 */
+ (NSString *)courseMainList;

/** 短信验证码 */
+ (NSString *)smsCodeSend;

/** 用户修改手机号 */
+ (NSString *)userAccountChangePhone;

/** 搜索课程 */
+ (NSString *)searchCourse;

/** 课程种类 */
+ (NSString *)coursetypeList;

/** 课程f分类 */
+ (NSString *)courseClassifyList;

/** 课程点评列表或者点评l课程 */
+ (NSString *)courseCommentList:(NSString *)courseId;

/** 点评的评论列表 */
+ (NSString *)courseCommentReplayList:(NSString *)commentId;

/** 笔记列表 */
+ (NSString *)courseNoteList:(NSString *)courseId;

/** 用户信息编辑 */
+ (NSString *)userInfoEdition;

/** 点评点赞 */
+ (NSString *)zanComment:(NSString *)commentId;

/** 点评回复的点赞 */
+ (NSString *)zanCommentReplay:(NSString *)commentReplayId;

+ (NSString *)verifyImageExit;

+ (NSString *)uploadImageField;
/** 课时笔记列表 */
+ (NSString *)courseHourseNoteList;
/** 添加课时笔记 */
/**
 course_id 课程ID
 course_type 课程类型【1：点播；2：直播；3：面授；4：班级；】
 section_id 课时ID
 content 笔记内容
 */
+ (NSString *)addCourseHourseNote;

/** 修改笔记 */
+ (NSString *)modificationCourseNote:(NSString *)noteId;

/** 获取当前登录的用户信息 */
+ (NSString *)currentLoginUserInfo;

/** 课程订单信息 */
+ (NSString *)courseOrderInfo;

/** 单课时购买信息 */
+ (NSString *)courseHourseOrderInfo;

/** 用户领取的机构卡券列表 */
+ (NSString *)couponsUserList;

/** 机构下的卡券 */
+ (NSString *)schoolCouponList;

/** 课程详情卡券入口 */
+ (NSString *)courseCouponList;

/** 用户领取的课程卡券 */
+ (NSString *)courseCouponUserList;

/** 领取 */
+ (NSString *)getWhichCoupon:(NSString *)couponId;

/** 生成订单 */
+ (NSString *)creatSingleOrder;

/** 成员信息 */
+ (NSString *)userMemberInfo;

/** 余额信息 */
+ (NSString *)userBalanceInfo;

/** 余额明细 */
+ (NSString *)userBalanceDetailInfo;

/** 收入明细 */
+ (NSString *)userIncomeDetailInfo;

/** 余额配置信息 */
+ (NSString *)userPayInfo;

/** 购物车信息 */
+ (NSString *)userShopcarInfo;

/** 订单—购物车信息
 和生成订单y同一接口 只是请求方式不同
 */
+ (NSString *)shopcarOrderInfo;

/** 添加课程到购物车 */
+ (NSString *)addCourseIntoShopcar;

/** 从购物车删除课程 */
+ (NSString *)deleteCourseFromShopcar;

/** 给钱了兄弟 */
+ (NSString *)subMitOrder;

/** 用户订单 */
+ (NSString *)userOrderList:(NSString *)orderListType;

/** 用户信息 */
+ (NSString *)userCenterInfo;

/** 我的卡券 */
+ (NSString *)myCouponsList:(NSString *)couponType;

/** 兑换 */
+ (NSString *)couponExchange;

/** 添加学习记录 */
+ (NSString *)addRecord;

/** 学习记录列表 */
+ (NSString *)learnRecordList;

/** 学习主页数据 */
+ (NSString *)studyMainPageData;

/** 学习主页 加入的课程 */
+ (NSString *)studyMainPageJoinCourseList;

/** 直播用户登录所需信息 */
+ (NSString *)liveLoginInfo;

@end

NS_ASSUME_NONNULL_END
