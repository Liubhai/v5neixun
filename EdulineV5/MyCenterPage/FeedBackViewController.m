//
//  FeedBackViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "FeedBackViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface FeedBackViewController ()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate> {
    BOOL isTextField;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIView *topWhiteView;
@property (strong, nonatomic) UILabel *feedTitleLabel;
@property (strong, nonatomic) UITextView *feedTextView;
@property (strong, nonatomic) UILabel *feedContentPlace;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *bottomWhiteView;
@property (strong, nonatomic) UILabel *phoneTitleLabel;
@property (strong, nonatomic) UITextField *phoneTextF;
@property (strong, nonatomic) UIButton *submitButton;


@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    _titleLabel.text = @"反馈";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeSubView];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = EdlineV5_Color.backColor;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    _topWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 250)];
    _topWhiteView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_topWhiteView];
    
    
    _feedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _feedTitleLabel.font = SYSTEMFONT(16);
    _feedTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _feedTitleLabel.text = @"问题描述";
    [_topWhiteView addSubview:_feedTitleLabel];
    
    _feedTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, _feedTitleLabel.bottom, MainScreenWidth - 30, 200)];
    _feedTextView.font = SYSTEMFONT(14);
    _feedTextView.textColor = EdlineV5_Color.textFirstColor;
    _feedTextView.delegate = self;
    _feedTextView.returnKeyType = UIReturnKeyDone;
    [_topWhiteView addSubview:_feedTextView];
    
    _feedContentPlace = [[UILabel alloc] initWithFrame:CGRectMake(_feedTextView.left, _feedTextView.top + 1, _feedTextView.width, 30)];
    _feedContentPlace.text = @"在这里输入反馈的内容";
    _feedContentPlace.textColor = EdlineV5_Color.textThirdColor;
    _feedContentPlace.font = SYSTEMFONT(14);
    _feedContentPlace.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_feedContentPlace addGestureRecognizer:placeTap];
    [_topWhiteView addSubview:_feedContentPlace];
    
    _bottomWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, _topWhiteView.bottom + 10, MainScreenWidth, 90)];
    _bottomWhiteView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_bottomWhiteView];
    
    _phoneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _phoneTitleLabel.font = SYSTEMFONT(16);
    _phoneTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _phoneTitleLabel.text = @"联系方式";
    [_bottomWhiteView addSubview:_phoneTitleLabel];
    
    _phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, 50, MainScreenWidth - 30, 40)];
    _phoneTextF.font = SYSTEMFONT(14);
    _phoneTextF.textColor = EdlineV5_Color.textSecendColor;
    _phoneTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入您的手机号" attributes:@{NSFontAttributeName:SYSTEMFONT(14),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _phoneTextF.delegate = self;
    _phoneTextF.returnKeyType = UIReturnKeyDone;
    [_bottomWhiteView addSubview:_phoneTextF];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _bottomWhiteView.bottom + 32, 320, 36)];
    [_submitButton setTitle:@"提交" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerX = MainScreenWidth/2.0;
    [_submitButton addTarget:self action:@selector(subMitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_submitButton];
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _feedContentPlace.hidden = NO;
    } else {
        _feedContentPlace.hidden = YES;
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _feedContentPlace.hidden = YES;
    [_feedTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _feedContentPlace.hidden = YES;
    isTextField = NO;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_feedTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_phoneTextF resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    isTextField = YES;
    return YES;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    if (_feedTextView.text.length<=0) {
        _feedContentPlace.hidden = NO;
    } else {
        _feedContentPlace.hidden = YES;
    }
    // 重置
    isTextField = NO;
}
- (void)keyboardWillShow:(NSNotification *)notification{
    if (isTextField) {
        NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat otherViewOriginY = _bottomWhiteView.top + _phoneTextF.bottom + 10;
        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
        if ([endValue CGRectValue].size.height > offSet) {
            [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
        }
    } else {
        // 暂不作处理
    }
}

- (void)subMitButtonClick:(UIButton *)sender {
    
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
