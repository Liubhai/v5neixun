//
//  MyCertificateListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/30.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "MyCertificateListVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "OrderScreenViewController.h"
#import "MyCertificateListCell.h"

@interface MyCertificateListVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, OrderScreenViewControllerDelegate> {
    NSInteger page;
    
    // 筛选
    NSString *screenTitle;
    NSString *screenType;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UITextField *institutionSearch;

@end

@implementation MyCertificateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    [_rightButton setImage:[Image(@"lesson_screen_nor") converToMainColor] forState:UIControlStateSelected];
    
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTopSearch];
    [self makeTableView];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_leftButton.right, 0, MainScreenWidth - _rightButton.width - _leftButton.right , 30)];
    _institutionSearch.centerY = _titleLabel.centerY;
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入证书名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = _institutionSearch.height / 2.0;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreOrderList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;//_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"MyCertificateListCell";
    MyCertificateListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MyCertificateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 123 + 12;//[self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getOrderList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(screenType)) {
        [param setObject:screenType forKey:@"date"];
    }
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userOrderList:screenType] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreOrderList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(screenType)) {
        [param setObject:screenType forKey:@"date"];
    }
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userOrderList:screenType] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _rightButton.selected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        [self getOrderList];
        return NO;
    }
    return YES;
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    [_institutionSearch resignFirstResponder];
    if (_rightButton.selected) {
        OrderScreenViewController *vc = [[OrderScreenViewController alloc] init];
        vc.delegate = self;
        vc.screenTitle = screenTitle;
        vc.screenType = screenType;
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
    }
}

- (void)sureChooseOrderScreen:(NSDictionary *)orderScreenInfo {
    if (SWNOTEmptyDictionary(orderScreenInfo)) {
        screenTitle = [NSString stringWithFormat:@"%@",[orderScreenInfo objectForKey:@"screenTitle"]];
        screenType = [NSString stringWithFormat:@"%@",[orderScreenInfo objectForKey:@"screenType"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
        _rightButton.selected = NO;
        //
        [self getOrderList];
    }
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
