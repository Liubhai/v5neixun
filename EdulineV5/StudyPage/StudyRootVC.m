//
//  StudyRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyRootVC.h"
#import "StudyTimeCell.h"
#import "StudyLatestCell.h"
#import "StudyCourseCell.h"
#import "EmptyCell.h"
#import "V5_Constant.h"
#import "JoinCourseVC.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"
#import "Net_Path.h"
#import "LearnRecordVC.h"
#import "CourseMainViewController.h"
#import "CourseDetailPlayVC.h"

#import "NewStudyTimeView.h"
#import "StudyTypeCourseListViewController.h"

#import "FaceVerifyViewController.h"
#import "MyCertificateListVC.h"

@interface StudyRootVC ()<UITableViewDelegate, UITableViewDataSource,StudyLatestCellDelegate, UIScrollViewDelegate> {
    NSInteger currentCourseType;
    NSString *dataType;// add加入的优先 learn学习优先
    BOOL emptyData;
    BOOL shouldLoad;
    CGFloat sectionHeight;
}

@property (strong, nonatomic) StudyTypeCourseListViewController *dianboVC;
@property (strong, nonatomic) StudyTypeCourseListViewController *zhiboVC;
@property (strong, nonatomic) StudyTypeCourseListViewController *banjiVC;
@property (strong, nonatomic) StudyTypeCourseListViewController *mianshouVC;

@property (nonatomic, strong) UIView *bg;
@property (nonatomic, retain) UIScrollView *mainScroll;

/**子视图个数*/
@property (strong, nonatomic) NSMutableArray *tabClassArray;

@property (strong, nonatomic) NewStudyTimeView *studyTimeView;
@property (strong, nonatomic) UIView *studyLatestView;
@property (strong, nonatomic) NSMutableArray *userLearnCourseArray;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *studyInfo;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (strong, nonatomic) NSMutableArray *liveArray;
@property (strong, nonatomic) NSMutableArray *classArray;
@property (strong, nonatomic) NSMutableArray *offlineArray;

@property (strong, nonatomic) UIButton *courseBtn;
@property (strong, nonatomic) UIButton *liveBtn;
@property (strong, nonatomic) UIButton *classBtn;
@property (strong, nonatomic) UIButton *offlineBtn;

@property (strong, nonatomic) UIView *changeTypeBackView;
@property (strong, nonatomic) UIButton *changeTypeBtn;

@property (strong, nonatomic) UIView *notLoginView;
@property (strong, nonatomic) UIImageView *notLoginIcon;
@property (strong, nonatomic) UILabel *notLoginLabel;
@property (strong, nonatomic) UIButton *notLoginButton;

@property (strong, nonatomic) UIButton *joinFirstBtn;
@property (strong, nonatomic) UIButton *studyFirstBtn;

@end

@implementation StudyRootVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
        if (_notLoginView) {
            _notLoginView.hidden = YES;
        }
    } else {
        if (_notLoginView) {
            _notLoginView.hidden = NO;
        }
    }
    if (shouldLoad) {
        [self getStudyInfo];
    }
    shouldLoad = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /// 新增内容
    self.canScroll = YES;
    self.canScrollAfterVideoPlay = YES;
    
    currentCourseType = 0;
    dataType = @"add";
    
    _tabClassArray = [NSMutableArray arrayWithArray:@[@"培训计划",@"公开课程"]];//@[@"点播",@"直播",@"班级",@"面授"]
    
    _courseArray = [NSMutableArray new];
    _liveArray = [NSMutableArray new];
    _classArray = [NSMutableArray new];
    _offlineArray = [NSMutableArray new];
    
    _userLearnCourseArray = [NSMutableArray new];
    
    _titleImage.hidden = YES;
    [self makeHeaderView];
    sectionHeight = MainScreenHeight - MACRO_UI_TABBAR_HEIGHT;
    [self makeTableView];
    [self makeNotLoginView];
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
        _notLoginView.hidden = YES;
    } else {
        _notLoginView.hidden = NO;
    }
    [_tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStudyPageData) name:@"studyPageReloadData" object:nil];
}

- (void)reloadStudyPageData {
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
        if (_notLoginView) {
            _notLoginView.hidden = YES;
        }
    } else {
        if (_notLoginView) {
            _notLoginView.hidden = NO;
        }
    }
    [self getStudyInfo];
}

