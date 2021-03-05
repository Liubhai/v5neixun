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

@interface ExamResultViewController ()

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
@property (strong, nonatomic) UILabel *correctlabel;

@property (strong, nonatomic) UIButton *resetButton;// 重新答题
@property (strong, nonatomic) UIButton *allAnalysisButton;//全部解析
@property (strong, nonatomic) UIButton *sureButton;//错题解析
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *examSheetBackView;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) NSMutableArray *examArray;

@end

@implementation ExamResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleImage.hidden = YES;
    
    [self makeTopView];
    
    _examArray = [NSMutableArray new];
    
    [self makeScrollview];
    
    [self makeTopUI];
    
    [self makeTestData];
    
    [self makeExamSheetUI];
    
    [self makeBottomView];
    
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
    _examTitleLabel.text = @"高一物理期中考试卷";
    [self.view addSubview:_examTitleLabel];
    
    _goodIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, 122, 122)];
    _goodIconImage.centerX = MainScreenWidth / 2.0;
    NSString *resultLevel = [NSString stringWithFormat:@"exam_top%@_icon",@(arc4random() % 4 + 1)];
    _goodIconImage.image = Image(resultLevel);//@"exam_top1_icon"
    [self.view addSubview:_goodIconImage];
    
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
    
    NSString *score = [NSString stringWithFormat:@"%@",@"90"];
    NSString *fullScore = [NSString stringWithFormat:@"%@ 分\n满分100分",score];
    NSRange scoreRange = NSMakeRange(0, score.length);
    // 40 20 14
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:fullScore];
    [att addAttributes:@{NSFontAttributeName:SYSTEMFONT(40)} range:scoreRange];
    [att addAttributes:@{NSFontAttributeName:SYSTEMFONT(20)} range:NSMakeRange(scoreRange.length, 1)];
    [att addAttributes:@{NSFontAttributeName:SYSTEMFONT(14)} range:NSMakeRange(scoreRange.length + 1, fullScore.length - scoreRange.length - 1)];
    _percentlabel.textColor = [UIColor whiteColor];
    _percentlabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:att];
    
    _circleView.hidden = YES;
    _percentlabel.hidden = YES;
    
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
    _userTimelabel.text = @"00:33:21";
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
    _finishlabel.text = @"2021-12-32 12:33";
    [self.view addSubview:_finishlabel];
    
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
}

- (void)makeBottomView {
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 3.0, 44)];
    [_resetButton setTitle:@"重新考试" forState:0];
    [_resetButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _resetButton.titleLabel.font = SYSTEMFONT(16);
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_resetButton];
    
    _allAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(_resetButton.right, 0, MainScreenWidth / 3.0, 44)];
    [_allAnalysisButton setTitle:@"全部解析" forState:0];
    [_allAnalysisButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _allAnalysisButton.backgroundColor = EdlineV5_Color.buttonDisableColor;
    _allAnalysisButton.titleLabel.font = SYSTEMFONT(16);
    [_allAnalysisButton addTarget:self action:@selector(allAnalysisButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_allAnalysisButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_allAnalysisButton.right, 0, MainScreenWidth / 3.0, 44)];
    [_sureButton setTitle:@"错题解析" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 3.0, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_bottomView addSubview:line];
}

- (void)resetButtonClick {
    
}

- (void)allAnalysisButtonClick {
    
}

- (void)sureButtonClick {
    
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
            model.exam_id = [NSString stringWithFormat:@"%@",@(arc4random() % Y)];
            model.selected = (j % 2 == 0) ? YES : NO;
            [pass addObject:model];
        }
        sheetModel.child = [NSMutableArray arrayWithArray:pass];
        [_examArray addObject:sheetModel];
    }
}

- (void)makeExamSheetUI {
    
    CGFloat hotYY = 15 + 22 + 14 + 14 + 20;
    if (SWNOTEmptyArr(_examArray)) {
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
                    [btn setTitle:[NSString stringWithFormat:@"%@",((ExamModel *)childArray[i]).exam_id] forState:0];
                    btn.titleLabel.font = SYSTEMFONT(14);
                    [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
                    btn.selected = ((ExamModel *)childArray[i]).selected;
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 4.0;
                    if (btn.selected) {
                        btn.layer.borderColor = HEXCOLOR(0x67C23A).CGColor;
                        btn.layer.borderWidth = 1.0;
                        btn.backgroundColor = [UIColor whiteColor];
                    } else {
                        btn.layer.borderColor = EdlineV5_Color.faildColor.CGColor;
                        btn.layer.borderWidth = 1.0;
                        btn.backgroundColor = [UIColor whiteColor];
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
}

@end
