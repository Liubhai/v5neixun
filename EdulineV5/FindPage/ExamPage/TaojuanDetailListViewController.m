//
//  TaojuanDetailListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "TaojuanDetailListViewController.h"
#import "SpecialExamListCell.h"
#import "TaoJuanDetailListCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamPaperDetailViewController.h"
#import "OrderViewController.h"
#import "FaceVerifyViewController.h"
#import "V5_UserModel.h"

@interface TaojuanDetailListViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, SpecialExamListCellDelegate, TaoJuanDetailListCellDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *detailInfo;

@end

@implementation TaojuanDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = _module_title;
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    _dataSource = [NSMutableArray new];
    _detailInfo = [NSMutableDictionary new];
    page = 1;
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstList) name:@"reloadExamList" object:nil];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return SWNOTEmptyDictionary(_detailInfo) ? 1 : 0;
    }
    return _dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    footer.backgroundColor = EdlineV5_Color.backColor;
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"SpecialExamListCell";
        SpecialExamListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[SpecialExamListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setExamPointDetailCell:_detailInfo];
        cell.delegate = self;
        return cell;
    }
    static NSString *reuse = @"TaoJuanDetailListCell";
    TaoJuanDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[TaoJuanDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setTaojuanDetailListCellInfo:_dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getOrExamButtonWith:(SpecialExamListCell *)cell {
    if ([cell.getOrExamBtn.titleLabel.text isEqualToString:@"开始答题"]) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            self.TaojuanDetailListUserFaceVerifyResult = ^(BOOL result) {
                if (result) {
                    ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
                    vc.examType = @"4";
                    NSArray *pass = [NSArray arrayWithArray:cell.specialInfo[@"rollup_paper"]];
                    if (SWNOTEmptyArr(pass)) {
                        vc.examIds = [NSString stringWithFormat:@"%@",[pass[0] objectForKey:@"paper_id"]];
                    }
                    vc.rollup_id = _rollup_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
                NSArray *pass = [NSArray arrayWithArray:cell.specialInfo[@"rollup_paper"]];
                [self faceCompareTip:[NSString stringWithFormat:@"%@",[pass[0] objectForKey:@"paper_id"]]];
            } else {
                [self faceVerifyTip];
            }
        } else {
            ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
            vc.examType = @"4";
            NSArray *pass = [NSArray arrayWithArray:cell.specialInfo[@"rollup_paper"]];
            if (SWNOTEmptyArr(pass)) {
                vc.examIds = [NSString stringWithFormat:@"%@",[pass[0] objectForKey:@"paper_id"]];
            }
            vc.rollup_id = _rollup_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        // 购买
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_volume";
        vc.orderId = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)doVolumeOrBuyExam:(TaoJuanDetailListCell *)cell {
    if (SWNOTEmptyDictionary(_detailInfo)) {
        NSString *priceCount = [NSString stringWithFormat:@"%@",_detailInfo[@"user_price"]];
        if ([_detailInfo[@"has_bought"] integerValue] || [priceCount isEqualToString:@"0.00"] || [priceCount isEqualToString:@"0.0"] || [priceCount isEqualToString:@"0"]) {
            if ([ShowExamUserFace isEqualToString:@"1"]) {
                self.TaojuanDetailListUserFaceVerifyResult = ^(BOOL result) {
                    if (result) {
                        ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
                        vc.examType = @"4";
                        vc.examIds = [NSString stringWithFormat:@"%@",[cell.taojuanDetailInfo objectForKey:@"paper_id"]];
                        vc.rollup_id = _rollup_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                };
                if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
                    [self faceCompareTip:[NSString stringWithFormat:@"%@",[cell.taojuanDetailInfo objectForKey:@"paper_id"]]];
                } else {
                    [self faceVerifyTip];
                }
            } else {
                ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
                vc.examType = @"4";
                vc.examIds = [NSString stringWithFormat:@"%@",[cell.taojuanDetailInfo objectForKey:@"paper_id"]];
                vc.rollup_id = _rollup_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            // 提示请先购买
            [self showHudInView:self.view showHint:@"请先购买"];
            return;
            // 购买
            OrderViewController *vc = [[OrderViewController alloc] init];
            vc.orderTypeString = @"exam_volume";
            vc.orderId = [NSString stringWithFormat:@"%@",[_detailInfo objectForKey:@"id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [param setObject:_rollup_id forKey:@"rollup_id"];
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path volumePaperDetailNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _detailInfo = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"rollup_paper"]];
//                if (_dataSource.count<10) {
//                    _tableView.mj_footer.hidden = YES;
//                } else {
//                    _tableView.mj_footer.hidden = NO;
//                    [_tableView.mj_footer setState:MJRefreshStateIdle];
//                }
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [_tableView reloadData];
            } else {
                _detailInfo = nil;
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [_tableView reloadData];
            }
        } else {
            _detailInfo = nil;
            [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
            [_tableView reloadData];
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
//    if (SWNOTEmptyStr(categoryString)) {
//        [param setObject:categoryString forKey:@"category"];
//    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path institutionListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

// MARK: - 人脸未认证提示
- (void)faceVerifyTip {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未完成人脸认证\n请先去认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = YES;
        vc.verifyed = NO;
//        vc.verifyResult = ^(BOOL result) {
//            if (result) {
//                self.TaojuanDetailListUserFaceVerifyResult(result);
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
                self.TaojuanDetailListUserFaceVerifyResult(result);
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

@end
