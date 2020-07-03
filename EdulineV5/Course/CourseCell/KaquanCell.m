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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(nonnull NSString *)cellType getOrUse:(BOOL)getOrUse useful:(BOOL)useful {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _getOrUse = getOrUse;
        _useful = useful;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, MainScreenWidth - 30, 92)];
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
    _rightButton.titleLabel.font = SYSTEMFONT(15);
    if (_useful) {
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.cornerRadius = 17;
        _rightButton.layer.borderWidth = 1;
        if (_getOrUse) {
            [_rightButton setTitle:@"已领取" forState:UIControlStateSelected];
            [_rightButton setTitle:@"领取" forState:0];
        } else {
            [_rightButton setTitle:@"取消使用" forState:UIControlStateSelected];
            [_rightButton setTitle:@"使用" forState:0];
        }
        [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    } else {
        [_rightButton setTitle:@"不可使用" forState:0];
        [_rightButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    }
    [_rightButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.centerY = _backView.centerY;
    [self addSubview:_rightButton];
}

- (void)setCouponInfo:(CouponModel *)model cellIndexPath:(NSIndexPath *)cellIndexPath isMyCouponsList:(BOOL)isMyCouponsList {
    _couponModel = model;
    _cellIndexpath = cellIndexPath;
    _cellType = model.coupon_type;
    _isMyCouponsList = isMyCouponsList;
    
    UIColor *cellColor = EdlineV5_Color.youhuijuanColor;
    // 1 优惠卷 2 打折卡 3 课程卡
    if (_useful) {
        if ([_cellType isEqualToString:@"1"]) {
            _backView.image = Image(@"youhuiquan");
            _themeLabel.font = SYSTEMFONT(14);
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
    } else {
        _backView.image = Image(@"kaquan_grey");
        cellColor = EdlineV5_Color.textThirdColor;
        if ([_cellType isEqualToString:@"1"]) {
            _themeLabel.font = SYSTEMFONT(14);
        } else if ([_cellType isEqualToString:@"2"]) {
            _themeLabel.font = SYSTEMFONT(20);
        } else if ([_cellType isEqualToString:@"3"]) {
            _themeLabel.font = SYSTEMFONT(15);
        }
    }
    
    _themeLabel.textColor = cellColor;
    _fanweiLabel.textColor = cellColor;
    _timeLabel.textColor = cellColor;
    [_rightButton setBackgroundColor:cellColor];
    [_rightButton setTitleColor:cellColor forState:UIControlStateSelected];
    _rightButton.layer.borderColor = cellColor.CGColor;
    
    if ([_cellType isEqualToString:@"1"]) {
        NSString *origin = [NSString stringWithFormat:@"¥%@ 满%@使用",model.price,model.maxprice];
        NSRange range1 = NSMakeRange(0, 1);
        NSRange range2 = NSMakeRange(1, [origin rangeOfString:@"满"].location - 1);
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:origin];
        [atr addAttributes:@{NSFontAttributeName: SYSTEMFONT(12)} range:range1];
        [atr addAttributes:@{NSFontAttributeName: SYSTEMFONT(20)} range:range2];
        _themeLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr];
        _fanweiLabel.text = [NSString stringWithFormat:@"仅限%@使用",model.school_name];
    } else if ([_cellType isEqualToString:@"2"]) {
        _themeLabel.text = [NSString stringWithFormat:@"%@折",model.discount];
        _fanweiLabel.text = [NSString stringWithFormat:@"仅限%@使用",model.school_name];
    } else if ([_cellType isEqualToString:@"3"]) {
        _themeLabel.text = @"课程卡";
        _fanweiLabel.text = [NSString stringWithFormat:@"仅限%@使用",model.course_title];
    }
    _timeLabel.text = [NSString stringWithFormat:@"有效期%@至%@",[EdulineV5_Tool timeForYYYYMMDDHHMM:model.use_stime],[EdulineV5_Tool timeForYYYYMMDDHHMM:model.use_etime]];
    
    if (_getOrUse) {
        _rightButton.selected = model.user_has;
    } else {
        _rightButton.selected = model.IsUsed;
    }
    
    if ([_cellType isEqualToString:@"1"]) {
        cellColor = EdlineV5_Color.youhuijuanColor;
    } else if ([_cellType isEqualToString:@"2"]) {
        cellColor = EdlineV5_Color.dazhekaColor;
    } else if ([_cellType isEqualToString:@"3"]) {
        cellColor = EdlineV5_Color.kechengkaColor;
    }
    if (_useful) {
        if (_rightButton.selected) {
            [_rightButton setBackgroundColor:[UIColor whiteColor]];
        } else {
            [_rightButton setBackgroundColor:cellColor];
        }
    } else {
        cellColor = EdlineV5_Color.textThirdColor;
        [_rightButton setBackgroundColor:[UIColor clearColor]];
    }
    
}

- (void)userButtonClick:(UIButton *)sender {
    
    if (_isMyCouponsList) {
        if (_useful) {
            if (_delegate && [_delegate respondsToSelector:@selector(useOrGetAction:)]) {
                [_delegate useOrGetAction:self];
            }
            return;
        }
    }
    
    if (_getOrUse && _couponModel.user_has) {
        return;
    }
    if (!_useful) {
        return;
    }
    
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
    if (_delegate && [_delegate respondsToSelector:@selector(useOrGetAction:)]) {
        [_delegate useOrGetAction:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
