//
//  ShitikaCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShitikaCell.h"
#import "V5_Constant.h"

@implementation ShitikaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0, MainScreenWidth - 1, 99)];
    _backView.image = Image(@"shitika_bg");
    [self.contentView addSubview:_backView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 27, MainScreenWidth - 80 - 27.5 - 15, 20)];
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.text = @"【机构1】平面设计基课程课程卡";
    [self.contentView addSubview:_themeLabel];
    
    _kahaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_themeLabel.left + 10, _themeLabel.bottom + 5, _themeLabel.width, 16)];
    _kahaoLabel.textColor = EdlineV5_Color.textSecendColor;
    _kahaoLabel.font = SYSTEMFONT(12);
    _kahaoLabel.text = @"卡号：892832193324233";
    [self.contentView addSubview:_kahaoLabel];
    
    _userButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 27.5 - 80, 0, 80, 34)];
    _userButton.centerY = 99 / 2.0;
    [_userButton setTitle:@"使用" forState:0];
    [_userButton setTitleColor:[UIColor whiteColor] forState:0];
    [_userButton setTitle:@"取消使用" forState:UIControlStateSelected];
    [_userButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
    _userButton.titleLabel.font = SYSTEMFONT(16);
    [_userButton setTitleColor:EdlineV5_Color.buttonNormalColor forState:UIControlStateSelected];
    _userButton.layer.masksToBounds = YES;
    _userButton.layer.cornerRadius = 17;
    _userButton.layer.borderWidth = 1;
    _userButton.layer.borderColor = EdlineV5_Color.buttonNormalColor.CGColor;
    [_userButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_userButton];
}

- (void)userButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(usercardButton:)]) {
        [_delegate usercardButton:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
