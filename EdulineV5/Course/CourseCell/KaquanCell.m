//
//  KaquanCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "KaquanCell.h"
#import "V5_Constant.h"

@implementation KaquanCell

// 110 = 10 + 90 + 10
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(nonnull NSString *)cellType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _cellType = cellType;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, MainScreenWidth - 30, 90)];
    [self addSubview:_backView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.left + 10, _backView.top, _backView.width - 10, 44)];
    _themeLabel.text = @"满一百减90";
    [self addSubview:_themeLabel];
    
    _fanweiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_themeLabel.left, _themeLabel.bottom, _themeLabel.width, 16)];
    _fanweiLabel.font = SYSTEMFONT(12);
    _fanweiLabel.text = @"仅限机构1使用";
    [self addSubview:_fanweiLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_themeLabel.left, _fanweiLabel.bottom + 3, _themeLabel.width, 16)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.text = @"有效期2019.12.12至2022.12.12";
    [self addSubview:_timeLabel];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(_backView.right - 10 - 75, 0, 75, 34)];
    _rightButton.layer.masksToBounds = YES;
    _rightButton.layer.cornerRadius = 17;
    _rightButton.layer.borderWidth = 1;
    _rightButton.titleLabel.font = SYSTEMFONT(15);
    [_rightButton setTitle:@"取消使用" forState:UIControlStateSelected];
    [_rightButton setTitle:@"使用" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    [_rightButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.centerY = _backView.centerY;
    [self addSubview:_rightButton];
    UIColor *cellColor = EdlineV5_Color.youhuijuanColor;
    // 1 优惠卷 2 打折卡 3 课程卡
    if ([_cellType isEqualToString:@"1"]) {
        _backView.image = Image(@"youhuiquan");
        _themeLabel.font = SYSTEMFONT(20);
        cellColor = EdlineV5_Color.youhuijuanColor;
    } else if ([_cellType isEqualToString:@"2"]) {
        _backView.image = Image(@"dazhe_bg");
        _themeLabel.font = SYSTEMFONT(20);
        cellColor = EdlineV5_Color.dazhekaColor;
    } else if ([_cellType isEqualToString:@"3"]) {
        _backView.image = Image(@"kecheng_bg");
        _themeLabel.font = SYSTEMFONT(15);
        cellColor = EdlineV5_Color.kechengkaColor;
    }
    
    _themeLabel.textColor = cellColor;
    _fanweiLabel.textColor = cellColor;
    _timeLabel.textColor = cellColor;
    [_rightButton setBackgroundColor:cellColor];
    [_rightButton setTitleColor:cellColor forState:UIControlStateSelected];
    _rightButton.layer.borderColor = cellColor.CGColor;
}

- (void)userButtonClick:(UIButton *)sender {
    UIColor *cellColor = EdlineV5_Color.youhuijuanColor;
    if ([_cellType isEqualToString:@"1"]) {
        cellColor = EdlineV5_Color.youhuijuanColor;
    } else if ([_cellType isEqualToString:@"2"]) {
        cellColor = EdlineV5_Color.dazhekaColor;
    } else if ([_cellType isEqualToString:@"3"]) {
        cellColor = EdlineV5_Color.kechengkaColor;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundColor:[UIColor whiteColor]];
    } else {
        [sender setBackgroundColor:cellColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
