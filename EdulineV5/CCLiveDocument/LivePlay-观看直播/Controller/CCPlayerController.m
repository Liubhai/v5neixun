//
//  CCPlayerController.m
//  CCLiveCloud
//
//  Created by MacBook Pro on 2018/10/22.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

#import "CCPlayerController.h"
#import "CCSDK/RequestData.h"//SDK
#import "CCSDK/SaveLogUtil.h"//日志
#import "LotteryView.h"//抽奖
#import "NewLotteryView.h"//抽奖2.0
#import "CCPlayerView.h"//视频
#import "CCInteractionView.h"//互动视图
#import "QuestionNaire.h"//第三方调查问卷
#import "QuestionnaireSurvey.h"//问卷和问卷统计
#import "QuestionnaireSurveyPopUp.h"//问卷弹窗
#import "RollcallView.h"//签到
#import "VoteView.h"//答题卡
#import "VoteViewResult.h"//答题结果
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SelectMenuView.h"//更多菜单
#import "AnnouncementView.h"//公告
#import "CCAlertView.h"//提示框
#import "CCProxy.h"
#import "CCClassTestView.h"//随堂测
#import "CCCupView.h"//奖杯
#import "CCPunchView.h"
#import "HDPlayerBaseInfoView.h" //播放器信息view
#import "HDAudioModeView.h"
//#ifdef LockView
#import "CCLockView.h"//锁屏界面
//#endif

/*
*******************************************************
*      去除锁屏界面功能步骤如下：                          *
*  1。command+F搜索   #ifdef LockView                  *
*                                                     *
*  2.删除 #ifdef LockView 至 #endif之间的代码            *
*******************************************************
*/
@interface CCPlayerController ()<RequestDataDelegate,
//#ifdef LIANMAI_WEBRTC
LianMaiDelegate,
//#endif
UIScrollViewDelegate,UITextFieldDelegate,CCPlayerViewDelegate>
#pragma mark - 房间相关参数
@property (nonatomic,copy)  NSString                 * viewerId;//观看者的id
@property (nonatomic,strong)NSTimer                  * userCountTimer;//计算观看人数
@property (nonatomic,strong)NSString                 * roomName;//房间名
@property (nonatomic,strong)RequestData              * requestData;//sdk
#pragma mark - UI初始化
@property (nonatomic,strong)CCPlayerView             * playerView;//视频视图
@property (nonatomic,strong)CCInteractionView        * contentView;//互动视图
@property (nonatomic,strong)SelectMenuView           * menuView;//选择菜单视图
#pragma mark - 抽奖
@property (nonatomic,strong)LotteryView              * lotteryView;//抽奖
@property (nonatomic,strong)NewLotteryView           * nLotteryView;//抽奖2.0
#pragma mark - 问卷
@property (nonatomic,assign)NSInteger                submitedAction;//提交事件
@property (nonatomic,strong)QuestionNaire            * questionNaire;//第三方调查问卷
@property (nonatomic,strong)QuestionnaireSurvey      * questionnaireSurvey;//问卷视图
@property (nonatomic,strong)QuestionnaireSurveyPopUp * questionnaireSurveyPopUp;//问卷弹窗
#pragma mark - 签到
@property (nonatomic,weak)  RollcallView             * rollcallView;//签到
@property (nonatomic,assign)NSInteger                duration;//签到时间
#pragma mark - 答题卡
@property(nonatomic,weak)  VoteView                  * voteView;//答题卡
@property(nonatomic,weak)  VoteViewResult            * voteViewResult;//答题结果
@property(nonatomic,assign)NSInteger                 mySelectIndex;//答题单选答案
@property(nonatomic,strong)NSMutableArray            * mySelectIndexArray;//答题多选答案
#pragma mark - 公告
@property(nonatomic,copy)  NSString                  * gongGaoStr;//公告内容
@property(nonatomic,strong)AnnouncementView          * announcementView;//公告视图

#pragma mark - 随堂测
@property(nonatomic,weak)CCClassTestView             * testView;//随堂测
#pragma mark - 打卡视图
@property(nonatomic,strong)CCPunchView                 * punchView;//打卡
#pragma mark - 提示框
@property (nonatomic,strong)CCAlertView              * alertView;//消息弹窗
//#ifdef LockView
#pragma make - 锁屏界面
@property (nonatomic,strong)CCLockView               * lockView;//锁屏视图
//#endif LockView

@property (nonatomic,assign)BOOL                     isScreenLandScape;//是否横屏
@property (nonatomic,assign)BOOL                     screenLandScape;//横屏
@property (nonatomic,assign)BOOL                     isHomeIndicatorHidden;//隐藏home条
@property (nonatomic,assign)NSInteger                firRoadNum;//房间线路
@property (nonatomic,strong)NSMutableArray           *secRoadKeyArray;//清晰度数组
@property (nonatomic,assign)BOOL                     firstUnStart;//第一次进入未开始直播
@property (nonatomic,assign)BOOL                     pauseInBackGround;//后台播放是否暂停
#pragma mark - 文档显示模式
@property (nonatomic,assign)BOOL                     isSmallDocView;//是否是文档小窗模式
#pragma mark - 跑马灯
@property (nonatomic, assign)BOOL                    openmarquee;//跑马灯开启
@property (nonatomic,strong)HDMarqueeView            *marqueeView;//跑马灯
@property (nonatomic,strong)NSDictionary             *jsonDict;//跑马灯数据

@property (nonatomic,assign)BOOL                     isLivePlay;//直播间是否已开启
/** 记录切换ppt缩放模式 */
@property (nonatomic, assign)NSInteger               pptScaleMode;
/** 随堂测数据 */
@property (nonatomic, copy) NSMutableDictionary      *testDict;
/** 提示 */
@property (nonatomic, strong)InformationShowView     *informationView;
/** 隐藏私聊 */
@property (nonatomic, assign)BOOL                    isHiddenPrivateChat;
/** 抽奖2.0 抽奖订单ID */
@property (nonatomic, copy) NSString                 *nLotteryId;
/** 提示窗 */
@property (nonatomic,strong)InformationShowView      *tipView;
/** 是否收到抽奖完成得回调 */
@property (nonatomic,assign)BOOL                     isnLotteryComplete;
/** 结束推流的状态 */
@property (nonatomic,assign)BOOL                    endNormal;
/** 播放器信息view */
@property (nonatomic,strong)HDPlayerBaseInfoView    *playerBaseInfoView;
/** 是否是在卡顿 */
@property (nonatomic,assign)BOOL                    isPlayerLoadStateStalled;
/** 播放失败 */
@property (nonatomic,assign)BOOL                    isPlayFailed;
/** 当前选择的清晰度下标 */
@property (nonatomic, assign) NSInteger             qualityIndex;

@property (nonatomic,assign)NSInteger                audioLineNum;//音频线路
/** 视音频模式 */
@property (nonatomic,assign)BOOL                     isAudioMode;

@property (nonatomic, strong) HDAudioModeView        *audioModeView;
/** 是否需要显示提示view */
@property (nonatomic, assign) BOOL                   isShowBaseInfoView;
/** 当前线路下标 */
@property (nonatomic, assign) NSInteger              currentLineIndex;

@end
@implementation CCPlayerController
//初始化
- (instancetype)initWithRoomName:(NSString *)roomName {
    self = [super init];
    if(self) {
        self.roomName = roomName;
    }
    return self;
}
//启动
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    /*  设置后台是否暂停 ps:后台支持播放时将会开启锁屏播放器 */
    _pauseInBackGround = NO;
    _isLivePlay = NO;
    _qualityIndex = 0;//默认清晰度下标
    _currentLineIndex = 0;
    [self setupUI];//创建UI
    [self integrationSDK];//集成SDK
    [self addObserver];//添加通知
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObserver];//移除通知
}

/**
 *    @brief    创建UI
 */
- (void)setupUI {
    /*   设置文档显示类型    YES:表示文档小窗模式   NO:文档在下模式  */
    _isSmallDocView = YES;
    //视频视图
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(HDGetRealHeight);
        make.top.equalTo(self.view).offset(SCREEN_STATUS);
    }];
    
    //添加互动视图
    [self.view addSubview:self.contentView];
    
    self.playerView.isChatActionKeyboard = YES;
    self.contentView.isChatActionKeyboard = YES;
}
/**
 *    @brief    集成sdk
 */
- (void)integrationSDK {
    UIView *docView = _isSmallDocView ? self.playerView.smallVideoView : self.contentView.docView;
    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = @"56761A7379431808";
    parameter.roomId = @"BBC10038C0C26ECD9C33DC5901307461";
    parameter.viewerName = @"普通人";//观看者昵称
    parameter.token = @"524550";//登陆密码
//    parameter.userId = GetFromUserDefaults(WATCH_USERID);//userId
//    parameter.roomId = GetFromUserDefaults(WATCH_ROOMID);//roomId
//    parameter.viewerName = GetFromUserDefaults(WATCH_USERNAME);//用户名
//    parameter.token = GetFromUserDefaults(WATCH_PASSWORD);//密码
    // 1.默认视频小窗
    parameter.playerParent = docView;
    parameter.playerFrame = CGRectMake(0,0,docView.frame.size.width, docView.frame.size.height);//文档位置,ps:起始位置为文档视图坐标
    // 2.默认文档大窗
    parameter.docParent = self.playerView.hdContentView;//视频视图
    parameter.docFrame = CGRectMake(0,0,self.playerView.frame.size.width, self.playerView.frame.size.height);//视频位置,ps:起始位置为视频视图坐标
    parameter.security = YES;//是否使用https(已弃用!)
    parameter.PPTScalingMode = 4;//ppt展示模式,建议值为4
    parameter.defaultColor = @"FFFFFF";//ppt默认底色，不写默认为白色
    parameter.scalingMode = 1;//屏幕适配方式
    parameter.pauseInBackGround = _pauseInBackGround;//后台是否暂停
    parameter.viewerCustomua = @"viewercustomua";//自定义参数,没有的话这么写就可以
    parameter.pptInteractionEnabled = YES;
    parameter.DocModeType = 0;//设置当前的文档模式
    parameter.groupid = _contentView.groupId;//用户的groupId
    parameter.tpl = 20;
    _pptScaleMode = parameter.PPTScalingMode;
    _requestData = [[RequestData alloc] initWithParameter:parameter];
    _requestData.delegate = self;
    /** 开启防录屏功能 */
    [_requestData setAntiRecordScreen:YES];
}

#pragma mark - 私有方法
/**
 *    @brief    发送聊天
 *    @param    str   聊天内容
 */
- (void)sendChatMessageWithStr:(NSString *)str {
    [_requestData chatMessage:str];
}
#pragma mark - 主动切换清晰度 & 线路
/**
 *    @brief    展示切换线路结果
 *    @param    result   //0 切换成功 -1切换失败 -2 切换频繁
 */
