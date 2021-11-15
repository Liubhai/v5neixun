//
//  CourseDetailPlayVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseDetailPlayVC.h"
#import "V5_Constant.h"
#import "StarEvaluator.h"
#import "EdulineV5_Tool.h"
#import "Net_Path.h"
#import "CourseDownView.h"
#import "CourseContentView.h"
#import "CourseCouponView.h"
#import "CourseTeacherAndOrganizationView.h"
#import "CourseCommentListVC.h"
#import "CourseCommentViewController.h"
#import "CourseIntroductionVC.h"
#import "CourseListVC.h"
#import "CourseTreeListViewController.h"
#import "OrderViewController.h"

//
#import "CourseListModelFinal.h"

//播放器
#import "AliyunVodPlayerView.h"
#import "AliyunUtil.h"
#import "AlivcVideoPlayListModel.h"
#import "AppDelegate.h"

// 直播测试
#import "TICManager.h"
#import "TICConfig.h"

// 声网直播测试
#import "LiveRoomViewController.h"
#import "BCLiveRoomViewController.h"
#import "OneToOneLiveRoomVC.h"
//#import "AgoraRtm.h"
#import "V5_UserModel.h"
// 分享
#import <UShareUI/UShareUI.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <WechatOpenSDK/WXApi.h>

#import "AppDelegate.h"

#import "SharePosterViewController.h"

// pdf
#import <PDFKit/PDFKit.h>

// 新版记笔记
#import "CourseMakeNoteVC.h"

/** CC直播 */
#import "CCPlayerController.h"
#import "CCSDK/CCLiveUtil.h"
#import "CCSDK/RequestData.h"
#import "CCPlayBackController.h"
#import "CCSDK/RequestDataPlayBack.h"

/** CC云课堂 */
#import <HSRoomUI/HSRoomUI.h>
#import "CCScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CCLoginViewController.h"
#import "CCLoginDirectionViewController.h"
#import <CCClassRoomBasic/CCClassRoomBasic.h>
#import <HSRoomUI/HSRoomUI.h>
#import "CCTicketVoteView.h"
#import "CCTickeResultView.h"
#import "CCBrainView.h"
#import "CCClassCodeView.h"
#import "CCUrlLoginView.h"
#import "CCRoomDecModel.h"
#import "CCPlayViewController.h"
#import "CCPushViewController.h"
#import "YUNLanguage.h"

// test
#import "CCLoginScanViewController.h"

#define FacePlayImageHeight 207

//清晰度【FD(流畅)，LD(标清)，SD(高清)，HD(超清)，OD(原画)，2K(2K)，4K(4K)。】

@interface CourseDetailPlayVC ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,CourseTeacherAndOrganizationViewDelegate,CourseCouponViewDelegate,CourseDownViewDelegate,CourseContentViewDelegate,AliyunVodPlayerViewDelegate,CourseListVCDelegate,CourseTreeListViewControllerDelegate,WKUIDelegate,WKNavigationDelegate,RequestDataDelegate,RequestDataPlayBackDelegate, CCClassCodeViewDelegate> {
    // 新增内容
    CGFloat sectionHeight;
    BOOL shouldStopRecordTimer;//阻止记录定时器方法执行
    CourseListModelFinal *currentCourseFinalModel;
    BOOL     isWebViewBig;//文档 是否放大
    BOOL freeLook;
    BOOL isFullS;//当前是否全屏
    BOOL shouldLoad;
    
    NSInteger wordMax;
    CGFloat keyHeight;
    
    // 图文电子书观看时长 计时
    NSInteger eventTime;
    NSTimer *eventTimer;
}

@property (strong, nonatomic) UIButton *zanButton;

/**三大子页面*/
@property (strong, nonatomic) CourseTreeListViewController *courseTreeListVC;
@property (strong, nonatomic) CourseListVC *courseListVC;
@property (strong, nonatomic) CourseCommentListVC *recordVC;
@property (strong, nonatomic) CourseCommentListVC *commentVC;

/**封面*/
@property (strong, nonatomic) UIImageView *faceImageView;

/**顶部内容*/
@property (strong, nonatomic) CourseContentView *courseContentView;

/**优惠卷*/
@property (strong, nonatomic) CourseCouponView *couponContentView;

/** 机构和讲师移动到头部视图里面了 */
@property (strong, nonatomic) CourseTeacherAndOrganizationView *teachersHeaderBackView;
@property (strong, nonatomic) NSDictionary *schoolInfo;
@property (strong, nonatomic) NSDictionary *teacherInfoDict;

/**子视图个数*/
@property (strong, nonatomic) NSMutableArray *tabClassArray;

///新增内容
@property (strong, nonatomic) LBHTableView *tableView;
@property (nonatomic, retain) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) UIView *buttonBackView;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) UIButton *courseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *questionButton;
@property (nonatomic, strong) UIImageView *seeFreeIcon;
@property (nonatomic, strong) UIView *blueLineView;

/// 底部全部设置为全局变量为了好处理交互
@property (nonatomic, strong) UIView *bg;

/**更多按钮弹出视图*/
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong, nonatomic) CourseDownView *courseDownView;

// 播放器
@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;
@property (strong, nonatomic) NSMutableArray *playFileUrlArray;// 音视频清晰度数组
@property (nonatomic,strong) UIImageView  *freeLookShowImageView;
@property (strong, nonatomic) UIView *freeLookView;
@property (strong, nonatomic) UILabel *freeLabel;
@property (strong, nonatomic) UIButton *buyCourseButton;
@property (strong, nonatomic) UIButton *buyhourseButton;

@property (strong, nonatomic) WKWebIntroview *wkWebView;
@property (strong, nonatomic) PDFView *pdfV;
@property (strong, nonatomic) NSTimer *recordTimer;

// 声网直播
@property (nonatomic, strong) BaseEducationManager *educationManager;

// 图文播放时候切换全屏或者半屏按钮
@property (strong, nonatomic) UIButton *tuwenFullButton;

// 记笔记弹框
@property (strong, nonatomic) UIView *popWhiteView;
@property (strong, nonatomic) UIButton *popCancelButton;
//@property (strong, nonatomic) UIView *popTextBackView;
@property (strong, nonatomic) UITextView *popTextView;
@property (strong, nonatomic) UILabel *popTextPlaceholderLabel;
@property (strong, nonatomic) UILabel *popTextMaxCountView;
@property (strong, nonatomic) UIButton *openButton;
@property (strong, nonatomic) UIButton *popSureButton;


/** 直播房间名字 */
@property (nonatomic, copy) NSString *roomName;//房间名
@property (nonatomic,strong)RequestDataPlayBack         *requestDataPlayBack;


/** 云课堂 */
@property(nonatomic, strong)CCClassCodeView *classCodeView;
@property(nonatomic, strong)CCUrlLoginView *urlLoginView;
@property(nonatomic, strong)CCRoomDecModel *descModel;
@property(nonatomic, assign)BOOL isUrlLogin;
@property(nonatomic, strong) CCPlayViewController *playVC;
@property(nonatomic, strong) CCPushViewController *pushVC;
@property(nonatomic,strong)LoadingView          *loadingView;

@property(nonatomic,strong)HSLiveViewController *liveVC;
@property (assign, nonatomic) CCRole role;//角色
@property (assign, nonatomic) NSInteger ccClassRoomrole;//角色
@property(nonatomic, assign)BOOL needPassword;
@property(nonatomic, copy)NSString *sessionID;
@property(nonatomic, strong)id loginInfo;
@property(nonatomic, assign)BOOL isLandSpace;
@property(nonatomic, assign)BOOL isLoading;

@end

@implementation CourseDetailPlayVC

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillAppear:animated];
    
//    if (shouldLoad) {
//        [self getCourseInfo];
//    }
//    shouldLoad = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_recordTimer != nil) {
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    __weak CourseDetailPlayVC *wekself = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:wekself];
    [NSObject cancelPreviousPerformRequestsWithTarget:wekself selector:@selector(startTimer) object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self destroyPlayVideo];
    if (eventTimer) {
        if (eventTime>0 && eventTime<10) {
            [self tuwenRequestCurrentSecond:_currentHourseId];
            eventTime = 0;
        }
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

- (void)destroyPlayVideo{
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView setDelegate:nil];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    wordMax = 400;
    freeLook = NO;
    isWebViewBig = NO;
    shouldStopRecordTimer = YES;
    _isClassNew = YES;
    /// 新增内容
    _canScroll = NO;
    _canScrollAfterVideoPlay = NO;
    _tableView.scrollEnabled = NO;
    
    _playFileUrlArray = [NSMutableArray new];
    
    if (_isLive) {
        _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录",@"点评"]];
        if ([ShowCourseComment isEqualToString:@"0"]) {
            _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录"]];
        }
    } else {
        _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录",@"笔记",@"点评"]];
        if ([ShowCourseComment isEqualToString:@"0"] && [ShowCourseNote isEqualToString:@"0"]) {
            _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录"]];
        } else {
            if ([ShowCourseComment isEqualToString:@"0"]) {
                _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录",@"笔记"]];
            }
            if ([ShowCourseNote isEqualToString:@"0"]) {
                _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录",@"点评"]];
            }
        }
    }

    _titleLabel.text = @"课程详情";
    _titleImage.backgroundColor = BasidColor;
    
    _titleLabel.textColor = [UIColor whiteColor];
    
    _zanButton = [[UIButton alloc] initWithFrame:CGRectMake(_rightButton.left - 44, _rightButton.top, 44, 44)];
    [_zanButton setImage:Image(@"course_collect_nor") forState:0];
    [_zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_zanButton];
    
    [self makeHeaderView];
    [self makeSubViews];
//    self.playerView.hidden = YES;
//    self.playerView.coverImageView.image = DefaultImage;
    if (!_isLive) {
        [_headerView addSubview:self.playerView];
        [self makeWkWebView];
    }
    
    _freeLookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.playerView.width, self.playerView.height)];
    _freeLookView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor;
    _freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    _freeLabel.font = SYSTEMFONT(16);
    _freeLabel.text = @"试看已结束";
    _freeLabel.textColor = HEXCOLOR(0xEBEEF5);
    _freeLabel.textAlignment = NSTextAlignmentCenter;
    _freeLabel.center = CGPointMake(self.playerView.width / 2.0, self.playerView.height / 2.0 - 64 / 2.0 + 22 / 2.0);
    [_freeLookView addSubview:_freeLabel];
    
    _buyCourseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _freeLabel.bottom + 12, 105, 30)];
    [_buyCourseButton setTitle:@"去购买该课程" forState:0];
    [_buyCourseButton setTitleColor:[UIColor whiteColor] forState:0];
    _buyCourseButton.backgroundColor = EdlineV5_Color.themeColor;
    _buyCourseButton.titleLabel.font = SYSTEMFONT(14);
    _buyhourseButton.hidden = YES;
    [_buyCourseButton addTarget:self action:@selector(buyCourseAndHourseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _buyCourseButton.layer.masksToBounds = YES;
    _buyCourseButton.layer.cornerRadius = 4;
    [_freeLookView addSubview:_buyCourseButton];
    
    _buyhourseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _freeLabel.bottom + 12, 105, 30)];
    [_buyhourseButton setTitle:@"去购买该课时" forState:0];
    [_buyhourseButton setTitleColor:[UIColor whiteColor] forState:0];
    _buyhourseButton.backgroundColor = EdlineV5_Color.themeColor;
    _buyhourseButton.titleLabel.font = SYSTEMFONT(14);
    _buyhourseButton.hidden = YES;
    [_buyhourseButton addTarget:self action:@selector(buyCourseAndHourseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _buyhourseButton.layer.masksToBounds = YES;
    _buyhourseButton.layer.cornerRadius = 4;
    [_freeLookView addSubview:_buyhourseButton];
    
//    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT - (_isLive ? 0 : 50);
    [self makeTableView];
    [self.view bringSubviewToFront:_titleImage];
    _titleImage.backgroundColor = [UIColor clearColor];
    _titleLabel.hidden = YES;
    _lineTL.hidden = YES;
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"course_share_icon") forState:0];
    [_leftButton setImage:Image(@"course_back_icon") forState:0];
    if (!_isLive) {
        [self makeDownView];
    }
    [self getCourseInfo];
    /**************************************/
    if (!_isLive) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignActive)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(willResignActive)
            name:UIApplicationWillResignActiveNotification
          object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCourseInfo) name:@"reloadCourseDetailData" object:nil];
//    [self dealPlayWordBook];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScanSuccess:) name:@"ScanSuccess" object:nil];
}

- (AliyunVodPlayerView *__nullable)playerView{
    if (!_playerView) {
        CGFloat width = 0;
        CGFloat height = 0;
        CGFloat topHeight = 0;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait ) {
            width = ScreenWidth;
            height = ScreenWidth * 9 / 16.0;
            topHeight = 0;
        }else{
            width = ScreenWidth;
            height = ScreenHeight;
            topHeight = 0;
        }
        /****************UI播放器集成内容**********************/
        _playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,topHeight, width, height) andSkin:AliyunVodPlayerViewSkinRed];
        _playerView.backgroundColor = [UIColor whiteColor];
//        AlivcVideoPlayListModel *currentModel = [[AlivcVideoPlayListModel alloc] init];
//        currentModel.videoUrl = @"https://hls.videocc.net/cf754ccb6d/c/cf754ccb6d0cb61da723e3a2000ec0df_1.m3u8";
//        currentModel.playMethod = AliyunPlayMedthodSTS;
//        _playerView.currentModel = currentModel;
        __weak CourseDetailPlayVC *wekself = self;
        [_playerView setDelegate:wekself];
        [_playerView setAutoPlay:YES];
        
        [_playerView setPrintLog:YES];
        _playerView.controlView.topView.hidden = YES;
        _playerView.isScreenLocked = false;
        _playerView.fixedPortrait = false;
        _playerView.hidden = YES;
    }
    return _playerView;
}

- (void)makeWkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebIntroview alloc] initWithFrame:self.playerView.frame];
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.userInteractionEnabled = YES;
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        [self.headerView addSubview:_wkWebView];
        _wkWebView.hidden = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fakeTapGestureHandler:)];
        [tapGestureRecognizer setDelegate:self];
        [_wkWebView.scrollView addGestureRecognizer:tapGestureRecognizer];
        
        _pdfV = [[PDFView alloc] initWithFrame:_wkWebView.frame];
        _pdfV.autoScales = YES;
        [_wkWebView addSubview:_pdfV];
        _pdfV.hidden = YES;
        
        _tuwenFullButton = [[UIButton alloc] initWithFrame:CGRectMake(_wkWebView.width - 51 - 10, _wkWebView.height - 51 - 10, 51, 51)];
        [_tuwenFullButton setImage:Image(@"shu") forState:0];
        [_tuwenFullButton addTarget:self action:@selector(tuwenFullButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_wkWebView addSubview:_tuwenFullButton];
    }
}

- (void)fakeTapGestureHandler:(UITapGestureRecognizer *)tap {
    __weak CourseDetailPlayVC *wekself = self;
    isWebViewBig = !isWebViewBig;
    if (isWebViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.wkWebView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            wekself.pdfV.frame = wekself.wkWebView.frame;
            _tuwenFullButton.frame = CGRectMake(wekself.wkWebView.width - 51 - 10, wekself.wkWebView.height - 51 - 10, 51, 51);
            [wekself.view addSubview:wekself.wkWebView];
            //方法 隐藏导航栏
            wekself.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.wkWebView.frame = self.playerView.frame;
            wekself.pdfV.frame = wekself.wkWebView.frame;
            _tuwenFullButton.frame = CGRectMake(wekself.wkWebView.width - 51 - 10, wekself.wkWebView.height - 51 - 10, 51, 51);
            [wekself.headerView addSubview:wekself.wkWebView];
            wekself.navigationController.navigationBar.hidden = YES;
        }];
    }
}

// MARK: - 图文时候半屏和全屏按钮点击事件
- (void)tuwenFullButtonClick:(UIButton *)sender {
    __weak CourseDetailPlayVC *wekself = self;
    isWebViewBig = !isWebViewBig;
    if (isWebViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.wkWebView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            wekself.pdfV.frame = wekself.wkWebView.frame;
            _tuwenFullButton.frame = CGRectMake(wekself.wkWebView.width - 51 - 10, wekself.wkWebView.height - 51 - 10, 51, 51);
            [wekself.view addSubview:wekself.wkWebView];
            //方法 隐藏导航栏
            wekself.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.wkWebView.frame = self.playerView.frame;
            wekself.pdfV.frame = wekself.wkWebView.frame;
            _tuwenFullButton.frame = CGRectMake(wekself.wkWebView.width - 51 - 10, wekself.wkWebView.height - 51 - 10, 51, 51);
            [wekself.headerView addSubview:wekself.wkWebView];
            wekself.navigationController.navigationBar.hidden = YES;
        }];
    }
}

// MARK: - tableview 的 headerview
- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    _headerView.backgroundColor = [UIColor whiteColor];
}

// MARK: - tableview
- (void)makeTableView {
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - MACRO_UI_LIUHAI_HEIGHT) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}

// MARK: - headerview的子视图
- (void)makeSubViews {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, FacePlayImageHeight)];
    _faceImageView.image = DefaultImage;
    [_headerView addSubview:_faceImageView];
    
    _courseContentView = [[CourseContentView alloc] initWithFrame:CGRectMake(0, _faceImageView.bottom, MainScreenWidth, 86 + 4)];//[_courseType isEqualToString:@"4"] ? (86- 35 + 4) : (86 + 4)
    _courseContentView.delegate = self;
    [_headerView addSubview:_courseContentView];
    
    /**优惠卷*/
