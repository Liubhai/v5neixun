//
//  HomeRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomeRootViewController.h"
#import "AliyunVodPlayerView.h"
#import "AliyunUtil.h"
#import "CourseMainViewController.h"
#import "CourseSearchListVC.h"
#import "CourseSearchHistoryVC.h"
#import "IntendedCourseVC.h"
#import "TeacherListVC.h"
#import "TeacherMainPageVC.h"
#import "TeacherCategoryVC.h"

#import "HomePageTeacherCell.h"
#import "HomePageCourseTypeOneCell.h"
#import "HomePageCourseTypeTwoCell.h"
#import "HomePageHotRecommendedCell.h"
#import "HomePageDiscountCell.h"

// 内训版
#import "HomeExamCell.h"
#import "HomeZixunCell.h"
#import "ZiXunDetailVC.h"
#import "ZiXunListVC.h"
#import "ExamPaperDetailViewController.h"
#import "JoinCourseVC.h"
#import "ExamNewMainViewController.h"
#import "ExamResultViewController.h"
#import "MyExamPage.h"

// 直播测试
//#import "LiveRoomViewController.h"
//#import "BCLiveRoomViewController.h"
//#import "OneToOneLiveRoomVC.h"
//#import "TICManager.h"
//#import "TICConfig.h"
//#import "AgoraRtm.h"



// 工具类
#import "SDCycleScrollView.h"
#import "ZPScrollerScaleView.h"
#import "AppDelegate.h"
#import "V5_UserModel.h"
#import "WkWebViewController.h"

// 测试班级课
#import "CourseTreeListViewController.h"
#import "InstitutionsChooseVC.h"

@interface HomeRootViewController ()<UITextFieldDelegate,SDCycleScrollViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomePageTeacherCellDelegate,HomePageHotRecommendedCellDelegate,HomePageCourseTypeTwoCellDelegate,HomePageDiscountCellDelegate, HomeZixunCellDelegate, HomeExamCellDelegate> {
    BOOL isWeek;// 显示周榜还是月榜
}

@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;
@property (strong, nonatomic) UITextField *institutionSearch;

// 头部
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *imageBannerBackView;
@property (strong, nonatomic) UIScrollView *cateScrollView;

// tableview
@property (strong, nonatomic) UITableView *tableView;


// 数据源
// 轮播图和分类
@property (strong, nonatomic) NSMutableArray *bannerImageArray;
@property (strong, nonatomic) NSMutableArray *bannerImageSourceArray;
@property (strong, nonatomic) NSMutableArray *cateSourceArray;
// 讲师
@property (strong, nonatomic) NSMutableArray *teacherArray;

@property (strong, nonatomic) NSMutableArray *sortArray;

/** 内训资讯 */
@property (strong, nonatomic) NSMutableArray *zixunArray;
/** 内训考试 */
@property (strong, nonatomic) NSMutableArray *examArray;
/** 内训计划 */
@property (strong, nonatomic) NSMutableArray *planArray;

// 周榜月榜按钮
@property (strong, nonatomic) UIButton *weekBtn;
@property (strong, nonatomic) UIButton *monthBtn;

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isWeek = YES;
//    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"home_intentionlesson_icon") forState:0];
    
    _bannerImageArray = [NSMutableArray new];
    _bannerImageSourceArray = [NSMutableArray new];
    _cateSourceArray = [NSMutableArray new];
    _sortArray = [NSMutableArray new];
    
    _teacherArray = [NSMutableArray new];
    
    _zixunArray = [NSMutableArray new];
    _planArray = [NSMutableArray new];
    _examArray = [NSMutableArray new];
    
    _titleLabel.text = @"首页";
    [self makeTopSearch];
    
    [self makeHeaderView];
    [self makeBannerView];
    [self makeCateView];
    [self makeTableView];
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
    
    // 从本地获取启动时候拿到的首页请求数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"homepageData"]) {
        [self dealHomepageLocalData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomePageInfo) name:@"changeFavoriteCourse" object:nil];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(15, _titleLabel.top, MainScreenWidth - 30, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索课程" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 17 + 15 + 10, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
//    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
//        [AppDelegate presentLoginNav:self];
//        return NO;
//    }
//    InstitutionsChooseVC *vc = [[InstitutionsChooseVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return NO;
    CourseSearchHistoryVC *vc = [[CourseSearchHistoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHomePageInfo)];
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (void)makeHeaderView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.01)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 0.01);
    [_headerView removeAllSubviews];
}

