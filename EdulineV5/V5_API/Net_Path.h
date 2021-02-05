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

// MARK: - 登录配置
+ (NSString *)appLoginTypeConfigNet;

// MARK: - 游客模式登录
+ (NSString *)touristLoginNet;

// MARK: - login
+ (NSString *)otherTypeLogin;

+ (NSString *)otherTypeBindNet;

// MARK: - 另外登录配置
+ (NSString *)appthirdloginTypeConfigNet;

/** 排版布局配置信息 */
+ (NSString *)layoutConfig;

/** 声网配置信息接口  */
+ (NSString *)shengwangConfig;

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

/** 课程收藏取消收藏 */
/**
 source_type
 video
 必填
 资源类型【video、live、offline、classes、exams、goods、topic】
 source_id
 1
 必填
 资源ID
 */
+ (NSString *)courseCollectionNet;

/** 个人中心收藏列表 */
+ (NSString *)userCollectionListNet;

/** 批量取消收藏 */
+ (NSString *)unCollectNet;

/** 课程课时目录列表 */
+ (NSString *)courseList:(NSString *)courseId pid:(NSString *)pid;

/** 课时链接信息 */
+ (NSString *)courseHourseUrlNet:(NSString *)courseId pid:(NSString *)pid;

/** 班级课目录列表 */
+ (NSString *)classCourseList:(NSString *)classCourseId;

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

// MARK: - 免费课程加入学习
+ (NSString *)joinFreeCourseNet;

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

/** 成员记录 */
+ (NSString *)userMemberRecord;

// MARK: - 余额收入积分
/** 余额信息 */
+ (NSString *)userBalanceInfo;

/** 余额充值生成订单 */
+ (NSString *)balanceOrderCreate;

/** 收入明细 */
+ (NSString *)userIncomeDetail;

/** 积分明细 */
+ (NSString *)userScoreDetail;

/** 余额明细 */
+ (NSString *)userBalanceDetailInfo;

/** 收入明细 */
+ (NSString *)userIncomeDetailInfo;

/** 积分明细 */
+ (NSString *)userScoreDetailInfo;

/** 你懂的 */
+ (NSString *)incomeForMoubao;

/**  */
+ (NSString *)incomeForMouxin;

/** 到余额 */
+ (NSString *)incomeForBalance;

/** 余额配置信息 */
+ (NSString *)userPayInfo;

/** 购物车信息 */
+ (NSString *)userShopcarInfo;

/** 购物车数量 */
+ (NSString *)userShopCarCountNet;

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

/** 取消订单 */
+ (NSString *)cancelOrder;

/** 删除订单 */
+ (NSString *)deleteOrderNet;

/** 用户信息 */
+ (NSString *)userCenterInfo;

/** 我的卡券 */
+ (NSString *)myCouponsList:(NSString *)couponType;

/** 兑换 */
+ (NSString *)couponExchange;

/**
 *课程卡直接兑换
 */
+ (NSString *)couponDirectExchangeNet;

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

/** 声网直播课时信息 */
+ (NSString *)shengwangLiveInfo:(NSString *)liveId;

/** 直播间带货课程列表 */
+ (NSString *)liveCourseListData;

// MARK: - 直播创建成功通知后台
+ (NSString *)noteLiveSucNet;

/** 讲师列表 */
+ (NSString *)teacherList;

/** 讲师主页课程列表 */
+ (NSString *)teacherCourseListInfo:(NSString *)teacherId;

/** 讲师主页信息 */
+ (NSString *)teacherMainInfo:(NSString *)teacherId;

/** 讲师认证信息 */
+ (NSString *)teacherApplyInfoNet;

/** 讲师认证提交 */
+ (NSString *)teacherApplySubmiteNet;

/** 关注和取消关注 */
+ (NSString *)userFollowNet;

/** 粉丝列表 */
+ (NSString *)userFollowListNet;

