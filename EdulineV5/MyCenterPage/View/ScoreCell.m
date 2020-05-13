//
//  ScoreCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ScoreCell.h"
#import "V5_Constant.h"

@implementation ScoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

//80
- (void)makeSubView {
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 40, 22)];
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    _themeLabel.font = SYSTEMFONT(16);
    _themeLabel.text = @"充值";
    [self addSubview:_themeLabel];
    
    _statusButton = [[UIButton alloc] initWithFrame:CGRectMake(_themeLabel.right + 5, 0, 32, 16)];
    _statusButton.layer.masksToBounds = YES;
    _statusButton.layer.cornerRadius = 1;
    [_statusButton setTitle:@"成功" forState:0];
    _statusButton.titleLabel.font = SYSTEMFONT(11);
    _statusButton.centerY = _themeLabel.centerY;
    [_statusButton setTitleColor:EdlineV5_Color.faildColor forState:0];
    const CGFloat *components = [EdulineV5_Tool getColorRGB:EdlineV5_Color.faildColor];
    _statusButton.layer.backgroundColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.2].CGColor;
    [self addSubview:_statusButton];
    
    _scoreCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 165, 0, 150, 21)];
    _scoreCountLabel.text = @"-10积分";
    _scoreCountLabel.font = SYSTEMFONT(15);
    _scoreCountLabel.textAlignment = NSTextAlignmentRight;
    _scoreCountLabel.textColor = EdlineV5_Color.textFirstColor;
    _scoreCountLabel.centerY = _themeLabel.centerY;
    [self addSubview:_scoreCountLabel];
    
    _scoreFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _themeLabel.bottom + 10, MainScreenWidth/2.0, 21)];
    _scoreFromLabel.text = @"备注：积分充值消耗";
    _scoreFromLabel.font = SYSTEMFONT(13);
    _scoreFromLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_scoreFromLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 165, 0, 150, 16)];
    _timeLabel.text = @"昨天 12:32";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = EdlineV5_Color.textSecendColor;
    _timeLabel.centerY = _scoreFromLabel.centerY;
    [self addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 80 - 0.5, MainScreenWidth - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