- (void)showTextWithIndex:(NSInteger)result
{
    NSString *showTitle = @"";
    NSString *index = [NSString stringWithFormat:@"%zd",result];
    if ([index isEqualToString:@"0"]) {
        showTitle = PLAY_MODE_CHANGE_SUCCESS;
    }else if ([index isEqualToString:@"-1"]) {
        showTitle = PLAY_MODE_CHANGE_ERROR;
    }else if ([index isEqualToString:@"-2"]) {
        showTitle = PLAY_MODE_CHANGE_TIMEOUT;
    }
    [self showTipInfomationWithTitle:showTitle];
}

- (void)showTipInfomationWithTitle:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenTipView) object:nil];
        if (self.tipView) {
            [self.tipView removeFromSuperview];
        }
        self.tipView = [[InformationShowView alloc] initWithLabel:title];
        [APPDelegate.window addSubview:self.tipView];
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hiddenTipView) userInfo:nil repeats:NO];
    });
}

/**
 *    @brief    更新音频视图UI
 */
- (void)updateUIWithAudioMode {
    if (_isAudioMode != YES) return;
    if (self.audioModeView) {
        [self.audioModeView removeFromSuperview];
        self.audioModeView = nil;
    }
    if (self.requestData.ijkPlayer) {
        self.audioModeView = [[HDAudioModeView alloc]initWithFrame:self.requestData.ijkPlayer.view.bounds];
        [self.requestData.ijkPlayer.view addSubview:self.audioModeView];
        [self.requestData.ijkPlayer.view bringSubviewToFront:self.audioModeView];
    }
}
/**
 *    The New Method (3.14.0)
 *    @brief    是否开启音频模式
 *    @param    hasAudio   HAVE_AUDIO_LINE_TURE 有音频 HAVE_AUDIO_LINE_FALSE 无音频
 *
 *    触发回调条件 1.初始化SDK登录成功后
 */
- (void)HDAudioMode:(HAVE_AUDIO_LINE)hasAudio {
    [self.playerView HDAudioMode:hasAudio];
}
/**
 *    The New Method (3.14.0)
 *    @brief    房间所包含的清晰度 (会多次回调)
 *    @param    dict    清晰度数据
 *    清晰度数据  key(包含的键值)              type(数据类型)             description(描述)
 *              qualityList(清晰度列表)      array                     @[HDQualityModel(清晰度详情),HDQualityModel(清晰度详情)]
 *              currentQuality(当前清晰度)   object                    HDQualityModel(清晰度详情)
 *
 *    触发回调条件 1.初始化SDK登录成功后
 *               2.主动调用切换清晰度方法
 *               3.主动调用切换视频模式回调
 */
- (void)HDReceivedVideoQuality:(NSDictionary *)dict {
    [self.playerView HDReceivedVideoQuality:dict];
}
/**
 *    The New Method (3.14.0)
 *    @brief    房间包含的音视频线路 (会多次回调)
 *    @param    dict   线路数据
 *    线路数据   key(包含的键值)             type(数据类型)             description(描述)
 *              lineList(线路列表)         array                     @[@"line1",@"line2"]
 *              indexNum(当前线路下标)      integer                   0
 *
 *    触发回调条件 1.初始化SDK登录成功后
 *               2.主动调用切换清晰度方法
 *               3.主动调用切换线路方法
 *               4.主动调用切换音视频模式回调
 */
- (void)HDReceivedVideoAudioLines:(NSDictionary *)dict {
    [self.playerView HDReceivedVideoAudioLines:dict];
}
/**
 *    @brief    切换音视频模式
 *    @param    isAudio   是否是音频
 */
- (void)changePlayMode:(BOOL)isAudio {
    _isAudioMode = isAudio == YES ? YES : NO;
    WS(ws)
    if (isAudio == YES) {
        [_requestData changePlayMode:PLAY_MODE_TYEP_AUDIO completion:^(NSDictionary *results) {
            NSInteger result = [results[@"success"] integerValue];
            [ws showTextWithIndex:result];
            [ws.playerView updateUITier];
            [ws updateUIWithAudioMode];
        }];
    }else {
        [_requestData changePlayMode:PLAY_MODE_TYEP_VIDEO completion:^(NSDictionary *results) {
            NSInteger result = [results[@"success"] integerValue];
            [ws showTextWithIndex:result];
            [ws.playerView updateUITier];
        }];
    }
}
/**
 *    @brief    切换线路
 *    @param    rodIndex   线路
 */
- (void)selectedRodWidthIndex:(NSInteger)rodIndex {
    WS(ws)
    [_requestData changeLine:rodIndex completion:^(NSDictionary *results) {
        NSInteger result = [results[@"success"] integerValue];
        [ws showTextWithIndex:result];
        [ws.playerView updateUITier];
        if (ws.isAudioMode == YES) {
            [ws updateUIWithAudioMode];
        }
    }];
}
/**
 *    @brief    切换清晰度
 *    @param    quality    清晰度
 */
- (void)selectedQuality:(NSString *)quality {
    WS(ws)
    [_requestData changeQuality:quality completion:^(NSDictionary *results) {
        NSInteger result = [results[@"success"] integerValue];
        [ws showTextWithIndex:result];
        [ws.playerView updateUITier];
    }];
}
/**
 *    @brief    更新视频状态提示view
 */
- (void)updatePlayerBaseInfoViewWithCompletion:(void (^)(BOOL result))completion
{
    if (self.isAudioMode == YES || self.isShowBaseInfoView != YES || !self.requestData.ijkPlayer) return;
    if (self.playerBaseInfoView && self.playerBaseInfoView.superview != nil) {
        [self.playerBaseInfoView updatePlayerBaseInfoViewWithFrame:self.requestData.ijkPlayer.view.frame];
    }else {
        if (self.playerBaseInfoView) {
            [self.playerBaseInfoView removeFromSuperview];
            self.playerBaseInfoView = nil;
        }
        self.playerBaseInfoView = [[HDPlayerBaseInfoView alloc]initWithFrame:self.requestData.ijkPlayer.view.frame];
        [self.requestData.ijkPlayer.view addSubview:self.playerBaseInfoView];
        [self.requestData.ijkPlayer.view bringSubviewToFront:self.playerBaseInfoView];
        WS(weakSelf)
        self.playerBaseInfoView.actionBtnClickBlock = ^(NSString * _Nonnull string) {
            weakSelf.isShowBaseInfoView = YES;
            [weakSelf.playerBaseInfoView showTipStrWithType:HDPlayerBaseInfoViewTypeWithhRetry withTipStr:PLAY_RETRY];
            [weakSelf.requestData reloadVideo:NO];
        };
    }
    if (completion) {
        completion(YES);
    }
}
/**
 *    @brief    显示答题卡和随堂测
 *    @param    type   1 答题卡 0 随堂测
 */
- (void)updateVoteAndTestWithType:(NSInteger)type
{
    if (type == 1) {
        [self.voteView updateUIWithScreenLandScape:self.screenLandScape];
        [self.voteView show];
    }else {
        [self.testView updateTestViewWithScreenlandscape:self.screenLandScape];
        [self.testView show];
    }
}

#pragma mark - playViewDelegate 以及相关方法
/**
 *    @brief    点击切换视频/文档按钮
 *    @param    tag    1为视频为主，2为文档为主
 */
- (void)changeBtnClicked:(NSInteger)tag {
    if (tag == 2) {
        [_requestData changeDocParent:self.playerView.hdContentView];
        [_requestData changePlayerParent:self.playerView.smallVideoView];
        [_requestData changePlayerFrame:CGRectMake(0, 0, self.playerView.smallVideoView.frame.size.width, self.playerView.smallVideoView.frame.size.height)];
        [_requestData changeDocFrame:CGRectMake(0, 0,self.playerView.frame.size.width, self.playerView.frame.size.height)];
    }else{
        [_requestData changeDocParent:self.playerView.smallVideoView];
        [_requestData changePlayerParent:self.playerView.hdContentView];
        [_requestData changePlayerFrame:CGRectMake(0, 0,self.playerView.frame.size.width, self.playerView.frame.size.height)];
        [_requestData changeDocFrame:CGRectMake(0, 0, self.playerView.smallVideoView.frame.size.width, self.playerView.smallVideoView.frame.size.height)];
    }
    [self.playerView bringSubviewToFront:self.marqueeView];
    [self.playerView updateUITier];
    [self updateUIWithAudioMode];
    if (self.requestData.ijkPlayer) {
        [self updatePlayerBaseInfoViewWithCompletion:nil];
    }
}
/**
 *    @brief    点击全屏按钮代理
 *    @param    tag   1为视频为主，2为文档为主
 */
- (void)quanpingButtonClick:(NSInteger)tag {
    [self.view endEditing:YES];
    [APPDelegate.window endEditing:YES];
    [self.contentView.chatView resignFirstResponder];
    [self othersViewHidden:YES];
    if (tag == 1) {
        [_requestData changePlayerFrame:self.view.frame];
    } else {
        [_requestData changeDocFrame:self.view.frame];
    }
    if (self.requestData.ijkPlayer) {
        [self updatePlayerBaseInfoViewWithCompletion:nil];
    }
    [self updateUIWithAudioMode];
    WS(ws)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws.marqueeView startMarquee];
    });
    self.screenLandScape = YES;
    if (self.playerView.templateType != 1) {    
        [self.playerView updateVoteWithLandScapeWithCompletion:^(BOOL result) {
            [ws.voteView updateUIWithScreenLandScape:result];
        }];
        [self.playerView updateTestWithLandScapeWithCompletion:^(BOOL result) {
            [ws.testView updateTestViewWithScreenlandscape:result];
        }];
    }
}
/**
 *    @brief    点击退出按钮(返回竖屏或者结束直播)
 *    @param    sender backBtn
 *    @param tag changeBtn的标记，1为视频为主，2为文档为主
 */
- (void)backButtonClick:(UIButton *)sender changeBtnTag:(NSInteger)tag{
    WS(ws)
    if (sender.tag == 2) {//横屏返回竖屏
        self.screenLandScape = NO;
        [self othersViewHidden:NO];
        if (tag == 1) {
            [_requestData changePlayerFrame:CGRectMake(0, 0, SCREEN_WIDTH, HDGetRealHeight)];
        } else {
            [_requestData changeDocFrame:CGRectMake(0, 0, SCREEN_WIDTH, HDGetRealHeight)];
        }
        if (self.playerView.templateType != 1) {
            [self.contentView updateVoteAndTestWithPortraitWithCompletion:^(BOOL result) {
                [ws.testView updateTestViewWithScreenlandscape:result];
                [ws.voteView updateUIWithScreenLandScape:result];
            }];
        }
        if (self.requestData.ijkPlayer) {
            [self updatePlayerBaseInfoViewWithCompletion:nil];
        }
        WS(ws)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playerView.backButton.userInteractionEnabled = YES;
            [ws.marqueeView startMarquee];
        });
        [self updateUIWithAudioMode];
    }else if( sender.tag == 1){//结束直播
        [self creatAlertController_alert];
    }
}
/**
 *    @brief    隐藏其他视图,当点击全屏和退出全屏时调用此方法
 *    @param    hidden   是否隐藏
 */
