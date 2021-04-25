//
//  ExamResultSheetViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/25.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamResultSheetViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface ExamResultSheetViewController () {
    NSTimer *paperTimer;// 试卷作答时候的计时器(倒计时或者正序即时)
}

@property (strong, nonatomic) UIButton *resetButton;//清空筛选
@property (strong, nonatomic) UIButton *sureButton;//开始学习
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation ExamResultSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isPaper) {
        _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:_remainTime]];
        paperTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    }
    
    _titleLabel.hidden = !_isPaper;
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    [_leftButton setImage:Image(@"nav_sheetclose_icon") forState:0];
 
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    [self makeTopUI];
    
    [self makeExamSheetUI];
    
    if (_isPaper) {
        [self makeBottomView];
    }
}

- (void)makeTopUI {
    UILabel *examTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 30, 22)];
    examTitle.font = SYSTEMFONT(13);
    examTitle.textColor = EdlineV5_Color.textThirdColor;
    examTitle.text = @"注:";
    [_mainScrollView addSubview:examTitle];
    
    UIView *finishView = [[UIView alloc] initWithFrame:CGRectMake(examTitle.right, 0, 14, 14)];
    finishView.layer.masksToBounds = YES;
    finishView.layer.borderColor = HEXCOLOR(0x67C23A).CGColor;
    finishView.layer.borderWidth = 1.0;
    finishView.backgroundColor = [UIColor whiteColor];
    finishView.layer.cornerRadius = 2;
    finishView.centerY = examTitle.centerY;
    [_mainScrollView addSubview:finishView];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(finishView.right + 2.5, 0, 32 + 26, 18.5)];
    finishLabel.text = @"正确";
    finishLabel.font = SYSTEMFONT(13);
    finishLabel.textColor = EdlineV5_Color.textFirstColor;
    finishLabel.centerY = finishView.centerY;
    [_mainScrollView addSubview:finishLabel];
    
    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(finishLabel.right, finishView.top, 14, 14)];
    errorView.layer.masksToBounds = YES;
    errorView.layer.cornerRadius = 2;
    errorView.layer.borderColor = EdlineV5_Color.faildColor.CGColor;
    errorView.layer.borderWidth = 1;
    [_mainScrollView addSubview:errorView];
    
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(errorView.right + 2.5, 0, 32 + 26, 18.5)];
    errorLabel.text = @"错误";
    errorLabel.font = SYSTEMFONT(13);
    errorLabel.textColor = EdlineV5_Color.textFirstColor;
    errorLabel.centerY = finishView.centerY;
    [_mainScrollView addSubview:errorLabel];
    
    UIView *unfinishView = [[UIView alloc] initWithFrame:CGRectMake(errorLabel.right, finishView.top, 14, 14)];
    unfinishView.layer.masksToBounds = YES;
    unfinishView.layer.cornerRadius = 2;
    unfinishView.layer.borderColor = EdlineV5_Color.layarLineColor.CGColor;
    unfinishView.layer.borderWidth = 1;
    [_mainScrollView addSubview:unfinishView];
    
    UILabel *unfinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(unfinishView.right + 2.5, 0, 32 + 26, 18.5)];
    unfinishLabel.text = @"未答";
    unfinishLabel.font = SYSTEMFONT(13);
    unfinishLabel.textColor = EdlineV5_Color.textFirstColor;
    unfinishLabel.centerY = finishView.centerY;
    [_mainScrollView addSubview:unfinishLabel];
}

- (void)makeBottomView {
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 44)];
    [_resetButton setTitle:@"继续答题" forState:0];
    [_resetButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _resetButton.titleLabel.font = SYSTEMFONT(16);
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_resetButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_resetButton.right, 0, MainScreenWidth / 2.0, 44)];
    [_sureButton setTitle:@"交卷" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_bottomView addSubview:line];
}

