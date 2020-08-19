//
//  MyCollectionCourseManagerVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCollectionCourseManagerVC.h"

#import "CourseCollectionManagerCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ShopCarModel.h"

@interface MyCollectionCourseManagerVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CourseCollectionManagerCellDelegate> {
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

@implementation MyCollectionCourseManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    course_ids = @"";
    allSeleted = NO;
    _titleLabel.text = @"管理";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"取消" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    _rightButton.hidden = NO;
    _dataSource = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [self makeBottomView];
    // Do any additional setup after loading the view.
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT)];
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

- (void)makeBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (MainScreenWidth - 1)/2.0, 49)];
    [_selectAllButton setTitle:@"全选" forState:0];
    [_selectAllButton setTitle:@"取消全选" forState:UIControlStateSelected];
    [_selectAllButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _selectAllButton.titleLabel.font = SYSTEMFONT(16);
    [_selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_selectAllButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_selectAllButton.right, 0, 1, 12)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    line.centerY = _selectAllButton.centerY;
    [_bottomView addSubview:line];
    
    _cancelCollectButton = [[UIButton alloc] initWithFrame:CGRectMake(line.right, 0, (MainScreenWidth - 1)/2.0, 49)];
    [_cancelCollectButton setTitle:@"取消收藏(0)" forState:0];
    [_cancelCollectButton setTitleColor:EdlineV5_Color.textzanColor forState:0];
    _cancelCollectButton.titleLabel.font = SYSTEMFONT(16);
    [_cancelCollectButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cancelCollectButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCollectionManagerCell";
    CourseCollectionManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCollectionManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.delegate = self;
    [cell setCourseCollectionManagerModel:_dataSource[indexPath.row] indexpath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_courseType)) {
        [param setObject:_courseType forKey:@"source_type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userCollectionListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[ShopCarCourseModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
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
    // 大类型
    if (SWNOTEmptyStr(_courseType)) {
        [param setObject:_courseType forKey:@"source_type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userCollectionListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[ShopCarCourseModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
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

// MARK: - 管理课程页面选择按钮代理
- (void)courseManagerSelectButtonClick:(CourseCollectionManagerCell *)cell {
    // 第一要改变数据源
    cell.courseModel.selected = cell.selectedIconBtn.selected;
    
    ShopCarCourseModel *cellCourseModel = cell.courseModel;
    NSIndexPath *path = cell.cellIndex;
    
    [_dataSource replaceObjectAtIndex:path.row withObject:cellCourseModel];
    
    // 判断每一个机构是不是全选与否
    for (int i = 0; i < _dataSource.count; i ++) {
        ShopCarCourseModel *model = _dataSource[i];
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
        ShopCarCourseModel *courseModel = _dataSource[i];
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
        ShopCarCourseModel *model = _selectedArray[i];
        if (SWNOTEmptyStr(course_ids)) {
            course_ids = [NSString stringWithFormat:@"%@,%@",course_ids,model.courseId];
        } else {
            course_ids = model.courseId;
        }
    }
    if (!SWNOTEmptyStr(course_ids)) {
        [self showHudInView:self.view showHint:@"请选择一个课程"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:_courseType forKey:@"source_type"];
    [param setObject:course_ids forKey:@"ids"];
    
    [Net_API requestDeleteWithURLStr:[Net_Path unCollectNet] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCollectionList" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
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
        ShopCarCourseModel *courseModel = _dataSource[i];
        if (courseModel.selected) {
            [_selectedArray addObject:courseModel];
        }
    }
    [_cancelCollectButton setTitle:[NSString stringWithFormat:@"取消收藏(%@)",@(_selectedArray.count)] forState:0];
}

- (void)rightButtonClick:(id)sender {
    if (SWNOTEmptyArr(_selectedArray)) {
        _selectAllButton.selected = NO;
        allSeleted = _selectAllButton.selected;
        
        for (int i = 0; i < _dataSource.count; i ++) {
            ShopCarCourseModel *courseModel = _dataSource[i];
            courseModel.selected = allSeleted;
            [_dataSource replaceObjectAtIndex:i withObject:courseModel];
        }
        [self dealDataSource];
        [_tableView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
