//
//  CourseCommentCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommentCell.h"
#import "V5_UserModel.h"

@implementation CourseCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BOOL)cellType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _cellType = cellType;
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
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 10, 0, 50, 20)];
    _nameLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.text = @"卡卡西";
    _nameLabel.centerY = _userFace.centerY;
    [self.contentView addSubview:_nameLabel];
    
    _scoreStar = [[StarEvaluator alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, 0, 76, 12)];
    _scoreStar.userInteractionEnabled = NO;
    _scoreStar.centerY = _userFace.centerY;
    [self.contentView addSubview:_scoreStar];

    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(MainScreenWidth - 15 - 20, 0, 20, 20);
    _editButton.centerY = _nameLabel.centerY;
    [_editButton setImage:Image(@"home_edit_icon") forState:0];
    [_editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editButton];
    
    if (_cellType) {
        _scoreStar.hidden = YES;
        _commentCountButton.hidden = YES;
        _tokenLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 64)];
        _tokenLabel.font = SYSTEMFONT(14);
        _tokenLabel.text = @"我们可以使用以下方式来指定切断文本; 收起 我们可以使用以下方式来指定切断文本,弄啥呢大哥,一起上呀打死那个龟孙,我们可以使用以下方式来指定切断文本; 收起 我们可以使用以下方式来指定切断文本";
        _tokenLabel.numberOfLines = 4;
        [self addSeeMoreButtonInLabel:_tokenLabel];
        [self.contentView addSubview:_tokenLabel];
    } else {
        _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 50)];
        _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
        _contentLabel.textColor = EdlineV5_Color.textFirstColor;
        _contentLabel.font = SYSTEMFONT(14);
        _contentLabel.numberOfLines = 0;
        _contentLabel.delegate = self;
        [self.contentView addSubview:_contentLabel];
    }
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, (_cellType ? _tokenLabel.bottom : _contentLabel.bottom) + 15, 100, 20)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    NSString *commentCount = @"323";
    NSString *zanCount = @"1314";
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
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
    
    _commentCountButton = [[UIButton alloc] initWithFrame:CGRectMake(_zanCountButton.left - 18 - commentWidth, _timeLabel.top, commentWidth, 20)];
    [_commentCountButton setImage:Image(@"comment_icon") forState:0];
    [_commentCountButton setTitle:commentCount forState:0];
    [_commentCountButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _commentCountButton.titleLabel.font = SYSTEMFONT(12);
    _commentCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _commentCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_commentCountButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentCountButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _timeLabel.bottom + 10, MainScreenWidth - _nameLabel.left - 15, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setCommentInfo:(NSDictionary *)info showAllContent:(BOOL)showAllContent {
    _userCommentInfo = info;
    _editButton.hidden = YES;
    if (SWNOTEmptyDictionary(info)) {
        if (!(SWNOTEmptyDictionary([info objectForKey:@"user"]))) {
            [self setHeight:_lineView.bottom];
            return;
        }
        if (SWNOTEmptyDictionary([info objectForKey:@"user"])) {
            if ([[NSString stringWithFormat:@"%@",[[info objectForKey:@"user"] objectForKey:@"id"]] isEqualToString:[V5_UserModel uid]]) {
                _editButton.hidden = NO;
            }
        }
    }
    if (_cellType) {
        _commentCountButton.hidden = YES;
        _zanCountButton.hidden = YES;
        _scoreStar.hidden = YES;
        if (SWNOTEmptyDictionary(info)) {
            _nameLabel.text = [NSString stringWithFormat:@"%@",[[info objectForKey:@"user"] objectForKey:@"nick_name"]];
            if (SWNOTEmptyStr([[info objectForKey:@"user"] objectForKey:@"avatar_url"])) {
                [_userFace sd_setImageWithURL:EdulineUrlString([[info objectForKey:@"user"] objectForKey:@"avatar_url"]) placeholderImage:DefaultUserImage];
            } else {
                _userFace.image = DefaultUserImage;
            }
            
            CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
            if (nameWidth > (MainScreenWidth - _nameLabel.left - 15)) {
                nameWidth = MainScreenWidth - _nameLabel.left - 15;
            }
            [_nameLabel setWidth:nameWidth];
            _tokenLabel.frame = CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 64);
            _tokenLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"content"]];
            if (showAllContent) {
                _tokenLabel.numberOfLines = 0;
            } else {
                _tokenLabel.numberOfLines = 4;
            }
            [_tokenLabel sizeToFit];
            [_tokenLabel setHeight:_tokenLabel.height];
            
            [_timeLabel setTop:_tokenLabel.bottom + 15];
            _timeLabel.text = [EdulineV5_Tool formateTime:[NSString stringWithFormat:@"%@",[info objectForKey:@"create_time"]]];
            
            [_lineView setTop:_timeLabel.bottom + 10];
        }
    } else {
        _commentCountButton.hidden = NO;
        _zanCountButton.hidden = NO;
        _scoreStar.hidden = NO;
        if (SWNOTEmptyDictionary(info)) {
            _nameLabel.text = [NSString stringWithFormat:@"%@",[[info objectForKey:@"user"] objectForKey:@"nick_name"]];
            if (SWNOTEmptyStr([[info objectForKey:@"user"] objectForKey:@"avatar_url"])) {
                [_userFace sd_setImageWithURL:EdulineUrlString([[info objectForKey:@"user"] objectForKey:@"avatar_url"]) placeholderImage:DefaultUserImage];
            } else {
                _userFace.image = DefaultUserImage;
            }
            CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
            if (nameWidth > (MainScreenWidth - _nameLabel.left - (10 + 76 + 20 + 15))) {
                nameWidth = MainScreenWidth - _nameLabel.left - (10 + 76 + 20 + 15);
            }
            [_nameLabel setWidth:nameWidth];
            [_scoreStar setLeft:_nameLabel.right + 10];
            [_scoreStar setStarValue:[[NSString stringWithFormat:@"%@",[info objectForKey:@"star"]] floatValue]];
            NSString *replayUsername = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[info objectForKey:@"reply_user"]]];
            NSString *replayUserId = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[info objectForKey:@"reply_user_id"]]];
            if ([replayUserId isEqualToString:@"0"] || ![info objectForKey:@"reply_user_id"]) {
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
                textStorage.textColor = EdlineV5_Color.themeColor;
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
            
            
            [_timeLabel setTop:_contentLabel.bottom + 15];
            _timeLabel.text = [EdulineV5_Tool formateTime:[NSString stringWithFormat:@"%@",[info objectForKey:@"create_time"]]];
            
            NSString *commentCount = [NSString stringWithFormat:@"%@",[info objectForKey:@"reply_count"]];
            NSString *zanCount = [NSString stringWithFormat:@"%@",[info objectForKey:@"like_count"]];
            CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
            CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
            BOOL isZan = [[NSString stringWithFormat:@"%@",[info objectForKey:@"like"]] boolValue];
            CGFloat space = 2.0;
            _zanCountButton.frame = CGRectMake(MainScreenWidth - 15 - zanWidth, _timeLabel.top, zanWidth, 20);
            [_zanCountButton setImage:isZan ? Image(@"dianzan_icon") : Image(@"dianzan_icon_norm") forState:0];
            [_zanCountButton setTitle:zanCount forState:0];
            [_zanCountButton setTitleColor:isZan ? EdlineV5_Color.textzanColor : EdlineV5_Color.textThirdColor forState:0];
            _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            
            _commentCountButton.frame = CGRectMake(_zanCountButton.left - 18 - commentWidth, _timeLabel.top, commentWidth, 20);
            [_commentCountButton setTitle:commentCount forState:0];
            _commentCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            _commentCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            
            [_lineView setTop:_timeLabel.bottom + 10];
        }
    }
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

