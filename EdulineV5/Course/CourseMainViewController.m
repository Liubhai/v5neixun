//
//  CourseMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseMainViewController.h"
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
#import "CourseStudentListViewController.h"
#import "CourseTreeListViewController.h"
#import "CourseDetailPlayVC.h"
#import "LingquanViewController.h"
#import "InstitutionRootVC.h"
#import "TeacherMainPageVC.h"
#import "WkWebViewController.h"

//
#import "OrderViewController.h"
#import "ShopCarManagerVC.h"
#import <UShareUI/UShareUI.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <WechatOpenSDK/WXApi.h>
#import "V5_UserModel.h"
#import "AppDelegate.h"

#import "SharePosterViewController.h"

#import "CourseActivityView.h"
#import "GroupListPopViewController.h"
#import "GroupDetailViewController.h"

#define FaceImageHeight 207

@interface CourseMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,CourseTeacherAndOrganizationViewDelegate,CourseCouponViewDelegate,CourseDownViewDelegate,CourseListVCDelegate,CourseTreeListViewControllerDelegate,UMSocialShareMenuViewDelegate> {
    // 新增内容
    CGFloat sectionHeight;
    BOOL shouldLoad;
    
    // 活动倒计时
    NSInteger eventTime;
    NSTimer *eventTimer;
}

/**三大子页面*/
@property (strong, nonatomic) CourseIntroductionVC *courseIntroduce;
@property (strong, nonatomic) CourseListVC *courseListVC;
@property (strong, nonatomic) CourseTreeListViewController *courseTreeListVC;
@property (strong, nonatomic) CourseCommentListVC *commentVC;
@property (strong, nonatomic) CourseStudentListViewController *courseStudentListVC;

/**封面*/
@property (strong, nonatomic) UIImageView *faceImageView;

/** 活动板块儿 */
@property (strong, nonatomic) CourseActivityView *courseActivityView;

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

@property (strong, nonatomic) UIButton *zanButton;

@property (strong, nonatomic) UIButton *navBackButton;
@property (strong, nonatomic) UIButton *navZanButton;
@property (strong, nonatomic) UIButton *navShareButton;

@end

@implementation CourseMainViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (shouldLoad) {
        [self getCourseInfo];
        [self getShopCarCount];
    }
    shouldLoad = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2] isKindOfClass:[CourseDetailPlayVC class]]) {
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        [vcArray removeObjectAtIndex:self.navigationController.childViewControllers.count - 2];
        self.navigationController.viewControllers = [NSArray arrayWithArray:vcArray];
    }
    
    _isClassNew = YES;
    /// 新增内容
    self.canScroll = YES;
    self.canScrollAfterVideoPlay = YES;
    
    _tabClassArray = [NSMutableArray arrayWithArray:@[@"简介",@"目录",@"点评"]];
    if ([_courseType isEqualToString:@"4"]) {
        _tabClassArray = [NSMutableArray arrayWithArray:@[@"简介",@"目录",@"点评",@"学员"]];
    }
    
    self.canScroll = YES;
    _titleLabel.text = @"课程详情";
    _titleImage.backgroundColor = BasidColor;
    
    _zanButton = [[UIButton alloc] initWithFrame:CGRectMake(_rightButton.left - 44, _rightButton.top, 44, 44)];
    [_zanButton setImage:Image(@"nav_collect_nor") forState:0];
    [_zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_zanButton];
    
    _titleLabel.textColor = [UIColor whiteColor];
    
    [self makeHeaderView];
    [self makeSubViews];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_UPHEIGHT;
    [self makeTableView];
    [self.view bringSubviewToFront:_titleImage];
//    _titleImage.backgroundColor = [UIColor clearColor];
//    _titleLabel.hidden = YES;
    _lineTL.hidden = YES;
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"share_white_icon") forState:0];
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _titleImage.alpha = 0;
    [self makeDownView];
    [self getCourseInfo];
    [self getShopCarCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCourseDetailPageData) name:@"reloadCourseDetailPage" object:nil];
}

