//
//  LiveRoomViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveRoomViewController.h"
#import "LiveRoomPersonCell.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import <TEduBoard/TEduBoard.h>
#import "QuestionChatLeftCell.h"
#import "QuestionChatTimeCell.h"
#import "QuestionChatRightCell.h"
#import "CommentBaseView.h"
#import "HorizontalScrollText.h"
#import "V5_UserModel.h"
#import "LiveMenberCell.h"
#import "LiveCourseListVC.h"
#import "CourseMainViewController.h"
#import "UIView+Toast.h"

// 声网RTM所需文件引用
#import "AgoraRtm.h"
#import "JsonParseUtil.h"
#import <MJExtension.h>

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

@interface LiveRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TEduBoardDelegate, CommentBaseViewDelegate, UITableViewDelegate, UITableViewDataSource, LiveCourseListVCDelegate,/** 声网代理 */ WhitePlayDelegate, SignalDelegate, RTCDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate> {
    NSInteger page;
    CGFloat keyHeight;
    BOOL isScrollBottom;
    BOOL reloadChatOrMenberList;// yes chat  no menber
    dispatch_source_t timer;
}

@property (nonatomic,assign) NSInteger timeCount;

// 腾讯直播相关控件
@property (assign, nonatomic) BOOL isFullScreen;
@property (strong, nonatomic) NSMutableArray *livePersonArray;
@property (strong, nonatomic) UIView *boardView;
@property (nonatomic, weak) WhiteBoardView *whiteBoardView;

//CGRectMake(0, _topBlackView.bottom, MainScreenWidth - 113, (MainScreenWidth - 113)*3/4.0);
@property (strong, nonatomic) UIView *allFaceContentView; //顶部装讲师直播头像和学生头像的容器

// 中间按钮背景视图
@property (strong, nonatomic) UIView *midButtonBackView;
@property (strong, nonatomic) UIButton *baibanBtn;
@property (strong, nonatomic) UIButton *chatBtn;
@property (strong, nonatomic) UIButton *menberBtn;
@property (strong, nonatomic) UIView *blueLine;
@property (strong, nonatomic) UIView *greyLine;


// 声网直播相关控件
@property (strong, nonatomic) UIView *chatBackView;// 聊天列表页面整个背景视图
@property (strong, nonatomic) UIView *noticeBackView;// 公告背景视图
@property (strong, nonatomic) HorizontalScrollText *noticeText;
@property (strong, nonatomic) UITableView *chatListTableView; // 聊天列表
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UITableView *liveMenberTableView; // 聊天列表
@property (strong, nonatomic) NSMutableArray *menberDataSource;

@property (strong, nonatomic) CommentBaseView *chatCommentView;
@property (strong, nonatomic) UIView *commentBackView;

// 声网直播间频道
@property (nonatomic, strong) AgoraRtmChannel *rtmChannel;
@property (nonatomic, assign) BOOL hasSignalReconnect;

@end

@implementation LiveRoomViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *app = [AppDelegate delegate];
//    app._allowRotation = YES;
    app._allowRotation = NO;
    isScrollBottom = NO;
    // 创建聊天频道
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    isScrollBottom = YES;
    
    _livePersonArray = [NSMutableArray new];
    _dataSource = [NSMutableArray new];
    
    [self makeLiveSubView];
    [self makeMidSubView];
    [self makeBoardView];
    [self makeNoticeView];
    [self makeChatListTableView];
    [self makeBottomView];
    [self makeMenberListTableView];
    [self initData];
    // 接收屏幕方向改变通知,监听屏幕方向
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationHandler) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initData {
    self.educationManager.signalDelegate = self;
    [self setupRTC];
    [self setupWhiteBoard];
    [self updateTimeState];
    [self updateChatViews];
    
    // init role render
    [self checkNeedRenderWithRole:UserRoleTypeTeacher];
    [self checkNeedRenderWithRole:UserRoleTypeStudent];
}

- (void)setupSignalWithSuccessBlock:(void (^)(void))successBlock {

    NSString *appid = EduConfigModel.shareInstance.appId;
    NSString *appToken = EduConfigModel.shareInstance.rtmToken;
    NSString *uid = @(EduConfigModel.shareInstance.uid).stringValue;
    
    WEAK(self);
    [self.educationManager initSignalWithAppid:appid appToken:appToken userId:uid dataSourceDelegate:self completeSuccessBlock:^{
        
        NSString *channelName = EduConfigModel.shareInstance.channelName;
        [weakself.educationManager joinSignalWithChannelName:channelName completeSuccessBlock:^{
            if(successBlock != nil){
                successBlock();
            }
            
        } completeFailBlock:^(NSInteger errorCode) {
            NSString *errMsg = [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"JoinSignalFailedText", nil), (long)errorCode];
            [weakself showToast:errMsg];
        }];
        
    } completeFailBlock:^(NSInteger errorCode) {
        NSString *errMsg = [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"InitSignalFailedText", nil), (long)errorCode];
        [weakself showToast:errMsg];
    }];
}

