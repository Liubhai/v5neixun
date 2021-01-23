//
//  MycouponsListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MycouponsListVC.h"
#import "KaquanCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "CouponModel.h"
#import "CourseMainViewController.h"
#import "InstitutionRootVC.h"
#import "InstitutionCourseMainVC.h"

@interface MycouponsListVC ()<UITableViewDelegate, UITableViewDataSource,KaquanCellDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MycouponsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCouponList) name:@"reloadMyCouponList" object:nil];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCouponList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreCouponList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"KaquanCell";
    CouponModel *model1 = _dataSource[indexPath.row];
    KaquanCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[KaquanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:model1.coupon_type getOrUse:NO useful:([_couponType isEqualToString:@"usable"] ? YES : NO) myCouponListtype:_couponType];
    }
    [cell setCouponInfo:model1 cellIndexPath:indexPath isMyCouponsList:YES];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getCouponList {
    if (SWNOTEmptyStr(_couponType)) {
        page = 1;
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path myCouponsList:_couponType] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[CouponModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                }
            }
            if (_dataSource.count<10) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
            }
            [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
            [_tableView reloadData];
        } enError:^(NSError * _Nonnull error) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
        }];
    }
}

- (void)getMoreCouponList {
    if (SWNOTEmptyStr(_couponType)) {
        page = page + 1;
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path myCouponsList:_couponType] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                    [_dataSource addObjectsFromArray:[CouponModel mj_objectArrayWithKeyValuesArray:pass]];
                    if (pass.count<10) {
                        _tableView.mj_footer.hidden = YES;
                    } else {
                        _tableView.mj_footer.hidden = NO;
                    }
                }
            }
            [_tableView reloadData];
        } enError:^(NSError * _Nonnull error) {
            page--;
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
        }];
    }
}

- (void)useOrGetAction:(KaquanCell *)cell {
    if ([cell.cellType isEqualToString:@"3"]) {
        
        // 直接兑换
        
        [self couponDirectExchange:cell.couponModel.couponId];
        
//        // 跳转对应的课程详情
//        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
//        vc.ID = [NSString stringWithFormat:@"%@",cell.couponModel.course_id];
//        // 这里必须要传值是什么课程类型 1 点播 2 直播  3 面授  4 班级课
//        vc.courseType = [NSString stringWithFormat:@"%@",cell.couponModel.course_type];
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 跳转对应机构
//        InstitutionRootVC *vc = [[InstitutionRootVC alloc] init];
//        vc.institutionId = [NSString stringWithFormat:@"%@",cell.couponModel.mhm_id];
//        [self.navigationController pushViewController:vc animated:YES];
        // 跳转到对应机构的课程y列表页面
        InstitutionCourseMainVC *vc = [[InstitutionCourseMainVC alloc] init];
        vc.institutionID = [NSString stringWithFormat:@"%@",cell.couponModel.mhm_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)couponDirectExchange:(NSString *)couponCode {
    if (SWNOTEmptyStr(couponCode)) {
        [Net_API requestPOSTWithURLStr:[Net_Path couponDirectExchangeNet] WithAuthorization:nil paramDic:@{@"id":couponCode} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                [self getCouponList];
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"卡券使用失败"];
        }];
    }
}

@end
