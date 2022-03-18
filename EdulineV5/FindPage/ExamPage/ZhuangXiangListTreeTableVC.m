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
#import "AppDelegate.h"
#import "V5_UserModel.h"

#import "ExamNewSecendTypeVC.h"

@interface ZhuangXiangListTreeTableVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZhuangXiangListCellDelegate, ExamNewSecendTypeVCDelegate> {
    NSInteger page;
    BOOL canSelect;//开关阀门 连续点击一个cell会出问题(由于网络延迟问题)
    NSString *examNewType;/// 新优化选择的分类
}

@property (strong, nonatomic) UITextField *institutionSearch;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *originSource;
@property (strong, nonatomic) NSDictionary *originDict;

@property (strong, nonatomic) UIButton *topCateButton;

@property (strong, nonatomic) UIView *mainTypeBackView;
@property (strong, nonatomic) UIScrollView *mainTypeScrollView;

@end

@implementation ZhuangXiangListTreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    canSelect = YES;
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    examNewType = @"";
    
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    [_rightButton setImage:[Image(@"lesson_screen_nor") converToMainColor] forState:UIControlStateSelected];
    
//    [self makeTopSearch];
    
    _mainTypeArray = [[NSMutableArray alloc] init];
    _mainSelectDict = [[NSMutableDictionary alloc] init];
    
    _dataSource = [NSMutableArray new];
    _originDict = [NSDictionary new];
    _originSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getZhuanXiangListData) name:@"reloadExamList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRightButton) name:@"hiddenSecondNewType" object:nil];
    [self getExamFirstTypeInfo];
}

- (void)makeMainTypeView {
    _mainTypeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainTypeBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    [self.view addSubview:_mainTypeBackView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMainTypeView)];
    _mainTypeBackView.userInteractionEnabled = YES;
    [_mainTypeBackView addGestureRecognizer:tap];
    _mainTypeBackView.hidden = YES;
    
    _mainTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 0)];
    _mainTypeScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainTypeScrollView];
    _mainTypeScrollView.hidden = YES;
}

