//
//  ExamPointSelectVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ExamPointSelectVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamPointModel.h"
#import "ExamDetailViewController.h"
#import "ExamNewSecendTypeVC.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"

@interface ExamPointSelectVC ()<UIScrollViewDelegate, ExamNewSecendTypeVCDelegate> {
    NSInteger maxSelectCount;
    /// 当前选择的试题数量按钮下标
    NSInteger currentTestCountSelected;
}

@property (strong, nonatomic) UIButton *resetButton;//清空筛选
@property (strong, nonatomic) UIButton *sureButton;//开始学习
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIScrollView *mainScrollView;

/// 选择题量
@property (strong, nonatomic) UIView *selectCountView;
@property (strong, nonatomic) NSArray *selectCountArray;

@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) NSMutableArray *secondArray;
@property (strong, nonatomic) NSMutableArray *thirdArray;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (strong, nonatomic) UIButton *topCateButton;

@property (strong, nonatomic) UIView *mainTypeBackView;
@property (strong, nonatomic) UIScrollView *mainTypeScrollView;

@end

@implementation ExamPointSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    [_rightButton setImage:[Image(@"lesson_screen_nor") converToMainColor] forState:UIControlStateSelected];
    
    maxSelectCount = 0;
    
    _mainTypeArray = [[NSMutableArray alloc] init];
    _mainSelectDict = [[NSMutableDictionary alloc] init];
    
    _firstArray = [NSMutableArray new];
    _secondArray = [NSMutableArray new];
    _thirdArray = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    
    currentTestCountSelected = 1;
    _selectCountArray = @[@"10",@"20",@"30",@"40",@"50"];
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _titleLabel.text = SWNOTEmptyStr(_examTypeString) ? _examTypeString : @"知识点练习";
    _titleLabel.hidden = YES;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - (MACRO_UI_UPHEIGHT + 44 + MACRO_UI_SAFEAREA))];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRightButton) name:@"hiddenSecondNewType" object:nil];
    
    [self makeBottomView];
    
    [self getExamFirstTypeInfo];
    
    [self getExamPointListData:@""];
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

- (void)makeBottomView {
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 44)];
    [_resetButton setTitle:@"清空筛选" forState:0];
    [_resetButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _resetButton.titleLabel.font = SYSTEMFONT(16);
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_resetButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_resetButton.right, 0, MainScreenWidth / 2.0, 44)];
    [_sureButton setTitle:@"开始答题" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_bottomView addSubview:line];
}

- (void)getClassTypeData {
    
    NSMutableArray *passArray = [NSMutableArray new];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary *pass = [NSMutableDictionary new];
        [pass setObject:@"1" forKey:@"id"];
        [pass setObject:@"这是知识点二级" forKey:@"title"];
        [pass setObject:@"1" forKey:@"isExpend"];
        NSMutableArray *secendArrayPass = [NSMutableArray new];
        for (int j = 0; j<5; j++) {
            NSDictionary *ps = @{@"id":@"1",@"child":@[],@"title":@"二级分类"};
            [secendArrayPass addObject:ps];
        }
        [pass setObject:[NSArray arrayWithArray:secendArrayPass] forKey:@"child"];
        [passArray addObject:pass];
    }
    [_firstArray addObjectsFromArray:[NSArray arrayWithArray:[ExamPointModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithArray:passArray]]]];
    if (SWNOTEmptyArr(_firstArray)) {
        [self makeScrollViewSubView:_firstArray];
    }
}

