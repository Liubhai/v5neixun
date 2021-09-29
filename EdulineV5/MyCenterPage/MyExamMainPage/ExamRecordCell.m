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
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - 30, 20)];
    _titleLabel.font = SYSTEMFONT(15);
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_titleLabel];
    
    _taojuanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 8, _titleLabel.width, 17)];
    _taojuanTitleLabel.textColor = EdlineV5_Color.textThirdColor;
    _taojuanTitleLabel.font = SYSTEMFONT(12);
    _taojuanTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.contentView addSubview:_taojuanTitleLabel];
    _taojuanTitleLabel.hidden = YES;
    
    _allCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 73 - 1 - 11 - 17, 50, 17)];
    _allCountLabel.font = SYSTEMFONT(12);
    _allCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _allCountLabel.text = @"共100题";
    CGFloat allCountWidth = [_allCountLabel.text sizeWithFont:_allCountLabel.font].width + 4;
    [_allCountLabel setWidth:allCountWidth];
    [self.contentView addSubview:_allCountLabel];
    
    _fenggeLineView = [[UIView alloc] initWithFrame:CGRectMake(_allCountLabel.right + 4, 0, 1, 8)];
    _fenggeLineView.backgroundColor = EdlineV5_Color.layarLineColor;
    _fenggeLineView.centerY = _allCountLabel.centerY;
    [self.contentView addSubview:_fenggeLineView];
    
    _rightCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right + 6, _allCountLabel.top, 50, 17)];
    _rightCountLabel.font = SYSTEMFONT(12);
    _rightCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _rightCountLabel.text = @"共100题";
    CGFloat rightCountWidth = [_rightCountLabel.text sizeWithFont:_rightCountLabel.font].width + 4;
    [_rightCountLabel setWidth:rightCountWidth];
    [self.contentView addSubview:_rightCountLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _allCountLabel.top, 200, 17)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = @"2021-01-21 12:33";
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.left, _timeLabel.bottom + 12, MainScreenWidth - _titleLabel.left, 1)];
    _lineView.backgroundColor = EdlineV5_Color.layarLineColor;
    [self.contentView addSubview:_lineView];
    
    _courseRecordResult = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 8 - 74, 8, 74, 74)];
    [self.contentView addSubview:_courseRecordResult];
    _courseRecordResult.hidden = YES;
}

- (void)setExamRecordRootManagerModel:(EXamRecordModel *)model indexpath:(NSIndexPath *)indexpath isPublic:(BOOL)isPublic isCourse:(BOOL)isCourse {
    _courseModel = model;
    _cellIndex= indexpath;
    _taojuanTitleLabel.hidden = YES;
    _courseRecordResult.hidden = YES;
    _titleLabel.frame = CGRectMake(15, 12, MainScreenWidth - 30, 20);
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.paper_title];
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
    [_titleLabel setHeight:_titleLabel.height>40 ? 40 : _titleLabel.height];
    _allCountLabel.text = [NSString stringWithFormat:@"共%@题",model.topic_count];
    if (isPublic) {
        if ([model.answer_status isEqualToString:@"2"]) {
            _allCountLabel.text = [NSString stringWithFormat:@"得分：%@分",model.user_score];
        } else {
            _allCountLabel.text = @"正在阅卷";
        }
        if (isCourse) {
            _taojuanTitleLabel.hidden = NO;
            _courseRecordResult.hidden = NO;
            _taojuanTitleLabel.text = [NSString stringWithFormat:@"一《%@》",model.course_title];
            _taojuanTitleLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 8, MainScreenWidth - 30, 17);
            if ([model.pass isEqualToString:@"1"]) {
                _courseRecordResult.image = Image(@"exam_qualified_icon");
            } else {
                _courseRecordResult.image = Image(@"exam_unqualified_icon");
            }
        }
    } else {
        _taojuanTitleLabel.hidden = NO;
        _taojuanTitleLabel.text = [NSString stringWithFormat:@"一《%@》",model.rollup_title];
        _taojuanTitleLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 8, MainScreenWidth - 30, 17);
    }
    _rightCountLabel.text = [NSString stringWithFormat:@"答对%@题",model.right_count];
    CGFloat allCountWidth = [_allCountLabel.text sizeWithFont:_allCountLabel.font].width + 4;
    CGFloat rightCountWidth = [_rightCountLabel.text sizeWithFont:_rightCountLabel.font].width + 4;
    
    if (isPublic) {
        _allCountLabel.frame = CGRectMake(15, isCourse ? (_taojuanTitleLabel.bottom + 16) : (_titleLabel.bottom + 14), allCountWidth, 17);
    } else {
        _allCountLabel.frame = CGRectMake(15, _taojuanTitleLabel.bottom + 16, allCountWidth, 17);
    }
    [_fenggeLineView setLeft:_allCountLabel.right + 4];
    _fenggeLineView.centerY = _allCountLabel.centerY;
    _rightCountLabel.frame = CGRectMake(_fenggeLineView.right + 8, _allCountLabel.top, rightCountWidth, 17);
    
    _timeLabel.frame = CGRectMake(MainScreenWidth - 15 - 200, _allCountLabel.top, 200, 17);
    _timeLabel.text = [EdulineV5_Tool formateTime:[NSString stringWithFormat:@"%@",model.commit_time]];
    
    _lineView.frame = CGRectMake(_titleLabel.left, _timeLabel.bottom + 12, MainScreenWidth - _titleLabel.left, 1);
    [self setHeight:_lineView.bottom];
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
