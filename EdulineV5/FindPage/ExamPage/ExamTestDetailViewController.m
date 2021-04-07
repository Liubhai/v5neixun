//
//  ExamTestDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/19.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamTestDetailViewController.h"
#import "TYAttributedLabel.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamIDListModel.h"

#import "ExamAnswerCell.h"

#import "AnswerSheetViewController.h"

@interface ExamTestDetailViewController ()<UITableViewDelegate, UITableViewDataSource, ExamAnswerCellDelegate> {
    NSInteger examCount;//整套试卷的总题数
    NSInteger currentExamRow;// 当前答题是第几道题
    NSIndexPath *currentExamIndexPath;// 当前答题在整个列表中的下标
    NSString *currentExamId;//当前答题的试题ID
    BOOL canEnterNextExam;// 点击下一题的时候是 答对 答错 能否直接进入下一题 还是需要显示解析
}

//  用一个专门数组去存储请求到的题的详情 上一题的时候就直接取出来去加载数据; 填充数据的时候 直接用 ExamDetailModel 去填充答案或者填空框内的内容

@property (strong, nonatomic) UIImageView *rightOrErrorIcon;// 正确错误 图标

@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray *examIdListArray;// 获取得到题干ID数组
@property (strong, nonatomic) NSMutableArray *examDetailArray;// 通过题干ID获取到具体试题内容数组
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *previousExamBtn;
@property (strong, nonatomic) UIButton *nextExamBtn;

@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) UIButton *examSheetBtn;
@property (strong, nonatomic) UIButton *examCollectBtn;

@property (strong, nonatomic) NSMutableArray *answerManagerArray;// 选择的答案对应的数组 一维数组 遍历一次(添加 修改)





@end

@implementation ExamTestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.hidden = YES;
    
    canEnterNextExam = NO;
    
    _answerManagerArray = [NSMutableArray new];
    
//    _examIdListArray = [NSMutableArray new];
    _examDetailArray = [NSMutableArray new];
    
    [self makeTopView];
    [self makeHeaderView];
    [self makeTableView];
    
    _rightOrErrorIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 74 - 4, MACRO_UI_UPHEIGHT + 8, 74, 74)];
    _rightOrErrorIcon.image = Image(@"exam_fault_icon");
    [self.view addSubview:_rightOrErrorIcon];
    _rightOrErrorIcon.hidden = YES;
    
//    [self makeBottomView];
    
//    [self getData];
    [self getExamDetailForExamIds:_examIds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextViewChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)makeTopView {
    
    _examCollectBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 20, 0, 20, 20)];
    [_examCollectBtn setImage:Image(@"star_nor") forState:0];
    [_examCollectBtn setImage:Image(@"star_pre") forState:UIControlStateSelected];
    _examCollectBtn.centerY = _titleLabel.centerY;
    [_examCollectBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_examCollectBtn];
}