- (void)othersViewHidden:(BOOL)hidden {
    self.screenLandScape = hidden;//设置横竖屏
    self.contentView.chatView.ccPrivateChatView.hidden = hidden;//隐藏聊天视图
    self.isScreenLandScape = YES;//支持旋转
    [self interfaceOrientation:hidden? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
    self.isScreenLandScape = NO;//不支持旋转
    self.contentView.hidden = hidden;//隐藏互动视图
    [self.menuView hiddenMenuViews:hidden];
    self.announcementView.hidden = hidden;//隐藏公告视图
    if (!hidden) {//更新新消息
        [_menuView updateMessageFrame];
    }
}
/**
 *    @brief    创建提示窗
 */
- (void)creatAlertController_alert {

    WS(ws)
    CCAlertView *alertView = [[CCAlertView alloc] initWithAlertTitle:ALERT_EXITPLAY sureAction:SURE cancelAction:CANCEL sureBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (ws.lockView) {
                [ws.lockView removeFromSuperview];
                ws.lockView = nil;
            }
            [ws exitPlayLive];
            ws.playerView.backButton.enabled = NO;
        });
    }];
    [APPDelegate.window addSubview:alertView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.playerView.backButton.userInteractionEnabled = YES;
    });
}
/**
 *    @brief    退出直播
 */
- (void)exitPlayLive {
    [self stopTimer];
    [self.requestData requestCancel];
    self.requestData = nil;
    if (self.playerView.smallVideoView) {
        [self.playerView.smallVideoView removeFromSuperview];
    }
    if (self.contentView) {
        //移除聊天
        [self.contentView removeChatView];
        [_announcementView removeFromSuperview];
    }
    //移除多功能菜单
    if (self.menuView) {
        [self.menuView removeFromSuperview];
        [self.menuView removeAllInformationView];
    }
    //#ifdef LIANMAI_WEBRTC
    if (_playerView.lianMaiView) {
        [_playerView removeLianMaiView];
    }
    //#endif
    WS(ws)
    [self dismissViewControllerAnimated:YES completion:^{
        [ws.playerView removeFromSuperview];
        ws.playerView = nil;
        [ws.contentView removeFromSuperview];
        ws.contentView = nil;
        ws.playerView.delegate = nil;
        ws.requestData.delegate = nil;
    }];
}

#pragma mark - SDK 必须实现的代理方法
/**
 *    @brief    请求成功
 */
- (void)requestSucceed {

}
/**
 *    @brief    登录请求失败
 */
- (void)requestFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    // 添加提示窗,提示message
    [self addBanAlertView:message];
}

#pragma mark- 功能代理方法 用哪个实现哪个-----
/**
 *    @brief    播放器初始化完成 (会多次回调)
 */
- (void)HDMediaPlaybackIsPreparedToPlayDidChange:(NSDictionary *)dict {
    [self updatePlayerBaseInfoViewWithCompletion:nil];
}
/**
 *    @brief    视频状态改变
 *    @param    state
 *              HDMoviePlaybackStateStopped          播放停止
 *              HDMoviePlaybackStatePlaying          开始播放
 *              HDMoviePlaybackStatePaused           暂停播放
 *              HDMoviePlaybackStateInterrupted      播放间断
 *              HDMoviePlaybackStateSeekingForward   播放快进
 *              HDMoviePlaybackStateSeekingBackward  播放后退
 */
- (void)HDMoviePlayBackStateDidChange:(HDMoviePlaybackState)state
{
    switch (state)
    {
        case HDMoviePlaybackStateStopped: {
            break;
        }
        case HDMoviePlaybackStatePlaying:{
            self.isPlayerLoadStateStalled = NO; //重试卡顿状态
            self.isShowBaseInfoView = NO;
            self.isPlayFailed = NO; //重置播放失败状态
//            [self.playerBaseInfoView showTipStrWithType:HDPlayerBaseInfoViewTypeHidden withTipStr:@""];
            if (self.playerBaseInfoView) {
                [self.playerBaseInfoView removeFromSuperview];
                self.playerBaseInfoView = nil;
            }
            
            if (_playerView.loadingView) {
                [_playerView.loadingView removeFromSuperview];
            }
            [[SaveLogUtil sharedInstance] saveLog:@"" action:SAVELOG_ALERT];
            //#ifdef LockView
            if (_pauseInBackGround == NO) {//添加锁屏视图
                if (!_lockView) {
                    _lockView = [[CCLockView alloc] initWithRoomName:_roomName duration:_requestData.ijkPlayer.duration];
                    [self.view addSubview:_lockView];
                }else{
                    [_lockView updateLockView];
                }
            }
            //#endif
            break;
        }
        case HDMoviePlaybackStatePaused:{
            break;
        }
        case HDMoviePlaybackStateInterrupted: {
            break;
        }
        case HDMoviePlaybackStateSeekingForward:
        case HDMoviePlaybackStateSeekingBackward: {
            break;
        }
        default: {
            break;
        }
    }
}
/**
 *    @brief    视频加载状态
 *    @param    state   播放状态
 *              HDMovieLoadStateUnknown         未知状态
 *              HDMovieLoadStatePlayable        视频未完成全部缓存，但已缓存的数据可以进行播放
 *              HDMovieLoadStatePlaythroughOK   完成缓存
 *              HDMovieLoadStateStalled         数据缓存已经停止，播放将暂停
 */
- (void)HDMovieLoadStateDidChange:(HDMovieLoadState)state
{
    switch (state)
    {
        case HDMovieLoadStateUnknown:
            break;
        case HDMovieLoadStatePlayable:
            break;
        case HDMovieLoadStatePlaythroughOK:
            break;
        case HDMovieLoadStateStalled:{
            self.isPlayerLoadStateStalled = YES;
        }break;
        default:
            break;
    }
}
/**
 *  @brief  获取ppt当前页数和总页数 (会多次回调)
 *
 *  回调当前翻页的页数信息
 *  白板docTotalPage一直为0, pageNum从1开始
 *  其他文档docTotalPage为正常页数,pageNum从0开始
 *  @param dictionary 翻页信息
 */
- (void)onPageChange:(NSDictionary *)dictionary {
 
}
/**
 *    @brief     获取所有文档列表 需要调用getDocsList
 */
- (void)receivedDocsList:(NSDictionary *)listDic {

}
/**
 *    @brief    双击PPT
 */
- (void)doubleCllickPPTView {
    if (_isLivePlay == NO) return;
    if (_screenLandScape) {//如果是横屏状态下
        _screenLandScape = NO;
        _isScreenLandScape = YES;
        // 新增方法 --> 处理全屏双击PPT退出全屏操作，统一由PlayView管理
        // 注：该方法不影响连麦操作
        [_playerView backBtnClickWithTag:2];
        //#ifdef LIANMAI_WEBRTC
        if([_playerView exsitRmoteView]) {
            [_playerView removeRmoteView];
            [_playerView.smallVideoView addSubview:_playerView.remoteView];
            _playerView.remoteView.frame = [_playerView calculateRemoteVIdeoRect:CGRectMake(0, 0, _playerView.smallVideoView .frame.size.width, _playerView.smallVideoView .frame.size.height)];
            // 设置远程连麦窗口的大小，连麦成功后调用才生效，连麦不成功调用不生效
            [_requestData setRemoteVideoFrameA:_playerView.remoteView.frame];
        }
        //#endif
    }else{
        _screenLandScape = YES;
        _isScreenLandScape = YES;
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [UIApplication sharedApplication].statusBarHidden = YES;
        _isScreenLandScape = NO;
        // 新增方法 --> 处理双击PPT进入全屏操作，统一由PlayView管理
        // 注：该方法不影响连麦操作
        [_playerView quanpingBtnClick];
        
        //#ifdef LIANMAI_WEBRTC
        if([_playerView exsitRmoteView]) {
            [_playerView removeRmoteView];
            [_playerView.smallVideoView addSubview:_playerView.remoteView];
            _playerView.remoteView.frame = [_playerView calculateRemoteVIdeoRect:CGRectMake(0, 0, _playerView.smallVideoView.frame.size.width, _playerView.smallVideoView.frame.size.height)];
            // 设置远程连麦窗口的大小，连麦成功后调用才生效，连麦不成功调用不生效
            [_requestData setRemoteVideoFrameA:_playerView.remoteView.frame];
        }
        //#endif
    }
}
#pragma mark - 房间信息
/**
 *    @brief  获取房间信息，主要是要获取直播间模版来类型，根据直播间模版类型来确定界面布局
 *    房间简介：dic[@"desc"];
 *    房间名称：dic[@"name"];
 *    房间模版类型：[dic[@"templateType"] integerValue];
 *    模版类型为1: 聊天互动： 无 直播文档： 无 直播问答： 无
 *    模版类型为2: 聊天互动： 有 直播文档： 无 直播问答： 有
 *    模版类型为3: 聊天互动： 有 直播文档： 无 直播问答： 无
 *    模版类型为4: 聊天互动： 有 直播文档： 有 直播问答： 无
 *    模版类型为5: 聊天互动： 有 直播文档： 有 直播问答： 有
 *    模版类型为6: 聊天互动： 无 直播文档： 无 直播问答： 有
 */
- (void)roomInfo:(NSDictionary *)dic {
    _roomName = dic[@"name"];
    self.openmarquee = [dic[@"openMarquee"] boolValue];
    //添加更多菜单
    [APPDelegate.window addSubview:self.menuView];
    [self.playerView roominfo:dic];
    NSInteger type = [dic[@"templateType"] integerValue];
    if (type == 4 || type == 5) {
        [self.playerView addSmallView];
        self.playerView.isOnlyVideoMode = NO;
    }else {
        // 1.仅有视频模式下 视频显示大窗
        [self changeBtnClicked:1];
        self.playerView.isOnlyVideoMode = YES;
    }
    _isHiddenPrivateChat = NO;
    if ([dic[@"privateChat"] integerValue] == 0) {
        _isHiddenPrivateChat = YES;
        [_menuView hiddenPrivateBtn];
    }
    _contentView.privateChatStatus = [dic[@"privateChat"] integerValue];
    WS(ws)
    _playerView.cleanVoteAndTestBlock = ^(NSInteger type) {
        [ws updateVoteAndTestWithType:type];
    };
    _contentView.cleanVoteAndTestBlock = ^(NSInteger type) {
        [ws updateVoteAndTestWithType:type];
    };
    
     //设置房间信息
    [_contentView roomInfo:dic withPlayView:self.playerView smallView:self.playerView.smallVideoView];
    _playerView.templateType = type;
    if (type != 1) {//如果只有视频的版型，去除menuView;
        _playerView.menuView = _menuView;
    }else {
        if (_menuView) {
            [_menuView removeFromSuperview];
            _menuView = nil;
        }
        return;
    }
    if (type == 6) {//去除私聊按钮
        [_menuView hiddenPrivateBtn];
    }
}
#pragma mark - 获取直播开始时间和直播时长
/**
 *  @brief  获取直播开始时间和直播时长
 *  liveDuration 直播持续时间，单位（s），直播未开始返回-1"
 *  liveStartTime 新增开始直播时间（格式：yyyy-MM-dd HH:mm:ss），如果直播未开始，则返回空字符串
 */
