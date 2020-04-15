//
//  SetingCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SetingCell.h"
#import "V5_Constant.h"

@implementation SetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 15, 50)];
    _themeLabel.font = SYSTEMFONT(15);
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_themeLabel];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 0, 8, 14)];
    _rightIcon.image = Image(@"list_more");
    _rightIcon.centerY = _themeLabel.centerY;
    [self addSubview:_rightIcon];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightIcon.right - 15 - 100, 0, 100, 50)];
    _rightLabel.textColor = EdlineV5_Color.textSecendColor;
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = SYSTEMFONT(15);
    [self addSubview:_rightLabel];
    
    _switchOther = [[UISwitch alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 36, 0, 51, 20)];
    _switchOther.onTintColor = HEXCOLOR(0x67C23A);
    _switchOther.tintColor = HEXCOLOR(0xC9C9C9);
    _switchOther.backgroundColor = HEXCOLOR(0xC9C9C9);
    _switchOther.thumbTintColor = [UIColor whiteColor];
    [_switchOther addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switchOther];
    [_switchOther setSize:_switchOther.size];
    _switchOther.centerY = _themeLabel.centerY;
    _switchOther.transform = CGAffineTransformMakeScale(36/51.0, 36/51.0);
    _switchOther.layer.masksToBounds = YES;
    _switchOther.layer.cornerRadius = 15;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, MainScreenWidth - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setSetingCellInfo:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        _themeLabel.text = [info objectForKey:@"title"];
        if ([[info objectForKey:@"type"] isEqualToString:@"switch"]) {
            _rightIcon.hidden = YES;
            _switchOther.hidden = NO;
            _rightLabel.hidden = YES;
        } else if ([[info objectForKey:@"type"] isEqualToString:@"third"]) {
            _rightIcon.hidden = NO;
            _switchOther.hidden = YES;
            _rightLabel.hidden = NO;
        } else if ([[info objectForKey:@"type"] isEqualToString:@"memory"]) {
            _rightIcon.hidden = YES;
            _switchOther.hidden = YES;
            _rightLabel.hidden = NO;
        } else if ([[info objectForKey:@"type"] isEqualToString:@"logout"]) {
            _rightIcon.hidden = YES;
            _switchOther.hidden = YES;
            _rightLabel.hidden = YES;
        } else {
            _rightIcon.hidden = NO;
            _switchOther.hidden = YES;
            _rightLabel.hidden = YES;
        }
    }
}

- (void)switchIsChanged:(UISwitch *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(switchClick:)]) {
        [_delegate switchClick:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
