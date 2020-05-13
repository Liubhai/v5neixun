//
//  MyRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyRootViewController.h"
#import "Api_Config.h"
#import "V5_Constant.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "Net_Path.h"
//页面跳转
#import "PersonalInformationVC.h"
#import "SetingViewController.h"
#import "MenberRootVC.h"
#import "OrderRootVC.h"
#import "MyBalanceVC.h"
#import "MyScoreVC.h"
#import "MyIncomeVC.h"
#import "MycouponsRootVC.h"
#import "LearnRecordVC.h"
#import "MyCollectCourseVC.h"
// 板块儿视图
#import "MyCenterOrderView.h"
#import "MyCenterBalanceView.h"
#import "MyCenterUserInfoView.h"

//
#import "MyCenterTypeOneCell.h"
#import "MyCenterTypeTwoCell.h"
#import "UIImage+Util.h"

@interface MyRootViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MyCenterUserInfoViewDelegate,MyCenterOrderViewDelegate,MyCenterBalanceViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MyCenterOrderView *mycenterOrderView;
@property (strong, nonatomic) MyCenterBalanceView *myCenterBalanceView;
@property (strong, nonatomic) MyCenterUserInfoView *myCenterUserInfoView;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) NSMutableArray *iconArray;


@property (strong, nonatomic) UIButton *setButton;

@end

@implementation MyRootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _cellLayoutType = @"2";
//    _titleImage.hidden = YES;
    _iconArray = [NSMutableArray new];
    [_iconArray addObjectsFromArray:@[@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"},@{@"image":@"pre_list_kaquan",@"title":@"我的卡券"}]];
    _titleImage.alpha = 0;
    _titleLabel.text = @"个人中心";
    [_leftButton setImage:[Image(@"pre_nav_home") converToOtherColor:EdlineV5_Color.textFirstColor] forState:0];
    [_rightButton setImage:Image(@"pre_nav_mes_blue") forState:0];
    _rightButton.hidden = NO;
    _setButton = [[UIButton alloc] initWithFrame:CGRectMake(_rightButton.left - 44, _rightButton.top, 44, 44)];
    [_setButton setImage:Image(@"pre_nav_set_blue") forState:0];
    [_setButton addTarget:self action:@selector(setingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_setButton];
    
    [self makeHeaderView];
    [self makeTableView];
    _tableView.tableHeaderView = _headerView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserInfo)];
    [_tableView reloadData];
    
    [self.view bringSubviewToFront:_titleImage];
    
    [_tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfo) name:@"reloadUserInfo" object:nil];
}

- (void)reloadUserInfo {
    // test
    [_myCenterUserInfoView setUserInfo:nil];
    [_tableView reloadData];
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    _myCenterUserInfoView = [[MyCenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 234)];
    _myCenterUserInfoView.delegate = self;
    [_headerView addSubview:_myCenterUserInfoView];
    _mycenterOrderView = [[MyCenterOrderView alloc] initWithFrame:CGRectMake(15, _myCenterUserInfoView.bottom - 80, MainScreenWidth - 30, 140)];
    _mycenterOrderView.delegate = self;
    [_headerView addSubview:_mycenterOrderView];
    _myCenterBalanceView = [[MyCenterBalanceView alloc] initWithFrame:CGRectMake(0, _mycenterOrderView.bottom + 10, MainScreenWidth, 90)];
    _myCenterBalanceView.delegate = self;
    [_headerView addSubview:_myCenterBalanceView];
    [_headerView setHeight:_myCenterBalanceView.bottom];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT)];
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

// MARK: - table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_cellLayoutType isEqualToString:@"1"]) {
        return 1;
    } else if ([_cellLayoutType isEqualToString:@"2"]) {
        return _iconArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_cellLayoutType isEqualToString:@"1"]) {
        static NSString *reuse = @"centerOneCell";
        MyCenterTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[MyCenterTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setMyCenterClassifyInfo:_iconArray];
        return cell;
    } else if ([_cellLayoutType isEqualToString:@"2"]) {
        static NSString *reuse = @"centerTwoCell";
        MyCenterTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[MyCenterTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setMyCenterTypeTwoCellInfo:_iconArray[indexPath.row]];
        return cell;
    } else {
        static NSString *reuse = @"centerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_cellLayoutType isEqualToString:@"1"]) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else if ([_cellLayoutType isEqualToString:@"2"]) {
        return 50.0;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LearnRecordVC *vc = [[LearnRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if (indexPath.row == 1) {
        MyCollectCourseVC *vc = [[MyCollectCourseVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    MycouponsRootVC *vc = [[MycouponsRootVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > - MACRO_UI_STATUSBAR_HEIGHT && scrollView.contentOffset.y < MACRO_UI_STATUSBAR_HEIGHT) {
//        [UIView animateWithDuration:0.25 animations:^{
//            _titleImage.alpha = (0.017) * (scrollView.contentOffset.y + MACRO_UI_STATUSBAR_HEIGHT);
//        }];
//    }
    if (scrollView.contentOffset.y > MACRO_UI_STATUSBAR_HEIGHT) {
        _titleImage.alpha = 1;
    }
    if (scrollView.contentOffset.y <= 0) {
        _titleImage.alpha = 0;
    }
}

- (void)leftButtonClick:(id)sender {
    NSLog(@"返回按钮被点击了");
}

- (void)setingButtonClick:(UIButton *)sender {
    SetingViewController *vc = [[SetingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - MyCenterUserInfoViewDelegate(进入个人信息页面)
- (void)goToUserInfoVC {
    if (SWNOTEmptyStr([UserModel oauthToken])) {
        PersonalInformationVC *vc = [[PersonalInformationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [AppDelegate presentLoginNav:self];
    }
}

- (void)goToSetingVC {
    SetingViewController *vc = [[SetingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToMenberCenter {
    MenberRootVC *vc = [[MenberRootVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - MyCenterOrderViewDelegate(进入订单页面)
- (void)goToOrderVC:(UIButton *)sender {
    OrderRootVC *vc = [[OrderRootVC alloc] init];
    if (sender.tag == 0) {
       vc.currentType = @"waiting";
    } else if (sender.tag == 1) {
        vc.currentType = @"cancel";
    } else if (sender.tag == 2) {
        vc.currentType = @"finish";
    } else if (sender.tag == 3) {
        vc.currentType = @"shouhou";
    } else {
        vc.currentType = @"all";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - MyCenterBalanceViewDelegate(进入余额积分等页面)
- (void)jumpToOtherVC:(UIButton *)sender {
    if (sender.tag == 0) {
        MyBalanceVC *vc = [[MyBalanceVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 2) {
        MyScoreVC *vc = [[MyScoreVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 1) {
        MyIncomeVC *vc = [[MyIncomeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getUserInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userCenterInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _userInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                [UserModel saveUid:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"id"]]];
                [UserModel saveUname:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"nick_name"]]];
                [UserModel saveNickName:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"user_name"]]];
                [UserModel savePhone:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"phone"]]];
                [UserModel saveGender:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"gender"]]];
                [self.myCenterBalanceView setBalanceInfo:_userInfo];
                [self reloadUserInfo];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        [self reloadUserInfo];
    }];
}

@end
