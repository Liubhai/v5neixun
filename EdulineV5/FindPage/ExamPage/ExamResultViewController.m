//
//  ExamResultViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamResultViewController.h"
#import "V5_Constant.h"
#import "JustCircleProgress.h"
#import "ExamSheetModel.h"
#import "Net_Path.h"
#import "ExamResultDetailViewController.h"
#import "ExamPaperErrorTestAgainVC.h"
#import "ExamPaperDetailViewController.h"

@interface ExamResultViewController () {
    NSString *can_exam;
    BOOL showReload;
}

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UILabel *examTitleLabel;
@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) UIImageView *goodIconImage;

@property (strong, nonatomic) JustCircleProgress *circleView;//157
@property (strong, nonatomic) UILabel *percentlabel;

@property (strong, nonatomic) UILabel *useTimeLeftLabel;
@property (strong, nonatomic) UILabel *finishLeftLabel;
@property (strong, nonatomic) UILabel *correctLeftLabel;

@property (strong, nonatomic) UILabel *userTimelabel;
@property (strong, nonatomic) UILabel *finishlabel;
@property (strong, nonatomic) UILabel *tipsLabel;// 主观题待阅卷提示
@property (strong, nonatomic) UILabel *correctlabel;

@property (strong, nonatomic) UIButton *resetButton;// 重新答题
@property (strong, nonatomic) UIButton *allAnalysisButton;//全部解析
@property (strong, nonatomic) UIButton *sureButton;//错题解析
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *examSheetBackView;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) NSDictionary *resultDict;// 考试结果信息
@property (strong, nonatomic) NSMutableArray *examArray;// 每部分数组

@property (strong, nonatomic) NSDictionary *resultDictWrong;// 考试结果信息(所有错题)
@property (strong, nonatomic) NSMutableArray *examWrongArray;// 每部分数组(所有错题)

@property (strong, nonatomic) UIView *changeTypeBackView;

@property (strong, nonatomic) UIButton *joinFirstBtn;
@property (strong, nonatomic) UIButton *studyFirstBtn;

@end

@implementation ExamResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (showReload) {
        [self getExamPaperResultInfo];
    }
    showReload = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleImage.hidden = YES;
    can_exam = @"0";
    showReload = NO;
    [self makeTopView];
    
    _examArray = [NSMutableArray new];
    _resultDict = [NSDictionary new];
    
    _examWrongArray = [NSMutableArray new];
    _resultDictWrong = [NSDictionary new];
    
    [self makeScrollview];
    
    [self makeTopUI];
    
    [self getExamPaperResultInfo];
    [self getExamPaperResultWrongInfo];
    
//    [self makeTestData];
    
//    [self makeExamSheetUI];
    
//    [self makeBottomView];
    
}

- (void)makeTopView {
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 270 + MACRO_UI_LIUHAI_HEIGHT)];
        
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _backImageView.bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[EdlineV5_Color.buttonDisableColor CGColor], (id)[EdlineV5_Color.themeColor CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0.5, 0.0f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(0.5, 1.0f); //(1, 1)
    [_backImageView.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.view addSubview:_backImageView];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    [_leftBtn setImage:Image(@"nav_back_white") forState:0];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    _examTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 27+MACRO_UI_STATUSBAR_ADD_HEIGHT, MainScreenWidth-100, 34)];
    _examTitleLabel.font = SYSTEMFONT(18);
    _examTitleLabel.textColor = [UIColor whiteColor];
    _examTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_examTitleLabel];
    
    _goodIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, 122, 122)];
    _goodIconImage.centerX = MainScreenWidth / 2.0;
    NSString *resultLevel = [NSString stringWithFormat:@"exam_top%@_icon",@(arc4random() % 4 + 1)];
    _goodIconImage.image = Image(resultLevel);//@"exam_top1_icon"
