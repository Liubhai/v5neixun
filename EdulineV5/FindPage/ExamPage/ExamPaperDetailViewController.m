//
//  ExamPaperDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/15.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamPaperDetailViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamIDListModel.h"

#import "ExamAnswerCell.h"

#import "AnswerSheetViewController.h"
#import "ExamCalculateHeight.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "FaceVerifyViewController.h"

@interface ExamPaperDetailViewController ()<UITableViewDelegate, UITableViewDataSource, ExamAnswerCellDelegate> {
    NSInteger examCount;//整套试卷的总题数
    NSInteger currentExamRow;// 当前答题是第几道题
    NSIndexPath *currentExamIndexPath;// 当前答题在整个列表中的下标
    NSString *currentExamId;//当前答题的试题ID
    BOOL canEnterNextExam;// 点击下一题的时候是 答对 答错 能否直接进入下一题 还是需要显示解析
    NSTimer *paperTimer;// 试卷作答时候的计时器(倒计时或者正序即时)
    NSInteger remainTime;
    NSInteger popAlertCount;// 公开考试弹框次数
    BOOL canTouchPaper;// 人脸验证取消后能否操作试卷作答
}

//  用一个专门数组去存储请求到的题的详情 上一题的时候就直接取出来去加载数据; 填充数据的时候 直接用 ExamDetailModel 去填充答案或者填空框内的内容

@property (strong, nonatomic) UIImageView *rightOrErrorIcon;// 正确错误 图标

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *examIdListArray;// 获取得到题干ID数组
@property (strong, nonatomic) NSMutableArray *examDetailArray;// 通过题干ID获取到具体试题内容数组

@property (strong, nonatomic) NSMutableDictionary *examCellHeightDict;
@property (strong, nonatomic) NSMutableArray *examCellHeightModelArray;// 每道试题的答案高度值 model 数组

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *previousExamBtn;
@property (strong, nonatomic) UIButton *nextExamBtn;

@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) UIButton *examSheetBtn;
@property (strong, nonatomic) UIButton *examCollectBtn;

@property (strong, nonatomic) NSMutableArray *answerManagerArray;// 选择的答案对应的数组 一维数组 遍历一次(添加 修改)

@property (strong, nonatomic) ExamPaperDetailModel *currentExamPaperDetailModel;

@property (strong, nonatomic) AVPlayer *voicePlayer;
@property (strong, nonatomic) UIButton *currentVoiceButton;



@end

@implementation ExamPaperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _titleLabel.text = @"00:32:22";
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = SYSTEMFONT(16);
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.layarLineColor;
    
    canEnterNextExam = NO;
    
    // 人脸
    canTouchPaper = YES;
    
    _answerManagerArray = [NSMutableArray new];
    
    _examIdListArray = [NSMutableArray new];
    _examDetailArray = [NSMutableArray new];
    
    _examCellHeightModelArray = [NSMutableArray new];
    _examCellHeightDict = [NSMutableDictionary new];
    
    [self makeTopView];
    [self makeHeaderView];
    [self makeTableView];
    
    _rightOrErrorIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 74 - 4, MACRO_UI_UPHEIGHT + 8, 74, 74)];
    _rightOrErrorIcon.image = Image(@"exam_fault_icon");
    [self.view addSubview:_rightOrErrorIcon];
    _rightOrErrorIcon.hidden = YES;
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paperTimerStopOrStart:) name:@"pauseAndResumeExamTime" object:nil];
}

- (void)makeTopView {
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 50, 0, 50, 28)];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 3;//_submitBtn.height / 2.0;
    _submitBtn.centerY = _titleLabel.centerY;
    _submitBtn.backgroundColor = EdlineV5_Color.themeColor;
    [_submitBtn setTitle:@"交卷" forState:0];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    _submitBtn.titleLabel.font = SYSTEMFONT(15);
    [_submitBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_submitBtn];
    
    _examSheetBtn = [[UIButton alloc] initWithFrame:CGRectMake(_submitBtn.left - 25 - 20, 0, 20, 20)];
    [_examSheetBtn setImage:Image(@"exam_sheet_icon") forState:0];
    _examSheetBtn.centerY = _titleLabel.centerY;
    [_examSheetBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_examSheetBtn];
    
    _examCollectBtn = [[UIButton alloc] initWithFrame:CGRectMake(_examSheetBtn.left - 25 - 20, 0, 20, 20)];
    [_examCollectBtn setImage:Image(@"star_nor") forState:0];
    [_examCollectBtn setImage:Image(@"star_pre") forState:UIControlStateSelected];
    _examCollectBtn.centerY = _titleLabel.centerY;
    [_examCollectBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_examCollectBtn];
    _examCollectBtn.hidden = YES;
    if ([_examType isEqualToString:@"4"]) {
        _examCollectBtn.hidden = NO;
    }
}

- (void)makeBottomView {
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,1);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 3;
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
    [_nextExamBtn setTitle:@"下一题" forState:0];
    [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
    [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    _nextExamBtn.titleLabel.font = SYSTEMFONT(16);
    [_nextExamBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (examCount == 1) {
        
    } else {
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
    }
    [_bottomView addSubview:_nextExamBtn];
    
    _nextExamBtn.hidden = NO;
    _previousExamBtn.hidden = YES;
    [_nextExamBtn setCenterX:MainScreenWidth / 2.0];
    
    _previousExamBtn.enabled = NO;
    _nextExamBtn.enabled = NO;
    if (examCount == 1) {
        [_nextExamBtn setTitle:@"提交" forState:0];
        _nextExamBtn.hidden = YES;
        [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
        [_nextExamBtn setImage:nil forState:0];
    }
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    _headerView.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
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
            return model.topics.count;// 材料题
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
    cell.examModuleType = YES;
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
    back.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
    
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        ExamDetailModel *modelXXX;
        modelXXX = model;
        UIImageView *examCountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 14, 16)];
        examCountIcon.image = Image(@"marker_icon");
        [back addSubview:examCountIcon];
        
        UILabel *examCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(examCountIcon.right + 10, 0, 15+28, 20)];
        examCountLabel.font = SYSTEMFONT(13);
        examCountLabel.textColor = EdlineV5_Color.textThirdColor;
        NSString *cur = [NSString stringWithFormat:@"%@",@(currentExamRow)];
        NSMutableAttributedString *fullExamCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",@(currentExamRow),@(examCount)]];
        [fullExamCount addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.themeColor} range:NSMakeRange(0, cur.length)];
        examCountLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:fullExamCount];
        CGFloat countLabelWidth = [[NSString stringWithFormat:@"%@/%@",@(currentExamRow),@(examCount)] sizeWithFont:examCountLabel.font].width + 15;
        [examCountLabel setWidth:countLabelWidth];
        [back addSubview:examCountLabel];
        
        UIImageView *examTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(examCountLabel.right, 2, 32, 16)];
        // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答
        if (![model.question_type isEqualToString:@"7"] && SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *cailiaoModel = model.topics[section];
            modelXXX = cailiaoModel;
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
        
        UILabel *examScore = [[UILabel alloc] initWithFrame:CGRectMake(examTypeImageView.right, 0, 100, 20)];
        examScore.font = SYSTEMFONT(15);
        examScore.textColor = EdlineV5_Color.textFirstColor;
        if (![model.question_type isEqualToString:@"7"] && SWNOTEmptyArr(model.topics)) {
            ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)_examIdListArray[currentExamIndexPath.section];
            NSArray *passArray = [NSArray arrayWithArray:passDict.child];
            if (SWNOTEmptyArr(passArray)) {
                ExamIDModel *passfinalDict = (ExamIDModel *)passArray[currentExamIndexPath.row];
                NSArray *inExamIdModelArray = [NSArray arrayWithArray:passfinalDict.sub_topics];
                if (SWNOTEmptyArr(inExamIdModelArray)) {
                    ExamIDModel *passfinal = (ExamIDModel *)inExamIdModelArray[section];
                    examScore.text = [NSString stringWithFormat:@"（%@分）",passfinal.score];
                }
            }
        } else {
            ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)_examIdListArray[currentExamIndexPath.section];
            NSArray *passArray = [NSArray arrayWithArray:passDict.child];
            if (SWNOTEmptyArr(passArray)) {
                ExamIDModel *passfinalDict = (ExamIDModel *)passArray[currentExamIndexPath.row];
                examScore.text = [NSString stringWithFormat:@"（%@分）",passfinalDict.score];
            }
        }
        examScore.hidden = YES;
        [back addSubview:examScore];
        
        if ([_examType isEqualToString:@"3"] || [_examType isEqualToString:@"4"]) {
            examScore.hidden = NO;
        }
        
        UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(11, 20, MainScreenWidth - 22, 20)];
        lable1111.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
        NSMutableAttributedString * attrString;
        
        if (![model.question_type isEqualToString:@"7"] && SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[section];
            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:modelpass.titleMutable];
            [examTypeImageView setLeft:15];
