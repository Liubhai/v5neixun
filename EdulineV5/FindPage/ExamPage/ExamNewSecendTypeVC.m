//
//  ExamNewSecendTypeVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ExamNewSecendTypeVC.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"
#import "Net_Path.h"

@interface ExamNewSecendTypeVC ()

@property (strong, nonatomic) NSMutableArray *firstTypeArray;
@property (strong, nonatomic) NSMutableArray *secondTypeArray;
@property (strong, nonatomic) NSMutableArray *thirdTypeArray;

@property (strong, nonatomic) UIView *typeBackView;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIView *secondTypeView;
@property (strong, nonatomic) UIView *thirdTypeView;

@property (strong, nonatomic) UIButton *resetButton;//清空筛选
@property (strong, nonatomic) UIButton *sureButton;//开始学习
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation ExamNewSecendTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    self.view.hidden = YES;
    _titleImage.hidden = YES;
    
    _firstTypeArray = [[NSMutableArray alloc] init];
    _secondTypeArray = [[NSMutableArray alloc] init];
    _thirdTypeArray = [[NSMutableArray alloc] init];
    
    _typeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    _typeBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_typeBackView];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    [_typeBackView addSubview:_mainScrollView];
    
    _secondTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    [_mainScrollView addSubview:_secondTypeView];
    
    _thirdTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, _secondTypeView.bottom, MainScreenWidth, 0)];
    [_mainScrollView addSubview:_thirdTypeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];

    [self getSecondTypeInfo];
    // Do any additional setup after loading the view.
}

- (void)makeBottomView {
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, _typeBackView.height - 44, MainScreenWidth,  44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_typeBackView addSubview:_bottomView];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 44)];
    [_resetButton setTitle:@"取消" forState:0];
    [_resetButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _resetButton.titleLabel.font = SYSTEMFONT(16);
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_resetButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_resetButton.right, 0, MainScreenWidth / 2.0, 44)];
    [_sureButton setTitle:@"确定" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_bottomView addSubview:line];
}

- (void)makeSecondTypeUI:(TeacherCategoryModel *)model {
    [_secondTypeView removeAllSubviews];
    UILabel *firstTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, MainScreenWidth - 30, 20 + 28)];
    firstTypeLabel.font = SYSTEMFONT(14);
    firstTypeLabel.textColor = EdlineV5_Color.textThirdColor;
    firstTypeLabel.text = model.title;
    [_secondTypeView addSubview:firstTypeLabel];
    [_secondTypeArray removeAllObjects];
    [_secondTypeArray addObjectsFromArray:model.child];
    if (_secondTypeArray.count) {
        CGFloat topSpacee = 20.0;
        CGFloat rightSpace = 15.0;
        CGFloat btnInSpace = 10.0;
        CGFloat XX = 15.0;
        CGFloat YY = firstTypeLabel.bottom;
        CGFloat btnHeight = 32.0;
        for (int i = 0; i<_secondTypeArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[NSString stringWithFormat:@"%@",((CateGoryModelSecond *)_secondTypeArray[i]).title] forState:0];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
            btn.backgroundColor = EdlineV5_Color.backColor;
            btn.selected = ((CateGoryModelSecond *)_secondTypeArray[i]).selected;
//            if (btn.selected) {
//                btn.backgroundColor = EdlineV5_Color.buttonWeakeColor;
//            } else {
//                btn.backgroundColor = EdlineV5_Color.backColor;
//            }
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = btnHeight / 2.0;
            CGFloat btnWidth = ([btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2) > (MainScreenWidth - 30) ? (MainScreenWidth - 30) : ([btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2);
            btnWidth = btnWidth > 60 ? btnWidth : 60;
            if ((btnWidth + XX) > (MainScreenWidth - 15)) {
                XX = 15.0;
                YY = YY + topSpacee + btnHeight;
            }
            btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
            XX = btn.right + rightSpace;
            if (i == _secondTypeArray.count - 1) {
                [_secondTypeView setHeight:btn.bottom];
            }
            [_secondTypeView addSubview:btn];
        }
    } else {
        [_secondTypeView setHeight:firstTypeLabel.bottom];
    }
    
    _thirdTypeView.frame = CGRectMake(0, _secondTypeView.bottom, MainScreenWidth, 0);
    
    // 处理底部按视图的坐标
    [_typeBackView setHeight:(_thirdTypeView.bottom + 10 + _bottomView.height) > (MainScreenHeight - MACRO_UI_UPHEIGHT) ? (MainScreenHeight - MACRO_UI_UPHEIGHT) : (_thirdTypeView.bottom + 10 + _bottomView.height)];
    [_mainScrollView setHeight:_typeBackView.height - _bottomView.height];
    [_mainScrollView setContentSize:CGSizeMake(0, _thirdTypeView.bottom + 10)];
    _bottomView.frame = CGRectMake(0, _typeBackView.height - 44, MainScreenWidth, 44);
}