//    [self.view addSubview:_goodIconImage];
    
    _circleView = [[JustCircleProgress alloc] initWithFrame:CGRectMake(20, MACRO_UI_UPHEIGHT, 122, 122)];
    _circleView.backgroundColor = [UIColor clearColor];//EdlineV5_Color.themeColor;
    _circleView.lineWidth = 10.0;
    _circleView.bgColor = EdlineV5_Color.buttonDisableColor;
    _circleView.progressColor = [UIColor whiteColor];
    _circleView.progress = 90;
    _circleView.centerX = MainScreenWidth / 2.0;
    [self.view addSubview:_circleView];
    
    _percentlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 137, 137)];
    _percentlabel.font = SYSTEMFONT(9);
    _percentlabel.textColor = [UIColor whiteColor];
    _percentlabel.textAlignment = NSTextAlignmentCenter;
    _percentlabel.center = _circleView.center;
    _percentlabel.numberOfLines = 0;
    [self.view addSubview:_percentlabel];
    
    _circleView.hidden = NO;
    _percentlabel.hidden = NO;
    
    // 55 35 12 21 font 15 13
     
    _useTimeLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _circleView.bottom + 12, MainScreenWidth/2.0 - 10 - 25, 16)];
    _useTimeLeftLabel.font = SYSTEMFONT(12);
    _useTimeLeftLabel.textColor = [UIColor whiteColor];
    _useTimeLeftLabel.text = @"用时";
    _useTimeLeftLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_useTimeLeftLabel];
    
    _userTimelabel = [[UILabel alloc] initWithFrame:CGRectMake(_useTimeLeftLabel.right + 10, _useTimeLeftLabel.top, MainScreenWidth - (_useTimeLeftLabel.right + 10), 16)];
    _userTimelabel.font = SYSTEMFONT(12);
    _userTimelabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_userTimelabel];
    
    _finishLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_useTimeLeftLabel.left, _useTimeLeftLabel.bottom + 8, _useTimeLeftLabel.width, 16)];
    _finishLeftLabel.font = SYSTEMFONT(12);
    _finishLeftLabel.textColor = [UIColor whiteColor];
    _finishLeftLabel.text = @"交卷时间";
    _finishLeftLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_finishLeftLabel];
    
    _finishlabel = [[UILabel alloc] initWithFrame:CGRectMake(_useTimeLeftLabel.right + 10, _finishLeftLabel.top, _userTimelabel.width, 16)];
    _finishlabel.font = SYSTEMFONT(12);
    _finishlabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_finishlabel];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _finishlabel.bottom, MainScreenWidth, 11)];
    _tipsLabel.text = @"*该试卷含有主观题，请等待阅卷完成";
    _tipsLabel.font = SYSTEMFONT(10);
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_tipsLabel];
    _tipsLabel.hidden = YES;
    
//    _correctLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_useTimeLeftLabel.left, _finishLeftLabel.bottom + 12, 46 + 5, 21)];
//    _correctLeftLabel.font = SYSTEMFONT(15);
//    _correctLeftLabel.textColor = [UIColor whiteColor];
//    _correctLeftLabel.text = @"正确率";
//    [self.view addSubview:_correctLeftLabel];
//
//    _correctlabel = [[UILabel alloc] initWithFrame:CGRectMake(_useTimeLeftLabel.right + 15, _correctLeftLabel.top, 53 + 28, 21)];
//    _correctlabel.font = SYSTEMFONT(13);
//    _correctlabel.textColor = [UIColor whiteColor];
//    _correctlabel.text = @"0%";
//    [self.view addSubview:_correctlabel];
}

