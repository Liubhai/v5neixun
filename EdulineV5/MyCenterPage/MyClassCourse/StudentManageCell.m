//
//  StudentManageCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudentManageCell.h"
#import "V5_Constant.h"

@implementation StudentManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 57, 57)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = _faceImageView.height / 2.0;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.image = DefaultUserImage;
    [self addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _faceImageView.top + 5, MainScreenWidth - 15 - 55 - (_faceImageView.right + 15), 22)];
    _nameLabel.font = SYSTEMFONT(15);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_nameLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _faceImageView.bottom - 13, MainScreenWidth - 55 - 15 - (_faceImageView.right + 15), 13)];
    _introLabel.font = SYSTEMFONT(12);
    _introLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_introLabel];
    
//    _dateLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _introLabel.top - 5 - 13, MainScreenWidth - 55 - 15 - (_faceImageView.right + 15), 13)];
//    _dateLineLabel.font = SYSTEMFONT(12);
//    _dateLineLabel.textColor = EdlineV5_Color.textThirdColor;
//
//    [self addSubview:_dateLineLabel];
    
    _followButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 55, 0, 55, 21)];
    _followButton.centerY = _faceImageView.centerY;
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.cornerRadius = 2;
    _followButton.layer.borderWidth = 1;
    _followButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _followButton.titleLabel.font = SYSTEMFONT(11);
    [_followButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_followButton setTitle:@"移除" forState:0];
    [_followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 97 - 1, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setStudentInfo:(NSDictionary *)dict cellIndexPath:(NSIndexPath *)cellIndexPath {
    _cellIndex = cellIndexPath;
    [_faceImageView sd_setImageWithURL:EdulineUrlString([dict objectForKey:@"avatar_url"]) placeholderImage:DefaultImage];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",SWNOTEmptyStr([dict objectForKey:@"nick_name"]) ? [dict objectForKey:@"nick_name"] : @""];
    
    _introLabel.text = [NSString stringWithFormat:@"获取方式：%@",SWNOTEmptyStr([dict objectForKey:@"from_text"]) ? [dict objectForKey:@"from_text"] : @""];
}

- (void)followButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(removeStudent:)]) {
        [_delegate removeStudent:_cellIndex];
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