- (void)editButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(editContent:)]) {
        [_delegate editContent:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
 
- (void)addSeeMoreButtonInLabel:(YYLabel *)label {
    [label sizeToFit];
    CGFloat labelFourlineHeight = label.height;
    CGFloat labelHeight = [EdulineV5_Tool heightForString:label.text fontSize:label.font andWidth:label.width];
    
    [_tokenLabel setHeight:labelHeight>labelFourlineHeight ? labelFourlineHeight : labelHeight];
    label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName:SYSTEMFONT(14)}];
    NSString *moreString = @" 查看更多";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... %@", moreString]];
    NSRange expandRange = [text.string rangeOfString:moreString];
    
    [text addAttribute:NSForegroundColorAttributeName value:EdlineV5_Color.themeColor range:expandRange];
    [text addAttribute:NSForegroundColorAttributeName value:EdlineV5_Color.textFirstColor range:NSMakeRange(0, expandRange.location)];
    
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text setTextHighlight:hi range:[text.string rangeOfString:moreString]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(replayComment:)]) {
            [weakSelf.delegate replayComment:weakSelf];
        }
    };
    
    text.font = SYSTEMFONT(14);
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];

    NSAttributedString *truncationToken =[NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.font alignment:YYTextVerticalAlignmentTop];
    label.truncationToken = truncationToken;
}
 
- (NSAttributedString *)appendAttriStringWithFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    if ([_tokenLabel.attributedText.string containsString:@"收起"]) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
 
    
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击收起
        [weakSelf setLabelFrame:NO];
    };
    
    return append;
}
 
- (void)expandString {
    NSMutableAttributedString *attri = [_tokenLabel.attributedText mutableCopy];
    [attri appendAttributedString:[self appendAttriStringWithFont:attri.font]];
    _tokenLabel.attributedText = attri;
}
 
- (void)packUpString {
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *attri = [_tokenLabel.attributedText mutableCopy];
    NSRange range = [attri.string rangeOfString:appendText options:NSBackwardsSearch];
 
    if (range.location != NSNotFound) {
        [attri deleteCharactersInRange:range];
    }
 
    _tokenLabel.attributedText = attri;
}
 
 
- (void)setLabelFrame:(BOOL)isExpand {
    if (isExpand) {
        [self expandString];
        self.tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200);
    }
    else {
        [self packUpString];
        self.tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 30);
    }
}

- (void)changeZanButtonInfo:(NSString *)zanCount zanOrNot:(BOOL)zanOrNot {
    CGFloat zanWidth = [zanCount sizeWithFont:SYSTEMFONT(12)].width + 4 + 20;
    CGFloat space = 2.0;
    _zanCountButton.frame = CGRectMake(MainScreenWidth - 15 - zanWidth, _timeLabel.top, zanWidth, 20);
    [_zanCountButton setImage:zanOrNot ? Image(@"dianzan_icon") : Image(@"dianzan_icon_norm") forState:0];
    [_zanCountButton setTitle:zanCount forState:0];
    [_zanCountButton setTitleColor:zanOrNot ? EdlineV5_Color.textzanColor : EdlineV5_Color.textThirdColor forState:0];
    _zanCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _zanCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_commentCountButton setRight:_zanCountButton.left - 18];
}

// MARK: - TY
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    //非文本/比如表情什么的
    if (![textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        return;
    }
    id linkContain = ((TYLinkTextStorage *)textStorage).linkData;
    if ([linkContain isKindOfClass:[NSDictionary class]]) {
        NSString *typeS = [linkContain objectForKey:@"type"];
        if ([typeS isEqualToString:@"user"]) {
            NSLog(@" 点评回复点击用户名 %@",[linkContain objectForKey:@"userId"]);
        }
    }
}


@end
