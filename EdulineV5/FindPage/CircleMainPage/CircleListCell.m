//
//  CircleListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CircleListCell.h"

@implementation CircleListCell

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
    [self.contentView addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 10, _userFace.top, 150, 15)];
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.text = @"卡卡西";
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom - 13, 100, 13)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _guanzhuButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 47, 0, 47, 21)];
    _guanzhuButton.layer.masksToBounds = YES;
    _guanzhuButton.layer.cornerRadius = 2;
    _guanzhuButton.centerY = _userFace.centerY;
    [_guanzhuButton setTitle:@"+ 关注" forState:0];
    [_guanzhuButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _guanzhuButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _guanzhuButton.layer.borderWidth = 1;
    _guanzhuButton.titleLabel.font = SYSTEMFONT(11);
    [self.contentView addSubview:_guanzhuButton];
    
    _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom + 15, MainScreenWidth - _nameLabel.left - 15, 50)];
    _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    _contentLabel.font = SYSTEMFONT(14);
    _contentLabel.numberOfLines = 0;
    _contentLabel.delegate = self;
    [self.contentView addSubview:_contentLabel];
    
    _pictureBackView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, _contentLabel.width, 0.01)];
    [self.contentView addSubview:_pictureBackView];
    
    NSString *commentCount = @"323";
    NSString *zanCount = @"1314";
    NSString *shareCount = @"99";
    CGFloat shareWidth = [shareCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.left, _pictureBackView.bottom + 17, shareWidth, 20)];
    [_shareButton setImage:Image(@"circle_share_icon") forState:0];
    [_shareButton setTitle:shareCount forState:0];
    [_shareButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _shareButton.titleLabel.font = SYSTEMFONT(12);
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shareButton];
    
    _zanCountButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - zanWidth, _pictureBackView.bottom + 17, zanWidth, 20)];
    [_zanCountButton setImage:Image(@"dianzan_icon") forState:0];
    [_zanCountButton setTitle:zanCount forState:0];
    [_zanCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _zanCountButton.titleLabel.font = SYSTEMFONT(12);
    _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_zanCountButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_zanCountButton];
    
    _commentCountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _zanCountButton.top, commentWidth, 20)];
    [_commentCountButton setImage:Image(@"comment_icon") forState:0];
    [_commentCountButton setTitle:commentCount forState:0];
    [_commentCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _commentCountButton.titleLabel.font = SYSTEMFONT(12);
    _commentCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _commentCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_commentCountButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _commentCountButton.centerX = _contentLabel.left + _contentLabel.width / 2.0;
    [self.contentView addSubview:_commentCountButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _shareButton.bottom + 10, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setCircleCellInfo:(NSDictionary *)dict {
    _userCommentInfo = dict;
    [_userFace sd_setImageWithURL:EdulineUrlString(dict[@"avatar"]) placeholderImage:DefaultUserImage];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"create_time"]];
    _timeLabel.text = [EdulineV5_Tool formatterDate:[NSString stringWithFormat:@"%@",dict[@"create_time"]]];
    
    _contentLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    _contentLabel.frame = CGRectMake(_nameLabel.left, _userFace.bottom + 15, MainScreenWidth - _nameLabel.left - 15, 50);
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    
    [_contentLabel setHeight:_contentLabel.height];
    
    
    _pictureBackView.frame = CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, _contentLabel.width, 0.01);
    [_pictureBackView removeAllSubviews];
    NSArray *picArray = [NSArray arrayWithArray:[dict objectForKey:@"attach_url"]];
    CGFloat leftSpace = 0;
    CGFloat inSpace = 11;
    CGFloat picWidth = (_contentLabel.width - leftSpace * 2 - inSpace * 2) / 3.0;
    
    if (picArray.count) {
        [_pictureBackView setTop:_contentLabel.bottom + 12];
    } else {
        [_pictureBackView setTop:_contentLabel.bottom];
    }
    
    for (int i = 0; i<picArray.count; i++) {
        // x 余 y 正
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace + (picWidth + inSpace) * (i%3), (inSpace + picWidth) * (i/3), picWidth, picWidth)];
        pic.clipsToBounds = YES;
        pic.contentMode = UIViewContentModeScaleAspectFill;
        [pic sd_setImageWithURL:EdulineUrlString(picArray[i]) placeholderImage:DefaultImage];
        pic.tag = 66 + i;
        pic.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)];
        [pic addGestureRecognizer:tap];
        [_pictureBackView addSubview:pic];
        if (i == (picArray.count - 1)) {
            [_pictureBackView setHeight:pic.bottom];
        }
    }
    
    NSString *commentCount = [NSString stringWithFormat:@"%@",dict[@"comment_num"]];
    NSString *zanCount = [NSString stringWithFormat:@"%@",dict[@"like_num"]];
    NSString *shareCount = [NSString stringWithFormat:@"%@",dict[@"recircle_num"]];
    CGFloat shareWidth = [shareCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _shareButton.frame = CGRectMake(_contentLabel.left, _pictureBackView.bottom + 17, shareWidth, 20);
    [_shareButton setImage:Image(@"circle_share_icon") forState:0];
    [_shareButton setTitle:shareCount forState:0];
    [_shareButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _shareButton.titleLabel.font = SYSTEMFONT(12);
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [self.contentView addSubview:_shareButton];
    
    _zanCountButton.frame = CGRectMake(MainScreenWidth - 15 - zanWidth, _pictureBackView.bottom + 17, zanWidth, 20);
    [_zanCountButton setImage:Image(@"dianzan_icon") forState:0];
    [_zanCountButton setTitle:zanCount forState:0];
    [_zanCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _zanCountButton.titleLabel.font = SYSTEMFONT(12);
    _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [self.contentView addSubview:_zanCountButton];
    
    _commentCountButton.frame = CGRectMake(0, _zanCountButton.top, commentWidth, 20);
    [_commentCountButton setImage:Image(@"comment_icon") forState:0];
    [_commentCountButton setTitle:commentCount forState:0];
    [_commentCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _commentCountButton.titleLabel.font = SYSTEMFONT(12);
    _commentCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _commentCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    _commentCountButton.centerX = _contentLabel.left + _contentLabel.width / 2.0;
    [self.contentView addSubview:_commentCountButton];
    
    _lineView.frame = CGRectMake(0, _shareButton.bottom + 10, MainScreenWidth, 1);
    
    [self setHeight:_lineView.bottom];
}

- (void)commentButtonClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(replayComment:)]) {
//        [_delegate replayComment:self];
//    }
}

- (void)zanButtonClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(zanComment:)]) {
//        [_delegate zanComment:self];
//    }
}

- (void)shareButtonClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(editContent:)]) {
//        [_delegate editContent:self];
//    }
}

- (void)picTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(showCirclePic:imagetag:toView:)]) {
        [_delegate showCirclePic:_userCommentInfo imagetag:tap.view.tag - 66 toView:tap.view];
    }
}

@end
