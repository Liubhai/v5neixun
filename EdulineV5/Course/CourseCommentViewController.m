//
//  CourseCommentViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommentViewController.h"
#import "V5_Constant.h"
#import "StarEvaluator.h"
#import "Net_Path.h"

@interface CourseCommentViewController ()<UITextViewDelegate,StarEvaluatorDelegate> {
    CGFloat keyHeight;
    NSInteger wordMax;
}

@property (strong, nonatomic) UIScrollView *mainView;
@property (strong, nonatomic) UILabel *pingfenLabel;
@property (strong, nonatomic) StarEvaluator *starEva;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) UIButton *openButton;
@property (strong, nonatomic) UILabel *textCountLabel;
@property (strong, nonatomic) UILabel *placeLabel;

@end

@implementation CourseCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap:)];
//    [self.view addGestureRecognizer:viewTap];
    wordMax = _isComment ? 100 : 400;
    _titleImage.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = _isComment ? @"点评" : @"笔记";
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [_leftButton setImage:Image(@"nav_back_grey") forState:0];
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"提交" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textThirdColor forState:UIControlStateDisabled];
    _rightButton.hidden = NO;
    _rightButton.enabled = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (SWNOTEmptyDictionary(_originCommentInfo)) {
        if (_isComment) {
            float count = [[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"star"]] floatValue];
            [_starEva setStarValue:count];
            _starEva.currentValue = count;
            _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",count>5.0 ? 5.0 : count];
            _commentTextView.text = [NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"content"]];
            _placeLabel.hidden = YES;
            _textCountLabel.text = [NSString stringWithFormat:@"%@/%@",@(_commentTextView.text.length),@(wordMax)];
            if (_commentTextView.text.length>wordMax) {
                NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_textCountLabel.text];
                [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _textCountLabel.text.length - 4)];
                _textCountLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
            }
        } else {
            _commentTextView.text = [NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"content"]];
            _placeLabel.hidden = YES;
            _textCountLabel.text = [NSString stringWithFormat:@"%@/%@",@(_commentTextView.text.length),@(wordMax)];
            _openButton.selected = [[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"open_status"]] boolValue];
            if (_commentTextView.text.length>wordMax) {
                NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_textCountLabel.text];
                [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _textCountLabel.text.length - 4)];
                _textCountLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
            }
        }
    }
}

