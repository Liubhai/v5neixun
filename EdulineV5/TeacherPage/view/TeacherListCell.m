//
//  TeacherListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeacherListCell.h"
#import "V5_Constant.h"

@implementation TeacherListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 84, 112)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 2;
    [self addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _faceImageView.top + 5, MainScreenWidth - 15 - (_faceImageView.right + 15), 22)];
    _nameLabel.font = SYSTEMFONT(16);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_nameLabel];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _nameLabel.bottom + 13, MainScreenWidth - 15 - (_faceImageView.right + 15), 18)];
    _levelLabel.font = SYSTEMFONT(13);
    _levelLabel.textColor = EdlineV5_Color.textSecendColor;
    [self addSubview:_levelLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _levelLabel.bottom + 13, MainScreenWidth - 15 - (_faceImageView.right + 15), 18)];
    _introLabel.font = SYSTEMFONT(13);
    _introLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_introLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 152 - 1, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setTeacherListInfo:(NSDictionary *)info {
    
    _faceImageView.image = DefaultImage;
    
    _nameLabel.text = @"讲师";
    
    _levelLabel.text = @"高级讲师";
    
    NSString *intro = @"高级软件工程师 资深签约讲师深签约讲师深签约讲师";
    _introLabel.text = intro;
    _introLabel.numberOfLines = 0;
    [_introLabel sizeToFit];
    [_introLabel setHeight:_introLabel.height];
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