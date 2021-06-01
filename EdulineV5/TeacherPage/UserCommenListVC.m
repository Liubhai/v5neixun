//
//  UserCommenListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "UserCommenListVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "UserListCell.h"

@interface UserCommenListVC ()<UITableViewDelegate, UITableViewDataSource,UserListCellDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation UserCommenListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = _themeString;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _dataSource = [NSMutableArray new];
    page = 1;
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
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreOrderList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"UserListCell";
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setUserInfo:_dataSource[indexPath.row] cellIndexPath:indexPath cellType:[_themeString isEqualToString:@"最近访客"] ? NO : YES];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// MARK: - UserListCellDelegate(关注取消关注按钮点击事件)
- (void)followAndUnFollow:(UIButton *)sender cellIndexPath:(nonnull NSIndexPath *)cellIndexPath {
    if (SWNOTEmptyDictionary(_dataSource[cellIndexPath.row])) {
        NSString *userId = [NSString stringWithFormat:@"%@",[_dataSource[cellIndexPath.row] objectForKey:@"user_id"]];
        if ([[_dataSource[cellIndexPath.row] objectForKey:@"is_follow"] boolValue]) {
            [Net_API requestDeleteWithURLStr:[Net_Path userFollowNet] paramDic:@{@"user_id":userId} Api_key:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource[cellIndexPath.row]];
                        [pass setObject:@"0" forKey:@"is_follow"];
                        [_dataSource replaceObjectAtIndex:cellIndexPath.row withObject:[NSDictionary dictionaryWithDictionary:pass]];
                    }
                }
                [_tableView reloadData];
            } enError:^(NSError * _Nonnull error) {
                
            }];
        } else {
            [Net_API requestPOSTWithURLStr:[Net_Path userFollowNet] WithAuthorization:nil paramDic:@{@"user_id":userId} finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource[cellIndexPath.row]];
                        [pass setObject:@"1" forKey:@"is_follow"];
                        [_dataSource replaceObjectAtIndex:cellIndexPath.row withObject:[NSDictionary dictionaryWithDictionary:pass]];
                    }
                }
                [_tableView reloadData];
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
        
    }
}

- (void)getFirstData {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(_userId)) {
        [param setObject:_userId forKey:@"user_id"];
    }
    NSString *netUlr;
    if ([_themeString isEqualToString:@"我的粉丝"]) {
        netUlr = [Net_Path userFollowListNet];
    } else if ([_themeString isEqualToString:@"我的关注"]) {
        netUlr = [Net_Path userFollowNet];
    } else if ([_themeString isEqualToString:@"最近访客"]) {
        netUlr = [Net_Path userLastVisitorList];
    }
    if (!SWNOTEmptyStr(netUlr)) {
        return;
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:netUlr WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                if ([_themeString isEqualToString:@"最近访客"]) {
//                    [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
//                } else {
//                    [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                }
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                }
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreOrderList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(_userId)) {
        [param setObject:_userId forKey:@"user_id"];
    }
    NSString *netUlr;
    if ([_themeString isEqualToString:@"我的粉丝"]) {
        netUlr = [Net_Path userFollowListNet];
    } else if ([_themeString isEqualToString:@"我的关注"]) {
        netUlr = [Net_Path userFollowNet];
    } else if ([_themeString isEqualToString:@"最近访客"]) {
        netUlr = [Net_Path userLastVisitorList];
    }
    if (!SWNOTEmptyStr(netUlr)) {
        return;
    }
    [Net_API requestGETSuperAPIWithURLStr:netUlr WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
//                if ([_themeString isEqualToString:@"最近访客"]) {
//                    NSArray *pass = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
//                    if (pass.count<10) {
//                        [_tableView.mj_footer endRefreshingWithNoMoreData];
//                    }
//                    [_dataSource addObjectsFromArray:pass];
//                    [_tableView reloadData];
//                } else {
//                    NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                    if (pass.count<10) {
//                        [_tableView.mj_footer endRefreshingWithNoMoreData];
//                    }
//                    [_dataSource addObjectsFromArray:pass];
//                    [_tableView reloadData];
//                }
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
