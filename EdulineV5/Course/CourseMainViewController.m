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
#import "V5_UserModel.h"
#import "AppDelegate.h"

#define FaceImageHeight 207

@interface CourseMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,CourseTeacherAndOrganizationViewDelegate,CourseCouponViewDelegate,CourseDownViewDelegate,CourseListVCDelegate,CourseTreeListViewControllerDelegate> {
    // 新增内容
    CGFloat sectionHeight;
    BOOL shouldLoad;
}

/**三大子页面*/
@property (strong, nonatomic) CourseIntroductionVC *courseIntroduce;
@property (strong, nonatomic) CourseListVC *courseListVC;
@property (strong, nonatomic) CourseTreeListViewController *courseTreeListVC;
@property (strong, nonatomic) CourseCommentListVC *commentVC;
@property (strong, nonatomic) CourseStudentListViewController *courseStudentListVC;

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
    
    _titleLabel.textColor = [UIColor whiteColor];
    
    [self makeHeaderView];
    [self makeSubViews];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_UPHEIGHT;
    [self makeTableView];
    [self.view bringSubviewToFront:_titleImage];
    _titleImage.backgroundColor = [UIColor clearColor];
    _titleLabel.hidden = YES;
    _lineTL.hidden = YES;
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"nav_more_white") forState:0];
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    [self makeDownView];
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
    [_headerView addSubview:_faceImageView];
    
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
                } else if (i == 3) {
                    self.recordButton = btn;
                }
                [_bg addSubview:btn];
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
        
        if (_courseIntroduce == nil) {
            _courseIntroduce = [[CourseIntroductionVC alloc] init];
            _courseIntroduce.courseId = _ID;
            _courseIntroduce.dataSource = _dataSource;
            _courseIntroduce.tabelHeight = sectionHeight - 47;
            _courseIntroduce.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _courseIntroduce.vc = self;
            _courseIntroduce.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
            [self.mainScroll addSubview:_courseIntroduce.view];
            [self addChildViewController:_courseIntroduce];
        } else {
            _courseIntroduce.dataSource = _dataSource;
            _courseIntroduce.tabelHeight = sectionHeight - 47;
            _courseIntroduce.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _courseIntroduce.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 47);
            [_courseIntroduce changeMainScrollViewHeight:sectionHeight - 47];
        }
        
        if ([_courseType isEqualToString:@"4"]) {
            if (_courseTreeListVC == nil) {
                _courseTreeListVC = [[CourseTreeListViewController alloc] init];
                _courseTreeListVC.courseId = _ID;
                _courseTreeListVC.courselayer = _courselayer;
                _courseTreeListVC.isMainPage = YES;
                _courseTreeListVC.sid = _sid;
                _courseTreeListVC.tabelHeight = sectionHeight - 47;
                _courseTreeListVC.vc = self;
                _courseTreeListVC.delegate = self;
                _courseTreeListVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
                _courseTreeListVC.videoInfoDict = _dataSource;
                _courseTreeListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                [self.mainScroll addSubview:_courseTreeListVC.view];
                [self addChildViewController:_courseTreeListVC];
            } else {
                _courseTreeListVC.courseId = _ID;
                _courseTreeListVC.courselayer = _courselayer;
                _courseTreeListVC.isMainPage = YES;
                _courseTreeListVC.sid = _sid;
                _courseTreeListVC.tabelHeight = sectionHeight - 47;
                _courseTreeListVC.vc = self;
                _courseTreeListVC.delegate = self;
                _courseTreeListVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
                _courseTreeListVC.videoInfoDict = _dataSource;
                _courseTreeListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                _courseTreeListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseTreeListVC getClassCourseList];
            }
        } else {
            if (_courseListVC == nil) {
                _courseListVC = [[CourseListVC alloc] init];
                _courseListVC.courseId = _ID;
                _courseListVC.courselayer = _courselayer;
                _courseListVC.isMainPage = YES;
                _courseListVC.isClassCourse = _isClassNew;
                _courseListVC.sid = _sid;
                _courseListVC.tabelHeight = sectionHeight - 47;
                _courseListVC.vc = self;
                _courseListVC.delegate = self;
                _courseListVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
                _courseListVC.videoInfoDict = _dataSource;
                _courseListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                [self.mainScroll addSubview:_courseListVC.view];
                [self addChildViewController:_courseListVC];
            } else {
                _courseListVC.courseId = _ID;
                _courseListVC.courselayer = _courselayer;
                _courseListVC.isMainPage = YES;
                _courseListVC.isClassCourse = _isClassNew;
                _courseListVC.sid = _sid;
                _courseListVC.tabelHeight = sectionHeight - 47;
                _courseListVC.vc = self;
                _courseListVC.delegate = self;
                _courseListVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
                _courseListVC.videoInfoDict = _dataSource;
                _courseListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 47);
                _courseListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseListVC getCourseListData];
            }
        }
        
        if (_commentVC == nil) {
            _commentVC = [[CourseCommentListVC alloc] init];
            _commentVC.courseId = _ID;
            _commentVC.tabelHeight = sectionHeight - 47;
            _commentVC.vc = self;
            _commentVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _commentVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 47);
            [self.mainScroll addSubview:_commentVC.view];
            [self addChildViewController:_commentVC];
        } else {
            _commentVC.courseId = _ID;
            _commentVC.tabelHeight = sectionHeight - 47;
            _commentVC.vc = self;
            _commentVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _commentVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 47);
            _commentVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
            [_commentVC getCourseCommentList];
        }
        
        if ([_courseType isEqualToString:@"4"]) {
            if (_courseStudentListVC == nil) {
                _courseStudentListVC = [[CourseStudentListViewController alloc] init];
                _courseStudentListVC.courseId = _ID;
                _courseStudentListVC.tabelHeight = sectionHeight - 47;
                _courseStudentListVC.vc = self;
                _courseStudentListVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
                _courseStudentListVC.view.frame = CGRectMake(MainScreenWidth*3,0, MainScreenWidth, sectionHeight - 47);
                [self.mainScroll addSubview:_courseStudentListVC.view];
                [self addChildViewController:_courseStudentListVC];
            } else {
                _courseStudentListVC.courseId = _ID;
                _courseStudentListVC.tabelHeight = sectionHeight - 47;
                _courseStudentListVC.vc = self;
                _courseStudentListVC.cellTabelCanScroll = !_canScrollAfterVideoPlay;
                _courseStudentListVC.view.frame = CGRectMake(MainScreenWidth*3,0, MainScreenWidth, sectionHeight - 47);
                _courseStudentListVC.collectionView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 47);
                [_courseStudentListVC getStudentListInfo];
            }
        }
        
    }
    return _bg;
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
            _titleImage.backgroundColor = EdlineV5_Color.themeColor;
            _titleLabel.hidden = NO;
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

