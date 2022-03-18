//
//  TaojuanListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "TaojuanListViewController.h"
#import "SpecialExamListCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "TaojuanDetailListViewController.h"
#import "ExamPaperDetailViewController.h"
#import "OrderViewController.h"
#import "FaceVerifyViewController.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"

#import "ExamNewSecendTypeVC.h"

@interface TaojuanListViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, SpecialExamListCellDelegate, ExamNewSecendTypeVCDelegate> {
    NSInteger page;
    NSString *examNewType;/// 新优化选择的分类
}

@property (strong, nonatomic) UITextField *institutionSearch;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIButton *topCateButton;

@property (strong, nonatomic) UIView *mainTypeBackView;
@property (strong, nonatomic) UIScrollView *mainTypeScrollView;

@end


@implementation TaojuanListViewController

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
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top - 2, MainScreenWidth - _leftButton.width - 15, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索套卷名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
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
    [cell setExamPointCell:_dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaojuanDetailListViewController *vc = [[TaojuanDetailListViewController alloc] init];
    vc.module_title = _module_title;
    vc.rollup_id = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getOrExamButtonWith:(SpecialExamListCell *)cell {
    
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    
    if ([cell.getOrExamBtn.titleLabel.text isEqualToString:@"开始答题"]) {
        ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
        vc.examType = _module_id;
        vc.examModuleId = _examModuleId;
        vc.examIds = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"first_paper_id"]];
        vc.rollup_id = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 购买
        OrderViewController *vc = [[OrderViewController alloc] init];
        vc.orderTypeString = @"exam_volume";
        vc.orderId = [NSString stringWithFormat:@"%@",[cell.specialInfo objectForKey:@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_examModuleId)) {
        [param setObject:_examModuleId forKey:@"module_id"];
    }
    if (SWNOTEmptyStr(examNewType)) {
        [param setObject:examNewType forKey:@"category"];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:SWNOTEmptyStr(_institutionSearch.text) ? [Net_Path setOfVolumeSearchNet] : [Net_Path setOfVolumeListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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
    if (SWNOTEmptyStr(examNewType)) {
        [param setObject:examNewType forKey:@"category"];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [Net_API requestGETSuperAPIWithURLStr:SWNOTEmptyStr(_institutionSearch.text) ? [Net_Path setOfVolumeSearchNet] : [Net_Path setOfVolumeListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        [_tableView.mj_header beginRefreshing];
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
//                self.taojuanUserFaceVerifyResult(result);
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
                self.taojuanUserFaceVerifyResult(result);
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
