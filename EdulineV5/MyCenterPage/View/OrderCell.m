//
//  OrderCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderCell.h"
#import "V5_Constant.h"

@implementation OrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _backIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    _backIamgeView.image = Image(@"myorder_bg");
    [self addSubview:_backIamgeView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 30, 1)];
    [self addSubview:_backView];
    
    _orderNum = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, _backView.width - 12, 36)];
    _orderNum.text = @"订单号：AWN8923779294";
    _orderNum.textColor = EdlineV5_Color.textSecendColor;
    _orderNum.font = SYSTEMFONT(14);
    [_backView addSubview:_orderNum];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.width - 10 - 100, 0, 100, 36)];
    _statusLabel.font = SYSTEMFONT(14);
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.text = @"已完成";
    _statusLabel.textColor = EdlineV5_Color.faildColor;
    [_backView addSubview:_statusLabel];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _orderNum.bottom, _backView.width, 1)];
    _line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_backView addSubview:_line1];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, _line1.bottom + 15, 120, 66)];
    _faceImageView.image = DefaultImage;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 4;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backView addSubview:_faceImageView];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_faceImageView.right - 32, _faceImageView.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"album_icon");
    [_backView addSubview:_courseTypeImage];
    
    _theme = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _faceImageView.top, _backView.width - _faceImageView.right - 64 - 10, 24)];
    _theme.font = SYSTEMFONT(15);
    _theme.textColor = EdlineV5_Color.textFirstColor;
    _theme.text = @"课程标题显示在这里";
    [_backView addSubview:_theme];
    
    _dateLine = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _theme.bottom + 5, _theme.width, 15)];
    _dateLine.font = SYSTEMFONT(11);
    _dateLine.textColor = EdlineV5_Color.textThirdColor;
    _dateLine.text = @"有效期至2021-11-12 ";
    [_backView addSubview:_dateLine];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.width - 12 - 100, _faceImageView.top, 100, 24)];
    _priceLabel.font = SYSTEMFONT(14);
    _priceLabel.textColor = EdlineV5_Color.textFirstColor;
    _priceLabel.text = @"¥199";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_priceLabel];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(_faceImageView.left, _faceImageView.bottom + 15, _backView.width - _faceImageView.left * 2, 1)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_backView addSubview:_line2];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.left, _line2.bottom + 12, 150, 16)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textSecendColor;
    _timeLabel.text = @"2019-11-12 12:32";
    [_backView addSubview:_timeLabel];
    
    _truePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.width - 80, 0, 80, 21)];
    _truePriceLabel.centerY = _timeLabel.centerY;
    _truePriceLabel.textColor = EdlineV5_Color.faildColor;
    _truePriceLabel.font = SYSTEMFONT(14);
    _truePriceLabel.text = @"¥109";
    [_backView addSubview:_truePriceLabel];
    
    _trueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_truePriceLabel.left - 40, 0, 40, 21)];
    _trueLabel.centerY = _timeLabel.centerY;
    _trueLabel.textColor = EdlineV5_Color.textSecendColor;
    _trueLabel.font = SYSTEMFONT(14);
    _trueLabel.text = @"实付:";
    _trueLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_trueLabel];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame = CGRectMake(_backView.width - 15 - 70, _truePriceLabel.bottom + 13, 70, 28);
    [_button2 setTitle:@"去支付" forState:0];
    _button2.titleLabel.font = SYSTEMFONT(12);
    [_button2 setTitleColor:[UIColor whiteColor] forState:0];
    _button2.backgroundColor = EdlineV5_Color.baseColor;
    _button2.layer.masksToBounds = YES;
    _button2.layer.cornerRadius = _button2.height / 2.0;
    [_backView addSubview:_button2];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(_button2.left - 12 - 70, _truePriceLabel.bottom + 13, 70, 28);
    _button1.titleLabel.font = SYSTEMFONT(12);
    [_button1 setTitle:@"删除订单" forState:0];
    [_button1 setTitleColor:EdlineV5_Color.baseColor forState:0];
    _button1.layer.masksToBounds = YES;
    _button1.layer.cornerRadius = _button1.height / 2.0;
    _button1.layer.borderWidth = 1;
    _button1.layer.borderColor = EdlineV5_Color.baseColor.CGColor;
    [_backView addSubview:_button1];
}

- (void)setOrderInfo:(NSDictionary *)orderInfo {
    
    // 1 点播 2 直播 3 面授 4 专辑
    NSString *courseType = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"album_icon");
    }
    
    [_backView setHeight:_button1.bottom + 10];
    
    [_backIamgeView setHeight:_backView.bottom + 15];
    [self setHeight:_backView.bottom + 15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
