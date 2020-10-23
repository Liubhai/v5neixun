//
//  CommentBaseView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/18.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CommentBaseView.h"

@implementation CommentBaseView

- (instancetype)initWithFrame:(CGRect)frame leftButtonImageArray:(nullable NSArray *)leftButtonImageArray placeHolderTitle:(nullable NSString *)placeHolderTitle sendButtonTitle:(nullable NSString *)sendButtonTitle {
    self = [super initWithFrame:frame];
    if (self) {
        _leftButtonImageArray = [NSArray arrayWithArray:leftButtonImageArray];
        _sendButtonTitle = sendButtonTitle;
        _placeHolderTitle = placeHolderTitle;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = HEXCOLOR(0x000000).CGColor;// 阴影颜色
    self.layer.shadowOpacity = 1;// 阴影透明度，默认0
    self.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius = 3;//阴影半径，默认3
    
    CGFloat XX = 15;
    
    for (int i = 0; i<_leftButtonImageArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (CommentViewLeftButtonWidth + 8) * i, 10, CommentViewLeftButtonWidth, CommentViewLeftButtonWidth)];
        [btn setImage:Image(_leftButtonImageArray[i]) forState:0];
        btn.tag = 20 + i;
        [btn addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == _leftButtonImageArray.count - 1) {
            XX = btn.right + 13.5;
        }
        [self addSubview:btn];
    }
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(XX, (CommenViewHeight - CommentInputHeight) / 2.0, MainScreenWidth - XX - 57.5, CommentInputHeight)];
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.layer.cornerRadius = CommentInputHeight / 2.0;
    _inputTextView.textColor = EdlineV5_Color.textFirstColor;
    _inputTextView.font = SYSTEMFONT(16);
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = EdlineV5_Color.backColor;
    _inputTextView.returnKeyType = UIReturnKeyDone;
    [self addSubview:_inputTextView];
    
    _placeHoderLab = [[UILabel alloc] initWithFrame:CGRectMake(_inputTextView.left + 12.5, (CommenViewHeight - CommentInputHeight) / 2.0, _inputTextView.width - 12.5, CommentInputHeight)];
    _placeHoderLab.text = @"评论";
    _placeHoderLab.textColor = EdlineV5_Color.textThirdColor;
    _placeHoderLab.font = SYSTEMFONT(16);
    _placeHoderLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_placeHoderLab addGestureRecognizer:placeTap];
    [self addSubview:_placeHoderLab];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_inputTextView.right + 8, 0, MainScreenWidth - (_inputTextView.right + 8), CommenViewHeight)];
    [_sendButton setTitle:SWNOTEmptyStr(_sendButtonTitle) ? _sendButtonTitle : @"发送" forState:0];
    _sendButton.titleLabel.font = SYSTEMFONT(16);
    [_sendButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    _placeHoderLab.hidden = YES;
    return YES;
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(judgeLogin)]) {
        [_delegate judgeLogin];
    } else {
        _placeHoderLab.hidden = YES;
        [_inputTextView becomeFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sendReplayMsg:)]) {
            [_delegate sendReplayMsg:self];
        }
        return NO;
    }
    return YES;
}

- (void)leftButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(commentLeftButtonClick:sender:)]) {
        [_delegate commentLeftButtonClick:self sender:sender];
    }
}

- (void)sendButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(sendReplayMsg:)]) {
        [_delegate sendReplayMsg:self];
    }
}

@end