- (void)makeLiveSubView {
    _liveBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_STATUSBAR_HEIGHT, MainScreenWidth, (MainScreenWidth - 113)*3/4.0 + 37 * 2)];//画板高度+上下黑色背景高度
    _liveBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_liveBackView];
    
    _topBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _liveBackView.width, 37)];
    _topBlackView.backgroundColor = EdlineV5_Color.textFirstColor;
    
    _teacherFaceBackView = [[LiveTeacherView alloc] initWithFrame:CGRectMake(0, _topBlackView.bottom, MainScreenWidth - 113, (MainScreenWidth - 113)*3/4.0)];
    [_liveBackView addSubview:_teacherFaceBackView];
    
    [self makeCollectionView];
    
    [_liveBackView addSubview:_topBlackView];
    
    _topToolBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _liveBackView.width, 37)];
    _topToolBackView.layer.masksToBounds = YES;
    _topToolBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    [_liveBackView addSubview:_topToolBackView];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    [_leftBtn setImage:Image(@"nav_back_white") forState:0];
    [_leftBtn addTarget:self action:@selector(onQuitClassRoom) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBackView addSubview:_leftBtn];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftBtn.right, 0, MainScreenWidth, 37)];
    _themeLabel.textColor = [UIColor whiteColor];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.text =  SWNOTEmptyStr(_liveTitle) ? _liveTitle : @"欢迎来到本直播间";
    [_topToolBackView addSubview:_themeLabel];
    
    _cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 7.5 - 37, 0, 37, 37)];
    [_cameraBtn setImage:Image(@"cam_open") forState:UIControlStateSelected];
    [_cameraBtn setImage:Image(@"cam_close") forState:0];
    [_cameraBtn addTarget:self action:@selector(swicthCamera:) forControlEvents:UIControlEventTouchUpInside];
    if ([_userIdentify isEqualToString:@"1"]) {
        
    } else {
        _cameraBtn.hidden = [_course_live_type isEqualToString:@"1"] ? YES : NO;
    }
    [_topToolBackView addSubview:_cameraBtn];
    
    _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cameraBtn.left - 37, 0, 37, 37)];
    [_voiceBtn setImage:Image(@"mic_open") forState:UIControlStateSelected];
    [_voiceBtn setImage:Image(@"mic_close") forState:0];
    [_voiceBtn addTarget:self action:@selector(switchVoice:) forControlEvents:UIControlEventTouchUpInside];
    if ([_userIdentify isEqualToString:@"1"]) {
        
    } else {
        _voiceBtn.hidden = [_course_live_type isEqualToString:@"1"] ? YES : NO;
    }
    [_topToolBackView addSubview:_voiceBtn];
    
    _lianmaiBtn = [[UIButton alloc] initWithFrame:CGRectMake(_voiceBtn.left - 100, 0, 100, 22)];
    _lianmaiBtn.layer.masksToBounds = YES;
    _lianmaiBtn.layer.cornerRadius = 11;
    _lianmaiBtn.backgroundColor = HEXCOLOR(0x67C23A);
    _lianmaiBtn.titleLabel.font = SYSTEMFONT(14);
    
    NSString *commentCount = @"连麦";
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
    CGFloat space = 5.0;
    _lianmaiBtn.frame = CGRectMake(_voiceBtn.left - 7.5 - commentWidth, 0, commentWidth, 22);
    _lianmaiBtn.centerY = 37/2.0;
    [_lianmaiBtn setImage:Image(@"live_phone") forState:0];
    [_lianmaiBtn setTitle:commentCount forState:0];
    [_lianmaiBtn setTitleColor:[UIColor whiteColor] forState:0];
    _lianmaiBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _lianmaiBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    _lianmaiBtn.hidden = YES;
    [_topToolBackView addSubview:_lianmaiBtn];
    
    _bottomBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, (MainScreenWidth - 113)*3/4.0 + 37, _liveBackView.width, 37)];
    _bottomBlackView.backgroundColor = EdlineV5_Color.textFirstColor;
    [_liveBackView addSubview:_bottomBlackView];
    
    _bottomToolBackView = [[UIView alloc] initWithFrame:CGRectMake(0, (MainScreenWidth - 113)*3/4.0 + 37, _liveBackView.width, 37)];
    _bottomToolBackView.layer.masksToBounds = YES;
    _bottomToolBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    [_liveBackView addSubview:_bottomToolBackView];
    
    _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 7.5 - 37, 0, 37, 37)];
    [_fullScreenBtn setImage:Image(@"play_full_icon") forState:0];
    [_fullScreenBtn setImage:Image(@"play_suoxiao_icon") forState:UIControlStateSelected];
    [_fullScreenBtn addTarget:self action:@selector(fullButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBackView addSubview:_fullScreenBtn];
    
    NSString *roomMember = @"90";
    CGFloat roomMemberWidth = [roomMember sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
    CGFloat space1 = 5.0;
    _roomPersonCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(_fullScreenBtn.left - 7.5 - roomMemberWidth, 0, roomMemberWidth, 37)];
    _roomPersonCountBtn.centerY = 37/2.0;
    _roomPersonCountBtn.titleLabel.font = SYSTEMFONT(14);
    [_roomPersonCountBtn setImage:Image(@"live_member") forState:0];
    [_roomPersonCountBtn setTitle:roomMember forState:0];
    [_roomPersonCountBtn setTitleColor:[UIColor whiteColor] forState:0];
    _roomPersonCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space1/2.0, 0, space1/2.0);
    _roomPersonCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space1/2.0, 0, -space1/2.0);
    _roomPersonCountBtn.hidden = YES;
    [_bottomToolBackView addSubview:_roomPersonCountBtn];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 37)];
    _timeLabel.font = SYSTEMFONT(13);
    _timeLabel.textColor = [UIColor whiteColor];
    [_bottomToolBackView addSubview:_timeLabel];
}

// MARK: - 白板
- (void)makeBoardView {
//    //腾讯白板视图
//    [[[TICManager sharedInstance] getBoardController] addDelegate:self];
//    _boardView = [[[TICManager sharedInstance] getBoardController] getBoardRenderView];
//    _boardView.frame = CGRectMake(0, _midButtonBackView.bottom, MainScreenWidth, MainScreenHeight - _midButtonBackView.bottom);
//    [self.view addSubview:_boardView];
    // 声网白板视图
    _boardView = [[UIView alloc] init];
    _boardView.frame = CGRectMake(0, _midButtonBackView.bottom, MainScreenWidth, MainScreenHeight - _midButtonBackView.bottom);
    [self.view addSubview:_boardView];
    
    WhiteBoardView *whiteboardView = [[WhiteBoardView alloc] initWithFrame:CGRectMake(0, 0, _boardView.width, _boardView.height)];
    _whiteBoardView = whiteboardView;
    [_boardView addSubview:_whiteBoardView];
}

// 设置RTC
- (void)setupRTC {
    
    EduConfigModel *configModel = EduConfigModel.shareInstance;
    
    [self.educationManager initRTCEngineKitWithAppid:configModel.appId clientRole:RTCClientRoleBroadcaster dataSourceDelegate:self];
    
    self.cameraBtn.selected = self.educationManager.studentModel.enableVideo;
    self.voiceBtn.selected = self.educationManager.studentModel.enableAudio;
    
    WEAK(self);
    [self.educationManager joinRTCChannelByToken:configModel.rtcToken channelId:configModel.channelName info:nil uid:configModel.uid joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        [weakself checkNeedRenderWithRole:UserRoleTypeStudent];
    }];
}

// 设置白板代理
- (void)setupWhiteBoard {
    
    [self.educationManager initWhiteSDK:self.whiteBoardView dataSourceDelegate:self];

    RoomModel *roomModel = self.educationManager.roomModel;
    
    WEAK(self);
    [self.educationManager joinWhiteRoomWithBoardId:EduConfigModel.shareInstance.boardId boardToken:EduConfigModel.shareInstance.boardToken whiteWriteModel:NO completeSuccessBlock:^(WhiteRoom * _Nullable room) {

        [weakself disableWhiteDeviceInputs:!weakself.educationManager.studentModel.grantBoard];
        [weakself disableCameraTransform:roomModel.lockBoard];
        
    } completeFailBlock:^(NSError * _Nullable error) {
        [weakself showToast:NSLocalizedString(@"JoinWhiteErrorText", nil)];
    }];
}

- (void)showToast:(NSString *)title {
    [UIApplication.sharedApplication.keyWindow makeToast:title];
}