//    _couponContentView = [[CourseCouponView alloc] initWithFrame:CGRectMake(0, _courseContentView.bottom, MainScreenWidth, 52)];
//    _couponContentView.delegate = self;
//    [_headerView addSubview:_couponContentView];
//    /**机构讲师*/
//    if (_teachersHeaderBackView == nil) {
//        _teachersHeaderBackView = [[CourseTeacherAndOrganizationView alloc] initWithFrame:CGRectMake(0, _couponContentView.bottom, MainScreenWidth, 59)];
//        [_headerView addSubview:_teachersHeaderBackView];
//
//        [_teachersHeaderBackView setHeight:0];
//        _teachersHeaderBackView.hidden = YES;
//        _teachersHeaderBackView.delegate = self;
//    }
    [_headerView setHeight:_courseContentView.bottom];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - _headerView.height;
    if ([ShowCourseNote isEqualToString:@"0"]) {
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - _headerView.height;
    }
}

// MARK: - 底部视图(咨询、加入购物车、加入学习)
- (void)makeDownView {
    _courseDownView = [[CourseDownView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT) isRecord:YES];
    _courseDownView.delegate = self;
    [self.view addSubview:_courseDownView];
    if ([ShowCourseNote isEqualToString:@"0"]) {
        _courseDownView.hidden = YES;
    } else {
        _courseDownView.hidden = NO;
    }
}

