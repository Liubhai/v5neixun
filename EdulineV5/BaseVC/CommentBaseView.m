//
//  CommentBaseView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/18.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CommentBaseView.h"

@implementation CommentBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, (CommenViewHeight - CommentInputHeight) / 2.0, MainScreenWidth - 30, CommentInputHeight)];
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

@end
