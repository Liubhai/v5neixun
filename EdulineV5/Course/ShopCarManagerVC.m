//
//  ShopCarManagerVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/30.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShopCarManagerVC.h"
#import "KaquanCell.h"
#import "ShopCarCell.h"
#import "V5_Constant.h"
#import "LingquanViewController.h"
#import "ShopCarManagerFinalVC.h"
#import "Net_Path.h"
#import "ShopCarModel.h"

@interface ShopCarManagerVC ()<UITableViewDelegate,UITableViewDataSource,ShopCarCellDelegate> {
    NSString *course_ids;
    BOOL allSeleted;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation ShopCarManagerVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!SWNOTEmptyArr(_dataSourse)) {
        [self getUserShopCarInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    course_ids = @"";
    allSeleted = NO;
    _titleLabel.text = @"购物车";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"管理" forState:0];
    [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    _rightButton.hidden = NO;
    _dataSourse = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    [self makeTableView];
    [self makeDownView];
    [self getUserShopCarInfo];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserShopCarInfo) name:@"getCouponsReload" object:nil];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    NSString *openText = @"全选";
    CGFloat openWidth = [openText sizeWithFont:SYSTEMFONT(13)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, openWidth, 30)];
    [_allSelectBtn setImage:Image(@"checkbox_orange") forState:UIControlStateSelected];
    [_allSelectBtn setImage:Image(@"checkbox_def") forState:0];
    [_allSelectBtn setTitle:@"全选" forState:0];
    [_allSelectBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _allSelectBtn.titleLabel.font = SYSTEMFONT(13);
    _allSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_allSelectBtn addTarget:self action:@selector(headSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _allSelectBtn.centerY = 49/2.0;
    [_bottomView addSubview:_allSelectBtn];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 110, 0, 110, 36)];
    [_submitButton setTitle:@"去结算" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerY = _allSelectBtn.centerY;
    [_submitButton addTarget:self action:@selector(submiteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
    
    _finalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_submitButton.left - 200 - 15, 0, 200, 49)];
    _finalPriceLabel.textColor = EdlineV5_Color.faildColor;
    _finalPriceLabel.font = SYSTEMFONT(15);
    _finalPriceLabel.text = @"合计: ¥0.00";
    _finalPriceLabel.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:_finalPriceLabel];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_bottomView addSubview:line];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth/2.0, 49)];
    [_deleteBtn setTitleColor:EdlineV5_Color.youhuijuanColor forState:0];
    _deleteBtn.titleLabel.font = SYSTEMFONT(16);
    [_deleteBtn setTitle:@"删除" forState:0];
    [_deleteBtn addTarget:self action:@selector(deleteCourses:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
    
    _midLine = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, 0.5, 12)];
    _midLine.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_bottomView addSubview:_midLine];
    _midLine.centerY = _deleteBtn.centerY;
    _midLine.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourse.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShopCarModel *model = _dataSourse[section];
    return model.course_list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShopCarModel *model = _dataSourse[section];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 70)];
    head.backgroundColor = [UIColor whiteColor];
    UIView *jiange = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 9.5)];
    jiange.backgroundColor = EdlineV5_Color.fengeLineColor;
    [head addSubview:jiange];
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 24.5, 30, 30)];
    [selectBtn setImage:Image(@"checkbox_orange") forState:UIControlStateSelected];
    [selectBtn setImage:Image(@"checkbox_def") forState:0];
    [selectBtn addTarget:self action:@selector(headSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag = section;
    [head addSubview:selectBtn];
    selectBtn.selected = model.selected;
    UILabel *jigouTitle = [[UILabel alloc] initWithFrame:CGRectMake(selectBtn.right + 7, 9.5, 150, 60)];
    jigouTitle.textColor = EdlineV5_Color.textFirstColor;
    jigouTitle.text = [NSString stringWithFormat:@"%@",model.school_name];
    [head addSubview:jigouTitle];
    UIButton *lingquan = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 9.5, 30, 60)];
    [lingquan setTitle:@"领券" forState:0];
    [lingquan setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    lingquan.titleLabel.font = SYSTEMFONT(13);
    [lingquan addTarget:self action:@selector(lingquanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    lingquan.tag = section;
    [head addSubview:lingquan];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [head addSubview:line];
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ShopCarCell";
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShopCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellType:YES];
    }
    cell.delegate = self;
    ShopCarModel *model = _dataSourse[indexPath.section];
    ShopCarCourseModel *courseModel = model.course_list[indexPath.row];
    [cell setShopCarCourseInfo:courseModel cellIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (void)headSelectBtnClick:(UIButton *)sender {
    if (sender == _allSelectBtn) {
        _allSelectBtn.selected = !sender.selected;
        allSeleted = _allSelectBtn.selected;
        
        for (int i = 0; i < _dataSourse.count; i ++) {
            ShopCarModel *carModel = _dataSourse[i];
            carModel.selected = allSeleted;
            NSMutableArray *pass = [NSMutableArray arrayWithArray:carModel.course_list];
            for (int j = 0; j < pass.count; j ++) {
                ShopCarCourseModel *courseModel = pass[j];
                courseModel.selected = allSeleted;
                [pass replaceObjectAtIndex:j withObject:courseModel];
            }
            carModel.course_list = [NSArray arrayWithArray:pass];
            [_dataSourse replaceObjectAtIndex:i withObject:carModel];
        }
    } else {
        sender.selected = !sender.selected;
        ShopCarModel *model = _dataSourse[sender.tag];
        NSMutableArray *pass = [NSMutableArray arrayWithArray:model.course_list];
        
        for (int i = 0; i < pass.count; i++) {
            ShopCarCourseModel *courseModel = pass[i];
            courseModel.selected = sender.selected;
            [pass replaceObjectAtIndex:i withObject:courseModel];
        }
        
        model.course_list = [NSArray arrayWithArray:pass];
        model.selected = sender.selected;
        [_dataSourse replaceObjectAtIndex:sender.tag withObject:model];
        
        // 判断每一个机构是不是全选与否
        for (int i = 0; i < _dataSourse.count; i ++) {
            ShopCarModel *carModel = _dataSourse[i];
            BOOL carSelect = carModel.selected;
            for (int j = 0; j < carModel.course_list.count; j ++) {
                ShopCarCourseModel *courseModel = carModel.course_list[j];
                if (courseModel.selected) {
                    carSelect = YES;
                } else {
                    carSelect = NO;
                    break;
                }
            }
            carModel.selected = carSelect;
            [_dataSourse replaceObjectAtIndex:i withObject:carModel];
            
            if (carModel.selected) {
                allSeleted = YES;
            } else {
                allSeleted = NO;
                break;
            }
        }
        _allSelectBtn.selected = allSeleted;
    }
    [self dealDataSource];
    [_tableView reloadData];
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    if (_rightButton.selected) {
        _allSelectBtn.centerX = MainScreenWidth / 4.0;
        _midLine.hidden = NO;
        _deleteBtn.hidden = NO;
        _finalPriceLabel.hidden = YES;
        _submitButton.hidden = YES;
    } else {
        [_allSelectBtn setLeft:10];
        _midLine.hidden = YES;
        _deleteBtn.hidden = YES;
        _finalPriceLabel.hidden = NO;
        _submitButton.hidden = NO;
    }
}

- (void)lingquanButtonClicked:(UIButton *)sender {
    LingquanViewController *vc = [[LingquanViewController alloc] init];
    ShopCarModel *model = _dataSourse[sender.tag];
    vc.mhm_id = model.mhm_id;
    vc.getOrUse = YES;
    vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}

- (void)submiteButtonClick:(UIButton *)sender {
    
    course_ids = @"";
    BOOL hasCoureCard = NO;
    for (int i = 0; i<_selectedArray.count; i ++) {
        ShopCarCourseModel *model = _selectedArray[i];
        if (model.has_course_card) {
            hasCoureCard = YES;
        }
        if (SWNOTEmptyStr(course_ids)) {
            course_ids = [NSString stringWithFormat:@"%@,%@",course_ids,model.courseId];
        } else {
            course_ids = model.courseId;
        }
    }
    if (!SWNOTEmptyStr(course_ids)) {
        [self showHudInView:self.view showHint:@"请选择一个商品"];
        return;
    }
    if (hasCoureCard) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"订单含有课程卡课程 是否取消勾选？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"继续付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShopCarManagerFinalVC *vc = [[ShopCarManagerFinalVC alloc] init];
            vc.course_ids = course_ids;
            [self.navigationController pushViewController:vc animated:YES];
            }];
        [alertController addAction:commentAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"去取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    ShopCarManagerFinalVC *vc = [[ShopCarManagerFinalVC alloc] init];
    vc.course_ids = course_ids;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - ShopCarCellDelegate(购物车选择代理)
- (void)chooseWhichCourse:(ShopCarCell *)shopCarCell {
    // 第一要改变数据源
    shopCarCell.courseModel.selected = shopCarCell.selectedIconBtn.selected;
    
    ShopCarCourseModel *cellCourseModel = shopCarCell.courseModel;
    NSIndexPath *path = shopCarCell.cellIndex;
    
    ShopCarModel *model = _dataSourse[path.section];
    NSMutableArray *pass = [NSMutableArray arrayWithArray:model.course_list];
    [pass replaceObjectAtIndex:path.row withObject:cellCourseModel];
    model.course_list = [NSArray arrayWithArray:pass];
    [_dataSourse replaceObjectAtIndex:path.section withObject:model];
    
    // 判断每一个机构是不是全选与否
    BOOL hasSectionSchoolUnSelect = NO;
    for (int i = 0; i < _dataSourse.count; i ++) {
        ShopCarModel *carModel = _dataSourse[i];
        BOOL carSelect = carModel.selected;
        for (int j = 0; j < carModel.course_list.count; j ++) {
            ShopCarCourseModel *courseModel = carModel.course_list[j];
            if (courseModel.selected) {
                carSelect = YES;
            } else {
                carSelect = NO;
                break;
            }
        }
        carModel.selected = carSelect;
        [_dataSourse replaceObjectAtIndex:i withObject:carModel];
        
        // 判断是不是所有都选择了
        if (!carModel.selected) {
            // 说明有机构没有全选
            hasSectionSchoolUnSelect = YES;
        }
    }
    
    allSeleted = !hasSectionSchoolUnSelect;
    
    _allSelectBtn.selected = allSeleted;
    
    
    [self dealDataSource];
    
    // 第二 刷新页面
    [_tableView reloadData];
}

// MARK: - 删除课程商品
- (void)deleteCourses:(UIButton *)sender {
    if (SWNOTEmptyArr(_selectedArray)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要将这些课程移除购物车?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteShopCarCourse];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:commentAction];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)deleteShopCarCourse {
    course_ids = @"";
    for (int i = 0; i<_selectedArray.count; i ++) {
        ShopCarCourseModel *model = _selectedArray[i];
        if (SWNOTEmptyStr(course_ids)) {
            course_ids = [NSString stringWithFormat:@"%@,%@",course_ids,model.courseId];
        } else {
            course_ids = model.courseId;
        }
    }
    if (SWNOTEmptyStr(course_ids)) {
        [Net_API requestDeleteWithURLStr:[Net_Path deleteCourseFromShopcar] paramDic:@{@"course_ids":course_ids} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
            [self getUserShopCarInfo];
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 处理已选择的课程进 selectedArray
- (void)dealDataSource {
    [_selectedArray removeAllObjects];
    float allMoney = 0.00;
    for (int i = 0; i<_dataSourse.count; i++) {
        ShopCarModel *carModel = _dataSourse[i];
        for (int j = 0; j < carModel.course_list.count; j++) {
            ShopCarCourseModel *courseModel = carModel.course_list[j];
            if (courseModel.selected) {
                [_selectedArray addObject:courseModel];
                allMoney = allMoney + courseModel.price.floatValue;
            }
        }
    }
    _finalPriceLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f",allMoney];
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%@)",@(_selectedArray.count)] forState:0];
}

- (void)getUserShopCarInfo {
    [_selectedArray removeAllObjects];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userShopcarInfo] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSourse removeAllObjects];
                [_dataSourse addObjectsFromArray:[ShopCarModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
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
