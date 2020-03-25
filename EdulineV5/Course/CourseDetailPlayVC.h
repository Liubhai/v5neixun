//
//  CourseDetailPlayVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseDetailPlayVC : BaseViewController

@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong ,nonatomic)NSString         *ID;
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

@end

NS_ASSUME_NONNULL_END