- (void)startTimeAndDurationLiveBroadcast:(NSDictionary *)dataDic {
    SaveToUserDefaults(LIVE_STARTTIME, dataDic[@"liveStartTime"]);
    //当第一次进入时为未开始状态,设置此属性,在直播开始时给startTime赋值
    if ([dataDic[@"liveStartTime"] isEqualToString:@""] && !self.firstUnStart) {
        self.firstUnStart = YES;
    }
}
#pragma mark- 收到在线人数
/**
 *    @brief    收到在线人数
 */
- (void)onUserCount:(NSString *)count {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerView.userCountLabel.text = count;
    });
}

#pragma mark - 打卡功能
/**
 *    @brief    移除打卡视图
 */
- (void)removePunchView {
    if (_punchView) {
        [_punchView removeFromSuperview];
        _punchView = nil;
    }
}
/**
 *    @brief    打卡功能
 *    @param    dic   打卡数据
 */
- (void)hdReceivedStartPunchWithDict:(NSDictionary *)dic {
    
    if (_punchView) {
        [_punchView removeFromSuperview];
    }
    WS(weakSelf)
    self.punchView = [[CCPunchView alloc] initWithDict:dic punchBlock:^(NSString * punchid) {
        [weakSelf.requestData hdCommitPunchWithPunchId:punchid];
    } isScreenLandScape:self.isScreenLandScape];
    self.punchView.commitSuccess = ^(BOOL success) {
        [weakSelf removePunchView];
    };
    [APPDelegate.window addSubview:self.punchView];
    _punchView.frame = [UIScreen mainScreen].bounds;
    
    [self showRollCallView];
}
/**
 *    @brief    收到结束打卡
 *    dic{ "punchId": "punchId"}
 */
- (void)hdReceivedEndPunchWithDict:(NSDictionary *)dic {
    [self.punchView updateUIWithFinish:dic];
}
/**
 *    @brief    收到打卡提交结果
 *    dic{
 *    "success": true,
 *    "data": {"isRepeat": false//是否重复提交打卡 }
 }
 */
- (void)hdReceivedPunchResultWithDict:(NSDictionary *)dic {
    [self.punchView updateUIWithDic:dic];
}
#pragma mark - 服务器端给自己设置的信息
/**
 *    @brief    服务器端给自己设置的信息
 *    viewerId 服务器端给自己设置的UserId
 *    groupId 分组id
 *    name 用户名
 */
- (void)setMyViewerInfo:(NSDictionary *) infoDic {
    _viewerId = infoDic[@"viewerId"];
    [_contentView setMyViewerInfo:infoDic];
}
#pragma mark - 聊天管理
/**
 *    @brief    聊天管理
 *    status    聊天消息的状态 0 显示 1 不显示
 *    chatIds   聊天消息的id列列表
 */
- (void)chatLogManage:(NSDictionary *) manageDic {
    [_contentView chatLogManage:manageDic];
}
#pragma mark - 聊天
/**
 *    @brief    收到私聊信息
 *    @param    dic {fromuserid         //发送者用户ID
 *                   fromusername       //发送者用户名
 *                   fromuserrole       //发送者角色
 *                   msg                //消息内容
 *                   time               //发送时间
 *                   touserid           //接受者用户ID
 *                   tousername         //接受者用户名}
 */
- (void)OnPrivateChat:(NSDictionary *)dic {
    if (_isHiddenPrivateChat != YES) {    
        [_contentView OnPrivateChat:dic withMsgBlock:^{
            [self.menuView showInformationViewWithTitle:NewPrivateMessage];
        }];
    }
}
/**
 *    @brief  历史聊天数据 (会多次回调)
 *    @param  chatLogArr [{ chatId         //聊天ID
                           content         //聊天内容
                           groupId         //聊天组ID
                           time            //时间
                           userAvatar      //用户头像
                           userId          //用户ID
                           userName        //用户名称
                           userRole        //用户角色}]
 */
- (void)onChatLog:(NSArray *)chatLogArr {
    [_contentView onChatLog:chatLogArr];
}
/*
 *  @brief  收到公聊消息
 *  @param  message {  groupId         //聊天组ID
                       msg             //消息内容
                       time            //发布时间
                       useravatar      //用户头像
                       userid          //用户ID
                       username        //用户名称
                       userrole        //用户角色}
 */
- (void)onPublicChatMessage:(NSDictionary *)dic {
    [_contentView onPublicChatMessage:dic];
}
/**
 *  @brief  接收到发送的广播
 *  @param  dic {content     //广播内容
                 userid      //发布者ID
                 username    //发布者名字
                 userrole    //发布者角色 }
 */
- (void)broadcast_msg:(NSDictionary *)dic {
    [_contentView broadcast_msg:dic];
}
/*
 *  @brief  收到自己的禁言消息，如果你被禁言了，你发出的消息只有你自己能看到，其他人看不到
 *  @param  message {  groupId         //聊天组ID
                       msg             //消息内容
                       time            //发布时间
                       useravatar      //用户头像
                       userid          //用户ID
                       username        //用户名称
                       userrole        //用户角色}
 */
- (void)onSilenceUserChatMessage:(NSDictionary *)message {
    [_contentView onSilenceUserChatMessage:message];
}
/**
 *    @brief    历史广播数组
 *    @param    array   历史广播数组
 *              array [{
                           content         //广播内容
                           userid          //发布者ID
                           username        //发布者名字
                           userrole        //发布者角色
                           createTime      //绝对时间
                           time            //相对时间(相对直播)
                           id              //广播ID }]
 */
- (void)broadcastLast_msg:(NSArray *)array {
    [_contentView broadcastLast_msg:array];
}

/**
*    @brief    删除广播
*    @param    dic   广播信息
*              dic {action             //操作 1.删除
                    id                 //广播ID }
*/
- (void)broadcast_delete:(NSDictionary *)dic {
    [_contentView broadcast_delete:dic];
}
#pragma mark - 禁言
/**
 *    @brief    当主讲全体禁言时，你再发消息，会出发此代理方法，information是禁言提示信息
 */
- (void)information:(NSString *)information {
    //添加提示窗
    [self addBanAlertView:information];
}
/**
 *    @brief  收到踢出消息，停止推流并退出播放（被主播踢出）
 *            dictionary[@"kick_out_type"] 踢出类型
 *            dictionary[@"viewerid"]      用户ID
 *            kick_out_type: 踢出类型
 *                           10 在允许重复登录前提下，后进入者会登录会踢出先前登录者
 *                           20 讲师、助教、主持人通过页面踢出按钮踢出用户
  *
 */
- (void)onKickOut:(NSDictionary *)dictionary {
    if ([_viewerId isEqualToString:dictionary[@"viewerid"]]) {
        WS(weakSelf)
        CCAlertView *alert = [[CCAlertView alloc] initWithAlertTitle:ALERT_KICKOUT sureAction:SURE cancelAction:nil sureBlock:^{
            [weakSelf exitPlayLive];
        }];
        [APPDelegate.window addSubview:alert];
    }
}

#pragma mark - 问答
/**
 *    @brief    发布问答的id
 */
- (void)publish_question:(NSString *)publishId {
    [_contentView publish_question:publishId];
}
/**
 *    @brief  收到提问，用户观看时和主讲的互动问答信息
 *    @param  questionDic { groupId         //分组ID
                            content         //问答内容
                            userName        //问答用户名
                            userId          //问答用户ID
                            time            //问答时间
                            id              //问答主键ID
                            useravatar      //用户化身 }
 */
- (void)onQuestionDic:(NSDictionary *)questionDic {
    [_contentView onQuestionDic:questionDic];
}
/**
 *    @brief  收到回答
 *    @param  answerDic {content            //回复内容
                         userName           //用户名
                         questionUserId     //问题用户ID
                         time               //回复时间
                         questionId         //问题ID
                         isPrivate          //1 私聊回复 0 公聊回复 }
 */
- (void)onAnswerDic:(NSDictionary *)answerDic{
    [_contentView onAnswerDic:answerDic];
}
/**
 *    @brief  收到历史提问&回答 （会多次回调）
 *    @param  questionArr [{content             //问答内容
                            encryptId           //加密ID
                            groupId             //分组ID
                            isPublish           //1 发布的问答 0 未发布的问答
                            questionUserId      //问答用户ID
                            questionUserName    //问答用户名
                            time                //问答时间
                            triggerTime         //问答具体时间}]
 *    @param  answerArr  [{answerUserId         //回复用户ID
                           answerUserName       //回复名
                           answerUserRole       //回复角色（主讲、助教）
                           content              //回复内容
                           encryptId            //加密ID
                           groupId              //分组ID
                           isPrivate            //1 私聊回复 0 公共回复
                           time = 135;          //回复时间
                           triggerTime          //回复具体时间}]
 */
- (void)onQuestionArr:(NSArray *)questionArr onAnswerArr:(NSArray *)answerArr{
    [_contentView onQuestionArr:questionArr onAnswerArr:answerArr];
}
/**
 *    @brief    提问
 *    @param    message 提问内容
 */
- (void)question:(NSString *)message {
    [_requestData question:message];
}
#pragma mark - 直播未开始和开始
- (NSMutableArray *)secRoadKeyArray
{
    if (!_secRoadKeyArray) {
        _secRoadKeyArray = [NSMutableArray array];
    }
    return _secRoadKeyArray;
}
#pragma mark- 直播未开始和开始
/**
 *    @brief  收到播放直播状态 0.正在直播 1.未开始直播
 */
- (void)getPlayStatue:(NSInteger)status {
    [_playerView getPlayStatue:status];
    //直播状态
    _isLivePlay = status == 0 ? YES : NO;
    if (status == 0 && self.firstUnStart) {
        NSDate *date = [NSDate date];// 获得时间对象
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [forMatter stringFromDate:date];
        SaveToUserDefaults(LIVE_STARTTIME, dateStr);
    }
    if (status == 0) {
        // 收到播放直播状态后重新获取随堂测(断网重连后需要重新获取)
        [_requestData getPracticeInformation:@""];
        // 抽奖2.0 查询抽奖状态
        [_requestData queryLotteryStatus];
        if (!_questionnaireSurvey) {
            // 查询正在进行中的问卷
            [_requestData getPublishingQuestionnaire];
        }
        // 打卡
        if (!_punchView) {
            [_requestData hdInquirePunchInformation];
        }
    } else {

    }
}
#pragma mark - 开始结束直播
/**
 *    @brief  主讲开始推流
 */
