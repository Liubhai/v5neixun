//
//  ZhuangXiangListTreeTableVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ZhuangXiangListTreeTableVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ZhuangXiangListCell.h"
#import "ZhuanXiangModel.h"
#import "ZhuangXiangListCell.h"
#import "ExamDetailViewController.h"
#import "OrderViewController.h"

@interface ZhuangXiangListTreeTableVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZhuangXiangListCellDelegate> {
    NSInteger page;
    BOOL canSelect;//开关阀门 连续点击一个cell会出问题(由于网络延迟问题)
}

@property (strong, nonatomic) UITextField *institutionSearch;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *originSource;
@property (strong, nonatomic) NSDictionary *originDict;

@end

@implementation ZhuangXiangListTreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    canSelect = YES;
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self makeTopSearch];
    
    _dataSource = [NSMutableArray new];
    _originDict = [NSDictionary new];
    _originSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top - 2, MainScreenWidth - _leftButton.width - 15, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索专项名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 17 + 15 + 10, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;
    _institutionSearch.clearButtonMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getZhuanXiangListData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.showItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"ZhuangXiangListCell";
    ZhuangXiangListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[ZhuangXiangListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    ZhuanXiangModel *item = self.manager.showItems[indexPath.row];
    [cell setZhuangXiangCellInfo:item];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZhuanXiangModel *item = self.manager.showItems[indexPath.row];
    if (item.level == 2) {
        
    } else {
        if (!item.isExpand) {
            if (!canSelect) {
                return;
            }
            canSelect = NO;
            NSLog(@"展开");
            item.isExpand = !item.isExpand;
            [self.manager.showItems replaceObjectAtIndex:indexPath.row withObject:item];
            [self getZhuangXiangListArray:item indepath:indexPath];
        } else {
            if (!canSelect) {
                return;
            }
            canSelect = NO;
            NSLog(@"收起");
//            item.isExpand = !item.isExpand;
//            [self.manager.showItems replaceObjectAtIndex:indexPath.row withObject:item];
            [self tableView:tableView didSelectItems:@[item] isExpand:!item.isExpand];
        }
    }
    
}

#pragma mark - Private Method

- (NSArray <NSIndexPath *>*)getUpdateIndexPathsWithCurrentIndexPath:(NSIndexPath *)indexPath andUpdateNum:(NSInteger)updateNum {
    
    NSMutableArray *tmpIndexPaths = [NSMutableArray arrayWithCapacity:updateNum];
    for (int i = 0; i < updateNum; i++) {
        NSIndexPath *tmp = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
        [tmpIndexPaths addObject:tmp];
    }
    return tmpIndexPaths;
}

- (UIColor *)getColorWithRed:(NSInteger)redNum green:(NSInteger)greenNum blue:(NSInteger)blueNum {
    return [UIColor colorWithRed:redNum/255.0 green:greenNum/255.0 blue:blueNum/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectItems:(NSArray <ZhuanXiangModel *>*)items isExpand:(BOOL)isExpand {
    
    NSMutableArray *updateIndexPaths = [NSMutableArray array];
    NSMutableArray *editIndexPaths   = [NSMutableArray array];
    
    for (ZhuanXiangModel *item in items) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.manager.showItems indexOfObject:item] inSection:0];
        [updateIndexPaths addObject:indexPath];
        
        NSInteger updateNum = [self.manager expandItem:item];
        NSArray *tmp = [self getUpdateIndexPathsWithCurrentIndexPath:indexPath andUpdateNum:updateNum];
        [editIndexPaths addObjectsFromArray:tmp];
    }
    
    if (isExpand) {
        [tableView insertRowsAtIndexPaths:editIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
//        [tableView deleteRowsAtIndexPaths:editIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        // 上面 delete 方法有弊端  暂不清楚原因 这里直接 table 刷新
        [_tableView reloadData];
    }
    
    for (NSIndexPath *indexPath in updateIndexPaths) {
        ZhuangXiangListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateItem];
    }
    canSelect = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        if (SWNOTEmptyStr(textField.text)) {
            [_tableView.mj_header beginRefreshing];
        }
        return NO;
    }
    return YES;
}