- (void)makeNotLoginView {
    
    _notLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT)];
    _notLoginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_notLoginView];
    
    _notLoginIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0 - 71, _notLoginView.height/2.0 - 25 - 35 - 106, 142, 106)];
    _notLoginIcon.image = Image(@"empty_img");
    [_notLoginView addSubview:_notLoginIcon];
    
    _notLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _notLoginIcon.bottom + 15, MainScreenWidth, 20)];
    _notLoginLabel.text = @"登录后查看更多内容~";
    _notLoginLabel.font = SYSTEMFONT(14);
    _notLoginLabel.textColor = EdlineV5_Color.textSecendColor;
    _notLoginLabel.textAlignment = NSTextAlignmentCenter;
    [_notLoginView addSubview:_notLoginLabel];
    
    _notLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _notLoginLabel.bottom + 50, 110, 36)];
    [_notLoginButton setTitle:@"登录" forState:0];
    [_notLoginButton setTitleColor:[UIColor whiteColor] forState:0];
    _notLoginButton.titleLabel.font = SYSTEMFONT(16);
    _notLoginButton.backgroundColor = EdlineV5_Color.themeColor;
    _notLoginButton.layer.masksToBounds = YES;
    _notLoginButton.layer.cornerRadius = 18;
    _notLoginButton.centerX = _notLoginIcon.centerX;
    [_notLoginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_notLoginView addSubview:_notLoginButton];
}

- (void)makeChangeTypeBackView {
    
    CGRect btn111 = [self.tableView rectForHeaderInSection:0];
    CGPoint btnPoint = CGPointMake(btn111.origin.x + MainScreenWidth - 15 - 123, btn111.origin.y + 16 + 30 + 5 - self.tableView.contentOffset.y);
    
    if (!_changeTypeBackView) {
        _changeTypeBackView = [[UIView alloc] init];
        _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
        
        _changeTypeBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _changeTypeBackView.layer.cornerRadius = 2;
        _changeTypeBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        _changeTypeBackView.layer.shadowOffset = CGSizeMake(0,1);
        _changeTypeBackView.layer.shadowOpacity = 1;
        _changeTypeBackView.layer.shadowRadius = 5;
        
        _joinFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, _changeTypeBackView.width, 32)];
        _joinFirstBtn.tag = 10;
        [_joinFirstBtn setTitle:@"最近报名的优先" forState:0];
        [_joinFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [_joinFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        _joinFirstBtn.titleLabel.font = SYSTEMFONT(13);
        [_joinFirstBtn addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:_joinFirstBtn];
        
        _studyFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _joinFirstBtn.bottom, _changeTypeBackView.width, 32)];
        _studyFirstBtn.tag = 11;
        [_studyFirstBtn setTitle:@"最近学习的优先" forState:0];
        [_studyFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [_studyFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        _studyFirstBtn.titleLabel.font = SYSTEMFONT(13);
        [_studyFirstBtn addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:_studyFirstBtn];
        _changeTypeBackView.hidden = YES;
        [self.view addSubview:_changeTypeBackView];
    }
    if ([dataType isEqualToString:@"add"]) {
        _joinFirstBtn.selected = YES;
        _studyFirstBtn.selected = NO;
    } else {
        _joinFirstBtn.selected = NO;
        _studyFirstBtn.selected = YES;
    }
    _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
    _changeTypeBackView.hidden = !_changeTypeBackView.hidden;
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 + 40 + MACRO_UI_LIUHAI_HEIGHT)];
    _headerView.backgroundColor = EdlineV5_Color.backColor;
    
    _studyTimeView = [[NewStudyTimeView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 + MACRO_UI_LIUHAI_HEIGHT)];
    [_headerView addSubview:_studyTimeView];
    
    UIView *whiteLayer = [[UIView alloc] initWithFrame:CGRectMake(0, _studyTimeView.height - 15, MainScreenWidth, 15)];
    whiteLayer.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteLayer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteLayer.layer.mask = maskLayer;
    [_headerView addSubview:whiteLayer];
    
    _studyLatestView = [[UIView alloc] initWithFrame:CGRectMake(0, _studyTimeView.bottom, MainScreenWidth, 40)];
    _studyLatestView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_studyLatestView];
}

