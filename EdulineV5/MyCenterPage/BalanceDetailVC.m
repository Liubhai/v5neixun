//
//  BalanceDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BalanceDetailVC.h"
#import "V5_Constant.h"
#import "BalanceDetailCell.h"
#import "Net_Path.h"

@interface BalanceDetailVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation BalanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"明细";
    _dataSource = [NSMutableArray new];
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
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
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"BalanceDetailCell";
    BalanceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[BalanceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setInfoData:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.5;
}

- (void)getFirstData {
    page = 1;
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userBalanceDetailInfo] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
            }
        }
        if (_dataSource.count<10) {
            _tableView.mj_footer.hidden = YES;
        } else {
            _tableView.mj_footer.hidden = NO;
        }
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreData {
    page = page + 1;
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userBalanceDetailInfo] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:pass];
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

@end