// MARK - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifireAC =@"ActivityListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifireAC];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifireAC];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_bg == nil) {
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        _bg.backgroundColor = [UIColor whiteColor];
    } else {
        _bg.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
    }
    if (sectionHeight>1) {
        if (_introButton == nil) {
            for (int i = 0; i < _tabClassArray.count; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*i/_tabClassArray.count * 1.0, 0, MainScreenWidth/_tabClassArray.count * 1.0, 47)];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:_tabClassArray[i] forState:0];
                btn.titleLabel.font = SYSTEMFONT(15);
                [btn setTitleColor:[UIColor blackColor] forState:0];
                [btn setTitleColor:BasidColor forState:UIControlStateSelected];
                if (_isLive) {
                    if (i == 0) {
                        self.introButton = btn;
                    } else if (i == 1) {
                        self.commentButton = btn;
                    } else if (i == 2) {
                        self.courseButton = btn;
                    }
                    [_bg addSubview:btn];
                } else {
                    if (i == 0) {
                        self.introButton = btn;
                    } else if (i == 1) {
                        self.courseButton = btn;
                    } else if (i == 2) {
                        self.commentButton = btn;
                    }
                    [_bg addSubview:btn];
                }
            }
            
            // 添加试看标志
            self.seeFreeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 14)];
            self.seeFreeIcon.image = Image(@"see_icon");
            if (self.introButton) {
                [self.seeFreeIcon setOrigin:CGPointMake(self.introButton.width / 2.0 + 17, self.introButton.height / 2.0 - 14)];
                self.seeFreeIcon.hidden = YES;
                [self.introButton addSubview:self.seeFreeIcon];
            }
            
            if (SWNOTEmptyDictionary(self.dataSource)) {
                NSString *audition_stat = [NSString stringWithFormat:@"%@",self.dataSource[@"audition_stat"]];
                self.seeFreeIcon.hidden = [audition_stat boolValue] ? NO : YES;
                if ([[self.dataSource objectForKey:@"is_buy"] boolValue]) {
                    self.seeFreeIcon.hidden = YES;
                }
            }
            
            self.introButton.selected = YES;
            
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, MainScreenWidth, 1)];
            grayLine.backgroundColor = EdlineV5_Color.fengeLineColor;
            [_bg addSubview:grayLine];
            
            self.blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 20, 2)];
            self.blueLineView.backgroundColor = EdlineV5_Color.themeColor;
            self.blueLineView.centerX = self.introButton.centerX;
            [_bg addSubview:self.blueLineView];
            
        }
        
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,47, MainScreenWidth, sectionHeight - 47)];
            self.mainScroll.contentSize = CGSizeMake(MainScreenWidth*_tabClassArray.count, 0);
            self.mainScroll.pagingEnabled = YES;
            self.mainScroll.showsHorizontalScrollIndicator = NO;
            self.mainScroll.showsVerticalScrollIndicator = NO;
            self.mainScroll.bounces = NO;
            self.mainScroll.delegate = self;
            [_bg addSubview:self.mainScroll];
        } else {
            self.mainScroll.frame = CGRectMake(0,47, MainScreenWidth, sectionHeight - 47);
        }
        __weak typeof(self) weakself = self;
        if ([_courseType isEqualToString:@"4"]) {
            if (_courseTreeListVC == nil) {
                _courseTreeListVC = [[CourseTreeListViewController alloc] init];
                _courseTreeListVC.courseId = weakself.ID;
                _courseTreeListVC.courselayer = weakself.courselayer;
                _courseTreeListVC.isMainPage = NO;
                _courseTreeListVC.sid = weakself.sid;
                _courseTreeListVC.tabelHeight = sectionHeight - 47;
                _courseTreeListVC.detailVC = weakself;
                _courseTreeListVC.delegate = weakself;
                _courseTreeListVC.cellTabelCanScroll = YES;//weakself.canScrollAfterVideoPlay;
                _courseTreeListVC.videoInfoDict = _dataSource;
                _courseTreeListVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
                [weakself.mainScroll addSubview:weakself.courseTreeListVC.view];
                [weakself addChildViewController:weakself.courseTreeListVC];
            } else {
                _courseTreeListVC.courseId = weakself.ID;
                _courseTreeListVC.courselayer = weakself.courselayer;
                _courseTreeListVC.isMainPage = NO;
                _courseTreeListVC.sid = weakself.sid;
                _courseTreeListVC.tabelHeight = sectionHeight - 47;
                _courseTreeListVC.detailVC = weakself;
                _courseTreeListVC.delegate = weakself;
                _courseTreeListVC.cellTabelCanScroll = YES;
                _courseTreeListVC.videoInfoDict = weakself.dataSource;
                _courseTreeListVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
                _courseTreeListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseTreeListVC getClassCourseList];
            }
        } else {
            if (_courseListVC == nil) {
                _courseListVC = [[CourseListVC alloc] init];
                _courseListVC.courseId = weakself.ID;
                _courseListVC.courselayer = weakself.courselayer;
                _courseListVC.isMainPage = NO;
                _courseListVC.isClassCourse = weakself.isClassNew;
                _courseListVC.sid = weakself.sid;
                _courseListVC.tabelHeight = sectionHeight - 47;
                _courseListVC.detailVC = weakself;
                _courseListVC.delegate = weakself;
                _courseListVC.cellTabelCanScroll = YES;//weakself.canScrollAfterVideoPlay;
                _courseListVC.videoInfoDict = _dataSource;
                _courseListVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
                [weakself.mainScroll addSubview:weakself.courseListVC.view];
                [weakself addChildViewController:weakself.courseListVC];
            } else {
                _courseListVC.courseId = weakself.ID;
                _courseListVC.courselayer = weakself.courselayer;
                _courseListVC.isMainPage = NO;
                _courseListVC.isClassCourse = weakself.isClassNew;
                _courseListVC.sid = weakself.sid;
                _courseListVC.tabelHeight = sectionHeight - 47;
                _courseListVC.detailVC = weakself;
                _courseListVC.delegate = weakself;
                _courseListVC.cellTabelCanScroll = YES;
                _courseListVC.videoInfoDict = weakself.dataSource;
                _courseListVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
                _courseListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseListVC getCourseListData];
            }
        }
        
        if (_isLive) {
            if ([ShowCourseComment isEqualToString:@"1"]) {
                if (_commentVC == nil) {
                    _commentVC = [[CourseCommentListVC alloc] init];
                    _commentVC.courseId = _ID;
                    _commentVC.tabelHeight = sectionHeight - 47;
                    _commentVC.detailVC = weakself;
                    _commentVC.cellType = NO;
                    _commentVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                    _commentVC.view.frame = CGRectMake(_isLive ? MainScreenWidth : MainScreenWidth * 2,0, MainScreenWidth, sectionHeight - 47);
                    [self.mainScroll addSubview:_commentVC.view];
                    [self addChildViewController:_commentVC];
                } else {
                    _commentVC.courseId = _ID;
                    _commentVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                    _commentVC.view.frame = CGRectMake(_isLive ? MainScreenWidth : MainScreenWidth * 2,0, MainScreenWidth, sectionHeight - 47);
                    _commentVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                }
            } else {
                
            }
        } else {
            if ([ShowCourseComment isEqualToString:@"1"] && [ShowCourseNote isEqualToString:@"1"]) {
                if (_recordVC == nil) {
                    _recordVC = [[CourseCommentListVC alloc] init];
                    _recordVC.courseId = _ID;
                    _recordVC.tabelHeight = sectionHeight - 47;
                    _recordVC.detailVC = weakself;
                    _recordVC.cellType = YES;
                    _recordVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                    _recordVC.view.frame = CGRectMake(_isLive ? MainScreenWidth * 2 : MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                    [self.mainScroll addSubview:_recordVC.view];
                    [self addChildViewController:_recordVC];
                } else {
                    _recordVC.courseId = _ID;
                    _recordVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                    _recordVC.view.frame = CGRectMake(_isLive ? MainScreenWidth * 2 : MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                    _recordVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                }

                if (_commentVC == nil) {
                    _commentVC = [[CourseCommentListVC alloc] init];
                    _commentVC.courseId = _ID;
                    _commentVC.tabelHeight = sectionHeight - 47;
                    _commentVC.detailVC = weakself;
                    _commentVC.cellType = NO;
                    _commentVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                    _commentVC.view.frame = CGRectMake(_isLive ? MainScreenWidth : MainScreenWidth * 2,0, MainScreenWidth, sectionHeight - 47);
                    [self.mainScroll addSubview:_commentVC.view];
                    [self addChildViewController:_commentVC];
                } else {
                    _commentVC.courseId = _ID;
                    _commentVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                    _commentVC.view.frame = CGRectMake(_isLive ? MainScreenWidth : MainScreenWidth * 2,0, MainScreenWidth, sectionHeight - 47);
                    _commentVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                }
            } else {
                if ([ShowCourseNote isEqualToString:@"1"]) {
                    if (_recordVC == nil) {
                        _recordVC = [[CourseCommentListVC alloc] init];
                        _recordVC.courseId = _ID;
                        _recordVC.tabelHeight = sectionHeight - 47;
                        _recordVC.detailVC = weakself;
                        _recordVC.cellType = YES;
                        _recordVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                        _recordVC.view.frame = CGRectMake(_isLive ? MainScreenWidth * 2 : MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                        [self.mainScroll addSubview:_recordVC.view];
                        [self addChildViewController:_recordVC];
                    } else {
                        _recordVC.courseId = _ID;
                        _recordVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                        _recordVC.view.frame = CGRectMake(_isLive ? MainScreenWidth * 2 : MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                        _recordVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                    }
                }
                if ([ShowCourseComment isEqualToString:@"1"]) {
                    if (_commentVC == nil) {
                        _commentVC = [[CourseCommentListVC alloc] init];
                        _commentVC.courseId = _ID;
                        _commentVC.tabelHeight = sectionHeight - 47;
                        _commentVC.detailVC = weakself;
                        _commentVC.cellType = NO;
                        _commentVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                        _commentVC.view.frame = CGRectMake(_isLive ? MainScreenWidth : MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                        [self.mainScroll addSubview:_commentVC.view];
                        [self addChildViewController:_commentVC];
                    } else {
                        _commentVC.courseId = _ID;
                        _commentVC.cellTabelCanScroll = YES;//!_canScrollAfterVideoPlay;
                        _commentVC.view.frame = CGRectMake(_isLive ? MainScreenWidth : MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                        _commentVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                    }
                }
            }
        }
    }
    if (SWNOTEmptyDictionary(self.dataSource)) {
        NSString *audition_stat = [NSString stringWithFormat:@"%@",self.dataSource[@"audition_stat"]];
        self.seeFreeIcon.hidden = [audition_stat boolValue] ? NO : YES;
        if ([[self.dataSource objectForKey:@"is_buy"] boolValue]) {
            self.seeFreeIcon.hidden = YES;
        }
    }
    return _bg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - 子视图导航按钮点击事件
- (void)buttonClick:(UIButton *)sender{
    if (sender == self.introButton) {
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.courseButton) {
        [self.mainScroll setContentOffset:CGPointMake(_isLive ? MainScreenWidth * 2 : MainScreenWidth, 0) animated:YES];
    } else if (sender == self.commentButton) {
        [self.mainScroll setContentOffset:CGPointMake(_isLive ? MainScreenWidth : MainScreenWidth * 2, 0) animated:YES];
    } else if (sender == self.recordButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 3, 0) animated:YES];
    } else if (sender == self.questionButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 4, 0) animated:YES];
    }
}

// MARK: - 滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScroll) {
        if (scrollView.contentOffset.x <= 0) {
            self.blueLineView.centerX = self.introButton.centerX;
            self.introButton.selected = YES;
            self.courseButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.blueLineView.centerX = self.commentButton.centerX;
            self.commentButton.selected = YES;
            self.introButton.selected = NO;
            self.courseButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            if (_isLive) {
                self.blueLineView.centerX = self.commentButton.centerX;
                self.courseButton.selected = NO;
                self.introButton.selected = NO;
                self.commentButton.selected = YES;
                self.recordButton.selected = NO;
                self.questionButton.selected = NO;
            } else {
                self.blueLineView.centerX = self.courseButton.centerX;
                self.courseButton.selected = YES;
                self.introButton.selected = NO;
                self.commentButton.selected = NO;
                self.recordButton.selected = NO;
                self.questionButton.selected = NO;
            }
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.blueLineView.centerX = self.recordButton.centerX;
            self.courseButton.selected = NO;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = YES;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 4*MainScreenWidth){
            self.blueLineView.centerX = self.questionButton.centerX;
            self.courseButton.selected = NO;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = YES;
        }
    } if (scrollView == self.tableView) {
        CGFloat bottomCellOffset = self.headerView.height - MACRO_UI_UPHEIGHT;
        if (scrollView.contentOffset.y > bottomCellOffset - 0.5) {
            _titleImage.backgroundColor = EdlineV5_Color.themeColor;
            _titleLabel.hidden = NO;
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.introButton.selected) {
                        if ([_courseType isEqualToString:@"4"]) {
                            if ([vc isKindOfClass:[CourseTreeListViewController class]]) {
                                CourseTreeListViewController *vccomment = (CourseTreeListViewController *)vc;
                                vccomment.cellTabelCanScroll = YES;
                            }
                        } else {
                            if ([vc isKindOfClass:[CourseListVC class]]) {
                                CourseListVC *vccomment = (CourseListVC *)vc;
                                vccomment.cellTabelCanScroll = YES;
                            }
                        }
                    }
                    if (self.courseButton.selected) {
                        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
                            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
                            if ([ShowCourseNote isEqualToString:@"1"]) {
                                if (vccomment.cellType) {
                                    // 笔记
                                    vccomment.cellTabelCanScroll = YES;
                                }
                            } else {
                                if (!vccomment.cellType) {
                                    // 评论
                                    vccomment.cellTabelCanScroll = YES;
                                }
                            }
                        }
                    }
                    if (self.commentButton.selected) {
                        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
                            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
                            if (!vccomment.cellType) {
                                vccomment.cellTabelCanScroll = YES;
                            }
                        }
                    }
                }
            }
        }else{
            _titleImage.backgroundColor = [UIColor clearColor];
            _titleLabel.hidden = YES;
            if (!self.canScroll) {//子视图没到顶部
                if (self.canScrollAfterVideoPlay) {
                    scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
                } else {
                    scrollView.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    }
}

// MARK: - 机构讲师信息赋值
- (void)setTeacherAndOrganizationData {
    if (SWNOTEmptyDictionary(_schoolInfo)) {
        [_teachersHeaderBackView setTop:_couponContentView.bottom];
        [_teachersHeaderBackView setHeight:59];
        _teachersHeaderBackView.hidden = NO;
        [_teachersHeaderBackView setTeacherAndOrganizationData:_schoolInfo teacherInfo:_teacherInfoDict];
    }
    [_headerView setHeight:_teachersHeaderBackView.bottom];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - _headerView.height;
    if ([ShowCourseNote isEqualToString:@"0"]) {
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT;
    }
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
}

// MARK: - 讲师机构点击事件(讲师)
- (void)jumpToOrganization:(NSDictionary *)schoolInfo {
    
}

// MARK: - 讲师机构点击事件(机构)
- (void)jumpToTeacher:(NSDictionary *)teacherInfoDict tapTag:(NSInteger)viewTag {
    
}

// MARK: - 优惠卷点击事件
- (void)jumpToCouponsVC {
    
}

// MARK: - 从播放页返回或者跳转到课程详情页
- (void)popToCourseDetailVC {
    if ([self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2] isKindOfClass:[CourseMainViewController class]]) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = _ID;
        vc.isLive =  _isLive;
        vc.courseType = _courseType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//// MARK: - 右边按钮点击事件(收藏、下载、分享)
//- (void)rightButtonClick:(id)sender {
//    
//    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
//    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//    allWindowView.layer.masksToBounds =YES;
//    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
//    //获取当前UIWindow 并添加一个视图
//    UIApplication *app = [UIApplication sharedApplication];
//    [app.keyWindow addSubview:allWindowView];
//    _allWindowView = allWindowView;
//    
//    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WidthRatio,55 * HeightRatio,100 * WidthRatio,100 * HeightRatio)];
//    moreView.frame = CGRectMake(MainScreenWidth - 120 * WidthRatio,55 * HeightRatio,100 * WidthRatio,100 * HeightRatio);
//    moreView.backgroundColor = [UIColor whiteColor];
//    moreView.layer.masksToBounds = YES;
//    [allWindowView addSubview:moreView];
//    
//    NSArray *imageArray = @[@"ico_collect@3x",@"class_share",@"class_down"];
//    NSArray *titleArray = @[@"+收藏",@"分享",@"下载"];
////    if ([_collectStr integerValue] == 1) {
////        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
////        titleArray = @[@"-收藏",@"分享",@"下载"];
////    }
//    CGFloat ButtonW = 100 * WidthRatio;
//    CGFloat ButtonH = 33 * HeightRatio;
//    for (int i = 0 ; i < 3 ; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 * WidthRatio, ButtonH * i, ButtonW, ButtonH)];
//        button.tag = i;
//        [button setTitle:titleArray[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
//        button.titleLabel.font = SYSTEMFONT(14);
//        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
//        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,20 * WidthRatio);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20 * WidthRatio, 0, 0);
//        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [moreView addSubview:button];
//    }
//}

- (void)leftButtonClick:(id)sender {
    if (isFullS) {
        [self changeOrientation:UIInterfaceOrientationPortrait];
        [self aliyunVodPlayerView:_playerView fullScreen:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// MARK: - 更多按钮点击事件
- (void)moreButtonClick:(UIButton *)sender {
    
}

// MARK: - 更多视图背景图点击事件
- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

// MARK: - 免费试看结束后点击事件
- (void)freeLookTapClick:(UITapGestureRecognizer *)tap {
    
    if ([currentCourseFinalModel.model.price floatValue]>0) {
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = [currentCourseFinalModel.model.course_type isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
        vc.orderId = currentCourseFinalModel.model.classHourId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"course";
        vc.orderId = currentCourseFinalModel.model.course_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)buyCourseAndHourseButtonClick:(UIButton *)sender {
    if (isFullS) {
        [self changeOrientation:UIInterfaceOrientationPortrait];
        [self aliyunVodPlayerView:_playerView fullScreen:NO];
    }
    if (sender == _buyCourseButton) {
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"course";
        vc.orderId = [_courseType isEqualToString:@"4"] ? _ID : currentCourseFinalModel.model.course_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = [currentCourseFinalModel.model.course_type isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
        vc.orderId = currentCourseFinalModel.model.classHourId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: - 底部按钮点击事件
- (void)jumpServiceVC:(CourseDownView *)downView {
    
}

- (void)jumpToShopCarVC:(CourseDownView *)downView {
    
}

- (void)joinShopCarEvent:(CourseDownView *)downView {
    
}

- (void)joinStudyEvent:(CourseDownView *)downView {
    
}

- (void)jumpToCommentVC {
    if (!SWNOTEmptyDictionary(_dataSource)) {
        return;
    }
    NSString *isBuy = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"is_buy"]];
    if ([isBuy isEqualToString:@"1"] || currentCourseFinalModel.model.is_buy) {
        _originCommentInfo = nil;
        [self makePopView];
//        CourseMakeNoteVC *vc = [[CourseMakeNoteVC alloc] init];
//        vc.notHiddenNav = NO;
//        vc.hiddenNavDisappear = YES;
//        vc.courseId = _ID;
//        vc.courseHourseId = _currentHourseId;
//        vc.courseType = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"course_type"]];
//        [self.view addSubview:vc.view];
//        [self addChildViewController:vc];
    } else {
        [self showHudInView:self.view showHint:@"购买后才能记笔记"];
        return;
    }
}

// MARK: - 获取课程详情信息
- (void)getCourseInfo {
    if (SWNOTEmptyStr(_ID)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseInfo:_ID] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _dataSource = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    _courselayer = [NSString stringWithFormat:@"%@",_dataSource[@"section_level"]];
                    if ([_dataSource objectForKey:@"recent_learn"]) {
                        if (SWNOTEmptyDictionary([_dataSource objectForKey:@"recent_learn"])) {
                            _recent_learn_Source = [NSDictionary dictionaryWithDictionary:[_dataSource objectForKey:@"recent_learn"]];
                        }
                    }
                    [self setCourseInfoData];
                    if (_shouldContinueLearn) {
                        if (SWNOTEmptyDictionary(_recent_learn_Source)) {
                            CourseListModel *current_model = [CourseListModel mj_objectWithKeyValues:_recent_learn_Source];
                            current_model.classHourId = [NSString stringWithFormat:@"%@",_recent_learn_Source[@"section_id"]];
                            section_rate_model *rateModel = [[section_rate_model alloc] init];
                            rateModel.current_time = [[NSString stringWithFormat:@"%@",_recent_learn_Source[@"current_time"]] integerValue];
                            current_model.section_rate = rateModel;
                            if (!SWNOTEmptyStr(current_model.course_type)) {
                                current_model.course_type = _isLive ? @"2" : @"";
                            }
                            [self recordLearnContinuePlay:current_model];
                        }
                    } else {
                        if (_currentPlayModel) {
                            [self recordLearnContinuePlay:_currentPlayModel];
                        }
                    }
                }
            }
        } enError:^(NSError * _Nonnull error) {
            NSLog(@"课程详情请求失败 = %@",error);
        }];
    }
}

- (void)setCourseInfoData {
    if (SWNOTEmptyDictionary(_dataSource)) {
        NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
        if ([faceUrlString containsString:@"http"]) {
            [_faceImageView sd_setImageWithURL:EdulineUrlString([_dataSource objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
        } else {
            _faceImageView.image = DefaultImage;
        }
        if ([[NSString stringWithFormat:@"%@",_dataSource[@"collected"]] boolValue]) {
            [_zanButton setImage:Image(@"course_collect_pre") forState:0];
        } else {
            [_zanButton setImage:Image(@"course_collect_nor") forState:0];
        }
        [_courseContentView setCourseContentInfo:_dataSource showTitleOnly:YES];
        [_courseContentView setHeight:86 + 4];//[[NSString stringWithFormat:@"%@",_dataSource[@"course_type"]] isEqualToString:@"4"] ? (86-35+4) : (86 + 4)
        [_headerView setHeight:_courseContentView.bottom];
        if ([[NSString stringWithFormat:@"%@",_dataSource[@"course_type"]] isEqualToString:@"4"]) {
            [_headerView setHeight:_courseContentView.bottom];
            sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - _headerView.height;
            if ([ShowCourseNote isEqualToString:@"0"]) {
                sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT;
            }
        }
        _tableView.tableHeaderView = _headerView;
        [self.tableView reloadData];
    }
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    isFullS = isFullScreen;
    if (![AppDelegate delegate]._allowRotation) {
        return;
    }
//    _tableView.scrollEnabled = YES;
    if (isFullScreen) {
        _titleImage.hidden = YES;
        _playerView.controlView.topView.hidden = NO;
        _playerView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _headerView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _freeLookView.frame = _playerView.frame;
        
        if ([currentCourseFinalModel.model.price floatValue]>0) {
            [_buyCourseButton setRight:_playerView.width / 2.0 - 10];
            [_buyhourseButton setLeft:_playerView.width / 2.0 + 10];
        } else {
            _buyCourseButton.centerX = _playerView.width / 2.0;
        }
        
        _freeLabel.center = CGPointMake(self.playerView.width / 2.0, self.playerView.height / 2.0 - 64 / 2.0 + 22 / 2.0);
        [_buyCourseButton setTop:_freeLabel.bottom + 12];
        [_buyhourseButton setTop:_freeLabel.bottom + 12];
        _tableView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _tableView.contentOffset = CGPointMake(0, 0);
        self.playerView.controlView.topView.backButton.hidden = NO;
//        [self tableViewCanNotScroll];
    } else {
        _playerView.controlView.topView.hidden = NO;
        _playerView.frame = CGRectMake(0, 0, MainScreenWidth, FacePlayImageHeight);
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, FacePlayImageHeight + 90);
        _freeLookView.frame = _playerView.frame;
        if ([currentCourseFinalModel.model.price floatValue]>0) {
            [_buyCourseButton setRight:_playerView.width / 2.0 - 10];
            [_buyhourseButton setLeft:_playerView.width / 2.0 + 10];
        } else {
            _buyCourseButton.centerX = _playerView.width / 2.0;
        }
        if (([_freeLookView superview] && !_freeLookView.hidden) || [currentCourseFinalModel.model.course_type isEqualToString:@"2"]) {
            _titleImage.hidden = NO;
        }
        _freeLabel.center = CGPointMake(self.playerView.width / 2.0, self.playerView.height / 2.0 - 64 / 2.0 + 22 / 2.0);
        [_buyCourseButton setTop:_freeLabel.bottom + 12];
        [_buyhourseButton setTop:_freeLabel.bottom + 12];
        _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - ([currentCourseFinalModel.model.course_type isEqualToString:@"2"] ? 0 : 50) - MACRO_UI_LIUHAI_HEIGHT);
        _titleImage.hidden = NO;
        [self.headerView bringSubviewToFront:self.titleImage];
        self.playerView.controlView.topView.backButton.hidden = YES;
//        [self tableViewCanScroll];
    }

    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
    [self setNeedsStatusBarAppearanceUpdate];
}

// MARK: - 处理强制竖屏
- (void)changeOrientation:(UIInterfaceOrientation)orientation
{
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

- (void)playVideo:(CourseListModelFinal *)model cellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex currentCell:(nonnull CourseCatalogCell *)cell {
    if (_courseListVC) {
        _courseListVC.next_position = nil;
    }
    _previousHourseId = _currentHourseId;
    _currentHourseId = model.model.classHourId;
    __weak CourseDetailPlayVC *wekself = self;
    
    CourseListModelFinal *currentt = model;
    currentCourseFinalModel = currentt;
    
    wekself.freeLookView.hidden = YES;
    
    freeLook = NO;
    if ([_courseType isEqualToString:@"2"]) {
        [wekself stopRecordTimer];
        [wekself stopTuwenTimer];
        [wekself destroyPlayVideo];
        [AppDelegate delegate]._allowRotation = NO;
        _titleImage.hidden = NO;
        if (cell.listFinalModel.model.audition <= 0 && !cell.listFinalModel.model.is_buy) {
            if ([cell.listFinalModel.model.price floatValue] > 0) {
                OrderViewController *vc = [[OrderViewController alloc] init];
                vc.orderTypeString = [_courseType isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
                vc.orderId = cell.listFinalModel.model.classHourId;
                [self.navigationController pushViewController:vc animated:YES];
                [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
            } else {
                [self showHudInView:self.view showHint:@"需解锁该课程"];
            }
            return;
        }
        //        学习状态【957：未开始；999：直播中；992：已结束；】
        if (cell.listFinalModel.model.live_rate.status == 999) {
            if ([cell.listFinalModel.model.section_live.live_type isEqualToString:@"2"]) {
                [self integrationSDK];
            } else if ([cell.listFinalModel.model.section_live.live_type isEqualToString:@"3"]) {
                [self parseCodeStr:@""];
            } else {
                [self getShengwangLiveInfo:model.model.classHourId courselistModel:model.model];
            }
        } else if (cell.listFinalModel.model.live_rate.status == 957) {
            [self showHudInView:self.view showHint:cell.listFinalModel.model.live_rate.status_text];
        } else if (cell.listFinalModel.model.live_rate.status == 992) {
            if ([cell.listFinalModel.model.section_live.live_type isEqualToString:@"2"]) {
                [self integrationPlayBackSDK];
            } else if ([cell.listFinalModel.model.section_live.live_type isEqualToString:@"3"]) {
//                [self integrationPlayBackSDK];
            } else {
                if (SWNOTEmptyArr(cell.listFinalModel.model.live_rate.callback_url)) {
                    // 用播放器播放回放视频
                    [wekself.headerView addSubview:wekself.playerView];
                    _wkWebView.hidden = YES;
                    _playerView.hidden = NO;
                    _titleImage.hidden = NO;
                    [wekself.headerView bringSubviewToFront:wekself.titleImage];
                    [wekself.playerView setTitle:cell.listFinalModel.model.title];
                    wekself.playerView.trackInfoArray = [NSArray arrayWithArray:cell.listFinalModel.model.live_rate.callback_url];
                    [wekself.playerView playViewPrepareWithURL:EdulineUrlString(cell.listFinalModel.model.live_rate.callback_url[0][@"play_url"])];
                    wekself.playerView.userInteractionEnabled = YES;
                    [AppDelegate delegate]._allowRotation = YES;
                }
            }
        }
        return;
    }
    
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
            if (vccomment.cellType) {
                // 笔记
                vccomment.detailVC = self;
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
    
    [wekself stopRecordTimer];
    [wekself stopTuwenTimer];
    [wekself destroyPlayVideo];
    [AppDelegate delegate]._allowRotation = NO;
    _titleImage.hidden = NO;
    //首先全部重置为没有再播放
    for (int i = 0; i<_courseListVC.courseListArray.count; i++) {
        CourseListModelFinal *model1 = _courseListVC.courseListArray[i];
        for (int j = 0; j<model1.child.count; j++) {
            CourseListModelFinal *model2 = model1.child[j];
            for (int k = 0; k<model2.child.count; k++) {
                CourseListModelFinal *model3 = model2.child[k];
                model3.isPlaying = NO;
                [model2.child replaceObjectAtIndex:k withObject:model3];
            }
            model2.isPlaying = NO;
            [model1.child replaceObjectAtIndex:j withObject:model2];
        }
        model1.isPlaying = NO;
        [_courseListVC.courseListArray replaceObjectAtIndex:i withObject:model1];
    }
    
    if (cell.listFinalModel.model.audition <= 0 && !cell.listFinalModel.model.is_buy) {
        if ([cell.listFinalModel.model.price floatValue] > 0) {
            OrderViewController *vc = [[OrderViewController alloc] init];
            vc.orderTypeString = [_courseType isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
            vc.orderId = cell.listFinalModel.model.classHourId;
            [self.navigationController pushViewController:vc animated:YES];
            [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
        } else {
            [self showHudInView:self.view showHint:@"需解锁该课程"];
        }
        [_courseListVC.tableView reloadData];
        return;
    }
    
    [_playFileUrlArray removeAllObjects];
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseHourseUrlNet:_ID pid:cell.listFinalModel.model.classHourId] WithAuthorization:[_courseType isEqualToString:@"4"] ? @{@"class_id":wekself.ID} : nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSMutableArray *current_position = [NSMutableArray arrayWithArray:responseObject[@"data"][@"curr_position"][@"position"]];
                NSMutableArray *next_position = [NSMutableArray arrayWithArray:responseObject[@"data"][@"next_position"][@"position"]];
                if (_courseListVC) {
                    _courseListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseListVC justReloadListStatus];
                }
                if (_courseTreeListVC) {
                    _courseTreeListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseTreeListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseTreeListVC justReloadListStatus];
                }
                if ([model.model.section_data.data_type isEqualToString:@"3"] || [model.model.section_data.data_type isEqualToString:@"4"]) {
                    if (!SWNOTEmptyStr(responseObject[@"data"][@"fileurl_string"])) {
                        [_courseListVC.tableView reloadData];
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        _wkWebView.hidden = NO;
                        _playerView.hidden = YES;
                        if ([model.model.section_data.data_type isEqualToString:@"3"]) {
                            _pdfV.hidden = YES;
                            _wkWebView.scrollView.hidden = NO;
                            [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]]];
                        } else {
                            _wkWebView.scrollView.hidden = YES;
                            _pdfV.hidden = NO;
                            _pdfV.document = [[PDFDocument alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]];
                        }
                        [_tableView setContentOffset:CGPointZero animated:YES];
                        [_courseListVC.tableView reloadData];
                        
                        // 直接请求一次添加学习记录
                        
                        // 重置当前选择的课时模型
                        if (superIndex) {
                            CourseListModelFinal *supermodel = _courseListVC.courseListArray[superIndex.row];
                            CourseListModelFinal *parentmodel = supermodel.child[panrentCellIndex.row];
                            CourseListModelFinal *model = parentmodel.child[cellIndex.row];
                            model.isPlaying = YES;
                            CourseListModelFinal *curent = model;
                            currentCourseFinalModel = curent;
                            [parentmodel.child replaceObjectAtIndex:cellIndex.row withObject:model];
                            [supermodel.child replaceObjectAtIndex:panrentCellIndex.row withObject:parentmodel];
                            [_courseListVC.courseListArray replaceObjectAtIndex:superIndex.row withObject:supermodel];
                            [_courseListVC.tableView reloadData];
                        } else {
                            if (panrentCellIndex) {
                                CourseListModelFinal *parentmodel = _courseListVC.courseListArray[panrentCellIndex.row];
                                CourseListModelFinal *model = parentmodel.child[cellIndex.row];
                                model.isPlaying = YES;
                                CourseListModelFinal *curent = model;
                                currentCourseFinalModel = curent;
                                [parentmodel.child replaceObjectAtIndex:cellIndex.row withObject:model];
                                [_courseListVC.courseListArray replaceObjectAtIndex:panrentCellIndex.row withObject:parentmodel];
                                [_courseListVC.tableView reloadData];
                            } else {
                                if (cellIndex) {
                                    CourseListModelFinal *model = _courseListVC.courseListArray[cellIndex.row];
                                    model.isPlaying = YES;
                                    CourseListModelFinal *curent = model;
                                    currentCourseFinalModel = curent;
                                    [_courseListVC.courseListArray replaceObjectAtIndex:cellIndex.row withObject:model];
                                    [_courseListVC.tableView reloadData];
                                }
                            }
                        }
                        [self tuwenStartTimer];
//                        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":wekself.ID,@"section_id":currentCourseFinalModel.model.classHourId,@"current_time":@"0"} finish:^(id  _Nonnull responseObject) {
//                            NSLog(@"%@",responseObject);
//                        } enError:^(NSError * _Nonnull error) {
//
//                        }];
                        
                        return;
                    }
                } else {
                    [_playFileUrlArray addObjectsFromArray:responseObject[@"data"][@"fileurl_array"]];
                    if (!SWNOTEmptyArr(_playFileUrlArray)) {
                        [_courseListVC.tableView reloadData];
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        NSDictionary *firstFileUrlInfo = [NSDictionary dictionaryWithDictionary:_playFileUrlArray[0]];
                        if (SWNOTEmptyStr(firstFileUrlInfo[@"play_url"])) {
                            //刷新数据源
                            if (superIndex) {
                                CourseListModelFinal *supermodel = _courseListVC.courseListArray[superIndex.row];
                                CourseListModelFinal *parentmodel = supermodel.child[panrentCellIndex.row];
                                CourseListModelFinal *model = parentmodel.child[cellIndex.row];
                                model.isPlaying = YES;
                                CourseListModelFinal *curent = model;
                                currentCourseFinalModel = curent;
                                [parentmodel.child replaceObjectAtIndex:cellIndex.row withObject:model];
                                [supermodel.child replaceObjectAtIndex:panrentCellIndex.row withObject:parentmodel];
                                [_courseListVC.courseListArray replaceObjectAtIndex:superIndex.row withObject:supermodel];
                                [_courseListVC.tableView reloadData];
                            } else {
                                if (panrentCellIndex) {
                                    CourseListModelFinal *parentmodel = _courseListVC.courseListArray[panrentCellIndex.row];
                                    CourseListModelFinal *model = parentmodel.child[cellIndex.row];
                                    model.isPlaying = YES;
                                    CourseListModelFinal *curent = model;
                                    currentCourseFinalModel = curent;
                                    [parentmodel.child replaceObjectAtIndex:cellIndex.row withObject:model];
                                    [_courseListVC.courseListArray replaceObjectAtIndex:panrentCellIndex.row withObject:parentmodel];
                                    [_courseListVC.tableView reloadData];
                                } else {
                                    if (cellIndex) {
                                        CourseListModelFinal *model = _courseListVC.courseListArray[cellIndex.row];
                                        model.isPlaying = YES;
                                        CourseListModelFinal *curent = model;
                                        currentCourseFinalModel = curent;
                                        [_courseListVC.courseListArray replaceObjectAtIndex:cellIndex.row withObject:model];
                                        [_courseListVC.tableView reloadData];
                                    }
                                }
                            }
                            
                            if (currentCourseFinalModel.model.audition > 0 && !currentCourseFinalModel.model.is_buy) {
                                freeLook = YES;
                            }
                            
                            [wekself.headerView addSubview:wekself.playerView];
                            _wkWebView.hidden = YES;
                            _playerView.hidden = NO;
                            _titleImage.hidden = NO;
                            [wekself.headerView bringSubviewToFront:wekself.titleImage];
                            NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
                            if ([faceUrlString containsString:@"http"]) {
                                wekself.playerView.coverUrl = EdulineUrlString([_dataSource objectForKey:@"cover_url"]);
                            }
                            if ([model.model.section_data.data_type isEqualToString:@"2"]) {
                                wekself.playerView.unHiddenCoverImage = YES;
                            } else {
                                wekself.playerView.unHiddenCoverImage = NO;
                            }
                            [wekself.playerView setTitle:currentCourseFinalModel.model.title];
                            wekself.playerView.trackInfoArray = [NSArray arrayWithArray:_playFileUrlArray];
                            [wekself.playerView playViewPrepareWithURL:EdulineUrlString(firstFileUrlInfo[@"play_url"])];
                            wekself.playerView.userInteractionEnabled = YES;
                            [AppDelegate delegate]._allowRotation = YES;
                        } else {
                            [_courseListVC.tableView reloadData];
                            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                            return;
                        }
                    }
                }
            }
        }
        
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"课时信息请求失败"];
    }];
}