// MARK: - 处理整个头部的数据
- (void)setStudyInfoData {
    if (SWNOTEmptyDictionary(_studyInfo)) {
        [_studyTimeView newStudyPageTimeInfo:_studyInfo];
        [self setStudyLatestViewInfo];
    } else {
        [self setStudyLatestViewInfo];
    }
    [_headerView setHeight:_studyLatestView.bottom + 10];
}

// MARK: - 赋值最近在学
- (void)setStudyLatestViewInfo {
    [_userLearnCourseArray removeAllObjects];
    [_userLearnCourseArray addObjectsFromArray:[[_studyInfo objectForKey:@"data"] objectForKey:@"latest"]];
    
    [_studyLatestView removeAllSubviews];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    theme.text = @"最近在学";
    theme.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    theme.textColor = EdlineV5_Color.textFirstColor;
    [view addSubview:theme];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 40)];
    [moreButton setTitle:@"更多" forState:0];
    [moreButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    moreButton.titleLabel.font = SYSTEMFONT(14);
    [moreButton addTarget:self action:@selector(jumpLearnRecord:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreButton];
    
    [_studyLatestView addSubview:view];
    
    UIScrollView *studyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, view.bottom, MainScreenWidth, 20)];
    studyScrollView.backgroundColor = [UIColor whiteColor];
    studyScrollView.showsHorizontalScrollIndicator = NO;
    studyScrollView.showsVerticalScrollIndicator = NO;
    [_studyLatestView addSubview:studyScrollView];
    
    CGFloat maxHeight = 0;
    CGFloat maxWidth = 0;
    for (int i = 0; i<_userLearnCourseArray.count; i ++) {
        UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(15 + (125 + 8) * i, 10, 125, 70)];
        [face sd_setImageWithURL:EdulineUrlString([_userLearnCourseArray[i] objectForKey:@"course_cover"]) placeholderImage:DefaultImage];
        face.layer.masksToBounds = YES;
        face.layer.cornerRadius = 2;
        [studyScrollView addSubview:face];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(face.left, face.top, 33, 20)];
        NSString *courseType = [NSString stringWithFormat:@"%@",[_userLearnCourseArray[i] objectForKey:@"course_type"]];
        NSString *section_data_type = [NSString stringWithFormat:@"%@",[_userLearnCourseArray[i] objectForKey:@"section_data_type"]];
        if ([courseType isEqualToString:@"1"]) {
            icon.image = Image(@"dianbo");
        } else if ([courseType isEqualToString:@"2"]) {
            icon.image = Image(@"live");
        } else if ([courseType isEqualToString:@"3"]) {
            icon.image = Image(@"mianshou");
        } else if ([courseType isEqualToString:@"4"]) {
            icon.image = Image(@"class_icon");
        }
        [studyScrollView addSubview:icon];
        icon.hidden = YES;
        
        UILabel *learnTime = [[UILabel alloc] initWithFrame:CGRectMake(face.left, face.bottom - 16, face.width, 16)];
        learnTime.layer.backgroundColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:0.5].CGColor;
        learnTime.textColor = [UIColor whiteColor];
        learnTime.font = SYSTEMFONT(10);
        if ([section_data_type isEqualToString:@"3"] || [section_data_type isEqualToString:@"4"]) {
            learnTime.text = [NSString stringWithFormat:@"总学时:%@",[EdulineV5_Tool tuwenTimeChangeWithSecondsFormat:[[_userLearnCourseArray[i] objectForKey:@"total_time"] integerValue]]];
        } else {
            learnTime.text = [NSString stringWithFormat:@" 学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:[[_userLearnCourseArray[i] objectForKey:@"current_time"] integerValue]]];
        }
        [studyScrollView addSubview:learnTime];
        
        CGFloat radius = 4; // 圆角大小
        UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight; // 圆角位置
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:learnTime.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = learnTime.bounds;
        maskLayer.path = path.CGPath;
        learnTime.layer.mask = maskLayer;
        
        UILabel *thmeLabel = [[UILabel alloc] initWithFrame:CGRectMake(face.left, face.bottom + 10, face.width, 20)];
        thmeLabel.font = SYSTEMFONT(13);
        thmeLabel.textColor = EdlineV5_Color.textFirstColor;
        thmeLabel.text = [NSString stringWithFormat:@"%@",[_userLearnCourseArray[i] objectForKey:@"section_title"]];
        
        maxHeight = MAX(thmeLabel.bottom + 20, maxHeight);
        maxWidth = MAX(face.right, maxWidth);
        [studyScrollView addSubview:thmeLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(face.left, face.top, face.width, thmeLabel.bottom - face.top)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(newStudyLatestButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [studyScrollView addSubview:btn];
    }
    studyScrollView.contentSize = CGSizeMake(maxWidth + 10, 0);
    [studyScrollView setHeight:maxHeight];
    
    [_studyLatestView setHeight:studyScrollView.bottom];
}

- (void)makeTableView {
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableHeaderView = _headerView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStudyInfo)];
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

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
    
    __weak StudyRootVC *weakself = self;
    if (weakself.bg == nil) {
        weakself.bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        weakself.bg.backgroundColor = [UIColor whiteColor];
    } else {
        weakself.bg.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
    }
    
    if (sectionHeight>1) {
        if (self.courseBtn == nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10 + 28 + 13 + 22 + 20)];//93
            view.backgroundColor = [UIColor whiteColor];
            [weakself.bg addSubview:view];
            
            UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 22)];
            theme.text = @"报名的课程";
            theme.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];//SYSTEMFONT(16);
            theme.textColor = EdlineV5_Color.textFirstColor;
            [view addSubview:theme];
            
            if (!_changeTypeBtn) {
                _changeTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 5 - 30, 0, 30, 30)];
                _changeTypeBtn.centerY = theme.centerY;
                [_changeTypeBtn setImage:Image(@"study_shaixuan") forState:0];
                [_changeTypeBtn addTarget:self action:@selector(makeChangeTypeBackView) forControlEvents:UIControlEventTouchUpInside];
            }
            [view addSubview:_changeTypeBtn];
            
            for (int i = 0; i < _tabClassArray.count; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (94 + 12) * i, theme.bottom + 13, 94, 28)];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 14;
                [btn setTitle:_tabClassArray[i] forState:0];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
                btn.titleLabel.font = SYSTEMFONT(14);
                [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
                [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                if (i == 0) {
                    btn.selected = YES;
                    btn.backgroundColor = EdlineV5_Color.themeColor;
                } else {
                    btn.selected = NO;
                    [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
                }
                if (i == 0) {
                    _courseBtn = btn;
                } else if (i == 1) {
                    _liveBtn = btn;
                } else if (i == 2) {
                    _classBtn = btn;
                } else if (i == 3) {
                    _offlineBtn = btn;
                }
            }
        }
        
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,93, MainScreenWidth, sectionHeight - 93)];
            self.mainScroll.contentSize = CGSizeMake(MainScreenWidth*_tabClassArray.count, 0);
            self.mainScroll.pagingEnabled = YES;
            self.mainScroll.showsHorizontalScrollIndicator = NO;
            self.mainScroll.showsVerticalScrollIndicator = NO;
            self.mainScroll.bounces = NO;
            self.mainScroll.delegate = self;
            [_bg addSubview:self.mainScroll];
        } else {
            self.mainScroll.frame = CGRectMake(0,93, MainScreenWidth, sectionHeight - 93);
        }
        
