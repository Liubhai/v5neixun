//
//  InstitutionListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionListCell.h"
#import "V5_Constant.h"

@implementation InstitutionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 70, 70)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 35;
    _faceImageView.layer.borderWidth = 2;
    _faceImageView.layer.borderColor = EdlineV5_Color.backColor.CGColor;
    [self addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 20, _faceImageView.top + 5, MainScreenWidth - 15 - (_faceImageView.right + 20), 22)];
    _nameLabel.font = SYSTEMFONT(16);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_nameLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 20, _nameLabel.bottom + 6, MainScreenWidth - 15 - (_faceImageView.right + 20), 18)];
    _introLabel.font = SYSTEMFONT(13);
    _introLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_introLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110 - 1, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setInstitutionListInfo:(NSDictionary *)info {
    
    [_faceImageView sd_setImageWithURL:EdulineUrlString([info objectForKey:@"logo"]) placeholderImage:DefaultUserImage];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    
    NSString *intro = [NSString stringWithFormat:@"%@",[info objectForKey:@"info"]];
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