// MARK: - 布局底部试题数量选择视图
- (void)makeSelectCountViewUI:(CGFloat)top {
    if (!_selectCountView) {
        _selectCountView = [[UIView alloc] initWithFrame:CGRectMake(0, top, MainScreenWidth, 135)];
        _selectCountView.backgroundColor = [UIColor whiteColor];
    }
    if (![_selectCountView superview]) {
        [_mainScrollView addSubview:_selectCountView];
        _mainScrollView.contentSize = CGSizeMake(0, _selectCountView.bottom);
    }
    [_selectCountView removeAllSubviews];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 5)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_selectCountView addSubview:line];
    
    UILabel *countTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom + 15, MainScreenWidth - 30, 31)];
    countTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    countTitle.textColor = EdlineV5_Color.textFirstColor;
    countTitle.text = @"出题数量";
    [_selectCountView addSubview:countTitle];
    
    UIView *countLine = [[UIView alloc] initWithFrame:CGRectMake(15, countTitle.bottom + 14, MainScreenWidth - 30, 2)];
    countLine.backgroundColor = HEXCOLOR(0xEBEEF5);//EdlineV5_Color.backColor;
    [_selectCountView addSubview:countLine];
    
    
    for (int i = 0; i<_selectCountArray.count; i++) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        view1.layer.masksToBounds = YES;
        view1.layer.cornerRadius = view1.height / 2.0;
        [_selectCountView addSubview:view1];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.height / 2.0;
        btn.backgroundColor = [UIColor clearColor];
        [_selectCountView addSubview:btn];
        btn.tag = 50 + i;
        [btn addTarget:self action:@selector(countSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, countLine.bottom + 14, 30, 16.5)];
        countLabel.font = SYSTEMFONT(12);
        countLabel.textColor = EdlineV5_Color.textSecendColor;
        countLabel.text = [NSString stringWithFormat:@"%@",_selectCountArray[i]];
        [_selectCountView addSubview:countLabel];
        
        if (i == currentTestCountSelected) {
            view1.frame = CGRectMake(0, 0, 18, 18);
            view1.backgroundColor = [UIColor whiteColor];
            view1.layer.cornerRadius = view1.height / 2.0;
            view1.layer.borderWidth = 2;
            view1.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
        } else {
            view1.frame = CGRectMake(0, 0, 8, 8);
            view1.backgroundColor = HEXCOLOR(0xEBEEF5);//EdlineV5_Color.backColor;
            view1.layer.cornerRadius = view1.height / 2.0;
        }
        
        if (i == 0) {
            [view1 setLeft:countLine.left];
            countLabel.textAlignment = NSTextAlignmentLeft;
            [countLabel setLeft:countLine.left];
        } else if (i == (_selectCountArray.count - 1)) {
            [view1 setRight:countLine.right];
            countLabel.textAlignment = NSTextAlignmentRight;
            [countLabel setRight:countLine.right];
        } else {
            view1.centerX = (countLine.width * i) / ((_selectCountArray.count - 1) * 1.0);
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.centerX = (countLine.width * i) / ((_selectCountArray.count - 1) * 1.0);
        }
        view1.centerY = countLine.centerY;
        
        btn.centerX = view1.centerX;
        btn.centerY = view1.centerY;
    }
}

// MARK: -试题数量选择按钮点击事件处理
- (void)countSelectButtonClick:(UIButton *)sender {
    currentTestCountSelected = sender.tag - 50;
    [self makeSelectCountViewUI:_selectCountView.top];
}

// MARK: - 布局右边分类视图
- (void)makeScrollViewSubView:(NSMutableArray *)selectedInfo {
    if (_mainScrollView) {
        [_mainScrollView removeAllSubviews];
    }
    
    CGFloat hotYY = 20;
    CGFloat secondSpace = 6;
    [_secondArray removeAllObjects];
    [_secondArray addObjectsFromArray:selectedInfo];
    if (SWNOTEmptyArr(_secondArray)) {
        for (int j = 0; j < _secondArray.count; j++) {
            UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, hotYY, MainScreenWidth, 0)];
            hotView.backgroundColor = [UIColor whiteColor];
            hotView.tag = 10 + j;
            [_mainScrollView addSubview:hotView];
            
            NSString *secondTitle = [NSString stringWithFormat:@"%@",((ExamPointModel *)_secondArray[j]).title];//@"热门搜索";
            if (secondTitle.length>15) {
                secondTitle = [secondTitle substringWithRange:NSMakeRange(0, 15)];
                secondTitle = [NSString stringWithFormat:@"%@...",secondTitle];
            }
            CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 14;
            UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, secondBtnWidth, 32)];
            secondBtn.tag = 100 + j;
            [secondBtn setImage:Image(@"contents_down") forState:0];
            [secondBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
            [secondBtn setTitle:secondTitle forState:0];
            [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
//            [secondBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
            secondBtn.titleLabel.font = SYSTEMFONT(15);
            [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -secondBtn.currentImage.size.width, 0, secondBtn.currentImage.size.width)];
            [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-14, 0, -(secondBtnWidth - 14))];
            [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.selected = ((ExamPointModel *)_secondArray[j]).isExpend;
            [hotView addSubview:secondBtn];
            
            UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 60, 0, 60, 32)];
            allSelectLabel.font = SYSTEMFONT(12);
            allSelectLabel.textColor = EdlineV5_Color.textThirdColor;
            allSelectLabel.centerY = secondBtn.centerY;
            allSelectLabel.textAlignment = NSTextAlignmentRight;
            allSelectLabel.tag = 101 + j;
            allSelectLabel.userInteractionEnabled = YES;
            [hotView addSubview:allSelectLabel];
            UIGestureRecognizer *allSelectT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSelectTap:)];
            [allSelectLabel addGestureRecognizer:allSelectT];
            allSelectLabel.text = ((ExamPointModel *)_secondArray[j]).selected ? @"取消全选" : @"全选";
            
            [_thirdArray removeAllObjects];
            if (!((ExamPointModel *)_secondArray[j]).isExpend) {
                [hotView setHeight:secondBtn.bottom];
                hotYY = hotView.bottom + 20;
                if (j == _secondArray.count - 1) {
//                    _mainScrollView.contentSize = CGSizeMake(0, hotYY);
                }
                continue;
            }
            if (SWNOTEmptyArr(((ExamPointModel *)_secondArray[j]).child)) {
                [_thirdArray addObjectsFromArray:[NSArray arrayWithArray:((ExamPointModel *)_secondArray[j]).child]];
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
                    NSString *btnTitle = [NSString stringWithFormat:@"%@",((ExamPointModel *)_thirdArray[i]).title];
                    if (btnTitle.length>15) {
                        btnTitle = [btnTitle substringWithRange:NSMakeRange(0, 15)];
                        btnTitle = [NSString stringWithFormat:@"%@...",btnTitle];
                    }
                    [btn setTitle:btnTitle forState:0];
                    btn.titleLabel.font = SYSTEMFONT(14);
                    [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
                    [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
                    btn.selected = ((ExamPointModel *)_thirdArray[i]).selected;
                    if (btn.selected) {
                        btn.backgroundColor = EdlineV5_Color.buttonWeakeColor;
                    } else {
                        btn.backgroundColor = EdlineV5_Color.backColor;
                    }
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = btnHeight / 2.0;
                    CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
                    if ((btnWidth + XX) > (MainScreenWidth - 15)) {
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
//                _mainScrollView.contentSize = CGSizeMake(0, hotYY);
            }
        }
    } else {
//        _mainScrollView.contentSize = CGSizeMake(0, hotYY);
    }
    
    [self makeSelectCountViewUI:hotYY];
}

