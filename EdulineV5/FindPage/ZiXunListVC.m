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

@interface ZiXunListVC ()<TeacherCategoryVCDelegate> {
    NSInteger page;
    NSString *typeString;
}

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
    typeString = @"";
    [self makeTableView];
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

- (void)rightButtonClick:(id)sender {
    TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
    vc.typeString = @"5";
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 选择更换资讯类型代理
- (void)chooseCategoryId:(NSString *)categoryId {
    typeString = categoryId;
    [self.tableView.mj_header beginRefreshing];
}

@end
