//
//  ZiXunListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ZiXunListVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ZiXunListCell.h"
#import "ZiXunDetailVC.h"
#import "TeacherCategoryVC.h"

// 工具类
#import "SDCycleScrollView.h"
#import "ZPScrollerScaleView.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "WkWebViewController.h"
#import "CourseMainViewController.h"

@interface ZiXunListVC ()<TeacherCategoryVCDelegate, SDCycleScrollViewDelegate> {
    NSInteger page;
    NSString *typeString;
}

// 头部
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *imageBannerBackView;

// 轮播图和分类
@property (strong, nonatomic) NSMutableArray *bannerImageArray;
@property (strong, nonatomic) NSMutableArray *bannerImageSourceArray;

@end

@implementation ZiXunListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"资讯";
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    _rightButton.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    
    _dataSource = [NSMutableArray new];
    _bannerImageArray = [NSMutableArray new];
    _bannerImageSourceArray = [NSMutableArray new];
    typeString = @"";
    [self makeHeaderView];
    [self makeBannerView];
    [self makeTableView];
    _tableView.tableHeaderView = _headerView;
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
    _imageBannerBackView.frame = CGRectMake(0, 0, MainScreenWidth, SWNOTEmptyArr(_bannerImageArray) ? (2 * MainScreenWidth / 5 + 20) : 0);
    [_imageBannerBackView removeAllSubviews];
    
    if (SWNOTEmptyArr(_bannerImageSourceArray)) {
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
    }
    [_headerView addSubview:_imageBannerBackView];
    _headerView.frame = CGRectMake(0, 0, MainScreenWidth, _imageBannerBackView.bottom);
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"ZiXunListCell";
    ZiXunListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[ZiXunListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setZiXunInfo:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZiXunDetailVC *vc = [[ZiXunDetailVC alloc] init];
    vc.zixunId = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)getFirstData {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(typeString)) {
        [param setObject:typeString forKey:@"category"];
    }
    if (SWNOTEmptyStr(_mhm_id)) {
        [param setObject:_mhm_id forKey:@"mhm_id"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path zixunListPageNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                    _tableView.mj_footer.hidden = NO;
                }
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
    
    // 每次刷新的时候还是要请求一下 banner 信息
    [self getZixunListPageBannerInfo];
}

- (void)getMoreDataList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(typeString)) {
        [param setObject:typeString forKey:@"category"];
    }
    if (SWNOTEmptyStr(_mhm_id)) {
        [param setObject:_mhm_id forKey:@"mhm_id"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path zixunListPageNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)getZixunListPageBannerInfo {
    NSMutableDictionary *param = [NSMutableDictionary new];

    if (SWNOTEmptyStr(_mhm_id)) {
        [param setObject:_mhm_id forKey:@"mhm_id"];
    } else {
        [param setObject:Institution_Id forKey:@"mhm_id"];
    }
    // topic资讯、school机构、home首页、advert广告
    [param setObject:@"topic" forKey:@"type"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path commenBannerInfoNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_bannerImageSourceArray removeAllObjects];
                [_bannerImageArray removeAllObjects];
                
                [_bannerImageSourceArray addObjectsFromArray:responseObject[@"data"]];
                for (NSDictionary *imageSource in _bannerImageSourceArray) {
                    if (SWNOTEmptyStr(imageSource[@"image_url"])) {
                        [_bannerImageArray addObject:imageSource[@"image_url"]];
                    } else {
                        [_bannerImageArray addObject:@""];
                    }
                }
                
                [self makeHeaderView];
                [self makeBannerView];
                _tableView.tableHeaderView = _headerView;
                
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
    }];
}

- (void)rightButtonClick:(id)sender {
    TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
    vc.typeString = @"5";
    vc.delegate = self;
    vc.mhm_id = _mhm_id;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 选择更换资讯类型代理
- (void)chooseCategoryId:(NSString *)categoryId {
    typeString = categoryId;
    [self.tableView.mj_header beginRefreshing];
}

@end