// MARK: - 中间按钮
- (void)makeMidSubView {
    _midButtonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _liveBackView.bottom, MainScreenWidth, 40)];
    _midButtonBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_midButtonBackView];
    
    BOOL showMenberList = YES;
    if ([_userIdentify isEqualToString:@"1"] && [_course_live_type isEqualToString:@"2"]) {
        showMenberList = YES;
    }
    _showBoardView = YES;
    if (_showBoardView) {
        if (showMenberList) {
            _baibanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 3.0, 40)];
            [_baibanBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_baibanBtn setTitle:@"白板" forState:0];
            _baibanBtn.titleLabel.font = SYSTEMFONT(15);
            [_baibanBtn setTitleColor:[UIColor blackColor] forState:0];
            [_baibanBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_baibanBtn];
            
            _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/3.0, 0, MainScreenWidth / 3.0, 40)];
            [_chatBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_chatBtn setTitle:@"聊天" forState:0];
            _chatBtn.titleLabel.font = SYSTEMFONT(15);
            [_chatBtn setTitleColor:[UIColor blackColor] forState:0];
            [_chatBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_chatBtn];
            
            _menberBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth * 2/3.0, 0, MainScreenWidth / 3.0, 40)];
            [_menberBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menberBtn setTitle:@"学员" forState:0];
            _menberBtn.titleLabel.font = SYSTEMFONT(15);
            [_menberBtn setTitleColor:[UIColor blackColor] forState:0];
            [_menberBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_menberBtn];
            
            _blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 4, 20, 2)];
            _blueLine.backgroundColor = BasidColor;
            [_midButtonBackView addSubview:_blueLine];
            _blueLine.centerX = _baibanBtn.centerX;
            
        } else {
            _baibanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 40)];
            [_baibanBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_baibanBtn setTitle:@"白板" forState:0];
            _baibanBtn.titleLabel.font = SYSTEMFONT(15);
            [_baibanBtn setTitleColor:[UIColor blackColor] forState:0];
            [_baibanBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_baibanBtn];
            
            _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth / 2.0, 40)];
            [_chatBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_chatBtn setTitle:@"聊天" forState:0];
            _chatBtn.titleLabel.font = SYSTEMFONT(15);
            [_chatBtn setTitleColor:[UIColor blackColor] forState:0];
            [_chatBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_chatBtn];
            
            _blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 4, 20, 2)];
            _blueLine.backgroundColor = BasidColor;
            [_midButtonBackView addSubview:_blueLine];
            _blueLine.centerX = _baibanBtn.centerX;
        }
    } else {
        if (showMenberList) {
            _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 40)];
            [_chatBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_chatBtn setTitle:@"聊天" forState:0];
            _chatBtn.titleLabel.font = SYSTEMFONT(15);
            [_chatBtn setTitleColor:[UIColor blackColor] forState:0];
            [_chatBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_chatBtn];
            
            _menberBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth / 2.0, 40)];
            [_menberBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menberBtn setTitle:@"学员" forState:0];
            _menberBtn.titleLabel.font = SYSTEMFONT(15);
            [_menberBtn setTitleColor:[UIColor blackColor] forState:0];
            [_menberBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_menberBtn];
            
            _blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 4, 20, 2)];
            _blueLine.backgroundColor = BasidColor;
            [_midButtonBackView addSubview:_blueLine];
            _blueLine.centerX = _chatBtn.centerX;
        } else {
            _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
            [_chatBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_chatBtn setTitle:@"聊天" forState:0];
            _chatBtn.titleLabel.font = SYSTEMFONT(15);
            [_chatBtn setTitleColor:[UIColor blackColor] forState:0];
            [_chatBtn setTitleColor:BasidColor forState:UIControlStateSelected];
            [_midButtonBackView addSubview:_chatBtn];
            
            _blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 4, 20, 2)];
            _blueLine.backgroundColor = BasidColor;
            [_midButtonBackView addSubview:_blueLine];
            _blueLine.centerX = _chatBtn.centerX;
        }
    }
    _greyLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 2, MainScreenWidth, 2)];
    _greyLine.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_midButtonBackView addSubview:_greyLine];
}

// MARK: - 中间按钮点击事件
- (void)midButtonClick:(UIButton *)sender {
    if (sender == _baibanBtn) {
        self.blueLine.centerX = self.baibanBtn.centerX;
        self.baibanBtn.selected = YES;
        self.chatBtn.selected = NO;
        self.menberBtn.selected = NO;
        [_chatCommentView.inputTextView resignFirstResponder];
        _chatCommentView.hidden = YES;
        _chatBackView.hidden = YES;
        // 成员列表背景图隐藏
        _liveMenberTableView.hidden = YES;
        // 白板视图展示
        
    } else if (sender == _chatBtn) {
        self.blueLine.centerX = self.chatBtn.centerX;
        self.chatBtn.selected = YES;
        self.baibanBtn.selected = NO;
        self.menberBtn.selected = NO;
        _chatCommentView.hidden = NO;
        _chatBackView.hidden = NO;
        // 成员列表背景图隐藏
        _liveMenberTableView.hidden = YES;
    } else if (sender == _menberBtn) {
        self.blueLine.centerX = self.menberBtn.centerX;
        self.menberBtn.selected = YES;
        self.baibanBtn.selected = NO;
        self.chatBtn.selected = NO;
        _chatCommentView.hidden = YES;
        _chatBackView.hidden = YES;
        _liveMenberTableView.hidden = NO;
        [_liveMenberTableView reloadData];
    }
}

- (void)makeBottomView {
    _chatCommentView = [[CommentBaseView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA) leftButtonImageArray:@[@"live_dashang",@"live_store"] placeHolderTitle:nil sendButtonTitle:nil];
    _chatCommentView.delegate = self;
    _chatCommentView.placeHoderLab.hidden = YES;
    _chatCommentView.hidden = YES;
    [self.view addSubview:_chatCommentView];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.001)];
    _commentBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBackViewTap:)];
    [_commentBackView addGestureRecognizer:backViewTap];
    _commentBackView.hidden = YES;
    [self.view addSubview:_commentBackView];
}

// MARK: - 公告相关控件
- (void)makeNoticeView {
    _chatBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _midButtonBackView.bottom, MainScreenWidth, MainScreenHeight - _midButtonBackView.bottom - CommenViewHeight)];
    _chatBackView.backgroundColor = [UIColor whiteColor];
    _chatBackView.hidden = YES;
    [self.view addSubview:_chatBackView];
    
    _noticeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 32)];
    _noticeBackView.backgroundColor = [UIColor whiteColor];
    [_chatBackView addSubview:_noticeBackView];
    
    UIImageView *noticeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, (_noticeBackView.height - 17) / 2.0, 17, 17)];
    noticeIcon.image = Image(@"gonggao");
    [_noticeBackView addSubview:noticeIcon];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(noticeIcon.right + 2.5, 0, 40, 32)];
    tipsLabel.font = SYSTEMFONT(12);
    tipsLabel.text = @"公告:";
    tipsLabel.textColor = HEXCOLOR(0xFF8A52);
    [_noticeBackView addSubview:tipsLabel];
    
    _noticeText = [[HorizontalScrollText alloc] initWithFrame:CGRectMake(tipsLabel.right + 5, 0, MainScreenWidth - tipsLabel.right - 5 - 45, 32)];
    _noticeText.backgroundColor    = [UIColor whiteColor];
    _noticeText.textColor          = EdlineV5_Color.textSecendColor;
    _noticeText.textFont           = [UIFont systemFontOfSize:12];
    _noticeText.speed              = 0.03;
    _noticeText.moveDirection      = LMJTextScrollMoveLeft;
    _noticeText.moveMode           = LMJTextScrollFromOutside;
    _noticeText.text = @"请同学们文明发言哈～";
    [_noticeBackView addSubview:_noticeText];
    
    UIButton *noticeCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 45, 0, 45, 32)];
    [noticeCloseBtn setImage:Image(@"close_icon") forState:0];
    [noticeCloseBtn addTarget:self action:@selector(noticeCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_noticeBackView addSubview:noticeCloseBtn];
}

// MARK: - 聊天tableview
- (void)makeChatListTableView {
    _chatListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _noticeBackView.bottom, MainScreenWidth, _chatBackView.height - _noticeBackView.height)];
    _chatListTableView.delegate = self;
    _chatListTableView.dataSource = self;
    _chatListTableView.backgroundColor = EdlineV5_Color.backColor;;
    _chatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatListTableView.showsVerticalScrollIndicator = NO;
    _chatListTableView.showsHorizontalScrollIndicator = NO;
//    _chatListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
    [_chatBackView addSubview:_chatListTableView];
    [EdulineV5_Tool adapterOfIOS11With:_chatListTableView];
//    [_chatListTableView.mj_header beginRefreshing];
}

// MARK: - 学员tableView
- (void)makeMenberListTableView {
    _liveMenberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _midButtonBackView.bottom, MainScreenWidth, MainScreenHeight - _midButtonBackView.bottom)];
    _liveMenberTableView.delegate = self;
    _liveMenberTableView.dataSource = self;
    _liveMenberTableView.backgroundColor = EdlineV5_Color.backColor;;
    _liveMenberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _liveMenberTableView.showsVerticalScrollIndicator = NO;
    _liveMenberTableView.showsHorizontalScrollIndicator = NO;
