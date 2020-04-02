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

//播放器
#import "AliyunVodPlayerView.h"
#import "AliyunUtil.h"
#import "AlivcVideoPlayListModel.h"
#import "AppDelegate.h"

#define FacePlayImageHeight 207

@interface CourseDetailPlayVC ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,CourseTeacherAndOrganizationViewDelegate,CourseCouponViewDelegate,CourseDownViewDelegate,AliyunVodPlayerViewDelegate,CourseListVCDelegate> {
    // 新增内容
    CGFloat sectionHeight;
}

/**三大子页面*/
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
@property (nonatomic, strong) UIView *blueLineView;

/// 底部全部设置为全局变量为了好处理交互
@property (nonatomic, strong) UIView *bg;

/**更多按钮弹出视图*/
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong, nonatomic) CourseDownView *courseDownView;

// 播放器
@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;

@end

@implementation CourseDetailPlayVC

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self destroyPlayVideo];

}

- (void)destroyPlayVideo{
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isClassNew = YES;
    /// 新增内容
    self.canScroll = YES;
    self.canScrollAfterVideoPlay = YES;
    
    _tabClassArray = [NSMutableArray arrayWithArray:@[@"目录",@"笔记",@"点评"]];

    self.canScroll = YES;
    _titleLabel.text = @"课程详情";
    _titleImage.backgroundColor = BasidColor;

    [self makeHeaderView];
    [self makeSubViews];
//    self.playerView.hidden = YES;
    self.playerView.coverImageView.image = DefaultImage;
    [_headerView addSubview:self.playerView];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_UPHEIGHT;
    [self makeTableView];
    [self.view bringSubviewToFront:_titleImage];
    _titleImage.backgroundColor = [UIColor clearColor];
    _titleLabel.hidden = YES;
    _lineTL.hidden = YES;
    [self makeDownView];
    [self getCourseInfo];
    /**************************************/
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

- (void)willResignActive {
    if (_playerView &&  self.playerView.playerViewState == AVPStatusStarted){
        [self.playerView pause];
    }
}

- (void)becomeActive{
    if (self.playerView && [self.playerView getPopLayerIsHidden] == YES){
        [self.playerView resume];
    }
//    if (self.isPresent == NO) {
//        self.isBecome = NO;
//        NSLog(@"%@%ld",NSLocalizedString(@"播放器状态:", nil),(long)self.playerView.playerViewState);
//        if (self.playerView && [self.playerView getPopLayerIsHidden] == YES){
//            [self.playerView resume];
//        }
//    }
   
}

- (void)resignActive{
//    if (self.isPresent) {
//        self.isBecome = YES;
//    }
    
    if (_playerView &&  self.playerView.playerViewState == AVPStatusStarted){
        [self.playerView pause];
    }
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
        _playerView.circlePlay = YES;
        [_playerView setDelegate:self];
        [_playerView setAutoPlay:YES];
        
        [_playerView setPrintLog:YES];
        _playerView.controlView.topView.hidden = YES;
        _playerView.isScreenLocked = false;
        _playerView.fixedPortrait = false;
    
    }
    return _playerView;
}

// MARK: - tableview 的 headerview
- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    _headerView.backgroundColor = [UIColor whiteColor];
}

// MARK: - tableview
- (void)makeTableView {
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - 50) style:UITableViewStylePlain];
    
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
    _faceImageView.image = Image(@"lesson_img");
    [_headerView addSubview:_faceImageView];
    
    _courseContentView = [[CourseContentView alloc] initWithFrame:CGRectMake(0, _faceImageView.bottom, MainScreenWidth, 86 + 4)];
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
}

// MARK: - 底部视图(咨询、加入购物车、加入学习)
- (void)makeDownView {
    _courseDownView = [[CourseDownView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT) isRecord:YES];
    _courseDownView.delegate = self;
    [self.view addSubview:_courseDownView];
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
                if (i == 0) {
                    self.introButton = btn;
                } else if (i == 1) {
                    self.courseButton = btn;
                } else if (i == 2) {
                    self.commentButton = btn;
                }
                [_bg addSubview:btn];
            }
            self.introButton.selected = YES;
            
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, MainScreenWidth, 1)];
            grayLine.backgroundColor = EdlineV5_Color.fengeLineColor;
            [_bg addSubview:grayLine];
            
            self.blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MainScreenWidth / 5.0, 2)];
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
            _courseListVC.cellTabelCanScroll = weakself.canScrollAfterVideoPlay;
            _courseListVC.videoInfoDict = _dataSource;
            _courseListVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
            [weakself.mainScroll addSubview:weakself.courseListVC.view];
            [weakself addChildViewController:weakself.courseListVC];