- (void)makeSubView {
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA)];
    [self.view addSubview:_mainView];
    
    _pingfenLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 42, _isComment ? 60 : 0)];
    _pingfenLabel.text = @"评分";
    _pingfenLabel.textColor = EdlineV5_Color.textFirstColor;
    _pingfenLabel.font = SYSTEMFONT(15);
    [_mainView addSubview:_pingfenLabel];
    
    _starEva = [[StarEvaluator alloc] initWithFrame:CGRectMake(_pingfenLabel.right, (60 - 20) / 2.0, 116, _isComment ? 20 : 0)];
    _starEva.delegate = self;
    _starEva.userInteractionEnabled = YES;
    [_mainView addSubview:_starEva];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(_starEva.right + 20, 0, 100, _isComment ? 60 : 0)];
    _scoreLabel.font = SYSTEMFONT(14);
    _scoreLabel.textColor = EdlineV5_Color.textThirdColor;
    [_mainView addSubview:_scoreLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _scoreLabel.bottom, MainScreenWidth, _isComment ? 0.5 : 0)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainView addSubview:_lineView];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, _isComment ? (_lineView.bottom + 15) : 0, MainScreenWidth - 30, 400)];
    _commentTextView.font = SYSTEMFONT(14);
    _commentTextView.textColor = EdlineV5_Color.textFirstColor;
    _commentTextView.delegate = self;
    [_mainView addSubview:_commentTextView];
    
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commentTextView.left, _commentTextView.top + 1, _commentTextView.width, 30)];
    _placeLabel.text = _isComment ? @" 您可以分享学习体验、课程内容、老师讲课的风格等" : @" 笔记内容";
    _placeLabel.textColor = EdlineV5_Color.textThirdColor;
    _placeLabel.font = SYSTEMFONT(14);
    _placeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_placeLabel addGestureRecognizer:placeTap];
    [_mainView addSubview:_placeLabel];
    
    _textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _mainView.height - 35, 100, 20)];
    _textCountLabel.font = SYSTEMFONT(14);
    _textCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _textCountLabel.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
    _textCountLabel.textAlignment = NSTextAlignmentRight;
    [_mainView addSubview:_textCountLabel];
    
    NSString *openText = @"公开";
    CGFloat openWidth = [openText sizeWithFont:SYSTEMFONT(14)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _openButton = [[UIButton alloc] initWithFrame:CGRectMake(15, _textCountLabel.top, openWidth, 20)];
    [_openButton setImage:Image(@"checkbox_sel") forState:UIControlStateSelected];
    [_openButton setImage:Image(@"checkbox_nor") forState:0];
    [_openButton setTitle:openText forState:0];
    [_openButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _openButton.titleLabel.font = SYSTEMFONT(14);
    _openButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _openButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_openButton];
    
    _openButton.hidden = _isComment;
    if (!_isComment) {
        _pingfenLabel.hidden = YES;
        _starEva.hidden = YES;
        _scoreLabel.hidden = YES;
        _lineView.hidden = YES;
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _placeLabel.hidden = YES;
    [_commentTextView becomeFirstResponder];
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _placeLabel.hidden = NO;
        _rightButton.enabled = NO;
    } else {
        _placeLabel.hidden = YES;
        _rightButton.enabled = YES;
    }
    _textCountLabel.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(wordMax)];
    if (textView.text.length>wordMax) {
        NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_textCountLabel.text];
        [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _textCountLabel.text.length - 4)];
        _textCountLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    } else {
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeLabel.hidden = YES;
    return YES;
}

- (void)anotherStarEvaluator:(StarEvaluator *)evaluator currentValue:(float)value {
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",value>5.0 ? 5.0 : value];
}

- (void)rightButtonClick:(id)sender {
    [_commentTextView resignFirstResponder];
    if (_commentTextView.text.length<=0) {
        [self showHudInView:self.view showHint:@"内容不能为空"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (_isComment) {
        [param setObject:_commentTextView.text forKey:@"content"];
        [param setObject:[_scoreLabel.text stringByReplacingOccurrencesOfString:@"分" withString:@""] forKey:@"star"];
        [Net_API requestPOSTWithURLStr:_isComment ? [Net_Path courseCommentList:_courseId] : (SWNOTEmptyDictionary(_originCommentInfo) ? [Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] : [Net_Path addCourseHourseNote]) WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"comment"}];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        if (SWNOTEmptyDictionary(_originCommentInfo)) {
            [param setObject:_commentTextView.text forKey:@"content"];
            [param setObject:_openButton.selected ? @"1" : @"0"  forKey:@"open_status"];
            [Net_API requestPUTWithURLStr:[Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        } else {
            [param setObject:_commentTextView.text forKey:@"content"];
            [param setObject:_courseId forKey:@"course_id"];
            [param setObject:_courseHourseId forKey:@"section_id"];
            [param setObject:_courseType forKey:@"course_type"];
            [param setObject:_openButton.selected ? @"1" : @"0"  forKey:@"open_status"];
            [Net_API requestPOSTWithURLStr:_isComment ? [Net_Path courseCommentList:_courseId] : (SWNOTEmptyDictionary(_originCommentInfo) ? [Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] : [Net_Path addCourseHourseNote]) WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

- (void)backViewTap:(UIGestureRecognizer *)tap {
    [_commentTextView resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification{
//    [_mainView setContentOffset:CGPointMake(0, 0)];
    [_textCountLabel setTop:_mainView.height - 35];
    [_openButton setTop:_textCountLabel.top];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    [_textCountLabel setTop:_mainView.height - keyHeight - 35];
    [_openButton setTop:_textCountLabel.top];
}

- (void)openButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
