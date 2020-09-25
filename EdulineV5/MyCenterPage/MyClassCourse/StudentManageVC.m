//
//  StudentManageVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudentManageVC.h"
#import "StudentManageCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface StudentManageVC ()<UITableViewDelegate, UITableViewDataSource, StudentManageCellDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation StudentManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"学员管理";
//    _rightButton.hidden = NO;
//    [_rightButton setImage:nil forState:0];
//    [_rightButton setTitle:@"添加" forState:0];
//    [_rightButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"StudentManageCell";
    StudentManageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[StudentManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setStudentInfo:_dataSource[indexPath.row] cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path classCourseStudentListNet:_courseId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
                [_tableView reloadData];
            }
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

- (void)removeStudent:(NSIndexPath *)cellIndexPath {
    if (SWNOTEmptyArr(_dataSource)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定移除该学员吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self removeWhichStudent:cellIndexPath];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:commentAction];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)rightButtonClick:(id)sender {
    
}

- (void)removeWhichStudent:(NSIndexPath *)cellIndexPath {
    if (_dataSource.count > cellIndexPath.row) {
        NSString *userId = [NSString stringWithFormat:@"%@",_dataSource[cellIndexPath.row][@"user_id"]];
        if (SWNOTEmptyStr(userId) && SWNOTEmptyStr(_courseId)) {
            [Net_API requestDeleteWithURLStr:[Net_Path removeClassCourseStudent:_courseId studentId:userId] paramDic:nil Api_key:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
                [self getFirstList];
            } enError:^(NSError * _Nonnull error) {
                [self showHudInView:self.view showHint:@"网络飞走了"];
            }];
        }
    }
}
@end