- (void)sureButtonClick {
    if (SWNOTEmptyStr(_currentExamPaperDetailModel.paper_id)) {
        
        NSMutableDictionary *passDict = [NSMutableDictionary new];
        [passDict setObject:_currentExamPaperDetailModel.paper_id forKey:@"paper_id"];
        [passDict setObject:_currentExamPaperDetailModel.unique_code forKey:@"unique_code"];
        [passDict setObject:[NSArray arrayWithArray:_answerManagerArray] forKey:@"answer_data"];
//        if ([_currentExamPaperDetailModel.total_time isEqualToString:@"0"]) {
//            [passDict setObject:@(_remainTime) forKey:@"time_takes"];
//        } else {
//            [passDict setObject:@([_currentExamPaperDetailModel.total_time integerValue] * 60 - _remainTime) forKey:@"time_takes"];
//        }
        
        [Net_API requestPOSTWithURLStr:[Net_Path submitPaperNet] WithAuthorization:nil paramDic:passDict finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)resetButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeExamSheetUI {
    
    CGFloat hotYY = 15 + 22 + 14 + 14 + 20;
    if (SWNOTEmptyArr(_examArray)) {
        NSInteger order = 1;
        for (int j = 0; j < _examArray.count; j++) {
            UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, hotYY, MainScreenWidth, 0)];
            hotView.backgroundColor = [UIColor whiteColor];
            hotView.tag = 10 + j;
            [_mainScrollView addSubview:hotView];
            
            UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 20)];
            typeTitleLabel.font = SYSTEMFONT(14);
            typeTitleLabel.textColor = EdlineV5_Color.textFirstColor;
            NSMutableArray *childArray = [NSMutableArray new];
            typeTitleLabel.text = [NSString stringWithFormat:@"%@",((ExamSheetModel *)_examArray[j]).title];
            [hotView addSubview:typeTitleLabel];
            if (SWNOTEmptyArr(((ExamSheetModel *)_examArray[j]).child)) {
                [childArray addObjectsFromArray:[NSArray arrayWithArray:((ExamSheetModel *)_examArray[j]).child]];
            }
//            if (_isPaper) {
//                typeTitleLabel.text = [NSString stringWithFormat:@"%@",((ExamPaperIDListModel *)_examArray[j]).title];
//                [hotView addSubview:typeTitleLabel];
//                if (SWNOTEmptyArr(((ExamPaperIDListModel *)_examArray[j]).child)) {
//                    [childArray addObjectsFromArray:[NSArray arrayWithArray:((ExamPaperIDListModel *)_examArray[j]).child]];
//                }
//            } else {
//                typeTitleLabel.text = [NSString stringWithFormat:@"%@",((ExamIDListModel *)_examArray[j]).title];
//                [hotView addSubview:typeTitleLabel];
//                if (SWNOTEmptyArr(((ExamIDListModel *)_examArray[j]).child)) {
//                    [childArray addObjectsFromArray:[NSArray arrayWithArray:((ExamIDListModel *)_examArray[j]).child]];
//                }
//            }
            if (childArray.count) {
                CGFloat topSpacee = 15.0;
                CGFloat rightSpace = 15.0;
                CGFloat XX = 15.0;
                CGFloat YY = 12.0 + typeTitleLabel.bottom;
                CGFloat btnHeight = 36.0;
                for (int i = 0; i<childArray.count; i++) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, btnHeight, btnHeight)];
                    btn.tag = 400 + i;
                    [btn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:[NSString stringWithFormat:@"%@",@(order)] forState:0];
                    btn.titleLabel.font = SYSTEMFONT(14);
                    [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
                    btn.selected = ((ExamModel *)childArray[i]).answer_right;
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 4.0;
                    if (btn.selected) {
                        btn.layer.borderColor = HEXCOLOR(0x67C23A).CGColor;
                        btn.layer.borderWidth = 1.0;
                        btn.backgroundColor = [UIColor whiteColor];
                        [btn setTitleColor:HEXCOLOR(0x67C23A) forState:0];
                    } else {
                        btn.layer.borderColor = EdlineV5_Color.faildColor.CGColor;
                        btn.layer.borderWidth = 1.0;
                        btn.backgroundColor = [UIColor whiteColor];
                        [btn setTitleColor:EdlineV5_Color.faildColor forState:0];
                    }
                    if (_currentIndexpath) {
                        if (j == _currentIndexpath.section && i == _currentIndexpath.row) {
                            btn.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
                            btn.layer.borderWidth = 1.0;
                            btn.backgroundColor = EdlineV5_Color.buttonDisableColor;
                        }
                    }
                    if (btn.right > (MainScreenWidth - 15)) {
                        XX = 15.0;
                        YY = YY + topSpacee + btnHeight;
                    }
                    btn.frame = CGRectMake(XX, YY, btnHeight, btnHeight);
                    XX = btn.right + rightSpace;
                    if (i == childArray.count - 1) {
                        [hotView setHeight:btn.bottom];
                    }
                    [hotView addSubview:btn];
                    order = order + 1;
                }
            } else {
                [hotView setHeight:typeTitleLabel.bottom];
            }
            hotYY = hotView.bottom + 20;
            if (j == _examArray.count - 1) {
                _mainScrollView.contentSize = CGSizeMake(0, hotYY);
            }
        }
    } else {
        _mainScrollView.contentSize = CGSizeMake(0, hotYY);
    }
}

- (void)thirdBtnClick:(UIButton *)sender {
    UIView *view = (UIView *)sender.superview;
    
    ExamSheetModel *secondModel = (ExamSheetModel *)_examArray[view.tag - 10];
    
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    
    ExamModel *thirdModel = (ExamModel *)passThird[sender.tag - 400];
    // 跳转到答题详情页 处理  当前题下标 整个试题id列表的index
    if (thirdModel.topic_id) {
        self.chooseOtherExam(thirdModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    if (_isPaper) {
//        ExamSheetModel *secondModel = (ExamSheetModel *)_examArray[view.tag - 10];
//
//        NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
//
//        ExamModel *thirdModel = (ExamModel *)passThird[sender.tag - 400];
//        // 跳转到答题详情页 处理  当前题下标 整个试题id列表的index
//        if (thirdModel.topic_id) {
//            self.chooseOtherExam(thirdModel);
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else {
//        ExamIDListModel *secondModel = (ExamIDListModel *)_examArray[view.tag - 10];
//
//        NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
//
//        ExamIDModel *thirdModel = (ExamIDModel *)passThird[sender.tag - 400];
//        // 跳转到答题详情页 处理  当前题下标 整个试题id列表的index
//        if (thirdModel.topic_id) {
//            self.chooseOtherExam(thirdModel);
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}

// MARK: - 计时器开始计时
- (void)timerStart {
    if (_orderType) {
        // 正序计时
        // 显示时间
        _remainTime +=1;
        _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:_remainTime]];
    } else {
        // 倒序计时
        // 显示时间
        if (_remainTime <= 0) {
            _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:_remainTime]];
            [paperTimer invalidate];
            paperTimer = nil;
            _remainTime = 0;
        }
        _remainTime -=1;
        if (_remainTime<=-1) {
            [paperTimer invalidate];
            paperTimer = nil;
            _remainTime = 0;
        } else {
            _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:_remainTime]];
            if (_remainTime == 0) {
                // 这里不需要提交试卷了 因为在答题详情页会做这一步操作
            }
        }
    }
}

- (void)dealloc {
    if (paperTimer) {
        [paperTimer invalidate];
        paperTimer = nil;
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        [paperTimer invalidate];
        paperTimer = nil;
    }
}

@end
