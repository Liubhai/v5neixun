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
#import "V5_UserModel.h"
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
#import "TeacherApplyVC.h"
#import "InstitutionApplyVC.h"
#import "MyRecommendViewController.h"
#import "MessageRootVC.h"
#import "ClassCourseListVC.h"
#import "MyTeachingRootVC.h"
#import "RegisterAndForgetPwVC.h"
// 板块儿视图
#import "MyCenterOrderView.h"
#import "MyCenterBalanceView.h"
#import "MyCenterUserInfoView.h"

//
#import "MyCenterTypeOneCell.h"
#import "MyCenterTypeTwoCell.h"
#import "UIImage+Util.h"
#import "NSObject+PYThemeExtension.h"

@interface MyRootViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MyCenterUserInfoViewDelegate,MyCenterOrderViewDelegate,MyCenterBalanceViewDelegate,MyCenterTypeOneCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MyCenterOrderView *mycenterOrderView;
@property (strong, nonatomic) MyCenterBalanceView *myCenterBalanceView;
@property (strong, nonatomic) MyCenterUserInfoView *myCenterUserInfoView;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) NSMutableArray *iconArray;


@property (strong, nonatomic) UIButton *setButton;
@property (strong, nonatomic) UILabel *redLabel;

@end

@implementation MyRootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    _titleImage.hidden = YES;
    _iconArray = [NSMutableArray new];
    _titleImage.alpha = 0;
    _titleLabel.text = @"个人中心";
    [_leftButton setImage:[Image(@"pre_nav_home") converToOtherColor:EdlineV5_Color.textFirstColor] forState:0];
    _leftButton.hidden = YES;
    [_rightButton setImage:Image(@"pre_nav_mes_blue") forState:0];
    _rightButton.hidden = NO;
    
    _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _redLabel.layer.masksToBounds = YES;
    _redLabel.layer.cornerRadius = _redLabel.height / 2.0;
    _redLabel.backgroundColor = EdlineV5_Color.faildColor;
    _redLabel.hidden = YES;
    _redLabel.center = CGPointMake(_rightButton.width / 2.0 + 10, _rightButton.height / 2.0 - 10);
    [_rightButton addSubview:_redLabel];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:@"reloadUserInfo" object:nil];
}