- (void)newClassCourseCellDidSelected:(CourseListModel *)model indexpath:(nonnull NSIndexPath *)indexpath {
    if (_courseTreeListVC) {
        _courseTreeListVC.next_position = nil;
    }
    if ([model.course_type isEqualToString:@"2"]) {
        _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_LIUHAI_HEIGHT);
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - _headerView.height;
        if (_courseDownView) {
            _courseDownView.hidden = YES;
        }
    } else {
        _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_LIUHAI_HEIGHT);
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - _headerView.height;
        if (_courseDownView) {
            _courseDownView.hidden = NO;
        }
        if ([ShowCourseNote isEqualToString:@"0"]) {
            _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_LIUHAI_HEIGHT);
            sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - _headerView.height;
            if (_courseDownView) {
                _courseDownView.hidden = YES;
            }
        }
    }
    
    _previousHourseId = _currentHourseId;
    _currentHourseId = model.classHourId;
    __weak CourseDetailPlayVC *wekself = self;
    freeLook = NO;
    
    wekself.freeLookView.hidden = NO;
    
    CourseListModelFinal *curent = [[CourseListModelFinal alloc] init];
    curent.model = model;
    currentCourseFinalModel = curent;
    
    //[_courseType isEqualToString:@"2"]
    if ([model.course_type isEqualToString:@"2"]) {
        [wekself stopRecordTimer];
        [wekself stopTuwenTimer];
        [wekself destroyPlayVideo];
        [AppDelegate delegate]._allowRotation = NO;
        _titleImage.hidden = NO;
        if (model.audition <= 0 && !model.is_buy) {
            if ([model.price floatValue] > 0) {
                OrderViewController *vc = [[OrderViewController alloc] init];
                vc.orderTypeString = [model.course_type isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
                vc.orderId = model.classHourId;
                [self.navigationController pushViewController:vc animated:YES];
                [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
            } else {
                [self showHudInView:self.view showHint:@"需解锁该课程"];
            }
            return;
        }
        //        学习状态【957：未开始；999：直播中；992：已结束；】
        if (model.live_rate.status == 999) {
            if ([model.section_live.live_type isEqualToString:@"2"]) {
                [self integrationSDK];
            } else if ([model.section_live.live_type isEqualToString:@"3"]) {
                [self parseCodeStr:@""];
            } else {
                [self getShengwangLiveInfo:model.classHourId courselistModel:model];
            }
        } else if (model.live_rate.status == 957) {
            [self showHudInView:self.view showHint:model.live_rate.status_text];
        } else if (model.live_rate.status == 992) {
            if ([model.section_live.live_type isEqualToString:@"2"]) {
                [self integrationPlayBackSDK];
            } else if ([model.section_live.live_type isEqualToString:@"3"]) {
//                [self integrationPlayBackSDK];
            } else {
                if (SWNOTEmptyArr(model.live_rate.callback_url)) {
                    // 用播放器播放回放视频
                    [wekself.headerView addSubview:wekself.playerView];
                    _wkWebView.hidden = YES;
                    _playerView.hidden = NO;
                    _titleImage.hidden = NO;
                    [wekself.headerView bringSubviewToFront:wekself.titleImage];
                    wekself.playerView.controlView.topView.backButton.hidden = YES;
                    [wekself.playerView setTitle:model.title];
                    wekself.playerView.trackInfoArray = [NSArray arrayWithArray:model.live_rate.callback_url];
                    [wekself.playerView playViewPrepareWithURL:EdulineUrlString(model.live_rate.callback_url[0][@"play_url"])];
                    wekself.playerView.userInteractionEnabled = YES;
                    [AppDelegate delegate]._allowRotation = YES;
                }
            }
        }
        return;
    }
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
            if (vccomment.cellType) {
                // 笔记
                vccomment.detailVC = self;
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];

    [wekself stopRecordTimer];
    [wekself stopTuwenTimer];
    [wekself destroyPlayVideo];
    [AppDelegate delegate]._allowRotation = NO;
    _titleImage.hidden = NO;
    //首先全部重置为没有再播放
    
    for (int i = 0; i<_courseTreeListVC.manager.showItems.count; i++) {
        CourseListModel *model = _courseTreeListVC.manager.showItems[i];
        model.isPlaying = NO;
        [_courseTreeListVC.manager.showItems replaceObjectAtIndex:i withObject:model];
    }
    
    if (model.audition <= 0 && !model.is_buy) {
        if ([model.price floatValue] > 0) {
            OrderViewController *vc = [[OrderViewController alloc] init];
            vc.orderTypeString = [currentCourseFinalModel.model.course_type isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";//[_courseType isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
            vc.orderId = model.classHourId;
            [self.navigationController pushViewController:vc animated:YES];
            [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
        } else {
            [self showHudInView:self.view showHint:@"需解锁该课程"];
        }
        [_courseTreeListVC.tableView reloadData];
        return;
    }
    
    [_playFileUrlArray removeAllObjects];
    
    NSString *courseId = model.course_id;
    
    CourseListModel *pmodel = model.parentItem;
    while (pmodel) {
        courseId = pmodel.course_id;
        pmodel = pmodel.parentItem;
    }
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseHourseUrlNet:courseId pid:model.classHourId] WithAuthorization:nil paramDic:[_courseType isEqualToString:@"4"] ? @{@"class_id":wekself.ID} : nil finish:^(id  _Nonnull responseObject) {
        
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                if (_courseTreeListVC) {
                    _courseTreeListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseTreeListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseTreeListVC justReloadListStatus];
                }
                if ([model.section_data.data_type isEqualToString:@"3"] || [model.section_data.data_type isEqualToString:@"4"]) {
                    if (!SWNOTEmptyStr(responseObject[@"data"][@"fileurl_string"])) {
                        [_courseTreeListVC.tableView reloadData];
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        _wkWebView.hidden = NO;
                        _playerView.hidden = YES;
                        if ([model.section_data.data_type isEqualToString:@"3"]) {
                            _pdfV.hidden = YES;
                            _wkWebView.scrollView.hidden = NO;
                            [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]]];
                        } else {
                            _wkWebView.scrollView.hidden = YES;
                            _pdfV.hidden = NO;
                            _pdfV.document = [[PDFDocument alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]];
                        }
                        [_tableView setContentOffset:CGPointZero animated:YES];
                        [_courseTreeListVC.tableView reloadData];
                        
                        CourseListModel *newClassCurrentModel = model;
                        newClassCurrentModel.isPlaying = YES;
                        
                        CourseListModelFinal *curent = [[CourseListModelFinal alloc] init];
                        curent.model = newClassCurrentModel;
                        currentCourseFinalModel = curent;
                        
                        [self tuwenStartTimer];
                        
                        return;
                    }
                } else {
                    [_playFileUrlArray addObjectsFromArray:responseObject[@"data"][@"fileurl_array"]];
                    if (!SWNOTEmptyArr(_playFileUrlArray)) {
                        [_courseTreeListVC.tableView reloadData];
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        NSDictionary *firstFileUrlInfo = [NSDictionary dictionaryWithDictionary:_playFileUrlArray[0]];
                        if (SWNOTEmptyStr(firstFileUrlInfo[@"play_url"])) {
                            
                            CourseListModel *newClassCurrentModel = model;
                            newClassCurrentModel.isPlaying = YES;
                            
                            CourseListModelFinal *curent = [[CourseListModelFinal alloc] init];
                            curent.model = newClassCurrentModel;
                            currentCourseFinalModel = curent;
                            
                            if (model.audition > 0 && !model.is_buy) {
                                freeLook = YES;
                            }
                            
                            [wekself.headerView addSubview:wekself.playerView];
                            _wkWebView.hidden = YES;
                            _playerView.hidden = NO;
                            _titleImage.hidden = NO;
                            [wekself.headerView bringSubviewToFront:wekself.titleImage];
                            wekself.playerView.controlView.topView.backButton.hidden = YES;
                            NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
                            if ([faceUrlString containsString:@"http"]) {
                                wekself.playerView.coverUrl = EdulineUrlString([_dataSource objectForKey:@"cover_url"]);
                            }
                            if ([model.section_data.data_type isEqualToString:@"2"]) {
                                wekself.playerView.unHiddenCoverImage = YES;
                            } else {
                                wekself.playerView.unHiddenCoverImage = NO;
                            }
                            [wekself.playerView setTitle:model.title];
                            wekself.playerView.trackInfoArray = [NSArray arrayWithArray:_playFileUrlArray];
                            [wekself.playerView playViewPrepareWithURL:EdulineUrlString(firstFileUrlInfo[@"play_url"])];
                            wekself.playerView.userInteractionEnabled = YES;
                            [AppDelegate delegate]._allowRotation = YES;
                        } else {
                            [_courseTreeListVC.tableView reloadData];
                            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                            return;
                        }
                    }
                }
            }
        }
        
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"课时信息请求失败"];
    }];
    
    /**
     *原逻辑
    if ([model.section_data.data_type isEqualToString:@"3"]) {
        if (!SWNOTEmptyStr(model.section_data.data_txt)) {
            [_courseListVC.tableView reloadData];
            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
            return;
        }
    } else {
        if (!SWNOTEmptyStr(model.section_data.fileurl)) {
            [_courseListVC.tableView reloadData];
            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
            return;
        }
    }
    
    if ([model.section_data.data_type isEqualToString:@"3"]) {
        _wkWebView.hidden = NO;
        _playerView.hidden = YES;
        [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:model.section_data.data_txt]]];
        [_tableView setContentOffset:CGPointZero animated:YES];
        [_courseListVC.tableView reloadData];
        return;
    }
    
    if ([model.section_data.data_type isEqualToString:@"4"]) {
        _wkWebView.hidden = NO;
        _playerView.hidden = YES;
        [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:model.section_data.fileurl]]];
        [_tableView setContentOffset:CGPointZero animated:YES];
        [_courseListVC.tableView reloadData];
        return;
    }
    
    CourseListModel *newClassCurrentModel = model;
    newClassCurrentModel.isPlaying = YES;
    [_courseTreeListVC.manager.showItems replaceObjectAtIndex:indexpath.row withObject:newClassCurrentModel];
    [_courseTreeListVC.tableView reloadData];
    
    CourseListModelFinal *curent = [[CourseListModelFinal alloc] init];
    curent.model = newClassCurrentModel;
    currentCourseFinalModel = curent;
    
    if (model.audition > 0 && !model.is_buy) {
        freeLook = YES;
    }
    
    [wekself.headerView addSubview:wekself.playerView];
    _wkWebView.hidden = YES;
    _playerView.hidden = NO;
    _titleImage.hidden = YES;
    NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
    if ([faceUrlString containsString:@"http"]) {
        wekself.playerView.coverUrl = EdulineUrlString([_dataSource objectForKey:@"cover_url"]);
    }
    if ([model.section_data.data_type isEqualToString:@"2"]) {
        wekself.playerView.unHiddenCoverImage = YES;
    } else {
        wekself.playerView.unHiddenCoverImage = NO;
    }
    [wekself.playerView playViewPrepareWithURL:EdulineUrlString(model.section_data.fileurl)];
    wekself.playerView.userInteractionEnabled = YES;
    [AppDelegate delegate]._allowRotation = YES;
    */
}

