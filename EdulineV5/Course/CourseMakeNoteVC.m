//
//  CourseMakeNoteVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/10/13.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CourseMakeNoteVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface CourseMakeNoteVC ()<UITextViewDelegate> {
    NSInteger wordMax;
}

/// 提问弹框
@property (strong, nonatomic) UIView *popBackView;
@property (strong, nonatomic) UIView *popWhiteView;
@property (strong, nonatomic) UIView *popTextBackView;
@property (strong, nonatomic) UITextView *popTextView;
@property (strong, nonatomic) UILabel *popTextPlaceholderLabel;
@property (strong, nonatomic) UILabel *popTextMaxCountView;
@property (strong, nonatomic) UIButton *openButton;
@property (strong, nonatomic) UIView *popLine1View;
@property (strong, nonatomic) UIButton *popCancelButton;
@property (strong, nonatomic) UIView *popLine2View;
@property (strong, nonatomic) UIButton *popSureButton;

@end

@implementation CourseMakeNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleImage.hidden = YES;
    wordMax = 400;
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    [self makePopView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}

// MARK: - 提问弹框
- (void)makePopView {
    if (_popBackView == nil) {
        _popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _popBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [self.view addSubview:_popBackView];
        
        _popWhiteView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth - 270) / 2.0, MainScreenHeight / 2.0 - 180 - 30, 270, 180 + 30)];
        _popWhiteView.backgroundColor = [UIColor whiteColor];
        _popWhiteView.layer.masksToBounds = YES;
        _popWhiteView.layer.cornerRadius = 7;
        [_popBackView addSubview:_popWhiteView];
        
        _popTextBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, _popWhiteView.width - 40, 95)];
        _popTextBackView.layer.masksToBounds = YES;
        _popTextBackView.layer.cornerRadius = 4;
        _popTextBackView.layer.borderWidth = 0.5;
        _popTextBackView.layer.borderColor = HEXCOLOR(0xE4E7ED).CGColor;
        [_popWhiteView addSubview:_popTextBackView];
        
        _popTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 12, _popTextBackView.width - 24, 75 - 12)];
        _popTextView.font = SYSTEMFONT(14);
        _popTextView.textColor = EdlineV5_Color.textFirstColor;
        _popTextView.delegate = self;
        _popTextView.returnKeyType = UIReturnKeyDone;
        [_popTextBackView addSubview:_popTextView];
        
        _popTextPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_popTextView.left, _popTextView.top + 1, _popTextView.width, 30)];
        _popTextPlaceholderLabel.text = @" 输入笔记内容";
        _popTextPlaceholderLabel.textColor = EdlineV5_Color.textThirdColor;
        _popTextPlaceholderLabel.font = SYSTEMFONT(14);
        _popTextPlaceholderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
        [_popTextPlaceholderLabel addGestureRecognizer:placeTap];
        [_popTextBackView addSubview:_popTextPlaceholderLabel];
        
        _popTextMaxCountView = [[UILabel alloc] initWithFrame:CGRectMake(_popTextBackView.width - 4 - 100, _popTextBackView.height - 20, 100, 16)];
        _popTextMaxCountView.font = SYSTEMFONT(12);
        _popTextMaxCountView.textColor = EdlineV5_Color.textThirdColor;
        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
        _popTextMaxCountView.textAlignment = NSTextAlignmentRight;
        [_popTextBackView addSubview:_popTextMaxCountView];
        
        NSString *openText = @"公开";
        CGFloat openWidth = [openText sizeWithFont:SYSTEMFONT(14)].width + 4 + 20;
        CGFloat space = 2.0;
        
        _openButton = [[UIButton alloc] initWithFrame:CGRectMake(_popTextBackView.left - 3.5, _popTextBackView.bottom + 10, openWidth, 20)];
        [_openButton setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
        [_openButton setImage:Image(@"checkbox_nor") forState:0];
        [_openButton setTitle:openText forState:0];
        [_openButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        _openButton.titleLabel.font = SYSTEMFONT(14);
        _openButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
        _openButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_openButton];
        
        _popCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _popWhiteView.height - 50, (_popWhiteView.width - 1) / 2.0, 50)];
        [_popCancelButton setTitle:@"取消" forState:0];
        [_popCancelButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        _popCancelButton.titleLabel.font = SYSTEMFONT(18);
        [_popCancelButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_popCancelButton];
        
        _popLine2View = [[UIView alloc] initWithFrame:CGRectMake(_popCancelButton.right, _popCancelButton.top, 1, 50)];
        _popLine2View.backgroundColor = EdlineV5_Color.fengeLineColor;
        [_popWhiteView addSubview:_popLine2View];
        
        _popSureButton = [[UIButton alloc] initWithFrame:CGRectMake(_popLine2View.right, _popWhiteView.height - 50, (_popWhiteView.width - 1) / 2.0, 50)];
        [_popSureButton setTitle:@"发布" forState:0];
        [_popSureButton setTitleColor:EdlineV5_Color.themeColor forState:0];
        _popSureButton.titleLabel.font = SYSTEMFONT(18);
        [_popSureButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popWhiteView addSubview:_popSureButton];
        
        _popLine1View = [[UIView alloc] initWithFrame:CGRectMake(0, _popLine2View.top - 1, _popWhiteView.width, 1)];
        _popLine1View.backgroundColor = EdlineV5_Color.fengeLineColor;
        [_popWhiteView addSubview:_popLine1View];
        
        if (SWNOTEmptyDictionary(_originCommentInfo)) {
            _popTextView.text = [NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"content"]];
            _popTextPlaceholderLabel.hidden = YES;
            _popTextMaxCountView.text = [NSString stringWithFormat:@"%@/%@",@(_popTextView.text.length),@(wordMax)];
            _openButton.selected = [[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"open_status"]] boolValue];
            if (_popTextView.text.length>wordMax) {
                NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_popTextMaxCountView.text];
                [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _popTextMaxCountView.text.length - 4)];
                _popTextMaxCountView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
            }
        }
        
    }
    _popBackView.hidden = NO;
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _popTextPlaceholderLabel.hidden = NO;
    } else {
        _popTextPlaceholderLabel.hidden = YES;
    }
    _popTextMaxCountView.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(wordMax)];
    if (textView.text.length>wordMax) {
        NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_popTextMaxCountView.text];
        [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _popTextMaxCountView.text.length - 4)];
        _popTextMaxCountView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    } else {
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _popTextPlaceholderLabel.hidden = YES;
    [_popTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _popTextPlaceholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_popTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)openButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)popButtonClick:(UIButton *)sender {
    [_popTextView resignFirstResponder];
    if (sender == _popCancelButton) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    } else if (sender == _popSureButton) {
        if (!SWNOTEmptyStr(_popTextView.text)) {
            [self showHudInView:self.view showHint:@"内容不能为空"];
            return;
        }
        if (_popTextView.text.length>wordMax) {
            [self showHudInView:self.view showHint:[NSString stringWithFormat:@"内容不能超过%@字",@(wordMax)]];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary new];
        if (SWNOTEmptyDictionary(_originCommentInfo)) {
            [param setObject:_popTextView.text forKey:@"content"];
            [param setObject:_openButton.selected ? @"1" : @"0"  forKey:@"open_status"];
            [Net_API requestPUTWithURLStr:[Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        _popTextView.text = @"";
                        _popTextPlaceholderLabel.hidden = NO;
                        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
                        [self.view removeFromSuperview];
                        [self removeFromParentViewController];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        } else {
            [param setObject:_popTextView.text forKey:@"content"];
            [param setObject:_courseId forKey:@"course_id"];
            if (SWNOTEmptyStr(_courseHourseId)) {
                [param setObject:_courseHourseId forKey:@"section_id"];
            }
            [param setObject:_courseType forKey:@"course_type"];
            [param setObject:_openButton.selected ? @"1" : @"0"  forKey:@"open_status"];
            [Net_API requestPOSTWithURLStr:(SWNOTEmptyDictionary(_originCommentInfo) ? [Net_Path modificationCourseNote:[NSString stringWithFormat:@"%@",[_originCommentInfo objectForKey:@"id"]]] : [Net_Path addCourseHourseNote]) WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        _popTextView.text = @"";
                        _popTextPlaceholderLabel.hidden = NO;
                        _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(wordMax)];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseCommentListVCRloadData" object:nil userInfo:@{@"type":@"note"}];
                        [self.view removeFromSuperview];
                        [self removeFromParentViewController];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
    }
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