- (void)makeScrollview {
    _examSheetBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 270 + MACRO_UI_LIUHAI_HEIGHT - 12, MainScreenWidth, MainScreenHeight - (270 + MACRO_UI_LIUHAI_HEIGHT - 12 + 44 + MACRO_UI_SAFEAREA))];
    _examSheetBackView.backgroundColor = [UIColor whiteColor];
    CGFloat radius = 12; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_examSheetBackView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _examSheetBackView.bounds;
    maskLayer.path = path.CGPath;
    _examSheetBackView.layer.mask = maskLayer;
    [self.view addSubview:_examSheetBackView];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - (270 + MACRO_UI_LIUHAI_HEIGHT - 12 + 44 + MACRO_UI_SAFEAREA))];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [_examSheetBackView addSubview:_mainScrollView];
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
    
    UIView *subjectivityView = [[UIView alloc] initWithFrame:CGRectMake(unfinishLabel.right, finishView.top, 14, 14)];
    subjectivityView.layer.masksToBounds = YES;
    subjectivityView.layer.cornerRadius = 2;
    subjectivityView.layer.borderColor = EdlineV5_Color.layarLineColor.CGColor;
    subjectivityView.layer.borderWidth = 1;
    subjectivityView.backgroundColor = HEXCOLOR(0xF0F0F2);
    [_mainScrollView addSubview:subjectivityView];
    
    UILabel *subjectivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(subjectivityView.right + 2.5, 0, 32 + 26, 18.5)];
    subjectivityLabel.text = @"主观题";
    subjectivityLabel.font = SYSTEMFONT(13);
    subjectivityLabel.textColor = EdlineV5_Color.textFirstColor;
    subjectivityLabel.centerY = finishView.centerY;
    [_mainScrollView addSubview:subjectivityLabel];
}

