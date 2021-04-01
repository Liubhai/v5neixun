//
//  ExamRecordList.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamRecordList.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "LBHTableView.h"

#import "ExamCollectCell.h"

#import "ExamTestDetailViewController.h"

@interface ExamRecordList ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ExamCollectCellDelegate> {
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

@implementation ExamRecordList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [self makeBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstList) name:@"reloadMyCollectionList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showManagerBottomView:) name:@"showManagerBottomView" object:nil];
}

- (void)makeBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.hidden = YES;

    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    _bottomView.layer.shadowOpacity = 1;// 阴影透明度，默认0
    _bottomView.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _bottomView.layer.shadowRadius = 7;//阴影半径，默认3
    [self.view addSubview:_bottomView];
    
    _selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (MainScreenWidth - 1)/2.0, 49)];
    [_selectAllButton setTitle:@"全选" forState:0];
    [_selectAllButton setTitle:@"全选" forState:UIControlStateSelected];
    [_selectAllButton setImage:[Image(@"checkbox_orange") converToMainColor] forState:UIControlStateSelected];
    [_selectAllButton setImage:Image(@"checkbox_def") forState:0];
    
    [_selectAllButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _selectAllButton.titleLabel.font = SYSTEMFONT(16);
    [_selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat selectAllBtnWidth = [_selectAllButton.titleLabel.text sizeWithFont:_selectAllButton.titleLabel.font].width + 15 + 20 + 7 + 15;
    [_selectAllButton setWidth:selectAllBtnWidth];
    
    _selectAllButton.imageEdgeInsets = UIEdgeInsetsMake(0, -3.5, 0, 3.5);
    _selectAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3.5, 0, -3.5);
    
    [_bottomView addSubview:_selectAllButton];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_selectAllButton.right, 0, 1, 12)];
//    line.backgroundColor = EdlineV5_Color.fengeLineColor;
//    line.centerY = _selectAllButton.centerY;
//    [_bottomView addSubview:line];
    
    _cancelCollectButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 88 - 30, 0, 88 + 30, 49)];
    [_cancelCollectButton setTitle:@"取消收藏(0)" forState:0];
    [_cancelCollectButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _cancelCollectButton.titleLabel.font = SYSTEMFONT(16);
    [_cancelCollectButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cancelCollectButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
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
    if ([_examListType isEqualToString:@"error"]) {
        static NSString *reuse = @"ExamCollectCellerror";
        ExamCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[ExamCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setExamErorModel:_dataSource[indexPath.row] indexpath:indexPath];
        cell.delegate = self;
        return cell;
    } else {
        static NSString *reuse = @"ExamCollectCell";
        ExamCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[ExamCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setExamCollectRootManagerModel:_dataSource[indexPath.row] indexpath:indexPath showSelect:_bottomView.hidden];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExamCollectCellModel *model = _dataSource[indexPath.row];
    ExamTestDetailViewController *vc = [[ExamTestDetailViewController alloc] init];
    vc.examType = [_examListType isEqualToString:@"error"] ? @"error" : @"collect";
    vc.examIds = model.topic_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getFirstList {
    page = 1;
    NSString *getUrl = [Net_Path examPointIdListNet];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([_examListType isEqualToString:@"error"]) {
        getUrl = [Net_Path examWrongListNet];
    } else {
        getUrl = [Net_Path examCollectionListNet];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[ExamCollectCellModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                }
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [self dealDataSource];
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
    NSString *getUrl = [Net_Path examPointIdListNet];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([_examListType isEqualToString:@"error"]) {
        getUrl = [Net_Path examWrongListNet];
    } else {
        getUrl = [Net_Path examCollectionListNet];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[ExamCollectCellModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                
                [self dealDataSource];
                
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

// MARK: - 管理课程页面选择按钮代理
- (void)examCollectManagerSelectButtonClick:(ExamCollectCell *)cell {
    // 第一要改变数据源
    cell.courseModel.selected = cell.selectedIconBtn.selected;
    
    ExamCollectCellModel *cellCourseModel = cell.courseModel;
    NSIndexPath *path = cell.cellIndex;
    
    [_dataSource replaceObjectAtIndex:path.row withObject:cellCourseModel];
    
    // 判断每一个机构是不是全选与否
    for (int i = 0; i < _dataSource.count; i ++) {
        ExamCollectCellModel *model = _dataSource[i];
        if (model.selected) {
            allSeleted = YES;
        } else {
            allSeleted = NO;
            break;
        }
    }
    
    _selectAllButton.selected = allSeleted;
    
    [self dealDataSource];
    
    // 第二 刷新页面
    [_tableView reloadData];
}

// MARK: - 全选按钮方法
- (void)selectAllButtonClick:(UIButton *)sender {
    _selectAllButton.selected = !sender.selected;
    allSeleted = _selectAllButton.selected;
    
    for (int i = 0; i < _dataSource.count; i ++) {
        ExamCollectCellModel *courseModel = _dataSource[i];
        courseModel.selected = allSeleted;
        [_dataSource replaceObjectAtIndex:i withObject:courseModel];
    }
    
    [self dealDataSource];
    [_tableView reloadData];
}

// MARK: - 取消收藏按钮点击事件
- (void)cancelButtonClick:(UIButton *)sender {
    course_ids = @"";
    for (int i = 0; i<_selectedArray.count; i ++) {
        ExamCollectCellModel *model = _selectedArray[i];
        if (SWNOTEmptyStr(course_ids)) {
            course_ids = [NSString stringWithFormat:@"%@,%@",course_ids,model.topic_id];
        } else {
            course_ids = model.topic_id;
        }
    }
    if (!SWNOTEmptyStr(course_ids)) {
        [self showHudInView:self.view showHint:@"请选择一个试题"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"0" forKey:@"status"];
    [param setObject:course_ids forKey:@"topic_id"];
    
    [Net_API requestPOSTWithURLStr:[Net_Path examCollectionNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _selectAllButton.selected = NO;
                [self getFirstList];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"网络请求失败"];
    }];
    
}

// MARK: - 处理已选择的课程进 selectedArray
- (void)dealDataSource {
    [_selectedArray removeAllObjects];
    for (int i = 0; i<_dataSource.count; i++) {
        ExamCollectCellModel *courseModel = _dataSource[i];
        if (courseModel.selected) {
            [_selectedArray addObject:courseModel];
        }
    }
    if (_selectedArray.count == 0) {
        allSeleted = NO;
        _selectAllButton.selected = NO;
    }
    [_cancelCollectButton setTitle:[NSString stringWithFormat:@"取消收藏(%@)",@(_selectedArray.count)] forState:0];
}

- (void)showManagerBottomView:(NSNotification *)notice {
    if ([_examListType isEqualToString:@"collect"]) {
        if ([[notice.userInfo objectForKey:@"show"] boolValue]) {
            _bottomView.hidden = NO;
            _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT);
        } else {
            _bottomView.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        }
        [_tableView reloadData];
    }
}

@end