- (void)onLiveStatusChangeStart {
    [_playerView onLiveStatusChangeStart];
}
/**
 *    @brief  停止直播，endNormal表示是否停止推流
 */
- (void)onLiveStatusChangeEnd:(BOOL)endNormal {
    // 开始播放更新提示语状态
    if (self.playerBaseInfoView) {
        [self.playerBaseInfoView removeFromSuperview];
        self.playerBaseInfoView = nil;
    }
    _isLivePlay = NO; //直播停止
    if (self.punchView) {
        [self removePunchView];
    }
    [_playerView onLiveStatusChangeEnd:endNormal];
}
#pragma mark - 抽奖2.0
/**
 *    @brief    抽奖2.0 抽奖状态
 *    @param    model   NewLotteryMessageModel 详情
 */
- (void)HDOnLotteryWithModel:(NewLotteryMessageModel *)model
{
    WS(ws)
    /** 1.抽奖1.0存在 移除抽奖1.0 */
    if (_lotteryView) {
        [_lotteryView removeFromSuperview];
    }
    /** 2.当前没有正在进行的抽奖,并且当前不在抽奖完成页面 */
    if (model.type == NEW_LOTTERY_NULL && _isnLotteryComplete == NO) { //无抽奖
        if (_nLotteryView) {
            [_nLotteryView removeFromSuperview];
        }
    }else if (model.type == NEW_LOTTERY_BEGIN) { //开始抽奖
        _isnLotteryComplete = NO;
        if (_nLotteryView) {
            [_nLotteryView removeFromSuperview];
        }
        self.nLotteryView = [[NewLotteryView alloc] initIsScreenLandScape:self.screenLandScape clearColor:NO];
        [APPDelegate.window addSubview:self.nLotteryView];
        _nLotteryView.frame = [UIScreen mainScreen].bounds;
        _nLotteryView.closeBlock = ^(BOOL result) {
            [ws.nLotteryView endEditing:YES];
            ws.nLotteryView.hidden = YES;
        };
    }else if (model.type == NEW_LOTTERY_CANCEL) { //抽奖取消
        _isnLotteryComplete = NO;
        [self.nLotteryView remove];
        CCAlertView *alertView = [[CCAlertView alloc] initWithAlertTitle:NEWLOTTERY_CANCEL sureAction:SURE cancelAction:nil sureBlock:^{
            ws.playerView.isChatActionKeyboard = YES;
            ws.contentView.isChatActionKeyboard = YES;
        }];
        [APPDelegate.window addSubview:alertView];
    }else if (model.type == NEW_LOTTERY_COMPLETE) { //抽奖结束
        _nLotteryId = model.infos[@"lotteryId"];
        _isnLotteryComplete = YES;
        [_nLotteryView nLottery_resultWithModel:model isScreenLandScape:self.screenLandScape];
        self.playerView.isChatActionKeyboard = NO;
        self.contentView.isChatActionKeyboard = NO;
        /** 提交中奖信息数据 */
        _nLotteryView.contentBlock = ^(NSArray * _Nonnull array) {
            [ws.requestData commitLottery:array lotteryId:ws.nLotteryId completion:^(BOOL success) {
                ws.playerView.isChatActionKeyboard = YES;
                ws.contentView.isChatActionKeyboard = YES;
                if (success) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:ws selector:@selector(hiddenTipView) object:nil];
                    if (ws.tipView) {
                        [ws.tipView removeFromSuperview];
                    }
                    ws.tipView = [[InformationShowView alloc] initWithLabel:NEWLOTTERY_COMMINT_SUCCESS];
                    [APPDelegate.window addSubview:ws.tipView];
                    [ws.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                    ws.isnLotteryComplete = NO;
                    [ws closeLotteryView];
                    [NSTimer scheduledTimerWithTimeInterval:2.0f target:ws selector:@selector(hiddenTipView) userInfo:nil repeats:NO];
                    return;
                }else {
                    ws.nLotteryView.isAgainCommit = YES; // 提交失败能够再次提交
                    [NSObject cancelPreviousPerformRequestsWithTarget:ws selector:@selector(hiddenTipView) object:nil];
                    if (ws.tipView) {
                        [ws.tipView removeFromSuperview];
                    }
                    ws.tipView = [[InformationShowView alloc] initWithLabel:NEWLOTTERY_COMMINT_ERROR];
                    [APPDelegate.window addSubview:ws.tipView];
                    [ws.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                    [NSTimer scheduledTimerWithTimeInterval:2.0f target:ws selector:@selector(hiddenTipView) userInfo:nil repeats:NO];
                    return;
                }
            }];
        };
        /** 抽奖关闭按钮 */
        _nLotteryView.closeBlock = ^(BOOL result) {
            ws.playerView.isChatActionKeyboard = YES;
            ws.contentView.isChatActionKeyboard = YES;
            if (result == NO) {
                CCAlertView *alertView = [[CCAlertView alloc] initWithAlertTitle:NEWLOTTERY_NOCOMMINT_TIP sureAction:SURE cancelAction:CANCEL sureBlock:^{
                    [ws.nLotteryView endEditing:YES];
                    [ws.nLotteryView remove];
                    ws.isnLotteryComplete = NO;
                }];
                [APPDelegate.window addSubview:alertView];
                return;
            }else {
                ws.isnLotteryComplete = NO;
                [ws.nLotteryView endEditing:YES];
                [ws.nLotteryView remove];
            }
        };
    }else if (model.type == NEW_LOTTERY_EXIT) { //抽奖异常
        CCAlertView *alertView = [[CCAlertView alloc] initWithAlertTitle:NEWLOTTERY_CANCEL sureAction:SURE cancelAction:nil sureBlock:^{
            ws.playerView.isChatActionKeyboard = YES;
            ws.contentView.isChatActionKeyboard = YES;
            ws.isnLotteryComplete = NO;
        }];
        [APPDelegate.window addSubview:alertView];
    }
}
/**
 *    @brief    抽奖2.0 关闭抽奖
 */
- (void)closeLotteryView {
    [_nLotteryView remove];
}

- (void)hiddenTipView {
    if (_tipView) {
        [_tipView removeFromSuperview];
        _tipView = nil;
    }
}
#pragma mark - 加载视频失败
/**
 *  @brief  加载视频失败
 */
- (void)play_loadVideoFail {
    self.isPlayFailed = YES;
    WS(ws)
    if (self.playerBaseInfoView) {
        [self.playerBaseInfoView removeFromSuperview];
        self.playerBaseInfoView = nil;
    }
    self.isShowBaseInfoView = YES;
    [self updatePlayerBaseInfoViewWithCompletion:^(BOOL result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *type = ws.isAudioMode == YES ? AUDIO_ERROR : PLAY_ERROR;
            [ws.playerBaseInfoView showTipStrWithType:HDPlayerBaseInfoViewTypeWithError withTipStr:type];
        });
    }];
}
#pragma mark - 聊天禁言
/**
 *    @brief    收到聊天禁言
 *    mode      禁言类型 1：个人禁言  2：全员禁言
 */
- (void)onBanChat:(NSDictionary *) modeDic {
    NSInteger mode = [modeDic[@"mode"] integerValue];
    NSString *str = ALERT_BANCHAT(mode == 1);
    //添加禁言弹窗
    [self addBanAlertView:str];
}
/**
 *    @brief    收到聊天禁言并删除聊天记录
 *    viewerId  禁言用户id,是自己的话别删除聊天历史,其他人需要删除该用户的聊天
 */
- (void)onBanDeleteChat:(NSDictionary *)viewerDic {
    [_contentView onBanDeleteChatMessage:viewerDic];
}
/**
 *    @brief    收到解除禁言事件
 *    mode      禁言类型 1：个人禁言  2：全员禁言
 */
- (void)onUnBanChat:(NSDictionary *) modeDic {
    NSInteger mode = [modeDic[@"mode"] integerValue];
    NSString *str = ALERT_UNBANCHAT(mode == 1);
    //添加禁言弹窗
    [self addBanAlertView:str];
}
#pragma mark - 进出直播间提示
/**
 *    @brief    进出直播间提示
 *    @param    model   提示详情
 */
- (void)HDUserRemindWithModel:(RemindModel *)model {
    NSArray *array = model.clientType;
    if ([array containsObject:@(4)]) {
        [self.contentView HDUserRemindWithModel:model];
    }
}

#pragma mark - 聊天禁言提示
/**
 *    @brief    禁言用户提示
 *    @param    model   BanChatModel    详情
 */
- (void)HDBanChatBroadcastWithModel:(BanChatModel *)model {
    NSString *tipStr = [[NSString alloc]initWithFormat:@"用户:%@%@",model.userName,@"被禁言"];
    if (_informationView) {
        [_informationView removeFromSuperview];
        _informationView = [[InformationShowView alloc] initWithLabel:tipStr];
    }
    [self.view addSubview:_informationView];
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInformationView) userInfo:nil repeats:NO];
}

#pragma mark - 移除提示信息
- (void)removeInformationView {
    if (_informationView) {
        [_informationView removeFromSuperview];
        _informationView = nil;
    }
}

#pragma mark - 视频或者文档大窗
/**
 *  @brief  视频或者文档大窗
 *  isMain  1为视频为主,0为文档为主"
 */
- (void)onSwitchVideoDoc:(BOOL)isMain {
    if (_isSmallDocView) {
        [_playerView onSwitchVideoDoc:isMain];
    }
}
#pragma mark - 抽奖
/**
 *  @brief  开始抽奖
 */
- (void)start_lottery {
    // 抽奖2.0存在取消抽奖2.0
    if (_nLotteryView) {
        [_nLotteryView removeFromSuperview];
    }
    if (_lotteryView) {
        [_lotteryView removeFromSuperview];
    }
    self.lotteryView = [[LotteryView alloc] initIsScreenLandScape:self.screenLandScape clearColor:NO];
    [APPDelegate.window addSubview:self.lotteryView];
    _lotteryView.frame = [UIScreen mainScreen].bounds;
    [self showRollCallView];
}
/**
 *  @brief  抽奖结果
 *  remainNum   剩余奖品数
 */
- (void)lottery_resultWithCode:(NSString *)code
                        myself:(BOOL)myself
                    winnerName:(NSString *)winnerName
                     remainNum:(NSInteger)remainNum {
    [_lotteryView lottery_resultWithCode:code myself:myself winnerName:winnerName remainNum:remainNum IsScreenLandScape:self.screenLandScape];
}
/**
 *  @brief  退出抽奖
 */
- (void)stop_lottery {
    [self.lotteryView remove];
}
#pragma mark - 问卷及问卷统计
/**
 *  @brief  问卷功能
 */
