//
//  BalanceDetailCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BalanceDetailCell.h"
#import "V5_Constant.h"

@implementation BalanceDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (70 - 54)/2.0, MainScreenWidth - 30, 27)];
    _titleLabel.font = SYSTEMFONT(15);
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.text = @"充值:内购充值";
    [self addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.bottom + 5, MainScreenWidth - 30, 27)];
    _timeLabel.font = SYSTEMFONT(15);
    _timeLabel.textColor = EdlineV5_Color.textSecendColor;
    _timeLabel.text = @"今天14:54";
    [self addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 0, 100, 27)];
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textColor = EdlineV5_Color.textFirstColor;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"+¥9.9";
    _priceLabel.centerY = 77 / 2.0;
    [self addSubview:_priceLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 77, MainScreenWidth - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setInfoData:(NSDictionary *)infoData {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