// MARK: - 登录后页面刷新
- (void)reloadCourseDetailPageData {
    [self getCourseInfo];
    [self getShopCarCount];
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
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, FaceImageHeight)];
    _faceImageView.image = DefaultImage;
    _faceImageView.userInteractionEnabled = YES;
    [_headerView addSubview:_faceImageView];
    
    _courseActivityView = [[CourseActivityView alloc] initWithFrame:CGRectMake(0, _faceImageView.height - 45, MainScreenWidth, 45)];
    [_headerView addSubview:_courseActivityView];
    _courseActivityView.hidden = YES;
    
    _navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _navBackButton.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    [_navBackButton setImage:Image(@"course_back_icon") forState:0];
    [_navBackButton addTarget:self action:@selector(navLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_faceImageView addSubview:_navBackButton];
    
    _navShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _navShareButton.frame = CGRectMake(MainScreenWidth-52, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 53, 44);
    [_navShareButton setImage:Image(@"course_share_icon") forState:0];
    [_navShareButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_faceImageView addSubview:_navShareButton];
    
    _navZanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _navZanButton.frame = CGRectMake(_navShareButton.left - 44, _navShareButton.top, 44, 44);
    [_navZanButton setImage:Image(@"course_collect_nor") forState:0];
    [_navZanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_faceImageView addSubview:_navZanButton];
    
    _courseContentView = [[CourseContentView alloc] initWithFrame:CGRectMake(0, _faceImageView.bottom, MainScreenWidth, 86 + 4)];
    [_headerView addSubview:_courseContentView];
    
    /**优惠卷*/
    _couponContentView = [[CourseCouponView alloc] initWithFrame:CGRectMake(0, _courseContentView.bottom, MainScreenWidth, 0)];
    _couponContentView.delegate = self;
    [_headerView addSubview:_couponContentView];
    /**机构讲师*/
    if (_teachersHeaderBackView == nil) {
        _teachersHeaderBackView = [[CourseTeacherAndOrganizationView alloc] initWithFrame:CGRectMake(0, _couponContentView.bottom, MainScreenWidth, 59)];
        [_headerView addSubview:_teachersHeaderBackView];
        
        [_teachersHeaderBackView setHeight:0];
        _teachersHeaderBackView.hidden = YES;
        _teachersHeaderBackView.delegate = self;
    }
    [_headerView setHeight:_teachersHeaderBackView.bottom];
}

