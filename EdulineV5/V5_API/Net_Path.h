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

@end

NS_ASSUME_NONNULL_END
