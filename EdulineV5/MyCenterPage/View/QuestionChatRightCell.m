//
//  QuestionChatRightCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "QuestionChatRightCell.h"
#import "V5_Constant.h"

@implementation QuestionChatRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 36, 0, 36, 36)];
    _faceImage.clipsToBounds = YES;
    _faceImage.contentMode = UIViewContentModeScaleAspectFill;
    _faceImage.layer.masksToBounds = YES;
    _faceImage.layer.cornerRadius = _faceImage.height / 2.0;
    [self.contentView addSubview:_faceImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.left - 12 - 200, _faceImage.top, 200, 30)];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameLabel.font = SYSTEMFONT(13);
    [self.contentView addSubview:_nameLabel];
    
    _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(_faceImage.left - 12 - 182, _nameLabel.bottom + 5, questionChatContentWidth, 43)];
    _contentBackView.layer.masksToBounds = YES;
    _contentBackView.layer.cornerRadius = 5;
    _contentBackView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentBackView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.left - 12 - 12 - (questionChatContentWidth - 24), _nameLabel.bottom + 5 + 12, questionChatContentWidth - 24, 19)];
    _contentLabel.font = SYSTEMFONT(14);
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_contentLabel];
}

- (void)setQuestionChatRightInfo:(NSDictionary *)info {
    [_faceImage sd_setImageWithURL:EdulineUrlString(info[@"avatar_url"]) placeholderImage:DefaultUserImage];
    _nameLabel.text = [NSString stringWithFormat:@"%@",info[@"nick_name"]];
    
    _contentLabel.frame = CGRectMake(_faceImage.left - 12 - 12 - (questionChatContentWidth - 24), _nameLabel.bottom + 5 + 12, questionChatContentWidth - 24, 19);
    _contentLabel.text = [NSString stringWithFormat:@"%@",info[@"content"]];
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:_contentLabel.height];
    [_contentLabel setRight:_faceImage.left - 12 - 12];
    [_contentBackView setHeight:_contentLabel.height + 24];
    [_contentBackView setWidth:_contentLabel.width + 24];
    [_contentBackView setRight:_faceImage.left - 12];
    
    [self setHeight:_contentBackView.bottom + 20];
}

- (void)setQuestionChatRightModel:(MessageInfoModel *)info {
    _faceImage.image = DefaultUserImage;
    _nameLabel.text = [NSString stringWithFormat:@"%@",info.userName];
    
    _contentLabel.frame = CGRectMake(_faceImage.left - 12 - 12 - (questionChatContentWidth - 24), _nameLabel.bottom + 5 + 12, questionChatContentWidth - 24, 19);
    _contentLabel.text = [NSString stringWithFormat:@"%@",info.message];
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:_contentLabel.height];
    [_contentLabel setRight:_faceImage.left - 12 - 12];
    [_contentBackView setHeight:_contentLabel.height + 24];
    [_contentBackView setWidth:_contentLabel.width + 24];
    [_contentBackView setRight:_faceImage.left - 12];
    
    [self setHeight:_contentBackView.bottom + 20];
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
