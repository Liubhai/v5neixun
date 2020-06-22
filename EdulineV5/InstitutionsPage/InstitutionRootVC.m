//
//  InstitutionRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionRootVC.h"
#import "HomePageTeacherCell.h"
#import "HomePageCourseTypeTwoCell.h"
#import "V5_Constant.h"
#import "TeacherListVC.h"
#import "InstitutionListVC.h"
#import "Net_Path.h"
#import "TeacherMainPageVC.h"
#import "InstitutionCourseMainVC.h"

@interface InstitutionRootVC ()<UITableViewDelegate, UITableViewDataSource,HomePageTeacherCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSDictionary *institutionInfo;

@property (strong, nonatomic) NSMutableArray *cateSourceArray;
// 讲师
@property (strong, nonatomic) NSMutableArray *teacherArray;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *topBackImageView;
@property (strong, nonatomic) UIButton *leftBackButton;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *InstitutionLabel;
@property (strong, nonatomic) UILabel *introLabel;

@end

@implementation InstitutionRootVC

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.textColor = [UIColor whiteColor];
    _titleImage.backgroundColor = EdlineV5_Color.themeColor;
    _titleImage.alpha = 0;
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.themeColor;
    _teacherArray = [NSMutableArray new];
    _cateSourceArray = [NSMutableArray new];
    
    [self makeHeaderView];
    [self makeTableView];
    _tableView.tableHeaderView = _topView;
    
    [self.view bringSubviewToFront:_titleImage];
}

- (void)makeHeaderView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT + 20 + 70 + 25)];
    _topView.backgroundColor = [UIColor whiteColor];
    
    _topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT + 20 + 70 + 25)];
    _topBackImageView.backgroundColor = EdlineV5_Color.themeColor;
    _topBackImageView.image = Image(@"study_card_img");
    [_topView addSubview:_topBackImageView];
    
    _leftBackButton = [[UIButton alloc] initWithFrame:_leftButton.frame];
    [_leftBackButton setImage:Image(@"nav_back_white") forState:0];
    [_leftBackButton addTarget:self action:@selector(leftBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_leftBackButton];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MACRO_UI_UPHEIGHT + 20, 70, 70)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 35;
    _faceImageView.image = DefaultImage;
    [_topView addSubview:_faceImageView];
    
    _InstitutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 20, _faceImageView.top + 5, MainScreenWidth - (_faceImageView.right + 20), 23)];
    _InstitutionLabel.font = SYSTEMFONT(16);
    _InstitutionLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_InstitutionLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 20, _InstitutionLabel.bottom + 7.5, MainScreenWidth - (_faceImageView.right + 20), 23)];
    _introLabel.font = SYSTEMFONT(12);
    _introLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_introLabel];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getInstitutionInfo)];
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

// MARK: - tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 56)];
    sectionHead.backgroundColor = [UIColor whiteColor];
    
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 56)];
    themeLabel.font = SYSTEMFONT(19);
    themeLabel.textColor = EdlineV5_Color.textFirstColor;
    if (section == 0) {
        themeLabel.text = @"推荐课程";
    } else if (section == 1) {
        themeLabel.text = @"推荐讲师";
    } else if (section == 2) {
        themeLabel.text = @"推荐资讯";
    }
    [sectionHead addSubview:themeLabel];
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 60, 0, 60, 56)];
    more.tag = section;
    [more setTitle:@"查看全部" forState:0];
    more.titleLabel.font = SYSTEMFONT(14);
    [more setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [more addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHead addSubview:more];
    return sectionHead;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
    return sectionHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"HomePageCourseTypeTwoCelInstitutionl";
        HomePageCourseTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomePageCourseTypeTwoCellInfo:_cateSourceArray];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *reuse = @"HomePageTeacherInstitutionCell";
        HomePageTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setTeacherArrayInfo:_teacherArray];
        cell.delegate = self;
        return cell;
    } else {
        static NSString *reuse = @"homeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else if (indexPath.section == 1) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else {
        return 0.0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > MACRO_UI_STATUSBAR_HEIGHT) {
        _titleImage.alpha = 1;
    }
    if (scrollView.contentOffset.y <= 0) {
        _titleImage.alpha = 0;
    }
}

// MARK: - HomePageTeacherCellDelegate(讲师点击事件)
- (void)goToTeacherMainPage:(NSString *)teacherId {
    TeacherMainPageVC *vc = [[TeacherMainPageVC alloc] init];
    vc.teacherId = teacherId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonClick:(UIButton *)sender {
    if (sender.tag == 1) {
        TeacherListVC *vc = [[TeacherListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 0) {
        InstitutionCourseMainVC *vc = [[InstitutionCourseMainVC alloc] init];
        vc.institutionID = _institutionId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)leftBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getInstitutionInfo {
    if (SWNOTEmptyStr(_institutionId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path institutionMainPageNet:_institutionId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_cateSourceArray removeAllObjects];
                    [_cateSourceArray addObjectsFromArray:responseObject[@"data"][@"course"]];
                    
                    [_teacherArray removeAllObjects];
                    [_teacherArray addObjectsFromArray:responseObject[@"data"][@"teacher"]];
                    
                    _institutionInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    
                    [self setInstitutionInfoData];
                    
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
        }];
    }
}

- (void)setInstitutionInfoData {
    if (SWNOTEmptyDictionary(_institutionInfo)) {
        if ([[_institutionInfo objectForKey:@"code"] integerValue]) {
            [_faceImageView sd_setImageWithURL:EdulineUrlString(_institutionInfo[@"data"][@"info"][@"logo"]) placeholderImage:DefaultImage];
            _InstitutionLabel.text = [NSString stringWithFormat:@"%@",_institutionInfo[@"data"][@"info"][@"title"]];
            _titleLabel.text = [NSString stringWithFormat:@"%@",_institutionInfo[@"data"][@"info"][@"title"]];
            _introLabel.text = [NSString stringWithFormat:@"%@",_institutionInfo[@"data"][@"info"][@"info"]];
        }
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
