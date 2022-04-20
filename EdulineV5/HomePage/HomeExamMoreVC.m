//
//  HomeExamMoreVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/4/18.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "HomeExamMoreVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "HomeExamCell.h"
#import "ExamPaperDetailViewController.h"
#import "ExamResultViewController.h"

@interface HomeExamMoreVC ()<UITableViewDelegate, UITableViewDataSource, HomeExamCellDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation HomeExamMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"我的考试";
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    // Do any additional setup after loading the view.
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderList)];
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
    static NSString *reuse = @"HomeExamCell1";
    HomeExamCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[HomeExamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setHomeExamListInfo:_dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getOrderList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userOwnExamListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
            }
        }
        if (_dataSource.count<10) {
            _tableView.mj_footer.hidden = YES;
        } else {
            _tableView.mj_footer.hidden = NO;
        }
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreOrderList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userOwnExamListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:pass];
                if (pass.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        }
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

// MARK: - 考试或者查看详情
- (void)doExamOrLookExamResult:(NSDictionary *)examInfo {
    
    NSString *exam_status = [NSString stringWithFormat:@"%@",examInfo[@"exam_status"]];
    NSString *answer_times = [NSString stringWithFormat:@"%@",examInfo[@"answer_times"]];
    NSString *exam_number = [NSString stringWithFormat:@"%@",examInfo[@"exam_rest_num"]];
    
    if ([answer_times isEqualToString:@"0"] || [answer_times isEqualToString:@"null"] || [answer_times isEqualToString:@"<null>"]) {
        // 未作答
        if ([exam_status isEqualToString:@"0"]) {
            // 未开放
        } else {
            // 开始答题
            if ([exam_number isEqualToString:@"0"]) {
                [self showHudInView:self.view showHint:@"考试次数已用完"];
                return;
            }
            ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
            vc.examType = @"3";
            vc.examIds = [NSString stringWithFormat:@"%@",[examInfo objectForKey:@"paper_id"]];
            vc.examModuleId = [NSString stringWithFormat:@"%@",[examInfo objectForKey:@"exam_id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        /// 已参考
        ExamResultViewController *vc = [[ExamResultViewController alloc] init];
        vc.record_id = [NSString stringWithFormat:@"%@",examInfo[@"record_id"]];
        vc.examType = @"3";
        [self.navigationController pushViewController:vc animated:YES];
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
