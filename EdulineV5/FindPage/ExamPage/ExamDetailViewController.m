//
//  ExamDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/5.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamDetailViewController.h"
#import "TYAttributedLabel.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamIDListModel.h"

#import "ExamAnswerCell.h"

@interface ExamDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger examCount;//整套试卷的总题数
    NSInteger currentExamRow;// 当前答题是第几道题
    NSString *currentExamId;//当前答题的试题ID
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *examIdListArray;// 获取得到题干ID数组
@property (strong, nonatomic) NSMutableArray *examDetailArray;// 通过题干ID获取到具体试题内容数组
@property (strong, nonatomic) UIView *headerView;;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *previousExamBtn;
@property (strong, nonatomic) UIButton *nextExamBtn;

@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) UIButton *examSheetBtn;
@property (strong, nonatomic) UIButton *examCollectBtn;





@end

@implementation ExamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"00:32:22";
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = SYSTEMFONT(16);
    
    _examIdListArray = [NSMutableArray new];
    _examDetailArray = [NSMutableArray new];
    
    [self makeTopView];
    [self makeHeaderView];
    [self makeTableView];
    [self makeBottomView];
    
    [self getData];
}

- (void)makeTopView {
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 52, 0, 52, 25)];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = _submitBtn.height / 2.0;
    _submitBtn.centerY = _titleLabel.centerY;
    _submitBtn.backgroundColor = EdlineV5_Color.themeColor;
    [_submitBtn setTitle:@"交卷" forState:0];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    _submitBtn.titleLabel.font = SYSTEMFONT(14);
    [_submitBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_submitBtn];
    
    _examSheetBtn = [[UIButton alloc] initWithFrame:CGRectMake(_submitBtn.left - 25 - 20, 0, 20, 20)];
    [_examSheetBtn setImage:Image(@"exam_sheet_icon") forState:0];
    _examSheetBtn.centerY = _titleLabel.centerY;
    [_examSheetBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_examSheetBtn];
    
    _examCollectBtn = [[UIButton alloc] initWithFrame:CGRectMake(_examSheetBtn.left - 25 - 20, 0, 20, 20)];
    [_examCollectBtn setImage:Image(@"star_nor") forState:0];
    _examCollectBtn.centerY = _titleLabel.centerY;
    [_examCollectBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_examCollectBtn];
}

