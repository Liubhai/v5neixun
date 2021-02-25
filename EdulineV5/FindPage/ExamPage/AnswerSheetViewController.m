//
//  AnswerSheetViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "AnswerSheetViewController.h"
#import "V5_Constant.h"
//#import "ExamSheetModel.h"
#import "ExamIDListModel.h"

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
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    [self makeTopUI];
    
    [self makeExamSheetUI];
    
    [self makeBottomView];
}

- (void)makeTopUI {
    UILabel *examTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 30, 22)];
    examTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    examTitle.textColor = EdlineV5_Color.textFirstColor;
    examTitle.text = @"这里显示考试的标题";
    [_mainScrollView addSubview:examTitle];
    
    UIView *finishView = [[UIView alloc] initWithFrame:CGRectMake(15, examTitle.bottom + 14, 14, 14)];
    finishView.backgroundColor = EdlineV5_Color.themeColor;
    finishView.layer.masksToBounds = YES;
    finishView.layer.cornerRadius = 2;
    [_mainScrollView addSubview:finishView];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(finishView.right + 2.5, 0, 32 + 26, 18.5)];
    finishLabel.text = @"已答";
    finishLabel.font = SYSTEMFONT(13);
    finishLabel.textColor = EdlineV5_Color.textFirstColor;
    finishLabel.centerY = finishView.centerY;
    [_mainScrollView addSubview:finishLabel];
    
    UIView *unfinishView = [[UIView alloc] initWithFrame:CGRectMake(finishLabel.right, examTitle.bottom + 14, 14, 14)];
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
            typeTitleLabel.text = [NSString stringWithFormat:@"%@",((ExamIDListModel *)_examArray[j]).title];
            [hotView addSubview:typeTitleLabel];
            NSMutableArray *childArray = [NSMutableArray new];
            if (SWNOTEmptyArr(((ExamIDListModel *)_examArray[j]).child)) {
                [childArray addObjectsFromArray:[NSArray arrayWithArray:((ExamIDListModel *)_examArray[j]).child]];
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
                    [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
                    btn.selected = ((ExamIDModel *)childArray[i]).has_answered;
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 4.0;
                    if (btn.selected) {
                        btn.backgroundColor = EdlineV5_Color.themeColor;
                    } else {
                        btn.layer.borderColor = EdlineV5_Color.layarLineColor.CGColor;
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
    
    ExamIDListModel *secondModel = (ExamIDListModel *)_examArray[view.tag - 10];
    
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    
    ExamIDModel *thirdModel = (ExamIDModel *)passThird[sender.tag - 400];
    // 跳转到答题详情页 处理  当前题下标 整个试题id列表的index
    if (thirdModel.topic_id) {
        self.chooseOtherExam(thirdModel.topic_id);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