- (void)makeBottomView:(ExamDetailModel *)model {
    if ([_examType isEqualToString:@"collect"]) {
        return;
    }
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _previousExamBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 44)];
    [_previousExamBtn setTitle:@"上一题" forState:0];
    [_previousExamBtn setImage:Image(@"exam_last") forState:0];
    [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _previousExamBtn.titleLabel.font = SYSTEMFONT(16);
    [_previousExamBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_previousExamBtn) {
        CGFloat space = 7.5;
        _previousExamBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
        _previousExamBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    }
    
    [_bottomView addSubview:_previousExamBtn];
    
    _nextExamBtn = [[UIButton alloc] initWithFrame:CGRectMake(_previousExamBtn.right, 0, MainScreenWidth / 2.0, 44)];
    [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    _nextExamBtn.titleLabel.font = SYSTEMFONT(16);
    [_nextExamBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isOrderTest && SWNOTEmptyStr(model.next_topic_id)) {
        [_nextExamBtn setTitle:@"下一题" forState:0];
        [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = _nextExamBtn.imageView.frame.size.width;
        CGFloat imageHeight = _nextExamBtn.imageView.frame.size.height;
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = _nextExamBtn.titleLabel.intrinsicContentSize.width;
            labelHeight = _nextExamBtn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = _nextExamBtn.titleLabel.frame.size.width;
            labelHeight = _nextExamBtn.titleLabel.frame.size.height;
        }
        CGFloat space = 7.5;

        _nextExamBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
        _nextExamBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
    } else {
        [_nextExamBtn setTitle:@"提交" forState:0];
    }
    [_bottomView addSubview:_nextExamBtn];
    _nextExamBtn.hidden = NO;
    _previousExamBtn.hidden = YES;
    [_nextExamBtn setCenterX:MainScreenWidth / 2.0];
    
    _previousExamBtn.enabled = NO;
    _nextExamBtn.enabled = NO;
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    _headerView.backgroundColor = EdlineV5_Color.backColor;
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    _footerView.backgroundColor = EdlineV5_Color.backColor;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - ([_examType isEqualToString:@"error"] ? (MACRO_UI_SAFEAREA + 44) : 0)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            return 1;
        }
        if (SWNOTEmptyArr(model.topics)) {
            return model.topics.count;
        } else {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            return model.topics.count;
        }
        if ([model.question_type isEqualToString:@"8"]) {
            return 1;
        }
        if (SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[section];
            if ([modelpass.question_type isEqualToString:@"8"]) {
                return 1;
            }
            return modelpass.options.count;
        } else {
            return model.options.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"ExamAnswerCell";
    ExamAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[ExamAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            [cell setExamDetail:model cellModel:model.topics[indexPath.row] cellIndex:indexPath];
        } else if ([model.question_type isEqualToString:@"8"]) {
            if (model.options.count) {
                [cell setAnswerInfo:(ExamDetailOptionsModel *)(model.options[indexPath.row]) mainExamDetail:model examDetail:model cellIndex:indexPath];
            } else {
                [cell setAnswerInfo:[ExamDetailOptionsModel new] mainExamDetail:model examDetail:model cellIndex:indexPath];
            }
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                ExamDetailModel *modelpass = model.topics[indexPath.section];
                if ([modelpass.question_type isEqualToString:@"8"]) {
                    if (!modelpass.options.count) {
                        [cell setAnswerInfo:[ExamDetailOptionsModel new] mainExamDetail:model examDetail:modelpass cellIndex:indexPath];
                    } else {
                        [cell setAnswerInfo:(ExamDetailOptionsModel *)(modelpass.options[indexPath.row]) mainExamDetail:model examDetail:modelpass cellIndex:indexPath];
                    }
                } else {
                    [cell setAnswerInfo:(ExamDetailOptionsModel *)(modelpass.options[indexPath.row]) mainExamDetail:model examDetail:modelpass cellIndex:indexPath];
                }
            } else {
                [cell setAnswerInfo:(ExamDetailOptionsModel *)(model.options[indexPath.row]) mainExamDetail:model examDetail:model cellIndex:indexPath];
            }
        }
    }
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    back.backgroundColor = EdlineV5_Color.backColor;
    
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        
        UIImageView *examTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 32, 16)];
        // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答
        if (![model.question_type isEqualToString:@"7"] && SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *cailiaoModel = model.topics[section];
            if ([cailiaoModel.question_type isEqualToString:@"1"]) {
                examTypeImageView.image = [Image(@"Multiple Choice_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([cailiaoModel.question_type isEqualToString:@"2"]) {
                examTypeImageView.image = [Image(@"judge_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([cailiaoModel.question_type isEqualToString:@"3"]) {
                examTypeImageView.image = [Image(@"duoxuan_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([cailiaoModel.question_type isEqualToString:@"4"]) {
                examTypeImageView.image = [Image(@"budingxaing_icon") converToMainColor];
                [examTypeImageView setWidth:44];
            } else if ([cailiaoModel.question_type isEqualToString:@"5"]) {
                examTypeImageView.image = [Image(@"tiankong_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([cailiaoModel.question_type isEqualToString:@"6"]) {
                examTypeImageView.image = [Image(@"cailiao_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([cailiaoModel.question_type isEqualToString:@"7"]) {
                examTypeImageView.image = [Image(@"wanxing_icon") converToMainColor];
                [examTypeImageView setWidth:55];
            } else if ([cailiaoModel.question_type isEqualToString:@"8"]) {
                examTypeImageView.image = [Image(@"jieda_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            }
        } else {
            if ([model.question_type isEqualToString:@"1"]) {
                examTypeImageView.image = [Image(@"Multiple Choice_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([model.question_type isEqualToString:@"2"]) {
                examTypeImageView.image = [Image(@"judge_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([model.question_type isEqualToString:@"3"]) {
                examTypeImageView.image = [Image(@"duoxuan_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([model.question_type isEqualToString:@"4"]) {
                examTypeImageView.image = [Image(@"budingxaing_icon") converToMainColor];
                [examTypeImageView setWidth:44];
            } else if ([model.question_type isEqualToString:@"5"]) {
                examTypeImageView.image = [Image(@"tiankong_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([model.question_type isEqualToString:@"6"]) {
                examTypeImageView.image = [Image(@"cailiao_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            } else if ([model.question_type isEqualToString:@"7"]) {
                examTypeImageView.image = [Image(@"wanxing_icon") converToMainColor];
                [examTypeImageView setWidth:55];
            } else if ([model.question_type isEqualToString:@"8"]) {
                examTypeImageView.image = [Image(@"jieda_icon") converToMainColor];
                [examTypeImageView setWidth:32];
            }
        }
        [back addSubview:examTypeImageView];
        
        UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(11, 20, MainScreenWidth - 22, 20)];
        lable1111.backgroundColor = EdlineV5_Color.backColor;
        NSMutableAttributedString * attrString;
        
        if (![model.question_type isEqualToString:@"7"] && SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[section];
            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:modelpass.titleMutable];
            examTypeImageView.frame = CGRectMake(15, 2, 32, 16);
        } else {
            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
        }
        
        [attrString addAttributes:@{NSFontAttributeName:SYSTEMFONT(14)} range:NSMakeRange(0, attrString.length)];
        
        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
        [lable1111 sizeToFit];
        lable1111.showsVerticalScrollIndicator = NO;
        lable1111.showsHorizontalScrollIndicator = NO;
        lable1111.editable = NO;
        lable1111.scrollEnabled = NO;
        [lable1111 setHeight:lable1111.height];
        [back setHeight:lable1111.bottom];
        [back addSubview:lable1111];
        return back;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(11, 0, MainScreenWidth - 22, 20)];
    NSMutableAttributedString * attrString;
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        
        if ([model.question_type isEqualToString:@"7"]) {
            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                ExamDetailModel *modelpass = model.topics[section];
                attrString = [[NSMutableAttributedString alloc] initWithAttributedString:modelpass.titleMutable];
            } else {
                attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
            }
        }
        [attrString addAttributes:@{NSFontAttributeName:SYSTEMFONT(14)} range:NSMakeRange(0, attrString.length)];
        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
        [lable1111 sizeToFit];
        [lable1111 setHeight:lable1111.height];
        return lable1111.height + 20;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([_examType isEqualToString:@"3"]) {
        return nil;
    } else {
        
        ExamDetailModel *modelxxx;
        NSString *currentModelType = @"";
        if (SWNOTEmptyArr(_examDetailArray)) {
            ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
            currentModelType = model.question_type;
            if ([model.question_type isEqualToString:@"7"]) {
                modelxxx = model;
            } else {
                if (SWNOTEmptyArr(model.topics)) {
                    ExamDetailModel *modelpass = model.topics[section];
                    modelxxx = modelpass;
                } else {
                    modelxxx = model;
                }
            }
        }
        if (!modelxxx.is_answer) {
            return nil;
        }
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
        back.backgroundColor = EdlineV5_Color.backColor;
        
        UILabel *examPointTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - (58 + 33) - 15, 20)];
        examPointTitle.textColor = EdlineV5_Color.textFirstColor;
        examPointTitle.font = SYSTEMFONT(14);
        examPointTitle.text = @"考点：";
        NSString *pointS = @"";
        for (int i = 0; i<modelxxx.points.count; i++) {
            if (i == 0) {
                pointS = [NSString stringWithFormat:@"%@",modelxxx.points[i]];
            } else {
                pointS = [NSString stringWithFormat:@"%@、%@",pointS,modelxxx.points[i]];
            }
        }
        examPointTitle.text = [NSString stringWithFormat:@"考点：%@",pointS];
        [back addSubview:examPointTitle];
        if ([currentModelType isEqualToString:@"6"]) {
            examPointTitle.hidden = YES;
        }
        
        UIButton *expandButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (58 + 33), 12, (58 + 33) - 15, 20)];
        [expandButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        expandButton.titleLabel.font = SYSTEMFONT(14);
        [expandButton setTitle:@"查看解析" forState:0];
        [expandButton setImage:Image(@"exam_parsingdown_icon") forState:0];
        
        [expandButton setTitle:@"收起解析" forState:UIControlStateSelected];
        [expandButton setImage:Image(@"exam_parsingup_icon") forState:UIControlStateSelected];
        expandButton.tag = section;
        [expandButton addTarget:self action:@selector(expandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        expandButton.selected = modelxxx.is_expand;
        
        [EdulineV5_Tool dealButtonImageAndTitleUI:expandButton];
        [back addSubview:expandButton];
        [back setHeight:expandButton.bottom + 12];
        
        if (modelxxx.is_expand) {
            
            UILabel *rightAnswerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, expandButton.bottom + 16, 75, 20)];
            rightAnswerTitle.font = SYSTEMFONT(15);
            rightAnswerTitle.textColor = HEXCOLOR(0x67C23A);
            rightAnswerTitle.text = @"正确答案：";
            [back addSubview:rightAnswerTitle];
            CGFloat rightAnswerTitleWidth = [rightAnswerTitle.text sizeWithFont:rightAnswerTitle.font].width;
            [rightAnswerTitle setWidth:rightAnswerTitleWidth];
            
            UITextView *rightValueTextView = [[UITextView alloc] initWithFrame:CGRectMake(rightAnswerTitle.right - 10, rightAnswerTitle.top - 7, MainScreenWidth - (rightAnswerTitle.right - 10) - 15, 20)];
            rightValueTextView.showsVerticalScrollIndicator = NO;
            rightValueTextView.showsHorizontalScrollIndicator = NO;
            rightValueTextView.editable = NO;
            rightValueTextView.scrollEnabled = NO;
            rightValueTextView.backgroundColor = EdlineV5_Color.backColor;
            rightValueTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:SWNOTEmptyStr(modelxxx.examAnswer) ? modelxxx.examAnswer : @""]];
            rightValueTextView.font = SYSTEMFONT(15);
            [rightValueTextView sizeToFit];
            [rightValueTextView setHeight:rightValueTextView.height];
            [back addSubview:rightValueTextView];
            
            UILabel *keyTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, MAX(rightAnswerTitle.bottom, rightValueTextView.bottom) + 7, 50, 20)];
            keyTitle.font = SYSTEMFONT(14);
            keyTitle.textColor = EdlineV5_Color.textFirstColor;
            keyTitle.text = @"解析：";
            [back addSubview:keyTitle];
            
            UITextView *analyzeTextView = [[UITextView alloc] initWithFrame:CGRectMake(keyTitle.right - 15, keyTitle.top - 7, MainScreenWidth - keyTitle.right, 20)];
            analyzeTextView.showsVerticalScrollIndicator = NO;
            analyzeTextView.showsHorizontalScrollIndicator = NO;
            analyzeTextView.editable = NO;
            analyzeTextView.scrollEnabled = NO;
            analyzeTextView.backgroundColor = EdlineV5_Color.backColor;
            analyzeTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:modelxxx.analyzeMutable];
            analyzeTextView.font = SYSTEMFONT(15);
            [analyzeTextView sizeToFit];
            [analyzeTextView setHeight:analyzeTextView.height];
            [back addSubview:analyzeTextView];
            [back setHeight:MAX(keyTitle.bottom, analyzeTextView.bottom) + 12];
        }
        return back;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_examType isEqualToString:@"3"]) {
        return 0.001;
    } else {
        ExamDetailModel *modelxxx;
        
        if (SWNOTEmptyArr(_examDetailArray)) {
            ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
            if ([model.question_type isEqualToString:@"7"]) {
                modelxxx = model;
            } else {
                if (SWNOTEmptyArr(model.topics)) {
                    ExamDetailModel *modelpass = model.topics[section];
                    modelxxx = modelpass;
                } else {
                    modelxxx = model;
                }
            }
        }
        
        if (!modelxxx.is_answer) {
            return 0.001;
        }
        
        if (modelxxx.is_expand) {
            UITextView *rightValueTextView = [[UITextView alloc] initWithFrame:CGRectMake(15 + 80, 12 + 20 + 16 - 7, MainScreenWidth - 95 - 15, 20)];
            rightValueTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:SWNOTEmptyStr(modelxxx.examAnswer) ? modelxxx.examAnswer : @""]];
            rightValueTextView.font = SYSTEMFONT(15);
            [rightValueTextView sizeToFit];
            [rightValueTextView setHeight:rightValueTextView.height];
            
            UITextView *analyzeTextView = [[UITextView alloc] initWithFrame:CGRectMake(15 + 54, MAX((12 + 20 + 16 + 20), rightValueTextView.bottom), MainScreenWidth - 69 - 15, 20)];
            analyzeTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:modelxxx.analyzeMutable];
            analyzeTextView.font = SYSTEMFONT(15);
            [analyzeTextView sizeToFit];
            [analyzeTextView setHeight:analyzeTextView.height];
            CGFloat viewHeight = MAX((MAX((12 + 20 + 16 + 20), rightValueTextView.bottom) + 7 + 20), analyzeTextView.bottom) + 12;
            return viewHeight;
        } else {
            return 12 + 20 + 12;
        }
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

// MARK: - cell代理方法合集(ExamAnswerCellDelegate)
- (void)gapfillingChooseStatusChanged:(ExamAnswerCell *)answerCell button:(nonnull UIButton *)sender {
    ExamDetailModel *current_model = [self checkExamDetailArray:currentExamId];
    ExamDetailModel *current_cell_model = current_model.topics[answerCell.cellIndexPath.row];
    for (int i = 0; i<current_cell_model.options.count; i++) {
        ExamDetailOptionsModel *optionModel = current_cell_model.options[i];
        if (i == (sender.tag - 100)) {
            optionModel.is_selected = YES;
        } else {
            optionModel.is_selected = NO;
        }
    }
    [_tableView reloadRowAtIndexPath:answerCell.cellIndexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            // 完形填空
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                // 小题有多个 材料题
                ExamDetailModel *modelpass = model.topics[indexPath.section];
            } else {
                if (model.is_answer) {
                    return;
                }
                // 只有一个小题
                // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题
                if ([model.question_type isEqualToString:@"1"] || [model.question_type isEqualToString:@"2"]) {
                    for (int i = 0; i<model.options.count; i ++) {
                        ExamDetailOptionsModel *op = (ExamDetailOptionsModel *)(model.options[i]);
                        if (i == indexPath.row) {
                            op.is_selected = YES;
                        } else {
                            op.is_selected = NO;
                        }
                    }
                    [_tableView reloadData];
                } else if ([model.question_type isEqualToString:@"3"] || [model.question_type isEqualToString:@"4"]) {
                    for (int i = 0; i<model.options.count; i ++) {
                        ExamDetailOptionsModel *op = (ExamDetailOptionsModel *)(model.options[i]);
                        if (i == indexPath.row) {
                            op.is_selected = !op.is_selected;
                        }
                    }
                    [_tableView reloadData];
                }
            }
        }
    }
}

- (void)getExamDetailForExamIds:(NSString *)examIds {
    if (SWNOTEmptyStr(examIds)) {
        currentExamId = examIds;
        // 首选通过 ID 去获取 获取不到再去请求数据
        ExamDetailModel *c_model = [self checkExamDetailArray:examIds];
        if (c_model) {
            [self makeUIByExamDetailModel:c_model];
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
            return;
        }
        
        // 匹配不到对应试题ID的试题详情model 就需要请求接口
        NSString *getUrl = [Net_Path examWrongDetailNet];
        NSMutableDictionary *param = [NSMutableDictionary new];
        if ([_examType isEqualToString:@"error"]) {
            getUrl = [Net_Path examWrongDetailNet];
            [param setObject:examIds forKey:@"topic_id"];
        } else if ([_examType isEqualToString:@"collect"]) {
            getUrl = [Net_Path examPublicDetailNet];
            [param setObject:examIds forKey:@"topic_id"];
            [param setObject:@"6" forKey:@"origin"];
        }
        ShowHud(@"试题信息拉取中...");
        [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSMutableArray *passArray = [NSMutableArray arrayWithArray:[ExamDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                    for (int i = 0; i<passArray.count; i++) {
                        ExamDetailModel *pass = passArray[i];
                        pass.titleMutable = [self changeStringToMutA:pass.title];
                        pass.analyzeMutable = [self changeStringToMutA:pass.analyze];
                        if ([_examType isEqualToString:@"collect"]) {
                            pass.is_answer = YES;
                            pass.is_expand = YES;
                        }
                        if (SWNOTEmptyArr(pass.topics)) {
                            for (int j = 0; j<pass.topics.count; j++) {
                                ExamDetailModel *detail = pass.topics[j];
                                NSString *examAnswer = @"";
                                detail.titleMutable = [self changeCailiaoStringToMutA:[NSString stringWithFormat:@"(%@）%@",@(j + 1),detail.title] indexString:[NSString stringWithFormat:@"(%@）",@(j + 1)]];
                                detail.analyzeMutable = [self changeStringToMutA:detail.analyze];
                                if ([_examType isEqualToString:@"collect"]) {
                                    detail.is_answer = YES;
                                    detail.is_expand = YES;
                                }
                                if ([detail.question_type isEqualToString:@"8"]) {
                                    ExamDetailOptionsModel *op = [ExamDetailOptionsModel new];
                                    detail.options = [NSArray arrayWithObjects:op, nil];
                                } else {
                                    for (int k = 0; k<detail.options.count; k++) {
                                        ExamDetailOptionsModel *modelOp = detail.options[k];
                                        modelOp.mutvalue = [self changeStringToMutA:modelOp.value];
                                        if ([detail.question_type isEqualToString:@"5"]) {
                                            NSString *gapFillAnswer = [NSString stringWithFormat:@"（%@）",@(k + 1)];
                                            for (int m = 0; m < modelOp.values.count; m++) {
                                                if (m == 0) {
                                                    gapFillAnswer = [NSString stringWithFormat:@"%@%@",gapFillAnswer,modelOp.values[m]];
                                                } else {
                                                    gapFillAnswer = [NSString stringWithFormat:@"%@、%@",gapFillAnswer,modelOp.values[m]];
                                                }
                                            }
                                            examAnswer = [NSString stringWithFormat:@"%@%@",examAnswer,gapFillAnswer];
                                        } else {
                                            if (modelOp.is_right) {
                                                examAnswer = [NSString stringWithFormat:@"%@%@",examAnswer,modelOp.key];
                                            }
                                        }
                                    }
                                }
                                detail.examAnswer = examAnswer;
                            }
                        } else {
                            if ([pass.question_type isEqualToString:@"8"]) {
                                ExamDetailOptionsModel *op = [ExamDetailOptionsModel new];
                                pass.options = [NSArray arrayWithObjects:op, nil];
                            } else {
                                NSString *examAnswer = @"";
                                for (int j = 0; j<pass.options.count; j++) {
                                    ExamDetailOptionsModel *modelOp = pass.options[j];
                                    modelOp.mutvalue = [self changeStringToMutA:modelOp.value];
                                    if ([pass.question_type isEqualToString:@"5"]) {
                                        NSString *gapFillAnswer = [NSString stringWithFormat:@"（%@）",@(j + 1)];
                                        for (int m = 0; m < modelOp.values.count; m++) {
                                            if (m == 0) {
                                                gapFillAnswer = [NSString stringWithFormat:@"%@%@",gapFillAnswer,modelOp.values[m]];
                                            } else {
                                                gapFillAnswer = [NSString stringWithFormat:@"%@、%@",gapFillAnswer,modelOp.values[m]];
                                            }
                                        }
                                        examAnswer = [NSString stringWithFormat:@"%@%@",examAnswer,gapFillAnswer];
                                    } else {
                                        if (modelOp.is_right) {
                                            examAnswer = [NSString stringWithFormat:@"%@%@",examAnswer,modelOp.key];
                                        }
                                    }
                                }
                                pass.examAnswer = examAnswer;
                            }
                        }
                    }
                    
                    if (SWNOTEmptyArr(passArray)) {
                        [_examDetailArray addObject:passArray[0]];
                        [self makeUIByExamDetailModel:passArray[0]];
                        [self makeBottomView:passArray[0]];
                    }
                }
            }
            [self hideHud];
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        } enError:^(NSError * _Nonnull error) {
            [self hideHud];
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        }];
    }
}

// MARK: - 通过获取到的试题详情 加载页面数据
- (void)makeUIByExamDetailModel:(id)examModel {
    if (examModel) {
        if (!_headerView) {
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
            _headerView.backgroundColor = EdlineV5_Color.backColor;
        }
        if (!_footerView) {
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
            _footerView.backgroundColor = EdlineV5_Color.backColor;
        }
        [_headerView removeAllSubviews];
        [_footerView removeAllSubviews];
        
        ExamDetailModel *model = (ExamDetailModel *)examModel;
        
        if (model.is_answer && [model.question_type isEqualToString:@"6"]) {
            UIView *footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
            footerLine.backgroundColor = EdlineV5_Color.backColor;
            [_footerView addSubview:footerLine];
            UILabel *examPointTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, MainScreenWidth - 30, 20)];
            examPointTitle.numberOfLines = 0;
            examPointTitle.textColor = EdlineV5_Color.textFirstColor;
            examPointTitle.font = SYSTEMFONT(14);
            examPointTitle.text = @"考点：";
            NSString *pointS = @"";
            for (int i = 0; i<model.points.count; i++) {
                if (i == 0) {
                    pointS = [NSString stringWithFormat:@"%@",model.points[i]];
                } else {
                    pointS = [NSString stringWithFormat:@"%@、%@",pointS,model.points[i]];
                }
            }
            examPointTitle.text = [NSString stringWithFormat:@"考点：%@",pointS];
            [examPointTitle sizeToFit];
            [examPointTitle setHeight:examPointTitle.height];
            [_footerView addSubview:examPointTitle];
            [_footerView setHeight:examPointTitle.bottom + 20];
        }
        _tableView.tableFooterView = _footerView;
        
        // 是否收藏
        _examCollectBtn.selected = model.collected;
        
        if ([model.question_type isEqualToString:@"7"]) {
            // 当前试题只有一道题 就不需要这个tableheader 设置高度0.01 不能设置成0 不然会自动适配一个35高度的空白 并设置 tableview 的 header
            _tableView.tableHeaderView = _headerView;
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                
                UIImageView *examTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 16)];
                examTypeImageView.image = [Image(@"cailiao_icon") converToMainColor];
                [_headerView addSubview:examTypeImageView];
                
                // 有多道小试题 这里就需要设置 整个 tableview 的 头部
                
                NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
                
                if (model.titleMutable) {
                    NSString *pass = [NSString stringWithFormat:@"%@",[mutable attributedSubstringFromRange:NSMakeRange(mutable.length - 1, 1)]];
                    if ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
                        [mutable replaceCharactersInRange:NSMakeRange(mutable.length - 1, 1) withString:@""];
                    }
                }
                [mutable addAttributes:@{NSFontAttributeName:SYSTEMFONT(15)} range:NSMakeRange(0, model.titleMutable.length)];
                
                UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(11, examTypeImageView.bottom + 10, MainScreenWidth - 22, 100)];
                lable1111.backgroundColor = EdlineV5_Color.backColor;

                lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutable];
                [lable1111 sizeToFit];
                lable1111.showsVerticalScrollIndicator = NO;
                lable1111.showsHorizontalScrollIndicator = NO;
                lable1111.editable = NO;
                lable1111.scrollEnabled = NO;
                [lable1111 setHeight:lable1111.height];
                [_headerView addSubview:lable1111];
                [_headerView setHeight:lable1111.bottom];
                _tableView.tableHeaderView = _headerView;
                
            } else {
                // 当前试题只有一道题 就不需要这个tableheader 设置高度0.01 不能设置成0 不然会自动适配一个35高度的空白 并设置 tableview 的 header
                _tableView.tableHeaderView = _headerView;
            }
        }
        [_tableView reloadData];
    }
}