- (void)questionnaireWithTitle:(NSString *)title url:(NSString *)url {
    //问卷横屏输入事件(区分横屏聊天键盘事件)
    self.playerView.isChatActionKeyboard = NO;
    if (self.questionNaire) {
        //初始化第三方问卷视图
        [self.questionNaire removeFromSuperview];
        self.questionNaire = nil;
    }
    [self.view endEditing:YES];
    self.questionNaire = [[QuestionNaire alloc] initWithTitle:title url:url isScreenLandScape:self.screenLandScape];
//添加第三方问卷视图
    [self addAlerView:self.questionNaire];
}
/**
 *  @brief  提交问卷结果（成功，失败）
 */
- (void)commitQuestionnaireResult:(BOOL)success {
    WS(ws)
    //问卷横屏输入事件(区分横屏聊天键盘事件)
    self.playerView.isChatActionKeyboard = YES;
    [self.questionnaireSurvey commitSuccess:success];
    if(success &&self.submitedAction != 1) {
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:ws selector:@selector(removeQuestionnaireSurvey) userInfo:nil repeats:NO];
    }
}
/**
 *  @brief  发布问卷
 */
- (void)questionnaire_publish {
    [self removeQuestionnaireSurvey];
}
/**
 *  @brief  获取问卷详细内容
 *  @param  detailDic {
            forcibly               //1就是强制答卷，0为非强制答卷
            id                     //问卷主键ID
            subjects               //包含的项目
            submitedAction         //1提交后查看答案，0为提交后不查看答案
            title                  //标题 }
 */
- (void)questionnaireDetailInformation:(NSDictionary *)detailDic {
    [self.view endEditing:YES];
    self.submitedAction     = [detailDic[@"submitedAction"] integerValue];
    //问卷横屏输入事件(区分横屏聊天键盘事件)
    self.playerView.isChatActionKeyboard = NO;
    //初始化问卷详情页面
    self.questionnaireSurvey = [[QuestionnaireSurvey alloc] initWithCloseBlock:^{
        [self removeQuestionnaireSurvey];
    } CommitBlock:^(NSDictionary *dic) {
        //提交问卷结果
        [self.requestData commitQuestionnaire:dic];
    } questionnaireDic:detailDic isScreenLandScape:self.screenLandScape isStastic:NO];
    //添加问卷详情
    [self addAlerView:self.questionnaireSurvey];
}
/**
 *  @brief  结束发布问卷
 */
- (void)questionnaire_publish_stop {
    WS(ws)
    //问卷横屏输入事件(区分横屏聊天键盘事件)
    self.playerView.isChatActionKeyboard = YES;
    [self.questionnaireSurveyPopUp removeFromSuperview];
    self.questionnaireSurveyPopUp = nil;
    if(self.questionnaireSurvey == nil) return;//如果已经结束发布问卷，不需要加载弹窗
    //结束编辑状态
    [self.view endEditing:YES];
    [self.questionnaireSurvey endEditing:YES];
    //初始化结束问卷弹窗
    self.questionnaireSurveyPopUp = [[QuestionnaireSurveyPopUp alloc] initIsScreenLandScape:self.screenLandScape SureBtnBlock:^{
        [ws removeQuestionnaireSurvey];
    }];
    //添加问卷弹窗
    [self addAlerView:self.questionnaireSurveyPopUp];
}
/**
 *  @brief  获取问卷统计
 *  @param  staticsDic {
            forcibly               //1就是强制答卷，0为非强制答卷
            id                     //问卷主键ID
            subjects               //包含的项目
            submitedAction         //1提交后查看答案，0为提交后不查看答案
            title                  //标题 }
 */
- (void)questionnaireStaticsInformation:(NSDictionary *)staticsDic {
    [self.view endEditing:YES];
    if (self.questionnaireSurvey != nil) {
        [self.questionnaireSurvey removeFromSuperview];
        self.questionnaireSurvey = nil;
    }
    //初始化问卷统计视图
    self.questionnaireSurvey = [[QuestionnaireSurvey alloc] initWithCloseBlock:^{
        [self removeQuestionnaireSurvey];
    } CommitBlock:nil questionnaireDic:staticsDic isScreenLandScape:self.screenLandScape isStastic:YES];
    //添加问卷统计视图
    [self addAlerView:self.questionnaireSurvey];
}
#pragma mark - 签到
/**
  *  @brief  开始签到
  */
- (void)start_rollcall:(NSInteger)duration{
    [self removeRollCallView];
    [self.view endEditing:YES];
    self.duration = duration;
    //添加签到视图
    [self addAlerView:self.rollcallView];
    [APPDelegate.window bringSubviewToFront:self.rollcallView];
}
#pragma mark - 答题卡
/**
  *  @brief  开始答题
  */
- (void)start_vote:(NSInteger)count singleSelection:(BOOL)single {
    [self removeVoteView];
    self.mySelectIndex = -1;
    [self.mySelectIndexArray removeAllObjects];
    WS(ws)
    VoteView *voteView = [[VoteView alloc] initWithCount:count singleSelection:single voteSingleBlock:^(NSInteger index) {
        //答单选题
        [ws.requestData reply_vote_single:index];
        ws.mySelectIndex = index;
    } voteMultipleBlock:^(NSMutableArray *indexArray) {
        //答多选题
        [ws.requestData reply_vote_multiple:indexArray];
        ws.mySelectIndexArray = [indexArray mutableCopy];
    } singleNOSubmit:^(NSInteger index) {

    } multipleNOSubmit:^(NSMutableArray *indexArray) {
        
    } isScreenLandScape:self.screenLandScape];
    //收起按钮
    voteView.cleanBlock = ^(BOOL result) {
        [ws updateVoteWithStatus:NO];
    };
    //关闭按钮
    voteView.closeBlock = ^(BOOL result) {
        [ws updateVoteWithStatus:YES];
    };
    
    //避免强引用 weak指针指向局部变量
    self.voteView = voteView;
    
    //添加voteView
    [self addAlerView:self.voteView];
}
/**
 *  @brief  结束答题
 */
- (void)stop_vote {
    [self updateVoteWithStatus:YES];
    [self removeVoteView];
}
/**
  *  @brief  答题结果
  *  @param  resultDic {answerCount         //参与回答人数
                        correctOption       //正确答案 (单选字符串，多选字符串数组)
                        statisics[{         //统计数组
                                    count   //选择当前选项人数
                                    option  //选项序号
                                    percent //正确率
                                    }]
                        voteCount           //题目数量
                        voteId              //题目ID
                        voteType            //题目类型}
  */
- (void)vote_result:(NSDictionary *)resultDic {
    [self updateVoteWithStatus:YES];
    [self removeVoteView];
    VoteViewResult *voteViewResult = [[VoteViewResult alloc] initWithResultDic:resultDic mySelectIndex:self.mySelectIndex mySelectIndexArray:self.mySelectIndexArray isScreenLandScape:self.screenLandScape];
    _voteViewResult = voteViewResult;
    //添加答题结果
    [self addAlerView:self.voteViewResult];
}
#pragma mark - 跑马灯
/**
 *    @brief    跑马灯
 *    @param    dic action  [{                      //事件
                                duration            //执行时间
                                end {               //结束位置
                                        alpha       //透明度
                                        xpos        //x坐标
                                        ypos        //y坐标 },
                                start {             //开始位置
                                        alpha       //透明度
                                        xpos        //x坐标
                                        ypos        //y坐标}]
                    image {                         //包含图片
                                height              //图片高度
                                image_url           //地址
                                width               //图片宽度}
                    loop                            //循环次数 -1 无限循环
                    text   {                        //文字信息
                                 color              //文字颜色
                                 content            //文字内容
                                 font_size          //字体大小}
                    type                            //当前类型 text 文本 image 图片
 */
- (void)receivedMarqueeInfo:(NSDictionary *)dic {
    if (dic == nil || self.openmarquee == NO) {
        return;
    }
    self.jsonDict = dic;
    {

        CGFloat width = 0.0;
        CGFloat height = 0.0;
        self.marqueeView = [[HDMarqueeView alloc]init];
        HDMarqueeViewStyle style = [[self.jsonDict objectForKey:@"type"] isEqualToString:@"text"] ? HDMarqueeViewStyleTitle : HDMarqueeViewStyleImage;
        self.marqueeView.style = style;
        self.marqueeView.repeatCount = [[self.jsonDict objectForKey:@"loop"] integerValue];
        if (style == HDMarqueeViewStyleTitle) {
            NSDictionary * textDict = [self.jsonDict objectForKey:@"text"];
            NSString * text = [textDict objectForKey:@"content"];
            UIColor * textColor = [UIColor colorWithHexString:[textDict objectForKey:@"color"] alpha:1.0f];
            UIFont * textFont = [UIFont systemFontOfSize:[[textDict objectForKey:@"font_size"] floatValue]];
            
            self.marqueeView.text = text;
            self.marqueeView.textAttributed = @{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor};
            CGSize textSize = [self.marqueeView.text calculateRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) Font:textFont WithLineSpace:0];
            width = textSize.width;
            height = textSize.height;
            
        }else{
            NSDictionary * imageDict = [self.jsonDict objectForKey:@"image"];
            NSURL * imageURL = [NSURL URLWithString:[imageDict objectForKey:@"image_url"]];
            self.marqueeView.imageURL = imageURL;
            width = [[imageDict objectForKey:@"width"] floatValue];
            height = [[imageDict objectForKey:@"height"] floatValue];

        }
        self.marqueeView.frame = CGRectMake(0, 0, width, height);
        //处理action
        NSArray * setActionsArray = [self.jsonDict objectForKey:@"action"];
        //跑马灯数据不是数组类型
        if (![setActionsArray isKindOfClass:[NSArray class]]) return;
        NSMutableArray <HDMarqueeAction *> * actions = [NSMutableArray array];
        for (int i = 0; i < setActionsArray.count; i++) {
            NSDictionary * actionDict = [setActionsArray objectAtIndex:i];
            CGFloat duration = [[actionDict objectForKey:@"duration"] floatValue];
            NSDictionary * startDict = [actionDict objectForKey:@"start"];
            NSDictionary * endDict = [actionDict objectForKey:@"end"];

            HDMarqueeAction * marqueeAction = [[HDMarqueeAction alloc]init];
            marqueeAction.duration = duration;
            marqueeAction.startPostion.alpha = [[startDict objectForKey:@"alpha"] floatValue];
            marqueeAction.startPostion.pos = CGPointMake([[startDict objectForKey:@"xpos"] floatValue], [[startDict objectForKey:@"ypos"] floatValue]);
            marqueeAction.endPostion.alpha = [[endDict objectForKey:@"alpha"] floatValue];
            marqueeAction.endPostion.pos = CGPointMake([[endDict objectForKey:@"xpos"] floatValue], [[endDict objectForKey:@"ypos"] floatValue]);
            
            [actions addObject:marqueeAction];
        }
        self.marqueeView.actions = actions;
        self.marqueeView.fatherView = self.playerView;
        self.playerView.layer.masksToBounds = YES;
    }
}
#pragma  mark - 文档加载状态
/**
 *    @brief    文档加载状态
 *    index
 *      0 文档组件初始化完成
 *      1 动画文档加载完成
 *      2 非动画翻页加载成功
 *      3 文档组件加载失败
 *      4 非动画翻页加载失败
 *      5 文档动画加载失败
 *      6 画板加载失败
 *      7 极速动画翻页加载成功
 *      8 极速动画翻页加载失败
 */
