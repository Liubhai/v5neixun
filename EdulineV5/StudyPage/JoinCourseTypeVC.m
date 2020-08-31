//
//  JoinCourseTypeVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "JoinCourseTypeVC.h"
#import "StudyCourseCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "CourseMainViewController.h"

@interface JoinCourseTypeVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
    NSString *typeString;//状态【all：全部；not_started：未开始；learning：学习中；finished：已完成；】
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation JoinCourseTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    page = 1;
    typeString = @"all";
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseStudyTypeProgressChange:) name:@"courseStudyTypeProgressChange" object:nil];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
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
    static NSString *reuse = @"StudyCourseCell";
    StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[StudyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setStudyCourseInfo:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"section_level"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getFirstData {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [param setObject:typeString forKey:@"learn_status"];
    // 大类型
    if (SWNOTEmptyStr(_courseType)) {
        [param setObject:_courseType forKey:@"course_type"];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyMainPageJoinCourseList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
    [param setObject:typeString forKey:@"learn_status"];
    // 大类型
    if (SWNOTEmptyStr(_courseType)) {
        [param setObject:_courseType forKey:@"course_type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyMainPageJoinCourseList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

- (void)courseStudyTypeProgressChange:(NSNotification *)notice {
    if (SWNOTEmptyDictionary(notice.userInfo)) {
        typeString = [notice.userInfo objectForKey:@"StudyTypeProgress"];
        NSString *currentType = [NSString stringWithFormat:@"%@",[notice.userInfo objectForKey:@"currentType"]];
        [self getFirstData];
//        if ([currentType isEqualToString:_courseType]) {
//            [self getFirstData];
//        }
    }
}

@end
