//
//  AddressListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/25.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "AddressListViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"

@interface AddressListViewController ()<UITableViewDelegate, UITableViewDataSource, AddressTableViewCellDelegate> {
    NSInteger page;
    BOOL shouldLoad;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *headerView;// 用作table头部视图

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation AddressListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (shouldLoad) {
        [self getFirstData];
    }
    shouldLoad = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"收货地址";
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.rightButton setTitle:@"添加" forState:0];
    [self.rightButton setImage:nil forState:0];
    [self.rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    self.lineTL.hidden = NO;
    self.lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    _dataSource = [[NSMutableArray alloc] init];
    
    [self makeHeaderView];
    [self makeTableView];
    [self makeDownView];
    // Do any additional setup after loading the view.
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 6)];
    _headerView.backgroundColor = EdlineV5_Color.backColor;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataList)];
    _tableView.mj_footer.hidden = YES;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView reloadData];
    [_tableView.mj_header beginRefreshing];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellReuse = @"AddressTableViewCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (!cell) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuse];
    }
    [cell setAddressInfo:_dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145 + 6 * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_fromCenter) {
        AddAddressViewController *vc = [[AddAddressViewController alloc] init];
        vc.currentAddressInfo = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.addressSelect(_dataSource[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// MARK: - 获取第一页的数据
- (void)getFirstData {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path addressListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                    _tableView.mj_footer.hidden = NO;
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

// MARK: - 上拉加载更多数据
- (void)getMoreDataList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path addressListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
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

// MARK: - cell代理AddressTableViewCellDelegate
- (void)changeDefaultAddress:(AddressTableViewCell *)cell {
    if (SWNOTEmptyDictionary(cell.currentAddressInfo)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:[NSString stringWithFormat:@"%@",cell.currentAddressInfo[@"id"]] forKey:@"id"];
        [param setObject:[[NSString stringWithFormat:@"%@",cell.currentAddressInfo[@"default"]] integerValue] ? @"0" : @"1" forKey:@"default"];
        [Net_API requestPUTWithURLStr:[Net_Path addressSetDefaultNet] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [self getFirstData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)deleteAddress:(AddressTableViewCell *)cell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除该地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (SWNOTEmptyDictionary(cell.currentAddressInfo)) {
            NSMutableDictionary *param = [NSMutableDictionary new];
            NSString *addId = [NSString stringWithFormat:@"%@",cell.currentAddressInfo[@"id"]];
            NSDictionary *addInfo = [NSDictionary dictionaryWithDictionary:cell.currentAddressInfo];
            [param setObject:addId forKey:@"id"];
            
            [Net_API requestDeleteWithURLStr:[Net_Path addressDelateNet] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:responseObject[@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        [self getFirstData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAddressViewUI" object:nil userInfo:@{@"type":@"delete",@"addressInfo":addInfo}];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textFirstColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeAddress:(AddressTableViewCell *)cell {
    if (SWNOTEmptyDictionary(cell.currentAddressInfo)) {
        AddAddressViewController *vc = [[AddAddressViewController alloc] init];
        vc.currentAddressInfo = [NSDictionary dictionaryWithDictionary:cell.currentAddressInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)rightButtonClick:(id)sender {
    AddAddressViewController *vc = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 顶部按钮优化放在底部
- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6.5, 320, 36)];
    [_submitButton setTitle:@"新建收货地址" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerX = _bottomView.width/2.0;
    [_submitButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
}

// MARK: - 添加新地址
- (void)addAddress:(UIButton *)sender {
    AddAddressViewController *vc = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
