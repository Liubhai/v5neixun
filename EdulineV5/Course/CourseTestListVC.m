//
//  CourseTestListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CourseTestListVC.h"
#import "CourseTestListCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamPaperDetailViewController.h"
#import "FaceVerifyViewController.h"
#import "V5_UserModel.h"

@interface CourseTestListVC () {
    NSInteger page;
    BOOL course_can_exam;// 整个课程能不能可考
}

@end

@implementation CourseTestListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    _titleImage.hidden = YES;
    _canPlayRecordVideo = YES;
    _dataSource = [NSMutableArray new];
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [self getCourseTestListInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseTestListCell";
    CourseTestListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseTestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setCourseTestCellInfoData:_dataSource[indexPath.row] course_can_exam:course_can_exam];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *can_exam = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"can_exam"]];
    if ([can_exam integerValue] && course_can_exam) {
        ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
        vc.examType = @"3";
        vc.examIds = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"paper_id"]];
        vc.courseId = _courseId;
        vc.isExamButNoVerify = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        if ([ShowExamUserFace isEqualToString:@"1"]) {
//            self.courseTestListUserFaceVerifyResult = ^(BOOL result) {
//                if (result) {
//                    ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
//                    vc.examType = @"3";
//                    vc.examIds = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"paper_id"]];
//                    vc.courseId = _courseId;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            };
//            if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
//                [self faceCompareTip:[NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"paper_id"]]];
//            } else {
//                [self faceVerifyTip];
//            }
//        } else {
//
//        }
    } else {
        if (!course_can_exam) {
            [self showHudInView:self.vc.view showHint:@"不符合参加考试的条件"];
        } else {
            if (![can_exam integerValue]) {
                [self showHudInView:self.vc.view showHint:@"考试次数已经用完"];
            }
        }
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

- (void)getCourseTestListInfo:(NSDictionary *)courseInfo {
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    course_can_exam = [[NSString stringWithFormat:@"%@",courseInfo[@"can_exam"]] boolValue];
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:[courseInfo objectForKey:@"exam"]];
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
    [_tableView reloadData];
    return;
    if (SWNOTEmptyStr(_courseId)) {
        page = 1;
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [param setObject:_courseId forKey:@"course_id"];
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path classCourseStudentListNet:_courseId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
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
            
        }];
    }
}

- (void)getMoreList {
    if (SWNOTEmptyStr(_courseId)) {
        page = page + 1;
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [param setObject:_courseId forKey:@"course_id"];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path classCourseStudentListNet:_courseId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
//                self.courseTestListUserFaceVerifyResult(result);
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
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 人脸识别提示
- (void)faceCompareTip:(NSString *)courseHourseId {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请进行人脸验证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = NO;
        vc.verifyed = YES;
        vc.sourceType = @"course";
        vc.sourceId = courseHourseId;
        vc.scene_type = @"1";
        vc.verifyResult = ^(BOOL result) {
            if (result) {
                self.courseTestListUserFaceVerifyResult(result);
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
    [self presentViewController:alertController animated:YES completion:nil];
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