//    _liveMenberTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
    [self.view addSubview:_liveMenberTableView];
    _liveMenberTableView.hidden = YES;
    [EdulineV5_Tool adapterOfIOS11With:_liveMenberTableView];
}

// MARK: - 聊天tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _chatListTableView) {
        if (isScrollBottom) { //只在初始化的时候执行
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.dataSource.count > 0) {
                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.chatListTableView numberOfRowsInSection:0]-1) inSection:0];
                   [self.chatListTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
           });
        }
        return _dataSource.count;
    } else {
        return 5;
        return _menberDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatListTableView) {
        // [[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"user_id"]] isEqualToString:[V5_UserModel uid]]
        MessageInfoModel *model = _dataSource[indexPath.row];
        if (model.isSelfSend) {
            static NSString *rightReuse = @"QuestionChatRightCell";
            QuestionChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuse];
            if (!cell) {
                cell = [[QuestionChatRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuse];
            }
            [cell setQuestionChatRightModel:model];
            return cell;
        } else {
            static NSString *rightReuse = @"QuestionChatLeftCell";
            QuestionChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuse];
            if (!cell) {
                cell = [[QuestionChatLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuse];
            }
            [cell setQuestionChatLeftModel:model];
            return cell;
        }
    } else {
        static NSString *rightReuse = @"LiveMenberCell";
        LiveMenberCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuse];
        if (!cell) {
            cell = [[LiveMenberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuse];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatListTableView) {
        UITableViewCell *cell = [self tableView:self.chatListTableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    } else {
        return 64.0;
    }
}

//MARK: - 公告关闭按钮点击事件
- (void)noticeCloseBtnClick:(UIButton *)sender {
    _noticeBackView.hidden = YES;
    _chatListTableView.frame = CGRectMake(0, 0, MainScreenWidth, _chatBackView.height);
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_chatCommentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommenViewHeight];
    [_chatCommentView setHeight:CommenViewHeight + MACRO_UI_SAFEAREA];
    [_chatCommentView.inputTextView setHeight:CommentInputHeight];
    CGFloat XX = SWNOTEmptyArr(_chatCommentView.leftButtonImageArray) ? (15 + _chatCommentView.leftButtonImageArray.count * (CommentViewLeftButtonWidth + 8) + 13.5 - 8) : 15;
    _chatCommentView.inputTextView.frame = CGRectMake(XX, (CommenViewHeight - CommentInputHeight) / 2.0, MainScreenWidth - XX - 57.5, CommentInputHeight);
    for (int i = 0; i<self.chatCommentView.leftButtonImageArray.count; i++) {
        UIButton *btn = (UIButton *)[_chatCommentView viewWithTag:20 + i];
        btn.hidden = NO;
    }
    [_chatCommentView.sendButton setTop:0];
    [_commentBackView setHeight:0.001];
    _commentBackView.hidden = YES;
    if (_chatCommentView.inputTextView.text.length<=0) {
        _chatCommentView.placeHoderLab.hidden = NO;
    } else {
        _chatCommentView.placeHoderLab.hidden = YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    if (IS_IPHONEX) {
        keyHeight = keyHeight - 34;
    }
    [UIView animateWithDuration:0.1 animations:^{
        for (int i = 0; i<self.chatCommentView.leftButtonImageArray.count; i++) {
            UIButton *btn = (UIButton *)[self.chatCommentView viewWithTag:20 + i];
            btn.hidden = YES;
        }
        [self.chatCommentView setHeight:CommentViewMaxHeight];
        self.chatCommentView.inputTextView.frame = CGRectMake(15, (CommenViewHeight - CommentInputHeight) / 2.0, MainScreenWidth - 15 - 57.5, CommentViewMaxHeight - (CommenViewHeight - CommentInputHeight));
        [self.chatCommentView.sendButton setTop:self.chatCommentView.inputTextView.bottom - CommenViewHeight + (CommenViewHeight - CommentInputHeight)/2.0];
        [self.chatCommentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
        [self.commentBackView setHeight:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
    } completion:^(BOOL finished) {
        self.commentBackView.hidden = NO;
    }];
}

// MARK: - 发送内容
- (void)sendReplayMsg:(CommentBaseView *)view {
    [view.inputTextView resignFirstResponder];
    if (!SWNOTEmptyStr(view.inputTextView.text)) {
        [self showHudInView:self.view showHint:@"请输入内容"];
        return;
    }
    NSString *content = view.inputTextView.text;
    
    MessageModel *model = [[MessageModel alloc] init];
    model.cmd = 1;
    MessageInfoModel *messModel = [[MessageInfoModel alloc] init];
    messModel.message = content;
    messModel.userId = [NSString stringWithFormat:@"%@",@(EduConfigModel.shareInstance.uid)];
    messModel.userName = [NSString stringWithFormat:@"%@",EduConfigModel.shareInstance.userName];
    model.data = messModel;

    __weak LiveRoomViewController *weakSelf = self;
    void(^sent)(int) = ^(int status) {
        if (status != 0) {
            NSString *alert = [NSString stringWithFormat:@"send message error: %d", status];
            [weakSelf showAlert:alert];
            return;
        }
        messModel.isSelfSend = YES;
        [_dataSource addObject:messModel];
        [_chatListTableView reloadData];
        if (_dataSource.count > 0) {
            [_chatListTableView scrollToRowAtIndexPath:
             [NSIndexPath indexPathForRow:[_dataSource count] - 1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
        }
    };
    
    [self.educationManager.signalManager sendMessage:[model mj_JSONString] completeSuccessBlock:^{
        sent(0);
    } completeFailBlock:^(NSInteger errorCode) {
        sent((int)(errorCode));
    }];
    view.inputTextView.text = @"";
}

- (void)commentLeftButtonClick:(CommentBaseView *)view sender:(UIButton *)sender {
    if (view.leftButtonImageArray.count == 2) {
        if (sender.tag == 20) {
            // 大赏
        } else {
            // 带货
            LiveCourseListVC *vc = [[LiveCourseListVC alloc] init];
            vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
            vc.delegate = self;
        }
    }
}

// MARK: - 去抢购跳转
- (void)liveRoomJumpCourseDetailPage:(NSDictionary *)dict {
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentBackViewTap:(UIGestureRecognizer *)tap {
    [_chatCommentView.inputTextView resignFirstResponder];
}

// MARK: - 摄像头列表
- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(113, 64);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 2;
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(MainScreenWidth - 113, _topBlackView.bottom, 113, (MainScreenWidth - 113)*3/4.0) collectionViewLayout:cellLayout];
    if (_isFullScreen) {
        [_collectionView setSize:CGSizeMake(113 * 2 + 2, (MainScreenWidth - 113)*3/4.0)];
    } else {
        [_collectionView setSize:CGSizeMake(113, (MainScreenWidth - 113)*3/4.0)];
    }
    [_collectionView registerClass:[LiveRoomPersonCell class] forCellWithReuseIdentifier:@"LiveRoomPersonCell"];
    _collectionView.backgroundColor = EdlineV5_Color.textFirstColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_liveBackView addSubview:_collectionView];
    [_collectionView reloadData];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self changeRoomMenberCountUI];
    return _livePersonArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveRoomPersonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveRoomPersonCell" forIndexPath:indexPath];
    UserModel *currentModel = self.livePersonArray[indexPath.row];
    cell.userModel = currentModel;
    [self initStudentRenderBlock:cell currentUid:currentModel.uid];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)initStudentRenderBlock:(LiveRoomPersonCell *)cell currentUid:(NSInteger)currentUid {
    WEAK(self);
    if(cell == nil){
        return;
    }
           
    RTCVideoCanvasModel *model = [RTCVideoCanvasModel new];
    model.uid = currentUid;
    model.videoView = cell.videoCanvasView;
    model.renderMode = RTCVideoRenderModeHidden;

    EduConfigModel *configModel = EduConfigModel.shareInstance;
    if (model.uid == configModel.uid) {
       model.canvasType = RTCVideoCanvasTypeLocal;
       [weakself.educationManager setupRTCVideoCanvas:model completeBlock:nil];
    } else {
       model.canvasType = RTCVideoCanvasTypeRemote;
       [weakself.educationManager setRTCRemoteStreamWithUid:model.uid type:RTCVideoStreamTypeLow];
       [weakself.educationManager setupRTCVideoCanvas:model completeBlock:nil];
    }
}

// MARK: - 全屏切换按钮点击事件

// MARK: 点击btn按钮
- (void)fullButtonClick:(UIButton *)sender {
    // 这里我是通过按钮的selected状态来判定横屏竖屏的,并不是唯一的判断标准
    if (sender.selected) {
        [self changeOrientation:UIInterfaceOrientationPortrait];
    }else{
        [self changeOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

- (void)changeOrientation:(UIInterfaceOrientation)orientation
{
    return;
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

// 通知方法
- (void)orientationHandler {
    
// 在这里可进行屏幕旋转时的处理

    // 获取当前设备方向
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    // 动画时长
    NSTimeInterval duration = 0.3;
    // 获取宽高
    CGFloat w = CGRectGetWidth(self.view.bounds);
    CGFloat h = CGRectGetHeight(self.view.bounds);
    
    // 处理方法,该方法参数根据跟人情况而定
    [self fullScreenWithUIDeviceOrientation:orient duration:duration width:w height:h];
    
}

// 处理横屏竖屏
- (void)fullScreenWithUIDeviceOrientation:(UIDeviceOrientation)orientation duration:(NSTimeInterval)duration width:(CGFloat)width height:(CGFloat)height {
    return;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationPortraitUpsideDown) return;
    
    if (orientation == UIDeviceOrientationPortrait) {
        // 竖屏
        // 处理方法
        _isFullScreen = NO;
        [self showFullScreen];
    }else{
        // 向左旋转或向右旋转
        // 处理方法
        _isFullScreen = YES;
        [self showFullScreen];
    }
}

- (void)showFullScreen {
    if (_isFullScreen) {
        
        _liveBackView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _topBlackView.frame = CGRectMake(0, 0, _liveBackView.width, 24);
        _topToolBackView.frame = CGRectMake(0, 0, _liveBackView.width, 37);
        
        _leftBtn.frame = CGRectMake(0, 0, 37, 37);
        
        _themeLabel.frame = CGRectMake(_leftBtn.right, 0, _liveBackView.width, 37);
        
        _cameraBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        
        _voiceBtn.frame = CGRectMake(_cameraBtn.left - 37, 0, 37, 37);
        [_lianmaiBtn setRight:_voiceBtn.left - 7.5];
        
        _boardView.frame = CGRectMake(0, _topBlackView.bottom, _liveBackView.width - (113 * 2 + 2), _liveBackView.height - 24 * 2);
        
        _bottomBlackView.frame = CGRectMake(0, _liveBackView.height - 24, _liveBackView.width, 24);
        
        _bottomToolBackView.frame = CGRectMake(0, _liveBackView.height - 37, _liveBackView.width, 37);
        
        _fullScreenBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        _fullScreenBtn.selected = YES;
        
        [_roomPersonCountBtn setRight:_fullScreenBtn.left - 7.5];
        
        _collectionView.frame = CGRectMake(_liveBackView.width - (113 * 2 + 2), 24, 113 * 2 + 2, MainScreenWidth - 24 * 2);
    } else {
        
        _liveBackView.frame = CGRectMake(0, MACRO_UI_STATUSBAR_HEIGHT, MainScreenWidth, (MainScreenWidth - 113)*3/4.0 + 37 * 2);//画板高度+上下黑色背景高度
        
        _topBlackView.frame = CGRectMake(0, 0, _liveBackView.width, 37);
        _topToolBackView.frame = CGRectMake(0, 0, _liveBackView.width, 37);
        
        _leftBtn.frame = CGRectMake(0, 0, 37, 37);
        
        _themeLabel.frame = CGRectMake(_leftBtn.right, 0, _liveBackView.width, 37);
        
        _cameraBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        
        _voiceBtn.frame = CGRectMake(_cameraBtn.left - 37, 0, 37, 37);
        [_lianmaiBtn setRight:_voiceBtn.left - 7.5];
        
        _boardView.frame = CGRectMake(0, _topBlackView.bottom, _liveBackView.width - 113, _liveBackView.height - 37 * 2);
        
        _bottomBlackView.frame = CGRectMake(0, _liveBackView.height - 37, _liveBackView.width, 37);
        
        _bottomToolBackView.frame = CGRectMake(0, _liveBackView.height - 37, _liveBackView.width, 37);
        
        _fullScreenBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        _fullScreenBtn.selected = NO;
        [_roomPersonCountBtn setRight:_fullScreenBtn.left - 7.5];
        
        _collectionView.frame = CGRectMake(_liveBackView.width - 113, _topBlackView.bottom, 113, _boardView.height);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CATransaction setDisableActions:YES];
        
        [_collectionView reloadData];
        
        [CATransaction commit];
    });
}

// MARK: - 白板代理
#pragma mark - board delegate
- (void)onTEBRedoStatusChanged:(BOOL)canRedo
{
    
}

- (void)onTEBUndoStatusChanged:(BOOL)canUndo
{
    
}

// MARK: - 退出互动课堂
- (void)onQuitClassRoom
{
    if (_isFullScreen) {
        [self fullButtonClick:_fullScreenBtn];
        return;
    }
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    
    __weak LiveRoomViewController *weakSelf = self;
    [weakSelf.educationManager releaseResources];
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - 开关摄像头
- (void)swicthCamera:(UIButton *)sender {
    
    if (sender.selected) {
        // 有授权
        sender.selected = !sender.selected;
        
        AgoraLogInfo(@"small muteVideoStream:%d", sender.selected);
        
        WEAK(self);
        if (sender.selected) {
            [self.educationManager.rtcManager setClientRole:AgoraClientRoleBroadcaster];
        } else {
            [self.educationManager.rtcManager setClientRole:AgoraClientRoleAudience];
        }
        
        [self.educationManager updateEnableVideoWithValue:sender.selected completeSuccessBlock:^{

            [weakself reloadStudentViews];

        } completeFailBlock:^(NSString * _Nonnull errMessage) {

            [weakself showToast:errMessage];
            [weakself reloadStudentViews];
        }];
        return;
    }
    
    AVAuthorizationStatus microPhoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (microPhoneStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusNotDetermined:
        {
            // 被拒绝
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
            completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        NSURL *url =  [NSURL URLWithString:@"App-Prefs:root=Photos"];
                        if ([[UIApplication sharedApplication] canOpenURL: url]) {
                            if (iOS10) {
                                [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
                            } else {
                                [[UIApplication sharedApplication] openURL: url];
                            }
                        }
                    } else {
                        [self showAlertWithTitle:@"温馨提示" msg:@"您没有开启\"摄像头\"权限\n 无法进行通话。请在设置中开启摄像头权限。" handler:^(UIAlertAction *action) {
                            
                        }];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            // 有授权
            sender.selected = !sender.selected;
            
            AgoraLogInfo(@"small muteVideoStream:%d", sender.selected);
            
            WEAK(self);
            if (sender.selected) {
                [self.educationManager.rtcManager setClientRole:AgoraClientRoleBroadcaster];
            } else {
                [self.educationManager.rtcManager setClientRole:AgoraClientRoleAudience];
            }
            
            [self.educationManager updateEnableVideoWithValue:sender.selected completeSuccessBlock:^{

                [weakself reloadStudentViews];

            } completeFailBlock:^(NSString * _Nonnull errMessage) {

                [weakself showToast:errMessage];
                [weakself reloadStudentViews];
            }];
        }
            break;

        default:
            break;
    }
}

// MARK: - 开关麦克风
- (void)switchVoice:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = !sender.selected;
        
        AgoraLogInfo(@"small muteAudioStream:%d", sender.selected);
        
        [self.educationManager.rtcManager enableLocalAudio:sender.selected];
        
        WEAK(self);
        [self.educationManager updateEnableAudioWithValue:sender.selected completeSuccessBlock:^{
            
            [weakself reloadStudentViews];

        } completeFailBlock:^(NSString * _Nonnull errMessage) {
            
            [weakself showToast:errMessage];
            [weakself reloadStudentViews];
        }];
        return;
    }
    
    AVAuthorizationStatus microPhoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (microPhoneStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusNotDetermined:
        {
            // 被拒绝
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio
            completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        NSURL *url =  [NSURL URLWithString:@"App-Prefs:root=Photos"];
                        if ([[UIApplication sharedApplication] canOpenURL: url]) {
                            if (iOS10) {
                                [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
                            } else {
                                [[UIApplication sharedApplication] openURL: url];
                            }
                        }
                    } else {
                        [self showAlertWithTitle:@"温馨提示" msg:@"您没有开启\"麦克风\"权限\n 无法进行通话。请在设置中开启麦克风权限。" handler:^(UIAlertAction *action) {
                            
                        }];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            sender.selected = !sender.selected;
            
            AgoraLogInfo(@"small muteAudioStream:%d", sender.selected);
            
            [self.educationManager.rtcManager enableLocalAudio:sender.selected];
            
            WEAK(self);
            [self.educationManager updateEnableAudioWithValue:sender.selected completeSuccessBlock:^{
                
                [weakself reloadStudentViews];

            } completeFailBlock:^(NSString * _Nonnull errMessage) {
                
                [weakself showToast:errMessage];
                [weakself reloadStudentViews];
            }];
        }
            break;

        default:
            break;
    }
}

// MARK: - event listener
- (void)onTICUserVideoAvailable:(NSString *)userId available:(BOOL)available
{
    if(available){
        [_livePersonArray addObject:userId];
    }
    else{
        [_livePersonArray removeObject:userId];
        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:userId];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CATransaction setDisableActions:YES];
        
        [_collectionView reloadData];
        
        [CATransaction commit];
    });
}

// MARK: - 改变房间人数显示UI
- (void)changeRoomMenberCountUI {
    NSInteger roomcount = 0;
    if ([_livePersonArray containsObject:_userId]) {
        roomcount = _livePersonArray.count;
    } else {
        roomcount = _livePersonArray.count + 1;
    }
    NSString *roomMember = [NSString stringWithFormat:@"%@",@(roomcount)];
    CGFloat roomMemberWidth = [roomMember sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
    CGFloat space1 = 5.0;
    _roomPersonCountBtn.frame= CGRectMake(_fullScreenBtn.left - 7.5 - roomMemberWidth, 0, roomMemberWidth, 37);
    _roomPersonCountBtn.centerY = 37/2.0;
    [_roomPersonCountBtn setImage:Image(@"live_member") forState:0];
    [_roomPersonCountBtn setTitle:roomMember forState:0];
    _roomPersonCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space1/2.0, 0, space1/2.0);
    _roomPersonCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space1/2.0, 0, -space1/2.0);
}