- (void)reloadUserInfo {
    // test
    [_myCenterUserInfoView setUserInfo:nil];
    [_tableView reloadData];
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _myCenterUserInfoView = [[MyCenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 234 + MACRO_UI_LIUHAI_HEIGHT)];
    _myCenterUserInfoView.delegate = self;
    [_headerView addSubview:_myCenterUserInfoView];
    _mycenterOrderView = [[MyCenterOrderView alloc] initWithFrame:CGRectMake(15, _myCenterUserInfoView.bottom - 80, MainScreenWidth - 30, 140)];
    _mycenterOrderView.delegate = self;
    [_headerView addSubview:_mycenterOrderView];
    _myCenterBalanceView = [[MyCenterBalanceView alloc] initWithFrame:CGRectMake(0, _mycenterOrderView.bottom + 10, MainScreenWidth, SWNOTEmptyStr([V5_UserModel oauthToken]) ? 90 : 0)];
    _myCenterBalanceView.hidden = SWNOTEmptyStr([V5_UserModel oauthToken]) ? NO : YES;
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
    if ([PROFILELAYOUT isEqualToString:@"1"]) {
        return _iconArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([PROFILELAYOUT isEqualToString:@"1"]) {
        static NSString *reuse = @"centerTwoCell";
        MyCenterTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[MyCenterTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setMyCenterTypeTwoCellInfo:_iconArray[indexPath.row]];
        return cell;
    } else {
        static NSString *reuse = @"centerOneCell";
        MyCenterTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[MyCenterTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        cell.delegate = self;
        [cell setMyCenterClassifyInfo:_iconArray];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([PROFILELAYOUT isEqualToString:@"1"]) {
        return 50.0;
    } else {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if ([PROFILELAYOUT isEqualToString:@"1"]) {
        NSString *iconKey = [NSString stringWithFormat:@"%@",[_iconArray[indexPath.row] objectForKey:@"key"]];
        if ([iconKey isEqualToString:@"wenda"]) {
            
        } else if ([iconKey isEqualToString:@"comment"]) {
            
        } else if ([iconKey isEqualToString:@"note"]) {
            
        } else if ([iconKey isEqualToString:@"collection"]) {
            MyCollectCourseVC *vc = [[MyCollectCourseVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([iconKey isEqualToString:@"record"]) {
            LearnRecordVC *vc = [[LearnRecordVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([iconKey isEqualToString:@"doc"]) {
            
        } else if ([iconKey isEqualToString:@"storage"]) {
            
        } else if ([iconKey isEqualToString:@"vip"]) {
            
        } else if ([iconKey isEqualToString:@"coupon"]) {
            MycouponsRootVC *vc = [[MycouponsRootVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([iconKey isEqualToString:@"exchange"]) {
            
        } else if ([iconKey isEqualToString:@"subordinate"]) {
            MyRecommendViewController *vc = [[MyRecommendViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([iconKey isEqualToString:@"teacher"]) {
            if (SWNOTEmptyDictionary(_userInfo)) {
                NSString *userSchoolId = [NSString stringWithFormat:@"%@",[[[_userInfo objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"mhm_id"]];
                if (SWNOTEmptyStr(userSchoolId)) {
                    if (SWNOTEmptyStr([V5_UserModel userPhone])) {
                        if ([V5_UserModel userPhone].length > 5) {
                            TeacherApplyVC *vc = [[TeacherApplyVC alloc] init];
                            vc.userSchoolId = userSchoolId;
                            [self.navigationController pushViewController:vc animated:YES];
                            return;
                        }
                    }
                    [self needSetUserInfoPhone];
//                    RegisterAndForgetPwVC *vc = [[RegisterAndForgetPwVC alloc] init];
//                    vc.changePhone = YES;
//                    vc.hasPhone = NO;
//                    vc.oldPhone = NO;
//                    vc.topTitle = @"*应《中华人民共和国网络安全法》要求，为了更好保障您的账号安全，请绑定您的手机号！";
//                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self showHudInView:self.view showHint:@"用户信息未包含所属机构信息,不能进行讲师认证"];
                }
            } else {
                [self showHudInView:self.view showHint:@"用户信息未包含所属机构信息,不能进行讲师认证"];
            }
        } else if ([iconKey isEqualToString:@"school"]) {
            if (SWNOTEmptyStr([V5_UserModel userPhone])) {
                if ([V5_UserModel userPhone].length > 5) {
                   InstitutionApplyVC *vc = [[InstitutionApplyVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
            }
            [self needSetUserInfoPhone];
//            RegisterAndForgetPwVC *vc = [[RegisterAndForgetPwVC alloc] init];
//            vc.changePhone = YES;
//            vc.hasPhone = NO;
//            vc.oldPhone = NO;
//            vc.topTitle = @"*应《中华人民共和国网络安全法》要求，为了更好保障您的账号安全，请绑定您的手机号！";
//            [self.navigationController pushViewController:vc animated:YES];
        } else if ([iconKey isEqualToString:@"address"]) {
            
        } else if ([iconKey isEqualToString:@"my_classes"]) {
            ClassCourseListVC *vc = [[ClassCourseListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([iconKey isEqualToString:@"my_teach"]) {
            MyTeachingRootVC *vc = [[MyTeachingRootVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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

- (void)rightButtonClick:(id)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    MessageRootVC *vc = [[MessageRootVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setingButtonClick:(UIButton *)sender {
    SetingViewController *vc = [[SetingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: -
- (void)jumpToOtherPage:(UIButton *)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    NSString *iconKey = [NSString stringWithFormat:@"%@",[_iconArray[sender.tag - 66] objectForKey:@"key"]];
    if ([iconKey isEqualToString:@"wenda"]) {
        
    } else if ([iconKey isEqualToString:@"comment"]) {
        
    } else if ([iconKey isEqualToString:@"note"]) {
        
    } else if ([iconKey isEqualToString:@"collection"]) {
        MyCollectCourseVC *vc = [[MyCollectCourseVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([iconKey isEqualToString:@"record"]) {
        LearnRecordVC *vc = [[LearnRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([iconKey isEqualToString:@"doc"]) {
        
    } else if ([iconKey isEqualToString:@"storage"]) {
        
    } else if ([iconKey isEqualToString:@"vip"]) {
        
    } else if ([iconKey isEqualToString:@"coupon"]) {
        MycouponsRootVC *vc = [[MycouponsRootVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([iconKey isEqualToString:@"exchange"]) {
        
    } else if ([iconKey isEqualToString:@"subordinate"]) {
        MyRecommendViewController *vc = [[MyRecommendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([iconKey isEqualToString:@"teacher"]) {
        if (SWNOTEmptyDictionary(_userInfo)) {
            NSString *userSchoolId = [NSString stringWithFormat:@"%@",[[[_userInfo objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"mhm_id"]];
            if (SWNOTEmptyStr(userSchoolId)) {
                TeacherApplyVC *vc = [[TeacherApplyVC alloc] init];
                vc.userSchoolId = userSchoolId;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self showHudInView:self.view showHint:@"用户信息未包含所属机构信息,不能进行讲师认证"];
            }
        } else {
            [self showHudInView:self.view showHint:@"用户信息未包含所属机构信息,不能进行讲师认证"];
        }
    } else if ([iconKey isEqualToString:@"school"]) {
        InstitutionApplyVC *vc = [[InstitutionApplyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([iconKey isEqualToString:@"address"]) {
        
    } else if ([iconKey isEqualToString:@"my_classes"]) {
        ClassCourseListVC *vc = [[ClassCourseListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([iconKey isEqualToString:@"my_teach"]) {
        MyTeachingRootVC *vc = [[MyTeachingRootVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: - MyCenterUserInfoViewDelegate(进入个人信息页面)
- (void)goToUserInfoVC {
    if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
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
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    MenberRootVC *vc = [[MenberRootVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToMessageVC {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    MessageRootVC *vc = [[MessageRootVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - MyCenterOrderViewDelegate(进入订单页面)
- (void)goToOrderVC:(UIButton *)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
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
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
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
                [V5_UserModel saveUid:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"id"]]];
                [V5_UserModel saveUname:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"nick_name"]]];
                [V5_UserModel saveNickName:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"user_name"]]];
                [V5_UserModel savePhone:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"phone"]]];
                [V5_UserModel saveGender:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"gender"]]];
                [V5_UserModel saveAvatar:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"avatar_url"]]];
                [V5_UserModel saveVipStatus:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"vip_status"]]];
                [V5_UserModel saveIntro:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"signature"]]];
                [V5_UserModel saveNeed_set_password:[[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"need_set_password"]] boolValue]];
                [V5_UserModel saveNeed_set_paypwd:[[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"need_set_paypwd"]] boolValue]];
                
                [_iconArray removeAllObjects];
                NSArray *listArray = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"list"]];
                for (int i = 0; i<listArray.count; i++) {
                    if (SWNOTEmptyArr([listArray[i] objectForKey:@"list"])) {
                        [_iconArray addObjectsFromArray:[listArray[i] objectForKey:@"list"]];
                    }
                }
                NSString *notifyCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"notify"]];
                if (notifyCount.integerValue > 0) {
                    _redLabel.hidden = NO;
                    _myCenterUserInfoView.redLabel.hidden = NO;
                } else {
                    _redLabel.hidden = YES;
                    _myCenterUserInfoView.redLabel.hidden = YES;
                }
                _myCenterBalanceView.frame = CGRectMake(0, _mycenterOrderView.bottom + 10, MainScreenWidth, SWNOTEmptyStr([V5_UserModel oauthToken]) ? 90 : 0);
                _myCenterBalanceView.hidden = SWNOTEmptyStr([V5_UserModel oauthToken]) ? NO : YES;
                [_headerView setHeight:_myCenterBalanceView.bottom];
                [self.myCenterBalanceView setBalanceInfo:_userInfo];
                _tableView.tableHeaderView = _headerView;
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

- (void)needSetUserInfoPhone {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"应《中华人民共和国网络安全法》要求，为了更好保障您的账号安全，请前往个人信息绑定您的手机号！" message:@"是否去绑定手机号?" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PersonalInformationVC *vc = [[PersonalInformationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:loginAction];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
