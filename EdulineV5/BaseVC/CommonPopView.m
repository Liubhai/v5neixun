//
//  CommonPopView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/22.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CommonPopView.h"
#import "V5_Constant.h"

@implementation CommonPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    self.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    
    _popWhiteView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth - 270) / 2.0, MainScreenHeight / 2.0 - 180, 270, 180)];
    _popWhiteView.backgroundColor = [UIColor whiteColor];
    _popWhiteView.layer.masksToBounds = YES;
    _popWhiteView.layer.cornerRadius = 7;
    [self addSubview:_popWhiteView];
    
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
    
    _popTextPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_popTextView.left + 12.5, _popTextView.top + 1, _popTextView.width - 12.5, 30)];
    _popTextPlaceholderLabel.text = @"输入提问内容";
    _popTextPlaceholderLabel.textColor = EdlineV5_Color.textThirdColor;
    _popTextPlaceholderLabel.font = SYSTEMFONT(14);
    _popTextPlaceholderLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_popTextPlaceholderLabel addGestureRecognizer:placeTap];
    [_popTextBackView addSubview:_popTextPlaceholderLabel];
    
    _popTextMaxCountView = [[UILabel alloc] initWithFrame:CGRectMake(_popTextBackView.width - 4 - 100, _popTextBackView.height - 20, 100, 16)];
    _popTextMaxCountView.font = SYSTEMFONT(12);
    _popTextMaxCountView.textColor = EdlineV5_Color.textThirdColor;
    _popTextMaxCountView.text = [NSString stringWithFormat:@"0/%@",@(_wordMax)];
    _popTextMaxCountView.textAlignment = NSTextAlignmentRight;
    [_popTextBackView addSubview:_popTextMaxCountView];
    
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
    [_popSureButton setTitle:@"提问" forState:0];
    [_popSureButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _popSureButton.titleLabel.font = SYSTEMFONT(18);
    [_popSureButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_popWhiteView addSubview:_popSureButton];
    
    _popLine1View = [[UIView alloc] initWithFrame:CGRectMake(0, _popLine2View.top - 1, _popWhiteView.width, 1)];
    _popLine1View.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_popWhiteView addSubview:_popLine1View];
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _popTextPlaceholderLabel.hidden = NO;
    } else {
        _popTextPlaceholderLabel.hidden = YES;
    }
    _popTextMaxCountView.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(_wordMax)];
    if (_wordMax>5) {
        if (textView.text.length>_wordMax) {
            NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_popTextMaxCountView.text];
            [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor} range:NSMakeRange(0, _popTextMaxCountView.text.length - 4)];
            _popTextMaxCountView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
        } else {
        }
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

- (void)popButtonClick:(UIButton *)sender {
    [_popTextView resignFirstResponder];
    if (sender == _popCancelButton) {
        self.hidden = YES;
        [self removeFromSuperview];
    } else if (sender == _popSureButton) {
        self.hidden = YES;
        if (!SWNOTEmptyStr(_popTextView.text)) {
            [MBProgressHUD showMessag:@"请输入提问内容" toView:self];
            return;
        }
    }
}

@end