- (void)bottomButtonClick:(UIButton *)sender {
    if (sender == _nextExamBtn) {
        _rightOrErrorIcon.hidden = YES;
        _previousExamBtn.enabled = NO;
        _nextExamBtn.enabled = NO;
        // 这里需要判断是否能够直接进入下一题还是需要展开解析
        // 如果当前题答错了 并且是第一次答这道题 那么就显示 底部区域 并且 将这个道题上传 model.is_expend 设置成 yes
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if (!model.is_answer) {
            // 这个地方需要判断是不是填空题 填空题需要请求接口 让接口去判断 其他类型自己判断
            if ([model.question_type isEqualToString:@"5"]) {
                // 请求接口 并根据接口返回的判断结果 修改 model 的 is_answer 并且在请求接口完成后 释放 上一题 下一题的 enable 属性
                [self requestExamJudgeIsRight:model];
                return;
            }
            if (![self judgeCurrentExamIsRight]) {
                // 提交答案 并且 展开解析
                // 这时候要把已作答的题目和对应的作答内容组装起来 便于后面赋值
                model.is_right = NO;
                model.is_answer = YES;
                model.is_expand = YES;
                [_tableView reloadData];
                _previousExamBtn.enabled = YES;
                _nextExamBtn.enabled = YES;
                [self putExamResult:model.examDetailId examLevel:model.topic_level isRight:NO];
                _rightOrErrorIcon.hidden = NO;
                _rightOrErrorIcon.image = Image(@"exam_fault_icon");
                if (!_isOrderTest) {
                    _nextExamBtn.hidden = YES;
                } else {
                    if (!SWNOTEmptyStr(model.next_topic_id)) {
                        _nextExamBtn.hidden = YES;
                    }
                }
                return;
            } else {
                // 回答正确了 也需要在这里设置已作答
                model.is_answer = YES;
                model.is_expand = YES;
                model.is_right = YES;
                [self putExamResult:model.examDetailId examLevel:model.topic_level isRight:YES];
                if (!_isOrderTest || !SWNOTEmptyStr(model.next_topic_id)) {
                    _nextExamBtn.hidden = YES;
                    [_tableView reloadData];
                    _previousExamBtn.enabled = YES;
                    _nextExamBtn.enabled = YES;
                    _rightOrErrorIcon.hidden = NO;
                    _rightOrErrorIcon.image = Image(@"exam_correct_icon");
                    return;
                }
            }
        } else {
            if ([_examType isEqualToString:@"collect"]) {
                _rightOrErrorIcon.hidden = YES;
            } else {
//                _rightOrErrorIcon.hidden = NO;
//                _rightOrErrorIcon.image = model.is_right ? Image(@"exam_correct_icon") : Image(@"exam_fault_icon");
            }
        }
        
        if (!SWNOTEmptyStr(model.next_topic_id)) {
            _rightOrErrorIcon.hidden = NO;
            _rightOrErrorIcon.image = model.is_right ? Image(@"exam_correct_icon") : Image(@"exam_fault_icon");
            _nextExamBtn.hidden = YES;
        }
        
        
        if (_isOrderTest && SWNOTEmptyStr(model.next_topic_id)) {
            [self getExamDetailForExamIds:model.next_topic_id];
            _previousExamBtn.enabled = YES;
             _nextExamBtn.enabled = YES;
        }
    } else if (sender == _previousExamBtn) {
    } else if (sender == _examSheetBtn) {
    } else if (sender == _examCollectBtn) {
        // 收藏
        _examCollectBtn.enabled = NO;
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        [self collectionCurrentExamBy:model];
    }
}

