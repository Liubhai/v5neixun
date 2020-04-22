//
//  ShopCarCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShopCarCell.h"
#import "V5_Constant.h"

@implementation ShopCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BOOL)cellType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _cellType = cellType;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _selectedIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [_selectedIconBtn setImage:Image(@"checkbox_orange") forState:UIControlStateSelected];
    [_selectedIconBtn setImage:Image(@"checkbox_def") forState:0];
    [_selectedIconBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectedIconBtn.centerY = 92 / 2.0;
    [self addSubview:_selectedIconBtn];
    
    
    _courseFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cellType ? (_selectedIconBtn.right + 10) : 15, 10, 130, 72)];
    _courseFaceImageView.image = DefaultImage;
    [self addSubview:_courseFaceImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, 10, MainScreenWidth - (_courseFaceImageView.right + 8) - 15, 40)];
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.text = @"课程显示课程标题，课时显示课时名称";
    [self addSubview:_themeLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, _courseFaceImageView.bottom - 15, 150, 15)];
    _timeLabel.font = SYSTEMFONT(11);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = @"有效期至2022.12.12";
    [self addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, _timeLabel.top, 150, 15)];
    _priceLabel.font = SYSTEMFONT(12);
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.text = @"VIP:¥200.00";
    [self addSubview:_priceLabel];
    
    _courseHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.top - 17, _timeLabel.width, 15)];
    _courseHourLabel.font = SYSTEMFONT(11);
    _courseHourLabel.textAlignment = NSTextAlignmentRight;
    _courseHourLabel.textColor = EdlineV5_Color.textThirdColor;
    _courseHourLabel.text = @"12课时";
    [self addSubview:_courseHourLabel];
    
    if (_cellType) {
        _selectedIconBtn.hidden = NO;
        _timeLabel.hidden = YES;
        _courseHourLabel.hidden = YES;
    } else {
        _selectedIconBtn.hidden = YES;
        _timeLabel.hidden = NO;
        _courseHourLabel.hidden = NO;
    }
}

- (void)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end