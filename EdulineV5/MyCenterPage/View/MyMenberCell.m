//
//  MyMenberCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyMenberCell.h"
#import "V5_Constant.h"

@implementation MyMenberCell

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
    [self.contentView addSubview:_themeLabel];
    
    _scoreCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 165, 0, 150, 21)];
    _scoreCountLabel.font = SYSTEMFONT(15);
    _scoreCountLabel.textAlignment = NSTextAlignmentRight;
    _scoreCountLabel.textColor = EdlineV5_Color.textFirstColor;
    _scoreCountLabel.centerY = _themeLabel.centerY;
    [self.contentView addSubview:_scoreCountLabel];
    
    _scoreFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _themeLabel.bottom + 10, MainScreenWidth/2.0, 21)];
    _scoreFromLabel.font = SYSTEMFONT(13);
    _scoreFromLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_scoreFromLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 165, 0, 150, 16)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = EdlineV5_Color.textSecendColor;
    _timeLabel.centerY = _scoreFromLabel.centerY;
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 80 - 0.5, MainScreenWidth - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setMenberInfo:(NSDictionary *)info {
    
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