- (void)expandButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            model.is_expand = sender.selected;
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                ExamDetailModel *modelpass = model.topics[sender.tag];
                modelpass.is_expand = sender.selected;
            } else {
                model.is_expand = sender.selected;
            }
        }
    }
    [_tableView reloadData];
}

// MARK: - 将标签转为富文本并且过滤换行符
- (NSMutableAttributedString *)changeStringToMutA:(NSString *)commonString {
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[commonString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    if (SWNOTEmptyStr(commonString)) {
        NSString *pass = [NSString stringWithFormat:@"%@",[attrString attributedSubstringFromRange:NSMakeRange(attrString.length - 1, 1)]];
        if ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
            [attrString replaceCharactersInRange:NSMakeRange(attrString.length - 1, 1) withString:@""];
        }
    }
    return attrString;
}

// MARK: - 自己组装材料题编号进去
- (NSMutableAttributedString *)changeCailiaoStringToMutA:(NSString *)commonString indexString:(NSString *)indexString {
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[commonString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    if (SWNOTEmptyStr(commonString)) {
        NSString *pass = [NSString stringWithFormat:@"%@",[attrString attributedSubstringFromRange:NSMakeRange(attrString.length - 1, 1)]];
        if ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
            [attrString replaceCharactersInRange:NSMakeRange(attrString.length - 1, 1) withString:@""];
        }
        if (commonString.length>indexString.length) {
            NSString *pass111 = [NSString stringWithFormat:@"%@",[attrString attributedSubstringFromRange:NSMakeRange(indexString.length, 1)]];
            if ([[pass111 substringToIndex:1] isEqualToString:@"\n"]) {
                [attrString replaceCharactersInRange:NSMakeRange(indexString.length, 1) withString:@""];
            }
        }
    }
    return attrString;
}