- (void)makeBottomView {
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
    [_nextExamBtn setTitle:@"下一题" forState:0];
    [_nextExamBtn setImage:[Image(@"exam_next") converToMainColor] forState:0];
    [_nextExamBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    _nextExamBtn.titleLabel.font = SYSTEMFONT(16);
    [_nextExamBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_bottomView addSubview:_nextExamBtn];
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    _headerView.backgroundColor = EdlineV5_Color.backColor;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
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
        ExamDetailModel *model = _examDetailArray[0];
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
        ExamDetailModel *model = _examDetailArray[0];
        if (SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[section];
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
        ExamDetailModel *model = _examDetailArray[0];
        if (SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[indexPath.section];
            [cell setAnswerInfo:(ExamDetailOptionsModel *)(modelpass.options[indexPath.row])];
        } else {
            [cell setAnswerInfo:(ExamDetailOptionsModel *)(model.options[indexPath.row])];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    back.backgroundColor = EdlineV5_Color.backColor;
    UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    lable1111.backgroundColor = EdlineV5_Color.backColor;
    NSMutableAttributedString * attrString;
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = _examDetailArray[0];
        if (SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[section];
            attrString = [[NSMutableAttributedString alloc] initWithData:[modelpass.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        } else {
            attrString = [[NSMutableAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        }
        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
        [lable1111 sizeToFit];
        lable1111.showsVerticalScrollIndicator = NO;
        lable1111.showsHorizontalScrollIndicator = NO;
        lable1111.editable = NO;
        lable1111.scrollEnabled = NO;
        [lable1111 setHeight:lable1111.height];
        [back setHeight:lable1111.height];
        [back addSubview:lable1111];
        return back;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    NSMutableAttributedString * attrString;
    if (SWNOTEmptyArr(_examDetailArray)) {
        ExamDetailModel *model = _examDetailArray[0];
        if (SWNOTEmptyArr(model.topics)) {
            ExamDetailModel *modelpass = model.topics[section];
            attrString = [[NSMutableAttributedString alloc] initWithData:[modelpass.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        } else {
            attrString = [[NSMutableAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        }
        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
        [lable1111 sizeToFit];
        [lable1111 setHeight:lable1111.height];
        return lable1111.height;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)getData {
    if (SWNOTEmptyStr(_examIds)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointIdListNet] WithAuthorization:nil paramDic:@{@"point_ids":_examIds,@"module_id":_examType} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    examCount = [[NSString stringWithFormat:@"%@",responseObject[@"data"][@"topic_num"]] integerValue];
                    currentExamRow = 0;
                    [_examIdListArray removeAllObjects];
                    NSArray *pass = [NSArray arrayWithArray:[ExamIDListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rules"]]];
                    [_examIdListArray addObjectsFromArray:pass];
                    if (SWNOTEmptyArr(pass)) {
                        ExamIDListModel *passDict = (ExamIDListModel *)pass[0];
                        NSArray *passArray = [NSArray arrayWithArray:passDict.child];
                        if (SWNOTEmptyArr(passArray)) {
                            ExamIDModel *passfinalDict = (ExamIDModel *)passArray[0];
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
    if (SWNOTEmptyStr(examIds)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointDetailDataNet] WithAuthorization:nil paramDic:@{@"topic_id":examIds} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_examDetailArray removeAllObjects];
                    [_examDetailArray addObjectsFromArray:[ExamDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                    for (int i = 0; i<_examDetailArray.count; i++) {
                        ExamDetailModel *pass = _examDetailArray[i];
                        if (SWNOTEmptyArr(pass.topics)) {
                            
                        } else {
                            for (int j = 0; j<pass.options.count; j++) {
                                ExamDetailOptionsModel *modelOp = pass.options[j];
                                modelOp.mutvalue = [self changeStringToMutA:modelOp.value];
                            }
                        }
                    }
                    if (SWNOTEmptyArr(_examDetailArray)) {
                        if (!_headerView) {
                            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
                            _headerView.backgroundColor = EdlineV5_Color.backColor;
                        }
                        [_headerView removeAllSubviews];
                        
                        UILabel *examThemeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth-15 - 14 - 53, 53)];
                        examThemeLabel.font = SYSTEMFONT(16);
                        examThemeLabel.textColor = EdlineV5_Color.textFirstColor;
                        examThemeLabel.text = @"知识点练习";
                        [_headerView addSubview:examThemeLabel];
                        
                        UILabel *examCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 28, 0, 15+28, 53)];
                        examCountLabel.font = SYSTEMFONT(13);
                        examCountLabel.textColor = EdlineV5_Color.textThirdColor;
                        NSString *cur = [NSString stringWithFormat:@"%@",@(currentExamRow)];
                        NSMutableAttributedString *fullExamCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",@(currentExamRow),@(examCount)]];
                        [fullExamCount addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.themeColor} range:NSMakeRange(0, cur.length)];
                        examCountLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:fullExamCount];
                        [_headerView addSubview:examCountLabel];
                        
                        UIImageView *examCountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(examCountLabel.left - 10 - 14, 0, 14, 16)];
                        examCountIcon.image = Image(@"marker_icon");
                        examCountIcon.centerY = examCountLabel.centerY;
                        [_headerView addSubview:examCountIcon];
                        
                        ExamDetailModel *model = (ExamDetailModel *)_examDetailArray[0];
                        if (SWNOTEmptyArr(model.topics)) {
                            // 有多道小试题 这里就需要设置 整个 tableview 的 头部
                            NSString *origin = [NSString stringWithFormat:@"%@",model.title];
                            UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(0, examThemeLabel.bottom, MainScreenWidth, 100)];
                            NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[origin dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

                            lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
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
                            [_headerView setHeight:examThemeLabel.bottom];
                            _tableView.tableHeaderView = _headerView;
                        }
                        [_tableView reloadData];
                    }
                    
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)bottomButtonClick:(UIButton *)sender {
}

- (NSMutableAttributedString *)changeStringToMutA:(NSString *)commonString {
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[commonString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrString;
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
