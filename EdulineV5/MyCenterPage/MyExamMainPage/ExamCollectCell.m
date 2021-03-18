//
//  ExamCollectCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/9.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamCollectCell.h"

@implementation ExamCollectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    // 73 (+ line)
    _selectedIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 - 5, 12 - 5, 30, 30)];
    [_selectedIconBtn setImage:[Image(@"checkbox_orange") converToMainColor] forState:UIControlStateSelected];
    [_selectedIconBtn setImage:Image(@"checkbox_def") forState:0];
    [_selectedIconBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectedIconBtn];
    
    _examTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 16)];
    
    _titleLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(_selectedIconBtn.right + 10, 12, MainScreenWidth - 15 - (_selectedIconBtn.right + 10), 20)];
    _titleLabel.font = SYSTEMFONT(14);
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_titleLabel];
    
    _allCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 73 - 1 - 11 - 17, 50, 17)];
    _allCountLabel.font = SYSTEMFONT(12);
    _allCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_allCountLabel];
    
    _fenggeLineView = [[UIView alloc] initWithFrame:CGRectMake(_allCountLabel.right + 4, 0, 1, 8)];
    _fenggeLineView.backgroundColor = EdlineV5_Color.layarLineColor;
    _fenggeLineView.centerY = _allCountLabel.centerY;
    [self.contentView addSubview:_fenggeLineView];
    
    _rightCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_fenggeLineView.right + 6, _allCountLabel.top, 50, 17)];
    _rightCountLabel.font = SYSTEMFONT(12);
    _rightCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_rightCountLabel];
    
    _allCountLabel.hidden = YES;
    _fenggeLineView.hidden = YES;
    _rightCountLabel.hidden = YES;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 14, _titleLabel.width, 17)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.left, _timeLabel.bottom + 12, MainScreenWidth - _titleLabel.left, 1)];
    _lineView.backgroundColor = EdlineV5_Color.layarLineColor;
    [self.contentView addSubview:_lineView];
}