// MARK: - 有学习记录时候第一次播放逻辑
- (void)recordLearnContinuePlay:(CourseListModel *)model {
    if (_courseListVC) {
        _courseListVC.next_position = nil;
    }
    CourseListModelFinal *curentt = [[CourseListModelFinal alloc] init];
    curentt.model = model;
    currentCourseFinalModel = curentt;
    if ([currentCourseFinalModel.model.course_type isEqualToString:@"2"]) {
        _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_LIUHAI_HEIGHT);
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - _headerView.height;
        if (_courseDownView) {
            _courseDownView.hidden = YES;
        }
    } else {
        _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_LIUHAI_HEIGHT);
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - _headerView.height;
        if (_courseDownView) {
            _courseDownView.hidden = NO;
        }
        
        if ([ShowCourseNote isEqualToString:@"0"]) {
            _tableView.frame = CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_LIUHAI_HEIGHT);
            sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - _headerView.height;
            if (_courseDownView) {
                _courseDownView.hidden = YES;
            }
        }
        
    }
    [_tableView reloadData];
    freeLook = NO;
    if ([currentCourseFinalModel.model.course_type isEqualToString:@"2"]) {
//        [self getLiveCourseHourseInfo:model.classHourId courseHourseModel:model];
//        [self getShengwangLiveInfo:model.classHourId courselistModel:model];
        return;
    }
    _previousHourseId = _currentHourseId;
    _currentHourseId = model.classHourId;
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
            if (vccomment.cellType) {
                // 笔记
                vccomment.detailVC = self;
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
    __weak CourseDetailPlayVC *wekself = self;
    [wekself stopRecordTimer];
    [wekself stopTuwenTimer];
    [wekself destroyPlayVideo];
    [AppDelegate delegate]._allowRotation = NO;
    _titleImage.hidden = NO;
    
    [_playFileUrlArray removeAllObjects];
    
    NSString *courseId = model.course_id;
    
    CourseListModel *pmodel = model.parentItem;
    while (pmodel) {
        courseId = pmodel.course_id;
        pmodel = pmodel.parentItem;
    }
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseHourseUrlNet:courseId pid:model.classHourId] WithAuthorization:nil paramDic:[_courseType isEqualToString:@"4"] ? @{@"class_id":wekself.ID} : nil finish:^(id  _Nonnull responseObject) {
        
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSMutableArray *current_position = [NSMutableArray arrayWithArray:responseObject[@"data"][@"curr_position"][@"position"]];
                NSMutableArray *next_position = [NSMutableArray arrayWithArray:responseObject[@"data"][@"next_position"][@"position"]];
                if (_courseListVC) {
                    _courseListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseListVC justReloadListStatus];
                }
                if (_courseTreeListVC) {
                    _courseTreeListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseTreeListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseTreeListVC justReloadListStatus];
                }
                if ([model.section_data.data_type isEqualToString:@"3"] || [model.section_data.data_type isEqualToString:@"4"]) {
                    if (!SWNOTEmptyStr(responseObject[@"data"][@"fileurl_string"])) {
                        if (_courseListVC) {
                            [_courseListVC.tableView reloadData];
                        } else if (_courseTreeListVC) {
                            [_courseTreeListVC.tableView reloadData];
                        }
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        _wkWebView.hidden = NO;
                        _playerView.hidden = YES;
                        if ([model.section_data.data_type isEqualToString:@"3"]) {
                            _pdfV.hidden = YES;
                            _wkWebView.scrollView.hidden = NO;
                            [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]]];
                        } else {
                            _wkWebView.scrollView.hidden = YES;
                            _pdfV.hidden = NO;
                            _pdfV.document = [[PDFDocument alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]];
                        }
                        [self tuwenStartTimer];
                        [_tableView setContentOffset:CGPointZero animated:YES];
                        if (_courseListVC) {
                            [_courseListVC.tableView reloadData];
                        } else if (_courseTreeListVC) {
                            [_courseTreeListVC.tableView reloadData];
                        }
                        return;
                    }
                } else {
                    [_playFileUrlArray addObjectsFromArray:responseObject[@"data"][@"fileurl_array"]];
                    if (!SWNOTEmptyArr(_playFileUrlArray)) {
                        [_courseTreeListVC.tableView reloadData];
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        NSDictionary *firstFileUrlInfo = [NSDictionary dictionaryWithDictionary:_playFileUrlArray[0]];
                        if (SWNOTEmptyStr(firstFileUrlInfo[@"play_url"])) {
                            
                            CourseListModel *newClassCurrentModel = model;
                            newClassCurrentModel.isPlaying = YES;
                            
                            CourseListModelFinal *curent = [[CourseListModelFinal alloc] init];
                            curent.model = newClassCurrentModel;
                            currentCourseFinalModel = curent;
                            
                            if (_courseListVC) {
                                for (int i = 0; i<_courseListVC.courseListArray.count; i++) {
                                    CourseListModelFinal *model = (CourseListModelFinal *)_courseListVC.courseListArray[i];
                                    // currentCourseFinalModel.model.classHourId
                                    if ([model.model.classHourId isEqualToString:[NSString stringWithFormat:@"%@",current_position[0]]]) {
                                        model.isPlaying = YES;
                                        [_courseListVC.courseListArray replaceObjectAtIndex:i withObject:model];
                                        break;
                                    }
                                }
                                [_courseListVC.tableView reloadData];
                            }
                             // 目前生成了继续学习数据的 是可以直接看的音视频 不存在处理试看情况(错的)
                            if (model.audition > 0 && !model.is_buy) {
                                freeLook = YES;
                            }
                            
                            [wekself.headerView addSubview:wekself.playerView];
                            _wkWebView.hidden = YES;
                            _playerView.hidden = NO;
                            _titleImage.hidden = NO;
                            [wekself.headerView bringSubviewToFront:wekself.titleImage];
                            wekself.playerView.controlView.topView.backButton.hidden = YES;
                            NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
                            if ([faceUrlString containsString:@"http"]) {
                                wekself.playerView.coverUrl = EdulineUrlString([_dataSource objectForKey:@"cover_url"]);
                            }
                            if ([model.section_data.data_type isEqualToString:@"2"]) {
                                wekself.playerView.unHiddenCoverImage = YES;
                            } else {
                                wekself.playerView.unHiddenCoverImage = NO;
                            }
                            [wekself.playerView setTitle:model.title];
                            wekself.playerView.trackInfoArray = [NSArray arrayWithArray:_playFileUrlArray];
                            [wekself.playerView playViewPrepareWithURL:EdulineUrlString(firstFileUrlInfo[@"play_url"])];
                            wekself.playerView.userInteractionEnabled = YES;
                            [AppDelegate delegate]._allowRotation = YES;
                        } else {
                            if (_courseListVC) {
                                [_courseListVC.tableView reloadData];
                            } else if (_courseTreeListVC) {
                                [_courseTreeListVC.tableView reloadData];
                            }
                            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                            return;
                        }
                    }
                }
            }
        }
        
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"课时信息请求失败"];
    }];
    
    
    /**
     *原逻辑
    if ([model.section_data.data_type isEqualToString:@"3"]) {
        if (!SWNOTEmptyStr(model.section_data.data_txt)) {
            [_courseListVC.tableView reloadData];
            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
            return;
        }
    } else {
        if (!SWNOTEmptyStr(model.section_data.fileurl)) {
            [_courseListVC.tableView reloadData];
            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
            return;
        }
    }
    
    if ([model.section_data.data_type isEqualToString:@"3"]) {
        _wkWebView.hidden = NO;
        _playerView.hidden = YES;
        [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:model.section_data.data_txt]]];
        [_tableView setContentOffset:CGPointZero animated:YES];
        [_courseListVC.tableView reloadData];
        return;
    }
    
    if ([model.section_data.data_type isEqualToString:@"4"]) {
        _wkWebView.hidden = NO;
        _playerView.hidden = YES;
        [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:model.section_data.fileurl]]];
        [_tableView setContentOffset:CGPointZero animated:YES];
        [_courseListVC.tableView reloadData];
        return;
    }
    
    CourseListModel *newClassCurrentModel = model;
    newClassCurrentModel.isPlaying = YES;
//    [_courseTreeListVC.manager.showItems replaceObjectAtIndex:indexpath.row withObject:newClassCurrentModel];
//    [_courseTreeListVC.tableView reloadData];
    
    CourseListModelFinal *curent = [[CourseListModelFinal alloc] init];
    curent.model = newClassCurrentModel;
    currentCourseFinalModel = curent;
    
    if (model.audition > 0 && !model.is_buy) {
        freeLook = YES;
    }
    
    [wekself.headerView addSubview:wekself.playerView];
    _wkWebView.hidden = YES;
    _playerView.hidden = NO;
    _titleImage.hidden = YES;
    NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
    if ([faceUrlString containsString:@"http"]) {
        wekself.playerView.coverUrl = EdulineUrlString([_dataSource objectForKey:@"cover_url"]);
    }
    if ([model.section_data.data_type isEqualToString:@"2"]) {
        wekself.playerView.unHiddenCoverImage = YES;
    } else {
        wekself.playerView.unHiddenCoverImage = NO;
    }
    [wekself.playerView playViewPrepareWithURL:EdulineUrlString(model.section_data.fileurl)];
    wekself.playerView.userInteractionEnabled = YES;
    [AppDelegate delegate]._allowRotation = YES;
    */
}

//// MARK: - 音视频开始播放
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView happen:(AVPEventType )event {
    if (_isLive) {
        
    } else {
        if (event == AVPEventFirstRenderedStart) {
//            _titleImage.hidden = YES;
            __weak CourseDetailPlayVC *wekself = self;
            [wekself starRecordTimer];
            if (currentCourseFinalModel) {
                if (currentCourseFinalModel.model.section_rate.current_time > 0 && currentCourseFinalModel.model.section_rate.current_time < (wekself.playerView.aliPlayer.duration / 1000 - 5)) {
                    [wekself.playerView.aliPlayer seekToTime:currentCourseFinalModel.model.section_rate.current_time * 1000 seekMode:AVP_SEEKMODE_ACCURATE];
                }
            }
        } else if (event == AVPEventCompletion) {
            __weak CourseDetailPlayVC *wekself = self;
            [wekself stopRecordTimer];
            [wekself stopTuwenTimer];
        }
    }
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime {
    if (_isLive) {
        
    } else {
        __weak CourseDetailPlayVC *wekself = self;
        [wekself stopRecordTimer];
        [wekself stopTuwenTimer];
    }
}

 // MARK: - 暂停事件
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime {
    if (_isLive) {
        
    } else {
        __weak CourseDetailPlayVC *wekself = self;
        [wekself stopRecordTimer];
        [wekself stopTuwenTimer];
    }
}

// MARK: - 继续事件
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime {
    if (_isLive) {
        
    } else {
        __weak CourseDetailPlayVC *wekself = self;
        [wekself starRecordTimer];
    }
}

// MARK: - 功能：播放完成事件 ，请区别stop（停止播放）
- (void)onFinishWithAliyunVodPlayerView:(AliyunVodPlayerView*)playerView {
    if (_isLive) {
        
    } else {
        __weak CourseDetailPlayVC *wekself = self;
        _titleImage.hidden = NO;
        [wekself.playerView setUIStatusToReplay];
        [wekself stopRecordTimer];
        [wekself stopTuwenTimer];
        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":wekself.ID,@"section_id":currentCourseFinalModel.model.classHourId,@"current_time":@((long) (wekself.playerView.controlView.currentTime/1000))} finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
        } enError:^(NSError * _Nonnull error) {
            
        }];
        if (_courseListVC) {
            if (SWNOTEmptyDictionary(_courseListVC.next_position)) {
                CourseListModel *model = [CourseListModel mj_objectWithKeyValues:_courseListVC.next_position];
                CourseListModelFinal *finalModel = [[CourseListModelFinal alloc] init];
                finalModel.model = model;
                [self autoPlayNextCourseHourse:finalModel];
            }
        }
        if (_courseTreeListVC) {
            if (SWNOTEmptyDictionary(_courseTreeListVC.next_position)) {
                CourseListModel *model = [CourseListModel mj_objectWithKeyValues:_courseTreeListVC.next_position];
                CourseListModelFinal *finalModel = [[CourseListModelFinal alloc] init];
                finalModel.model = model;
                [self autoPlayNextCourseHourse:finalModel];
            }
        }
    }
}

- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - 学习记录定时器
- (void)addLearnRecord {
    if (shouldStopRecordTimer) {
        return;
    }
    if (!currentCourseFinalModel) {
        return;
    }
    
    __weak CourseDetailPlayVC *wekself = self;
    if (!SWNOTEmptyStr(wekself.ID)) {
        return;
    }
    
    if (freeLook) {
        long currentTime = (long) (wekself.playerView.controlView.currentTime/1000);
        long duration = (long) (wekself.playerView.controlView.duration/1000);
        if (currentTime * 100 / duration >= currentCourseFinalModel.model.audition) {
            [wekself stopRecordTimer];
            [wekself stopTuwenTimer];
            [wekself.playerView stop];
            if ([wekself.freeLookView superview]) {
                [wekself.headerView bringSubviewToFront:wekself.freeLookView];
                wekself.freeLookView.frame = wekself.playerView.frame;
                wekself.freeLookView.hidden = NO;
                if ([currentCourseFinalModel.model.price floatValue]>0) {
                    [_buyCourseButton setRight:wekself.playerView.width / 2.0 - 10];
                    [_buyhourseButton setLeft:wekself.playerView.width / 2.0 + 10];
                    _buyCourseButton.hidden = NO;
                    _buyhourseButton.hidden = NO;
                } else {
                    _buyCourseButton.centerX = wekself.playerView.width / 2.0;
                    _buyCourseButton.hidden = NO;
                    _buyhourseButton.hidden = YES;
                }
            } else {
                wekself.freeLookView.frame = wekself.playerView.frame;
                [wekself.headerView addSubview:wekself.freeLookView];
                if ([currentCourseFinalModel.model.price floatValue]>0) {
                    [_buyCourseButton setRight:wekself.playerView.width / 2.0 - 10];
                    [_buyhourseButton setLeft:wekself.playerView.width / 2.0 + 10];
                    _buyCourseButton.hidden = NO;
                    _buyhourseButton.hidden = NO;
                } else {
                    _buyCourseButton.centerX = wekself.playerView.width / 2.0;
                    _buyCourseButton.hidden = NO;
                    _buyhourseButton.hidden = YES;
                }
            }

            _freeLabel.center = CGPointMake(self.playerView.width / 2.0, self.playerView.height / 2.0 - 64 / 2.0 + 22 / 2.0);
            [_buyCourseButton setTop:_freeLabel.bottom + 12];
            [_buyhourseButton setTop:_freeLabel.bottom + 12];
            
            _titleImage.hidden = NO;
            return;
        }
    }
    
    if ([_courseType isEqualToString:@"4"]) {
        
        NSString *courseId = currentCourseFinalModel.model.course_id;
        CourseListModel *parentModel  = currentCourseFinalModel.model.parentItem;
        
        while (parentModel) {
            courseId = parentModel.course_id;
            parentModel = parentModel.parentItem;
        }
        
        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":courseId,@"section_id":currentCourseFinalModel.model.classHourId,@"current_time":@((long) (wekself.playerView.controlView.currentTime/1000))} finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":wekself.ID,@"section_id":currentCourseFinalModel.model.classHourId,@"current_time":@((long) (wekself.playerView.controlView.currentTime/1000))} finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)willResignActive {
    if (_playerView &&  self.playerView.playerViewState == AVPStatusStarted){
        [self.playerView pause];
        __weak CourseDetailPlayVC *wekself = self;
        [wekself.recordTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)becomeActive{
    __weak CourseDetailPlayVC *wekself = self;
    NSLog(@"播放器状态:%ld",(long)wekself.playerView.playerViewState);
    if (wekself.playerView && wekself.playerView.playerViewState == AVPStatusPaused){
        [wekself.playerView resume];
        [wekself.recordTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)resignActive{
    __weak CourseDetailPlayVC *wekself = self;
    if (wekself.playerView && self.playerView.playerViewState == AVPStatusStarted){
        [wekself.playerView pause];
        [wekself.recordTimer setFireDate:[NSDate distantFuture]];
    }
}

// MARK: - 横屏权限
#pragma mark - 默认竖屏
//- (BOOL)shouldAutorotate{
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}

- (void)tableViewCanNotScroll {
    [self performSelector:@selector(canNotScroll) withObject:nil afterDelay:1];
}

- (void)tableViewCanScroll {
    [self performSelector:@selector(canTableScroll) withObject:nil afterDelay:1];
}

- (void)canNotScroll {
    _canScroll = NO;
    _canScrollAfterVideoPlay = NO;
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - MACRO_UI_UPHEIGHT;
    if ([ShowCourseNote isEqualToString:@"0"]) {
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT;
    }
    [_tableView reloadData];
}

- (void)canTableScroll {
    _canScroll = YES;
    _canScrollAfterVideoPlay = YES;
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - MACRO_UI_UPHEIGHT;
    if ([ShowCourseNote isEqualToString:@"0"]) {
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT;
    }
    [_tableView reloadData];
}

- (void)dealPlayWordBook {
    _canScroll = NO;
    _canScrollAfterVideoPlay = NO;
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - (_isLive ? 0 : 50) - MACRO_UI_UPHEIGHT;
    if ([ShowCourseNote isEqualToString:@"0"]) {
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT;
    }
    _tableView.scrollEnabled = NO;
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CourseListVC class]]) {
            CourseListVC *vccomment = (CourseListVC *)vc;
            vccomment.cellTabelCanScroll = YES;
        }
        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
            if (vccomment.cellType) {
                // 笔记
                vccomment.cellTabelCanScroll = YES;
            }
        }
        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
            if (!vccomment.cellType) {
                vccomment.cellTabelCanScroll = YES;
            }
        }
    }
}

- (void)stopRecordTimer {
    __weak CourseDetailPlayVC *wekself = self;
    [wekself.recordTimer invalidate];
    wekself.recordTimer = nil;
    shouldStopRecordTimer = YES;
}

- (void)starRecordTimer {
    __weak CourseDetailPlayVC *wekself = self;
    [wekself stopRecordTimer];
    [wekself stopTuwenTimer];
    [wekself performSelector:@selector(startTimer) afterDelay:10];
//    if (currentCourseFinalModel) {
//        if (currentCourseFinalModel.model.is_buy) {
//            __weak CourseDetailPlayVC *wekself = self;
//            [wekself stopRecordTimer];
//            [wekself performSelector:@selector(startTimer) afterDelay:10];
//        }
//    }
}

- (void)startTimer {
    __weak CourseDetailPlayVC *wekself = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:wekself];
    [NSObject cancelPreviousPerformRequestsWithTarget:wekself selector:@selector(startTimer) object:nil];
    shouldStopRecordTimer = NO;
    wekself.recordTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:wekself selector:@selector(addLearnRecord) userInfo:nil repeats:YES];
    [wekself.recordTimer fire];
}

// MARK: - 直播相关
// 直播相关测试
- (void)loginLiveRoom:(NSDictionary *)liveInfo courseHourseModel:(CourseListModel *)model {
    __weak CourseDetailPlayVC *wekself = self;
    AppDelegate *app = [AppDelegate delegate];
    app.configTXSDK = ^(NSString *success) {
        NSString *userId = [NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"user_id"]];
        NSString *userSig = [NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"user_sig"]];
        [[TICManager sharedInstance] login:userId userSig:userSig callback:^(TICModule module, int code, NSString *desc) {
            if(code == 0){
                [self joinLiveRoom:liveInfo courseHourseModel:model];
            }
            else{
                [self showHudInView:wekself.view showHint:[NSString stringWithFormat:@"登录失败: %d,%@",code, desc]];
            }
        }];
    };
    [app intTXSDK];
}

- (void)joinLiveRoom:(NSDictionary *)liveInfo courseHourseModel:(CourseListModel *)model {
    NSString *classId = [NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"room_no"]];
    NSString *userId = [NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"user_id"]];
    if (classId.length <= 0) {
        return;
    }

    LiveRoomViewController *vc = [[LiveRoomViewController alloc] init];
    vc.course_live_type = [NSString stringWithFormat:@"%@",_dataSource[@"course_live_type"]];
    vc.classId = classId;
    vc.userId = userId;
    vc.teacherId = [NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"teacher_id"]];
    vc.liveTitle = model.title;
    vc.userIdentify = [NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"identity"]];
    
    TICClassroomOption *option = [[TICClassroomOption alloc] init];
    option.classId = [classId intValue];
    TEduBoardInitParam *initParam = [[TEduBoardInitParam alloc] init];
    if ([[NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"identity"]] integerValue]) {
        initParam.drawEnable = YES;
    } else {
        initParam.drawEnable = NO;
    }
    option.boardInitParam = initParam;
    
    [[TICManager sharedInstance] addMessageListener:vc];
    [[TICManager sharedInstance] addEventListener:vc];
    
    __weak CourseDetailPlayVC *wekself = self;
    [[TICManager sharedInstance] joinClassroom:option callback:^(TICModule module, int code, NSString *desc) {
        if(code == 0){
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            if(code == 10015){
                if ([[NSString stringWithFormat:@"%@",[liveInfo objectForKey:@"identity"]] integerValue]) {
                    [[TICManager sharedInstance] createClassroom:[classId intValue] classScene:TIC_CLASS_SCENE_VIDEO_CALL callback:^(TICModule module, int code, NSString *desc) {
                        if(code == 0){
                            [self showHudInView:self.view showHint:@"创建课堂成功，请\"加入课堂\""];
                            [Net_API requestPOSTWithURLStr:[Net_Path noteLiveSucNet] WithAuthorization:nil paramDic:@{@"room_no":classId} finish:^(id  _Nonnull responseObject) {
                                
                            } enError:^(NSError * _Nonnull error) {
                                
                            }];
                            // 这里说的是直接进入直播间
                            [[TICManager sharedInstance] joinClassroom:option callback:^(TICModule module, int code, NSString *desc) {
                                if(code == 0){
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                                else{
                                    if(code == 10015){
                                    }
                                    else{
                                        [self showHudInView:self.view showHint:[NSString stringWithFormat:@"加入课堂失败：%d %@", code, desc]];
                                    }
                                }
                            }];
                        }
                        else{
                            if(code == 10021){
                                [self showHudInView:self.view showHint:@"该课堂已被他人创建，请\"加入课堂\""];
                            }
                            else if(code == 10025){
                                [self showHudInView:self.view showHint:@"该课堂已创建，请\"加入课堂\""];
                            }
                            else{
                                [self showHudInView:self.view showHint:[NSString stringWithFormat:@"创建课堂失败：%d %@", code, desc]];
                            }
                        }
                    }];
                } else {
                    [self showHudInView:self.view showHint:@"课堂不存在，请\"创建课堂\""];
                }
            }
            else{
                [self showHudInView:self.view showHint:[NSString stringWithFormat:@"加入课堂失败：%d %@", code, desc]];
            }
        }
    }];
}