- (void)secondBtnClick:(UIButton *)sender {
    sender.selected = YES;
    TeacherCategoryModel *model = _firstTypeArray[0];
    CateGoryModelSecond *modelSecondCurrent = model.child[sender.tag - 400];
    NSMutableArray *passFirst = [NSMutableArray arrayWithArray:model.child];
    for (int i = 0; i<passFirst.count; i++) {
        CateGoryModelSecond *modelSecond = passFirst[i];
        if ([modelSecond.cateGoryId isEqualToString:modelSecondCurrent.cateGoryId]) {
            modelSecond.selected = YES;
        } else {
            modelSecond.selected = NO;
        }
        NSMutableArray *passThird = [NSMutableArray arrayWithArray:modelSecond.child];
        for (int j = 0; j<passThird.count; j++) {
            CateGoryModelThird *modelThird = (CateGoryModelThird *)passThird[j];
            if (j == 0) {
                modelThird.selected = YES;
            } else {
                modelThird.selected = NO;
            }
            [passThird replaceObjectAtIndex:j withObject:modelThird];
        }
        modelSecond.child = [NSArray arrayWithArray:passThird];
        [passFirst replaceObjectAtIndex:i withObject:modelSecond];
    }
    model.child = [NSArray arrayWithArray:passFirst];
    [_firstTypeArray replaceObjectAtIndex:0 withObject:model];
    
    [_secondTypeArray removeAllObjects];
    [_secondTypeArray addObjectsFromArray:model.child];
    
    [self makeSecondTypeUI:model];
    
    [self makeThirdTypeUI:_secondTypeArray[sender.tag - 400]];
}

- (void)makeThirdTypeUI:(CateGoryModelSecond *)model {
    [_thirdTypeView removeAllSubviews];
    _thirdTypeView.frame = CGRectMake(0, _secondTypeView.bottom, MainScreenWidth, 0);
    
    [_thirdTypeArray removeAllObjects];
    [_thirdTypeArray addObjectsFromArray:model.child];
    if (_thirdTypeArray.count) {
        
        UILabel *firstTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, MainScreenWidth - 30, 20 + 28)];
        firstTypeLabel.font = SYSTEMFONT(14);
        firstTypeLabel.textColor = EdlineV5_Color.textThirdColor;
        firstTypeLabel.text = model.title;
        [_thirdTypeView addSubview:firstTypeLabel];
        
        CGFloat topSpacee = 20.0;
        CGFloat rightSpace = 15.0;
        CGFloat btnInSpace = 10.0;
        CGFloat XX = 15.0;
        CGFloat YY = firstTypeLabel.bottom;
        CGFloat btnHeight = 32.0;
        for (int i = 0; i<_thirdTypeArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[NSString stringWithFormat:@"%@",((CateGoryModelThird *)_thirdTypeArray[i]).title] forState:0];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
            btn.backgroundColor = EdlineV5_Color.backColor;
            btn.selected = ((CateGoryModelThird *)_thirdTypeArray[i]).selected;
//            if (btn.selected) {
//                btn.backgroundColor = EdlineV5_Color.buttonWeakeColor;
//            } else {
//                btn.backgroundColor = EdlineV5_Color.backColor;
//            }
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = btnHeight / 2.0;
            CGFloat btnWidth = ([btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2) > (MainScreenWidth - 30) ? (MainScreenWidth - 30) : ([btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2);
            btnWidth = btnWidth > 60 ? btnWidth : 60;
            if ((btnWidth + XX) > (MainScreenWidth - 15)) {
                XX = 15.0;
                YY = YY + topSpacee + btnHeight;
            }
            btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
            XX = btn.right + rightSpace;
            if (i == _thirdTypeArray.count - 1) {
                [_thirdTypeView setHeight:btn.bottom];
            }
            [_thirdTypeView addSubview:btn];
        }
    }
    
    // 处理底部按视图的坐标
    
    [_typeBackView setHeight:(_thirdTypeView.bottom + 10 + _bottomView.height) > (MainScreenHeight - MACRO_UI_UPHEIGHT) ? (MainScreenHeight - MACRO_UI_UPHEIGHT) : (_thirdTypeView.bottom + 10 + _bottomView.height)];
    [_mainScrollView setHeight:_typeBackView.height - _bottomView.height];
    [_mainScrollView setContentSize:CGSizeMake(0, _thirdTypeView.bottom + 10)];
    _bottomView.frame = CGRectMake(0, _typeBackView.height - 44, MainScreenWidth, 44);
}