//            examTypeImageView.frame = CGRectMake(15, 2, 32, 16);
//            examScore.frame = CGRectMake(examTypeImageView.right, 0, 100, 20);
            [examScore setLeft:examTypeImageView.right];
            examCountIcon.hidden = YES;
            examCountLabel.hidden = YES;
        } else {
            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
            examCountIcon.hidden = NO;
            examCountLabel.hidden = NO;
        }
        
//        if ([model.question_type isEqualToString:@"7"]) {
//            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
//        } else {
//            if (SWNOTEmptyArr(model.topics)) {
//                ExamDetailModel *modelpass = model.topics[section];
//                attrString = [[NSMutableAttributedString alloc] initWithAttributedString:modelpass.titleMutable];
//            } else {
//                attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
//            }
//        }
        
        [attrString addAttributes:@{NSFontAttributeName:SYSTEMFONT(14)} range:NSMakeRange(0, attrString.length)];
        
        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
        [lable1111 sizeToFit];
        lable1111.showsVerticalScrollIndicator = NO;
        lable1111.showsHorizontalScrollIndicator = NO;
        lable1111.editable = NO;
        lable1111.scrollEnabled = NO;
        [lable1111 setHeight:lable1111.height];
        [back setHeight:lable1111.height];
        [back addSubview:lable1111];
        
        // 这个时候如果有音视频  需要处理
        
        UIView *mediaBackView = [[UIView alloc] initWithFrame:CGRectMake(0, lable1111.bottom, MainScreenWidth, 0.01)];
        mediaBackView.tag = 100 + section;
        [back addSubview:mediaBackView];
        NSInteger voiceIndex = 0;
        NSInteger videoIndex = 0;
        for (int i = 0; i<modelXXX.material.count; i++) {
            ExamMediaModel *mediaModel = modelXXX.material[i];
            UIButton *voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(15, (52 + 12) * i, 52, 52)];
            UILabel *mediaTitle = [[UILabel alloc] initWithFrame:CGRectMake(voiceButton.right + 12, 0, 100, 20)];
            mediaTitle.centerY = voiceButton.centerY;
            mediaTitle.font = SYSTEMFONT(14);
            mediaTitle.textColor = EdlineV5_Color.textFirstColor;
            if ([mediaModel.type isEqualToString:@"audio"]) {
                voiceIndex ++;
                [voiceButton setImage:Image(@"audio_play_icon") forState:0];
                [voiceButton setImage:Image(@"audio_pause_icon") forState:UIControlStateSelected];
                mediaTitle.text = [NSString stringWithFormat:@"听力文件%@",@(voiceIndex)];
            } else {
                videoIndex++;
                [voiceButton setImage:Image(@"video_play_icon") forState:0];
                mediaTitle.text = [NSString stringWithFormat:@"视频文件%@",@(videoIndex)];
            }
            voiceButton.tag = 66 + i;
            [voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [mediaBackView addSubview:voiceButton];
            [mediaBackView addSubview:mediaTitle];
            if (i == modelXXX.material.count - 1) {
                [mediaBackView setHeight:voiceButton.bottom];
            }
        }
        [back setHeight:mediaBackView.bottom];
        return back;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(11, 0, MainScreenWidth - 22, 20)];
    NSMutableAttributedString * attrString;
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        ExamDetailModel *modelXXX;
        modelXXX = model;
        if ([model.question_type isEqualToString:@"7"]) {
            attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                ExamDetailModel *modelpass = model.topics[section];
                modelXXX = modelpass;
                attrString = [[NSMutableAttributedString alloc] initWithAttributedString:modelpass.titleMutable];
            } else {
                attrString = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
            }
        }
        [attrString addAttributes:@{NSFontAttributeName:SYSTEMFONT(14)} range:NSMakeRange(0, attrString.length)];
        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
        [lable1111 sizeToFit];
        [lable1111 setHeight:lable1111.height];
        if (SWNOTEmptyArr(modelXXX.material)) {
            return lable1111.height + 20 + 10 + modelXXX.material.count * (52 + 12) - 12;
        }
        return lable1111.height + 20;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([_examType isEqualToString:@"3"] || [_examType isEqualToString:@"4"]) {
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
        back.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
        
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
            rightValueTextView.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
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
            analyzeTextView.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
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
    if ([_examType isEqualToString:@"3"] || [_examType isEqualToString:@"4"]) {
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
            rightValueTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:modelxxx.titleMutable];
            rightValueTextView.font = SYSTEMFONT(15);
            [rightValueTextView sizeToFit];
            [rightValueTextView setHeight:rightValueTextView.height];
            
            UITextView *analyzeTextView = [[UITextView alloc] initWithFrame:CGRectMake(15 + 54, MAX((12 + 20 + 16 + 20), rightValueTextView.bottom), MainScreenWidth - 69 - 15, 20)];
            analyzeTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:SWNOTEmptyStr(modelxxx.examAnswer) ? modelxxx.examAnswer : @""]];
            analyzeTextView.font = SYSTEMFONT(15);
            [analyzeTextView sizeToFit];
            [analyzeTextView setHeight:analyzeTextView.height];
            return MAX((MAX((12 + 20 + 16 + 20), rightValueTextView.bottom) + 7 + 20), analyzeTextView.bottom) + 12;
        } else {
            return 12 + 20 + 12;
        }
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
    if (SWNOTEmptyDictionary(_examCellHeightDict)) {
        if ([_examCellHeightDict.allKeys containsObject:model.examDetailId]) {
            NSMutableArray *pass = [NSMutableArray arrayWithArray:_examCellHeightDict[model.examDetailId]];
            if ([model.question_type isEqualToString:@"1"] || [model.question_type isEqualToString:@"2"] || [model.question_type isEqualToString:@"3"] || [model.question_type isEqualToString:@"4"] || [model.question_type isEqualToString:@"5"] || [model.question_type isEqualToString:@"7"] || [model.question_type isEqualToString:@"8"]) {
                ExamCalculateHeight *cellHeight = pass[indexPath.row];
                return cellHeight.cellHeight;
            } else if ([model.question_type isEqualToString:@"6"]) {
                NSMutableArray *pass1 = pass[indexPath.section];
                ExamCalculateHeight *cellHeight = pass1[indexPath.row];
                return cellHeight.cellHeight;
            }
        }
    }
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

