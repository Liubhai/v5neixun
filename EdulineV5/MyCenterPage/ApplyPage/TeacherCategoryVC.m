//
//  TeacherCategoryVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeacherCategoryVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "CourseCommonCell.h"

@interface TeacherCategoryVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger currentSelectRow;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSMutableArray *secondArray;
@property (strong, nonatomic) NSMutableArray *thirdArray;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation TeacherCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];
    
    currentSelectRow = 0;
    _titleLabel.text = @"选择所属行业";
    [_leftButton setImage:Image(@"categoryClose") forState:0];
    
    _rightButton.frame = CGRectMake(MainScreenWidth - 15 - 50, 0, 50, 28);
    _rightButton.layer.masksToBounds = YES;
    _rightButton.layer.cornerRadius = 3;
    _rightButton.centerY = _titleLabel.centerY;
    [_rightButton setTitle:@"确定" forState:0];
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    _rightButton.backgroundColor = EdlineV5_Color.themeColor;
    _rightButton.hidden = NO;
    
    if ([_typeString isEqualToString:@"0"]) {
        _titleLabel.text = _isChange ? @"选择意向课程" : @"更改意向课程";
        _rightButton.hidden = YES;
    }
    
    if ([_typeString isEqualToString:@"5"]) {
        _titleLabel.text = @"资讯";
        _rightButton.hidden = YES;
    }
    
    if ([_typeString isEqualToString:@"1"]) {
        _titleLabel.text = @"讲师";
        _rightButton.hidden = YES;
    }
    
    if ([_typeString isEqualToString:@"2"]) {
        _titleLabel.text = @"机构";
        _rightButton.hidden = YES;
    }
    
    if (_isApply) {
        _rightButton.hidden = NO;
    }
    
    if (_isDownExpend) {
        _titleImage.hidden = YES;
        self.view.hidden = YES;
    }
    
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    
    _firstArray = [NSMutableArray new];
    _secondArray = [NSMutableArray new];
    _thirdArray = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    [self maketableView];
    [self getTeacherClassifyList];
    
}

- (void)maketableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _isDownExpend ? 0 : MACRO_UI_UPHEIGHT, MainScreenWidth / 4.0, _isDownExpend ? _tableviewHeight : (MainScreenHeight - MACRO_UI_UPHEIGHT))];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(MainScreenWidth / 4.0, _isDownExpend ? 0 : MACRO_UI_UPHEIGHT, MainScreenWidth * 3 / 4.0, _tableView.height)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _firstArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SearchHistoryListCell";
    CourseCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse showOneLine:NO];
    }
    if (currentSelectRow == indexPath.row) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.LeftLineView.hidden = NO;
        cell.themeLabel.textColor = EdlineV5_Color.textFirstColor;
    } else {
        cell.backgroundColor = EdlineV5_Color.backColor;
        cell.LeftLineView.hidden = YES;
        cell.themeLabel.textColor = EdlineV5_Color.textSecendColor;
    }
    [cell setCategoryInfo:_firstArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentSelectRow = indexPath.row;
    [self.tableView reloadData];
    [self makeScrollViewSubView:_firstArray[indexPath.row]];
}