- (void)getZhuangXiangListArray:(ZhuanXiangModel *)model indepath:(NSIndexPath *)path {
    
    // 思路 相当于获取总数据里面对应 model 的下级 只是下级
    NSMutableArray *childArray = [NSMutableArray new];
    NSMutableArray *originPassArray = [NSMutableArray new];
    [originPassArray addObjectsFromArray:[NSArray arrayWithArray:[ZhuanXiangModel mj_objectArrayWithKeyValuesArray:_originSource]]];
    for (int i = 0; i<originPassArray.count; i++) {
        ZhuanXiangModel *model1 = originPassArray[i];
        if ([model1.course_id isEqualToString:model.course_id]) {
            if (model1.child) {
                NSLog(@"当前点击的标题 %@ , 下级的等级是%@",model1.title,@(((ZhuanXiangModel *)model1.child[0]).level));
            }
            [childArray addObjectsFromArray:model1.child];
            break;
        } else {
            for (int j = 0; j<model1.child.count; j++) {
                ZhuanXiangModel *model2 = model1.child[j];
                if ([model2.course_id isEqualToString:model.course_id]) {
                    [childArray addObjectsFromArray:model2.child];
                    break;
                } else {
                    for (int k = 0; k<model2.child.count; k++) {
                        ZhuanXiangModel *model3 = model2.child[k];
                        if ([model3.course_id isEqualToString:model3.course_id]) {
                            [childArray addObjectsFromArray:model3.child];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    NSMutableArray *items = [NSMutableArray new];
    [childArray enumerateObjectsUsingBlock:^(ZhuanXiangModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
        obj.parentID = model.course_id;
        obj.parentItem = model;
        obj.level = obj.level - 1;
        [items addObject:obj];
    }];
    model.child = items;
    [_manager.showItems insertObjects:items atIndex:path.row + 1];
    [_tableView reloadData];
    canSelect = YES;
}

- (void)getZhuanXiangListData {
    page = 1;
    if (SWNOTEmptyStr(_examTypeId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:_examTypeId forKey:@"module_id"];
        if (SWNOTEmptyStr(_institutionSearch.text)) {
            [param setObject:_institutionSearch.text forKey:@"title"];
        }
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
        [Net_API requestGETSuperAPIWithURLStr:SWNOTEmptyStr(_institutionSearch.text) ? [Net_Path specialExamSearchListNet] : [Net_Path specialExamList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_header.refreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSource removeAllObjects];
                    [_originSource removeAllObjects];
                    if ([[responseObject objectForKey:@"data"] allKeys]) {
                        NSArray *pass = [NSArray arrayWithArray:[ZhuanXiangModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                        [_originSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                        _originDict = [NSDictionary dictionaryWithDictionary:responseObject];
                        for (ZhuanXiangModel *object in pass) {
                            object.isLeaf = YES;
                            object.level = 0;
                            [_dataSource addObject:object];
                        }
                        NSMutableSet *items = [NSMutableSet set];
                        [_dataSource enumerateObjectsUsingBlock:^(ZhuanXiangModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            obj.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                            obj.parentID = @"";
                            obj.parentItem = nil;
                            [items addObject:obj];
                        }];
                        
                        ZhuangXiangModelManager *manager = [[ZhuangXiangModelManager alloc] initWithItems:items andExpandLevel:0];
                        _manager = manager;
                        
                        if (_dataSource.count<10) {
                            _tableView.mj_footer.hidden = YES;
                        } else {
                            _tableView.mj_footer.hidden = NO;
                            [_tableView.mj_footer setState:MJRefreshStateIdle];
                        }
                    }
                    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [_tableView.mj_header endRefreshing];
        }];
    }
}

- (void)getMoreList {
    page = page + 1;
    if (SWNOTEmptyStr(_examTypeId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:_examTypeId forKey:@"module_id"];
        if (SWNOTEmptyStr(_institutionSearch.text)) {
            [param setObject:_institutionSearch.text forKey:@"title"];
        }
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [Net_API requestGETSuperAPIWithURLStr:SWNOTEmptyStr(_institutionSearch.text) ? [Net_Path specialExamSearchListNet] : [Net_Path specialExamList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSArray *pass = [NSArray arrayWithArray:[ZhuanXiangModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                    [_originSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                    _originDict = [NSDictionary dictionaryWithDictionary:responseObject];
                    for (ZhuanXiangModel *object in pass) {
                        object.isLeaf = YES;
                        object.level = 0;
                        [_dataSource addObject:object];
                    }
                    NSMutableSet *items = [NSMutableSet set];
                    [_dataSource enumerateObjectsUsingBlock:^(ZhuanXiangModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                        obj.parentID = @"";
                        obj.parentItem = nil;
                        [items addObject:obj];
                    }];
                    
                    ZhuangXiangModelManager *manager = [[ZhuangXiangModelManager alloc] initWithItems:items andExpandLevel:0];
                    _manager = manager;
                    
                    if (pass.count<10) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
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

// MARK: - 专项列表cell上按钮的一些操作代理
- (void)userBuyOrExam:(ZhuangXiangListCell *)cell {
    if ([cell.treeItem.user_price floatValue]>0 && !cell.treeItem.has_bought) {
        // 购买
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_special";
        vc.orderId = cell.treeItem.course_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 开始答题
        ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
        vc.examIds = cell.treeItem.course_id;
        vc.examType = _examTypeId;
        vc.examTitle = cell.treeItem.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)userExamBy:(ZhuangXiangListCell *)cell {
    // 获取最顶级的 价格和是否购买 去判断
    NSString *courseId = cell.treeItem.user_price;
    NSString *course_id = cell.treeItem.course_id;
    
    ZhuanXiangModel *pmodel = cell.treeItem.parentItem;
    while (pmodel) {
        courseId = pmodel.user_price;
        course_id = pmodel.course_id;
        pmodel = pmodel.parentItem;
    }
    if ([courseId floatValue]>0 && !pmodel.has_bought) {
        // 购买
        // 购买
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_special";
        vc.orderId = course_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 开始答题
        ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
        vc.examIds = course_id;
        vc.examType = _examTypeId;
        vc.examTitle = pmodel ? pmodel.title : cell.treeItem.title;
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