// MARK: - cell代理方法合集(ExamAnswerCellDelegate)
- (void)gapfillingChooseStatusChanged:(ExamAnswerCell *)answerCell button:(nonnull UIButton *)sender {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
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

- (void)textFieldBegain:(UITextField *)textField {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [textField resignFirstResponder];
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
}

- (void)textViewBegain:(UITextView *)textView {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [textView resignFirstResponder];
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        if ([model.question_type isEqualToString:@"7"]) {
            // 完形填空
        } else {
            if (SWNOTEmptyArr(model.topics)) {
                // 小题有多个 材料题
                ExamDetailModel *modelpass = model.topics[indexPath.section];
//                if (modelpass.is_answer) {
//                    return;
//                }
//
//                if (model.is_answer) {
//                    return;
//                }
                
                // 只有一个小题
                // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题
                if ([modelpass.question_type isEqualToString:@"1"] || [modelpass.question_type isEqualToString:@"2"]) {
                    for (int i = 0; i<modelpass.options.count; i ++) {
                        ExamDetailOptionsModel *op = (ExamDetailOptionsModel *)(modelpass.options[i]);
                        ExamAnswerCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                        if (i == indexPath.row) {
                            op.is_selected = YES;
                        } else {
                            op.is_selected = NO;
                        }
                        cell.selectButton.selected = op.is_selected;
                    }
//                    [_tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
//                    [_tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
//                    [_tableView reloadData];
                } else if ([modelpass.question_type isEqualToString:@"3"] || [modelpass.question_type isEqualToString:@"4"]) {
                    for (int i = 0; i<modelpass.options.count; i ++) {
                        ExamDetailOptionsModel *op = (ExamDetailOptionsModel *)(modelpass.options[i]);
                        ExamAnswerCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                        if (i == indexPath.row) {
                            op.is_selected = !op.is_selected;
                        }
                        cell.mutSelectButton.selected = op.is_selected;
                    }
//                    [_tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
//                    [_tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
//                    [_tableView reloadData];
                }
            } else {
//                if (model.is_answer) {
//                    return;
//                }
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

- (void)getData {
    if (SWNOTEmptyStr(_examIds)) {
        NSString *getUrl = [Net_Path examPointIdListNet];
        NSMutableDictionary *param = [NSMutableDictionary new];
        if ([_examType isEqualToString:@"1"]) {
            getUrl = [Net_Path examPointIdListNet];
            [param setObject:_examIds forKey:@"point_ids"];
            [param setObject:_examModuleId forKey:@"module_id"];
        } else if ([_examType isEqualToString:@"2"]) {
            getUrl = [Net_Path specialExamIdListNet];
            [param setObject:_examIds forKey:@"special_id"];
        } else if ([_examType isEqualToString:@"3"]) {
            getUrl = [Net_Path openingExamIdListNet];
            [param setObject:_examIds forKey:@"paper_id"];
        } else if ([_examType isEqualToString:@"4"]) {
            getUrl = [Net_Path volumePaperIdListNet];
            [param setObject:_examIds forKey:@"paper_id"];
            [param setObject:_rollup_id forKey:@"rollup_id"];
        }
        [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    
                    // 考试试卷
                    _currentExamPaperDetailModel = [ExamPaperDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                    if ([_currentExamPaperDetailModel.total_time isEqualToString:@"0"]) {
                        // 正序计时
                        remainTime = 0;
                        paperTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
                    } else {
                        remainTime = [_currentExamPaperDetailModel.total_time integerValue] * 60;
                        paperTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
                    }
                    if ([_examType isEqualToString:@"3"]) {
                        popAlertCount = _currentExamPaperDetailModel.face_data.need_verify_number;
                    }
                    
                    examCount = [[NSString stringWithFormat:@"%@",responseObject[@"data"][@"total_count"]] integerValue];
                    [self makeBottomView];
                    currentExamRow = 0;
                    [_examIdListArray removeAllObjects];
                    NSArray *pass = [NSArray arrayWithArray:[ExamPaperIDListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"parts"]]];
                    
                    for (int i = 0; i<pass.count; i++) {
                        ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)pass[i];
                        if (SWNOTEmptyArr(passDict.child)) {
                            [_examIdListArray addObject:passDict];
                        }
                    }
                    if (SWNOTEmptyArr(_examIdListArray)) {
                        ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)_examIdListArray[0];
                        NSArray *passArray = [NSArray arrayWithArray:passDict.child];
                        if (SWNOTEmptyArr(passArray)) {
                            ExamIDModel *passfinalDict = (ExamIDModel *)passArray[0];
                            currentExamIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            currentExamId = [NSString stringWithFormat:@"%@",passfinalDict.topic_id];
                            currentExamRow = 1;
                            [self getExamDetailForExamIds:passfinalDict.topic_id];
                        }
                    }
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)getExamDetailForExamIds:(NSString *)examIds {
    [self resetVoicePlayer];
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
        NSString *getUrl = [Net_Path examPointDetailDataNet];
        NSMutableDictionary *param = [NSMutableDictionary new];
        if ([_examType isEqualToString:@"1"]) {
            getUrl = [Net_Path examPointDetailDataNet];
            [param setObject:examIds forKey:@"topic_id"];
        } else if ([_examType isEqualToString:@"2"]) {
            getUrl = [Net_Path specialExamDetailDataNet];
            [param setObject:examIds forKey:@"topic_id"];
        } else if ([_examType isEqualToString:@"3"]) {
            getUrl = [Net_Path openingExamDetailNet];
            [param setObject:examIds forKey:@"topic_id"];
            [param setObject:_examIds forKey:@"paper_id"];
        } else if ([_examType isEqualToString:@"4"]) {
            getUrl = [Net_Path volumePaperTestDetailNet];
            [param setObject:examIds forKey:@"topic_id"];
            [param setObject:_examIds forKey:@"paper_id"];
        }
        ShowHud(@"试题信息拉取中...");
        [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    if (paperTimer) {
                        [paperTimer setFireDate:[NSDate distantFuture]];
                    }
                    NSMutableArray *passArray = [NSMutableArray arrayWithArray:[ExamDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                    dispatch_group_t group = dispatch_group_create();//group计数=0
                    for (int i = 0; i<passArray.count; i++) {
                        dispatch_group_enter(group);//group计数+1
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            ExamDetailModel *pass = passArray[i];
                            pass.titleMutable = [self changeStringToMutA:pass.title];
                            pass.analyzeMutable = [self changeStringToMutA:pass.analyze];
                            if (SWNOTEmptyArr(pass.topics)) {
                                for (int j = 0; j<pass.topics.count; j++) {
                                    ExamDetailModel *detail = pass.topics[j];
                                    detail.titleMutable = [self changeCailiaoStringToMutA:[NSString stringWithFormat:@"(%@）%@",@(j + 1),detail.title] indexString:[NSString stringWithFormat:@"(%@）",@(j + 1)]];
                                    detail.analyzeMutable = [self changeStringToMutA:detail.analyze];
                                    if ([detail.question_type isEqualToString:@"8"]) {
                                        ExamDetailOptionsModel *op = [ExamDetailOptionsModel new];
                                        detail.options = [NSArray arrayWithObjects:op, nil];
                                    } else {
                                        for (int k = 0; k<detail.options.count; k++) {
                                            ExamDetailOptionsModel *modelOp = detail.options[k];
                                            modelOp.mutvalue = [self changeStringToMutA:modelOp.value];
                                        }
                                    }
                                }
                            } else {
                                if ([pass.question_type isEqualToString:@"8"]) {
                                    ExamDetailOptionsModel *op = [ExamDetailOptionsModel new];
                                    pass.options = [NSArray arrayWithObjects:op, nil];
                                } else {
                                    for (int j = 0; j<pass.options.count; j++) {
                                        ExamDetailOptionsModel *modelOp = pass.options[j];
                                        modelOp.mutvalue = [self changeStringToMutA:modelOp.value];
                                    }
                                }
                            }
                            dispatch_group_leave(group);//group计数-1
                        });
                    }
                    
                    //监听group计数，=0时执行block
                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        if (SWNOTEmptyArr(passArray)) {
                            [_examDetailArray addObject:passArray[0]];
                            [self calculateAnswerCellHeight:passArray[0]];
                            [self makeUIByExamDetailModel:passArray[0]];
                        }
                        if (paperTimer) {
                            [paperTimer setFireDate:[NSDate date]];
                        }
                        [self hideHud];
                        _previousExamBtn.enabled = YES;
                        _nextExamBtn.enabled = YES;
                    });
                }
            }
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
            _headerView.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;
        }
        [_headerView removeAllSubviews];
        
        UILabel *examThemeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth-15 - 14 - 53, 53)];
        examThemeLabel.font = SYSTEMFONT(16);
        examThemeLabel.textColor = EdlineV5_Color.textFirstColor;
        examThemeLabel.text = @"知识点练习";
        if (_currentExamPaperDetailModel) {
            examThemeLabel.text = _currentExamPaperDetailModel.title;
        }
        [_headerView addSubview:examThemeLabel];
        
        ExamDetailModel *model = (ExamDetailModel *)examModel;
        
        // 是否收藏
        _examCollectBtn.selected = model.collected;
        
        if ([model.question_type isEqualToString:@"7"]) {
            // 当前试题只有一道题 就不需要这个tableheader 设置高度0.01 不能设置成0 不然会自动适配一个35高度的空白 并设置 tableview 的 header
            [_headerView setHeight:examThemeLabel.bottom];
            _tableView.tableHeaderView = _headerView;
        } else {
            if (SWNOTEmptyArr(model.topics)) {

                UIImageView *examCountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, examThemeLabel.bottom + 2, 14, 16)];
                examCountIcon.image = Image(@"marker_icon");
                [_headerView addSubview:examCountIcon];
                
                UILabel *examCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(examCountIcon.right + 10, examThemeLabel.bottom, 15+28, 20)];
                examCountLabel.font = SYSTEMFONT(13);
                examCountLabel.textColor = EdlineV5_Color.textThirdColor;
                NSString *cur = [NSString stringWithFormat:@"%@",@(currentExamRow)];
                NSMutableAttributedString *fullExamCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",@(currentExamRow),@(examCount)]];
                [fullExamCount addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.themeColor} range:NSMakeRange(0, cur.length)];
                examCountLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:fullExamCount];
                CGFloat countLabelWidth = [[NSString stringWithFormat:@"%@/%@",@(currentExamRow),@(examCount)] sizeWithFont:examCountLabel.font].width + 15;
                [examCountLabel setWidth:countLabelWidth];
                [_headerView addSubview:examCountLabel];
                
                UIImageView *examTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(examCountLabel.right, examThemeLabel.bottom + 2, 32, 16)];
                examTypeImageView.image = [Image(@"cailiao_icon") converToMainColor];
                [_headerView addSubview:examTypeImageView];
                
                if ([_examType isEqualToString:@"3"] || [_examType isEqualToString:@"4"]) {
                    UILabel *examScore = [[UILabel alloc] initWithFrame:CGRectMake(examTypeImageView.right, examThemeLabel.bottom, 100, 20)];
                    examScore.font = SYSTEMFONT(15);
                    examScore.textColor = EdlineV5_Color.textFirstColor;
                    
                    ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)_examIdListArray[currentExamIndexPath.section];
                    NSArray *passArray = [NSArray arrayWithArray:passDict.child];
                    if (SWNOTEmptyArr(passArray)) {
                        ExamIDModel *passfinalDict = (ExamIDModel *)passArray[currentExamIndexPath.row];
                        examScore.text = [NSString stringWithFormat:@"（%@分）",passfinalDict.score];
                    }
                    [_headerView addSubview:examScore];
                }
                
                // 有多道小试题 这里就需要设置 整个 tableview 的 头部
                
                NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithAttributedString:model.titleMutable];
                
                if (model.titleMutable) {
                    NSString *pass = [NSString stringWithFormat:@"%@",[mutable attributedSubstringFromRange:NSMakeRange(mutable.length - 1, 1)]];
                    while ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
                        [mutable replaceCharactersInRange:NSMakeRange(mutable.length - 1, 1) withString:@""];
                        pass = [NSString stringWithFormat:@"%@",[mutable attributedSubstringFromRange:NSMakeRange(mutable.length - 1, 1)]];
                    }
                }
                [mutable addAttributes:@{NSFontAttributeName:SYSTEMFONT(15)} range:NSMakeRange(0, mutable.length)];
                
                UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(11, examThemeLabel.bottom + 20, MainScreenWidth - 22, 100)];
                lable1111.backgroundColor = [UIColor whiteColor];//EdlineV5_Color.backColor;

                lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutable];
                [lable1111 sizeToFit];
                lable1111.showsVerticalScrollIndicator = NO;
                lable1111.showsHorizontalScrollIndicator = NO;
                lable1111.editable = NO;
                lable1111.scrollEnabled = NO;
                [lable1111 setHeight:lable1111.height];
                [_headerView addSubview:lable1111];
                
                // 这个时候如果有音视频  需要处理
                
                UIView *mediaBackView = [[UIView alloc] initWithFrame:CGRectMake(0, lable1111.bottom + 10, MainScreenWidth, 0.01)];
                [_headerView addSubview:mediaBackView];
                NSInteger voiceIndex = 0;
                NSInteger videoIndex = 0;
                for (int i = 0; i<model.material.count; i++) {
                    ExamMediaModel *mediaModel = model.material[i];
                    UIButton *voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(15, (52 + 12) * i, 52, 52)];
                    UILabel *mediaTitle = [[UILabel alloc] initWithFrame:CGRectMake(voiceButton.right + 12, 0, 100, 20)];
                    mediaTitle.centerY = voiceButton.centerY;
                    mediaTitle.font = SYSTEMFONT(14);
                    mediaTitle.textColor = EdlineV5_Color.textFirstColor;
                    if ([mediaModel.type isEqualToString:@"audio"]) {
                        voiceIndex ++;
                        [voiceButton setImage:Image(@"audio_play_icon") forState:0];
                        [voiceButton setImage:Image(@"audio_pause_icon") forState:UIControlStateSelected];
                        mediaTitle.text = [NSString stringWithFormat:@"听力文件%@",@(voiceIndex)];
                    } else {
                        videoIndex++;
                        [voiceButton setImage:Image(@"video_play_icon") forState:0];
                        mediaTitle.text = [NSString stringWithFormat:@"视频文件%@",@(videoIndex)];
                    }
                    voiceButton.tag = 66 + i;
                    [voiceButton addTarget:self action:@selector(voiceHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [mediaBackView addSubview:voiceButton];
                    [mediaBackView addSubview:mediaTitle];
                    if (i == model.material.count - 1) {
                        [mediaBackView setHeight:voiceButton.bottom];
                    }
                }
                [_headerView setHeight:mediaBackView.bottom];
                _tableView.tableHeaderView = _headerView;
                
            } else {
                // 当前试题只有一道题 就不需要这个tableheader 设置高度0.01 不能设置成0 不然会自动适配一个35高度的空白 并设置 tableview 的 header
                [_headerView setHeight:examThemeLabel.bottom];
                _tableView.tableHeaderView = _headerView;
            }
        }
        [_tableView reloadData];
    }
}

