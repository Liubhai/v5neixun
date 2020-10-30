//
//  LiveRoomViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

#import "TICManager.h"
#import "MinEducationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveRoomViewController : BaseViewController<TICEventListener, TICMessageListener>

@property (strong, nonatomic) NSString *classId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *teacherId;
@property (strong, nonatomic) NSString *liveTitle;

@property (strong, nonatomic) UIView *liveBackView;

@property (strong, nonatomic) UIView *topBlackView;
@property (strong, nonatomic) UIView *bottomBlackView;

@property (strong, nonatomic) UIView *topToolBackView;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIButton *cameraBtn;
@property (strong, nonatomic) UIButton *voiceBtn;
@property (strong, nonatomic) UIButton *lianmaiBtn;

@property (strong, nonatomic) UIView *bottomToolBackView;
@property (strong, nonatomic) UIButton *fullScreenBtn;
@property (strong, nonatomic) UIButton *roomPersonCountBtn;

@property (strong, nonatomic) UIView *teacherFaceBackView;// 讲师摄像头 头像背景图
@property (strong, nonatomic) UICollectionView *collectionView;// 学生摄像头列表
@property (strong, nonatomic) NSString *course_live_type;// 大小班课
@property (strong, nonatomic) NSString *userIdentify;// 当前进入直播间的用户的身份(讲师或者普通观看者)

@property (assign, nonatomic) BOOL showBoardView;// 是否配置了白板

@property (nonatomic, strong) MinEducationManager *educationManager;

@end

NS_ASSUME_NONNULL_END
