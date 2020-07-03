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
    [self addSubview:_userFace];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.right + 15, _userFace.top, 200, _userFace.height)];
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_nameLabel];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 32)];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_themeLabel];
    
    _redView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 15 + 12, 8, 8)];
    _redView.layer.masksToBounds = YES;
    _redView.layer.cornerRadius = 4;
    _redView.backgroundColor = EdlineV5_Color.faildColor;
    [self addSubview:_redView];
    
    _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_userFace.left, _userFace.bottom + 15, MainScreenWidth - _userFace.left - 15, 50)];
    _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
    _contentLabel.textColor = EdlineV5_Color.textSecendColor;
    _contentLabel.font = SYSTEMFONT(13);
    _contentLabel.numberOfLines = 0;
    _contentLabel.delegate = self;
    [self addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFace.left, _contentLabel.bottom + 15, 100, 20)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_userFace.left, _timeLabel.bottom + 10, MainScreenWidth - _userFace.left, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setMessageInfo:(NSDictionary *)info {
    _currentMessageInfo = info;
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
