//
//  StudyRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyRootVC.h"
#import "StudyTimeCell.h"
#import "StudyLatestCell.h"
#import "StudyCourseCell.h"
#import "V5_Constant.h"
#import "JoinCourseVC.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "Net_Path.h"
#import "LearnRecordVC.h"

@interface StudyRootVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger currentCourseType;
    NSString *dataType;// add加入的优先 learn学习优先
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *studyInfo;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (strong, nonatomic) NSMutableArray *liveArray;
@property (strong, nonatomic) NSMutableArray *classArray;
@property (strong, nonatomic) NSMutableArray *offlineArray;

@property (strong, nonatomic) UIButton *courseBtn;
@property (strong, nonatomic) UIButton *liveBtn;
@property (strong, nonatomic) UIButton *classBtn;
@property (strong, nonatomic) UIButton *offlineBtn;

@property (strong, nonatomic) UIView *changeTypeBackView;
@property (strong, nonatomic) UIButton *changeTypeBtn;

@property (strong, nonatomic) UIView *notLoginView;
@property (strong, nonatomic) UIImageView *notLoginIcon;
@property (strong, nonatomic) UILabel *notLoginLabel;
@property (strong, nonatomic) UIButton *notLoginButton;

@property (strong, nonatomic) UIButton *joinFirstBtn;
@property (strong, nonatomic) UIButton *studyFirstBtn;

@end

@implementation StudyRootVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (SWNOTEmptyStr([UserModel oauthToken])) {
        if (_notLoginView) {
            _notLoginView.hidden = YES;
        }
    } else {
        if (_notLoginView) {
            _notLoginView.hidden = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    currentCourseType = 0;
    dataType = @"add";
    
    _courseArray = [NSMutableArray new];
    _liveArray = [NSMutableArray new];
    _classArray = [NSMutableArray new];
    _offlineArray = [NSMutableArray new];
    
    _titleImage.hidden = YES;
    
    [self makeTableView];
    [self makeNotLoginView];
    if (SWNOTEmptyStr([UserModel oauthToken])) {
        _notLoginView.hidden = YES;
    } else {
        _notLoginView.hidden = NO;
    }
    [_tableView.mj_header beginRefreshing];
}

- (void)makeNotLoginView {
    
    _notLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT)];
    _notLoginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_notLoginView];
    
    _notLoginIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0 - 71, _notLoginView.height/2.0 - 25 - 35 - 106, 142, 106)];
    _notLoginIcon.image = Image(@"empty_img");
    [_notLoginView addSubview:_notLoginIcon];
    
    _notLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _notLoginIcon.bottom + 15, MainScreenWidth, 20)];
    _notLoginLabel.text = @"登录后查看更多内容~";
    _notLoginLabel.font = SYSTEMFONT(14);
    _notLoginLabel.textColor = EdlineV5_Color.textSecendColor;
    _notLoginLabel.textAlignment = NSTextAlignmentCenter;
    [_notLoginView addSubview:_notLoginLabel];
    
    _notLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _notLoginLabel.bottom + 50, 110, 36)];
    [_notLoginButton setTitle:@"登录" forState:0];
    [_notLoginButton setTitleColor:[UIColor whiteColor] forState:0];
    _notLoginButton.titleLabel.font = SYSTEMFONT(16);
    _notLoginButton.backgroundColor = EdlineV5_Color.themeColor;
    _notLoginButton.layer.masksToBounds = YES;
    _notLoginButton.layer.cornerRadius = 18;
    _notLoginButton.centerX = _notLoginIcon.centerX;
    [_notLoginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_notLoginView addSubview:_notLoginButton];
}

