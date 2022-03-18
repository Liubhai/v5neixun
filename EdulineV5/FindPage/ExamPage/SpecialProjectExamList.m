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
#import "ExamDetailViewController.h"
#import "ExamPaperDetailViewController.h"
#import "OrderViewController.h"

#import "FaceVerifyViewController.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"

#import "ExamNewSecendTypeVC.h"

@interface SpecialProjectExamList ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, SpecialExamListCellDelegate, TeacherCategoryVCDelegate, CourseTypeVCDelegate, ExamNewSecendTypeVCDelegate> {
    NSInteger page;
    
    // 课程类型
    NSString *coursetypeString;
    NSString *coursetypeIdString;
    BOOL shouldLoad;
    NSString *examNewType;/// 新优化选择的分类
}

@property (strong, nonatomic) UITextField *institutionSearch;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIButton *topCateButton;

@property (strong, nonatomic) UIView *mainTypeBackView;
@property (strong, nonatomic) UIScrollView *mainTypeScrollView;

@end

@implementation SpecialProjectExamList

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (shouldLoad) {
        [self getFirstList];
    }
    shouldLoad = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    examNewType = @"";
    
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    [_rightButton setImage:[Image(@"lesson_screen_nor") converToMainColor] forState:UIControlStateSelected];
    
//    [self makeTopSearch];
    
    _mainTypeArray = [[NSMutableArray alloc] init];
    _mainSelectDict = [[NSMutableDictionary alloc] init];
    
    coursetypeIdString = @"";
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstList) name:@"reloadExamList" object:nil];
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
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
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
    return 119;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getOrExamButtonWith:(SpecialExamListCell *)cell {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    if ([cell.getOrExamBtn.titleLabel.text isEqualToString:@"开始答题"]) {
        NSString *exam_number = [NSString stringWithFormat:@"%@",cell.specialInfo[@"exam_rest_num"]];
        if ([exam_number isEqualToString:@"0"]) {
            [self showHudInView:self.view showHint:@"考试次数已用完"];
            return;
        }
        
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            self.specialuserFaceVerifyResult = ^(BOOL result) {
                if (result) {
                    ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
                    vc.examType = _examTypeId;
                    vc.examIds = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"paper_id"]];
                    vc.examModuleId = _examModuleId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
                [self faceCompareTip:[NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"paper_id"]]];
            } else {
                [self faceVerifyTip];
            }
        } else {
            ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
            vc.examType = _examTypeId;
            vc.examIds = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"paper_id"]];
            vc.examModuleId = _examModuleId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([cell.getOrExamBtn.titleLabel.text isEqualToString:@"购买"]) {
        // 购买
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_public";
        vc.orderId = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"paper_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    // 大类型
    if (SWNOTEmptyStr(_examModuleId)) {
        [param setObject:_examModuleId forKey:@"module_id"];
    }
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"category"];
    }
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    if (SWNOTEmptyStr(examNewType)) {
        [param setObject:examNewType forKey:@"category"];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
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
    if (SWNOTEmptyStr(_examModuleId)) {
        [param setObject:_examModuleId forKey:@"module_id"];
    }
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"category"];
    }
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    if (SWNOTEmptyStr(examNewType)) {
        [param setObject:examNewType forKey:@"category"];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:SWNOTEmptyStr(_institutionSearch.text) ? [Net_Path openingExamListSearchNet] : [Net_Path openingExamListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

//- (void)rightButtonClick:(id)sender {
//
//    _rightButton.selected = !_rightButton.selected;
//    if (_rightButton.selected) {
////        TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
////        vc.notHiddenNav = NO;
////        vc.hiddenNavDisappear = YES;
////        vc.typeString = @"0";
////        vc.delegate = self;
////        vc.isChange = YES;
////        vc.isDownExpend = YES;
////        vc.tableviewHeight = MainScreenHeight - MACRO_UI_UPHEIGHT - 120;
////        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
////        vc.view.layer.backgroundColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor;
////        [self.view addSubview:vc.view];
////        [self addChildViewController:vc];
//        CourseTypeVC *vc = [[CourseTypeVC alloc] init];
//        vc.typeString = @"exam";
//        vc.notHiddenNav = NO;
//        vc.isMainPage = NO;
//        vc.hiddenNavDisappear = YES;
//        vc.delegate = self;
//        if (SWNOTEmptyStr(coursetypeIdString)) {
//            vc.typeId = coursetypeIdString;
//        }
//        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
//        [self.view addSubview:vc.view];
//        [self addChildViewController:vc];
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
//    }
//}

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
        [self.tableView.mj_header beginRefreshing];
        return NO;
    }
    return YES;
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
//                self.specialuserFaceVerifyResult(result);
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
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 人脸识别提示
- (void)faceCompareTip:(NSString *)courseHourseId {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请进行人脸验证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = NO;
        vc.verifyed = YES;
        vc.sourceType = @"exam";
        vc.sourceId = courseHourseId;
        vc.scene_type = @"1";
        vc.verifyResult = ^(BOOL result) {
            if (result) {
                self.specialuserFaceVerifyResult(result);
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

@end