// MARK: - 获取直播课时相关信息
- (void)getLiveCourseHourseInfo:(NSString *)liveHourseSectionId courseHourseModel:(CourseListModel *)model {
    if (SWNOTEmptyStr(liveHourseSectionId)) {
        __weak typeof(self) ws = self;
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path liveLoginInfo] WithAuthorization:nil paramDic:@{@"section_id":liveHourseSectionId} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"sdk_appid"]] forKey:@"sdk_appid"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self loginLiveRoom:[responseObject objectForKey:@"data"] courseHourseModel:model];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 声网直播

- (void)getShengwangLiveInfo:(NSString *)sectionId courselistModel:(CourseListModel *)model {
    if (SWNOTEmptyStr(sectionId)) {
        WEAK(self);
        [weakself showHudInView:weakself.view hint:@"直播信息获取中..."];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path shengwangLiveInfo:sectionId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [self enterShengwangLive:responseObject[@"data"][@"info"] courselistModel:model];
                } else {
                    [weakself hideHud];
                }
            } else {
                [weakself hideHud];
            }
        } enError:^(NSError * _Nonnull error) {
            [weakself hideHud];
        }];
    }
}

- (void)enterShengwangLive:(NSDictionary *)liveInfo courselistModel:(CourseListModel *)model {
    
    
    WEAK(self);
    
    NSString *liveType = [NSString stringWithFormat:@"%@",liveInfo[@"course_live_type"]];
    NSString *userUuid = [NSString stringWithFormat:@"%@",liveInfo[@"user_id"]];
    NSString *roomUuid = [NSString stringWithFormat:@"%@",liveInfo[@"room_no"]];
    NSString *roomName = [NSString stringWithFormat:@"%@",liveInfo[@"section_name"]];
//    【1：大班课；2：小班课；3：1对1】
    SceneType sceneType;
    if ([liveType isEqualToString:@"3"]) {
        sceneType = SceneType1V1;
        self.educationManager = [OneToOneEducationManager new];
    } else if ([liveType isEqualToString:@"1"]) {
        sceneType = SceneTypeBig;
        self.educationManager = [BigEducationManager new];
    } else if ([liveType isEqualToString:@"2"]) {
        sceneType = SceneTypeSmall;
        self.educationManager = [MinEducationManager new];
    } else {
        [weakself hideHud];
        return;
    }
    
    [weakself hideHud];
    
    [weakself showHudInView:weakself.view hint:@"进入直播间中..."];
    
    EduConfigModel.shareInstance.className = roomName;
    EduConfigModel.shareInstance.userName = [V5_UserModel uname];
    EduConfigModel.shareInstance.sceneType = sceneType;
    
    
    [weakself getConfigWithSuccessBolck:^{
        [weakself getEntryInfoWithUserUuid:userUuid roomUuid:roomUuid successBolck:^{
            [weakself getWhiteInfoWithSuccessBolck:^{
                [weakself getRoomInfoWithSuccessBlock:^{
                    [weakself setupSignalWithSuccessBlock:^{
                        [weakself hideHud];
                        [weakself showHudInView:self.view showHint:@"开始进入直播间"];
                        // 请求一次学习记录
                        [weakself requestOnceStudyRecord:model.classHourId];
                        if (sceneType == SceneTypeBig) {
                            BCLiveRoomViewController *vc = [[BCLiveRoomViewController alloc] init];
                            vc.classId = weakself.currentHourseId;
                            vc.educationManager = (BigEducationManager *)weakself.educationManager;
                            [weakself.navigationController pushViewController:vc animated:YES];
                        } else if (sceneType == SceneTypeSmall) {
                            LiveRoomViewController *vc = [[LiveRoomViewController alloc] init];
                            vc.classId = weakself.currentHourseId;
                            vc.educationManager = (MinEducationManager *)weakself.educationManager;
                            [weakself.navigationController pushViewController:vc animated:YES];
                        } else if (sceneType == SceneType1V1) {
                            OneToOneLiveRoomVC *vc = [[OneToOneLiveRoomVC alloc] init];
                            vc.classId = weakself.currentHourseId;
                            vc.educationManager = (OneToOneEducationManager *)weakself.educationManager;
                            [weakself.navigationController pushViewController:vc animated:YES];
                        }
                    }];
                }];
            }];
        }];
    }];
    
}

#pragma mark EnterClassProcess
- (void)getConfigWithSuccessBolck:(void (^)(void))successBlock {
    
    WEAK(self);
    [BaseEducationManager getConfigWithSuccessBolck:^{
        if(successBlock != nil){
            successBlock();
        } else {
            [weakself hideHud];
        }
    } completeFailBlock:^(NSString * _Nonnull errMessage) {
        [weakself hideHud];
    }];
}

- (void)getEntryInfoWithUserUuid:(NSString *)userUuid roomUuid:(NSString *)roomUuid successBolck:(void (^)(void))successBlock {
    WEAK(self);
    
    NSString *userName = EduConfigModel.shareInstance.userName;
    NSString *className = EduConfigModel.shareInstance.className;
    SceneType sceneType = EduConfigModel.shareInstance.sceneType;
    
    [BaseEducationManager enterShengwangRoomWithUserName:userName roomName:className sceneType:sceneType userUuid:userUuid roomUuid:roomUuid successBolck:^{
        if(successBlock != nil){
            successBlock();
        } else {
            [weakself hideHud];
        }
    } completeFailBlock:^(NSString * _Nonnull errMessage) {
        [weakself hideHud];
    }];
//
//    [BaseEducationManager enterRoomWithUserName:userName roomName:className sceneType:sceneType successBolck:^{
//        if(successBlock != nil){
//            successBlock();
//        }
//
//    } completeFailBlock:^(NSString * _Nonnull errMessage) {
//    }];
}

- (void)getWhiteInfoWithSuccessBolck:(void (^)(void))successBlock {
    WEAK(self);
    [self.educationManager getWhiteInfoCompleteSuccessBlock:^{
        if(successBlock != nil){
            successBlock();
        } else {
            [weakself hideHud];
        }
    } completeFailBlock:^(NSString * _Nonnull errMessage) {
        [weakself hideHud];
    }];
}

- (void)getRoomInfoWithSuccessBlock:(void (^)(void))successBlock {
    WEAK(self);
    [self.educationManager getRoomInfoCompleteSuccessBlock:^(RoomInfoModel * _Nonnull roomInfoModel) {
        if(successBlock != nil){
            successBlock();
        } else {
            [weakself hideHud];
        }
    } completeFailBlock:^(NSString * _Nonnull errMessage) {
        [weakself hideHud];
    }];
}

- (void)setupSignalWithSuccessBlock:(void (^)(void))successBlock {

    NSString *appid = EduConfigModel.shareInstance.appId;
    NSString *appToken = EduConfigModel.shareInstance.rtmToken;
    NSString *uid = @(EduConfigModel.shareInstance.uid).stringValue;
    
    WEAK(self);
    [self.educationManager initSignalWithAppid:appid appToken:appToken userId:uid dataSourceDelegate:nil completeSuccessBlock:^{
        
        NSString *channelName = EduConfigModel.shareInstance.channelName;
        [weakself.educationManager joinSignalWithChannelName:channelName completeSuccessBlock:^{
            if(successBlock != nil){
                successBlock();
            } else {
                [weakself hideHud];
            }
        } completeFailBlock:^(NSInteger errorCode) {
            [weakself hideHud];
            NSString *errMsg = [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"JoinSignalFailedText", nil), (long)errorCode];
        }];
    } completeFailBlock:^(NSInteger errorCode){
        [weakself hideHud];
        NSString *errMsg = [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"InitSignalFailedText", nil), (long)errorCode];
    }];
}

// MARK: - 请求一次学习记录
- (void)requestOnceStudyRecord:(NSString *)classHourseId {
    WEAK(self);
    if (SWNOTEmptyStr(classHourseId)) {
        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":weakself.ID,@"section_id":classHourseId,@"current_time":@"0"} finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 点赞按钮点击事件
- (void)zanButtonClick:(UIButton *)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    // 收藏
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:_ID forKey:@"source_id"];
    if ([_courseType isEqualToString:@"1"]) {
        [param setObject:@"video" forKey:@"source_type"];
    } else if ([_courseType isEqualToString:@"2"]) {
        [param setObject:@"live" forKey:@"source_type"];
    } else if ([_courseType isEqualToString:@"3"]) {
        [param setObject:@"offline" forKey:@"source_type"];
    } else if ([_courseType isEqualToString:@"4"]) {
        [param setObject:@"classes" forKey:@"source_type"];
    }
    if ([[NSString stringWithFormat:@"%@",_dataSource[@"collected"]] boolValue]) {
        // 取消收藏 并改变数据源
        [Net_API requestDeleteWithURLStr:[Net_Path courseCollectionNet] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource];
                    [pass setObject:@"0" forKey:@"collected"];
                    _dataSource = [NSDictionary dictionaryWithDictionary:pass];
                    [_zanButton setImage:Image(@"course_collect_nor") forState:0];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络请求失败"];
        }];
    } else {
        // 收藏 并改变数据源
        [Net_API requestPOSTWithURLStr:[Net_Path courseCollectionNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource];
                    [pass setObject:@"1" forKey:@"collected"];
                    _dataSource = [NSDictionary dictionaryWithDictionary:pass];
                    [_zanButton setImage:Image(@"course_collect_pre") forState:0];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络请求失败"];
        }];
    }
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return self.view;
}

// MARK: - 右边按钮点击事件(收藏、下载、分享)
- (void)rightButtonClick:(id)sender {
    if ([[_dataSource objectForKey:@"share_force_login"] integerValue]) {
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
    }
    SharePosterViewController *vc = [[SharePosterViewController alloc] init];
    vc.type = @"1";
    vc.sourceId = _ID;
    vc.courseType = _courseType;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    [UMSocialUIManager setShareMenuViewDelegate:self];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = @"http://mobile.umeng.com/social";
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }];
}

// MARK: - 记笔记弹框系列流程
- (void)makePopView {
    if (_popWhiteView == nil) {
        _popWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, _faceImageView.bottom, MainScreenWidth, 180)];
        _popWhiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_popWhiteView];
        
        _popCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_popWhiteView.width - 15 - 36, 0, 36, 36)];
        [_popCancelButton setImage:Image(@"pay_close") forState:0];
        [_popCancelButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_popCancelButton];
        
        _popTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 36, _popWhiteView.width - 30, 100)];
        _popTextView.font = SYSTEMFONT(14);
        _popTextView.layer.masksToBounds = YES;
        _popTextView.layer.cornerRadius = 5;
        _popTextView.backgroundColor = HEXCOLOR(0xE4E7ED);
        _popTextView.textColor = EdlineV5_Color.textFirstColor;
        _popTextView.delegate = self;
        _popTextView.returnKeyType = UIReturnKeyDone;
        [_popWhiteView addSubview:_popTextView];
        
        _popTextPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_popTextView.left, _popTextView.top + 1, _popTextView.width, 30)];
        _popTextPlaceholderLabel.text = @" 输入笔记内容";
        _popTextPlaceholderLabel.textColor = EdlineV5_Color.textThirdColor;
        _popTextPlaceholderLabel.font = SYSTEMFONT(14);
        _popTextPlaceholderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
        [_popTextPlaceholderLabel addGestureRecognizer:placeTap];
        [_popWhiteView addSubview:_popTextPlaceholderLabel];
        
        _popTextMaxCountView = [[UILabel alloc] initWithFrame:CGRectMake(_popTextView.right - 4 - 100, _popTextView.bottom - 20, 100, 16)];
        _popTextMaxCountView.font = SYSTEMFONT(12);
        _popTextMaxCountView.textColor = EdlineV5_Color.textThirdColor;
        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
        _popTextMaxCountView.textAlignment = NSTextAlignmentRight;
        [_popWhiteView addSubview:_popTextMaxCountView];
        
        NSString *openText = @"公开";
        CGFloat openWidth = [openText sizeWithFont:SYSTEMFONT(14)].width + 4 + 20;
        CGFloat space = 2.0;
        
        _openButton = [[UIButton alloc] initWithFrame:CGRectMake(_popTextView.left - 3.5, _popWhiteView.height - 14 - 20, openWidth, 20)];
        [_openButton setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
        [_openButton setImage:Image(@"checkbox_nor") forState:0];
        [_openButton setTitle:openText forState:0];
        [_openButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        _openButton.titleLabel.font = SYSTEMFONT(14);
        _openButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
        _openButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_openButton];
        
        _popSureButton = [[UIButton alloc] initWithFrame:CGRectMake(_popWhiteView.width - 15 - 33, _popWhiteView.height - 14 - 20, 33, 20)];
        [_popSureButton setTitle:@"发布" forState:0];
        [_popSureButton setTitleColor:EdlineV5_Color.themeColor forState:0];
        _popSureButton.titleLabel.font = SYSTEMFONT(16);
        [_popSureButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_popSureButton];
    }
    [_popTextView becomeFirstResponder];
    _popWhiteView.hidden = NO;
    if (SWNOTEmptyDictionary(_originCommentInfo)) {
        _popTextView.text = [NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"content"]];
        _popTextPlaceholderLabel.hidden = YES;
        _popTextMaxCountView.text = [NSString stringWithFormat:@"%@/%@",@(_popTextView.text.length),@(wordMax)];
        _openButton.selected = [[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"open_status"]] boolValue];
        if (_popTextView.text.length>wordMax) {
            NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_popTextMaxCountView.text];
            [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _popTextMaxCountView.text.length - 4)];
            _popTextMaxCountView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
        }
    } else {
        _popTextView.text = @"";
        _popTextPlaceholderLabel.hidden = NO;
        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
        _openButton.selected = NO;
    }
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _popTextPlaceholderLabel.hidden = NO;
    } else {
        _popTextPlaceholderLabel.hidden = YES;
    }
    _popTextMaxCountView.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(wordMax)];
    if (textView.text.length>wordMax) {
        NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_popTextMaxCountView.text];
        [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _popTextMaxCountView.text.length - 4)];
        _popTextMaxCountView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    } else {
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _popTextPlaceholderLabel.hidden = YES;
    [_popTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _popTextPlaceholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_popTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)openButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)keyboardWillHide:(NSNotification *)notification{
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    if (IS_IPHONEX) {
        keyHeight = keyHeight - 34;
    }
    
    _popWhiteView.frame = CGRectMake(0, _faceImageView.height, MainScreenWidth, MainScreenHeight - keyHeight - _faceImageView.height);
    _popCancelButton.frame = CGRectMake(_popWhiteView.width - 15 - 36, 0, 36, 36);
    
    _popTextView.frame = CGRectMake(15, 36, _popWhiteView.width - 30, _popWhiteView.height - 36 - 14 - 20 - 10);
    _popTextView.layer.masksToBounds = YES;
    _popTextView.layer.cornerRadius = 5;
    
    _popTextPlaceholderLabel.frame = CGRectMake(_popTextView.left, _popTextView.top + 1, _popTextView.width, 30);
    
    _popTextMaxCountView.frame = CGRectMake(_popTextView.right - 4 - 100, _popTextView.bottom - 20, 100, 16);
    
    [_openButton setTop:_popWhiteView.height - 14 - 20];
    [_popSureButton setTop:_popWhiteView.height - 14 - 20];
}

- (void)popButtonClick:(UIButton *)sender {
    [_popTextView resignFirstResponder];
    if (sender == _popCancelButton) {
        _popTextView.text = @"";
        _popTextPlaceholderLabel.hidden = NO;
        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
        _popWhiteView.hidden = YES;
    } else if (sender == _popSureButton) {
        if (!SWNOTEmptyStr(_popTextView.text)) {
            [self showHudInView:self.view showHint:@"内容不能为空"];
            return;
        }
        if (_popTextView.text.length>wordMax) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"内容不能超过%@字",@(wordMax)]];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary new];
        if (SWNOTEmptyDictionary(_originCommentInfo)) {
            [param setObject:_popTextView.text forKey:@"content"];
            [param setObject:_openButton.selected ? @"1" : @"0"  forKey:@"open_status"];
            [Net_API requestPUTWithURLStr:[Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        _popTextView.text = @"";
                        _popTextPlaceholderLabel.hidden = NO;
                        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
                        _popWhiteView.hidden = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
                    }
                }
            } enError:^(NSError * _Nonnull error) {

            }];
        } else {
            [param setObject:_popTextView.text forKey:@"content"];
            [param setObject:_ID forKey:@"course_id"];
            if (SWNOTEmptyStr(_currentHourseId)) {
                [param setObject:_currentHourseId forKey:@"section_id"];
            }
            [param setObject:[NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"course_type"]] forKey:@"course_type"];
            [param setObject:_openButton.selected ? @"1" : @"0"  forKey:@"open_status"];
            [Net_API requestPOSTWithURLStr:(SWNOTEmptyDictionary(_originCommentInfo) ? [Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] : [Net_Path addCourseHourseNote]) WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        _popTextView.text = @"";
                        _popTextPlaceholderLabel.hidden = NO;
                        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
                        _popWhiteView.hidden = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
                    }
                }
            } enError:^(NSError * _Nonnull error) {

            }];
        }
    }
}

