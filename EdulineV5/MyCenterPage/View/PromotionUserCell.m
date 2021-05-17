//
//  PromotionUserCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "PromotionUserCell.h"
#import "V5_Constant.h"

@implementation PromotionUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 57, 57)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = _faceImageView.height / 2.0;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.image = DefaultUserImage;
    [self.contentView addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, 0, MainScreenWidth - 15 - 55 - (_faceImageView.right + 15), 22)];
    _nameLabel.font = SYSTEMFONT(15);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    _nameLabel.centerY = _faceImageView.centerY;
    [self.contentView addSubview:_nameLabel];
    
    _promotionIncome = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _nameLabel.top, 200, 22)];
    _promotionIncome.font = SYSTEMFONT(15);
    _promotionIncome.textColor = EdlineV5_Color.faildColor;
    [self.contentView addSubview:_promotionIncome];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 72 - 1, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setPromotionUserCellInfo:(NSDictionary *)dict {
    
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
