//
//  LiveMenberCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveMenberCell.h"
#include "V5_Constant.h"

@implementation LiveMenberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 32)];
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 32 / 2.0;
    _faceImageView.centerY = 64 / 2.0;
    _faceImageView.image = DefaultUserImage;
    [self.contentView addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 8, 0, 150, 64)];
    _nameLabel.font = SYSTEMFONT(13);
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    _nameLabel.text = @"爽歪歪";
    [self.contentView addSubview:_nameLabel];
    
    _microButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 22 - 15 - 22, 0, 22, 22)];
    _microButton.centerY = 64 / 2.0;
    [_microButton setImage:Image(@"mic_open_slices") forState:0];
    [_microButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_microButton];
    
    _camButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 22, 0, 22, 22)];
    _camButton.centerY = 64 / 2.0;
    [_camButton setImage:Image(@"cam_open_slices") forState:0];
    [_camButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_camButton];
    
    _fengeLine = [[UIView alloc] initWithFrame:CGRectMake(15, 63, MainScreenWidth - 15, 1)];
    _fengeLine.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_fengeLine];
}

- (void)buttonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(liveMenberCellButtonClick:buttonSender:)]) {
        [_delegate liveMenberCellButtonClick:self buttonSender:sender];
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
