//
//  HomeExamCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/28.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "HomeExamCell.h"
#import "V5_Constant.h"

@implementation HomeExamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 8, MainScreenWidth - 30, 90)];
    _whiteBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _whiteBackView.layer.cornerRadius = 4;
    _whiteBackView.layer.shadowColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:0.1].CGColor;
    _whiteBackView.layer.shadowOffset = CGSizeMake(0,0);
    _whiteBackView.layer.shadowOpacity = 1;
    _whiteBackView.layer.shadowRadius = 7;
    [self.contentView addSubview:_whiteBackView];
    
    _examStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 44, 17)];
    _examStatusImageView.image = Image(@"exam_yicankao");
    _examStatusImageView.hidden = YES;
    [self.contentView addSubview:_examStatusImageView];
    
    _examTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, _whiteBackView.width - 15 - 70 - 12, 20 + 16 * 2)];
    _examTitle.font = SYSTEMFONT(15);
    _examTitle.textColor = EdlineV5_Color.textFirstColor;
    [_whiteBackView addSubview:_examTitle];
    _examStatusImageView.centerY = _examTitle.centerY;
    
    _examButton = [[UIButton alloc] initWithFrame:CGRectMake(_whiteBackView.width - 15 - 70, 0, 70, 24)];
    _examButton.layer.masksToBounds = YES;
    _examButton.layer.cornerRadius = _examButton.height / 2.0;
    _examButton.titleLabel.font = SYSTEMFONT(12);
    _examButton.titleLabel.textColor = [UIColor whiteColor];
    _examButton.backgroundColor = EdlineV5_Color.themeColor;
    
    [_whiteBackView addSubview:_examButton];
    _examButton.centerY = _examTitle.centerY;
    
    _fenggeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _examTitle.bottom, _whiteBackView.width, 1)];
    _fenggeLineView.backgroundColor = HEXCOLOR(0xF5F5F5);
    [_whiteBackView addSubview:_fenggeLineView];
    
    _examCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, _fenggeLineView.bottom, 100, 37)];
    _examCountLabel.font = SYSTEMFONT(12);
    _examCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBackView addSubview:_examCountLabel];
    
    _examMenberNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBackView.width - 14 - 100, _fenggeLineView.bottom, 100, 37)];
    _examMenberNumLabel.textAlignment = NSTextAlignmentRight;
    _examMenberNumLabel.font = SYSTEMFONT(12);
    _examMenberNumLabel.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBackView addSubview:_examMenberNumLabel];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBackView.width / 2.0 - 65 / 2.0, _fenggeLineView.bottom, 65, 37)];
    _scoreLabel.font = SYSTEMFONT(12);
    _scoreLabel.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBackView addSubview:_scoreLabel];
}

- (void)setHomeExamListInfo:(NSDictionary *)info {
    _homeExamInfo = info;
    _examTitle.text = [NSString stringWithFormat:@"%@",info[@"title"]];
    _examCountLabel.text = [NSString stringWithFormat:@"题数：%@",info[@"total_count"]];
    _examMenberNumLabel.text = [NSString stringWithFormat:@"参考人数：%@",info[@"user_count"]];
    _scoreLabel.text = [NSString stringWithFormat:@"总分：%@",info[@"total_score"]];
    
    NSString *exam_status = [NSString stringWithFormat:@"%@",info[@"exam_status"]];
    if ([exam_status isEqualToString:@"1"]) {
        /// 已参考
        _examStatusImageView.hidden = NO;
        _examTitle.frame = CGRectMake(_examStatusImageView.right + 4.5, 0, _whiteBackView.width - 15 - 70 - (_examStatusImageView.right + 4.5), 20 + 16 * 2);
        [_examButton setTitle:@"查看详情" forState:0];
    } else {
        _examStatusImageView.hidden = YES;
        _examTitle.frame = CGRectMake(12, 0, _whiteBackView.width - 15 - 70 - 12, 20 + 16 * 2);
        [_examButton setTitle:@"开始考试" forState:0];
    }
}

- (void)doExamButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(doExamOrLookExamResult:)]) {
        [_delegate doExamOrLookExamResult:_homeExamInfo];
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