- (void)makeBannerView {
    if (!_imageBannerBackView) {
        _imageBannerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SWNOTEmptyArr(_bannerImageArray) ? 15 : 0, MainScreenWidth, 0)];
        _imageBannerBackView.backgroundColor = [UIColor whiteColor];
    }
    _imageBannerBackView.frame = CGRectMake(0, 0, MainScreenWidth, SWNOTEmptyArr(_bannerImageArray) ? (2 * MainScreenWidth / 5 + 20) : 0);//2 * MainScreenWidth / 5 + 20
    [_imageBannerBackView removeAllSubviews];
    
    if (SWNOTEmptyArr(_bannerImageSourceArray)) {
        // 添加工具类
        // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
        SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 10, MainScreenWidth, MainScreenWidth * 2 / 5) delegate:self placeholderImage:DefaultImage];
        cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        cycleScrollView3.imageURLStringsGroup = _bannerImageArray;
        cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView3.pageControlDotSize = CGSizeMake(5, 5);
        cycleScrollView3.delegate = self;
        [_imageBannerBackView addSubview:cycleScrollView3];
    }
    [_headerView addSubview:_imageBannerBackView];
}

- (void)makeCateView {
    if (_cateScrollView == nil) {
        _cateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _imageBannerBackView.bottom, MainScreenWidth, 0)];
        _cateScrollView.backgroundColor = [UIColor whiteColor];
        _cateScrollView.pagingEnabled = YES;
        _cateScrollView.scrollEnabled = YES;
        _cateScrollView.delegate = self;
        _cateScrollView.showsHorizontalScrollIndicator = NO;
        _cateScrollView.showsVerticalScrollIndicator = NO;
    }
    [_headerView addSubview:_cateScrollView];
    _cateScrollView.frame = CGRectMake(0, _imageBannerBackView.bottom, MainScreenWidth, SWNOTEmptyArr(_cateSourceArray) ? (96 + 8) : 0);
    [_cateScrollView removeAllSubviews];
    
    CGFloat YY = 4;
    CGFloat XX = 15;
    CGFloat space = 10;
    for (int i = 0; i<_cateSourceArray.count; i++) {
        UIImageView *cateImage = [[UIImageView alloc] initWithFrame:CGRectMake(XX + (157 + space) * i, YY, 157, 96)];
        cateImage.userInteractionEnabled = YES;
        cateImage.tag = i;
        cateImage.layer.masksToBounds = YES;
        cateImage.layer.cornerRadius = 5;
        cateImage.clipsToBounds = YES;
        cateImage.contentMode = UIViewContentModeScaleAspectFill;
        [cateImage sd_setImageWithURL:EdulineUrlString(_cateSourceArray[i][@"image_url"]) placeholderImage:DefaultImage];
        [cateImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cateImageTap:)]];
        [_cateScrollView addSubview:cateImage];
        if (i == (_cateSourceArray.count - 1)) {
            _cateScrollView.contentSize = CGSizeMake(cateImage.right + 10, 0);
        }
    }
    
//    UIView *fenge = [[UIView alloc] initWithFrame:CGRectMake(0, _cateScrollView.bottom, MainScreenWidth, (SWNOTEmptyArr(_bannerImageArray) || SWNOTEmptyArr(_cateSourceArray)) ? 10 : 0.01)];
//    fenge.backgroundColor = EdlineV5_Color.fengeLineColor;
//    [_headerView addSubview:fenge];
    _headerView.frame = CGRectMake(0, 0, MainScreenWidth, _cateScrollView.bottom > 1 ? _cateScrollView.bottom : 0.01);
}