- (void)setExamCollectRootManagerModel:(ExamCollectCellModel *)model indexpath:(NSIndexPath *)indexpath showSelect:(BOOL)showSelect {
    _courseModel = model;
    _cellIndex= indexpath;
    
    _selectedIconBtn.selected = model.selected;
    _selectedIconBtn.hidden = showSelect;
    
    if ([model.question_type isEqualToString:@"4"]) {
        _titleLabel.text = [NSString stringWithFormat:@"      %@",model.topic_title];
    } else if ([model.question_type isEqualToString:@"7"]) {
        _titleLabel.text = [NSString stringWithFormat:@"      %@",model.topic_title];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"     %@",model.topic_title];
    }
    
    if (showSelect) {
        _titleLabel.frame = CGRectMake(15, 12, MainScreenWidth - 30, 20);
    } else {
        _titleLabel.frame = CGRectMake(_selectedIconBtn.right + 10, 12, MainScreenWidth - 15 - (_selectedIconBtn.right + 10), 20);
    }
    _titleLabel.font = SYSTEMFONT(14);
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
    _titleLabel.verticalAlignment = TYVerticalAlignmentTop;
    [_titleLabel sizeToFit];
    
    [_titleLabel setHeight:_titleLabel.height>40 ? 40 : _titleLabel.height];
    
    // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答
    if ([model.question_type isEqualToString:@"1"]) {
        _examTypeImageView.image = [Image(@"Multiple Choice_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.question_type isEqualToString:@"2"]) {
        _examTypeImageView.image = [Image(@"judge_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.question_type isEqualToString:@"3"]) {
        _examTypeImageView.image = [Image(@"duoxuan_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.question_type isEqualToString:@"4"]) {
        _examTypeImageView.image = [Image(@"budingxaing_icon") converToMainColor];
        [_examTypeImageView setWidth:44];
    } else if ([model.question_type isEqualToString:@"5"]) {
        _examTypeImageView.image = [Image(@"tiankong_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.question_type isEqualToString:@"6"]) {
        _examTypeImageView.image = [Image(@"cailiao_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.question_type isEqualToString:@"7"]) {
        _examTypeImageView.image = [Image(@"wanxing_icon") converToMainColor];
        [_examTypeImageView setWidth:55];
    } else if ([model.question_type isEqualToString:@"8"]) {
        _examTypeImageView.image = [Image(@"jieda_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    }
    
    if ([model.question_type isEqualToString:@"4"]) {
        [_titleLabel addView:_examTypeImageView range:NSMakeRange(0, 4) alignment:TYDrawAlignmentCenter];
    } else if ([model.question_type isEqualToString:@"7"]) {
        [_titleLabel addView:_examTypeImageView range:NSMakeRange(0, 4) alignment:TYDrawAlignmentCenter];
    } else {
        [_titleLabel addView:_examTypeImageView range:NSMakeRange(0, 3) alignment:TYDrawAlignmentCenter];
    }
    
    _timeLabel.text = [EdulineV5_Tool timeForBalanceYYMMDDHHMM:[NSString stringWithFormat:@"%@",model.create_time]];
    _timeLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 14, _titleLabel.width, 17);
    
    _lineView.frame = CGRectMake(_titleLabel.left, _timeLabel.bottom + 12, MainScreenWidth - _titleLabel.left, 1);
    [self setHeight:_lineView.bottom];
}

- (void)setExamErorModel:(ExamCollectCellModel *)model indexpath:(NSIndexPath *)indexpath {
    _courseModel = model;
    _cellIndex= indexpath;
    _selectedIconBtn.hidden = YES;
    
    _allCountLabel.hidden = NO;
    _fenggeLineView.hidden = NO;
    _rightCountLabel.hidden = NO;
    
    if ([model.topic_type isEqualToString:@"4"]) {
        _titleLabel.text = [NSString stringWithFormat:@"      %@",model.topic_title];
    } else if ([model.topic_type isEqualToString:@"7"]) {
        _titleLabel.text = [NSString stringWithFormat:@"      %@",model.topic_title];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"     %@",model.topic_title];
    }
    
    _titleLabel.frame = CGRectMake(15, 12, MainScreenWidth - 30, 20);
    _titleLabel.font = SYSTEMFONT(14);
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
    _titleLabel.verticalAlignment = TYVerticalAlignmentTop;
    [_titleLabel sizeToFit];
    
    _titleLabel.frame = CGRectMake(15, 12, MainScreenWidth - 30, _titleLabel.height>40 ? 40 : _titleLabel.height);
    
    // 题目类型 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答
    if ([model.topic_type isEqualToString:@"1"]) {
        _examTypeImageView.image = [Image(@"Multiple Choice_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.topic_type isEqualToString:@"2"]) {
        _examTypeImageView.image = [Image(@"judge_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.topic_type isEqualToString:@"3"]) {
        _examTypeImageView.image = [Image(@"duoxuan_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.topic_type isEqualToString:@"4"]) {
        _examTypeImageView.image = [Image(@"budingxaing_icon") converToMainColor];
        [_examTypeImageView setWidth:44];
    } else if ([model.topic_type isEqualToString:@"5"]) {
        _examTypeImageView.image = [Image(@"tiankong_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.topic_type isEqualToString:@"6"]) {
        _examTypeImageView.image = [Image(@"cailiao_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    } else if ([model.topic_type isEqualToString:@"7"]) {
        _examTypeImageView.image = [Image(@"wanxing_icon") converToMainColor];
        [_examTypeImageView setWidth:55];
    } else if ([model.topic_type isEqualToString:@"8"]) {
        _examTypeImageView.image = [Image(@"jieda_icon") converToMainColor];
        [_examTypeImageView setWidth:32];
    }
    
    if ([model.topic_type isEqualToString:@"4"]) {
        [_titleLabel addView:_examTypeImageView range:NSMakeRange(0, 4) alignment:TYDrawAlignmentCenter];
    } else if ([model.topic_type isEqualToString:@"7"]) {
        [_titleLabel addView:_examTypeImageView range:NSMakeRange(0, 4) alignment:TYDrawAlignmentCenter];
    } else {
        [_titleLabel addView:_examTypeImageView range:NSMakeRange(0, 3) alignment:TYDrawAlignmentCenter];
    }
    
    _allCountLabel.text = [NSString stringWithFormat:@"答错%@次",model.wrong_count];
    CGFloat allCountWidth = [_allCountLabel.text sizeWithFont:_allCountLabel.font].width + 4;
    [_allCountLabel setWidth:allCountWidth];
    
    _rightCountLabel.text = [NSString stringWithFormat:@"累计作答%@次",model.answer_count];
    CGFloat rightCountWidth = [_rightCountLabel.text sizeWithFont:_rightCountLabel.font].width + 4;
    [_rightCountLabel setWidth:rightCountWidth];
    
    [_allCountLabel setTop:_titleLabel.bottom + 14];
    [_fenggeLineView setLeft:_allCountLabel.right + 4];
    _fenggeLineView.centerY = _allCountLabel.centerY;
    [_rightCountLabel setLeft:_fenggeLineView.right + 8];
    _rightCountLabel.centerY = _allCountLabel.centerY;
    
    _timeLabel.text = [EdulineV5_Tool timeForBalanceYYMMDDHHMM:[NSString stringWithFormat:@"%@",model.wrong_time]];
    _timeLabel.frame = CGRectMake(MainScreenWidth - 15 - 200, _titleLabel.bottom + 14, 200, 17);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    
    _lineView.frame = CGRectMake(_titleLabel.left, _timeLabel.bottom + 12, MainScreenWidth - _titleLabel.left, 1);
    [self setHeight:_lineView.bottom];
}

- (void)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(examCollectManagerSelectButtonClick:)]) {
        [_delegate examCollectManagerSelectButtonClick:self];
    }
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