// MARK: - 布局右边分类视图
- (void)makeScrollViewSubView:(TeacherCategoryModel *)selectedInfo {
    if (_mainScrollView) {
        [_mainScrollView removeAllSubviews];
    }
//    if (!SWNOTEmptyArr(selectedInfo.child)) {
//        // 要添加一个全部按钮
//        return;
//    }
    
    NSString *allTitle = [NSString stringWithFormat:@"%@",selectedInfo.all.title];//@"热门搜索";
    CGFloat allBtnWidth = [allTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 7;
    UIButton *alldBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, allBtnWidth, 32)];
    alldBtn.tag = 200 + currentSelectRow;
    [alldBtn setImage:Image(@"erji_more") forState:0];
    [alldBtn setImage:[Image(@"erji_more") converToMainColor] forState:UIControlStateSelected];
    [alldBtn setTitle:allTitle forState:0];
    alldBtn.titleLabel.numberOfLines = 0;
    alldBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [alldBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [alldBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    alldBtn.selected = selectedInfo.selected;
    alldBtn.titleLabel.font = SYSTEMFONT(15);
    [alldBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -alldBtn.currentImage.size.width, 0, alldBtn.currentImage.size.width)];
    [alldBtn setImageEdgeInsets:UIEdgeInsetsMake(0, allBtnWidth-7, 0, -(allBtnWidth - 7))];
    [alldBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:alldBtn];
    
    CGFloat hotYY = alldBtn.bottom + 20;
    CGFloat secondSpace = 6;
    [_secondArray removeAllObjects];
    [_secondArray addObjectsFromArray:selectedInfo.child];
    if (SWNOTEmptyArr(_secondArray)) {
        for (int j = 0; j < _secondArray.count; j++) {
            UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, hotYY, MainScreenWidth * 3 / 4.0, 0)];
            hotView.backgroundColor = [UIColor whiteColor];
            hotView.tag = 10 + j;
            [_mainScrollView addSubview:hotView];
            
            NSString *secondTitle = [NSString stringWithFormat:@"%@",((CateGoryModelSecond *)_secondArray[j]).title];//@"热门搜索";
            CGFloat secondBtnWidth = ([secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 7) > (hotView.width - 30) ? (hotView.width - 30) : ([secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 7);
            UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, secondBtnWidth, 32)];
            secondBtn.tag = 100 + j;
            [secondBtn setImage:Image(@"erji_more") forState:0];
            [secondBtn setImage:[Image(@"erji_more") converToMainColor] forState:UIControlStateSelected];
            secondBtn.titleLabel.numberOfLines = 0;
            secondBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [secondBtn setTitle:secondTitle forState:0];
            [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
            [secondBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
            secondBtn.titleLabel.font = SYSTEMFONT(15);
            [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -secondBtn.currentImage.size.width, 0, secondBtn.currentImage.size.width)];
            [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-7, 0, -(secondBtnWidth - 7))];
            [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.selected = ((CateGoryModelSecond *)_secondArray[j]).selected;
            [hotView addSubview:secondBtn];
            [_thirdArray removeAllObjects];
            if (SWNOTEmptyArr(((CateGoryModelSecond *)_secondArray[j]).child)) {
                [_thirdArray addObjectsFromArray:[NSArray arrayWithArray:((CateGoryModelSecond *)_secondArray[j]).child]];
            }
            if (_thirdArray.count) {
                CGFloat topSpacee = 20.0;
                CGFloat rightSpace = 15.0;
                CGFloat btnInSpace = 10.0;
                CGFloat XX = 15.0;
                CGFloat YY = 20.0 + secondBtn.bottom;
                CGFloat btnHeight = 32.0;
                for (int i = 0; i<_thirdArray.count; i++) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
                    btn.tag = 400 + i;
                    [btn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:[NSString stringWithFormat:@"%@",((CateGoryModelThird *)_thirdArray[i]).title] forState:0];
                    btn.titleLabel.numberOfLines = 0;
                    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    btn.titleLabel.font = SYSTEMFONT(14);
                    [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
                    [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
                    btn.selected = ((CateGoryModelThird *)_thirdArray[i]).selected;
//                    if (btn.selected) {
//                        btn.backgroundColor = EdlineV5_Color.buttonWeakeColor;
//                    } else {
//                        btn.backgroundColor = EdlineV5_Color.backColor;
//                    }
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = btnHeight / 2.0;
                    CGFloat btnWidth = ([btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2) > (hotView.width - 30) ? (hotView.width - 30) : ([btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2);//[btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
                    if ((btnWidth + XX) > (MainScreenWidth * 3/4.0 - 15)) {
                        XX = 15.0;
                        YY = YY + topSpacee + btnHeight;
                    }
                    btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
                    XX = btn.right + rightSpace;
                    if (i == _thirdArray.count - 1) {
                        [hotView setHeight:btn.bottom];
                    }
                    [hotView addSubview:btn];
                }
            } else {
                [hotView setHeight:secondBtn.bottom];
            }
            hotYY = hotView.bottom + 20;
            if (j == _secondArray.count - 1) {
                _mainScrollView.contentSize = CGSizeMake(0, hotYY);
            }
        }
    } else {
        _mainScrollView.contentSize = CGSizeMake(0, hotYY);
    }
}

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)getTeacherClassifyList {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_typeString)) {
        [param setObject:_typeString forKey:@"type"];
    }
    if (SWNOTEmptyStr(_mhm_id)) {
        [param setObject:_mhm_id forKey:@"mhm_id"];
    }
    
    if (_isInstitutionApply) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"regardless_mhm_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path commonCategoryNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            NSMutableArray *pass = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            for (int i = 0; i<pass.count; i ++) {
                NSMutableDictionary *passdict = [NSMutableDictionary dictionaryWithDictionary:pass[i]];
                NSDictionary *allDict = @{@"title":@"全部",@"id":[NSString stringWithFormat:@"%@",passdict[@"id"]]};
                [passdict setObject:allDict forKey:@"all"];
                [pass replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:passdict]];
            }
            if (!_isApply) {
                NSMutableDictionary *passdict = [NSMutableDictionary new];
                [passdict setObject:@"全部" forKey:@"title"];
                [passdict setObject:@"0" forKey:@"id"];
                [passdict setObject:@{@"title":@"全部",@"id":@"0"} forKey:@"all"];
                [pass insertObject:passdict atIndex:0];
            }
            [_firstArray addObjectsFromArray:[NSArray arrayWithArray:[TeacherCategoryModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithArray:pass]]]];
            [_tableView reloadData];
            if (SWNOTEmptyArr(_firstArray)) {
                [self makeScrollViewSubView:_firstArray[currentSelectRow]];
            }
            if (_isDownExpend) {
                self.view.hidden = NO;
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)allBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    TeacherCategoryModel *model = (TeacherCategoryModel *)_firstArray[sender.tag - 200];
    
    // 如果是意向课程选择 就是单选 这里直接请求更换意向课程接口
    if ([_typeString isEqualToString:@"0"]) {
        if (_isDownExpend) {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryModel:)]) {
                [_delegate chooseCategoryModel:model];
            }
        } else {
            [self changeFavoriteCourse:model.cateGoryId];
            return;
        }
    } else if ([_typeString isEqualToString:@"5"] || [_typeString isEqualToString:@"1"] || [_typeString isEqualToString:@"2"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryId:)]) {
            [_delegate chooseCategoryId:model.cateGoryId];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    model.selected = sender.selected;
    
    // 选择了全部 这个第一层分类下面所有的都将被取消选中状态
    NSMutableArray *passFirst = [NSMutableArray arrayWithArray:model.child];
    for (int i = 0; i<passFirst.count; i ++) {
        CateGoryModelSecond *modelSecond = (CateGoryModelSecond *)passFirst[i];
        modelSecond.selected = NO;
        NSMutableArray *passThird = [NSMutableArray arrayWithArray:modelSecond.child];
        for (int j = 0; j<passThird.count; j++) {
            CateGoryModelThird *modelThird = (CateGoryModelThird *)passThird[j];
            modelThird.selected = NO;
            [passThird replaceObjectAtIndex:j withObject:modelThird];
        }
        modelSecond.child = [NSArray arrayWithArray:passThird];
        [passFirst replaceObjectAtIndex:i withObject:modelSecond];
    }
    model.child = [NSArray arrayWithArray:passFirst];
    [_firstArray replaceObjectAtIndex:sender.tag - 200 withObject:model];
    [self makeScrollViewSubView:model];
}