// MARK: - tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sortArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"] || [_sortArray[section][@"key"] isEqualToString:@"userClasses"] || [_sortArray[section][@"key"] isEqualToString:@"userExams"]) {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        return [pass count];
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        if (isWeek) {
            for (NSDictionary *dict in _sortArray[section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                    NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                    return [pass count];
                }
            }
        } else {
            for (NSDictionary *dict in _sortArray[section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                    NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                    return [pass count];
                }
            }
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"]) {
//        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
//        if (!SWNOTEmptyArr(pass)) {
//            return nil;
//        }
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        BOOL showWeek = NO;
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        if (!showWeek) {
            return nil;
        }
    } else {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        if (!SWNOTEmptyArr(pass)) {
            return nil;
        }
    }
    
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 56)];
    sectionHead.backgroundColor = [UIColor whiteColor];
    
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 15 * 2 - 92, sectionHead.height)];
    themeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];//SYSTEMFONT(20);
    themeLabel.textColor = EdlineV5_Color.textFirstColor;
    themeLabel.text = [NSString stringWithFormat:@"%@",_sortArray[section][@"title"]];
    [sectionHead addSubview:themeLabel];
    
    if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        UIView *changeButtonView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 92, (sectionHead.height - 26) / 2.0, 92, 26)];
        changeButtonView.backgroundColor = EdlineV5_Color.backColor;
        changeButtonView.layer.masksToBounds = YES;
        changeButtonView.layer.cornerRadius = changeButtonView.height / 2.0;
        [sectionHead addSubview:changeButtonView];
        for (int i = 0; i<2; i++) {
            UIButton *weekButton = [[UIButton alloc] initWithFrame:CGRectMake(46 * i, 0, 46, 26)];
            weekButton.layer.masksToBounds = YES;
            weekButton.layer.cornerRadius = weekButton.height / 2.0;
            [weekButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
            [weekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            weekButton.titleLabel.font = SYSTEMFONT(14);
            [weekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [weekButton setTitle:@"周榜" forState:0];
                _weekBtn = weekButton;
            } else {
                [weekButton setTitle:@"月榜" forState:0];
                _monthBtn = weekButton;
            }
            if (isWeek) {
                if (i==0) {
                    weekButton.selected = YES;
                    weekButton.backgroundColor = EdlineV5_Color.themeColor;
                } else {
                    weekButton.selected = NO;
                    weekButton.backgroundColor = EdlineV5_Color.backColor;
                }
            } else {
                if (i==1) {
                    weekButton.selected = YES;
                    weekButton.backgroundColor = EdlineV5_Color.themeColor;
                } else {
                    weekButton.selected = NO;
                    weekButton.backgroundColor = EdlineV5_Color.backColor;
                }
            }
            [changeButtonView addSubview:weekButton];
        }
        
    } else {
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 58, 0, 58, 56)];
        moreButton.titleLabel.font = SYSTEMFONT(14);
        [moreButton setTitle:@"更多" forState:0];
        [moreButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"]) {
            [moreButton setTitle:@"" forState:0];
            [moreButton setImage:Image(@"home_change_icon") forState:0];
            if (!SWNOTEmptyStr(themeLabel.text)) {
                themeLabel.text = @"意向课程";
            }
        }
        [moreButton addTarget:self action:@selector(sectionMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        moreButton.tag = section;
        [sectionHead addSubview:moreButton];
    }
    return sectionHead;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"]) {
//        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
//        if (!SWNOTEmptyArr(pass)) {
//            return nil;
//        }
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        BOOL showWeek = NO;
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        if (!showWeek) {
            return nil;
        }
    } else {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        if (!SWNOTEmptyArr(pass)) {
            return nil;
        }
    }

    
    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"] || ([_sortArray[section][@"key"] isEqualToString:@"recommendTeacher"]) || ([_sortArray[section][@"key"] isEqualToString:@"flashSaleCourse"])) {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        if ([pass count]) {
            UIView *footerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
            footerBack.backgroundColor = [UIColor whiteColor];
            UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MainScreenWidth, 10)];
            sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
            [footerBack addSubview:sectionHead];
            return footerBack;
        } else {
            UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
            sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
            return sectionHead;
        }
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendCourse"]) {
        UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
        sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
        return sectionHead;
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        if (isWeek) {
            NSMutableArray *pass = [NSMutableArray new];
            for (NSDictionary *dict in _sortArray[section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                    [pass addObjectsFromArray:[dict objectForKey:@"list"]];
                }
            }
            if (SWNOTEmptyArr(pass)) {
                UIView *footerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
                footerBack.backgroundColor = [UIColor whiteColor];
                UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MainScreenWidth, 10)];
                sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
                [footerBack addSubview:sectionHead];
                return footerBack;
            } else {
                UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
                sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
                return sectionHead;
            }
        } else {
            NSMutableArray *pass = [NSMutableArray new];
            for (NSDictionary *dict in _sortArray[section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                    [pass addObjectsFromArray:[dict objectForKey:@"list"]];
                }
            }
            if (SWNOTEmptyArr(pass)) {
                UIView *footerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
                footerBack.backgroundColor = [UIColor whiteColor];
                UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MainScreenWidth, 10)];
                sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
                [footerBack addSubview:sectionHead];
                return footerBack;
            } else {
                UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
                sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
                return sectionHead;
            }
        }
    } else {
       UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
       sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
       return sectionHead;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"]) {
//        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
//        if (!SWNOTEmptyArr(pass)) {
//            return 0.001;
//        }
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        BOOL showWeek = NO;
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        if (!showWeek) {
            return 0.001;
        }
    } else {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        if (!SWNOTEmptyArr(pass)) {
            return 0.001;
        }
    }

    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"]) {