//            [self addBlockCategory:_courseListVC];
        } else {
            _courseListVC.cellTabelCanScroll = weakself.canScrollAfterVideoPlay;
            _courseListVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
            _courseListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
        }
        
        if (_recordVC == nil) {
            _recordVC = [[CourseCommentListVC alloc] init];
            _recordVC.tabelHeight = sectionHeight - 47;
            _recordVC.detailVC = weakself;
            _recordVC.cellType = YES;
            _recordVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _recordVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
            [self.mainScroll addSubview:_recordVC.view];
            [self addChildViewController:_recordVC];
        } else {
            _recordVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _recordVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
            _recordVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
        }

        if (_commentVC == nil) {
            _commentVC = [[CourseCommentListVC alloc] init];
            _commentVC.tabelHeight = sectionHeight - 47;
            _commentVC.detailVC = weakself;
            _commentVC.cellType = NO;
            _commentVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _commentVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 47);
            [self.mainScroll addSubview:_commentVC.view];
            [self addChildViewController:_commentVC];
        } else {
            _commentVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _commentVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 47);
            _commentVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
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
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth, 0) animated:YES];
    } else if (sender == self.commentButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 2, 0) animated:YES];
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
            self.blueLineView.centerX = self.courseButton.centerX;
            self.courseButton.selected = YES;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
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
                        if ([vc isKindOfClass:[CourseListVC class]]) {
                            CourseListVC *vccomment = (CourseListVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.courseButton.selected) {
                        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
                            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
                            if (vccomment.cellType) {
                                // 笔记
                                vccomment.cellTabelCanScroll = YES;
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
//                    if (self.recordButton.selected) {
//                        if ([vc isKindOfClass:[Good_ClassNotesViewController class]]) {
//                            Good_ClassNotesViewController *vccomment = (Good_ClassNotesViewController *)vc;
//                            vccomment.cellTabelCanScroll = YES;
//                        }
//                    }
//                    if (self.questionButton.selected) {
//                        if ([vc isKindOfClass:[Good_ClassAskQuestionsViewController class]]) {
//                            Good_ClassAskQuestionsViewController *vccomment = (Good_ClassAskQuestionsViewController *)vc;
//                            vccomment.cellTabelCanScroll = YES;
//                        }
//                    }
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

// MARK: - 右边按钮点击事件(收藏、下载、分享)
- (void)rightButtonClick:(id)sender {
    
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WidthRatio,55 * HeightRatio,100 * WidthRatio,100 * HeightRatio)];
    moreView.frame = CGRectMake(MainScreenWidth - 120 * WidthRatio,55 * HeightRatio,100 * WidthRatio,100 * HeightRatio);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    NSArray *imageArray = @[@"ico_collect@3x",@"class_share",@"class_down"];
    NSArray *titleArray = @[@"+收藏",@"分享",@"下载"];
//    if ([_collectStr integerValue] == 1) {
//        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
//        titleArray = @[@"-收藏",@"分享",@"下载"];
//    }
    CGFloat ButtonW = 100 * WidthRatio;
    CGFloat ButtonH = 33 * HeightRatio;
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 * WidthRatio, ButtonH * i, ButtonW, ButtonH)];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        button.titleLabel.font = SYSTEMFONT(14);
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,20 * WidthRatio);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20 * WidthRatio, 0, 0);
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
    }
}

// MARK: - 更多按钮点击事件
- (void)moreButtonClick:(UIButton *)sender {
    
}

// MARK: - 更多视图背景图点击事件
- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
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
    CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
    vc.isComment = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getCourseInfo {
    if (SWNOTEmptyStr(_ID)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseInfo:_ID] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            NSLog(@"课程详情 = %@",responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _dataSource = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    [self setCourseInfoData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            NSLog(@"课程详情请求失败 = %@",error);
        }];
    }
}

- (void)setCourseInfoData {
    if (SWNOTEmptyDictionary(_dataSource)) {
        NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover"]];
        if ([faceUrlString containsString:@"http"]) {
            [_faceImageView sd_setImageWithURL:EdulineUrlString([_dataSource objectForKey:@"cover"]) placeholderImage:DefaultImage];
        } else {
            _faceImageView.image = DefaultImage;
        }
        [_courseContentView setCourseContentInfo:_dataSource showTitleOnly:YES];
//        _tableView.tableHeaderView = _headerView;
//        [self.tableView reloadData];
    }
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    if (![AppDelegate delegate]._allowRotation) {
        return;
    }
    if (isFullScreen) {
        _titleImage.hidden = YES;
        _playerView.controlView.topView.hidden = NO;
        _playerView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _headerView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _tableView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _tableView.contentOffset = CGPointMake(0, 0);
        [self tableViewCanNotScroll];
    } else {
        _titleImage.hidden = NO;
        _playerView.controlView.topView.hidden = YES;
        _playerView.frame = CGRectMake(0, 0, MainScreenWidth, FacePlayImageHeight);
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, FacePlayImageHeight + 90);
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - 50);
        [self tableViewCanScroll];
    }
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
//    self.isStatusHidden = isFullScreen;
//    [self refreshUIWhenScreenChanged:isFullScreen];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)playVideo:(CourseListModelFinal *)model cellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex {
//    http://v5.51eduline.com/test.php
    //https://hls.videocc.net/cf754ccb6d/c/cf754ccb6d0cb61da723e3a2000ec0df_1.m3u8
    [self.playerView playViewPrepareWithURL:EdulineUrlString(@"http://v5.51eduline.com/test.php")];
    [AppDelegate delegate]._allowRotation = YES;
    [self tableViewCanNotScroll];
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
//    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - self.headerView.height;
    [_tableView reloadData];
}

- (void)canTableScroll {
    _canScroll = YES;
    _canScrollAfterVideoPlay = YES;
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_UPHEIGHT;
    [_tableView reloadData];
}

@end