// MARK: - 聊天相关
- (void)didReceivedMessage:(MessageInfoModel *)model {
    [_dataSource addObject:model];
    [_chatListTableView reloadData];
    if (_dataSource.count > 0) {
        [_chatListTableView scrollToRowAtIndexPath:
         [NSIndexPath indexPathForRow:[_dataSource count] - 1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)checkNeedRenderWithRole:(UserRoleType)roleType {
    
    if(roleType == UserRoleTypeTeacher) {
        UserModel *teacherModel = self.educationManager.teacherModel;
        [self updateTeacherViews:teacherModel];
        if(teacherModel != nil) {
            [self renderTeacherCanvas:teacherModel.uid];
        }
    } else if(roleType == UserRoleTypeStudent) {
       [self reloadStudentViews];
    }
}

- (void)renderTeacherCanvas:(NSUInteger)uid {
    RTCVideoCanvasModel *model = [RTCVideoCanvasModel new];
    model.uid = uid;
    model.videoView = self.teacherFaceBackView.videoRenderView;
    model.renderMode = RTCVideoRenderModeHidden;
    model.canvasType = RTCVideoCanvasTypeRemote;
    [self.educationManager setupRTCVideoCanvas:model completeBlock:nil];
}

- (void)renderShareCanvas:(NSUInteger)uid {
    RTCVideoCanvasModel *model = [RTCVideoCanvasModel new];
    model.uid = uid;
//    model.videoView = self.shareScreenView;
    model.renderMode = RTCVideoRenderModeFit;
    model.canvasType = RTCVideoCanvasTypeRemote;
    [self.educationManager setupRTCVideoCanvas:model completeBlock:nil];
    
//    self.shareScreenView.hidden = NO;
}

- (void)removeShareCanvas {
//    self.shareScreenView.hidden = YES;
}

- (void)muteVideoStream:(BOOL)mute {
    
    AgoraLogInfo(@"small muteVideoStream:%d", mute);
    
    WEAK(self);
    
    
    
    [self.educationManager updateEnableVideoWithValue:!mute completeSuccessBlock:^{
        
        [weakself reloadStudentViews];
        
    } completeFailBlock:^(NSString * _Nonnull errMessage) {
        
        [weakself showToast:errMessage];
        [weakself reloadStudentViews];
    }];
}

- (void)muteAudioStream:(BOOL)mute {
    
    AgoraLogInfo(@"small muteAudioStream:%d", mute);
    
    WEAK(self);
    [self.educationManager updateEnableAudioWithValue:!mute completeSuccessBlock:^{
        
        [weakself reloadStudentViews];

    } completeFailBlock:^(NSString * _Nonnull errMessage) {
        
        [weakself showToast:errMessage];
        [weakself reloadStudentViews];
    }];

}

#pragma mark  --------  Mandatory landscape -------
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//  return UIStatusBarStyleLightContent;
//}

- (void)dealloc {
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    if (timer) {
        dispatch_source_cancel(timer);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)reloadStudentViews {

    [self updateStudentArray:self.educationManager.studentTotleListArray];
//    [self.studentListView updateStudentArray:self.educationManager.studentTotleListArray];
//    [self.studentVideoListView updateStudentArray:self.educationManager.studentTotleListArray];
    
    [self updateStudentViews:self.educationManager.studentModel];
}

- (void)updateStudentArray:(NSArray<UserModel*> *)studentArray {
    
    if(studentArray.count == 0 || self.livePersonArray.count != studentArray.count) {
        self.livePersonArray = [studentArray deepCopy];
        [self.collectionView reloadData];
    } else {
        NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];

        NSInteger count = studentArray.count;
        for(NSInteger i = 0; i < count; i++) {
            UserModel *sourceModel = [self.livePersonArray objectAtIndex:i];
            UserModel *currentModel = [studentArray objectAtIndex:i];
            if(![sourceModel yy_modelIsEqual:currentModel]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
        }

        self.livePersonArray = [studentArray deepCopy];
        if(indexPaths.count > 0){
            [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        }
    }
}

- (void)updateStudentViews:(UserModel*)studentModel {
    if(studentModel == nil){
        return;
    }
    
    _voiceBtn.selected = studentModel.enableAudio;
    _cameraBtn.selected = studentModel.enableVideo;
    
    [self.educationManager muteRTCLocalVideo:studentModel.enableVideo == 0 ? YES : NO];
    [self.educationManager muteRTCLocalAudio:studentModel.enableAudio == 0 ? YES : NO];
}

- (void)showTipWithMessage:(NSString *)toastMessage {
    
    WEAK(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself showToast:toastMessage];
    });
}
    
#pragma mark SignalDelegate
- (void)didReceivedSignal:(SignalInfoModel *)signalInfoModel {
    switch (signalInfoModel.signalType) {
        case SignalValueCoVideo: {
            if(signalInfoModel.uid && signalInfoModel.uid == self.educationManager.teacherModel.uid) {
                [self checkNeedRenderWithRole:UserRoleTypeTeacher];
            } else {
                [self checkNeedRenderWithRole:UserRoleTypeStudent];
            }
        }
            break;
        case SignalValueAudio:
        case SignalValueVideo:
            if (signalInfoModel.uid && signalInfoModel.uid == self.educationManager.teacherModel.uid) {
                [self updateTeacherViews:self.educationManager.teacherModel];
            } else {
                [self reloadStudentViews];
            }
            break;
        case SignalValueChat: {
             [self updateChatViews];
        }
            break;
        case SignalValueGrantBoard: {
            
            if(signalInfoModel.uid == self.educationManager.studentModel.uid) {
                NSString *toastMessage;
                BOOL grantBoard = self.educationManager.studentModel.grantBoard;
                 if(grantBoard) {
                     toastMessage = NSLocalizedString(@"UnMuteBoardText", nil);
                 } else {
                     toastMessage = NSLocalizedString(@"MuteBoardText", nil);
                 }
                 [self showTipWithMessage:toastMessage];
                 [self disableWhiteDeviceInputs:!grantBoard];
            }
//            [self.studentListView updateStudentArray:self.educationManager.studentTotleListArray];
        }
            break;
        case SignalValueFollow: {
            NSString *toastMessage;
            BOOL lockBoard = self.educationManager.roomModel.lockBoard;
            if(lockBoard) {
                toastMessage = NSLocalizedString(@"LockBoardText", nil);
            } else {
                toastMessage = NSLocalizedString(@"UnlockBoardText", nil);
            }
            [self showTipWithMessage:toastMessage];
            [self disableCameraTransform:lockBoard];
        }
            break;
        case SignalValueCourse: {
            [self updateTimeState];
        }
            break;
        case SignalValueAllChat: {
            [self updateChatViews];
        }
            break;
        default:
            break;
    }
}

- (void)didReceivedConnectionStateChanged:(AgoraRtmConnectionState)state {
    if(state == AgoraRtmConnectionStateConnected) {

        if(self.hasSignalReconnect) {
            self.hasSignalReconnect = NO;
            [self updateViewOnReconnected];
        }
        
    } else if(state == AgoraRtmConnectionStateReconnecting) {
        
        self.hasSignalReconnect = YES;
        
        // When the signaling is abnormal, ensure that there is no voice and image of the current user in the current channel
        // 当信令异常的时候，保证当前频道内没有当前用户说话的声音和图像
        [self.educationManager muteRTCLocalVideo: YES];
        [self.educationManager muteRTCLocalAudio: YES];
        
    } else if(state == AgoraRtmConnectionStateDisconnected) {
        
        // When the signaling is abnormal, ensure that there is no voice and image of the current user in the current channel
        // 当信令异常的时候，保证当前频道内没有当前用户说话的声音和图像
        [self.educationManager muteRTCLocalVideo: YES];
        [self.educationManager muteRTCLocalAudio: YES];
        
    } else if(state == AgoraRtmConnectionStateAborted) {
        [self showToast:NSLocalizedString(@"LoginOnAnotherDeviceText", nil)];
//        [self.navigationView stopTimer];
        [self.educationManager releaseResources];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)updateViewOnReconnected {
    WEAK(self);
    [self.educationManager getRoomInfoCompleteSuccessBlock:^(RoomInfoModel * _Nonnull roomInfoModel) {
        
        [weakself updateTimeState];
        [weakself updateChatViews];

        [weakself disableCameraTransform:roomInfoModel.room.lockBoard];
        [weakself disableWhiteDeviceInputs:!weakself.educationManager.studentModel.grantBoard];

        [weakself checkNeedRenderWithRole:UserRoleTypeTeacher];
        [weakself checkNeedRenderWithRole:UserRoleTypeStudent];
        
    } completeFailBlock:^(NSString * _Nonnull errMessage) {
 
    }];
}

- (void)updateChatViews {
    
    RoomModel *roomModel = self.educationManager.roomModel;
    BOOL muteChat = roomModel != nil ? roomModel.muteAllChat : NO;
    if(!muteChat) {
        UserModel *studentModel = self.educationManager.studentModel;
        muteChat = studentModel.enableChat == 0 ? YES : NO;
    }
    self.chatCommentView.inputTextView.editable = muteChat ? NO : YES;
    self.chatCommentView.placeHoderLab.text = muteChat ? NSLocalizedString(@"ProhibitedPostText", nil) : NSLocalizedString(@"InputMessageText", nil);
}

- (void)updateTimeState {
    WEAK(self);
    RoomModel *roomModel = self.educationManager.roomModel;
    if(roomModel.courseState == ClassStateInClass) {
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval currenTimeInterval = [currentDate timeIntervalSince1970];
        weakself.timeCount = (NSInteger)((currenTimeInterval * 1000 - roomModel.startTime) * 0.001);
        [weakself startTimer];
    } else {
        [weakself stopTimer];
    }
}

- (void)disableCameraTransform:(BOOL)disableCameraTransform {
    [self.educationManager disableCameraTransform:disableCameraTransform];
    [self checkWhiteTouchViewVisible];
}

- (void)checkWhiteTouchViewVisible {
    self.whiteBoardView.hidden = YES;
    
    // follow
    if(self.educationManager.roomModel.lockBoard) {
        // permission
        if(self.educationManager.studentModel.grantBoard) {
            self.whiteBoardView.hidden = NO;
        }
    }
}

- (void)disableWhiteDeviceInputs:(BOOL)disable {
    [self.educationManager disableWhiteDeviceInputs:disable];
    [self checkWhiteTouchViewVisible];
}

- (void)updateTeacherViews:(UserModel*)teacherModel {
    if(teacherModel != nil){
        self.teacherFaceBackView.defaultImageView.hidden = teacherModel.enableVideo ? YES : NO;
    } else {
        self.teacherFaceBackView.defaultImageView.hidden = NO;
    }
}

#pragma mark RTCDelegate
- (void)rtcDidJoinedOfUid:(NSUInteger)uid {
    if(self.educationManager.teacherModel && uid == self.educationManager.teacherModel.screenId) {
        [self renderShareCanvas: uid];
    }
}
- (void)rtcDidOfflineOfUid:(NSUInteger)uid {
    if(self.educationManager.teacherModel && uid == self.educationManager.teacherModel.screenId) {
        [self removeShareCanvas];
    }
}


// MARK: - 声网频道(直播间)聊天频道创建 Channel
//- (void)createChannel:(NSString *)channel {
//    __weak LiveRoomViewController *weakSelf = self;
//    void(^errorHandle)(UIAlertAction *) = ^(UIAlertAction *action) {
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
//    channel = [NSString stringWithString:[EduConfigModel.shareInstance.className stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    AgoraRtmChannel *rtmChannel = [AgoraRtm.kit createChannelWithId:channel delegate:self];
//
//    if (!rtmChannel) {
//        [self showAlert:@"join channel fail" handle:errorHandle];
//    }
//
//    [rtmChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
//        if (errorCode != AgoraRtmJoinChannelErrorOk) {
//            NSString *alert = [NSString stringWithFormat:@"join channel error: %ld", errorCode];
//            [weakSelf showAlert:alert handle:errorHandle];
//        }
//    }];
//
//    self.rtmChannel = rtmChannel;
//}

// MARK: - 离开直播间
- (void)leaveChannel {
    [self.educationManager.signalManager releaseResources];
    [self.rtmChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        NSLog(@"leave channel error: %ld", (long)errorCode);
    }];
}

- (void)channelAppendRTM:(AgoraRtmMessage *)message {
    
    NSDictionary *dict = [JsonParseUtil dictionaryWithJsonString:message.text];
    NSInteger cmd = [dict[@"cmd"] integerValue];
    
    if(cmd == MessageCmdTypeChat) {
        
        MessageInfoModel *model = [MessageModel yy_modelWithDictionary:dict].data;
        
        if(![model.userId isEqualToString:self.educationManager.studentModel.userId]) {
            model.isSelfSend = NO;
        } else {
            model.isSelfSend = YES;
        }
        
        [_dataSource addObject:model];
        [_chatListTableView reloadData];
        if (_dataSource.count > 0) {
            [_chatListTableView scrollToRowAtIndexPath:
             [NSIndexPath indexPathForRow:[_dataSource count] - 1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
        }
    }
}

// 直播时长timer
- (void)startTimer {
//    self.timeCount = 0;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    
     WEAK(self);
    //每秒执行一次
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        int hours = weakself.timeCount / 3600;
        int minutes = (weakself.timeCount - (3600*hours)) / 60;
        int seconds = weakself.timeCount % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,seconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.timeLabel.text = strTime;
        });
        self.timeCount++;
    });
    dispatch_resume(timer);
}

- (void)stopTimer {
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

//// MARK: - 白板代理
//#pragma mark - board delegate
//- (void)onTEBRedoStatusChanged:(BOOL)canRedo
//{
//
//}
//
//- (void)onTEBUndoStatusChanged:(BOOL)canUndo
//{
//
//}
//
//// MARK: - 退出互动课堂
//- (void)onQuitClassRoom
//{
//    if (_isFullScreen) {
//        [self fullButtonClick:_fullScreenBtn];
//        return;
//    }
//    AppDelegate *app = [AppDelegate delegate];
//    app._allowRotation = NO;
//    [[[TICManager sharedInstance] getBoardController] removeDelegate:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[TICManager sharedInstance] removeEventListener:self];
//    [[TICManager sharedInstance] removeMessageListener:self];
//    __weak typeof(self) ws = self;
//    [[TICManager sharedInstance] quitClassroom:NO callback:^(TICModule module, int code, NSString *desc) {
//        if(code == 0){
//            //退出课堂成功
//        }
//        else{
//            //退出课堂失败
//        }
//        [ws.navigationController popViewControllerAnimated:YES];
//    }];
//}
//
//// MARK: - 开关摄像头
//- (void)swicthCamera:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    [_livePersonArray removeObject:_userId];
//    if (sender.selected) {
//        [_livePersonArray addObject:_userId];
//    } else {
//        [[[TICManager sharedInstance] getTRTCCloud] stopLocalPreview];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [CATransaction setDisableActions:YES];
//
//        [_collectionView reloadData];
//
//        [CATransaction commit];
//    });
//}
//
//// MARK: - 开关麦克风
//- (void)switchVoice:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [[[TICManager sharedInstance] getTRTCCloud] startLocalAudio];
//    } else {
//        [[[TICManager sharedInstance] getTRTCCloud] stopLocalAudio];
//    }
//}
//
//// MARK: - event listener
//- (void)onTICUserVideoAvailable:(NSString *)userId available:(BOOL)available
//{
//    if(available){
//        [_livePersonArray addObject:userId];
//    }
//    else{
//        [_livePersonArray removeObject:userId];
//        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:userId];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [CATransaction setDisableActions:YES];
//
//        [_collectionView reloadData];
//
//        [CATransaction commit];
//    });
//}
//
//- (void)onTICUserSubStreamAvailable:(NSString *)userId available:(BOOL)available
//{
////    if(available){
////        [_livePersonArray addObject:userId];
////    }
////    else{
////        [_livePersonArray removeObject:userId];
////        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:userId];
////    }
////    dispatch_async(dispatch_get_main_queue(), ^{
////
////        [CATransaction setDisableActions:YES];
////
////        [_collectionView reloadData];
////
////        [CATransaction commit];
////    });
//}
//
//
//-(void)onTICMemberJoin:(NSArray*)members {
//    NSString *msgInfo = [NSString stringWithFormat:@"[%@] %@",members.firstObject, @"加入了房间"];
//    [self showHudInView:self.view showHint:msgInfo];
////    self.chatView.text = [NSString stringWithFormat:@"%@\n%@",self.chatView.text, msgInfo];;
//}
//
//-(void)onTICMemberQuit:(NSArray*)members {
//
//    if ([members.firstObject isEqualToString:[[TIMManager sharedInstance] getLoginUser]]) {
//        [self showAlertWithTitle:@"退出课堂" msg:@"你被老师踢出了房间" handler:^(UIAlertAction *action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    }
//    NSString *msgInfo = [NSString stringWithFormat:@"[%@] %@",members.firstObject, @"退出了房间"];
//    [self showHudInView:self.view showHint:msgInfo];
////    self.chatView.text = [NSString stringWithFormat:@"%@\n%@",self.chatView.text, msgInfo];;
//}
//
//
//-(void)onTICClassroomDestroy {
//    [self showAlertWithTitle:@"课程结束" msg:@"老师已经结束了该堂课程" handler:^(UIAlertAction *action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//
//}
//
//// MARK: - 改变房间人数显示UI
//- (void)changeRoomMenberCountUI {
//    NSInteger roomcount = 0;
//    if ([_livePersonArray containsObject:_userId]) {
//        roomcount = _livePersonArray.count;
//    } else {
//        roomcount = _livePersonArray.count + 1;
//    }
//    NSString *roomMember = [NSString stringWithFormat:@"%@",@(roomcount)];
//    CGFloat roomMemberWidth = [roomMember sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
//    CGFloat space1 = 5.0;
//    _roomPersonCountBtn.frame= CGRectMake(_fullScreenBtn.left - 7.5 - roomMemberWidth, 0, roomMemberWidth, 37);
//    _roomPersonCountBtn.centerY = 37/2.0;
//    [_roomPersonCountBtn setImage:Image(@"live_member") forState:0];
//    [_roomPersonCountBtn setTitle:roomMember forState:0];
//    _roomPersonCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space1/2.0, 0, space1/2.0);
//    _roomPersonCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space1/2.0, 0, -space1/2.0);
//}

@end