//        if (_zhiboVC == nil) {
//            _zhiboVC = [[StudyTypeCourseListViewController alloc] init];
//            _zhiboVC.courseType = @"2";
//            _zhiboVC.notHiddenNav = YES;
//            _zhiboVC.screenType = dataType;
//            weakself.zhiboVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
//            _zhiboVC.tabelHeight = sectionHeight - 93;
//            _zhiboVC.vc = weakself;
//            _zhiboVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 93);
//            [weakself.mainScroll addSubview:weakself.zhiboVC.view];
//            [weakself addChildViewController:weakself.zhiboVC];
//        } else {
//            _zhiboVC.tabelHeight = sectionHeight - 93;
//            _zhiboVC.courseType = @"2";
//            _zhiboVC.notHiddenNav = YES;
//            _zhiboVC.screenType = dataType;
//            weakself.zhiboVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
//            _zhiboVC.vc = weakself;
//            _zhiboVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 93);
//            _zhiboVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 93);
//            [_zhiboVC getFirstStudyCourseData];
//        }
        
        if (_banjiVC == nil) {
            _banjiVC = [[StudyTypeCourseListViewController alloc] init];
            if (SWNOTEmptyDictionary(_studyInfo)) {
                if (_studyInfo[@"data"][@"plan"]) {
                    _banjiVC.dataSource = [NSMutableArray arrayWithArray:_studyInfo[@"data"][@"plan"]];
                }
            }
            _banjiVC.courseType = @"4";
            _banjiVC.notHiddenNav = YES;
            _banjiVC.screenType = dataType;
            weakself.banjiVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            _banjiVC.tabelHeight = sectionHeight - 93;
            _banjiVC.vc = weakself;
            _banjiVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 93);
            [weakself.mainScroll addSubview:weakself.banjiVC.view];
            [weakself addChildViewController:weakself.banjiVC];
        } else {
            _banjiVC.tabelHeight = sectionHeight - 93;
            _banjiVC.courseType = @"4";
            _banjiVC.notHiddenNav = YES;
            _banjiVC.screenType = dataType;
            weakself.banjiVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            _banjiVC.vc = weakself;
            _banjiVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 93);
            _banjiVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 93);
            if (SWNOTEmptyDictionary(_studyInfo)) {
                if (_studyInfo[@"data"][@"plan"]) {
                    _banjiVC.dataSource = [NSMutableArray arrayWithArray:_studyInfo[@"data"][@"plan"]];
                }
            }
            [_banjiVC.tableView reloadData];
