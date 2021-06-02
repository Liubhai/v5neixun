//
//  PublicAndTestExamRecordList.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/10.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "PublicAndTestExamRecordList.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "LBHTableView.h"

#import "ExamRecordCell.h"
#import "ExamResultViewController.h"

@interface PublicAndTestExamRecordList ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ExamRecordCellDelegate> {
    NSInteger page;
    BOOL allSeleted;
    NSString *course_ids;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

//装课程id
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *selectAllButton;
@property (strong, nonatomic) UIButton *cancelCollectButton;

@end

@implementation PublicAndTestExamRecordList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstList) name:@"reloadMyCollectionList" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
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
    if ([_examType isEqualToString:@"3"]) {
        static NSString *reuse = @"ExamRecordCellPublic";
        ExamRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[ExamRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        cell.delegate = self;
        [cell setExamRecordRootManagerModel:_dataSource[indexPath.row] indexpath:indexPath isPublic:YES];
        return cell;
    } else {
        static NSString *reuse = @"ExamRecordCellTest";
        ExamRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[ExamRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        cell.delegate = self;
        [cell setExamRecordRootManagerModel:_dataSource[indexPath.row] indexpath:indexPath isPublic:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EXamRecordModel *model = _dataSource[indexPath.row];
    if ([model.answer_status isEqualToString:@"2"] || [model.visible_answer isEqualToString:@"1"]) {
        ExamResultViewController *vc = [[ExamResultViewController alloc] init];
        vc.record_id = [NSString stringWithFormat:@"%@",model.topic_id];
        vc.answer_status = [NSString stringWithFormat:@"%@",model.answer_status];
        vc.examType = _examType;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self showHudInView:self.view showHint:@"正在阅卷，请耐心等待"];
    }
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [param setObject:_examType forKey:@"type"];
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPaperRecordListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[EXamRecordModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
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

- (void)getMoreList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [param setObject:_examType forKey:@"type"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPaperRecordListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[EXamRecordModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
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

@end
