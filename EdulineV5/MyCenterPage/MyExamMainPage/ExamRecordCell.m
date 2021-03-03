//
//  ExamRecordCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamRecordCell.h"
#import "V5_Constant.h"

@implementation ExamRecordCell

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
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectedIconBtn.right + 10, 12, MainScreenWidth - 15 - (_selectedIconBtn.right + 10), 20)];
    _titleLabel.font = SYSTEMFONT(15);
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_titleLabel];
    
    _allCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 73 - 1 - 11 - 17, 50, 17)];
    _allCountLabel.font = SYSTEMFONT(12);
    _allCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _allCountLabel.text = @"共100题";
    CGFloat allCountWidth = [_allCountLabel.text sizeWithFont:_allCountLabel.font].width + 4;
    [_allCountLabel setWidth:allCountWidth];
    [self.contentView addSubview:_allCountLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_allCountLabel.right + 6, 0, 1, 8)];
    _lineView.backgroundColor = EdlineV5_Color.layarLineColor;
    _lineView.centerY = _allCountLabel.centerY;
    [self.contentView addSubview:_lineView];
    
    _rightCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right + 6, _allCountLabel.top, 50, 17)];
    _rightCountLabel.font = SYSTEMFONT(12);
    _rightCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _rightCountLabel.text = @"共100题";
    CGFloat rightCountWidth = [_rightCountLabel.text sizeWithFont:_rightCountLabel.font].width + 4;
    [_rightCountLabel setWidth:rightCountWidth];
    [self.contentView addSubview:_rightCountLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _allCountLabel.top, 100, 17)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
}

- (void)setExamRecordRootManagerModel:(EXamRecordModel *)model indexpath:(NSIndexPath *)indexpath showSelect:(BOOL)showSelect {
    _courseModel = model;
    _cellIndex= indexpath;
    
    _selectedIconBtn.selected = model.selected;
    _selectedIconBtn.hidden = showSelect;
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    _allCountLabel.text = [NSString stringWithFormat:@"共%@题",model.allCount];
    _allCountLabel.text = [NSString stringWithFormat:@"答对%@题",model.rightCount];
    CGFloat allCountWidth = [_allCountLabel.text sizeWithFont:_allCountLabel.font].width + 4;
    CGFloat rightCountWidth = [_rightCountLabel.text sizeWithFont:_rightCountLabel.font].width + 4;
    
    if (showSelect) {
        _titleLabel.frame = CGRectMake(15, 12, MainScreenWidth - 30, 20);
        _allCountLabel.frame = CGRectMake(15, 73 - 1 - 11 - 17, allCountWidth, 17);
    } else {
        _titleLabel.frame = CGRectMake(_selectedIconBtn.right + 10, 12, MainScreenWidth - 15 - (_selectedIconBtn.right + 10), 20);
        _allCountLabel.frame = CGRectMake(_selectedIconBtn.right + 10, 73 - 1 - 11 - 17, allCountWidth, 17);
    }
    _lineView.frame = CGRectMake(_allCountLabel.right + 6, 0, 1, 8);
    _lineView.centerY = _allCountLabel.centerY;
    _rightCountLabel.frame = CGRectMake(_lineView.right + 6, _allCountLabel.top, rightCountWidth, 17);
}

- (void)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(examRecordManagerSelectButtonClick:)]) {
        [_delegate examRecordManagerSelectButtonClick:self];
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