//            [_banjiVC getFirstStudyCourseData];
        }
        
        if (_dianboVC == nil) {
            _dianboVC = [[StudyTypeCourseListViewController alloc] init];
            if (SWNOTEmptyDictionary(_studyInfo)) {
                if (_studyInfo[@"data"][@"course"]) {
                    _dianboVC.dataSource = [NSMutableArray arrayWithArray:_studyInfo[@"data"][@"course"]];
                }
            }
            _dianboVC.notHiddenNav = YES;
            _dianboVC.courseType = @"1";
            _dianboVC.screenType = dataType;
            weakself.dianboVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            _dianboVC.tabelHeight = sectionHeight - 93;
            _dianboVC.vc = weakself;
            _dianboVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 93);
            [weakself.mainScroll addSubview:weakself.dianboVC.view];
            [weakself addChildViewController:weakself.dianboVC];
        } else {
            _dianboVC.tabelHeight = sectionHeight - 93;
            _dianboVC.notHiddenNav = YES;
            _dianboVC.courseType = @"1";
            _dianboVC.screenType = dataType;
            weakself.dianboVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            _dianboVC.vc = weakself;
            _dianboVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 93);
            _dianboVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 93);
            if (SWNOTEmptyDictionary(_studyInfo)) {
                if (_studyInfo[@"data"][@"course"]) {
                    _dianboVC.dataSource = [NSMutableArray arrayWithArray:_studyInfo[@"data"][@"course"]];
                }
            }
            [_dianboVC.tableView reloadData];
//            [_dianboVC getFirstStudyCourseData];
        }
        
//        if (_mianshouVC == nil) {
//            _mianshouVC = [[StudyTypeCourseListViewController alloc] init];
//            _mianshouVC.courseType = @"3";
//            _mianshouVC.notHiddenNav = YES;
//            _mianshouVC.screenType = dataType;
//            weakself.mianshouVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
//            _mianshouVC.tabelHeight = sectionHeight - 93;
//            _mianshouVC.vc = weakself;
//            _mianshouVC.view.frame = CGRectMake(MainScreenWidth * 3,0, MainScreenWidth, sectionHeight - 93);
//            [weakself.mainScroll addSubview:weakself.mianshouVC.view];
//            [weakself addChildViewController:weakself.mianshouVC];
//        } else {
//            _mianshouVC.tabelHeight = sectionHeight - 93;
//            _mianshouVC.courseType = @"3";
//            _mianshouVC.notHiddenNav = YES;
//            _mianshouVC.screenType = dataType;
//            weakself.mianshouVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
//            _mianshouVC.vc = weakself;
//            _mianshouVC.view.frame = CGRectMake(MainScreenWidth *3,0, MainScreenWidth, sectionHeight - 93);
//            _mianshouVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 93);
//            [_mianshouVC getFirstStudyCourseData];
//        }
    }
    return weakself.bg;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

