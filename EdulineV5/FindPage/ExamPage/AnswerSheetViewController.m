//
//  AnswerSheetViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "AnswerSheetViewController.h"
#import "V5_Constant.h"

@interface AnswerSheetViewController ()

@property (strong, nonatomic) UIButton *resetButton;//清空筛选
@property (strong, nonatomic) UIButton *sureButton;//开始学习
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation AnswerSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"显示考试时间";
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    [_leftButton setImage:Image(@"nav_sheetclose_icon") forState:0];
 
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - (MACRO_UI_UPHEIGHT + 44 + MACRO_UI_SAFEAREA))];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    [self makeBottomView];
}

- (void)makeTopUI {
    UILabel *examTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 30, 22)];
    examTitle.font = SYSTEMFONT(16);
    examTitle.textColor = EdlineV5_Color.textFirstColor;
    examTitle.text = @"这里显示考试的标题";
    [_mainScrollView addSubview:examTitle];
    
//    UIView *finishView = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
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
}

- (void)resetButtonClick {
}

@end