- (void)secondBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    ExamPointModel *model = (ExamPointModel *)_firstArray[sender.tag - 100];
    model.isExpend = sender.selected;
    [_firstArray replaceObjectAtIndex:sender.tag - 100 withObject:model];
    [self makeScrollViewSubView:_firstArray];
}

- (void)thirdBtnClick:(UIButton *)sender {
    
//    if (!sender.selected) {
//        if ([self checkSelectCount] >= maxSelectCount) {
//            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"最多选择%@个知识点",@(maxSelectCount)]];
//            return;
//        }
//    }
    
    UIView *view = (UIView *)sender.superview;
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = EdlineV5_Color.buttonWeakeColor;
    } else {
        sender.backgroundColor = EdlineV5_Color.backColor;
    }

    // 获取第二层model
    NSMutableArray *passSecond = [NSMutableArray arrayWithArray:_firstArray];
    ExamPointModel *secondModel = (ExamPointModel *)passSecond[view.tag - 10];
    // 获取第三层model 并修改model选中状态
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    ExamPointModel *thirdModel = (ExamPointModel *)passThird[sender.tag - 400];
    thirdModel.selected = sender.selected;
    
    // 置换第三层model
    [passThird replaceObjectAtIndex:sender.tag - 400 withObject:thirdModel];
    
    // 修改并置换第二层m
    secondModel.child = [NSArray arrayWithArray:passThird];
    
    /// 直接检索判断是不是全部选中次级分类
    BOOL selectAll = YES;
    for (int i = 0; i<passThird.count; i++) {
        ExamPointModel *thirdModel = passThird[i];
        if (!thirdModel.selected) {
            selectAll = NO;
            break;
        }
    }
    secondModel.selected = selectAll;
    
    [passSecond replaceObjectAtIndex:view.tag - 10 withObject:secondModel];
    
    _firstArray = [NSMutableArray arrayWithArray:passSecond];
    [self makeScrollViewSubView:_firstArray];
    
//    [self changeRightButtonState:[self checkSelectCount] maxCount:maxSelectCount];
}

- (void)allSelectTap:(UIGestureRecognizer *)tap {
    if (tap.view.tag) {
        
    }
    
    UIView *view = (UIView *)tap.view.superview;

    // 获取第二层model
    NSMutableArray *passSecond = [NSMutableArray arrayWithArray:_firstArray];
    ExamPointModel *secondModel = (ExamPointModel *)passSecond[view.tag - 10];
    /// 全选与否 置反
    secondModel.selected = !secondModel.selected;
    
    // 获取第三层model 并修改model选中状态
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    /// 第三层状态保持和第二层一致
    for (int i = 0; i<passThird.count; i++) {
        ExamPointModel *thirdModel = passThird[i];
        thirdModel.selected = secondModel.selected;
        [passThird replaceObjectAtIndex:i withObject:thirdModel];
    }
    // 修改并置换第二层m
    secondModel.child = [NSArray arrayWithArray:passThird];
    [passSecond replaceObjectAtIndex:view.tag - 10 withObject:secondModel];
    
    _firstArray = [NSMutableArray arrayWithArray:passSecond];
    [self makeScrollViewSubView:_firstArray];
    
}