// MARK: - 滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScroll) {
        if (scrollView.contentOffset.x <= 0) {
            self.courseBtn.selected = YES;
            self.liveBtn.selected = NO;
            self.classBtn.selected = NO;
            self.offlineBtn.selected = NO;
            self.courseBtn.backgroundColor = EdlineV5_Color.themeColor;
            self.liveBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.classBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.offlineBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.courseBtn.selected = NO;
            self.liveBtn.selected = NO;
            self.classBtn.selected = YES;
            self.offlineBtn.selected = NO;
            self.courseBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.liveBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.classBtn.backgroundColor = EdlineV5_Color.themeColor;
            self.offlineBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.courseBtn.selected = NO;
            self.liveBtn.selected = YES;
            self.classBtn.selected = NO;
            self.offlineBtn.selected = NO;
            self.courseBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.liveBtn.backgroundColor = EdlineV5_Color.themeColor;
            self.classBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.offlineBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.courseBtn.selected = NO;
            self.liveBtn.selected = NO;
            self.classBtn.selected = NO;
            self.offlineBtn.selected = YES;
            self.courseBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.liveBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.classBtn.backgroundColor = EdlineV5_Color.fengeLineColor;
            self.offlineBtn.backgroundColor = EdlineV5_Color.themeColor;
        }
    } if (scrollView == self.tableView) {
        if (_changeTypeBackView) {
            _changeTypeBackView.hidden = YES;
        }
        CGFloat bottomCellOffset = self.headerView.height;
        if (scrollView.contentOffset.y > bottomCellOffset - 0.5) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.courseBtn.selected) {
                        if ([vc isKindOfClass:[StudyTypeCourseListViewController class]]) {
                            StudyTypeCourseListViewController *vccomment = (StudyTypeCourseListViewController *)vc;
                            if ([vccomment.courseType isEqualToString:@"4"]) {
                                vccomment.cellTabelCanScroll = YES;
                            }
                        }
                    }
                    if (self.liveBtn.selected) {
                        if ([vc isKindOfClass:[StudyTypeCourseListViewController class]]) {
                            StudyTypeCourseListViewController *vccomment = (StudyTypeCourseListViewController *)vc;
                            if ([vccomment.courseType isEqualToString:@"1"]) {
                                vccomment.cellTabelCanScroll = YES;
                            }
                        }
                    }
                    if (self.classBtn.selected) {
                        if ([vc isKindOfClass:[StudyTypeCourseListViewController class]]) {
                            StudyTypeCourseListViewController *vccomment = (StudyTypeCourseListViewController *)vc;
                            if ([vccomment.courseType isEqualToString:@"4"]) {
                                vccomment.cellTabelCanScroll = YES;
                            }
                        }
                    }
                    if (self.offlineBtn.selected) {
                        if ([vc isKindOfClass:[StudyTypeCourseListViewController class]]) {
                            StudyTypeCourseListViewController *vccomment = (StudyTypeCourseListViewController *)vc;
                            if ([vccomment.courseType isEqualToString:@"3"]) {
                                vccomment.cellTabelCanScroll = YES;
                            }
                        }
                    }
                }
            }
        }else{
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

// MARK: - 新版最近在学点击事件
- (void)newStudyLatestButtonClick:(UIButton *)sender {
    [self jumpToCourseDetailVC:_userLearnCourseArray[sender.tag]];
}

// MARK: - StudyLatestCellDelegate(最近在学课程点击跳转)
- (void)jumpToCourseDetailVC:(NSDictionary *)info {
    
    // 判断是不是过期了
    NSString *timeOut = [NSString stringWithFormat:@"%@",info[@"expire_rest"]];
    if ([timeOut isEqualToString:@"0"]) {
        [self showHudInView:self.view showHint:@"课程已过期"];
        return;
    }
    
    if ([ShowUserFace isEqualToString:@"1"] && ([[NSString stringWithFormat:@"%@",info[@"course_type"]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%@",info[@"course_type"]] isEqualToString:@"4"])) {
        self.userFaceStudyRootVerifyResult = ^(BOOL result) {
            CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",info[@"course_id"]];
            vc.currentHourseId = [NSString stringWithFormat:@"%@",info[@"section_id"]];
            vc.isLive = [[NSString stringWithFormat:@"%@",info[@"course_type"]] isEqualToString:@"2"];
            vc.courseType = [NSString stringWithFormat:@"%@",info[@"course_type"]];
            
            CourseListModel *model = [[CourseListModel alloc] init];
            section_data_model *sectionModel = [[section_data_model alloc] init];
            section_rate_model *sectionRateModel = [[section_rate_model alloc] init];
            sectionRateModel.current_time = [[NSString stringWithFormat:@"%@",info[@"current_time"]] unsignedIntValue];
            sectionModel.data_type = [NSString stringWithFormat:@"%@",info[@"section_data_type"]];
            model.title = [NSString stringWithFormat:@"%@",info[@"section_title"]];
            model.section_data = sectionModel;
            model.section_rate = sectionRateModel;
            model.course_id = [NSString stringWithFormat:@"%@",info[@"course_id"]];
            model.classHourId = [NSString stringWithFormat:@"%@",info[@"section_id"]];
            vc.currentPlayModel = model;
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
            [self faceCompareTip:[NSString stringWithFormat:@"%@",info[@"section_id"]] sourceType:@"course_section"];
        } else {
            [self faceVerifyTip];
        }
    } else {
        CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",info[@"course_id"]];
        vc.currentHourseId = [NSString stringWithFormat:@"%@",info[@"section_id"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",info[@"course_type"]] isEqualToString:@"2"];
        vc.courseType = [NSString stringWithFormat:@"%@",info[@"course_type"]];
        
        CourseListModel *model = [[CourseListModel alloc] init];
        section_data_model *sectionModel = [[section_data_model alloc] init];
        section_rate_model *sectionRateModel = [[section_rate_model alloc] init];
        sectionRateModel.current_time = [[NSString stringWithFormat:@"%@",info[@"current_time"]] unsignedIntValue];
        sectionModel.data_type = [NSString stringWithFormat:@"%@",info[@"section_data_type"]];
        model.title = [NSString stringWithFormat:@"%@",info[@"section_title"]];
        model.section_data = sectionModel;
        model.section_rate = sectionRateModel;
        model.course_id = [NSString stringWithFormat:@"%@",info[@"course_id"]];
        model.classHourId = [NSString stringWithFormat:@"%@",info[@"section_id"]];
        vc.currentPlayModel = model;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

// MARK: - 子视图导航按钮点击事件
- (void)typeBtnClick:(UIButton *)sender{
    if (sender == _courseBtn) {
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == _liveBtn) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth, 0) animated:YES];
    } else if (sender == _classBtn) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 2, 0) animated:YES];
    } else if (sender == _offlineBtn) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 3, 0) animated:YES];
    }
}

