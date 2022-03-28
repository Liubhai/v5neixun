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
    
    _examTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, _whiteBackView.width - 15 - 70 - 12, 20 + 16 * 2)];
    _examTitle.font = SYSTEMFONT(15);
    _examTitle.textColor = EdlineV5_Color.textFirstColor;
    _examTitle.text = @"2022年计算机二级模拟考试…";
    [_whiteBackView addSubview:_examTitle];
    
    _examButton = [[UIButton alloc] initWithFrame:CGRectMake(_whiteBackView.width - 15 - 70, 0, 70, 24)];
    _examButton.layer.masksToBounds = YES;
    _examButton.layer.cornerRadius = _examButton.height / 2.0;
    _examButton.titleLabel.font = SYSTEMFONT(12);
    _examButton.titleLabel.textColor = [UIColor whiteColor];
    _examButton.backgroundColor = EdlineV5_Color.themeColor;
    [_examButton setTitle:@"开始考试" forState:0];
    [_whiteBackView addSubview:_examButton];
    _examButton.centerY = _examTitle.centerY;
    
    _fenggeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _examTitle.bottom, _whiteBackView.width, 1)];
    _fenggeLineView.backgroundColor = HEXCOLOR(0xF5F5F5);
    [_whiteBackView addSubview:_fenggeLineView];
    
    _examCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, _fenggeLineView.bottom, 100, 37)];
    _examCountLabel.font = SYSTEMFONT(12);
    _examCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _examCountLabel.text = @"题数：40";
    [_whiteBackView addSubview:_examCountLabel];
    
    _examMenberNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBackView.width - 14 - 100, _fenggeLineView.bottom, 100, 37)];
    _examMenberNumLabel.textAlignment = NSTextAlignmentRight;
    _examMenberNumLabel.font = SYSTEMFONT(12);
    _examMenberNumLabel.textColor = EdlineV5_Color.textThirdColor;
    _examMenberNumLabel.text = @"参考人数：120";
    [_whiteBackView addSubview:_examMenberNumLabel];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBackView.width / 2.0 - 65 / 2.0, _fenggeLineView.bottom, 65, 37)];
    _scoreLabel.font = SYSTEMFONT(12);
    _scoreLabel.textColor = EdlineV5_Color.textThirdColor;
    _scoreLabel.text = @"总分：100";
    [_whiteBackView addSubview:_scoreLabel];
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
