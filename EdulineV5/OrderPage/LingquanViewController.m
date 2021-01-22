//
//  LingquanViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/31.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LingquanViewController.h"
#import "KaquanCell.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import "Net_Path.h"

@interface LingquanViewController ()<UITableViewDelegate,UITableViewDataSource,KaquanCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *changeStatusArray;

@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIView *bottomBackView;
@property (strong, nonatomic) UIButton *suerButton;

@end

@implementation LingquanViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = [AppDelegate delegate];
    RootV5VC * nv = (RootV5VC *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    _changeStatusArray = [NSMutableArray new];
    _titleImage.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self makeTopView];
    [self makeTableView];
//    if (_getOrUse) {
//        [self makeBottomView];
//    }
    [self makeBottomView];
    [self getcouponsList];
}

- (void)makeTopView {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MainScreenWidth, MainScreenHeight - 90)];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 17;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 52)];
    if (_getOrUse) {
        _themeLabel.text = @"领券";
    } else {
        _themeLabel.text = @"卡券";
    }
    _themeLabel.font = SYSTEMFONT(16);
    _themeLabel.centerX = MainScreenWidth / 2.0;
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [_whiteView addSubview:_themeLabel];
}

- (void)makeTableView {
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _whiteView.top + 52, MainScreenWidth, MainScreenHeight - (_whiteView.top + 52) - (_getOrUse ? MACRO_UI_TABBAR_HEIGHT : 0)) style:UITableViewStyleGrouped];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _whiteView.top + 52, MainScreenWidth, MainScreenHeight - (_whiteView.top + 52) - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (void)makeBottomView {
    _bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBackView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_bottomBackView addSubview:line];
    
    _suerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (49 - 36) / 2.0, 320, 36)];
    _suerButton.centerX = MainScreenWidth / 2.0;
    _suerButton.layer.masksToBounds = YES;
    _suerButton.layer.cornerRadius = 18;
    [_suerButton setTitle:@"确定" forState:0];
    [_suerButton setTitleColor:[UIColor whiteColor] forState:0];
    _suerButton.titleLabel.font = SYSTEMFONT(16);
    _suerButton.backgroundColor = EdlineV5_Color.themeColor;
    [_suerButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBackView addSubview:_suerButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CouponArrayModel *model = _dataSource[section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"KaquanCell1";
    CouponArrayModel *model = _dataSource[indexPath.section];
    CouponModel *model1 = model.list[indexPath.row];
    KaquanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[KaquanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellType:model1.coupon_type getOrUse:_getOrUse useful:((SWNOTEmptyStr(_mhm_id) && _carModel) ? model.useful : YES) myCouponListtype:@""];
    }
    [cell setCouponInfo:model1 cellIndexPath:indexPath isMyCouponsList:NO];
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CouponArrayModel *model = _dataSource[section];
    if (!SWNOTEmptyArr(model.list)) {
        return nil;
    }
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
    sectionLabel.text = [NSString stringWithFormat:@"%@",((CouponArrayModel *)_dataSource[section]).coupon_type_text];
    sectionLabel.font = SYSTEMFONT(14);
    sectionLabel.textColor = EdlineV5_Color.textThirdColor;
    [view1 addSubview:sectionLabel];
    return view1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CouponArrayModel *model = _dataSource[section];
    if (!SWNOTEmptyArr(model.list)) {
        return 0.001;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)sureButtonClicked:(UIButton *)sender {
    if (_getOrUse) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCouponsReload" object:nil];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)getcouponsList {
    if (SWNOTEmptyStr(_mhm_id)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:_mhm_id forKey:@"mhm_id"];
        [param setObject:@"1" forKey:@"group"];
        if (_carModel) {
            if (_carModel.mhm_id) {
                [param setObject:@(_carModel.total_price) forKey:@"price"];
            }
        }
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.frame.size.height];
        [Net_API requestGETSuperAPIWithURLStr:_getOrUse ? [Net_Path schoolCouponList] : [Net_Path couponsUserList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[CouponArrayModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
                    [self removeUsedCoupon];
                    [self changeDataSourceIsUseStatus];
                    NSInteger modelCount = 0;
                    for (CouponArrayModel *object in _dataSource) {
                        modelCount = modelCount + object.list.count;
                    }
                    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:modelCount isLoading:NO tableViewShowHeight:_tableView.frame.size.height];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        if (SWNOTEmptyStr(_courseId)) {
            [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.frame.size.height];
            [Net_API requestGETSuperAPIWithURLStr:_getOrUse ? [Net_Path courseCouponList] : [Net_Path courseCouponUserList] WithAuthorization:nil paramDic:@{@"course_id":_courseId,@"group":@"1"} finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        [_dataSource removeAllObjects];
                        [_dataSource addObjectsFromArray:[CouponArrayModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
                        [self removeUsedCoupon];
                        [self changeDataSourceIsUseStatus];
                        NSInteger modelCount = 0;
                        for (CouponArrayModel *object in _dataSource) {
                            modelCount = modelCount + object.list.count;
                        }
                        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:modelCount isLoading:NO tableViewShowHeight:_tableView.frame.size.height];
                        [_tableView reloadData];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

// MARK: - KaquanCellDelegate(cell按钮点击事件)
- (void)useOrGetAction:(KaquanCell *)cell {
    if (_getOrUse) {
        [Net_API requestPOSTWithURLStr:[Net_Path getWhichCoupon:cell.couponModel.couponId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    CouponModel *model = cell.couponModel;
                    model.user_has = YES;
                    CouponArrayModel *model1 = _dataSource[cell.cellIndexpath.section];
                    NSMutableArray *list = [NSMutableArray arrayWithArray:model1.list];
                    [list replaceObjectAtIndex:cell.cellIndexpath.row withObject:model];
                    model1.list = [NSArray arrayWithArray:list];
                    [_dataSource replaceObjectAtIndex:cell.cellIndexpath.section withObject:model1];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        if (_shopCarFinalIndexPath) {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseWhichCoupon:shopCarFinalIndexPath:)]) {
                [_delegate chooseWhichCoupon:cell.couponModel shopCarFinalIndexPath:_shopCarFinalIndexPath];
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            }
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseWhichCoupon:)]) {
                [_delegate chooseWhichCoupon:cell.couponModel];
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            }
        }
    }
}

// MARK: - 改变数据源是否使用的状态
- (void)changeDataSourceIsUseStatus {
    if (_couponModel) {
        if (SWNOTEmptyStr(_couponModel.couponId)) {
            for (int i = 0; i<_dataSource.count; i++) {
                CouponArrayModel *model1 = _dataSource[i];
                [_changeStatusArray removeAllObjects];
                [_changeStatusArray addObjectsFromArray:model1.list];
                for (int j = 0; j<model1.list.count; j++) {
                    CouponModel *model2 = model1.list[j];
                    if ([model2.couponId isEqualToString:_couponModel.couponId]) {
                        model2.IsUsed = YES;
                        [_changeStatusArray replaceObjectAtIndex:j withObject:model2];
                        model1.list = [NSArray arrayWithArray:_changeStatusArray];
                        [_dataSource replaceObjectAtIndex:i withObject:model1];
                        return;
                    }
                }
            }
        }
    }
}

- (void)removeUsedCoupon {
    for (int i = 0; i<_dataSource.count; i++) {
        CouponArrayModel *model1 = _dataSource[i];
        NSMutableArray *pass = [NSMutableArray new];
        [pass addObjectsFromArray:model1.list];
        for (NSInteger j = (pass.count - 1); j>=0; j--) {
            CouponModel *model2 = pass[j];
            if (model2.user_use) {
                [pass removeObject:model2];
            }
        }
        model1.list = [NSArray arrayWithArray:pass];
        [_dataSource replaceObjectAtIndex:i withObject:model1];
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
