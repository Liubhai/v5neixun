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
#import "FaceVerifyViewController.h"
#import "CourseDetailPlayVC.h"
#import "V5_UserModel.h"

@interface JoinCourseTypeVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
//    NSString *typeString;//状态【all：全部；not_started：未开始；learning：学习中；finished：已完成；】
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
//    typeString = @"all";
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseStudyTypeProgressChange:) name:@"courseStudyTypeProgressChange" object:nil];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - ([_courseType isEqualToString:@"4"] ? 45 : 0))];
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
    static NSString *reuse = @"StudyCourseCell1";
    StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[StudyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setJoinStudyCourseListInfo:_dataSource[indexPath.row] showOutDate:NO isOutDate:NO courseType:_courseType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[NSString stringWithFormat:@"%@",self.dataSource[indexPath.row][@"expire_rest"]] isEqualToString:@"0"]) {
        [self showHudInView:self.view showHint:@"课程已过期"];
        return;
    }
    if ([ShowUserFace isEqualToString:@"1"]) {
        __weak JoinCourseTypeVC *weakself = self;
        weakself.userFaceJoinCourseTypeVerify = ^(BOOL result) {
            NSDictionary *info = weakself.dataSource[indexPath.row];
            
            CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",info[@"id"]];
            vc.isLive = NO;
            vc.courseType = _courseType;
            vc.shouldContinueLearn = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
            [weakself faceCompareTip:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]] sourceType:@"course"];
        } else {
            [weakself faceVerifyTip];
        }
    } else {
        NSDictionary *info = _dataSource[indexPath.row];
        
        CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",info[@"id"]];
        vc.courseType = _courseType;
        vc.shouldContinueLearn = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getFirstData {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    NSString *urlString = [Net_Path courseStudyListNet];
    if ([_courseType isEqualToString:@"4"]) {
        urlString = [Net_Path planStudyListNet];
        [param setObject:_typeString forKey:@"type"];
    }
    
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:urlString WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
    NSString *urlString = [Net_Path courseStudyListNet];
    if ([_courseType isEqualToString:@"4"]) {
        urlString = [Net_Path planStudyListNet];
        [param setObject:_typeString forKey:@"type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:urlString WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

- (void)courseStudyTypeProgressChange:(NSNotification *)notice {
    if (SWNOTEmptyDictionary(notice.userInfo)) {
        _typeString = [notice.userInfo objectForKey:@"StudyTypeProgress"];
        NSString *currentType = [NSString stringWithFormat:@"%@",[notice.userInfo objectForKey:@"currentType"]];
        [self getFirstData];
//        if ([currentType isEqualToString:_courseType]) {
//            [self getFirstData];
//        }
    }
}

// MARK: - 人脸未认证提示
- (void)faceVerifyTip {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未完成人脸认证\n请先去认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = YES;
        vc.verifyed = NO;
        vc.verifyResult = ^(BOOL result) {
//            if (result) {
//                self.userFaceVerifyResult(result);
//            }
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
                self.userFaceJoinCourseTypeVerify(result);
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
