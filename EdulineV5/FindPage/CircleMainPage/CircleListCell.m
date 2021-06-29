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
    _userFace.userInteractionEnabled = YES;
    UITapGestureRecognizer *facetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceAndNametap:)];
    [_userFace addGestureRecognizer:facetap];
    [self.contentView addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 10, _userFace.top, MainScreenWidth - (_userFace.right + 10) - 15 - 50, 15)];
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nametap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceAndNametap:)];
    [_nameLabel addGestureRecognizer:nametap];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom - 13, 100, 13)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _guanzhuButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 47, 0, 47, 21)];
    _guanzhuButton.layer.masksToBounds = YES;
    _guanzhuButton.layer.cornerRadius = 2;
    _guanzhuButton.centerY = _userFace.centerY;
    [_guanzhuButton setTitle:@"+ 关注" forState:0];
    [_guanzhuButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_guanzhuButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_guanzhuButton setTitleColor:EdlineV5_Color.textThirdColor forState:UIControlStateSelected];
    _guanzhuButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _guanzhuButton.layer.borderWidth = 1;
    _guanzhuButton.titleLabel.font = SYSTEMFONT(11);
    [_guanzhuButton addTarget:self action:@selector(guanzhuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_guanzhuButton];
    
    _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom + 15, MainScreenWidth - _nameLabel.left - 15, 50)];
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    _contentLabel.font = SYSTEMFONT(14);
    _contentLabel.numberOfLines = 0;
    _contentLabel.delegate = self;
    [self.contentView addSubview:_contentLabel];
    
    _pictureBackView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, _contentLabel.width, 0.01)];
    [self.contentView addSubview:_pictureBackView];
    
    // 转发
    _forwardBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _contentLabel.bottom, MainScreenWidth - 30, 0.01)];
    _forwardBackView.backgroundColor = EdlineV5_Color.backColor;
    _forwardBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *forwardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardBackViewtap:)];
    [_forwardBackView addGestureRecognizer:forwardTap];
    [self.contentView addSubview:_forwardBackView];
    
    _forwardContentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_nameLabel.left - 15, 15, _contentLabel.width, 50)];
    _forwardContentLabel.backgroundColor = EdlineV5_Color.backColor;
    _forwardContentLabel.textColor = EdlineV5_Color.textFirstColor;
    _forwardContentLabel.font = SYSTEMFONT(14);
    _forwardContentLabel.numberOfLines = 0;
    _forwardContentLabel.delegate = self;
    [_forwardBackView addSubview:_forwardContentLabel];
    
    _forwardPictureBackView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left - 15, _forwardContentLabel.bottom + 15, _forwardContentLabel.width, 0.01)];
    [_forwardBackView addSubview:_forwardPictureBackView];
    
    NSString *commentCount = @"323";
    NSString *zanCount = @"1314";
    NSString *shareCount = @"99";
    CGFloat shareWidth = [shareCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.left, _pictureBackView.bottom + 17, 30, 20)];
    [_deleteButton setTitle:@"删除" forState:0];
    [_deleteButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _deleteButton.titleLabel.font = SYSTEMFONT(12);
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    _deleteButton.hidden = YES;
    
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

- (void)setCircleCellInfo:(NSDictionary *)dict circleType:(nonnull NSString *)circleType isDetail:(BOOL)isDetail {
    _userCommentInfo = dict;
    [_userFace sd_setImageWithURL:EdulineUrlString(dict[@"avatar_url"]) placeholderImage:DefaultUserImage];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"nick_name"]];
    _timeLabel.text = [EdulineV5_Tool formatterDate:[NSString stringWithFormat:@"%@",dict[@"create_time"]]];
    _guanzhuButton.selected = [[NSString stringWithFormat:@"%@",dict[@"followed"]] boolValue];
    _guanzhuButton.layer.borderColor = _guanzhuButton.selected ? EdlineV5_Color.textThirdColor.CGColor : EdlineV5_Color.themeColor.CGColor;
    
    NSString *user_id = [NSString stringWithFormat:@"%@",dict[@"user_id"]];
    if ([circleType isEqualToString:@"3"]) {
        _guanzhuButton.hidden = YES;
    } else {
        if ([user_id isEqualToString:[V5_UserModel uid]]) {
            _guanzhuButton.hidden = YES;
        } else {
            _guanzhuButton.hidden = NO;
        }
    }
    
    _contentLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    _contentLabel.frame = CGRectMake(_nameLabel.left, _userFace.bottom + 15, MainScreenWidth - _nameLabel.left - 15, 50);
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    
    [_contentLabel setHeight:_contentLabel.height];
    
    CGFloat bottomToolTop = 0;
    NSString *orignal_id = [NSString stringWithFormat:@"%@",dict[@"orignal_id"]];
    
    _pictureBackView.frame = CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, _contentLabel.width, 0.01);
    _pictureBackView.hidden = NO;
    [_pictureBackView removeAllSubviews];
    
    _forwardBackView.frame = CGRectMake(15, _contentLabel.bottom, MainScreenWidth - 30, 0.01);
    _forwardBackView.hidden = NO;
    
    if (!SWNOTEmptyStr(orignal_id) || [orignal_id isEqualToString:@"0"] || [orignal_id isEqualToString:@"<null>"] || [orignal_id isEqualToString:@"null"]) {
        // 不是转发
        
        //处理转发视图 隐藏 高度
        _forwardBackView.hidden = YES;
        [_forwardContentLabel setHeight:0.01];
        _forwardContentLabel.hidden = YES;
        [_forwardPictureBackView removeAllSubviews];
        [_forwardPictureBackView setHeight:0.01];
        _forwardPictureBackView.hidden = YES;
        
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
        bottomToolTop = _pictureBackView.bottom + 17;
    } else {
        // 是动态转发
        
        // 处理 _pictureBackView 视图高度 隐藏
        [_pictureBackView setHeight:0.01];
        _pictureBackView.hidden = YES;
        
        _forwardBackView.frame = CGRectMake(15, _contentLabel.bottom, MainScreenWidth - 30, 0.01);
        
        // 处理 转发板块儿的视图
        // 文本
        _forwardContentLabel.frame = CGRectMake(_nameLabel.left - 15, 15, _contentLabel.width, 50);
        _forwardContentLabel.hidden = NO;
        _forwardContentLabel.numberOfLines = 0;
        NSString *orignal_user = [NSString stringWithFormat:@"@%@",dict[@"orignal_user"]];
        NSString *orignal_content = [NSString stringWithFormat:@"%@",dict[@"orignal_content"]];
        _forwardContentLabel.text = [NSString stringWithFormat:@"%@：%@",orignal_user,orignal_content];
        [_forwardContentLabel addLinkWithLinkData:@{@"orignal_user":orignal_user} linkColor:HEXCOLOR(0x5191FF) underLineStyle:kCTUnderlineStyleNone range:NSMakeRange(0, orignal_user.length)];
        [_forwardContentLabel sizeToFit];
        
        [_forwardContentLabel setHeight:_forwardContentLabel.height];
        
        // 图片
        _forwardPictureBackView.frame = CGRectMake(_nameLabel.left - 15, _forwardContentLabel.bottom + 15, _forwardContentLabel.width, 0.01);
        [_forwardPictureBackView removeAllSubviews];
        _forwardPictureBackView.hidden = NO;
        
        // 转发被删除
        if (!SWNOTEmptyStr(dict[@"orignal_user"]) || [dict[@"orignal_user"] isEqualToString:@"<null>"] || [dict[@"orignal_user"] isEqualToString:@"null"]) {
            [_forwardBackView setHeight:53];
            _forwardContentLabel.frame = CGRectMake(_nameLabel.left - 15, 0, _contentLabel.width, 53);
            _forwardContentLabel.text = @"该内容已被删除，无法查看。";
            [_forwardContentLabel sizeToFit];
            [_forwardContentLabel setCenterY:_forwardBackView.height / 2.0];
            _forwardPictureBackView.hidden = YES;
            bottomToolTop = _forwardBackView.bottom + 17;
        } else {
            NSArray *picArray;
            if (SWNOTEmptyArr([dict objectForKey:@"orignal_attach"])) {
                picArray = [NSArray arrayWithArray:[dict objectForKey:@"orignal_attach"]];
            } else {
                picArray = [NSArray new];
            }
            CGFloat leftSpace = 0;
            CGFloat inSpace = 11;
            CGFloat picWidth = (_forwardContentLabel.width - leftSpace * 2 - inSpace * 2) / 3.0;
            
            if (picArray.count) {
                [_forwardPictureBackView setTop:_forwardContentLabel.bottom + 12];
            } else {
                [_forwardPictureBackView setTop:_forwardContentLabel.bottom];
            }
            
            for (int i = 0; i<picArray.count; i++) {
                // x 余 y 正
                UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace + (picWidth + inSpace) * (i%3), (inSpace + picWidth) * (i/3), picWidth, picWidth)];
                pic.clipsToBounds = YES;
                pic.contentMode = UIViewContentModeScaleAspectFill;
                [pic sd_setImageWithURL:EdulineUrlString(picArray[i]) placeholderImage:DefaultImage];
                [_forwardPictureBackView addSubview:pic];
                if (i == (picArray.count - 1)) {
                    [_forwardPictureBackView setHeight:pic.bottom];
                }
            }
            [_forwardBackView setHeight:_forwardPictureBackView.bottom + 15];
            bottomToolTop = _forwardBackView.bottom + 17;
        }
    }
    
    _deleteButton.frame = CGRectMake(_contentLabel.left, bottomToolTop, 30, 20);
    if (isDetail) {
        if ([user_id isEqualToString:[V5_UserModel uid]]) {
            _deleteButton.hidden = NO;
        } else {
            _deleteButton.hidden = YES;
        }
    } else {
        _deleteButton.hidden = YES;
    }
    
    NSString *commentCount = [NSString stringWithFormat:@"%@",dict[@"comment_num"]];
    NSString *zanCount = [NSString stringWithFormat:@"%@",dict[@"like_num"]];
    NSString *shareCount = [NSString stringWithFormat:@"%@",dict[@"recircle_num"]];
    CGFloat shareWidth = [shareCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _shareButton.frame = CGRectMake(_contentLabel.left, bottomToolTop, shareWidth, 20);
    [_shareButton setImage:Image(@"circle_share_icon") forState:0];
    [_shareButton setTitle:shareCount forState:0];
    [_shareButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _shareButton.titleLabel.font = SYSTEMFONT(12);
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [self.contentView addSubview:_shareButton];
    
    _zanCountButton.frame = CGRectMake(MainScreenWidth - 15 - zanWidth, bottomToolTop, zanWidth, 20);
    [_zanCountButton setImage:Image(@"dianzan_icon_norm") forState:0];
    [_zanCountButton setImage:Image(@"dianzan_icon") forState:UIControlStateSelected];
    [_zanCountButton setTitle:zanCount forState:0];
    [_zanCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [_zanCountButton setTitleColor:EdlineV5_Color.faildColor forState:UIControlStateSelected];
    _zanCountButton.titleLabel.font = SYSTEMFONT(12);
    _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [self.contentView addSubview:_zanCountButton];
    _zanCountButton.selected = [[NSString stringWithFormat:@"%@",dict[@"is_like"]] boolValue];
    
    _commentCountButton.frame = CGRectMake(0, _zanCountButton.top, commentWidth, 20);
    [_commentCountButton setImage:Image(@"comment_icon") forState:0];
    [_commentCountButton setTitle:commentCount forState:0];
    [_commentCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _commentCountButton.titleLabel.font = SYSTEMFONT(12);
    _commentCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _commentCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    _commentCountButton.centerX = _contentLabel.left + _contentLabel.width / 2.0;
    [self.contentView addSubview:_commentCountButton];
    
    if (isDetail) {
        _commentCountButton.hidden = YES;
        _shareButton.centerX = _contentLabel.left + _contentLabel.width / 2.0;
    } else {
        _commentCountButton.hidden = NO;
        [_shareButton setLeft:_contentLabel.left];
    }
    
    _lineView.frame = CGRectMake(0, _shareButton.bottom + 10, MainScreenWidth, 1);
    
    [self setHeight:_lineView.bottom];
}

- (void)deleteButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCircleClick:)]) {
        [_delegate deleteCircleClick:self];
    }
}

- (void)commentButtonClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(replayComment:)]) {
//        [_delegate replayComment:self];
//    }
}

- (void)zanButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(likeCircleClick:)]) {
        [_delegate likeCircleClick:self];
    }
}

- (void)shareButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(shareCircleClick:)]) {
        [_delegate shareCircleClick:self];
    }
}

- (void)guanzhuButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(followUser:)]) {
        [_delegate followUser:self];
    }
}

- (void)picTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(showCirclePic:imagetag:toView:)]) {
        [_delegate showCirclePic:_userCommentInfo imagetag:tap.view.tag - 66 toView:tap.view];
    }
}

- (void)faceAndNametap:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToUserHomePage:)]) {
        [_delegate goToUserHomePage:self];
    }
}

- (void)forwardBackViewtap:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToForwarOriginCircleDetailVC:)]) {
        [_delegate jumpToForwarOriginCircleDetailVC:self];
    }
}

@end