// MARK: - 右边按钮点击事件(收藏、下载、分享)
- (void)rightButtonClick:(id)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    NSArray *titleArray = @[@"收藏",@"分享"];
    if ([[NSString stringWithFormat:@"%@",_dataSource[@"collected"]] boolValue]) {
        titleArray = @[@"已收藏",@"分享"];
    }
    
    CGFloat ButtonW = 78;
    CGFloat ButtonH = 36;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 78 - 15,MACRO_UI_UPHEIGHT,78,ButtonH * titleArray.count)];
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, ButtonH * i, ButtonW, ButtonH)];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        button.titleLabel.font = SYSTEMFONT(14);
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
    }
    
//    NSArray *titleArray = @[@"下载",@"收藏",@"分享"];
//    if ([[NSString stringWithFormat:@"%@",_dataSource[@"collected"]] boolValue]) {
//        titleArray = @[@"下载",@"已收藏",@"分享"];
//    }
//
//    CGFloat ButtonW = 78;
//    CGFloat ButtonH = 36;
//    for (int i = 0 ; i < 3 ; i ++) {
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
//    WkWebViewController *vc = [[WkWebViewController alloc] init];
//    vc.titleString = @"客服";
//    vc.agreementKey = @"kehu";
//    [self.navigationController pushViewController:vc animated:YES];
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
            if ([priceCount isEqualToString:@"0.00"] || [priceCount isEqualToString:@"0.0"] || [priceCount isEqualToString:@"0"]) {
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
                [self.navigationController pushViewController:vc animated:YES];
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
            vc.orderTypeString = @"courseHourse";
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
            vc.orderTypeString = @"courseHourse";
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
            NSLog(@"课程详情 = %@",responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _dataSource = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    _courselayer = [NSString stringWithFormat:@"%@",_dataSource[@"section_level"]];
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
        NSString *faceUrlString = [NSString stringWithFormat:@"%@",[_dataSource objectForKey:@"cover_url"]];
        if ([faceUrlString containsString:@"http"]) {
            [_faceImageView sd_setImageWithURL:EdulineUrlString([_dataSource objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
        } else {
            _faceImageView.image = DefaultImage;
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
@end