// MARK: - 底部视图(咨询、加入购物车、加入学习)
- (void)makeDownView {
    _courseDownView = [[CourseDownView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT) isRecord:NO];
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
    __weak CourseMainViewController *weakself = self;
    if (weakself.bg == nil) {
        weakself.bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        weakself.bg.backgroundColor = [UIColor whiteColor];
    } else {
        weakself.bg.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
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
                } else if (i == 3) {
                    self.recordButton = btn;
                }
                [weakself.bg addSubview:btn];
            }
            
            // 添加试看标志
            self.seeFreeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 14)];
            self.seeFreeIcon.image = Image(@"see_icon");
            if (self.courseButton) {
                [self.seeFreeIcon setOrigin:CGPointMake(self.courseButton.width / 2.0 + 17, self.courseButton.height / 2.0 - 14)];
                self.seeFreeIcon.hidden = YES;
                [self.courseButton addSubview:self.seeFreeIcon];
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

        if (weakself.courseIntroduce == nil) {
            weakself.courseIntroduce = [[CourseIntroductionVC alloc] init];
            weakself.courseIntroduce.courseId = weakself.ID;
            weakself.courseIntroduce.dataSource = weakself.dataSource;
            weakself.courseIntroduce.tabelHeight = sectionHeight - 47;
            weakself.courseIntroduce.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            weakself.courseIntroduce.vc = weakself;
            weakself.courseIntroduce.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
            [weakself.mainScroll addSubview:weakself.courseIntroduce.view];
            [weakself addChildViewController:weakself.courseIntroduce];
        } else {
            weakself.courseIntroduce.dataSource = weakself.dataSource;
            weakself.courseIntroduce.tabelHeight = sectionHeight - 47;
            weakself.courseIntroduce.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            weakself.courseIntroduce.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
            [weakself.courseIntroduce changeMainScrollViewHeight:sectionHeight - 47];
        }

        if ([_courseType isEqualToString:@"4"]) {
            if (_courseTreeListVC == nil) {
                _courseTreeListVC = [[CourseTreeListViewController alloc] init];
                _courseTreeListVC.courseId = weakself.ID;
                _courseTreeListVC.courselayer = weakself.courselayer;
                _courseTreeListVC.isMainPage = YES;
                _courseTreeListVC.sid = weakself.sid;
                _courseTreeListVC.tabelHeight = sectionHeight - 47;
                _courseTreeListVC.vc = weakself;
                _courseTreeListVC.delegate = weakself;
                _courseTreeListVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
                _courseTreeListVC.videoInfoDict = weakself.dataSource;
                _courseTreeListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                [weakself.mainScroll addSubview:weakself.courseTreeListVC.view];
                [weakself addChildViewController:weakself.courseTreeListVC];
            } else {
                _courseTreeListVC.courseId = weakself.ID;
                _courseTreeListVC.courselayer = weakself.courselayer;
                _courseTreeListVC.isMainPage = YES;
                _courseTreeListVC.sid = weakself.sid;
                _courseTreeListVC.tabelHeight = sectionHeight - 47;
                _courseTreeListVC.vc = weakself;
                _courseTreeListVC.delegate = weakself;
                _courseTreeListVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
                _courseTreeListVC.videoInfoDict = weakself.dataSource;
                _courseTreeListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                _courseTreeListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseTreeListVC getClassCourseList];
            }
        } else {
            if (_courseListVC == nil) {
                _courseListVC = [[CourseListVC alloc] init];
                _courseListVC.courseId = weakself.ID;
                _courseListVC.courselayer = weakself.courselayer;
                _courseListVC.isMainPage = YES;
                _courseListVC.isClassCourse = weakself.isClassNew;
                _courseListVC.sid = weakself.sid;
                _courseListVC.tabelHeight = sectionHeight - 47;
                _courseListVC.vc = weakself;
                _courseListVC.delegate = weakself;
                _courseListVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
                _courseListVC.videoInfoDict = weakself.dataSource;
                _courseListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                [weakself.mainScroll addSubview:weakself.courseListVC.view];
                [weakself addChildViewController:weakself.courseListVC];
            } else {
                _courseListVC.courseId = weakself.ID;
                _courseListVC.courselayer = weakself.courselayer;
                _courseListVC.isMainPage = YES;
                _courseListVC.isClassCourse = weakself.isClassNew;
                _courseListVC.sid = weakself.sid;
                _courseListVC.tabelHeight = sectionHeight - 47;
                _courseListVC.vc = weakself;
                _courseListVC.delegate = weakself;
                _courseListVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
                _courseListVC.videoInfoDict = weakself.dataSource;
                _courseListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                _courseListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseListVC getCourseListData];
            }
        }

        if (_commentVC == nil) {
            _commentVC = [[CourseCommentListVC alloc] init];
            _commentVC.courseId = weakself.ID;
            _commentVC.tabelHeight = sectionHeight - 47;
            _commentVC.vc = weakself;
            _commentVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            _commentVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 47);
            [weakself.mainScroll addSubview:weakself.commentVC.view];
            [weakself addChildViewController:weakself.commentVC];
        } else {
            _commentVC.courseId = weakself.ID;
            _commentVC.tabelHeight = sectionHeight - 47;
            _commentVC.vc = weakself;
            _commentVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            _commentVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 47);
            _commentVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
            [_commentVC getCourseCommentList];
        }

        if ([_courseType isEqualToString:@"4"]) {
            if (_courseStudentListVC == nil) {
                _courseStudentListVC = [[CourseStudentListViewController alloc] init];
                _courseStudentListVC.courseId = weakself.ID;
                _courseStudentListVC.tabelHeight = sectionHeight - 47;
                _courseStudentListVC.vc = weakself;
                _courseStudentListVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
                _courseStudentListVC.view.frame = CGRectMake(MainScreenWidth*3,0, MainScreenWidth, sectionHeight - 47);
                [weakself.mainScroll addSubview:weakself.courseStudentListVC.view];
                [weakself addChildViewController:weakself.courseStudentListVC];
            } else {
                _courseStudentListVC.courseId = weakself.ID;
                _courseStudentListVC.tabelHeight = sectionHeight - 47;
                _courseStudentListVC.vc = weakself;
                _courseStudentListVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
                _courseStudentListVC.view.frame = CGRectMake(MainScreenWidth*3,0, MainScreenWidth, sectionHeight - 47);
                _courseStudentListVC.collectionView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseStudentListVC getStudentListInfo];
            }
        }
    }
    if (SWNOTEmptyDictionary(weakself.dataSource)) {
        NSString *audition_stat = [NSString stringWithFormat:@"%@",weakself.dataSource[@"audition_stat"]];
        self.seeFreeIcon.hidden = [audition_stat boolValue] ? NO : YES;
        if ([[weakself.dataSource objectForKey:@"is_buy"] boolValue]) {
            self.seeFreeIcon.hidden = YES;
        }
    }
    return weakself.bg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if ([_courselayer isEqualToString:@"1"]) {
        CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
        vc.courselayer = _courselayer;
        vc.ID = _ID;
        vc.isLive = _isLive;
        vc.courseType = _courseType;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
//            _titleImage.backgroundColor = EdlineV5_Color.themeColor;
//            _titleLabel.hidden = NO;
            _titleImage.alpha = 1;
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.courseButton.selected) {
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
                    if (self.introButton.selected) {
                        if ([vc isKindOfClass:[CourseIntroductionVC class]]) {
                            CourseIntroductionVC *vccomment = (CourseIntroductionVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.commentButton.selected) {
                        if ([vc isKindOfClass:[CourseCommentListVC class]]) {
                            CourseCommentListVC *vccomment = (CourseCommentListVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.recordButton.selected) {
                        if ([vc isKindOfClass:[CourseStudentListViewController class]]) {
                            CourseStudentListViewController *vccomment = (CourseStudentListViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
//                    if (self.questionButton.selected) {
//                        if ([vc isKindOfClass:[Good_ClassAskQuestionsViewController class]]) {
//                            Good_ClassAskQuestionsViewController *vccomment = (Good_ClassAskQuestionsViewController *)vc;
//                            vccomment.cellTabelCanScroll = YES;
//                        }
//                    }
                }
            }
        }else{
//            _titleImage.backgroundColor = [UIColor clearColor];
//            _titleLabel.hidden = YES;
            _titleImage.alpha = 0;
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
//    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
//        return;
//    }
    InstitutionRootVC *vc = [[InstitutionRootVC alloc] init];
    vc.institutionId = [NSString stringWithFormat:@"%@",_dataSource[@"mhm_info"][@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 讲师机构点击事件(机构)
- (void)jumpToTeacher:(NSDictionary *)teacherInfoDict tapTag:(NSInteger)viewTag {
//    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
//        return;
//    }
    TeacherMainPageVC *vc = [[TeacherMainPageVC alloc] init];
    vc.teacherId = [NSString stringWithFormat:@"%@",teacherInfoDict[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 优惠卷点击事件
- (void)jumpToCouponsVC {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    LingquanViewController *vc = [[LingquanViewController alloc] init];
//    vc.mhm_id = [NSString stringWithFormat:@"%@",[[_dataSource objectForKey:@"mhm_info"] objectForKey:@"id"]];
    vc.courseId = _ID;
    vc.getOrUse = YES;
    vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}

// MARK: - 返回按钮点击事件
- (void)navLeftButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
                    [_navZanButton setImage:Image(@"course_collect_nor") forState:0];
                    [_zanButton setImage:Image(@"nav_collect_nor") forState:0];
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
                    [_navZanButton setImage:Image(@"course_collect_pre") forState:0];
                    [_zanButton setImage:Image(@"nav_collect_pre") forState:0];
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
//    dispatch_sync(dispatch_get_main_queue(), ^{
//
//    });
    
//    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
//    allWindowView.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.2 alpha:0.5];
//    allWindowView.layer.masksToBounds =YES;
//    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
//    //获取当前UIWindow 并添加一个视图
//    UIApplication *app = [UIApplication sharedApplication];
//    [app.keyWindow addSubview:allWindowView];
//    _allWindowView = allWindowView;
//
//    NSArray *titleArray = @[@"收藏",@"分享"];
//    if ([[NSString stringWithFormat:@"%@",_dataSource[@"collected"]] boolValue]) {
//        titleArray = @[@"已收藏",@"分享"];
//    }
//
//    CGFloat ButtonW = 78;
//    CGFloat ButtonH = 36;
//
//    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 78 - 15,MACRO_UI_UPHEIGHT,78,ButtonH * titleArray.count)];
//    moreView.backgroundColor = [UIColor whiteColor];
//    moreView.layer.masksToBounds = YES;
//    [allWindowView addSubview:moreView];
//
//    for (int i = 0 ; i < 2 ; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, ButtonH * i, ButtonW, ButtonH)];
//        button.tag = i;
//        [button setTitle:titleArray[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
//        button.titleLabel.font = SYSTEMFONT(14);
//        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [moreView addSubview:button];
//    }
}

// MARK: - 更多按钮点击事件
- (void)moreButtonClick:(UIButton *)sender {
    [_allWindowView removeFromSuperview];
    if (sender.tag == 1) {
        //显示分享面板
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
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
    } else if (sender.tag == 0) {
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
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                [self showHudInView:self.view showHint:@"网络请求失败"];
            }];
        }
    }
}

// MARK: - 更多视图背景图点击事件
- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

// MARK: - 底部按钮点击事件
- (void)jumpServiceVC:(CourseDownView *)downView {
    if (SWNOTEmptyDictionary(_dataSource)) {
        if (![[NSString stringWithFormat:@"%@",_dataSource[@"online_consult"]] containsString:@"http"]) {
            NSURL *chatUrl = [NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[NSString stringWithFormat:@"%@",_dataSource[@"online_consult"]]]];
            [[UIApplication sharedApplication] openURL:chatUrl];
        } else {
            WkWebViewController *vc = [[WkWebViewController alloc] init];
            vc.titleString = @"在线咨询";
            vc.urlString = [NSString stringWithFormat:@"%@",_dataSource[@"online_consult"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)jumpToShopCarVC:(CourseDownView *)downView {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    ShopCarManagerVC *vc = [[ShopCarManagerVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)joinShopCarEvent:(CourseDownView *)downView {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if (SWNOTEmptyStr(_ID)) {
        [Net_API requestPOSTWithURLStr:[Net_Path addCourseIntoShopcar] WithAuthorization:nil paramDic:@{@"course_id":_ID} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                [self getShopCarCount];
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络超时"];
        }];
    }
}

- (void)joinStudyEvent:(CourseDownView *)downView {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if (SWNOTEmptyDictionary(_dataSource)) {
        if ([[_dataSource objectForKey:@"is_buy"] boolValue]) {
            CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
            vc.ID = _ID;
            vc.courselayer = _courselayer;
            vc.isLive = _isLive;
            vc.courseType = _courseType;
            if ([_dataSource objectForKey:@"recent_learn"]) {
                if (SWNOTEmptyDictionary([_dataSource objectForKey:@"recent_learn"])) {
                    vc.recent_learn_Source = [NSDictionary dictionaryWithDictionary:[_dataSource objectForKey:@"recent_learn"]];
                    vc.shouldContinueLearn = YES;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSString *priceCount = [NSString stringWithFormat:@"%@",_dataSource[@"price"]];
            NSString *user_price = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"user_price"]];
            if ([priceCount isEqualToString:@"0.00"] || [priceCount isEqualToString:@"0.0"] || [priceCount isEqualToString:@"0"] || ([[V5_UserModel vipStatus] isEqualToString:@"1"] && ([user_price isEqualToString:@"0.00"] || [user_price isEqualToString:@"0.0"] || [user_price isEqualToString:@"0"]))) {
                // 免费课程
                [Net_API requestPOSTWithURLStr:[Net_Path joinFreeCourseNet] WithAuthorization:nil paramDic:@{@"course_id":_ID} finish:^(id  _Nonnull responseObject) {
                    if (SWNOTEmptyDictionary(responseObject)) {
                        [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                        if ([[responseObject objectForKey:@"code"] integerValue]) {
                            [self getCourseInfo];
                        }
                    }
                } enError:^(NSError * _Nonnull error) {
                    [self showHudInView:self.view showHint:@"网络超时"];
                }];
            } else {
                OrderViewController *vc = [[OrderViewController alloc] init];
                vc.orderTypeString = @"course";
                vc.orderId = _ID;
                // 这里需要判断下有没有活动
                    if (SWNOTEmptyDictionary(_dataSource[@"promotion"])) {
                        NSDictionary *promotion = [NSDictionary dictionaryWithDictionary:_dataSource[@"promotion"]];
                        NSString *promotionType = [NSString stringWithFormat:@"%@",promotion[@"type"]];
                        /** 活动类型【1：限时折扣；2：限时秒杀；3：砍价；4：拼团；】 */
                        if ([promotionType isEqualToString:@"1"] || [promotionType isEqualToString:@"2"]) {

                        } else if ([promotionType isEqualToString:@"3"]) {

                        } else if ([promotionType isEqualToString:@"4"]) {
                            // 拼团
                            if (SWNOTEmptyDictionary(_dataSource[@"pintuan_data"])) {
                                NSString *pintuanStatus = [NSString stringWithFormat:@"%@",_dataSource[@"pintuan_data"][@"status"]];

                                /** 团状态【0：开团待审(未支付成功)；1：开团成功；2：拼团成功(应该是已经购买了)；3:拼团失败】 */
                                if ([pintuanStatus isEqualToString:@"1"] || [pintuanStatus isEqualToString:@"2"]) {
                                } else if ([pintuanStatus isEqualToString:@"0"]) {
                                    vc.ignoreActivity = YES;
                                } else {
                                }
                            } else {
                            }
                        }
                    }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)kanJiaAndPinTuan:(CourseDownView *)downView {
    // 活动
    if (SWNOTEmptyDictionary(_dataSource[@"promotion"])) {
        NSDictionary *promotion = [NSDictionary dictionaryWithDictionary:_dataSource[@"promotion"]];
        NSString *promotionType = [NSString stringWithFormat:@"%@",promotion[@"type"]];
        /** 活动类型【1：限时折扣；2：限时秒杀；3：砍价；4：拼团；】 */
        if ([promotionType isEqualToString:@"1"] || [promotionType isEqualToString:@"2"]) {
            
        } else if ([promotionType isEqualToString:@"3"]) {
            // 砍价
            GroupDetailViewController *vc = [[GroupDetailViewController alloc] init];
            /** 活动类型【1：限时折扣；2：限时秒杀；3：砍价；4：拼团；】 */
            vc.activityType = @"3";
            vc.activityId = [NSString stringWithFormat:@"%@",_dataSource[@"promotion"][@"id"]];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([promotionType isEqualToString:@"4"]) {
            // 拼团
            if (SWNOTEmptyDictionary(_dataSource[@"pintuan_data"])) {
                NSString *pintuanStatus = [NSString stringWithFormat:@"%@",_dataSource[@"pintuan_data"][@"status"]];
                
                /** 团状态【0：开团待审(未支付成功)；1：开团成功；2：拼团成功(应该是已经购买了)；3:拼团失败】 */
                if ([pintuanStatus isEqualToString:@"1"] || [pintuanStatus isEqualToString:@"2"]) {
                    // 进入拼团详情
                    GroupDetailViewController *vc = [[GroupDetailViewController alloc] init];
                    /** 活动类型【1：限时折扣；2：限时秒杀；3：砍价；4：拼团；】 */
                    vc.activityType = @"4";
                    vc.activityId = [NSString stringWithFormat:@"%@",_dataSource[@"pintuan_data"][@"id"]];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([pintuanStatus isEqualToString:@"0"]) {
                    [self showHudInView:self.view showHint:@"已入团成功，请确认支付"];
                } else {
                    // 弹框
                    [self showGroupList];
                }
            } else {
                // 弹框
                [self showGroupList];
            }
        }
    }
}

- (void)jumpToCommentVC {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        return;
    }
    CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
    vc.isComment = NO;
    vc.courseId = _ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playVideo:(CourseListModelFinal *)model cellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex currentCell:(nonnull CourseCatalogCell *)cell{
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
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
        return;
    }
    CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
    vc.ID = _ID;
    vc.courselayer = _courselayer;
    vc.currentHourseId = [NSString stringWithFormat:@"%@",cell.listFinalModel.model.classHourId];
    vc.isLive = _isLive;
    vc.courseType = _courseType;
    vc.currentPlayModel = cell.listFinalModel.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)newClassCourseCellDidSelected:(CourseListModel *)model indexpath:(nonnull NSIndexPath *)indexpath {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if (model.audition <= 0 && !model.is_buy) {
        if ([model.price floatValue] > 0) {
            OrderViewController *vc = [[OrderViewController alloc] init];
            vc.orderTypeString = [_courseType isEqualToString:@"2"] ? @"liveHourse" : @"courseHourse";
            vc.orderId = model.classHourId;
            [self.navigationController pushViewController:vc animated:YES];
            [self showHudInView:self.view showHint:@"需解锁该课时或者该课程"];
        } else {
            [self showHudInView:self.view showHint:@"需解锁该课程"];
        }
        return;
    }
    CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
    vc.ID = _ID;
    vc.courselayer = _courselayer;
    vc.currentHourseId = [NSString stringWithFormat:@"%@",model.classHourId];
    vc.isLive = _isLive;
    vc.courseType = _courseType;
    vc.currentPlayModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getCourseInfo {
    if (SWNOTEmptyStr(_ID)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseInfo:_ID] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _dataSource = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    _courselayer = [NSString stringWithFormat:@"%@",_dataSource[@"section_level"]];
                    [self setCourseInfoData];
                } else {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
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
        
        __weak typeof(self) weakself = self;
        
        if (SWNOTEmptyDictionary(_dataSource[@"promotion"])) {
            _courseActivityView.hidden = NO;
            [_courseActivityView setActivityInfo:weakself.dataSource];
            
            NSString *end_countdown = [NSString stringWithFormat:@"%@",[weakself.dataSource[@"promotion"] objectForKey:@"end_countdown"]];
            NSString *start_countdown = [NSString stringWithFormat:@"%@",[weakself.dataSource[@"promotion"] objectForKey:@"start_countdown"]];
            
            if ([[_dataSource[@"promotion"] objectForKey:@"running_status"] integerValue] == 1) {
                eventTime = [end_countdown integerValue];
                _courseActivityView.groupTimeTipLabel.text = @"距结束仅剩";
                [weakself.courseActivityView setDateInfo:eventTime];
            } else {
                eventTime = [start_countdown integerValue];
                _courseActivityView.groupTimeTipLabel.text = @"距开始还有";
                [_courseActivityView setDateInfo:eventTime];
            }
            if (eventTime>0) {
                [self startTimer];
            }
        } else {
            _courseActivityView.hidden = YES;
        }
        
        if ([[NSString stringWithFormat:@"%@",_dataSource[@"collected"]] boolValue]) {
            [_navZanButton setImage:Image(@"course_collect_pre") forState:0];
            [_zanButton setImage:Image(@"nav_collect_pre") forState:0];
        } else {
            [_navZanButton setImage:Image(@"course_collect_nor") forState:0];
            [_zanButton setImage:Image(@"nav_collect_nor") forState:0];
        }
        
        [_courseDownView setCOurseInfoData:_dataSource];
        [_courseContentView setCourseContentInfo:_dataSource showTitleOnly:NO];
        NSArray *coupon_Array = [NSArray arrayWithArray:_dataSource[@"recommend_coupon"]];
        NSString *coupon_count = [NSString stringWithFormat:@"%@",_dataSource[@"coupon_count"]];
        if (SWNOTEmptyArr(coupon_Array)) {
            [_couponContentView setHeight:52];
            _couponContentView.hidden = NO;
            [_couponContentView setCouponsListInfo:coupon_Array];
        } else {
            [_couponContentView setHeight:0];
            _couponContentView.hidden = YES;
        }
        [_teachersHeaderBackView setTop:_couponContentView.bottom];
        NSArray *teacherArray = [NSArray arrayWithArray:_dataSource[@"teachers"]];
        if (SWNOTEmptyDictionary([_dataSource objectForKey:@"mhm_info"]) || SWNOTEmptyArr(teacherArray)) {
            [_teachersHeaderBackView setHeight:59];
            [_headerView setHeight:_teachersHeaderBackView.bottom];
        }
        [_teachersHeaderBackView setTeacherAndOrganizationData:[_dataSource objectForKey:@"mhm_info"] teacherInfo:[_dataSource objectForKey:@"teachers"]];
        _tableView.tableHeaderView = _headerView;
        [self.tableView reloadData];
    }
}

// MARK: - 获取购物车数量
- (void)getShopCarCount {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userShopCarCountNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _courseDownView.shopCountLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([_courseDownView.shopCountLabel.text integerValue]>0) {
                    _courseDownView.shopCountLabel.hidden = NO;
                } else {
                    _courseDownView.shopCountLabel.hidden = YES;
                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

// MARK: - 显示团购列表弹框
- (void)showGroupList {
    GroupListPopViewController *vc = [[GroupListPopViewController alloc] init];
    vc.courseId = _ID;
    vc.videoDataSource = [NSDictionary dictionaryWithDictionary:_dataSource];
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}

- (void)startTimer {
    __weak typeof(self) weakself = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakself];
    [NSObject cancelPreviousPerformRequestsWithTarget:weakself selector:@selector(startTimer) object:nil];
    eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
}

// MARK: - 活动倒计时
- (void)eventTimerDown {
    eventTime--;
    if (eventTime<=0) {
        [self getCourseInfo];
        [eventTimer invalidate];
        eventTimer = nil;
    } else {
        [self.courseActivityView setDateInfo:eventTime];
    }
}

- (void)dealloc {
    if (eventTimer) {
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

@end
