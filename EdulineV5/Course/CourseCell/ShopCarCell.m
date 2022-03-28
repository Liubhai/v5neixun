//
//  ShopCarCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShopCarCell.h"
#import "V5_UserModel.h"

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
    [_selectedIconBtn setImage:[Image(@"checkbox_orange") converToMainColor] forState:UIControlStateSelected];
    [_selectedIconBtn setImage:Image(@"checkbox_def") forState:0];
    [_selectedIconBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectedIconBtn.centerY = 92 / 2.0;
    [self.contentView addSubview:_selectedIconBtn];
    
    
    _courseFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cellType ? (_selectedIconBtn.right + 10) : 15, 10, 130, 72)];
    _courseFaceImageView.image = DefaultImage;
    _courseFaceImageView.layer.masksToBounds = YES;
    _courseFaceImageView.layer.cornerRadius = 2;
    [self.contentView addSubview:_courseFaceImageView];
    
    _courseTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFaceImageView.left, _courseFaceImageView.top, 33, 20)];
    _courseTypeImageView.image = Image(@"class_icon");
    _courseTypeImageView.layer.masksToBounds = YES;
    _courseTypeImageView.layer.cornerRadius = 2;
    [self.contentView addSubview:_courseTypeImageView];
    _courseTypeImageView.hidden = YES;
    
    _themeLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, 10, MainScreenWidth - (_courseFaceImageView.right + 8) - 15, 40)];
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    _themeLabel.font = SYSTEMFONT(14);
    [self.contentView addSubview:_themeLabel];
    
    _course_card = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 15)];
    _course_card.image = Image(@"lessoncard_icon");
    _course_card.hidden = YES;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _courseFaceImageView.bottom - 15, 200, 15)];
    _timeLabel.font = SYSTEMFONT(11);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImageView.right + 8, _timeLabel.top, 150, 15)];
    _priceLabel.font = SYSTEMFONT(12);
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [self.contentView addSubview:_priceLabel];
    
    _hasCourseCardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 36, _timeLabel.top, 36, 15)];
    _hasCourseCardImageView.image = Image(@"lessoncard_icon");
    [self.contentView addSubview:_hasCourseCardImageView];
    
    _courseHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.top - 17, _timeLabel.width, 15)];
    _courseHourLabel.font = SYSTEMFONT(11);
    _courseHourLabel.textAlignment = NSTextAlignmentRight;
    _courseHourLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_courseHourLabel];
    
    if (_cellType) {
        _selectedIconBtn.hidden = NO;
        _timeLabel.hidden = YES;
        _courseHourLabel.hidden = YES;
        _hasCourseCardImageView.hidden = NO;
    } else {
        _selectedIconBtn.hidden = YES;
        _timeLabel.hidden = NO;
        _courseHourLabel.hidden = NO;
        _hasCourseCardImageView.hidden = YES;
    }
}

- (void)setShopCarCourseInfo:(ShopCarCourseModel *)model cellIndexPath:(NSIndexPath *)cellIndexPath {
    
    _courseModel = model;
    _cellIndex = cellIndexPath;
    
    [_courseFaceImageView sd_setImageWithURL:EdulineUrlString(model.cover_url) placeholderImage:DefaultImage];
    if (_cellType) {
        _selectedIconBtn.selected = model.selected;
        _hasCourseCardImageView.hidden = !model.has_course_card;
    }
    _hasCourseCardImageView.hidden = YES;
    _course_card.hidden = YES;
    if (model.has_course_card) {
        _themeLabel.text = [NSString stringWithFormat:@"    %@",model.title];
        _course_card.hidden = NO;
        [_course_card setWidth:36];
        [_themeLabel addView:_course_card range:NSMakeRange(0, 3) alignment:TYDrawAlignmentCenter];
    } else {
        _themeLabel.text = model.title;
        _course_card.hidden = YES;
        [_course_card setWidth:0];
        [_themeLabel addView:_course_card range:NSMakeRange(0, 0) alignment:TYDrawAlignmentCenter];
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:model.price]];
    if ([[V5_UserModel vipStatus] isEqualToString:@"1"]) {
        _priceLabel.text = [NSString stringWithFormat:@"VIP:%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:model.user_price]];
    }
    if ([model.course_type isEqualToString:@"1"]) {
        _courseTypeImageView.image = Image(@"dianbo");
    } else if ([model.course_type isEqualToString:@"2"]) {
        _courseTypeImageView.image = Image(@"live");
    } else if ([model.course_type isEqualToString:@"3"]) {
        _courseTypeImageView.image = Image(@"mianshou");
    } else if ([model.course_type isEqualToString:@"4"]) {
        _courseTypeImageView.image = Image(@"class_icon");
    }
    _courseHourLabel.text = [NSString stringWithFormat:@"%@课时",model.section_count];
    
    NSString *timeLine = [NSString stringWithFormat:@"%@",model.term_time];
    if ([timeLine isEqualToString:@"0"]) {
        _timeLabel.text = @"永久有效";
        _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    } else if (timeLine.length>4) {
        _timeLabel.text = [NSString stringWithFormat:@"%@前有效",[EdulineV5_Tool timeForYYYYMMDDNianYueRI:timeLine]];
        _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"购买之日起%@天内有效",timeLine];
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_timeLabel.text];
        [priceAtt addAttributes:@{NSForegroundColorAttributeName: EdlineV5_Color.faildColor} range:NSMakeRange(5, timeLine.length)];
        _timeLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    }
    
}

- (void)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(chooseWhichCourse:)]) {
        [_delegate chooseWhichCourse:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