- (void)makeChangeTypeBackView {
    
    CGRect btn111 = [self.tableView rectForHeaderInSection:2];
    CGPoint btnPoint = CGPointMake(btn111.origin.x + MainScreenWidth - 15 - 123, btn111.origin.y + 16 + 30 + 5 - self.tableView.contentOffset.y);
    
    if (!_changeTypeBackView) {
        _changeTypeBackView = [[UIView alloc] init];
        _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
        
        _changeTypeBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _changeTypeBackView.layer.cornerRadius = 2;
        _changeTypeBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        _changeTypeBackView.layer.shadowOffset = CGSizeMake(0,1);
        _changeTypeBackView.layer.shadowOpacity = 1;
        _changeTypeBackView.layer.shadowRadius = 5;
        
        _joinFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, _changeTypeBackView.width, 32)];
        _joinFirstBtn.tag = 10;
        [_joinFirstBtn setTitle:@"最近加入的优先" forState:0];
        [_joinFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [_joinFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        _joinFirstBtn.titleLabel.font = SYSTEMFONT(13);
        [_joinFirstBtn addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:_joinFirstBtn];
        
        _studyFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _joinFirstBtn.bottom, _changeTypeBackView.width, 32)];
        _studyFirstBtn.tag = 11;
        [_studyFirstBtn setTitle:@"最近学习的优先" forState:0];
        [_studyFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [_studyFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        _studyFirstBtn.titleLabel.font = SYSTEMFONT(13);
        [_studyFirstBtn addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:_studyFirstBtn];
        _changeTypeBackView.hidden = YES;
        [self.view addSubview:_changeTypeBackView];
    }
    if ([dataType isEqualToString:@"add"]) {
        _joinFirstBtn.selected = YES;
        _studyFirstBtn.selected = NO;
    } else {
        _joinFirstBtn.selected = NO;
        _studyFirstBtn.selected = YES;
    }
    _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
    _changeTypeBackView.hidden = !_changeTypeBackView.hidden;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_LIUHAI_HEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStudyInfo)];
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (currentCourseType == 0) {
            return _courseArray.count;
        } else if (currentCourseType == 1) {
            return _liveArray.count;
        } else if (currentCourseType == 2) {
            return _classArray.count;
        } else {
            return _offlineArray.count;
        }
    } else if (section == 1) {
        if (SWNOTEmptyDictionary(_studyInfo)) {
            if ([[[_studyInfo objectForKey:@"data"] allKeys] count]) {
                return 1;
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"StudyTimeCell";
        StudyTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell studyPageTimeInfo:_studyInfo];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *reuse = @"StudyLatestCell";
        StudyLatestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyLatestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setLatestLearnInfo:[[_studyInfo objectForKey:@"data"] objectForKey:@"latest"]];
        return cell;
    } else {
        static NSString *reuse = @"StudyCourseCell";
        StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        if (currentCourseType == 0) {
            [cell setStudyCourseInfo:_courseArray[indexPath.row]];
        } else if (currentCourseType == 1) {
            [cell setStudyCourseInfo:_liveArray[indexPath.row]];
        } else if (currentCourseType == 2) {
            [cell setStudyCourseInfo:_classArray[indexPath.row]];
        } else {
            [cell setStudyCourseInfo:_offlineArray[indexPath.row]];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        theme.text = @"最近在学";
        theme.font = SYSTEMFONT(16);
        theme.textColor = EdlineV5_Color.textFirstColor;
        [view addSubview:theme];
        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 40)];
        [moreButton setTitle:@"更多" forState:0];
        [moreButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        moreButton.titleLabel.font = SYSTEMFONT(14);
        [moreButton addTarget:self action:@selector(jumpLearnRecord:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreButton];
        
        return view;
    } else {
        //study_shaixuan
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10 + 28 + 13 + 22 + 20)];
        view.backgroundColor = [UIColor whiteColor];
        // 10 28 13 22 20 // 16
        
        UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 22)];
        theme.text = @"加入的课程";
        theme.font = SYSTEMFONT(16);
        theme.textColor = EdlineV5_Color.textFirstColor;
        [view addSubview:theme];
        
        if (!_changeTypeBtn) {
            _changeTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 5 - 30, 0, 30, 30)];
            _changeTypeBtn.centerY = theme.centerY;
            [_changeTypeBtn setImage:Image(@"study_shaixuan") forState:0];
            [_changeTypeBtn addTarget:self action:@selector(makeChangeTypeBackView) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:_changeTypeBtn];
        
        NSArray *courseTypeArray = @[@"点播",@"直播",@"专辑",@"面授"];
        for (int i = 0; i < courseTypeArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 77 * i, theme.bottom + 13, 65, 28)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:courseTypeArray[i] forState:0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            if (i == currentCourseType) {
                btn.selected = YES;
                btn.backgroundColor = EdlineV5_Color.themeColor;
            } else {
                btn.selected = NO;
                [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
            }
            if (i == 0) {
                _courseBtn = btn;
            } else if (i == 1) {
                _liveBtn = btn;
            } else if (i == 2) {
                _classBtn = btn;
            } else if (i == 3) {
                _offlineBtn = btn;
            }
        }
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
        view.backgroundColor = EdlineV5_Color.fengeLineColor;
        return view;
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 18 * 3)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 17, 80, 20)];
        [moreBtn setImage:[Image(@"study_more") converToMainColor] forState:0];
        [moreBtn setTitle:@"查看更多" forState:0];
        moreBtn.titleLabel.font = SYSTEMFONT(13);
        [moreBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:moreBtn];
        moreBtn.centerX = MainScreenWidth / 2.0;
        [moreBtn addTarget:self action:@selector(moreJoinCourseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreBtn];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 40;
    } else {
        return 10 + 28 + 13 + 22 + 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 10;
    } else {
        return 18 * 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else if (indexPath.section == 1) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else {
        return 106;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect btn111 = [self.tableView rectForHeaderInSection:2];
//    CGPoint btnPoint = CGPointMake(btn111.origin.x + MainScreenWidth - 15 - 123, btn111.origin.y + 16 + 30 + 5 - scrollView.contentOffset.y);
//    _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
    if (_changeTypeBackView) {
        _changeTypeBackView.hidden = YES;
    }
}

- (void)typeBtnClick:(UIButton *)sender {
    if (sender == _courseBtn) {
        _courseBtn.selected = YES;
        [_courseBtn setBackgroundColor:EdlineV5_Color.themeColor];
        _liveBtn.selected = NO;
        [_liveBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _classBtn.selected = NO;
        [_classBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _offlineBtn.selected = NO;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        currentCourseType = 0;
    } else if (sender == _liveBtn) {
        _courseBtn.selected = NO;
        [_courseBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _liveBtn.selected = YES;
        [_liveBtn setBackgroundColor:EdlineV5_Color.themeColor];
        _classBtn.selected = NO;
        [_classBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _offlineBtn.selected = NO;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        currentCourseType = 1;
    } else if (sender == _classBtn) {
        _courseBtn.selected = NO;
        [_courseBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _liveBtn.selected = NO;
        [_liveBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _classBtn.selected = YES;
        [_classBtn setBackgroundColor:EdlineV5_Color.themeColor];
        _offlineBtn.selected = NO;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        currentCourseType = 2;
    } else if (sender == _offlineBtn) {
        _courseBtn.selected = NO;
        [_courseBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _liveBtn.selected = NO;
        [_liveBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _classBtn.selected = NO;
        [_classBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _offlineBtn.selected = YES;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.themeColor];
        currentCourseType = 3;
    }
    [_tableView reloadData];
}

- (void)changeTypeButtonClick:(UIButton *)sender {
    _changeTypeBackView.hidden = YES;
    if (sender == _joinFirstBtn) {
        if ([dataType isEqualToString:@"add"]) {
            return;
        }
        dataType = @"add";
        _joinFirstBtn.selected = YES;
        _studyFirstBtn.selected = NO;
    } else {
        if ([dataType isEqualToString:@"learn"]) {
            return;
        }
        dataType = @"learn";
        _joinFirstBtn.selected = NO;
        _studyFirstBtn.selected = YES;
    }
    [self getStudyInfo];
}

- (void)jumpLearnRecord:(UIButton *)sender {
    LearnRecordVC *vc = [[LearnRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreJoinCourseButtonClick:(UIButton *)sender {
    JoinCourseVC *vc = [[JoinCourseVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginButtonClick:(UIButton *)sender {
    [AppDelegate presentLoginNav:self];
}

- (void)getStudyInfo {
    if (SWNOTEmptyStr([UserModel oauthToken])) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyMainPageData] WithAuthorization:nil paramDic:@{@"order":@"add"} finish:^(id  _Nonnull responseObject) {
            if ([_tableView.mj_header isRefreshing]) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _studyInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [_courseArray removeAllObjects];
                    [_liveArray removeAllObjects];
                    [_offlineArray removeAllObjects];
                    [_classArray removeAllObjects];//video
                    [_courseArray addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"course"] objectForKey:@"video"]];
                    [_liveArray addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"course"] objectForKey:@"live"]];
                    [_offlineArray addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"course"] objectForKey:@"offline"]];
                    [_classArray addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"course"] objectForKey:@"classes"]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            if ([_tableView.mj_header isRefreshing]) {
                [_tableView.mj_header endRefreshing];
            }
        }];
    }
}

@end
