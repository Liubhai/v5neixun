//
//  MessageListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _userFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
    _userFace.layer.masksToBounds = YES;
    _userFace.layer.cornerRadius = _userFace.height / 2.0;
    _userFace.clipsToBounds = YES;
    _userFace.contentMode = UIViewContentModeScaleAspectFill;
    _userFace.image = DefaultUserImage;
    [self.contentView addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 15, _userFace.top, 200, _userFace.height)];
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_nameLabel];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 32)];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_themeLabel];
    
    _redView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 15 + 12, 8, 8)];
    _redView.layer.masksToBounds = YES;
    _redView.layer.cornerRadius = 4;
    _redView.backgroundColor = EdlineV5_Color.faildColor;
    [self.contentView addSubview:_redView];
    
    _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_userFace.left, _userFace.bottom + 15, MainScreenWidth - _userFace.left - 15, 50)];
    _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
    _contentLabel.textColor = EdlineV5_Color.textSecendColor;
    _contentLabel.font = SYSTEMFONT(15);
    _contentLabel.numberOfLines = 0;
    _contentLabel.delegate = self;
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.left, _contentLabel.bottom + 15, 100, 20)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_userFace.left, _timeLabel.bottom + 10, MainScreenWidth - _userFace.left, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setMessageInfo:(NSDictionary *)info typeString:(nonnull NSString *)typeS {
    
    if ([typeS isEqualToString:@"course"] || [typeS isEqualToString:@"system"]) {
        _userFace.hidden = YES;
        _nameLabel.hidden = YES;
        _themeLabel.hidden = NO;
        _themeLabel.text = [NSString stringWithFormat:@"%@",info[@"title"]];
    } else {
        _userFace.hidden = NO;
        _nameLabel.hidden = NO;
        _themeLabel.hidden = YES;
        [_userFace sd_setImageWithURL:EdulineUrlString(info[@"send_user_avatar_url"]) placeholderImage:DefaultUserImage];
        _nameLabel.text = [NSString stringWithFormat:@"%@",info[@"send_user_nick_name"]];
    }
    
    _redView.hidden = [[NSString stringWithFormat:@"%@",info[@"is_read"]] boolValue];
    
    _currentMessageInfo = info;
    if ([typeS isEqualToString:@"system"]) {
        if ([info[@"is_link"] boolValue]) {
            _contentLabel.text = [NSString stringWithFormat:@"%@",info[@"content"]];
            _contentLabel.frame = CGRectMake(_userFace.left, _userFace.bottom + 15, MainScreenWidth - _userFace.left - 15, 50);
            _contentLabel.numberOfLines = 0;
            [_contentLabel sizeToFit];
            [_contentLabel setHeight:_contentLabel.height];
        } else {
            _contentLabel.text = [NSString stringWithFormat:@"%@",info[@"content"]];
            _contentLabel.frame = CGRectMake(_userFace.left, _userFace.bottom + 15, MainScreenWidth - _userFace.left - 15, 50);
            _contentLabel.numberOfLines = 0;
            _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [_contentLabel sizeToFit];
            if (_contentLabel.height > 45) {
                [_contentLabel setHeight:45];
            } else {
                [_contentLabel setHeight:_contentLabel.height];
            }
        }
    } else {
        _contentLabel.text = [NSString stringWithFormat:@"%@",info[@"content"]];
        _contentLabel.frame = CGRectMake(_userFace.left, _userFace.bottom + 15, MainScreenWidth - _userFace.left - 15, 50);
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
        [_contentLabel setHeight:_contentLabel.height];
    }
    
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeForYYYYMMDD:[NSString stringWithFormat:@"%@",info[@"create_time"]]]];
    _timeLabel.frame = CGRectMake(_userFace.left, _contentLabel.bottom + 15, 100, 20);
    
    _lineView.frame = CGRectMake(_userFace.left, _timeLabel.bottom + 10, MainScreenWidth - _userFace.left, 1);
    
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
