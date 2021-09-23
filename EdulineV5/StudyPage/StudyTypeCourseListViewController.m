//
//  StudyTypeCourseListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "StudyTypeCourseListViewController.h"
#import "Net_Path.h"
#import "EmptyCell.h"
#import "StudyCourseCell.h"
#import "CourseMainViewController.h"

@interface StudyTypeCourseListViewController () {
    NSInteger page;
    BOOL emptyData;
    NSInteger outdateIndex;
}

@end

@implementation StudyTypeCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    outdateIndex = 3;
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    [self addTableView];
    [self getFirstStudyCourseData];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreStudyCourseData)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScreenTypeNotice:) name:@"getFirstStudyCourseData" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    emptyData = SWNOTEmptyArr(_dataSource) ? NO : YES;
    return SWNOTEmptyArr(_dataSource) ? _dataSource.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyData) {
        static NSString *reuse = @"EmptyCell";
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[EmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    } else {
        static NSString *reuse = @"StudyCourseCell";
        StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setStudyCourseInfo:_dataSource[indexPath.row] showOutDate:outdateIndex == indexPath.row ? YES : NO isOutDate:indexPath.row >= outdateIndex ? YES : NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyData) {
        return 150;
    }
    if (outdateIndex == indexPath.row) {
        return 106 + 5 + 16 + 5;
    }
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyData) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= outdateIndex) {
        return;;
    }
    NSDictionary *info = _dataSource[indexPath.row];
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[info objectForKey:@"section_level"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc) {
            if (self.vc.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.vc.canScroll = YES;
            }
        }
    }
}

- (void)getFirstStudyCourseData {
//    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(page) forKey:@"page"];
//    [param setObject:@"10" forKey:@"count"];
    [param setObject:_courseType forKey:@"course_type"];
    [param setObject:_screenType forKey:@"order"];
//    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyMainPageJoinCourseList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
//        if (_tableView.mj_header.refreshing) {
//            [_tableView.mj_header endRefreshing];
//        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"normal"]];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"expired"]];
//                if (_dataSource.count<10) {
//                    _tableView.mj_footer.hidden = YES;
//                } else {
//                    _tableView.mj_footer.hidden = NO;
//                    [_tableView.mj_footer setState:MJRefreshStateIdle];
//                }
//                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
//        if (_tableView.mj_header.refreshing) {
//            [_tableView.mj_header endRefreshing];
//        }
    }];
}

//- (void)getMoreStudyCourseData {
//    page = page + 1;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(page) forKey:@"page"];
//    [param setObject:@"10" forKey:@"count"];
//    [param setObject:_courseType forKey:@"course_type"];
//    [param setObject:_screenType forKey:@"order"];
//    [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyMainPageJoinCourseList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
//        if (_tableView.mj_footer.isRefreshing) {
//            [_tableView.mj_footer endRefreshing];
//        }
//        if (SWNOTEmptyDictionary(responseObject)) {
//            if ([[responseObject objectForKey:@"code"] integerValue]) {
//                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                if (pass.count<10) {
//                    [_tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [_dataSource addObjectsFromArray:pass];
//                [_tableView reloadData];
//            }
//        }
//    } enError:^(NSError * _Nonnull error) {
//        page--;
//        if (_tableView.mj_footer.isRefreshing) {
//            [_tableView.mj_footer endRefreshing];
//        }
//    }];
//}

- (void)changeScreenTypeNotice:(NSNotification *)notice {
    NSDictionary *pass = notice.userInfo;
    if (SWNOTEmptyDictionary(pass)) {
        _screenType = [NSString stringWithFormat:@"%@",pass[@"dataType"]];
        [self getFirstStudyCourseData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
