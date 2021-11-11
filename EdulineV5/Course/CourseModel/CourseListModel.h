//
//  CourseListModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CourseListModel,section_data_model,section_rate_model,live_rate_model,section_CCLive;

@interface CourseListModel : NSObject

/**
 "id": 3,
 "name": "测试课时1-2",
 "pid": 1,
 "course_id": 1,
 "is_charge": 1,
 "price": "0.00",
 "status": 1,
 "level": 2,
 "child": []
 "start_time": 1598422680,
 "end_time": 1598425200,
 //
 {
     "course_id" = 1;
     "has_child" = 1;
     id = 1;
     "is_charge" = 1;
     name = "\U6d4b\U8bd5\U7ae0\U82821";
     pid = 0;
     price = "0.00";
     status = 1;
 }
 */

@property (strong, nonatomic) NSString *classHourId;
@property (strong, nonatomic) NSString *section_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *course_id;
@property (assign, nonatomic) BOOL is_charge;
@property (strong, nonatomic) NSString *price;
@property (assign, nonatomic) BOOL status;
@property (assign, nonatomic) BOOL has_child;
@property (assign, nonatomic) BOOL is_buy;
@property (assign, nonatomic) BOOL is_course_buy;// 该课时所属课程是否已经购买了
@property (assign, nonatomic) unsigned int audition;
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *course_type;
@property (strong, nonatomic) NSString *course_type_text;
@property (strong, nonatomic) section_data_model *section_data;
@property (strong, nonatomic) section_rate_model *section_rate;
@property (strong, nonatomic) live_rate_model *live_rate;
@property (strong, nonatomic) section_CCLive *section_live;

@property (nonatomic, weak)   CourseListModel *parentItem;
@property (nonatomic, strong) NSMutableArray<CourseListModel *> *childItems;
@property (nonatomic, assign) BOOL isLeaf;       // 是否叶子节点
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, strong) NSString *parentID;  // 父级节点唯一标识
@property (nonatomic, strong) NSString *orderNo;   // 序号
@property (nonatomic, strong) NSString *type;      // 类型

@property (assign, nonatomic) BOOL isMainPage; // yes 详情页面目录 no 播放页面目录
@property (assign, nonatomic) BOOL isPlaying; // yes 正在播放 no


@end

@interface section_data_model : NSObject
/*
"id": 2,
"title": "视频课件1",
"uid": 1,
"attach_id": 15,
"status": 1,
"data_type": 1,
"data_type_text": "视频",
"fileurl": "http://eduline-t.oss-cn-shenzhen.aliyuncs.com/upload/20200403/397f6d579183329d921b683f4016ae43.mp4?OSSAccessKeyId=LTAI4FcRKUNNtncbdrPXNsar&Expires=1588982304&Signature=g8kLTQX78PQElpRRXCT6dApiXQc%3D"
*/

@property (strong, nonatomic) NSString *fileId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *attach_id;
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSString *data_type;
@property (strong, nonatomic) NSString *data_type_text;
@property (strong, nonatomic) NSString *fileurl;
@property (strong, nonatomic) NSString *data_txt;

@end

@interface section_rate_model : NSObject
/*
"rate": 19,
"status": 999,//学习状态【957：未开始；999：学习中；992：已完成；】
"status_text": "学习中",
"current_time": 43
*/
@property (assign, nonatomic) unsigned int rate;//评论数量
@property (assign, nonatomic) unsigned int status;//评论数量
@property (assign, nonatomic) unsigned int current_time;//评论数量
@property (strong, nonatomic) NSString *status_text;//评论数量
@end

@interface live_rate_model : NSObject

@property (strong, nonatomic) NSArray *callback_url;//评论数量
@property (strong, nonatomic) NSString *status_text;//评论数量
@property (assign, nonatomic) unsigned int status;//评论数量

@end

/** CC直播 */
@interface section_CCLive : NSObject

/**
 "room_no": 24, //课时ID，声网房间ID
 "course_id": 4, //课程ID
 "live_type": 2, //直播方类型【1：声网；2：CC；】
 "cc_userid": "56761A7379431808", //CC账户ID
 "cc_room_id": "774F73163829E5D29C33DC5901307461", //直播间ID
 "authtype": 0, //验证方式【0：接口验证；1：密码验证；2：免密码验证】
 "attach_id": null,
 "cc_replay": "", //CC回放
 "create_time": 1607689317,
 "close_time": null,
 "update_time": 1607689317,
 "data_type": 1
 */

@property (strong, nonatomic) NSString *room_no;//课时ID，声网房间ID
@property (strong, nonatomic) NSString *course_id;//课程ID
@property (strong, nonatomic) NSString *live_type;//直播方类型【1：声网；2：CC；3:CC云课堂】
@property (strong, nonatomic) NSString *cc_userid;//CC账户ID
@property (strong, nonatomic) NSString *cc_room_id;//直播间ID
@property (strong, nonatomic) NSString *authtype;//验证方式【0：接口验证；1：密码验证；2：免密码验证】
@property (strong, nonatomic) NSString *attach_id;//
@property (strong, nonatomic) NSString *cc_replay;//CC回放
@property (strong, nonatomic) NSString *create_time;//
@property (strong, nonatomic) NSString *close_time;//
@property (strong, nonatomic) NSString *update_time;//
@property (strong, nonatomic) NSString *data_type;//CC回放
@property (strong, nonatomic) NSString *cc_replay_id;//CC回放ID

@end

NS_ASSUME_NONNULL_END