- (void)secondBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    TeacherCategoryModel *model = (TeacherCategoryModel *)_firstArray[currentSelectRow];
    
    NSMutableArray *passSecond = [NSMutableArray arrayWithArray:model.child];
    CateGoryModelSecond *secondModel = (CateGoryModelSecond *)passSecond[sender.tag - 100];
    
    // 如果是意向课程选择 就是单选 这里直接请求更换意向课程接口
    if ([_typeString isEqualToString:@"0"]) {
        if (_isDownExpend) {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryModel:)]) {
                [_delegate chooseCategoryModel:secondModel];
            }
        } else {
            [self changeFavoriteCourse:secondModel.cateGoryId];
            return;
        }
    } else if ([_typeString isEqualToString:@"5"] || [_typeString isEqualToString:@"1"] || [_typeString isEqualToString:@"2"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryId:)]) {
            [_delegate chooseCategoryId:secondModel.cateGoryId];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    for (int j = 0; j<passThird.count; j++) {
        CateGoryModelThird *modelThird = (CateGoryModelThird *)passThird[j];
        modelThird.selected = NO;
        [passThird replaceObjectAtIndex:j withObject:modelThird];
    }
    secondModel.child = [NSArray arrayWithArray:passThird];
    secondModel.selected = sender.selected;
    [passSecond replaceObjectAtIndex:sender.tag - 100 withObject:secondModel];
    
    // 选择了或者取消了某一个二级的分类 那么对应的一级的选中状态要取消 并且当前二级的下面三级分类选中状态也要取消
    
    
    model.selected = NO;
    model.child = [NSArray arrayWithArray:passSecond];
    [_firstArray replaceObjectAtIndex:currentSelectRow withObject:model];
    [self makeScrollViewSubView:model];
}