//        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
//        if (!SWNOTEmptyArr(pass)) {
//            return 0.001;
//        }
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        BOOL showWeek = NO;
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        for (NSDictionary *dict in _sortArray[section][@"list"]) {
            if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                NSArray *pass = [NSArray arrayWithArray:[dict objectForKey:@"list"]];
                if (SWNOTEmptyArr(pass)) {
                    showWeek = YES;
                }
            }
        }
        if (!showWeek) {
            return 0.001;
        }
    } else {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        if (!SWNOTEmptyArr(pass)) {
            return 0.001;
        }
    }

    if ([_sortArray[section][@"key"] isEqualToString:@"favoriteCourse"] || ([_sortArray[section][@"key"] isEqualToString:@"recommendTeacher"]) || ([_sortArray[section][@"key"] isEqualToString:@"flashSaleCourse"])) {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[section][@"list"]];
        if ([pass count]) {
            return 30;
        } else {
            return 10;
        }
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendCourse"]) {
        return 10;
    } else if ([_sortArray[section][@"key"] isEqualToString:@"recommendWellSale"]) {
        if (isWeek) {
            NSMutableArray *pass = [NSMutableArray new];
            for (NSDictionary *dict in _sortArray[section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                    [pass addObjectsFromArray:[dict objectForKey:@"list"]];
                }
            }
            if (SWNOTEmptyArr(pass)) {
                return 30;
            } else {
                return 10;
            }
        } else {
            NSMutableArray *pass = [NSMutableArray new];
            for (NSDictionary *dict in _sortArray[section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                    [pass addObjectsFromArray:[dict objectForKey:@"list"]];
                }
            }
            if (SWNOTEmptyArr(pass)) {
                return 30;
            } else {
                return 10;
            }
        }
    } else {
       return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"favoriteCourse"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"userClasses"]) {
        static NSString *reuse = @"HomePageCourseTypeOnefavoriteCourseCell";
        HomePageCourseTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomePageCourseTypeOneCellInfo:_sortArray[indexPath.section][@"list"][indexPath.row]];
        return cell;
        
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"userExams"]) {
        static NSString *reuse = @"HomeExamCell";
        HomeExamCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomeExamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomeExamListInfo:_sortArray[indexPath.section][@"list"][indexPath.row]];
        cell.delegate = self;
        return cell;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"information"]) {
        static NSString *reuse = @"HomeZixunCell";
        HomeZixunCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomeZixunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setZixunArrayInfo:_sortArray[indexPath.section][@"list"]];
        cell.delegate = self;
        return cell;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendCourse"]) {
        static NSString *reuse = @"HomePageHotRecommendedCell";
        HomePageHotRecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageHotRecommendedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setRecommendCourseCellInfo:_sortArray[indexPath.section][@"list"]];
        cell.delegate = self;
        return cell;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendWellSale"]) {
        if (isWeek) {
            NSMutableArray *pass = [NSMutableArray new];
            for (NSDictionary *dict in _sortArray[indexPath.section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"week"]) {
                    [pass addObjectsFromArray:[dict objectForKey:@"list"]];
                }
            }
            static NSString *reuse = @"HomePageCourseTypeOneweekCell";
            HomePageCourseTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[HomePageCourseTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            }
            [cell setHomePageCourseTypeOneWeekCellInfo:pass[indexPath.row] indexparh:indexPath];
            return cell;
        } else {
            NSMutableArray *pass = [NSMutableArray new];
            for (NSDictionary *dict in _sortArray[indexPath.section][@"list"]) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"month"]) {
                    [pass addObjectsFromArray:[dict objectForKey:@"list"]];
                }
            }
            static NSString *reuse = @"HomePageCourseTypeOnemonthCell";
            HomePageCourseTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[HomePageCourseTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            }
            [cell setHomePageCourseTypeOneWeekCellInfo:pass[indexPath.row] indexparh:indexPath];
            return cell;
        }
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendTeacher"]) {
        static NSString *reuse = @"HomePageTeacherrecommendTeacherCell";
        HomePageTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setTeacherArrayInfo:_sortArray[indexPath.section][@"list"]];
        cell.delegate = self;
        return cell;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"categoryCourse"]) {
        static NSString *reuse = @"HomePageCourseTypecategoryCourseCell";
        HomePageCourseTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomePageCourseTypeTwoCellInfo:_sortArray[indexPath.section][@"list"]];
        cell.delegate = self;
        return cell;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"flashSaleCourse"]) {
        static NSString *reuse = @"HomePageDiscountCell";
        HomePageDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setDiscountArrayInfo:_sortArray[indexPath.section][@"list"]];
        cell.delegate = self;
        return cell;
    } else {
        static NSString *reuse = @"homeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"favoriteCourse"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"userClasses"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"userExams"]) {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[indexPath.section][@"list"]];
        return [pass count] > 0 ? 106 : 0;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendCourse"]) {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[indexPath.section][@"list"]];
        return [pass count] > 0 ? (172 + 15 + 20) : 0;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendWellSale"]) {
        NSArray *pass = [NSArray arrayWithArray:_sortArray[indexPath.section][@"list"]];
        return [pass count] > 0 ? 106 : 0;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendTeacher"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"flashSaleCourse"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"information"]) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"categoryCourse"]) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else {
        return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"recommendWellSale"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"favoriteCourse"] || [_sortArray[indexPath.section][@"key"] isEqualToString:@"userClasses"]) {
        
        HomePageCourseTypeOneCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"id"]];
        vc.courselayer = [NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"section_level"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
        vc.courseType = [NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"course_type"]];
        if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"userClasses"]) {
            vc.courseType = @"4";
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[indexPath.section][@"key"] isEqualToString:@"categoryCourse"]) {
        HomePageCourseTypeOneCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"id"]];
        vc.courselayer = [NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"section_level"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
        vc.courseType = [NSString stringWithFormat:@"%@",[cell.courseInfoDict objectForKey:@"course_type"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *link_type = [NSString stringWithFormat:@"%@",_bannerImageSourceArray[index][@"link_type"]];
    if ([link_type isEqualToString:@"0"]) {
        return;
    } else if ([link_type isEqualToString:@"1"]) {
        if (SWNOTEmptyStr(_bannerImageSourceArray[index][@"link_data_type"])) {
            NSString *bannerType = [NSString stringWithFormat:@"%@",_bannerImageSourceArray[index][@"link_data_type"]];
            if ([bannerType isEqualToString:@"video"]) {
                CourseMainViewController *vc = [[CourseMainViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",[_bannerImageSourceArray[index] objectForKey:@"link_data_id"]];
                vc.isLive = NO;
                vc.courseType = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([bannerType isEqualToString:@"live"] || [bannerType isEqualToString:@"live_small"]) {
                CourseMainViewController *vc = [[CourseMainViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",[_bannerImageSourceArray[index] objectForKey:@"link_data_id"]];
                vc.isLive = YES;
                vc.courseType = @"2";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                return;
            }
        }
    } else if ([link_type isEqualToString:@"2"]) {
        if (SWNOTEmptyStr(_bannerImageSourceArray[index][@"link_data_type"])) {
            NSString *bannerType = [NSString stringWithFormat:@"%@",_bannerImageSourceArray[index][@"link_data_type"]];
            if ([bannerType isEqualToString:@"public"]) {
                WkWebViewController *vc = [[WkWebViewController alloc] init];
                vc.titleString = [NSString stringWithFormat:@"%@",[_bannerImageSourceArray[index] objectForKey:@"link_type_text"]];
                vc.urlString = [NSString stringWithFormat:@"%@",[_bannerImageSourceArray[index] objectForKey:@"link_href"]];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                return;
            }
        }
    }
}

// MARK: - 广告位点击事件
- (void)cateImageTap:(UITapGestureRecognizer *)tap {
    NSString *link_type = [NSString stringWithFormat:@"%@",_cateSourceArray[tap.view.tag][@"link_type"]];
    if ([link_type isEqualToString:@"0"]) {
        return;
    } else if ([link_type isEqualToString:@"1"]) {
        if (SWNOTEmptyStr(_cateSourceArray[tap.view.tag][@"link_data_type"])) {
            NSString *bannerType = [NSString stringWithFormat:@"%@",_cateSourceArray[tap.view.tag][@"link_data_type"]];
            if ([bannerType isEqualToString:@"video"]) {
                CourseMainViewController *vc = [[CourseMainViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",[_cateSourceArray[tap.view.tag] objectForKey:@"link_data_id"]];
                vc.isLive = NO;
                vc.courseType = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([bannerType isEqualToString:@"live"] || [bannerType isEqualToString:@"live_small"]) {
                CourseMainViewController *vc = [[CourseMainViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",[_cateSourceArray[tap.view.tag] objectForKey:@"link_data_id"]];
                vc.isLive = YES;
                vc.courseType = @"2";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                return;
            }
        }
    } else if ([link_type isEqualToString:@"2"]) {
        if (SWNOTEmptyStr(_cateSourceArray[tap.view.tag][@"link_data_type"])) {
            NSString *bannerType = [NSString stringWithFormat:@"%@",_cateSourceArray[tap.view.tag][@"link_data_type"]];
            if ([bannerType isEqualToString:@"public"]) {
                WkWebViewController *vc = [[WkWebViewController alloc] init];
                vc.titleString = [NSString stringWithFormat:@"%@",[_cateSourceArray[tap.view.tag] objectForKey:@"link_type_text"]];
                vc.urlString = [NSString stringWithFormat:@"%@",[_cateSourceArray[tap.view.tag] objectForKey:@"link_href"]];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                return;
            }
        }
    }
}

// MARK: - 更多按钮点击事件
- (void)sectionMoreButtonClick:(UIButton *)sender {
    if ([_sortArray[sender.tag][@"key"] isEqualToString:@"recommendTeacher"]) {
        TeacherListVC *vc = [[TeacherListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"recommendCourse"]) {
        CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
        vc.isSearch = YES;
        vc.hiddenNavDisappear = YES;
        vc.notHiddenNav = NO;
        vc.sortStr = @"推荐";
        vc.sortIdStr = @"splendid";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"favoriteCourse"]) {
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
        vc.isChange = YES;
        vc.typeString = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"categoryCourse"]) {
        CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
        vc.isSearch = YES;
        vc.hiddenNavDisappear = YES;
        vc.notHiddenNav = NO;
        vc.cateStr = [NSString stringWithFormat:@"%@",_sortArray[sender.tag][@"title"]];
        vc.cateIdStr = [NSString stringWithFormat:@"%@",_sortArray[sender.tag][@"category_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"flashSaleCourse"]) {
        CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
        vc.isSearch = YES;
        vc.hiddenNavDisappear = YES;
        vc.notHiddenNav = NO;
        vc.screenTypeStr = @"event";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"information"]) {
        ZiXunListVC *vc = [[ZiXunListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"userClasses"]) {
        JoinCourseVC *vc = [[JoinCourseVC alloc] init];
        vc.courseType = @"4";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_sortArray[sender.tag][@"key"] isEqualToString:@"userExams"]) {
        MyExamPage *vc = [[MyExamPage alloc] init];
        vc.sortTypeFromFind = @{@"title":@"分配考试",@"id":@"examApportion"};
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: - 调整到讲师主页面
- (void)goToTeacherMainPage:(NSString *)teacherId {
    TeacherMainPageVC *vc = [[TeacherMainPageVC alloc] init];
    vc.teacherId = teacherId;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 跳转到资讯详情页
- (void)goToZixunDetailPage:(NSString *)zixunId {
    ZiXunDetailVC *vc = [[ZiXunDetailVC alloc] init];
    vc.zixunId = zixunId;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 考试或者查看详情
- (void)doExamOrLookExamResult:(NSDictionary *)examInfo {
    
    NSString *exam_status = [NSString stringWithFormat:@"%@",examInfo[@"exam_status"]];
    NSString *answer_times = [NSString stringWithFormat:@"%@",examInfo[@"answer_times"]];
    NSString *exam_number = [NSString stringWithFormat:@"%@",examInfo[@"exam_rest_num"]];
    
    if ([answer_times isEqualToString:@"0"] || [answer_times isEqualToString:@"null"] || [answer_times isEqualToString:@"<null>"]) {
        // 未作答
        if ([exam_status isEqualToString:@"0"]) {
            // 未开放
        } else {
            // 开始答题
            if ([exam_number isEqualToString:@"0"]) {
                [self showHudInView:self.view showHint:@"考试次数已用完"];
                return;
            }
            ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
            vc.examType = @"3";
            vc.examIds = [NSString stringWithFormat:@"%@",[examInfo objectForKey:@"paper_id"]];
            vc.examModuleId = [NSString stringWithFormat:@"%@",[examInfo objectForKey:@"exam_id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        /// 已参考
        ExamResultViewController *vc = [[ExamResultViewController alloc] init];
        vc.record_id = [NSString stringWithFormat:@"%@",examInfo[@"record_id"]];
        vc.examType = @"3";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: 热门推荐课程跳转(HomePageHotRecommendedCellDelegate)
- (void)recommendCourseJump:(NSDictionary *)courseInfo {
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"section_level"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 分类课程点击跳转课程详情事件(HomePageCourseTypeTwoCellDelegate)
- (void)categoryCourseTapJump:(NSDictionary *)courseInfo {
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"section_level"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightButtonClick:(id)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
    vc.isChange = YES;
    vc.typeString = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 周榜月榜切换按钮点击事件
- (void)weekButtonClick:(UIButton *)sender {
    if (sender == _weekBtn) {
        isWeek = YES;
        _weekBtn.selected = YES;
        _monthBtn.selected = NO;
    } else {
        isWeek = NO;
        _weekBtn.selected = NO;
        _monthBtn.selected = YES;
    }
    [_tableView reloadData];
}

// MARK: - 点击限时打折课程跳转
- (void)goToDiscountCourseMainPage:(NSDictionary *)courseInfo {
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"product_id"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"product_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"product_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 首页请求数据
- (void)getHomePageInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path homePageInfoNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:@"homepageData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_sortArray removeAllObjects];
                
                [_bannerImageSourceArray removeAllObjects];
                [_bannerImageArray removeAllObjects];
                
                [_cateSourceArray removeAllObjects];
                
                if (SWNOTEmptyArr([responseObject objectForKey:@"data"])) {
                    NSArray *passArray = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
                    for (NSDictionary *dict in passArray) {
                        if ([dict[@"key"] isEqualToString:@"banner"]) {
                            [_bannerImageSourceArray addObjectsFromArray:dict[@"list"]];
                            for (NSDictionary *imageSource in _bannerImageSourceArray) {
                                if (SWNOTEmptyStr(imageSource[@"image_url"])) {
                                    [_bannerImageArray addObject:imageSource[@"image_url"]];
                                } else {
                                    [_bannerImageArray addObject:@""];
                                }
                            }
                        } else if ([dict[@"key"] isEqualToString:@"advert"]) {
                            [_cateSourceArray addObjectsFromArray:dict[@"list"]];
                        }
                    }
                    [_sortArray addObjectsFromArray:passArray];
                    for (int i = _sortArray.count - 1; i>=0; i--) {
                        if ([_sortArray[i][@"key"] isEqualToString:@"banner"] || [_sortArray[i][@"key"] isEqualToString:@"advert"]) {
                            [_sortArray removeObjectAtIndex:i];
                        }
                    }
                }
                
                [self makeHeaderView];
                [self makeBannerView];
                [self makeCateView];
                _tableView.tableHeaderView = _headerView;
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

// MARK: - 处理本地数据
- (void)dealHomepageLocalData {
    NSData *jsonData = [NSData dataWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"homepageData"]];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *responseObject = [NSDictionary dictionaryWithDictionary:jsonObj];
    if (SWNOTEmptyDictionary(responseObject)) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            [_sortArray removeAllObjects];
            
            [_bannerImageSourceArray removeAllObjects];
            [_bannerImageArray removeAllObjects];
            
            [_cateSourceArray removeAllObjects];
            
            if (SWNOTEmptyArr([responseObject objectForKey:@"data"])) {
                NSArray *passArray = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
                for (NSDictionary *dict in passArray) {
                    if ([dict[@"key"] isEqualToString:@"banner"]) {
                        [_bannerImageSourceArray addObjectsFromArray:dict[@"list"]];
                        for (NSDictionary *imageSource in _bannerImageSourceArray) {
                            if (SWNOTEmptyStr(imageSource[@"image_url"])) {
                                [_bannerImageArray addObject:imageSource[@"image_url"]];
                            } else {
                                [_bannerImageArray addObject:@""];
                            }
                        }
                    } else if ([dict[@"key"] isEqualToString:@"advert"]) {
                        [_cateSourceArray addObjectsFromArray:dict[@"list"]];
                    }
                }
                [_sortArray addObjectsFromArray:passArray];
                for (int i = _sortArray.count - 1; i>=0; i--) {
                    if ([_sortArray[i][@"key"] isEqualToString:@"banner"] || [_sortArray[i][@"key"] isEqualToString:@"advert"]) {
                        [_sortArray removeObjectAtIndex:i];
                    }
                }
            }
            
            [self makeHeaderView];
            [self makeBannerView];
            [self makeCateView];
            _tableView.tableHeaderView = _headerView;
            [_tableView reloadData];
        }
    }
}

@end
