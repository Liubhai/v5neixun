//
//  CourseDetailPlayVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^userFaceCourseDetailVerify)(BOOL result);
typedef void(^userFaceCourseNewDetailVerify)(BOOL result);
typedef void(^userFaceCourseRecordDetailVerify)(BOOL result);
typedef void(^userFaceCourseAutoDetailVerify)(BOOL result);

typedef void(^userAlertCourseRecordDetailVerify)(BOOL result);

typedef void(^userExamPopCourseRecordDetailVerify)(BOOL result);

@interface CourseDetailPlayVC : BaseViewController

@property (nonatomic, strong) userFaceCourseDetailVerify userFaceCourseDetailVerifyResult;
@property (nonatomic, strong) userFaceCourseNewDetailVerify userFaceCourseNewDetailVerifyResult;
@property (nonatomic, strong) userFaceCourseRecordDetailVerify userFaceCourseRecordDetailVerifyResult;
@property (nonatomic, strong) userFaceCourseAutoDetailVerify userFaceCourseAutoDetailVerifyResult;

@property (nonatomic, strong) userAlertCourseRecordDetailVerify userAlertCourseRecordDetailVerifyResult;

@property (nonatomic, strong) userExamPopCourseRecordDetailVerify userExamPopCourseRecordDetailVerifyResult;

@property (assign, nonatomic) BOOL isLive;//是不是直播  区分直播详情页和其他类型详情页

@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong ,nonatomic)NSDictionary   *recent_learn_Source;
@property (assign, nonatomic) BOOL shouldContinueLearn;
@property (strong, nonatomic) CourseListModel *currentPlayModel;// 从详情页传递过来的直接播放的当前课时信息
@property (assign, nonatomic) BOOL isFromLearnRecord; // 是不是从学习记录跳转进播放页
@property (strong ,nonatomic)NSString         *ID;
@property (strong ,nonatomic)NSString         *currentHourseId;
@property (strong ,nonatomic)NSString         *previousHourseId;
/** 是不是活动(由列表传入) */
@property (assign, nonatomic) BOOL isEvent;
/// 学习记录里面传过来的课时id
@property (strong, nonatomic) NSString *sid;
@property (strong ,nonatomic)NSString         *videoTitle;
@property (strong ,nonatomic)NSString         *imageUrl;
@property (strong ,nonatomic)NSString         *price;
@property (strong ,nonatomic)NSString         *videoUrl;
@property (strong ,nonatomic)NSString         *schoolID;

//营销数据的标识
@property (strong ,nonatomic)NSString         *orderSwitch;
@property (assign, nonatomic) BOOL canScroll;

/** 视频播放了之后整个外部tableview就不允许滚动了 */
@property (assign, nonatomic) BOOL canScrollAfterVideoPlay;

//@property (nonatomic, strong) AVCVideoConfig *config;

@property (assign, nonatomic) BOOL isClassNew;//是不是班级课

@property (strong ,nonatomic)UIView   *videoView;//视频的地方

@property (strong, nonatomic) NSString *courselayer; // 1 一层 2 二层 3 三层(涉及到目录布局)
@property (strong, nonatomic) NSString *courseType;


@property (strong, nonatomic) NSDictionary *originCommentInfo;

/** 记笔记弹框 */
- (void)makePopView;

@end

NS_ASSUME_NONNULL_END