- (void)makeBottomView {
    [_bottomView removeAllSubviews];
    [_bottomView removeFromSuperview];
    _bottomView = nil;
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 3.0, 44)];
    [_resetButton setTitle:@"错题重练" forState:0];
    [_resetButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _resetButton.titleLabel.font = SYSTEMFONT(16);
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_resetButton];
    
    _allAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(_resetButton.right, 0, MainScreenWidth / 3.0, 44)];
    [_allAnalysisButton setTitle:[can_exam isEqualToString:@"1"]?@"查看解析":@"全部解析" forState:0];
    if ([can_exam isEqualToString:@"1"]) {
        [_allAnalysisButton setImage:[Image(@"examresult_up") converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateNormal];
        [_allAnalysisButton setImage:[Image(@"examresult_down") converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateSelected];
    }
    [_allAnalysisButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _allAnalysisButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    _allAnalysisButton.titleLabel.font = SYSTEMFONT(16);
    if ([can_exam isEqualToString:@"1"]) {
        [EdulineV5_Tool dealButtonImageAndTitleUI:_allAnalysisButton];
        [_allAnalysisButton addTarget:self action:@selector(makeChangeTypeBackView) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_allAnalysisButton addTarget:self action:@selector(allAnalysisButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [_bottomView addSubview:_allAnalysisButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_allAnalysisButton.right, 0, MainScreenWidth / 3.0, 44)];
    [_sureButton setTitle:[can_exam isEqualToString:@"1"]?@"重新考试":@"错题解析" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    if ([can_exam isEqualToString:@"1"]) {
        [_sureButton addTarget:self action:@selector(examAgain) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [_bottomView addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 3.0, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_bottomView addSubview:line];
}

- (void)resetButtonClick {
//    if (![_answer_status isEqualToString:@"2"]) {
//        return;
//    }
    ExamPaperErrorTestAgainVC *vc = [[ExamPaperErrorTestAgainVC alloc] init];
    vc.paperInfo = [NSDictionary dictionaryWithDictionary:_resultDictWrong];
    vc.isOrderTest = YES;
    vc.examType = @"error";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)allAnalysisButtonClick {
//    if (![_answer_status isEqualToString:@"2"]) {
//        return;
//    }
    _changeTypeBackView.hidden = YES;
    _allAnalysisButton.selected = NO;
    ExamResultDetailViewController *vc = [[ExamResultDetailViewController alloc] init];
    vc.paperInfo = [NSDictionary dictionaryWithDictionary:_resultDict];
    vc.answer_status = _answer_status;
    vc.examType = _examType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sureButtonClick {
//    if (![_answer_status isEqualToString:@"2"]) {
//        return;
//    }
    _changeTypeBackView.hidden = YES;
    _allAnalysisButton.selected = NO;
    ExamResultDetailViewController *vc = [[ExamResultDetailViewController alloc] init];
    vc.paperInfo = [NSDictionary dictionaryWithDictionary:_resultDictWrong];
    vc.isErrorAnalysis = YES;
    vc.answer_status = _answer_status;
    vc.examType = _examType;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 重新考试
- (void)examAgain {
    showReload = YES;
    ExamPaperDetailViewController *vc = [[ExamPaperDetailViewController alloc] init];
    NSString *rollId = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"rollup_id"]];
    if ([rollId isEqualToString:@"0"]) {
        vc.examType = @"3";
    } else {
        vc.examType = @"4";
        vc.rollup_id = rollId;
    }
    vc.examIds = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"paper_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeTestData {
    int x = arc4random() % 10;
    for (int i = 0; i < x ; i++) {
        ExamSheetModel *sheetModel = [[ExamSheetModel alloc] init];
        sheetModel.title = [NSString stringWithFormat:@"题型名字%@",@(arc4random() % 100)];
        int Y = arc4random() % 10;
        NSMutableArray *pass = [NSMutableArray new];
        for (int j = 0; j < Y; j++) {
            ExamModel *model = [[ExamModel alloc] init];
            model.topic_id = [NSString stringWithFormat:@"%@",@(arc4random() % Y)];
            model.answer_right = (j % 2 == 0) ? YES : NO;
            [pass addObject:model];
        }
        sheetModel.child = [NSMutableArray arrayWithArray:pass];
        [_examArray addObject:sheetModel];
    }
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
            typeTitleLabel.text = [NSString stringWithFormat:@"%@",((ExamSheetModel *)_examArray[j]).title];
            [hotView addSubview:typeTitleLabel];
            NSMutableArray *childArray = [NSMutableArray new];
            if (SWNOTEmptyArr(((ExamSheetModel *)_examArray[j]).child)) {
                [childArray addObjectsFromArray:[NSArray arrayWithArray:((ExamSheetModel *)_examArray[j]).child]];
            }
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
//                    [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
//                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
//                    btn.selected = ((ExamModel *)childArray[i]).answer_right;
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 4.0;
                    /* 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题 **/
                    /** [((ExamModel *)childArray[i]).question_type isEqualToString:@"8"] || [((ExamModel *)childArray[i]).question_type isEqualToString:@"6"] */
                    if (((ExamModel *)childArray[i]).subjective) {
                        btn.layer.borderColor = HEXCOLOR(0xDCDFE6).CGColor;
                        btn.layer.borderWidth = 1.0;
                        btn.backgroundColor = HEXCOLOR(0xF0F0F2);
                        [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
                    } else {
                        if (((ExamModel *)childArray[i]).answered) {
                            if (((ExamModel *)childArray[i]).answer_right) {
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
                        } else {
                            btn.layer.borderColor = HEXCOLOR(0xDCDFE6).CGColor;
                            btn.layer.borderWidth = 1.0;
                            btn.backgroundColor = [UIColor whiteColor];
                            [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
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
    
    ExamResultDetailViewController *vc = [[ExamResultDetailViewController alloc] init];
    vc.paperInfo = [NSDictionary dictionaryWithDictionary:_resultDict];
    vc.currentResultModel = thirdModel;
    vc.answer_status = _answer_status;
    vc.examType = _examType;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 请求考试结果信息(全部)
- (void)getExamPaperResultInfo {
    if (SWNOTEmptyStr(_record_id)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examResultNet] WithAuthorization:nil paramDic:@{@"record_id":_record_id} finish:^(id  _Nonnull responseObject) {
            
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _resultDict = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    can_exam = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"can_exam"]];
                    [self setTopInfoData];
                    [_examArray removeAllObjects];
                    [_examArray addObjectsFromArray:[ExamSheetModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"paper_parts"]]];
                    [self makeExamSheetUI];
                    [self makeBottomView];
                    
                }
            }
            
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 请求考试结果信息(错题)
- (void)getExamPaperResultWrongInfo {
    if (SWNOTEmptyStr(_record_id)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examResultWrongNet] WithAuthorization:nil paramDic:@{@"record_id":_record_id} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _resultDictWrong = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    [_examWrongArray removeAllObjects];
                    [_examWrongArray addObjectsFromArray:[ExamSheetModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"paper_parts"]]];
                }
            }
            
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 头部信息赋值
- (void)setTopInfoData {
    if (SWNOTEmptyDictionary(_resultDict)) {
        _examTitleLabel.text = [NSString stringWithFormat:@"%@",_resultDict[@"paper_title"]];
        _userTimelabel.text = [EdulineV5_Tool timeChangeTimerWithSeconds:[[NSString stringWithFormat:@"%@",_resultDict[@"time_takes"]] integerValue]];
        _finishlabel.text = [EdulineV5_Tool formateYYYYMMDDHHMMTime:[NSString stringWithFormat:@"%@",_resultDict[@"commit_time"]]];
        
        /** 阅卷状态【0：提交答案；1：客观题已阅卷；2：主观题已阅卷，完成阅卷】 */
        NSString *user_answer_status = [NSString stringWithFormat:@"%@",_resultDict[@"answer_status"]];
        _answer_status = user_answer_status;
        if ([user_answer_status isEqualToString:@"1"]) {
            _tipsLabel.hidden = NO;
        }
        
        NSString *score = [EdulineV5_Tool reviseString:[NSString stringWithFormat:@"%@",_resultDict[@"user_score"]]];
        NSString *paperFullScore = [NSString stringWithFormat:@"%@",_resultDict[@"paper_score"]];
        
        _circleView.progress = [score floatValue] * 100 / [paperFullScore floatValue];
        
        NSString *fullScore = [NSString stringWithFormat:@"%@ 分\n总分%@分",score,paperFullScore];
        NSRange scoreRange = NSMakeRange(0, score.length);
        // 40 20 14
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:fullScore];
        [att addAttributes:@{NSFontAttributeName:SYSTEMFONT(32)} range:scoreRange];
        [att addAttributes:@{NSFontAttributeName:SYSTEMFONT(17)} range:NSMakeRange(scoreRange.length, 1)];
        [att addAttributes:@{NSFontAttributeName:SYSTEMFONT(13)} range:NSMakeRange(scoreRange.length + 1, fullScore.length - scoreRange.length - 1)];
        _percentlabel.textColor = [UIColor whiteColor];
        _percentlabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:att];
    }
}

- (void)makeChangeTypeBackView {
    
    if (!_changeTypeBackView) {
        _changeTypeBackView = [[UIView alloc] init];
        _changeTypeBackView.frame = CGRectMake(_allAnalysisButton.left, _bottomView.top - 4 - 100, _allAnalysisButton.width, 100);
        
        _changeTypeBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _changeTypeBackView.layer.cornerRadius = 4;
        _changeTypeBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
        _changeTypeBackView.layer.shadowOffset = CGSizeMake(0,1);
        _changeTypeBackView.layer.shadowOpacity = 1;
        _changeTypeBackView.layer.shadowRadius = 7;
        
        _joinFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, _changeTypeBackView.width, 22 + 9 + 9)];
        _joinFirstBtn.tag = 10;
        [_joinFirstBtn setTitle:@"错题解析" forState:0];
        [_joinFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [_joinFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        _joinFirstBtn.titleLabel.font = SYSTEMFONT(16);
        [_joinFirstBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:_joinFirstBtn];
        
        _studyFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _joinFirstBtn.bottom, _changeTypeBackView.width, 22 + 9 + 9)];
        _studyFirstBtn.tag = 11;
        [_studyFirstBtn setTitle:@"全部解析" forState:0];
        [_studyFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [_studyFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        _studyFirstBtn.titleLabel.font = SYSTEMFONT(16);
        [_studyFirstBtn addTarget:self action:@selector(allAnalysisButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:_studyFirstBtn];
        _changeTypeBackView.hidden = YES;
        [self.view addSubview:_changeTypeBackView];
    }
    _allAnalysisButton.selected = !_allAnalysisButton.selected;
    _changeTypeBackView.hidden = !_changeTypeBackView.hidden;
}

@end
