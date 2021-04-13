//
//  QuestionAnswerReplyListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/13.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "QuestionAnswerReplyListCell.h"

@implementation QuestionAnswerReplyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        _cellType = cellType;
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
    _userFace.image = DefaultUserImage;
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
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom + 15, 100, 20)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(_timeLabel.right + 10, _timeLabel.top, 30, 20)];
    [_deleteButton setTitle:@"删除" forState:0];
    [_deleteButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _deleteButton.titleLabel.font = SYSTEMFONT(12);
    [self.contentView addSubview:_deleteButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, _timeLabel.bottom + 10, MainScreenWidth - _nameLabel.left - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setQuestionAnswerCommentInfo:(NSDictionary *)info showAllContent:(BOOL)showAllContent {
    _userCommentInfo = info;
    NSString *replayUsername = @"二狗子";
    NSString *replayUserId = @"1";
    _contentLabel.frame = CGRectMake(_nameLabel.left, _userFace.bottom + 3, MainScreenWidth - _nameLabel.left - 15, 50);
    _contentLabel.numberOfLines = 0;
    
    NSString *insertString = [NSString stringWithFormat:@"@%@",replayUsername];
    NSString *final = [NSString stringWithFormat:@"回复%@:%@",insertString,@":用户回复评论用户回复评论用户回复评论用户回复评论？"];
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
    attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30, 1))];
    [_contentLabel setHeight:_contentLabel.textContainer.textHeight];
    [attStringCreater addTextStorageArray:@[textStorage]];
    
    [_timeLabel setTop:_contentLabel.bottom + 15];
    CGFloat timeWidth = [_timeLabel.text sizeWithFont:_timeLabel.font].width;
    [_timeLabel setWidth:timeWidth];
    
    _deleteButton.frame = CGRectMake(_timeLabel.right + 10, _timeLabel.top, 30, 20);
    
    [_lineView setTop:_timeLabel.bottom + 10];
    /**
    if (SWNOTEmptyDictionary(info)) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"nick_name"]];
        if (SWNOTEmptyStr([info objectForKey:@"avatar_url"])) {
            [_userFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"avatar_url"]) placeholderImage:DefaultUserImage];
        } else {
            _userFace.image = DefaultUserImage;
        }
        CGFloat nameWidth = [_nameLabel.text sizeWithFont:_nameLabel.font].width + 4;
        [_nameLabel setWidth:nameWidth];
        NSString *replayUsername = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[info objectForKey:@"reply_user"]]];
        NSString *replayUserId = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[info objectForKey:@"reply_user_id"]]];
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
        attStringCreater = [attStringCreater createTextContainerWithTextWidth:CGRectGetWidth(CGRectMake(20.0, 25.0, MainScreenWidth - 30, 1))];
        [_contentLabel setHeight:_contentLabel.textContainer.textHeight];
        [attStringCreater addTextStorageArray:@[textStorage]];
        
        [_pictureViews removeAllSubviews];
        NSInteger picCount = 5;
        CGFloat leftSpace = _nameLabel.left;
        CGFloat inSpace = 11;
        CGFloat picWidth = (MainScreenWidth - leftSpace - 15 - inSpace * 2) / 3.0;
        
        if (picCount) {
            [_pictureViews setTop:_contentLabel.bottom + 12];
        } else {
            [_pictureViews setTop:_contentLabel.bottom];
        }
        
        for (int i = 0; i<picCount; i++) {
            // x 余 y 正
            UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace + (picWidth + inSpace) * (i%3), (inSpace + picWidth) * (i/3), picWidth, picWidth)];
            pic.clipsToBounds = YES;
            pic.contentMode = UIViewContentModeScaleAspectFill;
            pic.image = DefaultImage;
            pic.tag = 66 + i;
            pic.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailPicTap:)];
//            [pic addGestureRecognizer:tap];
            [_pictureViews addSubview:pic];
            if (i == (picCount - 1)) {
                [_pictureViews setHeight:pic.bottom];
            }
        }
        
        [_timeLabel setTop:_contentLabel.bottom + 15];
        _timeLabel.text = [EdulineV5_Tool formateTime:[NSString stringWithFormat:@"%@",[info objectForKey:@"create_time"]]];
        
        _deleteButton.frame = CGRectMake(_timeLabel.right + 10, _timeLabel.top, 30, 20);
        
        [_lineView setTop:_timeLabel.bottom + 10];
    }
    */
    [self setHeight:_lineView.bottom];
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