// MARK: - 图文电子书观看时长相关处理
- (void)tuwenStartTimer {
    __weak typeof(self) weakself = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakself];
    [NSObject cancelPreviousPerformRequestsWithTarget:weakself selector:@selector(tuwenStartTimer) object:nil];
    eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tuwenEventTimerDown) userInfo:nil repeats:YES];
}

// MARK: - 图文电子书 计时
- (void)tuwenEventTimerDown {
    eventTime++;
    if (eventTime>0 && (eventTime%10 == 0)) {
        [self requestTuwenRecord];
    } else {
        
    }
}

- (void)stopTuwenTimer {
    if (eventTimer) {
        if (eventTime>0 && eventTime<10) {
            [self tuwenRequestCurrentSecond:@""];
            eventTime = 0;
        }
        eventTime = 0;
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

- (void)requestTuwenRecord {
    WEAK(self);
    if (SWNOTEmptyStr(_currentHourseId)) {
        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":weakself.ID,@"section_id":_currentHourseId,@"current_time":@"10"} finish:^(id  _Nonnull responseObject) {
            
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        if (eventTime>0 && eventTime<10) {
            [self tuwenRequestCurrentSecond:_currentHourseId];
            eventTime = 0;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

// MARK: - 不足10秒传具体秒数
- (void)tuwenRequestCurrentSecond:(NSString *)courseHourse_id {
    WEAK(self);
    // 区分两种情况 当前没有切换课时播放; 切换课时播放(切换时候停止传上一个课时ID 切换后退出页面传当前课时ID);
    if (SWNOTEmptyStr(courseHourse_id)) {
        [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":weakself.ID,@"section_id":courseHourse_id,@"current_time":@(eventTime)} finish:^(id  _Nonnull responseObject) {
            
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        if (SWNOTEmptyStr(_currentHourseId) || SWNOTEmptyStr(_previousHourseId)) {
            [Net_API requestPOSTWithURLStr:[Net_Path addRecord] WithAuthorization:nil paramDic:@{@"course_id":weakself.ID,@"section_id":(SWNOTEmptyStr(_previousHourseId) ? _previousHourseId : _currentHourseId),@"current_time":@(eventTime)} finish:^(id  _Nonnull responseObject) {
                
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

- (void)autoPlayNextCourseHourse:(CourseListModelFinal *)model {
    
    if (_courseListVC) {
        _courseListVC.next_position = nil;
    }
    if (_courseTreeListVC) {
        _courseTreeListVC.next_position = nil;
    }
    
    _previousHourseId = _currentHourseId;
    _currentHourseId = model.model.classHourId;
    __weak CourseDetailPlayVC *wekself = self;
    
    CourseListModelFinal *currentt = model;
    currentCourseFinalModel = currentt;
    
    wekself.freeLookView.hidden = YES;
    
    freeLook = NO;
//    if ([_courseType isEqualToString:@"2"]) {
//        [wekself stopRecordTimer];
//        [wekself stopTuwenTimer];
//        [wekself destroyPlayVideo];
//        [AppDelegate delegate]._allowRotation = NO;
//        _titleImage.hidden = NO;
//        if (model.model.audition <= 0 && !model.model.is_buy) {
//            if ([model.model.price floatValue] > 0) {
//                OrderViewController *vc = [[OrderViewController alloc] init];
//                vc.orderTypeString = [_courseType isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
//                vc.orderId = model.model.classHourId;
//                [self.navigationController pushViewController:vc animated:YES];
//                [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
//            } else {
//                [self showHudInView:self.view showHint:@"需解锁该课程"];
//            }
//            return;
//        }
//        //        学习状态【957：未开始；999：直播中；992：已结束；】
//        if (model.model.live_rate.status == 999) {
//            [self getShengwangLiveInfo:model.model.classHourId courselistModel:model.model];
//        } else if (model.model.live_rate.status == 957) {
//            [self showHudInView:self.view showHint:model.model.live_rate.status_text];
//        } else if (model.model.live_rate.status == 992) {
//            if (SWNOTEmptyArr(model.model.live_rate.callback_url)) {
//                // 用播放器播放回放视频
//                [wekself.headerView addSubview:wekself.playerView];
//                _wkWebView.hidden = YES;
//                _playerView.hidden = NO;
//                _titleImage.hidden = NO;
//                [wekself.headerView bringSubviewToFront:wekself.titleImage];
//                [wekself.playerView setTitle:model.model.title];
//                wekself.playerView.trackInfoArray = [NSArray arrayWithArray:model.model.live_rate.callback_url];
//                [wekself.playerView playViewPrepareWithURL:EdulineUrlString(model.model.live_rate.callback_url[0][@"play_url"])];
//                wekself.playerView.userInteractionEnabled = YES;
//                [AppDelegate delegate]._allowRotation = YES;
//            }
//        }
//        return;
//    }
    
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
            if (vccomment.cellType) {
                // 笔记
                vccomment.detailVC = self;
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
    
    [wekself stopRecordTimer];
    [wekself stopTuwenTimer];
    [wekself destroyPlayVideo];
    [AppDelegate delegate]._allowRotation = NO;
    _titleImage.hidden = NO;
    //首先全部重置为没有再播放
    for (int i = 0; i<_courseListVC.courseListArray.count; i++) {
        CourseListModelFinal *model1 = _courseListVC.courseListArray[i];
        for (int j = 0; j<model1.child.count; j++) {
            CourseListModelFinal *model2 = model1.child[j];
            for (int k = 0; k<model2.child.count; k++) {
                CourseListModelFinal *model3 = model2.child[k];
                model3.isPlaying = NO;
                [model2.child replaceObjectAtIndex:k withObject:model3];
            }
            model2.isPlaying = NO;
            [model1.child replaceObjectAtIndex:j withObject:model2];
        }
        model1.isPlaying = NO;
        [_courseListVC.courseListArray replaceObjectAtIndex:i withObject:model1];
    }
    
//    if (model.model.audition <= 0 && !model.model.is_buy) {
//        if ([model.model.price floatValue] > 0) {
//            OrderViewController *vc = [[OrderViewController alloc] init];
//            vc.orderTypeString = [_courseType isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
//            vc.orderId = model.model.classHourId;
//            [self.navigationController pushViewController:vc animated:YES];
//            [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
//        } else {
//            [self showHudInView:self.view showHint:@"需解锁该课程"];
//        }
//        [_courseListVC.tableView reloadData];
//        return;
//    }
    
    [_playFileUrlArray removeAllObjects];
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseHourseUrlNet:model.model.course_id pid:model.model.classHourId] WithAuthorization:nil paramDic:[_courseType isEqualToString:@"4"] ? @{@"class_id":wekself.ID} : nil finish:^(id  _Nonnull responseObject) {
        
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSMutableArray *current_position = [NSMutableArray arrayWithArray:responseObject[@"data"][@"curr_position"][@"position"]];
                NSMutableArray *next_position = [NSMutableArray arrayWithArray:responseObject[@"data"][@"next_position"][@"position"]];
                if (_courseListVC) {
                    _courseListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseListVC justReloadListStatus];
                }
                if (_courseTreeListVC) {
                    _courseTreeListVC.current_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"curr_position"]];
                    _courseTreeListVC.next_position = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"next_position"]];
                    [_courseTreeListVC justReloadListStatus];
                }
                if ([model.model.section_data.data_type isEqualToString:@"3"] || [model.model.section_data.data_type isEqualToString:@"4"]) {
                    if (!SWNOTEmptyStr(responseObject[@"data"][@"fileurl_string"])) {
                        if (_courseListVC) {
                            [_courseListVC.tableView reloadData];
                        }
                        if (_courseTreeListVC) {
                            [_courseTreeListVC.tableView reloadData];
                        }
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        _wkWebView.hidden = NO;
                        _playerView.hidden = YES;
                        if ([model.model.section_data.data_type isEqualToString:@"3"]) {
                            _pdfV.hidden = YES;
                            _wkWebView.scrollView.hidden = NO;
                            [_wkWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]]];
                        } else {
                            _wkWebView.scrollView.hidden = YES;
                            _pdfV.hidden = NO;
                            _pdfV.document = [[PDFDocument alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"fileurl_string"]]];
                        }
                        [_tableView setContentOffset:CGPointZero animated:YES];
                        if (_courseListVC) {
                            [_courseListVC.tableView reloadData];
                        }
                        if (_courseTreeListVC) {
                            [_courseTreeListVC.tableView reloadData];
                        }
                        
                        [self tuwenStartTimer];
                        return;
                    }
                } else {
                    [_playFileUrlArray addObjectsFromArray:responseObject[@"data"][@"fileurl_array"]];
                    if (!SWNOTEmptyArr(_playFileUrlArray)) {
                        [_courseListVC.tableView reloadData];
                        [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                        return;
                    } else {
                        NSDictionary *firstFileUrlInfo = [NSDictionary dictionaryWithDictionary:_playFileUrlArray[0]];
                        if (SWNOTEmptyStr(firstFileUrlInfo[@"play_url"])) {
//                            if (currentCourseFinalModel.model.audition > 0 && !currentCourseFinalModel.model.is_buy) {
//                                freeLook = YES;
//                            }
                            [wekself.headerView addSubview:wekself.playerView];
                            _wkWebView.hidden = YES;
                            _playerView.hidden = NO;
                            _titleImage.hidden = NO;
                            [wekself.headerView bringSubviewToFront:wekself.titleImage];
                            NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
                            if ([faceUrlString containsString:@"http"]) {
                                wekself.playerView.coverUrl = EdulineUrlString([_dataSource objectForKey:@"cover_url"]);
                            }
                            if ([model.model.section_data.data_type isEqualToString:@"2"]) {
                                wekself.playerView.unHiddenCoverImage = YES;
                            } else {
                                wekself.playerView.unHiddenCoverImage = NO;
                            }
                            [wekself.playerView setTitle:currentCourseFinalModel.model.title];
                            wekself.playerView.trackInfoArray = [NSArray arrayWithArray:_playFileUrlArray];
                            [wekself.playerView playViewPrepareWithURL:EdulineUrlString(firstFileUrlInfo[@"play_url"])];
                            wekself.playerView.userInteractionEnabled = YES;
                            [AppDelegate delegate]._allowRotation = YES;
                        } else {
                            if (_courseListVC) {
                                [_courseListVC.tableView reloadData];
                            }
                            if (_courseTreeListVC) {
                                [_courseTreeListVC.tableView reloadData];
                            }
                            [self showHudInView:wekself.view showHint:@"该课时内容无效"];
                            return;
                        }
                    }
                }
            }
        }
        
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"课时信息请求失败"];
    }];
}

// MARK: - CC直播
/**
 *    @brief    配置SDK
 */
-(void)integrationSDK{
    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = currentCourseFinalModel.model.section_live.cc_userid;//@"56761A7379431808";//
    parameter.roomId = currentCourseFinalModel.model.section_live.cc_room_id;//@"BBC10038C0C26ECD9C33DC5901307461";//
    parameter.viewerName = [V5_UserModel uname];//@"普通人";//
    parameter.token = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];//@"524550";//登陆密码
    parameter.security = YES;//是否使用https (已弃用)
    parameter.viewerCustomua = @"";//自定义参数
    parameter.tpl = 20;
    RequestData *requestData = [[RequestData alloc] initLoginWithParameter:parameter];
    requestData.delegate = self;
}

#pragma mark- 必须实现的代理方法RequestDataDelegate
//@optional
/**
 *    @brief    请求成功
 */
-(void)loginSucceedPlay {
    
    SaveToUserDefaults(WATCH_USERID,currentCourseFinalModel.model.section_live.cc_userid);
    SaveToUserDefaults(WATCH_ROOMID,currentCourseFinalModel.model.section_live.cc_room_id);
    SaveToUserDefaults(WATCH_USERNAME,[V5_UserModel uname]);
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(WATCH_PASSWORD,ak);
    
    // 请求一次学习记录
    [self requestOnceStudyRecord:currentCourseFinalModel.model.classHourId];
    
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    CCPlayerController *playForPCVC = [[CCPlayerController alloc] initWithRoomName:self.roomName];
    playForPCVC.modalPresentationStyle = 0;
    [self presentViewController:playForPCVC animated:YES completion:^{
    }];
}
/**
 *    @brief    登录请求失败
 */
-(void)loginFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    
    NSLog(@"CC直播登陆请求失败原因 = %@",message);
}
/**
 *    @brief  获取房间信息
 *    房间名称：dic[@"name"];
 */
-(void)roomInfo:(NSDictionary *)dic {
    _roomName = dic[@"name"];
}

// MARK: - CC直播回放

/**
 配置SDK
 */
-(void)integrationPlayBackSDK{
    
    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = currentCourseFinalModel.model.section_live.cc_userid;
    parameter.roomId = currentCourseFinalModel.model.section_live.cc_room_id;
    parameter.recordId = currentCourseFinalModel.model.section_live.cc_replay_id;
    parameter.viewerName = [V5_UserModel uname];
    parameter.token = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    parameter.security = NO;
    
    self.requestDataPlayBack = [[RequestDataPlayBack alloc] initLoginWithParameter:parameter];
    self.requestDataPlayBack.delegate = self;
}

#pragma mark- 必须实现的代理方法RequestDataPlayBackDelegate
/**
 *    @brief    请求成功
 */
-(void)loginSucceedPlayBack {
    
    SaveToUserDefaults(PLAYBACK_USERID,currentCourseFinalModel.model.section_live.cc_userid);
    SaveToUserDefaults(PLAYBACK_ROOMID,currentCourseFinalModel.model.section_live.cc_room_id);
    SaveToUserDefaults(PLAYBACK_RECORDID,currentCourseFinalModel.model.section_live.cc_replay_id);
    SaveToUserDefaults(PLAYBACK_USERNAME,[V5_UserModel uname]);
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(PLAYBACK_PASSWORD,ak);
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    CCPlayBackController *playBackVC = [[CCPlayBackController alloc] init];
    playBackVC.modalPresentationStyle = 0;
    [self presentViewController:playBackVC animated:YES completion:^{
        _requestDataPlayBack = nil;
    }];
}

// MARK: - CC云课堂