// MARK: - 判断当前题是否作答正确
- (BOOL)judgeCurrentExamIsRight {
    if ([_examType isEqualToString:@"error"] || [_examType isEqualToString:@"collect"]) {
        // 知识点练习和专项练习 没有材料题
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            BOOL is_right = NO;
            for (int i = 0; i<model.topics.count; i++) {
                ExamDetailModel *pass = model.topics[i];
                for (int j = 0; j < pass.options.count; j++) {
                    ExamDetailOptionsModel *op = pass.options[j];
                    if (op.is_selected) {
                        if (op.is_right) {
                            is_right = YES;
                        } else {
                            is_right = NO;
                            return is_right;
                        }
                    }
                }
            }
            return is_right;
        }
        if (SWNOTEmptyArr(model.topics)) {
            return YES;
        } else {
            // 遍历一遍选项 获取当前选中的 再判断当前选中的是不是 is_right
            /* 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题 **/
            BOOL is_right = NO;
            if ([model.question_type isEqualToString:@"1"] || [model.question_type isEqualToString:@"2"]) {
                for (int i = 0; i<model.options.count; i++) {
                    ExamDetailOptionsModel *op = model.options[i];
                    if (op.is_selected && op.is_right) {
                        is_right = YES;
                        break;
                    }
                }
                return is_right;
            } else if ([model.question_type isEqualToString:@"3"] || [model.question_type isEqualToString:@"4"]) {
                is_right = YES;
                for (int i = 0; i<model.options.count; i++) {
                    ExamDetailOptionsModel *op = model.options[i];
                    // 多选  不定项 反其道而行之 遍历所有  1、 正确答案 但是没有选择 判定错误; 2、 错误答案 选择了 判定错误. 有错误 即可返回错误
                    if (op.is_right) {
                        if (!op.is_selected) {
                            return NO;
                        }
                    } else {
                        if (op.is_selected) {
                            return NO;
                        }
                    }
                }
                return is_right;
            } else if ([model.question_type isEqualToString:@"5"]) {
                // 匹配对应题id的对应填空的内容
                return YES;
//                NSMutableDictionary *pass = [NSMutableDictionary new];
//                for (int i = 0; i<_answerManagerArray.count; i++) {
//                    pass = _answerManagerArray[i];
//                    if ([pass.allKeys containsObject:model.examDetailId]) {
//                        NSMutableArray *opLocalAnswer = [NSMutableArray arrayWithArray:[pass objectForKey:model.examDetailId]];
//
//                        if (opLocalAnswer.count != model.options.count) {
//                            return is_right;
//                        } else {
//                            for (int j = 0; j<model.options.count; j++) {
//
//                            }
//                        }
//                    } else {
//                        return is_right;
//                    }
//                }
            }
            return is_right;
        }
    } else {
        return YES;
    }
}