- (void)docLoadCompleteWithIndex:(NSInteger)index {
    WS(weakSelf)
    if (index == 0) {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf.playerView addSubview:weakSelf.marqueeView];
             [weakSelf.marqueeView startMarquee];
         });
    }
}
#pragma mark - 公告
/**
 *  @brief  公告
 */
- (void)announcement:(NSString *)str{
    //刚进入时的公告消息
    _gongGaoStr = StrNotEmpty(str) ? str : @"";
}
/**
 *  @brief  监听到有公告消息
 *  @dict   {action         //action 返回release 取出公告内容，action 返回remove 删除公告
             announcement   //公告内容}
 */
- (void)on_announcement:(NSDictionary *)dict {
    //如果当前不在公告页面,提示有新公告
    if (!_announcementView || _announcementView.hidden || _announcementView.frame.origin.y == SCREEN_HEIGHT ) {
        ///收到删除消息的时候不提示
        if([dict[@"action"] isEqualToString:@"release"]) {
            [_menuView showInformationViewWithTitle:NewAnnouncementMessage];
        }
    }
    if([dict[@"action"] isEqualToString:@"release"]) {
        _gongGaoStr = dict[@"announcement"];
    } else if([dict[@"action"] isEqualToString:@"remove"]) {
        _gongGaoStr = @"";
    }
    if(_announcementView) {
        [_announcementView updateViews:self.gongGaoStr];
    }
}
#pragma mark - 缓存速度
- (void)onBufferSpeed:(NSString *)speed
{
    if (self.isPlayerLoadStateStalled == YES && self.isPlayFailed != YES) {
        self.isShowBaseInfoView = YES;
        if (self.playerBaseInfoView) {
            [self.playerBaseInfoView removeFromSuperview];
            self.playerBaseInfoView = nil;
        }
        if (self.requestData.ijkPlayer) {        
            self.playerBaseInfoView = [[HDPlayerBaseInfoView alloc]initWithFrame:self.requestData.ijkPlayer.view.frame];
            [self.requestData.ijkPlayer.view addSubview:self.playerBaseInfoView];
            [self.requestData.ijkPlayer.view bringSubviewToFront:self.playerBaseInfoView];
            NSString *type = self.isAudioMode == YES ? AUDIO_LOADING : PLAY_LOADING;
            speed = speed.length > 0 ? speed : DEFAULT_LOADING_SPEED;
            [self.playerBaseInfoView showTipStrWithType:HDPlayerBaseInfoViewTypeWithOther withTipStr:[NSString stringWithFormat:@"%@%@",type,speed]];
        }
    }
}

#pragma mark - 随堂测
/**
 *    @brief       接收到随堂测 (3.10更改)
 *    rseultDic    随堂测内容
      resultDic    {
                   isExist                        //是否存在正在发布的随堂测 1 存在 0 不存在
                   practice{
                            id                    //随堂测ID
                            isAnswered            //是否已答题 true: 已答题, false: 未答题
                            options               //选项数组
                            ({
                                  id              //选项ID
                                  index           //选项索引
                            })
                            publishTime           //随堂测发布时间
                            status                //随堂测状态: 1 发布中 2 停止发布 3 已关闭
                            type                  //随堂测类型: 0 判断 1 单选 2 多选
                            submitRecord          //如果已答题，返回该学员答题记录，如果未答题，服务端不返回该字段
                            ({
                                optionId          //选项ID
                                optionIndex       //选项索引
                            })
                          }
                   serverTime                     //分发时间
                  }
 *
 */
- (void)receivePracticeWithDic:(NSDictionary *) resultDic {
    // 1.是否存在正在发布的随堂测 或 随堂测的状态为已关闭
    if ([resultDic[@"isExist"] intValue] == 0 || [resultDic[@"practice"][@"status"] intValue] == 3) {
        [self updateTestWithStatus:YES];
        if (_testView) {
            [_testView removeFromSuperview];
            _testView = nil;
        }
        return;//如果不存在随堂测，返回。
    }
    // 2.随堂测是否已答题 或 随堂测已停止
    if ([resultDic[@"practice"][@"isAnswered"] boolValue] == YES || [resultDic[@"practice"][@"status"] intValue] == 2) {
        // practiceId 随堂测ID
        NSString *practiceId = resultDic[@"practice"][@"id"];
        [_requestData getPracticeStatisWithPracticeId:practiceId];
        [self updateTestWithStatus:YES];
    }
    // 3.随堂测未答题显示答题选项
    NSMutableDictionary *dict = [resultDic mutableCopy];
    [dict setObject:@[] forKey:@"answer"];
    self.testDict = dict;
    [self showTestViewIsScreenLandScape:self.screenLandScape];
}
/**
 *    @brief    更新随堂测收起按钮
 *    @param    status   状态
 */
- (void)updateTestWithStatus:(BOOL)status
{
    [self.contentView testUPWithStatus:status];
    [self.playerView testUPWithStatus:status];
}
/**
 *    @brief    更新答题卡收起按钮
 *    @param    status   状态
 */
- (void)updateVoteWithStatus:(BOOL)status
{
    [self.contentView voteUPWithStatus:status];
    [self.playerView voteUPWithStatus:status];
}

/**
 *    @brief    展示随堂测
 *    @param    isScreenLandScape   NO 竖屏 YES 横屏
 */
- (void)showTestViewIsScreenLandScape:(NSInteger)isScreenLandScape {
    if (_testView) {
       [_testView removeFromSuperview];
       [_testView stopTimer];
        _testView = nil;
    }
    [self.view endEditing:YES];
    [APPDelegate.window endEditing:YES];
    //初始化随堂测视图
    CCClassTestView *testView = [[CCClassTestView alloc] initWithTestDic:_testDict isScreenLandScape:self.screenLandScape];
    [APPDelegate.window addSubview:testView];
    self.testView = testView;
    WS(weakSelf)
    self.testView.CommitBlock = ^(NSArray * _Nonnull arr) {//提交答案回调
       [weakSelf.requestData commitPracticeWithPracticeId:_testDict[@"practice"][@"id"] options:arr];
    };
    _testView.StaticBlock = ^(NSString * _Nonnull practiceId) {//获取统计回调
       [weakSelf.requestData getPracticeStatisWithPracticeId:practiceId];
    };
    // 随堂测收起操作
    _testView.cleanBlock = ^(NSMutableDictionary * _Nonnull result) {
        weakSelf.testDict = result;
        [weakSelf updateTestWithStatus:NO];
    };
}


/**
 *    @brief    随堂测提交结果(3.10更改)
 *    rseultDic    提交结果,调用commitPracticeWithPracticeId:(NSString *)practiceId options:(NSArray *)options后执行
 *
      resultDic {datas {practice                                 //随堂测
                             { answerResult                      //回答是否正确 1 正确 0 错误
                               id                                //随堂测ID
                               isRepeatAnswered                  //是否重复答题 true: 重复答题, false: 第一次答题
                               options ({  count                 //参与人数
                                             id                  //选项主键ID
                                             index               //选项序号
                                             isCorrect           //是否正确
                                             percent             //选项占比})
                               submitRecord 如果重复答题，则返回该学员第一次提交的记录，否则，返回该学员当前提交记录
                                            ({ optionId          //提交记录 提交选项ID
                                               optionIndex       //提交选项序号})
                               type                              //随堂测类型: 0 判断 1 单选 2 多选}}}
 */
- (void)practiceSubmitResultsWithDic:(NSDictionary *) resultDic {
    [_testView practiceSubmitResultsWithDic:resultDic];
}
/**
 *    @brief    随堂测统计结果(3.10更改)
 *    rseultDic    统计结果,调用getPracticeStatisWithPracticeId:(NSString *)practiceId后执行
      resultDic  {practice {                                //随堂测
                            answerPersonNum                 //回答该随堂测的人数
                            correctPersonNum                //回答正确的人数
                            correctRate                     //正确率
                            id                              //随堂测ID
                            options ({                      //选项数组
                                        count               //选择该选项的人数
                                        id                  //选项ID
                                        index               //选项序号
                                        isCorrect           //是否为正确选项 1 正确 0 错误
                                        percent             //选择该选项的百分比})
                            status                          //随堂测状态  1 发布中 2 停止发布
                            type                            //随堂测类型: 0 判断 1 单选 2 多选}}
 */
- (void)practiceStatisResultsWithDic:(NSDictionary *) resultDic {
    [self updateTestWithStatus:YES];
    if (_testView) {
        [self.view endEditing:YES];
        [APPDelegate.window endEditing:YES];
    }
    [_testView getPracticeStatisWithResultDic:resultDic isScreen:self.screenLandScape];
}
/**
 *    @brief    停止随堂测(The new method)
 *    rseultDic    结果
 *    resultDic {practiceId //随堂测主键ID}
 */
- (void)practiceStopWithDic:(NSDictionary *) resultDic {
    [self updateTestWithStatus:YES];
    [_testView stopTest];
    [self.requestData getPracticeRankWithPracticeId:resultDic[@"practiceId"]];
}
/**
 *    @brief    关闭随堂测(The new method)
 *    rseultDic    结果
 *    resultDic {practiceId //随堂测主键ID}
 */
- (void)practiceCloseWithDic:(NSDictionary *) resultDic {
    [self updateTestWithStatus:YES];
    //移除随堂测视图
    [_testView removeFromSuperview];
    _testView = nil;
}
/**
 *    @brief    收到奖杯(The new method)
 *    dic       结果
 *    "type":  1 奖杯 2 其他
 *    "viewerName": 获奖用户名
 *    "viewerId": 获奖用户ID
 */
- (void)prize_sendWithDict:(NSDictionary *)dic {
    NSString *name = @"";
    [self.view endEditing:YES];
    [APPDelegate.window endEditing:YES];
    if (![dic[@"viewerId"] isEqualToString:self.viewerId]) {
        name = dic[@"viewerName"];
    }
    CCCupView *cupView = [[CCCupView alloc] initWithWinnerName:name isScreen:self.screenLandScape];
    [APPDelegate.window addSubview:cupView];
}
//#ifdef LIANMAI_WEBRTC
#pragma mark - SDK连麦代理
/*
 *  @brief WebRTC连接成功，在此代理方法中主要做一些界面的更改
 */
