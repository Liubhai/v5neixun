//
//  MyCertificateListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/30.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "MyCertificateListCell.h"
#import "V5_Constant.h"

@implementation MyCertificateListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - 30, 123)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 8;
    [self.contentView addSubview:_whiteView];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, _whiteView.width - 14, 40)];
    _fromLabel.textColor = EdlineV5_Color.textFirstColor;
    _fromLabel.font = SYSTEMFONT(13);
    _fromLabel.text = @"来源：课程名称显示在这里";
    [_whiteView addSubview:_fromLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _fromLabel.bottom, _whiteView.width, 1)];
    _lineView.backgroundColor = HEXCOLOR(0xEBEEF5);
    [_whiteView addSubview:_lineView];
    
    _faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, _lineView.bottom + 13, 55, 55)];
    _faceImage.clipsToBounds = YES;
    _faceImage.contentMode = UIViewContentModeScaleAspectFill;
    [_whiteView addSubview:_faceImage];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.right + 12, _faceImage.top, _whiteView.width - (_faceImage.right + 12), 16)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 15];
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.text = @"一级建造建造师建造师师资格证";
    [_whiteView addSubview:_titleLabel];
    
    _datelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.right + 12, 123 - 14 - 12, _whiteView.width - (_faceImage.right + 12), 12)];
    _datelineLabel.font = SYSTEMFONT(11);
    _datelineLabel.textColor = EdlineV5_Color.textThirdColor;
    _datelineLabel.text = @"有效期：2022-01-12至2023-01-12";
    [_whiteView addSubview:_datelineLabel];
    
    _getTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.right + 12, _datelineLabel.top - 4 - 12, _whiteView.width - (_faceImage.right + 12), 12)];
    _getTimeLabel.font = SYSTEMFONT(11);
    _getTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    _getTimeLabel.text = @"获得时间：2022-01-12";
    [_whiteView addSubview:_getTimeLabel];
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