// MARK: - 课堂链接方式
-(void)parseCodeStr:(NSString *)result {
    
    /**
     讲师：http://cloudclass.csslcloud.net/index/presenter/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     助教：http://cloudclass.csslcloud.net/index/assistant/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     学员：http://cloudclass.csslcloud.net/index/talker/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     隐身者：http://cloudclass.csslcloud.net/index/inspector/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     旁听:https://view.csslcloud.net/api/view/index?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     */
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    
    if ([currentCourseFinalModel.model.section_live.identify isEqualToString:@"presenter"]) {
        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/presenter/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",currentCourseFinalModel.model.section_live.cc_room_id,currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
    } else if ([currentCourseFinalModel.model.section_live.identify isEqualToString:@"assistant"]) {
        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/assistant/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",currentCourseFinalModel.model.section_live.cc_room_id,currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
    } else if ([currentCourseFinalModel.model.section_live.identify isEqualToString:@"talker"]) {
        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/talker/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",currentCourseFinalModel.model.section_live.cc_room_id,currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
    } else if ([currentCourseFinalModel.model.section_live.identify isEqualToString:@"inspector"]) {
        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/inspector/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",currentCourseFinalModel.model.section_live.cc_room_id,currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
    } else if ([currentCourseFinalModel.model.section_live.identify isEqualToString:@"view"]) {
        result = [NSString stringWithFormat:@"https://view.csslcloud.net/api/view/index?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",currentCourseFinalModel.model.section_live.cc_room_id,currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
    }
    
    NSRange rangeRoomId = [result rangeOfString:@"roomid="];
    NSRange rangeUserId = [result rangeOfString:@"userid="];
    WS(ws)
    if (!StrNotEmpty(result) || rangeRoomId.location == NSNotFound || rangeUserId.location == NSNotFound)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HDClassLocalizeString(@"解析错误错误") message:HDClassLocalizeString(@"课堂链接错误") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:HDClassLocalizeString(@"好") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [ws presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *resultNew = [result stringByReplacingOccurrencesOfString:@"#" withString:@"index"];

        NSDictionary *roomInfo = [HDSTool parseURLParam:resultNew];
        NSString *roomId = roomInfo[@"roomid"];
        NSString *userId = roomInfo[@"userid"];
        NSInteger mode = [roomInfo[@"template"]integerValue];

        HDSTool *tool = [HDSTool sharedTool];
        tool.rid = roomId;
        tool.uid = userId;
        tool.roomMode = mode;

        if (!roomId || !userId) {
            return;
        }
        resultNew = [HDSTool getUrlStringWithString:resultNew];
        NSURL *url = [NSURL URLWithString:resultNew];
        NSString *path = [[url path]lastPathComponent];
        NSString *role = path;

        SaveToUserDefaults(LIVE_USERID,userId);
        SaveToUserDefaults(LIVE_ROOMID,roomId);

        NSString *urlDealed = [[CCScanViewController new]dealURLClassToCCAPI:result];
        [[CCStreamerBasic sharedStreamer]setServerDomain:urlDealed area:nil];
        
        __weak typeof(self) weakSelf = self;
        userId = [userId stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self getRoomDescWithRoomID:roomId classNo:nil completion:^(BOOL result, NSError *error, id info) {
            CCRoomDecModel *model = (CCRoomDecModel *)info;
            if (result)
            {
                if ([model.result isEqualToString:@"OK"])
                {
                    HDSTool *tool = [HDSTool sharedTool];
                    tool.roomSubMode = model.data.layout_mode;

                    SaveToUserDefaults(LIVE_ROOMNAME, model.data.name);
                    SaveToUserDefaults(LIVE_ROOMDESC, model.data.desc);
                    NSInteger authKey = [CCRoomDecModel authTypeKeyForRole:role model:model.data];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[@"userID"] = userId;
                    userInfo[@"roomID"] = roomId;
                    userInfo[@"role"] = role;
                    userInfo[@"authtype"] = @(authKey);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanSuccess" object:nil userInfo:userInfo];
                }
                else
                {
                    [CCTool showMessage:model.errorMsg];
                }
            }
            else
            {
            }
        }];
    }
}

- (void)ScanSuccess:(NSNotification *)noti
{
    NSString *userId = noti.userInfo[@"userID"];
    NSString *roomId = noti.userInfo[@"roomID"];
    NSString *role = noti.userInfo[@"role"];
    NSInteger authtype = [noti.userInfo[@"authtype"] integerValue];
    BOOL needPassword = authtype == 2 ? NO : YES;
    BOOL liveVCNeedPassword;
    NSInteger role1 = [CCTool roleFromRoleString:role];
    self.ccClassRoomrole = role1;
    self.role = role1;
    
    if (role1 == CCRole_Teacher || role1 == CCRole_Assistant)
    {
        liveVCNeedPassword = YES;
    }
    else
    {
        if (role1 == CCRole_Teacher)
        {
            liveVCNeedPassword = YES;
        }
        else
        {
            liveVCNeedPassword = needPassword;
        }
    }
    
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(SET_USER_NAME, [V5_UserModel uname]);
    SaveToUserDefaults(SET_USER_PWD, ak);//@"671309"
    SaveToUserDefaults(LIVE_USERID, userId);
    SaveToUserDefaults(LIVE_ROOMID, roomId);

    NSString *isp = GetFromUserDefaults(SERVER_AREA_NAME);

    NSString *uname = [V5_UserModel uname];
    
    NSString *upwd = ak;//@"671309"//(liveVCNeedPassword ? ak : @"");;

    __weak typeof(self) weakSelf = self;
    __block NSString *sessionStr = nil;
    [[CCStreamerBasic sharedStreamer] authWithRoomId:roomId accountId:userId role:self.ccClassRoomrole password:upwd nickName:uname completion:^(BOOL result, NSError *error, id info) {
        if (!result)
        {
            [CCTool showMessageError:error];
            return;
        }
        NSDictionary *dic = (NSDictionary *)info;
        NSString *res = dic[@"result"];
        NSString *errmsg = @"";
        if ([res isEqualToString:@"FAIL"])
        {
            errmsg  = dic[@"errorMsg"];
            [CCTool showMessage:errmsg];
            return ;
        }
        NSDictionary *dataDic = dic[@"data"];
        sessionStr = [dataDic objectForKey:@"sessionid"];
        SaveToUserDefaults(Login_UID, [dataDic objectForKey:@"userid"]);
        {
            weakSelf.sessionID = sessionStr;
            CCEncodeConfig *config = [[CCEncodeConfig alloc] init];
            config.reslution = CCResolution_240;
            [weakSelf initVC];

            NSString *accountid = userId;
            NSString *sessionid = self.sessionID;
            [[CCStreamerBasic sharedStreamer] joinWithAccountID:accountid sessionID:sessionid roomId:roomId config:config areaCode:isp events:@[] updateRtmpLayout:NO completion:^(BOOL result, NSError *error, id info) {
                BOOL modeGravity = [HDSDocManager sharedDoc].isPreviewGravityFollow;
                [[CCStreamerBasic sharedStreamer]setPreviewGravityFollow:modeGravity];

                HDSTool *tool = [HDSTool sharedTool];
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }

                if (result) {
                    weakSelf.loginInfo = info;
                    NSLog(HDClassLocalizeString(@"登录获取的info：%@") ,info);
                    if ([NSThread isMainThread]) {
                        if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                            [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                        }
                    }else {
                        main_async_safe(^{
                            if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                                [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                            }
                        });
                    }

                }else{
                    if (error.code == 22002) {

                        int version_check = [info[@"version_check"] intValue];
                        if (version_check == 1) {
                            return;
                        }
                    }
                }
            }];
        }
    }];
    
}

// MARK: - 获取直播间房间信息
- (void)getRoomIdAndDesc:(NSString *)classNo {
    // 100621591
    classNo = @"100621591";
    if (classNo.length == 0) {
        [CCTool showMessage:@"参课码错误"];
        return;
    }
    if (classNo.length != 9) {
        [CCTool showMessage:@"参课码错误"];
        return;
    }
    WeakSelf(weakSelf);
    [self getRoomDescWithRoomID:nil classNo:classNo completion:^(BOOL result, NSError *error, id info) {
        weakSelf.descModel = (CCRoomDecModel *)info;
        if (result)
        {
            if ([weakSelf.descModel.result isEqualToString:@"OK"])
            {
                weakSelf.descModel.data.classNo = classNo;
                HDSTool *tool = [HDSTool sharedTool];
                tool.roomSubMode = weakSelf.descModel.data.layout_mode;
                tool.rid = weakSelf.descModel.data.live_roomid;
                tool.uid = weakSelf.descModel.data.userid;
                tool.roomMode = weakSelf.descModel.data.templatetype;
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }
                if ([classNo hasSuffix:@"4"]) {
                    if (tool.roomMode != 32) {
                        [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
                        return;
                    } else {
                        if (tool.roomSubMode > 0) {
                            [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
                            return;
                        }
                    }
                }

                SaveToUserDefaults(LIVE_ROOMNAME, weakSelf.descModel.data.name);
                SaveToUserDefaults(LIVE_ROOMDESC, weakSelf.descModel.data.desc);
                //todo...
                // 进入云课堂
                [self loginCCClassRoomActionJoin];
            }
            else
            {
                [CCTool showMessage:weakSelf.descModel.errorMsg];
            }
        }
        else
        {
            NSString *errMessage = error.domain;
            if (!errMessage) {
                errMessage = HDClassLocalizeString(@"网络不稳定,请重试!") ;
            }
            NSInteger errCode = error.code;
            
            NSString *message = [NSString stringWithFormat:@"%@<%d>",errMessage,errCode];
            [HDSTool showAlertTitle:@"" msg:message completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
            }];
        }
    }];
}

// MARK: - 获取房间信息回调
- (void)getRoomDescWithRoomID:(NSString *)roomId classNo:(NSString *)classNo completion:(CCComletionBlock)completion {
    [CCRoomDecModel getRoomDescWithRoomID:roomId classCode:classNo completion:^(BOOL result, NSError *error, id info) {
        completion(result, error, info);
    }];
}

-(void)loginCCClassRoomActionJoin
{
    NSString *classCodeString = @"100621591";
    if ([classCodeString hasSuffix:@"0"]) {///老师 助教
        ///需要密码
        self.role = CCRole_Teacher;
        self.needPassword = YES;
    }else if ([classCodeString hasSuffix:@"1"]) {///学生
        self.role = CCRole_Student;
        self.needPassword = self.descModel.data.talker_authtype == 2 ? NO : YES;
    }else if ([classCodeString hasSuffix:@"7"]) {///麦下观众
        self.role = CCRole_au_low;
        self.needPassword = self.descModel.data.talker_authtype == 2 ? NO : YES;
    }else if ([classCodeString hasSuffix:@"3"]) {///隐身者
        if (self.descModel.data.templatetype == 32) {
            [CCTool showMessage:HDClassLocalizeString(@"暂不支持隐身者") ];
            return;
        }
        self.role = CCRole_Inspector;
        self.needPassword = self.descModel.data.inspector_authtype == 2 ? NO : YES;
    } else if ([self.classCodeView.classCodeTF.text hasSuffix:@"4"]) {
        self.role = CCRole_Assistant;
        self.needPassword = YES;
    }
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(SET_USER_NAME, [V5_UserModel uname]);
    SaveToUserDefaults(SET_USER_PWD, ak);//@"671309"
    SaveToUserDefaults(LIVE_USERID, self.descModel.data.userid);
    SaveToUserDefaults(LIVE_ROOMID, self.descModel.data.live_roomid);

    NSString *isp = GetFromUserDefaults(SERVER_AREA_NAME);

    NSString *uname = [V5_UserModel uname];


    NSString *upwd = ak;//@"671309";

    __weak typeof(self) weakSelf = self;
    __block NSString *sessionStr = nil;
    [[CCStreamerBasic sharedStreamer] authWithRoomId:self.descModel.data.live_roomid accountId:self.descModel.data.userid role:self.role password:upwd nickName:uname completion:^(BOOL result, NSError *error, id info) {
        if (!result)
        {
            [CCTool showMessageError:error];
            return;
        }
        NSDictionary *dic = (NSDictionary *)info;
        NSString *res = dic[@"result"];
        NSString *errmsg = @"";
        if ([res isEqualToString:@"FAIL"])
        {
            errmsg  = dic[@"errorMsg"];
            [CCTool showMessage:errmsg];
            return ;
        }
        NSDictionary *dataDic = dic[@"data"];
        sessionStr = [dataDic objectForKey:@"sessionid"];
        SaveToUserDefaults(Login_UID, [dataDic objectForKey:@"userid"]);
        {
            weakSelf.sessionID = sessionStr;
            CCEncodeConfig *config = [[CCEncodeConfig alloc] init];
            config.reslution = CCResolution_240;
            [weakSelf initVC];

            NSString *accountid = self.descModel.data.userid;
            NSString *sessionid = self.sessionID;
            [[CCStreamerBasic sharedStreamer] joinWithAccountID:accountid sessionID:sessionid roomId:weakSelf.descModel.data.live_roomid config:config areaCode:isp events:@[] updateRtmpLayout:NO completion:^(BOOL result, NSError *error, id info) {
                BOOL modeGravity = [HDSDocManager sharedDoc].isPreviewGravityFollow;
                [[CCStreamerBasic sharedStreamer]setPreviewGravityFollow:modeGravity];

                HDSTool *tool = [HDSTool sharedTool];
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }

                if (result) {
                    weakSelf.loginInfo = info;
                    NSLog(HDClassLocalizeString(@"登录获取的info：%@") ,info);
                    if ([NSThread isMainThread]) {
                        if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                            [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                        }
                    }else {
                        main_async_safe(^{
                            if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                                [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                            }
                        });
                    }

                }else{
                    if (error.code == 22002) {

                        int version_check = [info[@"version_check"] intValue];
                        if (version_check == 1) {
                            return;
                        }
                    }
                }
            }];
        }
    }];
}

// MARK: - 初始化云课堂控制器
- (void)initVC {
    HDSTool *tool = [HDSTool sharedTool];
    if (tool.roomMode == 32) {
        if (tool.roomSubMode == 1) {
            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_1V1_16_9];
        }else if (tool.roomSubMode == 2) {
            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_1V1_4_3];
        } else {
            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_saas];
        }
        self.liveVC.allowTakePhotoInLibrary = YES;
        
        HSRoomConfig *roomInfo = [[HSRoomConfig alloc]init];
        roomInfo.bleLicense = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxsaWNlbnNlIHZlcnNpb249InYxLjAiIGlkPSI2MDU5YTE3Y2I1YmE3ZDhmMjExZmUyODAiPgogICAgPG93bmVyPuWIm+ebm+inhuiBlOaVsOeggeenkeaKgO+8iOWMl+S6rO+8ieaciemZkOWFrOWPuDwvb3duZXI+CiAgICA8dXNlcj5jaGVuZnk8L3VzZXI+CiAgICA8ZW1haWw+Y2hlbmZ5QGJva2VjYy5jb208L2VtYWlsPgogICAgPGJ1bmRsZUlkPmNvbS5jbGFzcy5yb29tPC9idW5kbGVJZD4KICAgIDxhcHBOYW1lPmNjPC9hcHBOYW1lPgogICAgPGRyaXZlclR5cGVzPgogICAgICAgIDxkcml2ZXJUeXBlPklPUzwvZHJpdmVyVHlwZT4KICAgIDwvZHJpdmVyVHlwZXM+CiAgICA8cGVuVHlwZXM+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iQURQXzEwMSIgSUQ9IjUiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQURQXzYwMSIgSUQ9IjYiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQVBEXzYxMSIgSUQ9IjciIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iVEVfMzAxIiBJRD0iOCIgLz4KICAgICAgICA8cGVuVHlwZSBwZW5OYW1lPSJURV8zMDIiIElEPSI5IiAvPgogICAgICAgIDxwZW5UeXBlIHBlbk5hbWU9IlREXzEwMiIgSUQ9IjEwIiAvPgogICAgPC9wZW5UeXBlcz4KICAgIDxsaWNlbnNlZERhdGU+MTk3MDAxMDE8L2xpY2Vuc2VkRGF0ZT4KICAgIDxleHBpcmVkRGF0ZT45OTk5MTIzMTwvZXhwaXJlZERhdGU+CiAgICA8YXV0aElkPjYwNTk5YzQwYjViYTdkOGYyMTFmZTI3ZjwvYXV0aElkPgogICAgPHNlY3JldD5jU0VoY3kxQU1pTTRmaVFvY0g1ZU1USjJlVzEwWkNseUl6RnlJemN4TWw0PTwvc2VjcmV0PgogICAgPHBhZ2VBZGRyZXNzIHN0YXJ0PSI3MC4wLjE3LjAiIGVuZD0iNzAuMC4xNy4xOSIgcGFnZUNvdW50PSIyMCIgLz4KICAgIDxhdXRob3JpemVyIGNvbXBhbnk9IuWMl+S6rOaLk+aAneW+t+enkeaKgOaciemZkOWFrOWPuCIgd2Vic2l0ZT0iaHR0cDovL3d3dy50c3R1ZHkuY29tLmNuIiAvPgo8L2xpY2Vuc2U+Cg==";
        roomInfo.bleSignature = @"57E8A02D4FB158106F27FD1ECE5063753FAC2E096E49CB8A53B48B58DDA03A6CC9901865D0BC6DB313AE3AE8CEEFDCC426313ED5FDE8904DB5BACA83658A3F6AC6B360BF676D1EE7C47E9D6471540D8ECF4948680D30C54DC9766960516A7DE2F64594A25A0CF6C74A4872C765E7FC57ED076B8376EAE16682C5A94A432612EA";
        [ self.liveVC setLiveRoomConfig:roomInfo];

        return;
    }
    if (self.role == CCRole_Teacher)
    {
        if (self.pushVC) {
            [self.pushVC removeObserver];
        }
        self.pushVC = [[CCPushViewController alloc] initWithLandspace:self.isLandSpace];
        self.pushVC.isQuick = YES;
    }
    else if (self.role == CCRole_Student)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Student;
        self.playVC.isQuick = YES;
    }
    else if (self.role == CCRole_Inspector)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.isQuick = YES;
    }
//    else if (self.role == CCRole_Assistant)
//    {
//        if (self.teacherCopyVC) {
//            [self.teacherCopyVC removeObserver];
//        }
//        self.teacherCopyVC = [[CCTeachCopyViewController alloc]initWithLandspace:self.isLandSpace];
//    }
}

// MARK: - 推流成功
- (void)streamLoginSuccess:(NSDictionary *)info {
    HDSTool *tool = [HDSTool sharedTool];
    if (tool.roomMode == 32) {
//        [self landscapeRight:YES];
        self.liveVC.version_info = info;
        self.liveVC.openUrl = @"itms-apps://itunes.apple.com/app/id1239642978";
        if ([[self.navigationController.viewControllers lastObject] isKindOfClass:self.class]) {
            [self.navigationController pushViewController:self.liveVC animated:YES];
        }
        return;
    }
    //存储用户名、密码
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    NSString *userName = [V5_UserModel uname];
    NSString *userpwd = ak;//@"671309";
    SaveToUserDefaults(@"kkuserName", userName);
    SaveToUserDefaults(@"kkuserpwd", userpwd);
    NSString *userID =  self.descModel.data.userid;
    SaveToUserDefaults(LIVE_USERNAME, userName);
    if (self.role == CCRole_Teacher || self.role == CCRole_Assistant)
    {
        [CCDrawMenuView teacherResetDefaultColor];
    }
    else
    {
        [CCDrawMenuView resetDefaultColor];
    }
    if (self.role == CCRole_Teacher)
    {
        self.pushVC.sessionId =  self.sessionID;
        self.pushVC.viewerId = userID;
        self.pushVC.isLandSpace = self.isLandSpace;
        self.pushVC.roomID = self.descModel.data.live_roomid;
        self.pushVC.videoOriMode = self.isLandSpace ? CCVideoLandscape : CCVideoPortrait;
        self.pushVC.videoOriMode = CCVideoChangeByInterface;
//        if ([self isControllerPresented:[CCPushViewController class]]) {
//            return;
//        }
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:self.pushVC];
        Nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:Nav animated:YES completion:^{
            
        }];
//        [self.navigationController pushViewController:self.pushVC animated:YES];
    }
    else if (self.role == CCRole_Student)
    {
        self.playVC.sessionId =  self.sessionID;
        self.playVC.viewerId = userID;
//        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
//        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        
        self.playVC.isNeedPWD = self.needPassword;
        self.playVC.roleType = CCRole_Student;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:self.playVC];
        Nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:Nav animated:YES completion:^{
            
        }];
//        [self.navigationController pushViewController:self.playVC animated:YES];
    }
    else if (self.role == CCRole_Inspector)
    {
        self.playVC.loginInfo = info;
        self.playVC.viewerId = userID;
        self.playVC.sessionId =  self.sessionID;
//        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
//        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:self.playVC];
        Nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:Nav animated:YES completion:^{
            
        }];
//        [self.navigationController pushViewController:self.playVC animated:YES];
//        if ([self isControllerPresented:[CCPlayViewController class]]) {
//            return;
//        }
//        [self.navigationController pushViewController:self.playVC animated:YES];
    }
}

- (BOOL)isControllerPresented:(Class)class {
    UIViewController *vc = [HDSTool currentViewController];
    if ([vc isKindOfClass:class]) {
        NSLog(@"UIViewController---ERROR!---:%@",class);
        return YES;
    }
    return NO;
}

@end
