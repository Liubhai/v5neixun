//
//  CircleDetailCommentCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/31.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CircleDetailCommentCell.h"
#import "V5_UserModel.h"

@implementation CircleDetailCommentCell

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
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userfaceTap)];
    [_userFace addGestureRecognizer:faceTap];
    [self.contentView addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 10, 0, 50, 20)];
    _nameLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.text = @"卡卡西";
    _nameLabel.centerY = _userFace.centerY;
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 50)];
    _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    _contentLabel.font = SYSTEMFONT(14);
    _contentLabel.numberOfLines = 0;
    _contentLabel.delegate = self;
    [self.contentView addSubview:_contentLabel];
    
    _pictureBackView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, _contentLabel.width, 0.01)];
    [self.contentView addSubview:_pictureBackView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _pictureBackView.bottom + 15, 100, 20)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _timeLabel.top, 30, _timeLabel.height)];
    [_deleteButton setTitle:@"删除" forState:0];
    [_deleteButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _deleteButton.titleLabel.font = SYSTEMFONT(12);
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    NSString *zanCount = @"1314";
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    _zanCountButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - zanWidth, _timeLabel.top, zanWidth, 20)];
    [_zanCountButton setImage:Image(@"dianzan_icon") forState:0];
    [_zanCountButton setTitle:zanCount forState:0];
    [_zanCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _zanCountButton.titleLabel.font = SYSTEMFONT(12);
    _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_zanCountButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_zanCountButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _timeLabel.bottom + 10, MainScreenWidth - _nameLabel.left - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setCommentInfo:(NSDictionary *)info circle_userId:(NSString *)circle_userId {
    _userCommentInfo = info;
    _deleteButton.hidden = YES;
    if (SWNOTEmptyDictionary(info)) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"nick_name"]];
        if (SWNOTEmptyStr([info objectForKey:@"avatar_url"])) {
            [_userFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"avatar_url"]) placeholderImage:DefaultUserImage];
        } else {
            _userFace.image = DefaultUserImage;
        }
        CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
        [_nameLabel setWidth:nameWidth];
        NSString *replayUsername = [NSString stringWithFormat:@"%@",[info objectForKey:@"reply_user_name"]];
        NSString *replayUserId = [NSString stringWithFormat:@"%@",[info objectForKey:@"reply_user_id"]];
        if ([replayUserId isEqualToString:@"0"] || [replayUserId isEqualToString:@"<null>"] || ![info objectForKey:@"reply_user_id"]) {
            _contentLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"content"]];
            _contentLabel.frame = CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 50);
            _contentLabel.numberOfLines = 0;
            [_contentLabel sizeToFit];
            [_contentLabel setHeight:_contentLabel.height];
        } else {
            _contentLabel.frame = CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 50);
            _contentLabel.numberOfLines = 0;
            
            NSString *insertString = [NSString stringWithFormat:@"@%@",replayUsername];
            NSString *final = [NSString stringWithFormat:@"回复%@:%@",insertString,[NSString stringWithFormat:@"%@",[info objectForKey:@"content"]]];
            TYLinkTextStorage *textStorage = [[TYLinkTextStorage alloc]init];
            textStorage.textColor = HEXCOLOR(0x5191FF);
            textStorage.font = SYSTEMFONT(14);
            textStorage.linkData = @{@"type":@"user",@"userId":replayUserId};
            textStorage.underLineStyle = kCTUnderlineStyleNone;
            textStorage.range = [final rangeOfString:insertString];
            textStorage.text = insertString;
            
            // 属性文本生成器
            TYTextContainer *attStringCreater = [[TYTextContainer alloc]init];
            attStringCreater.text = final;
            _contentLabel.textContainer = attStringCreater;
            _contentLabel.textContainer.linesSpacing = 4;
            attStringCreater.font = SYSTEMFONT(13);
            attStringCreater.textAlignment = kCTTextAlignmentLeft;
            attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(_contentLabel.frame)];
            [_contentLabel setHeight:_contentLabel.textContainer.textHeight];
            [attStringCreater addTextStorageArray:@[textStorage]];
        }
        
        _pictureBackView.frame = CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, _contentLabel.width, 0.01);
        [_pictureBackView removeAllSubviews];
        NSArray *picArray = [NSArray arrayWithArray:[info objectForKey:@"attach_url"]];
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
        
        _timeLabel.text = [EdulineV5_Tool formateTime:[NSString stringWithFormat:@"%@",[info objectForKey:@"create_time"]]];
        CGFloat timeWidth = [_timeLabel.text sizeWithFont:_timeLabel.font].width + 10;
        _timeLabel.frame = CGRectMake(_nameLabel.left, _pictureBackView.bottom + 15, timeWidth, 20);
        
        [_deleteButton setLeft:_timeLabel.right];
        [_deleteButton setTop:_timeLabel.top];
        
        if (SWNOTEmptyStr([V5_UserModel oauthToken])) {
            if ([circle_userId isEqualToString:[V5_UserModel uid]]) {
                _deleteButton.hidden = NO;
            } else {
                NSString *comment_uid = [NSString stringWithFormat:@"%@",info[@"user_id"]];
                if ([comment_uid isEqualToString:[V5_UserModel uid]]) {
                    _deleteButton.hidden = NO;
                } else {
                    _deleteButton.hidden = YES;
                }
            }
        } else {
            _deleteButton.hidden = YES;
        }
        
        NSString *zanCount = [NSString stringWithFormat:@"%@",[info objectForKey:@"like_num"]];
        CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
        BOOL isZan = [[NSString stringWithFormat:@"%@",[info objectForKey:@"is_like"]] boolValue];
        CGFloat space = 2.0;
        _zanCountButton.frame = CGRectMake(MainScreenWidth - 15 - zanWidth, _timeLabel.top, zanWidth, 20);
        [_zanCountButton setImage:isZan ? Image(@"dianzan_icon") : Image(@"dianzan_icon_norm") forState:0];
        [_zanCountButton setTitle:zanCount forState:0];
        [_zanCountButton setTitleColor:isZan ? EdlineV5_Color.textzanColor : EdlineV5_Color.textThirdColor forState:0];
        _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
        _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        
        [_lineView setTop:_timeLabel.bottom + 10];
    }
    [self setHeight:_lineView.bottom];
}

- (void)zanButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(zanComment:)]) {
        [_delegate zanComment:self];
    }
}

- (void)picTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(showCircleDetailCommentPic:imagetag:toView:)]) {
        [_delegate showCircleDetailCommentPic:_userCommentInfo imagetag:tap.view.tag - 66 toView:tap.view];
    }
}

- (void)deleteButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteComment:)]) {
        [_delegate deleteComment:self];
    }
}

- (void)userfaceTap {
    if (_delegate && [_delegate respondsToSelector:@selector(circleDetailCommentUserFaceTapjump:)]) {
        [_delegate circleDetailCommentUserFaceTapjump:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