- (void)changeTypeButtonClick:(UIButton *)sender {
    _changeTypeBackView.hidden = YES;
    if (sender == _joinFirstBtn) {
        if ([dataType isEqualToString:@"add"]) {
            return;
        }
        dataType = @"add";
        _joinFirstBtn.selected = YES;
        _studyFirstBtn.selected = NO;
    } else {
        if ([dataType isEqualToString:@"learn"]) {
            return;
        }
        dataType = @"learn";
        _joinFirstBtn.selected = NO;
        _studyFirstBtn.selected = YES;
    }
    [self getStudyInfo];
    // 发通知 重新刷新页面数据
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFirstStudyCourseData" object:nil userInfo:@{@"dataType":dataType}];
}

- (void)jumpLearnRecord:(UIButton *)sender {
    LearnRecordVC *vc = [[LearnRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreJoinCourseButtonClick:(UIButton *)sender {
    JoinCourseVC *vc = [[JoinCourseVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginButtonClick:(UIButton *)sender {
    [AppDelegate presentLoginNav:self];
}

- (void)getStudyInfo {
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyMainPageData] WithAuthorization:nil paramDic:@{@"order":dataType} finish:^(id  _Nonnull responseObject) {
            if ([_tableView.mj_header isRefreshing]) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _studyInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [self setStudyInfoData];
                    _tableView.tableHeaderView = _headerView;
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            if ([_tableView.mj_header isRefreshing]) {
                [_tableView.mj_header endRefreshing];
            }
        }];
    } else {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
    }
}

// MARK: - 人脸未认证提示
- (void)faceVerifyTip {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未完成人脸认证\n请先去认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = YES;
        vc.verifyed = NO;
        vc.verifyResult = ^(BOOL result) {
//            if (result) {
//                self.userFaceVerifyResult(result);
//            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 人脸识别提示
- (void)faceCompareTip:(NSString *)courseHourseId sourceType:(NSString *)type {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请进行人脸验证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = NO;
        vc.verifyed = YES;
        vc.sourceType = type;
        vc.sourceId = courseHourseId;
        vc.scene_type = @"1";
        vc.verifyResult = ^(BOOL result) {
            if (result) {
                self.userFaceStudyRootVerifyResult(result);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
