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

@interface CourseCommentViewController ()<UITextViewDelegate,StarEvaluatorDelegate> {
    CGFloat keyHeight;
}

@property (strong, nonatomic) UIScrollView *mainView;
@property (strong, nonatomic) UILabel *pingfenLabel;
@property (strong, nonatomic) StarEvaluator *starEva;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) UILabel *textCountLabel;
@property (strong, nonatomic) UILabel *placeLabel;

@end

@implementation CourseCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap:)];
//    [self.view addGestureRecognizer:viewTap];
    _titleImage.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"点评";
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [_leftButton setImage:Image(@"nav_back_grey") forState:0];
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"提交" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeSubView {
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA)];
    [self.view addSubview:_mainView];
    
    _pingfenLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 42, 60)];
    _pingfenLabel.text = @"评分";
    _pingfenLabel.textColor = EdlineV5_Color.textFirstColor;
    _pingfenLabel.font = SYSTEMFONT(15);
    [_mainView addSubview:_pingfenLabel];
    
    _starEva = [[StarEvaluator alloc] initWithFrame:CGRectMake(_pingfenLabel.right, (60 - 20) / 2.0, 116, 20)];
    _starEva.delegate = self;
    _starEva.userInteractionEnabled = YES;
    [_mainView addSubview:_starEva];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(_starEva.right + 20, 0, 100, 60)];
    _scoreLabel.font = SYSTEMFONT(14);
    _scoreLabel.textColor = EdlineV5_Color.textThirdColor;
    [_mainView addSubview:_scoreLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _scoreLabel.bottom, MainScreenWidth, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainView addSubview:_lineView];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, _lineView.bottom + 15, MainScreenWidth - 30, 400)];
    _commentTextView.font = SYSTEMFONT(14);
    _commentTextView.textColor = EdlineV5_Color.textFirstColor;
    _commentTextView.delegate = self;
    [_mainView addSubview:_commentTextView];
    
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commentTextView.left, _commentTextView.top + 1, _commentTextView.width, 30)];
    _placeLabel.text = @" 您可以分享学习体验、课程内容、老师讲课的风格等";
    _placeLabel.textColor = EdlineV5_Color.textThirdColor;
    _placeLabel.font = SYSTEMFONT(14);
    _placeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_placeLabel addGestureRecognizer:placeTap];
    [_mainView addSubview:_placeLabel];
    
    _textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _mainView.height - 35, 100, 20)];
    _textCountLabel.font = SYSTEMFONT(14);
    _textCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _textCountLabel.text = @"0/200";
    _textCountLabel.textAlignment = NSTextAlignmentRight;
    [_mainView addSubview:_textCountLabel];
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _placeLabel.hidden = YES;
    [_commentTextView becomeFirstResponder];
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _placeLabel.hidden = NO;
    } else {
        _placeLabel.hidden = YES;
    }
    _textCountLabel.text = [NSString stringWithFormat:@"%@/200",@(textView.text.length)];
    if (textView.text.length>200) {
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
}

- (void)backViewTap:(UIGestureRecognizer *)tap {
    [_commentTextView resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification{
//    [_mainView setContentOffset:CGPointMake(0, 0)];
    [_textCountLabel setTop:_mainView.height - 35];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    [_textCountLabel setTop:_mainView.height - keyHeight - 35];
}

@end
