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
#import "CourseDetailPlayVC.h"
#import "FaceVerifyViewController.h"
#import "V5_UserModel.h"

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
    outdateIndex = 0;
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
        [self showHudInView:self.view showHint:@"课程已过期"];
        return;
    }
    
    if ([ShowUserFace isEqualToString:@"1"]) {
        __weak StudyTypeCourseListViewController *weakself = self;
        weakself.userFaceStudyTypeCourseListVerifyResult = ^(BOOL result) {
            NSDictionary *info = weakself.dataSource[indexPath.row];
            
            CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",info[@"course_id"]];
            vc.currentHourseId = [NSString stringWithFormat:@"%@",info[@"section_id"]];
            vc.isLive = [[NSString stringWithFormat:@"%@",info[@"course_type"]] isEqualToString:@"2"];
            vc.courseType = [NSString stringWithFormat:@"%@",info[@"course_type"]];
            vc.shouldContinueLearn = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
            [weakself faceCompareTip:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"course_id"]] sourceType:@"course"];
        } else {
            [weakself faceVerifyTip];
        }
    } else {
        NSDictionary *info = _dataSource[indexPath.row];
        
        CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",info[@"course_id"]];
        vc.currentHourseId = [NSString stringWithFormat:@"%@",info[@"section_id"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",info[@"course_type"]] isEqualToString:@"2"];
        vc.courseType = [NSString stringWithFormat:@"%@",info[@"course_type"]];
        vc.shouldContinueLearn = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
                outdateIndex = _dataSource.count;
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

// MARK: - 人脸未认证提示
- (void)faceVerifyTip {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未完成人脸认证\n请先去认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = YES;
        vc.verifyed = NO;
//        vc.verifyResult = ^(BOOL result) {
//            if (result) {
//                self.userFaceVerifyResult(result);
//            }
//        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

// MARK: - 人脸识别提示
- (void)faceCompareTip:(NSString *)courseHourseId sourceType:(NSString *)type {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请进行人脸验证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = NO;
        vc.verifyed = YES;
        vc.sourceType = type;
        vc.sourceId = courseHourseId;
        vc.scene_type = @"1";
        vc.verifyResult = ^(BOOL result) {
            if (result) {
                self.userFaceStudyTypeCourseListVerifyResult(result);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