- (NSInteger)checkSelectCount {
    NSMutableArray *teacherCateGory = [NSMutableArray new];
    for (int i = 0; i<_firstArray.count; i++) {
        ExamPointModel *model = (ExamPointModel *)_firstArray[i];
        for (int j = 0; j<model.child.count; j++) {
            ExamPointModel *secondModel = (ExamPointModel *)model.child[j];
            if (secondModel.selected) {
                NSMutableArray *pass = [NSMutableArray new];
                [pass addObject:model];
                [pass addObject:secondModel];
                [teacherCateGory addObject:pass];
            }
        }
    }
    NSLog(@"已选择知识点分类个数为 = %@ 个",@(teacherCateGory.count));
    return teacherCateGory.count;
}

- (void)sureButtonClick {
    NSMutableArray *teacherCateGory = [NSMutableArray new];
    NSString *examIds = @"";
    for (int i = 0; i<_firstArray.count; i++) {
        ExamPointModel *model = (ExamPointModel *)_firstArray[i];
        for (int j = 0; j<model.child.count; j++) {
            ExamPointModel *secondModel = (ExamPointModel *)model.child[j];
            if (secondModel.selected) {
                NSMutableArray *pass = [NSMutableArray new];
                [pass addObject:secondModel];
                [teacherCateGory addObject:pass];
                if (SWNOTEmptyStr(examIds)) {
                    examIds = [NSString stringWithFormat:@"%@,%@",examIds,secondModel.cateGoryId];
                } else {
                    examIds = [NSString stringWithFormat:@"%@",secondModel.cateGoryId];
                }
            }
        }
    }
    NSLog(@"已选择知识点分类个数为 = %@ 个",@(teacherCateGory.count));
    if (teacherCateGory.count<=0) {
        [self showHudInView:self.view showHint:@"请选择知识点"];
        return;
    }
    
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    
    ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
    vc.examIds = examIds;
    vc.examType = _examTypeId;
    vc.examTitle = _examTypeString;
    vc.examModuleId = _examModuleId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resetButtonClick {
    for (int i = 0; i<_firstArray.count; i++) {
        ExamPointModel *model = (ExamPointModel *)_firstArray[i];
        NSMutableArray *pass = [NSMutableArray arrayWithArray:model.child];
        for (int j = 0; j<pass.count; j++) {
            ExamPointModel *secondModel = (ExamPointModel *)pass[j];
            secondModel.selected = NO;
            [pass replaceObjectAtIndex:j withObject:secondModel];
        }
        model.child = [NSArray arrayWithArray:pass];
        model.selected = NO;
        [_firstArray replaceObjectAtIndex:i withObject:model];
    }
    [self makeScrollViewSubView:_firstArray];
//    [self changeRightButtonState:[self checkSelectCount] maxCount:maxSelectCount];
}

- (void)getExamPointListData:(NSString *)examNewType {
    if (SWNOTEmptyStr(_examModuleId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointListNet] WithAuthorization:nil paramDic:@{@"module_id":_examModuleId,@"category":examNewType} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    // 改变右上角按钮状态
                    maxSelectCount = [[NSString stringWithFormat:@"%@",responseObject[@"data"][@"point_limit"]] integerValue];
//                    [self changeRightButtonState:0 maxCount:maxSelectCount];
                    
                    [_firstArray removeAllObjects];
                    [_firstArray addObjectsFromArray:[NSArray arrayWithArray:[ExamPointModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"point_tree"]]]];
                    for (int i = 0; i<_firstArray.count; i++) {
                        ((ExamPointModel *)_firstArray[i]).isExpend = YES;
                    }
                    if (SWNOTEmptyArr(_firstArray)) {
                        [self makeScrollViewSubView:_firstArray];
                    }
                }
            }
        } enError:^(NSError * _Nonnull error) {
        }];
    }
}

- (void)changeRightButtonState:(NSInteger)selectCount maxCount:(NSInteger)maxCount {
//    _rightButton.hidden = NO;
//    [_rightButton setImage:nil forState:0];
//    NSString *maxcount = [NSString stringWithFormat:@"%@",@(maxSelectCount)];
//    NSString *rightTitle = [NSString stringWithFormat:@"%@/%@",@(selectCount),maxcount];
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:rightTitle];
//    [att addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.themeColor} range:NSMakeRange(0, rightTitle.length - maxcount.length)];
//    [att addAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xB7BAC1)} range:NSMakeRange(rightTitle.length - maxcount.length, maxcount.length)];
//    [_rightButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:att] forState:0];
    
    [_sureButton setTitle:[NSString stringWithFormat:@"(%@/%@)开始答题",@(selectCount),@(maxSelectCount)] forState:0];
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
    [self getExamPointListData:[NSString stringWithFormat:@"%@",_mainSelectDict[@"id"]]];
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
    [self getExamPointListData:[NSString stringWithFormat:@"%@",info[@"examType"]]];
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