//MARK: - 填空题请求接口判断正确与错误 并且修改 model 的 is_answer 属性为 yes(只针对练习试题的时候)
- (void)requestExamJudgeIsRight:(ExamDetailModel *)model {
    if (model) {
        NSString *getUrl = [Net_Path examPointDetailDataNet];
        NSMutableDictionary *param = [NSMutableDictionary new];
        if ([_examType isEqualToString:@"error"]) {
            getUrl = [Net_Path examPointDetailDataNet];
            [param setObject:model.examDetailId forKey:@"topic_id"];
            [param setObject:model.topic_level forKey:@"topic_level"];
        } else if ([_examType isEqualToString:@"collect"]) {
            getUrl = [Net_Path specialExamDetailDataNet];
            [param setObject:model.examDetailId forKey:@"topic_id"];
            [param setObject:model.topic_level forKey:@"topic_level"];
        }
        [Net_API requestPOSTWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            model.is_answer = YES;
            model.is_right = YES;
            model.is_expand = YES;
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 检测是否已经作答
- (BOOL)judgeIsAnswer {
    if ([_examType isEqualToString:@"1"] || [_examType isEqualToString:@"2"]) {
        // 先判断是否作答 然后再处理保存
        
    }
    return NO;
}

// MARK: - 检测获取当前试题详情数组里面有没有当前试题
- (ExamDetailModel *)checkExamDetailArray:(NSString *)examId {
    if (SWNOTEmptyStr(examId)) {
        BOOL has = NO;
        for (int i = 0; i<_examDetailArray.count; i++) {
            if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:examId]) {
                has = YES;
                return ((ExamDetailModel *)(_examDetailArray[i]));
                break;
            }
        }
        return nil;
    } else {
        return nil;
    }
}

// MARK: - 收藏和取消收藏当前试题
- (void)collectionCurrentExamBy:(ExamDetailModel *)model {
    if (model) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:model.examDetailId forKey:@"topic_id"];
        [param setObject:model.collected ? @"0" : @"1" forKey:@"status"];
        [Net_API requestPOSTWithURLStr:[Net_Path examCollectionNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCollectionList" object:nil];
                    // 改变按钮状态 并且改变数据源
                    _examCollectBtn.selected = !model.collected;
                    model.collected = !model.collected;
                    for (int i = 0; i<_examDetailArray.count; i++) {
                        if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:model.examDetailId]) {
                            [_examDetailArray replaceObjectAtIndex:i withObject:model];
                            break;
                        }
                    }
                }
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
            }
            _examCollectBtn.enabled = YES;
        } enError:^(NSError * _Nonnull error) {
            _examCollectBtn.enabled = YES;
        }];
    } else {
        _examCollectBtn.enabled = YES;
    }
}

