//
//  CourseCommentCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommentCell.h"

@implementation CourseCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _userFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 32, 32)];
    _userFace.layer.masksToBounds = YES;
    _userFace.layer.cornerRadius = _userFace.height / 2.0;
    _userFace.contentMode = UIViewContentModeScaleAspectFill;
    _userFace.backgroundColor = EdlineV5_Color.faildColor;
    [self addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 10, 0, 50, 20)];
    _nameLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.text = @"卡卡西";
    _nameLabel.centerY = _userFace.centerY;
    [self addSubview:_nameLabel];
    
    _scoreStar = [[StarEvaluator alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, 0, 76, 12)];
    _scoreStar.userInteractionEnabled = NO;
    _scoreStar.centerY = _userFace.centerY;
    [self addSubview:_scoreStar];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 50)];
    _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    _contentLabel.font = SYSTEMFONT(14);
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, 100, 20)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_timeLabel];
    
    NSString *commentCount = @"323";
    NSString *zanCount = @"1314";
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    _zanCountButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - zanWidth, _timeLabel.top, zanWidth, 20)];
    [_zanCountButton setImage:Image(@"dianzan_icon") forState:0];
    [_zanCountButton setTitle:zanCount forState:0];
    [_zanCountButton setTitleColor:EdlineV5_Color.textzanColor forState:0];
    _zanCountButton.titleLabel.font = SYSTEMFONT(12);
    _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_zanCountButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_zanCountButton];
    
    _commentCountButton = [[UIButton alloc] initWithFrame:CGRectMake(_zanCountButton.left - 18 - commentWidth, _timeLabel.top, commentWidth, 20)];
    [_commentCountButton setImage:Image(@"comment_icon") forState:0];
    [_commentCountButton setTitle:commentCount forState:0];
    [_commentCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _commentCountButton.titleLabel.font = SYSTEMFONT(12);
    _commentCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _commentCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_commentCountButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentCountButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _timeLabel.bottom + 10, _contentLabel.width, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setCommentInfo:(NSDictionary *)info {
    [self setHeight:_lineView.bottom];
}

- (void)commentButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(replayComment:)]) {
        [_delegate replayComment:self];
    }
}

- (void)zanButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(zanComment:)]) {
        [_delegate zanComment:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