- (void)thirdBtnClick:(UIButton *)sender {
    UIView *view = (UIView *)sender.superview;
    sender.selected = !sender.selected;
//    if (sender.selected) {
//        sender.backgroundColor = EdlineV5_Color.buttonWeakeColor;
//    } else {
//        sender.backgroundColor = EdlineV5_Color.backColor;
//    }
    
    // 获取第一层model
    TeacherCategoryModel *model = (TeacherCategoryModel *)_firstArray[currentSelectRow];
    model.selected = NO;
    // 获取第二层model
    NSMutableArray *passSecond = [NSMutableArray arrayWithArray:model.child];
    CateGoryModelSecond *secondModel = (CateGoryModelSecond *)passSecond[view.tag - 10];
    secondModel.selected = NO;
    // 获取第三层model 并修改model选中状态
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    CateGoryModelThird *thirdModel = (CateGoryModelThird *)passThird[sender.tag - 400];
    thirdModel.selected = sender.selected;
    
    // 如果是意向课程选择 就是单选 这里直接请求更换意向课程接口
    if ([_typeString isEqualToString:@"0"]) {
        if (_isDownExpend) {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryModel:)]) {
                [_delegate chooseCategoryModel:thirdModel];
            }
        } else {
            [self changeFavoriteCourse:thirdModel.cateGoryId];
            return;
        }
    } else if ([_typeString isEqualToString:@"5"] || [_typeString isEqualToString:@"1"] || [_typeString isEqualToString:@"2"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryId:)]) {
            [_delegate chooseCategoryId:thirdModel.cateGoryId];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    // 置换第三层model
    [passThird replaceObjectAtIndex:sender.tag - 400 withObject:thirdModel];
    
    // 修改并置换第二层m
    secondModel.child = [NSArray arrayWithArray:passThird];
    [passSecond replaceObjectAtIndex:view.tag - 10 withObject:secondModel];
    
    // 修改并置换第一层
    model.child = [NSArray arrayWithArray:passSecond];
    [_firstArray replaceObjectAtIndex:currentSelectRow withObject:model];
    [self makeScrollViewSubView:model];
}

- (void)rightButtonClick:(id)sender {
    NSMutableArray *teacherCateGory = [NSMutableArray new];
    for (int i = 0; i<_firstArray.count; i++) {
        TeacherCategoryModel *model = (TeacherCategoryModel *)_firstArray[i];
        if (model.selected) {
            NSMutableArray *pass = [NSMutableArray new];
            [pass addObject:model];
            [teacherCateGory addObject:pass];
        } else {
            for (int j = 0; j<model.child.count; j++) {
                CateGoryModelSecond *secondModel = (CateGoryModelSecond *)model.child[j];
                if (secondModel.selected) {
                    NSMutableArray *pass = [NSMutableArray new];
                    [pass addObject:model];
                    [pass addObject:secondModel];
                    [teacherCateGory addObject:pass];
                } else {
                    for (int k = 0; k<secondModel.child.count; k++) {
                        CateGoryModelThird *thirdModel = (CateGoryModelThird *)secondModel.child[k];
                        if (thirdModel.selected) {
                            NSMutableArray *pass = [NSMutableArray new];
                            [pass addObject:model];
                            [pass addObject:secondModel];
                            [pass addObject:thirdModel];
                            [teacherCateGory addObject:pass];
                        }
                    }
                }
            }
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryArray:)]) {
        [_delegate chooseCategoryArray:teacherCateGory];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changeFavoriteCourse:(NSString *)favoriteCourseId {
    if (SWNOTEmptyStr(favoriteCourseId)) {
        [Net_API requestPUTWithURLStr:[Net_Path favoriteCourseChangeNet] paramDic:@{@"category":favoriteCourseId} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFavoriteCourse" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"选择意向课程失败"];
        }];
    }
}

@end