- (void)thirdBtnClick:(UIButton *)sender {
    sender.selected = YES;
    TeacherCategoryModel *model = _firstTypeArray[0];
    
    
    CateGoryModelThird *modelThirdCurrent = _thirdTypeArray[sender.tag - 400];
    
    for (int i = 0; i<_thirdTypeArray.count; i++) {
        CateGoryModelThird *modelThird = _thirdTypeArray[i];
        if ([modelThird.cateGoryId isEqualToString:modelThirdCurrent.cateGoryId]) {
            modelThird.selected = YES;
        } else {
            modelThird.selected = NO;
        }
        [_thirdTypeArray replaceObjectAtIndex:i withObject:modelThird];
    }
    CateGoryModelSecond *currentSecondModel;
    for (CateGoryModelSecond *modelSecond in _secondTypeArray) {
        if (modelSecond.selected) {
            modelSecond.child = [NSArray arrayWithArray:_thirdTypeArray];
            currentSecondModel = modelSecond;
            break;
        }
    }
    
    
    model.child = [NSArray arrayWithArray:_secondTypeArray];
    
    [_firstTypeArray replaceObjectAtIndex:0 withObject:model];
    
    [self makeSecondTypeUI:model];
    
    [self makeThirdTypeUI:currentSecondModel];
}

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)getSecondTypeInfo {
    if (SWNOTEmptyStr(_typeId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examSecondTypeNet] WithAuthorization:nil paramDic:@{@"pid":_typeId} finish:^(id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                
                NSMutableArray *pass = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
                /// 更换二级下面三级的第一个为全部
                for (int i = 0; i<pass.count; i ++) {
                    NSMutableDictionary *passdict = [NSMutableDictionary dictionaryWithDictionary:pass[i]];
                    if (SWNOTEmptyArr(passdict[@"child"])) {
                        NSMutableArray *thirdChild = [NSMutableArray arrayWithArray:passdict[@"child"]];
                        NSMutableDictionary *passdict1 = [NSMutableDictionary new];
                        [passdict1 setObject:@"全部" forKey:@"title"];
                        [passdict1 setObject:[NSString stringWithFormat:@"%@",passdict[@"id"]] forKey:@"id"];
                        [passdict1 setObject:[NSString stringWithFormat:@"%@",passdict[@"id"]] forKey:@"pid"];
                        [thirdChild insertObject:passdict1 atIndex:0];
                        NSArray *thirdArray = [NSArray arrayWithArray:thirdChild];
                        [passdict setObject:thirdArray forKey:@"child"];
                    }
                    [pass replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:passdict]];
                }
                
                /// 更换二级第一个为全部
                NSMutableDictionary *passdict = [NSMutableDictionary new];
                [passdict setObject:@"全部" forKey:@"title"];
                [passdict setObject:_typeId forKey:@"id"];
                [passdict setObject:_typeId forKey:@"pid"];
//                [passdict setObject:@"1" forKey:@"selected"];
                [pass insertObject:passdict atIndex:0];
                
                /// 组装成完成的一个拥有3级的模型字典
                NSMutableDictionary *firstDict = [NSMutableDictionary new];
                [firstDict setObject:_typeString forKey:@"title"];
                [firstDict setObject:_typeId forKey:@"id"];
                [firstDict setObject:[NSArray arrayWithArray:pass] forKey:@"child"];

                
                [_firstTypeArray removeAllObjects];
                
                [_firstTypeArray addObjectsFromArray:[NSArray arrayWithArray:[TeacherCategoryModel mj_objectArrayWithKeyValuesArray:@[firstDict]]]];
                
                if (SWNOTEmptyArr(_firstTypeArray)) {
                    BOOL hasSelect = NO;
                    /// 这里处理保留上次选中状态
                    TeacherCategoryModel *model = _firstTypeArray[0];
                    /// 记录当前第三级
                    CateGoryModelSecond *modelsecondCurrent;
                    NSMutableArray *secondArray = [NSMutableArray arrayWithArray:model.child];
                    for (int i = 0; i<secondArray.count; i++) {
                        /// 第二级
                        if (hasSelect) {
                            break;
                        }
                        CateGoryModelSecond *modelsecond = secondArray[i];
                        if ([modelsecond.pid isEqualToString:_currentSelectId]) {
                            if (i == 0) {
                                modelsecond.selected = YES;
                                hasSelect = YES;
                                modelsecondCurrent = modelsecond;
                                [secondArray replaceObjectAtIndex:i withObject:modelsecond];
                                model.child = [NSArray arrayWithArray:secondArray];
                                [_firstTypeArray replaceObjectAtIndex:0 withObject:model];
                                break;
                            }
                        } else {
                            if ([modelsecond.cateGoryId isEqualToString:_currentSelectId]) {
                                modelsecond.selected = YES;
                                hasSelect = YES;
                                NSMutableArray *thirdArray = [NSMutableArray arrayWithArray:modelsecond.child];
                                if (SWNOTEmptyArr(thirdArray)) {
                                    CateGoryModelThird *thirdModel = thirdArray[0];
                                    thirdModel.selected = YES;
                                    // 替换
                                    [thirdArray replaceObjectAtIndex:0 withObject:thirdModel];
                                }
                                modelsecond.child = [NSArray arrayWithArray:thirdArray];
                                modelsecondCurrent = modelsecond;
                                [secondArray replaceObjectAtIndex:i withObject:modelsecond];
                                model.child = [NSArray arrayWithArray:secondArray];
                                [_firstTypeArray replaceObjectAtIndex:0 withObject:model];
                                break;
                            } else {
                                NSMutableArray *thirdArray = [NSMutableArray arrayWithArray:modelsecond.child];
                                for (int j = 0; j<thirdArray.count; j++) {
                                    CateGoryModelThird *thirdModel = thirdArray[j];
                                    if ([thirdModel.cateGoryId isEqualToString:_currentSelectId]) {
                                        thirdModel.selected = YES;
                                        //
                                        modelsecond.selected = YES;
                                        hasSelect = YES;
                                        
                                        [thirdArray replaceObjectAtIndex:j withObject:thirdModel];
                                        modelsecond.child = [NSArray arrayWithArray:thirdArray];
                                        modelsecondCurrent = modelsecond;
                                        [secondArray replaceObjectAtIndex:i withObject:modelsecond];
                                        model.child = [NSArray arrayWithArray:secondArray];
                                        [_firstTypeArray replaceObjectAtIndex:0 withObject:model];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (!hasSelect) {
                        if (SWNOTEmptyArr(secondArray)) {
                            CateGoryModelSecond *modelSecond = secondArray[0];
                            modelSecond.selected = YES;
                            modelsecondCurrent = modelSecond;
                            [secondArray replaceObjectAtIndex:0 withObject:modelSecond];
                            model.child = [NSArray arrayWithArray:secondArray];
                            [_firstTypeArray replaceObjectAtIndex:0 withObject:model];
                        }
                    }
                    
                    [self makeBottomView];
                    [self makeSecondTypeUI:_firstTypeArray[0]];
                    if (modelsecondCurrent) {
                        [self makeThirdTypeUI:modelsecondCurrent];
                    }
                    
                    self.view.hidden = NO;
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)resetButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenSecondNewType" object:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)sureButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(chooseExamType:)]) {
        if (SWNOTEmptyArr(_firstTypeArray)) {
            TeacherCategoryModel *model = _firstTypeArray[0];
            NSString *chooseTypeId = @"";
            NSArray *secondArray = [NSArray arrayWithArray:model.child];
            for (int i = 0; i<secondArray.count; i++) {
                CateGoryModelSecond *modelSecond = secondArray[i];
                if (modelSecond.selected) {
                    chooseTypeId = modelSecond.cateGoryId;
                    NSArray *thirdArray = [NSArray arrayWithArray:modelSecond.child];
                    for (CateGoryModelThird *modelThird in thirdArray) {
                        if (modelThird.selected) {
                            chooseTypeId = modelThird.cateGoryId;
                            break;
                        }
                    }
                }
            }
            if (SWNOTEmptyStr(chooseTypeId)) {
                [_delegate chooseExamType:@{@"examType":chooseTypeId}];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenSecondNewType" object:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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
