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
#import "AVC_VP_VideoPlayViewController.h"
#import "CourseSearchListVC.h"
#import "CourseSearchHistoryVC.h"
#import "IntendedCourseVC.h"
#import "TeacherListVC.h"

#import "HomePageTeacherCell.h"
#import "HomePageCourseTypeOneCell.h"
#import "HomePageCourseTypeTwoCell.h"
#import "HomePageHotRecommendedCell.h"

// 直播测试
#import "LiveRoomViewController.h"
#import "TICManager.h"
#import "TICConfig.h"

// 工具类
#import "SDCycleScrollView.h"
#import "ZPScrollerScaleView.h"

@interface HomeRootViewController ()<UITextFieldDelegate,SDCycleScrollViewDelegate,UIScrollViewDelegate,HomePageTeacherCellDelegate,UITableViewDelegate,UITableViewDataSource>

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

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"home_intentionlesson_icon") forState:0];
    
    _bannerImageArray = [NSMutableArray new];
    _bannerImageSourceArray = [NSMutableArray new];
    _cateSourceArray = [NSMutableArray new];
    
    [_bannerImageArray addObjectsFromArray:@[@"http://v5.51eduline.com/storage/upload/20200518/f577433b3d66563404a232f21f96bfec.jpg",@"http://v5.51eduline.com/storage/upload/20200518/f577433b3d66563404a232f21f96bfec.jpg",@"http://v5.51eduline.com/storage/upload/20200518/f577433b3d66563404a232f21f96bfec.jpg",@"http://v5.51eduline.com/storage/upload/20200518/f577433b3d66563404a232f21f96bfec.jpg"]];
    [_cateSourceArray addObjectsFromArray:@[@"",@"",@""]];
    
    _teacherArray = [NSMutableArray new];
    
    _titleLabel.text = @"首页";
    [self makeTopSearch];
    
    [self makeHeaderView];
    [self makeBannerView];
    [self makeCateView];
    [self makeTableView];
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(15, _titleLabel.top, MainScreenWidth - 15 - _rightButton.width, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索课程" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (void)makeHeaderView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    [_headerView removeAllSubviews];
}

- (void)makeBannerView {
    if (!_imageBannerBackView) {
        _imageBannerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SWNOTEmptyArr(_bannerImageArray) ? 15 : 0, MainScreenWidth, 0)];
        _imageBannerBackView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_imageBannerBackView];
    }
    _imageBannerBackView.frame = CGRectMake(0, 0, MainScreenWidth, SWNOTEmptyArr(_bannerImageArray) ? (2 * MainScreenWidth / 5 + 20) : 0);
    [_imageBannerBackView removeAllSubviews];
    
    // 添加工具类
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 10, MainScreenWidth, MainScreenWidth * 2 / 5) delegate:self placeholderImage:[UIImage imageNamed:@"站位图"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = _bannerImageArray;
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView3.delegate = self;
    [_imageBannerBackView addSubview:cycleScrollView3];
    [_headerView addSubview:_imageBannerBackView];
}

- (void)makeCateView {
    if (_cateScrollView == nil) {
        _cateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _imageBannerBackView.bottom + 20, MainScreenWidth, 0)];
        _cateScrollView.backgroundColor = [UIColor whiteColor];
        _cateScrollView.pagingEnabled = YES;
        _cateScrollView.scrollEnabled = NO;
        _cateScrollView.delegate = self;
        _cateScrollView.showsHorizontalScrollIndicator = NO;
        _cateScrollView.showsVerticalScrollIndicator = NO;
        [_headerView addSubview:_cateScrollView];
    }
    _cateScrollView.frame = CGRectMake(0, _imageBannerBackView.bottom, MainScreenWidth, SWNOTEmptyArr(_cateSourceArray) ? 116 : 0);
    [_cateScrollView removeAllSubviews];
    
    CGFloat YY = 14;
    CGFloat XX = 15;
    CGFloat space = 10;
    for (int i = 0; i<_cateSourceArray.count; i++) {
        UIImageView *cateImage = [[UIImageView alloc] initWithFrame:CGRectMake(XX + (150 + space) * i, YY, 150, 88)];
        cateImage.layer.masksToBounds = YES;
        cateImage.layer.cornerRadius = 5;
        cateImage.clipsToBounds = YES;
        cateImage.contentMode = UIViewContentModeScaleAspectFill;
        [_cateScrollView addSubview:cateImage];
        if (i == (_cateSourceArray.count - 1)) {
            _cateScrollView.contentSize = CGSizeMake(cateImage.right + 10, 0);
        }
    }
    
    UIView *fenge = [[UIView alloc] initWithFrame:CGRectMake(0, _cateScrollView.bottom, MainScreenWidth, (SWNOTEmptyArr(_bannerImageArray) || SWNOTEmptyArr(_cateSourceArray)) ? 10 : 0)];
    _headerView.frame = CGRectMake(0, 0, MainScreenWidth, fenge.bottom);
}

// MARK: - tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 56)];
    sectionHead.backgroundColor = [UIColor redColor];
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 58, 0, 58, 56)];
    moreButton.titleLabel.font = SYSTEMFONT(14);
    [moreButton setTitle:@"更多" forState:0];
    [moreButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [moreButton addTarget:self action:@selector(sectionMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = section;
    [sectionHead addSubview:moreButton];
    return sectionHead;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
    return sectionHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"HomePageCourseTypeOneCell";
        HomePageCourseTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *reuse = @"HomePageCourseTypeTwoCell";
        HomePageCourseTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomePageCourseTypeTwoCellInfo:@[@"",@"",@"",@"",@""]];
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *reuse = @"HomePageHotRecommendedCell";
        HomePageHotRecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageHotRecommendedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setRecommendCourseCellInfo:@[@"",@"",@"",@"",@""]];
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
    if (indexPath.section == 0) {
        return 106;
    } else if (indexPath.section == 1) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else if (indexPath.section == 2) {
        return 172 + 15 + 20;
    } else {
        return 0.0;
    }
}

// MARK: - 更多按钮点击事件
- (void)sectionMoreButtonClick:(UIButton *)sender {
    if (sender.tag == 2) {
        TeacherListVC *vc = [[TeacherListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: - 调整到讲师主页面
- (void)goToTeacherMainPage:(NSInteger)teacherViewTag {
    
}

- (void)rightButtonClick:(id)sender {
    IntendedCourseVC *vc = [[IntendedCourseVC alloc] init];
    vc.isChange = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
