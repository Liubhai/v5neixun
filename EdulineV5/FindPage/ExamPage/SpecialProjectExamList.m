//
//  SpecialProjectExamList.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SpecialProjectExamList.h"
#import "SpecialExamListCell.h"
#import "TeacherCategoryVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"

#import "CourseTypeVC.h"

@interface SpecialProjectExamList ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, SpecialExamListCellDelegate, TeacherCategoryVCDelegate, CourseTypeVCDelegate> {
    NSInteger page;
    
    // 课程类型
    NSString *coursetypeString;
    NSString *coursetypeIdString;
}

@property (strong, nonatomic) UITextField *institutionSearch;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation SpecialProjectExamList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    [_rightButton setImage:[Image(@"lesson_screen_nor") converToMainColor] forState:UIControlStateSelected];
    [self makeTopSearch];
    
    coursetypeIdString = @"";
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top - 2, _titleLabel.width, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索考试名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
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
    _tableView.backgroundColor = EdlineV5_Color.backColor;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SpecialExamListCell";
    SpecialExamListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[SpecialExamListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setPublicExamCell:_dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 103;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getOrExamButtonWith:(SpecialExamListCell *)cell {
    
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    // 大类型
    if (SWNOTEmptyStr(_examTypeId)) {
        [param setObject:_examTypeId forKey:@"module_id"];
    }
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"category"];
    }
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:SWNOTEmptyStr(_institutionSearch.text) ? [Net_Path openingExamListSearchNet] : [Net_Path openingExamListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
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
    // 大类型
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"category"];
    }
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

- (void)rightButtonClick:(id)sender {
    
    _rightButton.selected = !_rightButton.selected;
    if (_rightButton.selected) {
//        TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
//        vc.notHiddenNav = NO;
//        vc.hiddenNavDisappear = YES;
//        vc.typeString = @"0";
//        vc.delegate = self;
//        vc.isChange = YES;
//        vc.isDownExpend = YES;
//        vc.tableviewHeight = MainScreenHeight - MACRO_UI_UPHEIGHT - 120;
//        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
//        vc.view.layer.backgroundColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor;
//        [self.view addSubview:vc.view];
//        [self addChildViewController:vc];
        CourseTypeVC *vc = [[CourseTypeVC alloc] init];
        vc.typeString = @"exam";
        vc.notHiddenNav = NO;
        vc.isMainPage = NO;
        vc.hiddenNavDisappear = YES;
        vc.delegate = self;
        if (SWNOTEmptyStr(coursetypeIdString)) {
            vc.typeId = coursetypeIdString;
        }
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    }
}

- (void)chooseCourseType:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        coursetypeString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        coursetypeIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _rightButton.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)chooseCategoryModel:(TeacherCategoryModel *)model {
//    courseClassifyString = [NSString stringWithFormat:@"%@",model.title];
//    courseClassifyIdString = [NSString stringWithFormat:@"%@",model.cateGoryId];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    _rightButton.selected = !_rightButton.selected;
//    [self getCourseMainList];
}

// MARK: - 选择更换资讯类型代理
- (void)chooseCategoryId:(NSString *)categoryId {
    coursetypeIdString = categoryId;
    [self.tableView.mj_header beginRefreshing];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