/** 最近访客  */
+ (NSString *)userLastVisitorList;

/** 机构列表 */
+ (NSString *)institutionListNet;

/** 机构搜索 */
+ (NSString *)institutionSearchNet;

/** 机构主页信息 */
+ (NSString *)institutionMainPageNet:(NSString *)institutionId;

/** 机构课程列表 */
+ (NSString *)institutionCourseListNet:(NSString *)institutionId;

/** 机构认证 */
+ (NSString *)institutionApplyNet;

/** 公共分类接口 默认0【0：课程；1：讲师；2：机构；】 */
+ (NSString *)commonCategoryNet;

// MARK: - 发现页面接口

/** 发现页面数据接口 */
+ (NSString *)findPageNet;

// MARK: - 首页接口

/** 首页接口地址  */
+ (NSString *)homePageInfoNet;

/** 热门搜索 */
+ (NSString *)hotSearchNet;

// MARK: - 意向课程选择
/** 意向课程选择 */
+ (NSString *)favoriteCourseChangeNet;

// MARK: - 协议内容接口
/** 各种协议内容接口 */
+ (NSString *)agreementContentNet:(NSString *)agreementKey;


// MARK: - 资讯相关
/** 资讯主列表 */
+ (NSString *)zixunListPageNet;

/** 资讯详情 */
+ (NSString *)zixunDetailNet:(NSString *)zixunId;

/** 资讯评论提交 */
+ (NSString *)zixunPostComment:(NSString *)zixunId;

/** 资讯评论点赞 */
+ (NSString *)zixunCommentLikeNet:(NSString *)zixunId;

/** 资讯回复评论点赞 */
+ (NSString *)zixunCommentReplayLikeNet:(NSString *)zixunId;

/** 资讯评论 或者 评论回复列表 post get */
+ (NSString *)zixunPostCommentReplay:(NSString *)zixunId;

// MARK: - 我的消息
/** 互动消息 */
+ (NSString *)notifyCommentMessageNet;
/** 提问消息 */
+ (NSString *)notifyQuestionMessageNet;
/** 系统消息 */
+ (NSString *)notifySystemMessageNet;
/** 互动消息 */
+ (NSString *)notifyCourseMessageNet;

// MARK: - 提问会话框内容列表
+ (NSString *)questionChatListNet:(NSString *)chatId;

// MARK: - 提问
+ (NSString *)askQuestionNet;

// MARK: - 提问回复
+ (NSString *)questionReplayNet;

/** 消息设置已读 */
+ (NSString *)messageReadNet;

// MARK: - 任教授课
/** 任教授课列表 */
+ (NSString *)classCourseListNet;

/** 班级课下学员列表 */
+ (NSString *)classCourseStudentListNet:(NSString *)courseId;

/** 移除班级课里面的学员 */
+ (NSString *)removeClassCourseStudent:(NSString *)courseId studentId:(NSString *)studentId;

/** banner 图 接口 */
+ (NSString *)commenBannerInfoNet;

/** 我的授课 */
+ (NSString *)myTeacherCourseNet:(NSString *)courseType;

/** 凭证校验 */
+ (NSString *)checkVoucher:(NSString *)orderNumber;

/** moneyPw 验证手机号 */
+ (NSString *)userVerifyMoneyPwNet;

/** 验证原密码 */
+ (NSString *)verifyOldMoneyPwNet;

/** 密码设置 */
+ (NSString *)moneyPwSetNet;

/** 分享内容接口 */
+ (NSString *)shareContentInfoNet;

/** 考试主页面板块儿接口  */
+ (NSString *)examMainPageNet;

/** 知识点列表 */
+ (NSString *)examPointListNet;

/** 专项列表 */
+ (NSString *)specialExamList;

+ (NSString *)examPointIdListNet;

+ (NSString *)examPointDetailDataNet;

@end

NS_ASSUME_NONNULL_END