- (void)makeMainTypeUI {
    [_mainTypeScrollView removeAllSubviews];
    CGFloat ww = (MainScreenWidth - 30 - 24) / 3.0;
    CGFloat hh = 32.0;
    NSString *selectType = [NSString stringWithFormat:@"%@",_mainSelectDict[@"id"]];
    for (int i = 0; i<_mainTypeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (ww + 12) * (i%3), 16 + (hh + 14) * (i/3), ww, 32)];
        btn.tag = 600 + i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.height / 2.0;
        [btn setTitle:[_mainTypeArray[i] objectForKey:@"title"] forState:0];
        btn.titleLabel.font = SYSTEMFONT(13);
        [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        btn.backgroundColor = EdlineV5_Color.backColor;
        if ([selectType isEqualToString:[NSString stringWithFormat:@"%@",[_mainTypeArray[i] objectForKey:@"id"]]]) {
            btn.selected = YES;
            btn.backgroundColor = EdlineV5_Color.buttonWeakeColor;
        }
        [btn addTarget:self action:@selector(mainTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mainTypeScrollView addSubview:btn];
        if (i == (_mainTypeArray.count - 1)) {
            [_mainTypeScrollView setHeight:(btn.bottom + 15) > (MainScreenHeight - MACRO_UI_UPHEIGHT) ? (MainScreenHeight - MACRO_UI_UPHEIGHT) : (btn.bottom + 15)];
            [_mainTypeScrollView setContentSize:CGSizeMake(0, btn.bottom + 15)];
        }
    }
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
//    [_tableView.mj_header beginRefreshing];
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
    [cell setZhuangXiangCellInfo:item cellIndex:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    if (SWNOTEmptyStr(_examModuleId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:_examModuleId forKey:@"module_id"];
        if (SWNOTEmptyStr(_institutionSearch.text)) {
            [param setObject:_institutionSearch.text forKey:@"title"];
        }
        if (SWNOTEmptyStr(examNewType)) {
            [param setObject:examNewType forKey:@"category"];
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
                            
                            NSArray *secondArray = obj.child;
                            [secondArray enumerateObjectsUsingBlock:^(ZhuanXiangModel *secondObj, NSUInteger idx, BOOL * _Nonnull stop) {
                                secondObj.orderNo = [NSString stringWithFormat:@"%@",@(idx)];
                                secondObj.parentID = obj.course_id;
                                secondObj.parentItem = obj;
                                [items addObject:secondObj];
                                
                                NSArray *thirdArray = secondObj.child;
                                [thirdArray enumerateObjectsUsingBlock:^(ZhuanXiangModel *thirdObj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    thirdObj.orderNo = [NSString stringWithFormat:@"%@",@(idx)];
                                    thirdObj.parentID = secondObj.course_id;
                                    thirdObj.parentItem = secondObj;
                                    [items addObject:thirdObj];
                                }];
                                
                            }];
                            
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
    if (SWNOTEmptyStr(_examModuleId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:_examModuleId forKey:@"module_id"];
        if (SWNOTEmptyStr(_institutionSearch.text)) {
            [param setObject:_institutionSearch.text forKey:@"title"];
        }
        if (SWNOTEmptyStr(examNewType)) {
            [param setObject:examNewType forKey:@"category"];
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
                        
                        NSArray *secondArray = obj.child;
                        [secondArray enumerateObjectsUsingBlock:^(ZhuanXiangModel *secondObj, NSUInteger idx, BOOL * _Nonnull stop) {
                            secondObj.orderNo = [NSString stringWithFormat:@"%@",@(idx)];
                            secondObj.parentID = obj.course_id;
                            secondObj.parentItem = obj;
                            [items addObject:secondObj];
                            
                            NSArray *thirdArray = secondObj.child;
                            [thirdArray enumerateObjectsUsingBlock:^(ZhuanXiangModel *thirdObj, NSUInteger idx, BOOL * _Nonnull stop) {
                                thirdObj.orderNo = [NSString stringWithFormat:@"%@",@(idx)];
                                thirdObj.parentID = secondObj.course_id;
                                thirdObj.parentItem = secondObj;
                                [items addObject:thirdObj];
                            }];
                            
                        }];
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
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if ([cell.treeItem.user_price floatValue]>0 && !cell.treeItem.has_bought) {
        // 购买
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_special";
        vc.orderId = cell.treeItem.course_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 开始答题
        
        if ([cell.treeItem.answered_num isEqualToString:@"0"]) {
            ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
            vc.examIds = cell.treeItem.course_id;
            vc.examType = _examTypeId;
            vc.examTitle = cell.treeItem.title;
            vc.examModuleId = _examModuleId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否继续上次作答？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
                vc.examIds = cell.treeItem.course_id;
                vc.examType = _examTypeId;
                vc.examTitle = cell.treeItem.title;
                vc.examModuleId = _examModuleId;
                vc.zhuanxiangCurrentTopicId = cell.treeItem.last_practice;
                [self.navigationController pushViewController:vc animated:YES];
                }];
            [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
            [alertController addAction:commentAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [Net_API requestDeleteWithURLStr:[Net_Path zhuanxiangDeleteRecordNet] paramDic:@{@"special_id":cell.treeItem.course_id} Api_key:nil finish:^(id  _Nonnull responseObject) {
                    if (SWNOTEmptyDictionary(responseObject)) {
                        if ([[responseObject objectForKey:@"code"] integerValue]) {
                            ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
                            vc.examIds = cell.treeItem.course_id;
                            vc.examType = _examTypeId;
                            vc.examTitle = cell.treeItem.title;
                            vc.examModuleId = _examModuleId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                } enError:^(NSError * _Nonnull error) {
                    [self showHudInView:self.view showHint:@"清空上次作答记录失败"];
                }];
                }];
            [cancelAction setValue:EdlineV5_Color.textFirstColor forKey:@"_titleTextColor"];
            [alertController addAction:cancelAction];
            alertController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)userExamBy:(ZhuangXiangListCell *)cell {
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
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
        // 只做提示 不做跳转
        [self showHudInView:self.view showHint:@"请先购买"];
        return;
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_special";
        vc.orderId = course_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if ([cell.treeItem.answered_num isEqualToString:@"0"]) {
            ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
            vc.examIds = cell.treeItem.course_id;//course_id;
            vc.examType = _examTypeId;
            vc.examTitle = cell.treeItem.title;
            vc.examModuleId = _examModuleId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // 开始答题
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否继续上次作答？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
                vc.examIds = cell.treeItem.course_id;//course_id;
                vc.examType = _examTypeId;
                vc.examTitle = cell.treeItem.title;
                vc.examModuleId = _examModuleId;
                vc.zhuanxiangCurrentTopicId = cell.treeItem.last_practice;
                [self.navigationController pushViewController:vc animated:YES];
                }];
            [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
            [alertController addAction:commentAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [Net_API requestDeleteWithURLStr:[Net_Path zhuanxiangDeleteRecordNet] paramDic:@{@"special_id":cell.treeItem.course_id} Api_key:nil finish:^(id  _Nonnull responseObject) {
                    if (SWNOTEmptyDictionary(responseObject)) {
                        if ([[responseObject objectForKey:@"code"] integerValue]) {
                            ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
                            vc.examIds = cell.treeItem.course_id;//course_id;
                            vc.examType = _examTypeId;
                            vc.examTitle = cell.treeItem.title;
                            vc.examModuleId = _examModuleId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                } enError:^(NSError * _Nonnull error) {
                    [self showHudInView:self.view showHint:@"清空上次作答记录失败"];
                }];
                }];
            [cancelAction setValue:EdlineV5_Color.textFirstColor forKey:@"_titleTextColor"];
            [alertController addAction:cancelAction];
            alertController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

/// 专项顶部分类
- (void)headerButtonCilck:(UIButton *)sender {
    _topCateButton.selected = !_topCateButton.selected;
    if (_topCateButton.selected) {
        [self makeMainTypeUI];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        _rightButton.selected = NO;
        _mainTypeBackView.hidden = NO;
        _mainTypeScrollView.hidden = NO;
    } else {
        _mainTypeBackView.hidden = YES;
        _mainTypeScrollView.hidden = YES;
    }
}

- (void)mainTypeButtonClick:(UIButton *)sender {
    _mainSelectDict = [NSMutableDictionary dictionaryWithDictionary:_mainTypeArray[sender.tag - 600]];
    [_topCateButton setTitle:[NSString stringWithFormat:@"%@",_mainSelectDict[@"title"]] forState:0];
    [EdulineV5_Tool dealButtonImageAndTitleUI:_topCateButton];
    _topCateButton.selected = NO;
    _mainTypeBackView.hidden = YES;
    _mainTypeScrollView.hidden = YES;
    
    examNewType = [NSString stringWithFormat:@"%@",_mainSelectDict[@"id"]];
    if (_tableView.mj_header.refreshing) {
        [_tableView.mj_header endRefreshing];
    }
    [_tableView.mj_header beginRefreshing];
}

- (void)hiddenMainTypeView {
    _topCateButton.selected = NO;
    _mainTypeBackView.hidden = YES;
    _mainTypeScrollView.hidden = YES;
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    if (_rightButton.selected) {
        [self hiddenMainTypeView];
        ExamNewSecendTypeVC *vc = [[ExamNewSecendTypeVC alloc] init];
        vc.typeString = [NSString stringWithFormat:@"%@",_mainSelectDict[@"title"]];
        vc.typeId = [NSString stringWithFormat:@"%@",_mainSelectDict[@"id"]];
        vc.notHiddenNav = NO;
        vc.hiddenNavDisappear = YES;
        vc.delegate = self;
//        vc.delegate = self;
//        if (SWNOTEmptyStr(coursetypeIdString)) {
//            vc.typeId = coursetypeIdString;
//        }
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    }
}

- (void)getExamFirstTypeInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examFirstTypeNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            [_mainTypeArray removeAllObjects];
            [_mainTypeArray addObjectsFromArray:responseObject[@"data"]];
            if (SWNOTEmptyArr(_mainTypeArray)) {
                _mainSelectDict = [NSMutableDictionary dictionaryWithDictionary:_mainTypeArray[0]];
                examNewType = [NSString stringWithFormat:@"%@",_mainSelectDict[@"id"]];
                if (_tableView.mj_header.refreshing) {
                    [_tableView.mj_header endRefreshing];
                }
                [_tableView.mj_header beginRefreshing];
            }
            if (SWNOTEmptyDictionary(_mainSelectDict)) {
                NSString *selectString = [NSString stringWithFormat:@"%@",_mainSelectDict[@"title"]];
                CGFloat selectStringWitdh = [selectString sizeWithFont:SYSTEMFONT(18)].width;
                _topCateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _titleLabel.width, _titleLabel.height)];
                _topCateButton.titleLabel.font = SYSTEMFONT(18);
                [_topCateButton setTitle:selectString forState:UIControlStateNormal];
                [_topCateButton setImage:Image(@"exam_navbar_down") forState:0];
                [_topCateButton setImage:Image(@"exam_navbar_up") forState:UIControlStateSelected];
                [_topCateButton setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateNormal];
                [EdulineV5_Tool dealButtonImageAndTitleUI:_topCateButton];
                [_topCateButton addTarget:self action:@selector(headerButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
                _topCateButton.center = _titleLabel.center;
                [_titleImage addSubview:_topCateButton];
            }
            [self makeMainTypeView];
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)chooseExamType:(NSDictionary *)info {
    examNewType = [NSString stringWithFormat:@"%@",info[@"examType"]];
    [_tableView.mj_header beginRefreshing];
}

- (void)changeRightButton {
    _rightButton.selected = NO;
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
