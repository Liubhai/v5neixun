//
//  CourseCommentTopView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommentTopView.h"

// 24 + 18 = 42
@implementation CourseCommentTopView

- (instancetype)initWithFrame:(CGRect)frame commentOrRecord:(BOOL)commentOrRecord{
    self = [super initWithFrame:frame];
    if (self) {
        _commentOrRecord = commentOrRecord;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _courseScore = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 40, 22)];
    _courseScore.text = @"4.1分";
    _courseScore.textColor = EdlineV5_Color.textzanColor;
    _courseScore.font = SYSTEMFONT(15);
    [self addSubview:_courseScore];
    
    /** 不带边框星星 **/
    _courseStar = [[StarEvaluator alloc] initWithFrame:CGRectMake(_courseScore.right + 3, _courseScore.top, 116, 20)];
    _courseStar.centerY = _courseScore.centerY;
    [self addSubview:_courseStar];
    _courseStar.userInteractionEnabled = NO;
    [_courseStar setStarValue:4.1];
    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 60, 18, 60, 24)];
    _commentButton.titleLabel.font = SYSTEMFONT(14);
    [_commentButton setTitle:@"点评" forState:0];
    [_commentButton setTitleColor:EdlineV5_Color.textzanColor forState:0];
    _commentButton.layer.masksToBounds = YES;
    _commentButton.layer.cornerRadius = 12;
    _commentButton.layer.borderColor = EdlineV5_Color.textzanColor.CGColor;
    _commentButton.layer.borderWidth = 1.0;
    [_commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 58, 22, 58, 20)];
    _showLabel.text = @"只看我的";
    _showLabel.font = SYSTEMFONT(14);
    _showLabel.textColor = EdlineV5_Color.textSecendColor;
    CGFloat showLabelWidth = [_showLabel.text sizeWithFont:_showLabel.font].width + 4;
    [_showLabel setRight:MainScreenWidth - 15];
    [_showLabel setWidth:showLabelWidth];
    [self addSubview:_showLabel];
    
    _showOwnButton = [[UIButton alloc] initWithFrame:CGRectMake(_showLabel.left - 8 - 15, 0, 15, 15)];
    [_showOwnButton setImage:Image(@"checkbox_nor") forState:0];
    [_showOwnButton setImage:[Image(@"checkbox_sel1") converToMainColor] forState:UIControlStateSelected];
    [_showOwnButton addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _showOwnButton.centerY = _showLabel.centerY;
    [self addSubview:_showOwnButton];
    
    _showLabel.hidden = YES;
    _showOwnButton.hidden = YES;
    if (_commentOrRecord) {
        _commentButton.hidden = YES;
        _courseStar.hidden = YES;
        _courseScore.hidden = YES;
        [_showOwnButton setLeft:15];
        [_showLabel setLeft:_showOwnButton.right + 8];
        _showLabel.hidden = NO;
        _showOwnButton.hidden = NO;
    }
}

- (void)setCourseCommentInfo:(NSDictionary *)info commentOrRecord:(BOOL)commentOrRecord {
    if (commentOrRecord) {
        _commentButton.hidden = YES;
        _courseStar.hidden = YES;
        _courseScore.hidden = YES;
        [_showOwnButton setLeft:15];
        [_showLabel setLeft:_showOwnButton.right + 8];
        _showLabel.hidden = NO;
        _showOwnButton.hidden = NO;
    } else {
        NSString *scoreCount = [NSString stringWithFormat:@"%@",[info objectForKey:@"star"]];
        _courseScore.text = [NSString stringWithFormat:@"%@分",scoreCount];
        [_courseStar setStarValue:[scoreCount floatValue]];
    }
}

- (void)seleteButtonClick:(UIButton *)sender {
    _showOwnButton.selected = !_showOwnButton.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(showOwnCommentList:)]) {
        [_delegate showOwnCommentList:sender];
    }
}

- (void)commentButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToCommentVC)]) {
        [_delegate jumpToCommentVC];
    }
}

- (void)changeCommentStatus:(BOOL)hasComment {
    _commentButton.hidden = hasComment;
    _showLabel.hidden = !hasComment;
    _showOwnButton.hidden = !hasComment;

}

@end