// MARK: - 输入框通知(textfield)
- (void)userTextFieldChange:(NSNotification *)notice {
    UITextField *textF = (UITextField *)notice.object;
    ExamAnswerCell *cell = (ExamAnswerCell *)textF.superview.superview;
    
    ((ExamDetailOptionsModel *)cell.cellDetailModel.options[cell.cellIndexPath.row]).userAnswerValue = textF.text;
    
    for (int i = 0; i<_examDetailArray.count; i++) {
        if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.cellDetailModel.examDetailId]) {
            [_examDetailArray replaceObjectAtIndex:i withObject:cell.cellDetailModel];
            break;
        }
    }
}

// MARK: - 输入框通知(textView)
- (void)userTextViewChange:(NSNotification *)notice {
    UITextView *textF = (UITextView *)notice.object;
    ExamAnswerCell *cell = (ExamAnswerCell *)textF.superview.superview;
    
    ((ExamDetailOptionsModel *)cell.cellDetailModel.options[cell.cellIndexPath.row]).userAnswerValue = textF.text;
    
    for (int i = 0; i<_examDetailArray.count; i++) {
        if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.cellDetailModel.examDetailId]) {
            [_examDetailArray replaceObjectAtIndex:i withObject:cell.cellDetailModel];
            break;
        }
    }
}

// MARK: - 做试题-提交答案
- (void)putExamResult:(NSString *)topic_id examLevel:(NSString *)level isRight:(BOOL)isRight {
    NSString *getUrl = [Net_Path examPointPostAnswerNet];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([_examType isEqualToString:@"1"]) {
        getUrl = [Net_Path examPointPostAnswerNet];
    } else if ([_examType isEqualToString:@"2"]) {
        getUrl = [Net_Path specialExamPostAnswerNet];
    }
    [param setObject:topic_id forKey:@"topic_id"];
    [param setObject:level forKey:@"topic_level"];
    [param setObject:isRight ? @"1" : @"0" forKey:@"is_right"];
    [Net_API requestPOSTWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        NSLog(@"第%@题 答案提交 = %@",topic_id,responseObject[@"msg"]);
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

// MARK: - 返回的时候直接刷新收藏列表数据
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCollectionList" object:nil];
    }
}

@end