- (void)connectWebRTCSuccess {
    [self.playerView connectWebRTCSuccess];
}
/*
 *  @brief 当前是否可以连麦
 */
- (void)whetherOrNotConnectWebRTCNow:(BOOL)connect {
    [self.playerView whetherOrNotConnectWebRTCNow:YES];
    if (connect) {
        /*
         * 当观看端主动申请连麦时，需要调用这个接口，并把本地连麦预览窗口传给SDK，SDK会在这个view上
         * 进行远程画面渲染
         * param localView:本地预览窗口，传入本地view，连麦准备时间将会自动绘制预览画面在此view上
         * param isAudioVideo:是否是音视频连麦，不是音视频即是纯音频连麦(YES表示音视频连麦，NO表示音频连麦)
         */
        [_requestData requestAVMessageWithLocalView:nil isAudioVideo:self.playerView.isAudioVideo];
    }
}
/**
 *  @brief 主播端接受连麦请求，在此代理方法中，要调用DequestData对象的
 *  - (void)saveUserInfo:(NSDictionary *)dict remoteView:(UIView *)remoteView;方法
 *  把收到的字典参数和远程连麦页面的view传进来，这个view需要自己设置并发给SDK，SDK将要在这个view上进行渲染
 *
     publisherId = "";
     type = audiovideo;
     videosize = 320x240;
     viewerId = 188bc6e67041459e807b5ad1ddbe0d9c;
     viewerName = A;
 */
- (void)acceptSpeak:(NSDictionary *)dict {
    [self.playerView acceptSpeak:dict];
    if(self.playerView.isAudioVideo) {
        /*
         * 当收到- (void)acceptSpeak:(NSDictionary *)dict;回调方法后，调用此方法
         * dict 正是- (void)acceptSpeak:(NSDictionary *)dict;接收到的的参数
         * remoteView 是远程连麦页面的view，需要自己设置并发给SDK，SDK将要在这个view上进行远程画面渲染
         */
        [_requestData saveUserInfo:dict remoteView:self.playerView.remoteView];
    } else {
        [_requestData saveUserInfo:dict remoteView:nil];
    }
}
/*
 *  @brief 主播端发送断开连麦的消息，收到此消息后做断开连麦操作
 */
-(void)speak_disconnect:(BOOL)isAllow {
    [self.playerView speak_disconnect:isAllow];
}
/*
 *  @brief 本房间为允许连麦的房间，会回调此方法，在此方法中主要设置UI的逻辑，
 *  在断开推流,登录进入直播间和改变房间是否允许连麦状态的时候，都会回调此方法
 */
- (void)allowSpeakInteraction:(BOOL)isAllow {
    [self.playerView allowSpeakInteraction:isAllow];
}
//#endif
#pragma mark - 添加通知
-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterBackgroundNotification)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    //#ifdef LIANMAI_WEBRTC
    //删除菜单按钮的selected属性监听
    [self.menuView.menuBtn removeObserver:self forKeyPath:@"selected"];
    //#endif
}
/**
 APP将要进入后台
 */
- (void)appWillEnterBackgroundNotification {
//#ifdef LockView
    if (_pauseInBackGround == NO) {
        [_lockView updateLockView];
    }
//#endif
}
/**
 APP将要进入前台
 */
- (void)appWillEnterForegroundNotification {
    if (_requestData.ijkPlayer.playbackState == IJKMPMoviePlaybackStatePaused) {
        [_requestData.ijkPlayer play];
    }
}


#pragma mark - 添加弹窗类事件
-(void)addAlerView:(UIView *)view{
    [APPDelegate.window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self showRollCallView];
}
#pragma mark - 禁言弹窗
-(void)addBanAlertView:(NSString *)str{
    [_alertView removeFromSuperview];
    _alertView = nil;
    _alertView = [[CCAlertView alloc] initWithAlertTitle:str sureAction:ALERT_SURE cancelAction:nil sureBlock:nil];
    [APPDelegate.window addSubview:_alertView];
}
#pragma mark - 移除答题卡视图
-(void)removeVoteView{
    [_voteView removeFromSuperview];
    _voteView = nil;
    [_voteViewResult removeFromSuperview];
    _voteViewResult = nil;
    [self.view endEditing:YES];
}
#pragma mark - 懒加载
//playView
-(CCPlayerView *)playerView{
    if (!_playerView) {
        //视频视图
        _playerView = [[CCPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HDGetRealHeight) docViewType:_isSmallDocView];
        _playerView.delegate = self;
        WS(weakSelf)
        //切换音视频线路
        _playerView.selectedRod = ^(NSInteger selectedRod) {
            [weakSelf selectedRodWidthIndex:selectedRod];
        };
        //切换音视频模式
        _playerView.switchAudio = ^(BOOL result) {
            [weakSelf changePlayMode:result];
        };
        //切换清晰度
        _playerView.selectedQuality = ^(NSString * _Nonnull quality) {
            [weakSelf selectedQuality:quality];
        };
        //发送聊天
        _playerView.sendChatMessage = ^(NSString * sendChatMessage) {
            [weakSelf sendChatMessageWithStr:sendChatMessage];
        };
        _playerView.touchupEvent = ^{
            [weakSelf.contentView shouldHiddenKeyBoard];
        };
        _playerView.publicTipBlock = ^(NSString * _Nonnull tip) {
            [weakSelf showTipInfomationWithTitle:tip];
        };
        //#ifdef LIANMAI_WEBRTC
        //是否是请求连麦
        _playerView.connectSpeak = ^(BOOL connect) {
            if (connect) {
                
                [weakSelf.requestData gotoConnectWebRTC];
            }else{
                [weakSelf.requestData disConnectSpeak];
            }
        };
        //设置连麦视图
        _playerView.setRemoteView = ^(CGRect frame) {
            
            [weakSelf.requestData setRemoteVideoFrameA:frame];
        };
        //#endif
    }
    return _playerView;
}
//contentView
-(CCInteractionView *)contentView{
    if (!_contentView) {
        WS(ws)
        CGFloat y = HDGetRealHeight+SCREEN_STATUS;
        CGFloat h = SCREEN_HEIGHT - y;
        _contentView = [[CCInteractionView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH,h) hiddenMenuView:^{
            [ws hiddenMenuView];
        } chatBlock:^(NSString * _Nonnull msg) {
            [ws.requestData chatMessage:msg];
        } privateChatBlock:^(NSString * _Nonnull anteid, NSString * _Nonnull msg) {
            [ws.requestData privateChatWithTouserid:anteid msg:msg];
        } questionBlock:^(NSString * _Nonnull message) {
            if (_isLivePlay == NO) {
                [self addBanAlertView:@"直播未开始，无法提问"];
                return;
            }
            [ws.requestData question:message];
        } docViewType:_isSmallDocView];
        _contentView.playerView = self.playerView;
    }
    return _contentView;
}
//竖屏模式下点击空白退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.screenLandScape == NO) {
        [self.view endEditing:YES];
    }
}

//隐藏home条
- (BOOL)prefersHomeIndicatorAutoHidden {
    return  YES;
}
-(void) stopTimer {
    if([_userCountTimer isValid]) {
        [_userCountTimer invalidate];
        _userCountTimer = nil;
    }
}
//问卷和问卷统计
//移除问卷视图
-(void)removeQuestionnaireSurvey {
    [_questionnaireSurvey removeFromSuperview];
    _questionnaireSurvey = nil;
    [_questionnaireSurveyPopUp removeFromSuperview];
    _questionnaireSurveyPopUp = nil;
}
//签到
-(RollcallView *)rollcallView {
    if(!_rollcallView) {
        RollcallView *rollcallView = [[RollcallView alloc] initWithDuration:self.duration lotteryblock:^{
            [self.requestData answer_rollcall];//签到
        } isScreenLandScape:self.screenLandScape];
        _rollcallView = rollcallView;
    }
    return _rollcallView;
}
//移除签到视图
-(void)removeRollCallView {
    [_rollcallView removeFromSuperview];
    _rollcallView = nil;
}
//显示签到视图
-(void)showRollCallView{
    if (_rollcallView) {
        [APPDelegate.window bringSubviewToFront:_rollcallView];
    }
}
/**
 *    @brief    随堂测数据
 */
- (NSMutableDictionary *)testDict
{
    if (!_testDict) {
        _testDict = [NSMutableDictionary dictionary];
    }
    return _testDict;
}

//更多菜单
-(SelectMenuView *)menuView{
    if (!_menuView) {
        WS(ws)
        _menuView = [[SelectMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 120 - kScreenBottom, 35, 35)];
        //私聊按钮回调
        _menuView.privateBlock = ^{
            [ws.contentView.chatView privateChatBtnClicked];
            [APPDelegate.window bringSubviewToFront:ws.contentView.chatView.ccPrivateChatView];
        };
        //#ifdef LIANMAI_WEBRTC
        //连麦按钮回调
        _menuView.lianmaiBlock = ^{
            [ws.playerView lianmaiBtnClicked];
        };
        [_menuView.menuBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        //#endif
        //公告按钮回调
        _menuView.announcementBlock = ^{
            [ws announcementBtnClicked];
            [APPDelegate.window bringSubviewToFront:ws.announcementView];
        };
    }
    return _menuView;
}
//收回菜单
-(void)hiddenMenuView{
    //#ifdef LIANMAI_WEBRTC
    //如果菜单是展开状态,切换时关闭菜单
    if (!_menuView.lianmaiBtn.hidden) {
        [_menuView hiddenAllBtns:YES];
    }
    //#endif
}
//#ifdef LIANMAI_WEBRTC
//监听菜单按钮的selected属性
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    BOOL hidden = change[@"new"] == 0 ? YES: NO;
    [_playerView menuViewSelected:hidden];
}
//#endif
//公告
-(AnnouncementView *)announcementView{
    if (!_announcementView) {
        _announcementView = [[AnnouncementView alloc] initWithAnnouncementStr:_gongGaoStr];
        _announcementView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 417.5);
    }
    return _announcementView;
}
//点击公告按钮
-(void)announcementBtnClicked{
    [APPDelegate.window addSubview:self.announcementView];
    [UIView animateWithDuration:0.3 animations:^{
       _announcementView.frame = CGRectMake(0, HDGetRealHeight+SCREEN_STATUS, SCREEN_WIDTH,IS_IPHONE_X ? 417.5 + 90:417.5);
    }];
}
#pragma mark - 屏幕旋转
/**
 *    @brief    旋转方向
 *    @return   是否允许转屏
 */
- (BOOL)shouldAutorotate {
    if (self.isScreenLandScape == YES) {
        return YES;
    }
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
/**
 *    @brief    强制转屏
 *    @param    orientation   旋转方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)dealloc {
    /*      自动登录情况下，会存在移除控制器但是SDK没有销毁的情况 */
    if (_requestData) {
        [_requestData requestCancel];
        _requestData = nil;
    }
}
@end