- (void)bottomButtonClick:(UIButton *)sender {
    if (sender == _nextExamBtn || sender == _previousExamBtn || sender == _examSheetBtn) {
        if (!canTouchPaper) {
            if ([ShowExamUserFace isEqualToString:@"1"]) {
                if (popAlertCount>0) {
                    [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
                }
            }
            return;
        }
    }
    if (sender == _nextExamBtn) {
        [self resetVoicePlayer];
        _previousExamBtn.enabled = NO;
        _nextExamBtn.enabled = NO;
        // 这里需要判断是否能够直接进入下一题还是需要展开解析
        // 如果当前题答错了 并且是第一次答这道题 那么就显示 底部区域 并且 将这个道题上传 model.is_expend 设置成 yes
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        model.is_answer = YES;
        
        // 并且这里需要把 答题卡数组里面的 has_answer 修改值
        if (SWNOTEmptyArr(_examIdListArray)) {
            ExamPaperIDListModel *currentExamIdListModel = _examIdListArray[currentExamIndexPath.section];
            // 这个地方有可能会出现因为题型部分里面没有试题导致崩溃
            if (SWNOTEmptyArr(currentExamIdListModel.child)) {
                ExamIDModel *idModel = currentExamIdListModel.child[currentExamIndexPath.row];
                idModel.has_answered = YES;
            }
        }
        // todo 这里要开始组装答案
        /**
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
                return;
            } else {
                // 回答正确了 也需要在这里设置已作答
                model.is_answer = YES;
                model.is_expand = YES;
                model.is_right = YES;
            }
        }
        */
        if (SWNOTEmptyArr(_examIdListArray)) {
            ExamPaperIDListModel *idListModel = _examIdListArray[currentExamIndexPath.section];
            if (idListModel.child.count > (currentExamIndexPath.row + 1)) {
                currentExamIndexPath = [NSIndexPath indexPathForRow:currentExamIndexPath.row + 1 inSection:currentExamIndexPath.section];
            } else {
                if (_examIdListArray.count > (currentExamIndexPath.section + 1)) {
                    currentExamIndexPath = [NSIndexPath indexPathForRow:0 inSection:currentExamIndexPath.section + 1];
                } else {
                    // 最后一道题点击 其实是只有"上一题"按钮了 这时候就是显示上一题干的最后一个 也不对 这时候这个按钮都被隐藏了
                    // 最后一题了(改变当前底部按钮的样式  只显示"上一题"按钮)
                    // 好像不对  这是倒数第二道题点击时候的逻辑
                    if ([_nextExamBtn.titleLabel.text isEqualToString:@"提交"]) {
                        [self putExamAnswer];
                        return;
                    }
                }
            }
            ExamIDListModel *idListModelPass = _examIdListArray[currentExamIndexPath.section];
            // 这时候判断 并且更改底部按钮状态
            if (currentExamIndexPath.section == (_examIdListArray.count - 1) && currentExamIndexPath.row == (idListModelPass.child.count - 1)) {
                
                _nextExamBtn.hidden = NO;
                [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
                [_nextExamBtn setTitle:@"提交" forState:0];
                _nextExamBtn.hidden = YES;
                [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                [_nextExamBtn setImage:nil forState:0];
                _previousExamBtn.hidden = NO;
                [_previousExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                [_previousExamBtn setImage:[Image(@"exam_last") converToMainColor] forState:0];
                [_previousExamBtn setCenterX:MainScreenWidth / 2.0];
            } else {
                _nextExamBtn.hidden = NO;
                [_nextExamBtn setTitle:@"下一题" forState:0];
                [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
                [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
                _previousExamBtn.hidden = NO;
                [_previousExamBtn setCenterX:MainScreenWidth / 4.0];
                [_previousExamBtn setImage:Image(@"exam_last") forState:0];
                [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
            }
            
//            ExamPaperIDListModel *idListModelPass = _examIdListArray[currentExamIndexPath.section];
//            // 这时候判断 并且更改底部按钮状态
//            if (currentExamIndexPath.section == (_examIdListArray.count - 1) && currentExamIndexPath.row == (idListModelPass.child.count - 1)) {
//                _nextExamBtn.hidden = YES;
//                _previousExamBtn.hidden = NO;
//                [_previousExamBtn setCenterX:MainScreenWidth / 2.0];
//                [_previousExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
//                [_previousExamBtn setImage:[Image(@"exam_last") converToMainColor] forState:0];
//            } else {
//                _nextExamBtn.hidden = NO;
//                [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
//                _previousExamBtn.hidden = NO;
//                [_previousExamBtn setCenterX:MainScreenWidth / 4.0];
//                [_previousExamBtn setImage:Image(@"exam_last") forState:0];
//                [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
//            }
            // 要请求数据了
            if (SWNOTEmptyArr(_examIdListArray)) {
                ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)_examIdListArray[currentExamIndexPath.section];
                NSArray *passArray = [NSArray arrayWithArray:passDict.child];
                if (SWNOTEmptyArr(passArray)) {
                    ExamIDModel *passfinalDict = (ExamIDModel *)passArray[currentExamIndexPath.row];
                    currentExamId = [NSString stringWithFormat:@"%@",passfinalDict.topic_id];
                    currentExamRow = currentExamRow + 1;
                    [self getExamDetailForExamIds:passfinalDict.topic_id];
                } else {
                    _previousExamBtn.enabled = YES;
                    _nextExamBtn.enabled = YES;
                }
            } else {
                _previousExamBtn.enabled = YES;
                _nextExamBtn.enabled = YES;
            }
        } else {
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        }
    } else if (sender == _previousExamBtn) {
        [self resetVoicePlayer];
        _previousExamBtn.enabled = NO;
        _nextExamBtn.enabled = NO;
        if (SWNOTEmptyArr(_examIdListArray)) {
            ExamPaperIDListModel *idListModel = _examIdListArray[currentExamIndexPath.section];
            if (currentExamIndexPath.row>0) {
                currentExamIndexPath = [NSIndexPath indexPathForRow:currentExamIndexPath.row - 1 inSection:currentExamIndexPath.section];
            } else {
                if (currentExamIndexPath.section>0) {
                    ExamPaperIDListModel *preModel = _examIdListArray[currentExamIndexPath.section-1];
                    currentExamIndexPath = [NSIndexPath indexPathForRow:preModel.child.count - 1 inSection:currentExamIndexPath.section-1];
                }
            }
            // 这时候判断 并且更改底部按钮状态
            if (currentExamIndexPath.section == 0 && currentExamIndexPath.row == 0) {
                _nextExamBtn.hidden = NO;
                _previousExamBtn.hidden = YES;
                [_nextExamBtn setCenterX:MainScreenWidth / 2.0];
                [_nextExamBtn setTitle:@"下一题" forState:0];
                [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
                [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
            } else {
                _nextExamBtn.hidden = NO;
                [_nextExamBtn setTitle:@"下一题" forState:0];
                [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
                [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
                _previousExamBtn.hidden = NO;
                [_previousExamBtn setCenterX:MainScreenWidth / 4.0];
                [_previousExamBtn setImage:Image(@"exam_last") forState:0];
                [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
                
            }
//            // 这时候判断 并且更改底部按钮状态
//            if (currentExamIndexPath.section == 0 && currentExamIndexPath.row == 0) {
//                _nextExamBtn.hidden = NO;
//                _previousExamBtn.hidden = YES;
//                [_nextExamBtn setCenterX:MainScreenWidth / 2.0];
//            } else {
//                _nextExamBtn.hidden = NO;
//                [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
//                _previousExamBtn.hidden = NO;
//                [_previousExamBtn setCenterX:MainScreenWidth / 4.0];
//                [_previousExamBtn setImage:Image(@"exam_last") forState:0];
//                [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
//
//            }
            // 要请求数据了
            if (SWNOTEmptyArr(_examIdListArray)) {
                ExamPaperIDListModel *passDict = (ExamPaperIDListModel *)_examIdListArray[currentExamIndexPath.section];
                NSArray *passArray = [NSArray arrayWithArray:passDict.child];
                if (SWNOTEmptyArr(passArray)) {
                    ExamIDModel *passfinalDict = (ExamIDModel *)passArray[currentExamIndexPath.row];
                    currentExamId = [NSString stringWithFormat:@"%@",passfinalDict.topic_id];
                    currentExamRow = currentExamRow - 1;
                    [self getExamDetailForExamIds:passfinalDict.topic_id];
                } else {
                    _previousExamBtn.enabled = YES;
                    _nextExamBtn.enabled = YES;
                }
            } else {
                _previousExamBtn.enabled = YES;
                _nextExamBtn.enabled = YES;
            }
        } else {
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        }
    } else if (sender == _examSheetBtn) {
        [self managerAnswer];
        // 跳转到答题卡页面
        AnswerSheetViewController *vc = [[AnswerSheetViewController alloc] init];
        vc.sheetTitle = _currentExamPaperDetailModel ? _currentExamPaperDetailModel.title : @"";
        vc.remainTime = remainTime;
        vc.orderType = [_currentExamPaperDetailModel.total_time isEqualToString:@"0"] ? YES : NO;
        vc.isPaper = YES;
        vc.examType = _examType;
        vc.rollup_id = _rollup_id;
        vc.currentExamPaperDetailModel = _currentExamPaperDetailModel;
        vc.answerManagerArray = [NSMutableArray arrayWithArray:_answerManagerArray];
        vc.examArray = [NSMutableArray arrayWithArray:_examIdListArray];
        vc.currentIndexpath = currentExamIndexPath;
        vc.courseId = _courseId;
        vc.popAlertCount = popAlertCount;
        vc.chooseOtherExam = ^(NSString * _Nonnull examId) {
            _previousExamBtn.enabled = NO;
            _nextExamBtn.enabled = NO;
            currentExamId = [NSString stringWithFormat:@"%@",examId];
            NSInteger indexCount = 0;
          // 获取当前点击的试题的ID 请求接口 刷新页面  处理下标 当前试题的排序号 并且改变底部按钮的状态
            BOOL is_find = NO;
            for (int i = 0; i < _examIdListArray.count; i ++) {
                if (is_find) {
                    break;
                }
                ExamPaperIDListModel *idListModel = _examIdListArray[i];
                for (int j = 0; j<idListModel.child.count; j++) {
                    indexCount = indexCount + 1;
                    if ([((ExamIDModel *)(idListModel.child[j])).topic_id isEqualToString:examId]) {
                        is_find = YES;
                        currentExamIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                        // 这时候判断 并且更改底部按钮状态
                        if (currentExamIndexPath.section == 0 && currentExamIndexPath.row == 0) {
                            _nextExamBtn.hidden = NO;
                            _previousExamBtn.hidden = YES;
                            [_nextExamBtn setCenterX:MainScreenWidth / 2.0];
                            if (examCount == 1) {
                                [_nextExamBtn setTitle:@"提交" forState:0];
                                _nextExamBtn.hidden = YES;
                                [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                                [_nextExamBtn setImage:nil forState:0];
                            } else {
                                [_nextExamBtn setTitle:@"下一题" forState:0];
                                [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
                                [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                            }
                        } else if (currentExamIndexPath.section == (_examIdListArray.count - 1) && currentExamIndexPath.row == (idListModel.child.count - 1)) {
                            _nextExamBtn.hidden = NO;
                            [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
                            [_nextExamBtn setTitle:@"提交" forState:0];
                            [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                            [_nextExamBtn setImage:nil forState:0];
                            _nextExamBtn.hidden = YES;
                            _previousExamBtn.hidden = NO;
                            [_previousExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                            [_previousExamBtn setImage:[Image(@"exam_last") converToMainColor] forState:0];
                            [_previousExamBtn setCenterX:MainScreenWidth / 2.0];
                        } else {
                            _nextExamBtn.hidden = NO;
                            [_nextExamBtn setTitle:@"下一题" forState:0];
                            [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
                            [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
                            [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
                            _previousExamBtn.hidden = NO;
                            [_previousExamBtn setCenterX:MainScreenWidth / 4.0];
                            [_previousExamBtn setImage:Image(@"exam_last") forState:0];
                            [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
                            
                        }
//                        // 这时候判断 并且更改底部按钮状态
//                        if (currentExamIndexPath.section == 0 && currentExamIndexPath.row == 0) {
//                            _nextExamBtn.hidden = NO;
//                            _previousExamBtn.hidden = YES;
//                            [_nextExamBtn setCenterX:MainScreenWidth / 2.0];
//                        } else if (currentExamIndexPath.section == (_examIdListArray.count - 1) && currentExamIndexPath.row == (idListModel.child.count - 1)) {
//                            _nextExamBtn.hidden = YES;
//                            _previousExamBtn.hidden = NO;
//                            [_previousExamBtn setCenterX:MainScreenWidth / 2.0];
//                            [_previousExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
//                            [_previousExamBtn setImage:[Image(@"exam_last") converToMainColor] forState:0];
//                        } else {
//                            _nextExamBtn.hidden = NO;
//                            [_nextExamBtn setCenterX:MainScreenWidth * 3 / 4.0];
//                            _previousExamBtn.hidden = NO;
//                            [_previousExamBtn setCenterX:MainScreenWidth / 4.0];
//                            [_previousExamBtn setImage:Image(@"exam_last") forState:0];
//                            [_previousExamBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
//
//                        }
                        break;
                    }
                }
            }
            currentExamRow = indexCount;
            
            [self getExamDetailForExamIds:examId];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender == _examCollectBtn) {
        // 收藏
        _examCollectBtn.enabled = NO;
        ExamDetailModel *model = [self checkExamDetailArray:currentExamId];
        [self collectionCurrentExamBy:model];
    } else if (sender == _submitBtn) {
        // 交卷
        [self putExamAnswer];
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
//    [_tableView reloadData];
    [_tableView reloadSection:sender.tag withRowAnimation:UITableViewRowAnimationNone];
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
    if ([_examType isEqualToString:@"1"] || [_examType isEqualToString:@"2"]) {
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
        if ([_examType isEqualToString:@"1"]) {
            getUrl = [Net_Path examPointDetailDataNet];
            [param setObject:model.examDetailId forKey:@"topic_id"];
            [param setObject:model.topic_level forKey:@"topic_level"];
        } else if ([_examType isEqualToString:@"2"]) {
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
                    // 改变按钮状态 并且改变数据源
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCollectionList" object:nil];
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
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
    UITextField *textF = (UITextField *)notice.object;
    ExamAnswerCell *cell = (ExamAnswerCell *)textF.superview.superview;
    if ([cell.examDetailModel.question_type isEqualToString:@"6"]) {
        // 材料 填空题
        // 先赋值 填空小题赋值, 再替换材料的填空小题
        ((ExamDetailOptionsModel *)cell.cellDetailModel.options[cell.cellIndexPath.row]).userAnswerValue = textF.text;
        NSMutableArray *pass = [NSMutableArray arrayWithArray:cell.examDetailModel.topics];
        [pass replaceObjectAtIndex:cell.cellIndexPath.section withObject:(ExamDetailModel *)cell.cellDetailModel];
        cell.examDetailModel.topics = [NSArray arrayWithArray:pass];
        for (int i = 0; i<_examDetailArray.count; i++) {
            if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.examDetailModel.examDetailId]) {
                [_examDetailArray replaceObjectAtIndex:i withObject:cell.examDetailModel];
                break;
            }
        }
    } else {
        // 普通 填空题
        ((ExamDetailOptionsModel *)cell.cellDetailModel.options[cell.cellIndexPath.row]).userAnswerValue = textF.text;
        
        for (int i = 0; i<_examDetailArray.count; i++) {
            if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.cellDetailModel.examDetailId]) {
                [_examDetailArray replaceObjectAtIndex:i withObject:cell.cellDetailModel];
                break;
            }
        }
    }
}

// MARK: - 输入框通知(textView)
- (void)userTextViewChange:(NSNotification *)notice {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
    UITextView *textF = (UITextView *)notice.object;
    ExamAnswerCell *cell = (ExamAnswerCell *)textF.superview.superview;
    if ([cell.examDetailModel.question_type isEqualToString:@"6"]) {
        if (cell.cellDetailModel.options) {
            // 材料 填空题
            // 先赋值 填空小题赋值, 再替换材料的填空小题
            ((ExamDetailOptionsModel *)cell.cellDetailModel.options[cell.cellIndexPath.row]).userAnswerValue = textF.text;
            NSMutableArray *pass = [NSMutableArray arrayWithArray:cell.examDetailModel.topics];
            [pass replaceObjectAtIndex:cell.cellIndexPath.section withObject:(ExamDetailModel *)cell.cellDetailModel];
            cell.examDetailModel.topics = [NSArray arrayWithArray:pass];
            for (int i = 0; i<_examDetailArray.count; i++) {
                if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.examDetailModel.examDetailId]) {
                    [_examDetailArray replaceObjectAtIndex:i withObject:cell.examDetailModel];
                    break;
                }
            }
        } else {
            ExamDetailOptionsModel *opModel = [ExamDetailOptionsModel new];
            opModel.userAnswerValue = textF.text;
            cell.cellDetailModel.options = [NSArray arrayWithObjects:opModel, nil];
            NSMutableArray *pass = [NSMutableArray arrayWithArray:cell.examDetailModel.topics];
            [pass replaceObjectAtIndex:cell.cellIndexPath.section withObject:(ExamDetailModel *)cell.cellDetailModel];
            cell.examDetailModel.topics = [NSArray arrayWithArray:pass];
            for (int i = 0; i<_examDetailArray.count; i++) {
                if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.examDetailModel.examDetailId]) {
                    [_examDetailArray replaceObjectAtIndex:i withObject:cell.examDetailModel];
                    break;
                }
            }
        }
    } else {
        ((ExamDetailOptionsModel *)cell.cellDetailModel.options[cell.cellIndexPath.row]).userAnswerValue = textF.text;
        for (int i = 0; i<_examDetailArray.count; i++) {
            if ([((ExamDetailModel *)(_examDetailArray[i])).examDetailId isEqualToString:cell.cellDetailModel.examDetailId]) {
                [_examDetailArray replaceObjectAtIndex:i withObject:cell.cellDetailModel];
                break;
            }
        }
    }
}

// MARK: - 获取每个cell高度
- (void)calculateAnswerCellHeight:(ExamDetailModel *)model {
    /* 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题 **/
    NSMutableArray *cellHeightArray = [NSMutableArray new];
    if ([model.question_type isEqualToString:@"1"] || [model.question_type isEqualToString:@"2"] || [model.question_type isEqualToString:@"3"] || [model.question_type isEqualToString:@"4"] || [model.question_type isEqualToString:@"5"]) {
        // 取每一个 row
        for (int i = 0; i<model.options.count; i++) {
            ExamCalculateHeight *cellHeightModel = [[ExamCalculateHeight alloc] initWithExamDetailModel:model opitionModel:model.options[i]];
            [cellHeightArray addObject:cellHeightModel];
        }
    } else if ([model.question_type isEqualToString:@"8"]) {
        // 取每一个 row
        ExamCalculateHeight *cellHeightModel = [[ExamCalculateHeight alloc] initWithExamDetailModel:model opitionModel:[ExamDetailOptionsModel new]];
        [cellHeightArray addObject:cellHeightModel];
    } else if ([model.question_type isEqualToString:@"6"]) {
        // 取每一个 section 对应的 row
        for (int i = 0; i<model.topics.count; i++) {
            NSMutableArray *pass = [NSMutableArray new];
            ExamDetailModel *modelpass = model.topics[i];
            if ([modelpass.question_type isEqualToString:@"8"]) {
                ExamCalculateHeight *cellHeightModel = [[ExamCalculateHeight alloc] initWithExamDetailModel:modelpass opitionModel:[ExamDetailOptionsModel new]];
                [pass addObject:cellHeightModel];
            } else {
                for (int j = 0; j<modelpass.options.count; j++) {
                    ExamCalculateHeight *cellHeightModel = [[ExamCalculateHeight alloc] initWithExamDetailModel:modelpass opitionModel:modelpass.options[j]];
                    [pass addObject:cellHeightModel];
                }
            }
            [cellHeightArray addObject:pass];
        }
    } else if ([model.question_type isEqualToString:@"7"]) {
        // 取每一个 row
        for (int i = 0; i<model.topics.count; i++) {
            ExamDetailModel *modelpass = model.topics[i];
            ExamCalculateHeight *cellHeightModel = [[ExamCalculateHeight alloc] initWithGapfillingExamDetailModel:model examDetailModel:modelpass opitionModel:[ExamDetailOptionsModel new]];
            [cellHeightArray addObject:cellHeightModel];
        }
    }
    [_examCellHeightDict setObject:cellHeightArray forKey:[NSString stringWithFormat:@"%@",model.examDetailId]];
}

// MARK: - 交卷
/*
 [{"answer": [{"id": 11}, {"id": 13}, {"id": 12}], "topic_id": 6, "topic_level": 1, "question_type": 4},{"answer": ["填空题1-2", "填空题2",""], "topic_id": 7, "topic_level": 1, "question_type": 5}, {"answer": [{"id": 190}], "topic_id": 126, "topic_level": 1, "question_type": 4}, {"answer": "填空题type5简答题type8答案", "topic_id": 13, "topic_level": 1, "question_type": 8}]
 */
- (void)putExamAnswer {
    [self managerAnswer];
    if (SWNOTEmptyStr(_currentExamPaperDetailModel.paper_id)) {
        NSString *getUrl = [Net_Path submitPaperNet];
        NSMutableDictionary *passDict = [NSMutableDictionary new];
        [passDict setObject:_currentExamPaperDetailModel.paper_id forKey:@"paper_id"];
        [passDict setObject:_currentExamPaperDetailModel.unique_code forKey:@"unique_code"];
        [passDict setObject:[NSArray arrayWithArray:_answerManagerArray] forKey:@"answer_data"];
        if ([_currentExamPaperDetailModel.total_time isEqualToString:@"0"]) {
            [passDict setObject:@(remainTime) forKey:@"time_takes"];
        } else {
            [passDict setObject:@([_currentExamPaperDetailModel.total_time integerValue] * 60 - remainTime) forKey:@"time_takes"];
        }
        
        if ([_examType isEqualToString:@"4"]) {
            [passDict setObject:_rollup_id forKey:@"rollup_id"];
            getUrl = [Net_Path volumePaperSubmitAnswerNet];
        }
        
        if (SWNOTEmptyStr(_courseId)) {
            [passDict setObject:_courseId forKey:@"course_id"];
        }
        
        [Net_API requestPOSTWithURLStr:getUrl WithAuthorization:nil paramDic:passDict finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        } enError:^(NSError * _Nonnull error) {
            _previousExamBtn.enabled = YES;
            _nextExamBtn.enabled = YES;
        }];
    }
}

// MARK: - 组装答案
// [{"part_id": 304, "data":[{"answer": [11,13,12], "topic_id": 6, "topic_level": 1, "question_type": 4},{"answer": ["填空题1-2", "3-1", "填空题2-1"], "topic_id": 7, "topic_level": 1, "question_type": 5}, {"answer": [190], "topic_id": 126, "topic_level": 1, "question_type": 1}, {"answer": ["填空题type5简答题type8答案"], "topic_id": 13, "topic_level": 1, "question_type": 8}]}]

// 首先获取 _currentExamPaperDetailModel 的 parts 数组; 从数组中每个元素里面获取每一部分题型的 ID 数组; 根据 ID 去从 _examDetailArray 数组里面匹配到试题的信息(用户的答案等信息); 再根据题型去组装数据;如此循环 直至 parts 里面循环结束
- (void)managerAnswer {
    
    // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答
    // 检索每一道题 首先判断题型 再获取数据 完形填空和材料题 区别对待
    [_answerManagerArray removeAllObjects];
    for (int i = 0; i<_examIdListArray.count; i++) {
        NSMutableDictionary *partDict = [NSMutableDictionary new];
        ExamPaperIDListModel *paperIDListModel = _examIdListArray[i];
        [partDict setObject:paperIDListModel.examPartId forKey:@"part_id"];
        NSMutableArray *dataArray = [NSMutableArray new];
        for (int j = 0; j<paperIDListModel.child.count; j++) {
            ExamIDModel *idModel = paperIDListModel.child[j];
            for (int k = 0; k<_examDetailArray.count; k++) {
                ExamDetailModel *model = _examDetailArray[k];
                
                if ([idModel.topic_id isEqualToString:model.examDetailId]) {
                    NSMutableDictionary *passDict = [NSMutableDictionary new];
                    
                    // 这里区分类型 材料题 和  完形填空 组装的数据是每个小题的数据 topic_level 除外
                    [passDict setObject:model.topic_level forKey:@"topic_level"];
                    
                    if ([model.question_type isEqualToString:@"1"] || [model.question_type isEqualToString:@"2"] || [model.question_type isEqualToString:@"3"] || [model.question_type isEqualToString:@"4"]) {
                        // 单多选 不定项 判断题
                        [passDict setObject:model.examDetailId forKey:@"topic_id"];
                        [passDict setObject:model.question_type forKey:@"question_type"];
                        
                        NSMutableArray *passArray = [NSMutableArray new];
                        BOOL has_selected = NO;
                        for (int l = 0; l<model.options.count; l++) {
                            ExamDetailOptionsModel *opModel = model.options[l];
                            if (opModel.is_selected) {
                                has_selected = YES;
                                [passArray addObject:opModel.examDetailOptionId];
                            }
                        }
                        if (has_selected) {
                            [passDict setObject:[NSArray arrayWithArray:passArray] forKey:@"answer"];
                            [dataArray addObject:[NSDictionary dictionaryWithDictionary:passDict]];
                        }
                    } else if ([model.question_type isEqualToString:@"5"] || [model.question_type isEqualToString:@"8"]) {
                        // 填空题 和 解答题
                        [passDict setObject:model.examDetailId forKey:@"topic_id"];
                        [passDict setObject:model.question_type forKey:@"question_type"];
                        
                        NSMutableArray *passArray = [NSMutableArray new];
                        BOOL has_selected = NO;
                        for (int l = 0; l<model.options.count; l++) {
                            ExamDetailOptionsModel *opModel = model.options[l];
                            if (opModel.userAnswerValue) {
                                has_selected = YES;
                                [passArray addObject:opModel.userAnswerValue];
                            } else {
                                [passArray addObject:@""];
                            }
                        }
                        if (has_selected) {
                            [passDict setObject:[NSArray arrayWithArray:passArray] forKey:@"answer"];
                            [dataArray addObject:[NSDictionary dictionaryWithDictionary:passDict]];
                        }
                    } else if ([model.question_type isEqualToString:@"7"]) {
                        // 完形填空
                        BOOL has_selected = NO;
                        for (int l = 0; l<model.topics.count; l++) {
                            ExamDetailModel *topicDetailModel = model.topics[l];
                            [passDict setObject:topicDetailModel.examDetailId forKey:@"topic_id"];
                            [passDict setObject:topicDetailModel.question_type forKey:@"question_type"];
                            NSMutableArray *topicPassArray = [NSMutableArray new];
                            has_selected = NO;
                            for (int m = 0; m<topicDetailModel.options.count; m++) {
                                ExamDetailOptionsModel *opModel = topicDetailModel.options[m];
                                if (opModel.is_selected) {
                                    has_selected = YES;
                                    [topicPassArray addObject:opModel.examDetailOptionId];
                                }
                            }
                            if (has_selected) {
                                [passDict setObject:[NSArray arrayWithArray:topicPassArray] forKey:@"answer"];
                                [dataArray addObject:[NSDictionary dictionaryWithDictionary:passDict]];
                            }
                        }
                    } else if ([model.question_type isEqualToString:@"6"]) {
                        // 材料题
                        BOOL has_selected = NO;
                        for (int l = 0; l<model.topics.count; l++) {
                            ExamDetailModel *topicDetailModel = model.topics[l];
                            [passDict setObject:topicDetailModel.examDetailId forKey:@"topic_id"];
                            [passDict setObject:topicDetailModel.question_type forKey:@"question_type"];
                            NSMutableArray *topicPassArray = [NSMutableArray new];
                            
                            if ([topicDetailModel.question_type isEqualToString:@"1"] || [topicDetailModel.question_type isEqualToString:@"2"] || [topicDetailModel.question_type isEqualToString:@"3"] || [topicDetailModel.question_type isEqualToString:@"4"]) {
                                has_selected = NO;
                                for (int m = 0; m<topicDetailModel.options.count; m++) {
                                    ExamDetailOptionsModel *opModel = topicDetailModel.options[m];
                                    if (opModel.is_selected) {
                                        has_selected = YES;
                                        [topicPassArray addObject:opModel.examDetailOptionId];
                                    }
                                }
                                if (has_selected) {
                                    [passDict setObject:[NSArray arrayWithArray:topicPassArray] forKey:@"answer"];
                                    [dataArray addObject:[NSDictionary dictionaryWithDictionary:passDict]];
                                }
                            } else if ([topicDetailModel.question_type isEqualToString:@"5"] || [topicDetailModel.question_type isEqualToString:@"8"]) {
                                has_selected = NO;
                                for (int l = 0; l<topicDetailModel.options.count; l++) {
                                    ExamDetailOptionsModel *opModel = topicDetailModel.options[l];
                                    if (opModel.userAnswerValue) {
                                        has_selected = YES;
                                        [topicPassArray addObject:opModel.userAnswerValue];
                                    } else {
                                        [topicPassArray addObject:@""];
                                    }
                                }
                                if (has_selected) {
                                    [passDict setObject:[NSArray arrayWithArray:topicPassArray] forKey:@"answer"];
                                    [dataArray addObject:[NSDictionary dictionaryWithDictionary:passDict]];
                                }
                            }
                        }
                    }
                }
            }
        }
        [partDict setObject:[NSArray arrayWithArray:dataArray] forKey:@"data"];
        [_answerManagerArray addObject:[NSDictionary dictionaryWithDictionary:partDict]];
    }
    
    NSLog(@" 组装后的答案以及传值数据 = %@",_answerManagerArray);
}

// MARK: - 计时器开始计时
- (void)timerStart {
    if ([_currentExamPaperDetailModel.total_time isEqualToString:@"0"]) {
        // 正序计时
        // 显示时间
        _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:remainTime]];
        remainTime +=1;
        
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if ([_examType isEqualToString:@"3"] && !_isExamButNoVerify) {
                if (popAlertCount>0) {
                    //_currentExamPaperDetailModel.face_data.verify_timespan * 60
                    // 正序计时 就直接用最小间隔去处理
                    if (remainTime % (_currentExamPaperDetailModel.face_data.verify_timespan * 60) == 0) {
                        // 弹框
                        if (paperTimer) {
                            [paperTimer setFireDate:[NSDate distantFuture]];
                        }
                        [self faceCompareTip:_examIds];
                    }
                }
            }
        }
    } else {
        // 倒序计时
        // 显示时间
        _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:remainTime]];
        remainTime -=1;
        if (remainTime==0) {
            _titleLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeChangeTimerWithSeconds:remainTime]];
            // 倒计时结束自动提交
            [paperTimer invalidate];
            paperTimer = nil;
//            remainTime = [_currentExamPaperDetailModel.total_time integerValue] * 60;
            [self putExamAnswer];
        } else {
            if ([ShowExamUserFace isEqualToString:@"1"]) {
                if ([_examType isEqualToString:@"3"] && !_isExamButNoVerify) {
                    if (popAlertCount>0) {
                        // 倒序计时 优先判断最小间隔 * 剩余次数 是否大于 倒计时 如果 大于倒计时  那就用倒计时除以剩余次数 获取区间  每个区间里面最后一个时间点来弹框(不随机 随机个锤子)
                        if (([_currentExamPaperDetailModel.total_time integerValue] * 60 - remainTime) % (_currentExamPaperDetailModel.face_data.verify_timespan * 60) == 0) {
                            // 弹框
                            if (paperTimer) {
                                [paperTimer setFireDate:[NSDate distantFuture]];
                            }
                            [self faceCompareTip:_examIds];
                        }
                    }
                }
            }
        }
    }
}

// MARK: - section音频播放器
- (void)voiceButtonClick:(UIButton *)sender {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
    if (SWNOTEmptyStr(currentExamId)) {
        ExamDetailModel *c_model = [self checkExamDetailArray:currentExamId];
        if (c_model) {
            // 区分材料题和其他一般题
            if ([c_model.question_type isEqualToString:@"6"]) {
                // 完形
                c_model = c_model.topics[sender.superview.tag - 100];
            }
            if (SWNOTEmptyArr(c_model.material)) {
                ExamMediaModel *model = c_model.material[sender.tag - 66];
                if ([model.type isEqualToString:@"audio"]) {
                    if (sender.selected) {
                        if (_voicePlayer) {
                            [_voicePlayer pause];
                            sender.selected = NO;
                            _currentVoiceButton.selected = NO;
                        }
                    } else {
                        if (_currentVoiceButton != sender) {
                            _currentVoiceButton.selected = NO;
                        }
                        sender.selected = YES;
                        _currentVoiceButton = sender;
                        NSURL * url = [NSURL URLWithString:model.src];
                        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
                        if (!_voicePlayer) {
                            _voicePlayer = [[AVPlayer alloc] initWithPlayerItem:songItem];
                        } else {
                            [_voicePlayer replaceCurrentItemWithPlayerItem:songItem];
                        }
                        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
                    }
                } else {
                    if (_voicePlayer) {
                        [_voicePlayer pause];
                        if (_currentVoiceButton) {
                            _currentVoiceButton.selected = NO;
                        }
                    }
                    
                    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
                    playerController.showsPlaybackControls = YES; // 关闭视频视图按钮
                    playerController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:model.src]];
                    [playerController.player play]; // 是否自动播放
                    [self.navigationController presentViewController:playerController animated:YES completion:nil];
                }
            }
        }
    }
}

// MARK: - header音视频播放
- (void)voiceHeaderButtonClick:(UIButton *)sender {
    if (!canTouchPaper) {
        if ([ShowExamUserFace isEqualToString:@"1"]) {
            if (popAlertCount>0) {
                [self faceCompareTip:_currentExamPaperDetailModel.paper_id];
            }
        }
        return;
    }
    if (SWNOTEmptyStr(currentExamId)) {
        ExamDetailModel *c_model = [self checkExamDetailArray:currentExamId];
        if (c_model) {
            if (SWNOTEmptyArr(c_model.material)) {
                ExamMediaModel *model = c_model.material[sender.tag - 66];
                if ([model.type isEqualToString:@"audio"]) {
                    if (sender.selected) {
                        if (_voicePlayer) {
                            [_voicePlayer pause];
                            sender.selected = NO;
                            _currentVoiceButton.selected = NO;
                        }
                    } else {
                        if (_currentVoiceButton != sender) {
                            _currentVoiceButton.selected = NO;
                        }
                        sender.selected = YES;
                        _currentVoiceButton = sender;
                        NSURL * url = [NSURL URLWithString:model.src];
                        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
                        if (!_voicePlayer) {
                            _voicePlayer = [[AVPlayer alloc] initWithPlayerItem:songItem];
                        } else {
                            [_voicePlayer replaceCurrentItemWithPlayerItem:songItem];
                        }
                        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
                    }
                } else {
                    if (_voicePlayer) {
                        [_voicePlayer pause];
                        if (_currentVoiceButton) {
                            _currentVoiceButton.selected = NO;
                        }
                    }
                    
                    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
                    playerController.showsPlaybackControls = YES; // 关闭视频视图按钮
                    playerController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:model.src]];
                    [playerController.player play]; // 是否自动播放
                    [self.navigationController presentViewController:playerController animated:YES completion:nil];
                }
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {

    if ([keyPath isEqualToString:@"status"]) {
        switch (_voicePlayer.status) {
            case AVPlayerStatusUnknown:
                break;
            case AVPlayerStatusReadyToPlay:
                [_voicePlayer play];
                break;
            case AVPlayerStatusFailed:
                break;
            default:
                break;
        }
    }
}

// MARK: - 上下题按钮点击后都需要将音频暂停置空
- (void)resetVoicePlayer {
    if (_voicePlayer) {
        [_voicePlayer pause];
        if (_currentVoiceButton) {
            _currentVoiceButton = nil;
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

// MARK: - 人脸未认证提示
- (void)faceVerifyTip {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未完成人脸认证\n请先去认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = YES;
        vc.verifyed = NO;
        vc.verifyResult = ^(BOOL result) {
//            if (result) {
//                self.userFaceVerifyResult(result);
//            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 人脸识别提示
- (void)faceCompareTip:(NSString *)courseHourseId {
    if ([[[self.navigationController childViewControllers] lastObject] isKindOfClass:[AnswerSheetViewController class]]) {
        return;
    }
    canTouchPaper = NO;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请进行人脸验证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = NO;
        vc.verifyed = YES;
        vc.sourceType = @"exam";
        vc.sourceId = courseHourseId;
        vc.scene_type = @"2";
        vc.verifyResult = ^(BOOL result) {
            if (result) {
                if (self->paperTimer) {
                    [self->paperTimer setFireDate:[NSDate date]];
                    self->popAlertCount = self->popAlertCount - 1;
                    self->canTouchPaper = YES;
                }
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)paperTimerStopOrStart:(NSNotification *)notice {
    NSDictionary *pass = notice.userInfo;
    if ([[pass objectForKey:@"timeStatus"] integerValue]) {
        // 开启
        [self->paperTimer setFireDate:[NSDate date]];
        self->popAlertCount = self->popAlertCount - 1;
        self->canTouchPaper = YES;
    } else {
        // 暂停
        canTouchPaper = NO;
        // 弹框
        if (paperTimer) {
            [paperTimer setFireDate:[NSDate distantFuture]];
        }
    }
}

@end
