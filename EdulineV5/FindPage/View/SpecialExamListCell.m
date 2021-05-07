//
//  SpecialExamListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SpecialExamListCell.h"
#import "V5_Constant.h"

@implementation SpecialExamListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _whiteBack = [[UIView alloc] initWithFrame:CGRectMake(15, 10, MainScreenWidth - 30, 109)];
    _whiteBack.backgroundColor = [UIColor whiteColor];
    _whiteBack.layer.masksToBounds = YES;
    _whiteBack.layer.cornerRadius = 4;
    [self.contentView addSubview:_whiteBack];
    
    _gotImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 36, 16)];
    _gotImage.image = Image(@"exam_yigouamai_icon");
    _gotImage.hidden = YES;
    [_whiteBack addSubview:_gotImage];
    
    _examTitle = [[UILabel alloc] initWithFrame:CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20)];
    _examTitle.font = SYSTEMFONT(15);
    _examTitle.textColor = EdlineV5_Color.textFirstColor;
    [_whiteBack addSubview:_examTitle];
    _gotImage.centerY = _examTitle.centerY;
    
    _publicTime = [[UILabel alloc] initWithFrame:CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, 16)];
    _publicTime.font = SYSTEMFONT(11);
    _publicTime.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBack addSubview:_publicTime];
    _publicTime.hidden = YES;
    
    _examPoint = [[UILabel alloc] initWithFrame:CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, 14)];
    _examPoint.font = SYSTEMFONT(11);
    _examPoint.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBack addSubview:_examPoint];
    
    _examCount = [[UILabel alloc] initWithFrame:CGRectMake(12, _whiteBack.height - 36, 80, 16)];
    _examCount.font = SYSTEMFONT(12);
    _examCount.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBack addSubview:_examCount];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_examCount.right + 8, 0, 0.5, 8)];
    _lineView.backgroundColor = EdlineV5_Color.layarLineColor;
    _lineView.centerY = _examCount.centerY;
    [_whiteBack addSubview:_lineView];
    
    _learnCount = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right + 8, _examCount.top, 100, 16)];
    _learnCount.font = SYSTEMFONT(12);
    _learnCount.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBack addSubview:_learnCount];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBack.width - (100 + 14 + 82 + 12), 0, 100, 21)];
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = [NSString stringWithFormat:@"%@12,099.00",IOSMoneyTitle];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [_whiteBack addSubview:_priceLabel];
    
    _getOrExamBtn = [[UIButton alloc] initWithFrame:CGRectMake(_priceLabel.right + 14, 0, 82, 28)];
    _getOrExamBtn.backgroundColor = EdlineV5_Color.themeColor;
    _getOrExamBtn.layer.masksToBounds = YES;
    _getOrExamBtn.layer.cornerRadius = _getOrExamBtn.height / 2.0;
    [_getOrExamBtn setTitleColor:[UIColor whiteColor] forState:0];
    _getOrExamBtn.titleLabel.font = SYSTEMFONT(14);
    [_getOrExamBtn setTitle:@"购买" forState:0];
    [_getOrExamBtn addTarget:self action:@selector(buttonClickBy:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBack addSubview:_getOrExamBtn];
    
    _priceLabel.centerY = _examCount.centerY;
    _getOrExamBtn.centerY = _examCount.centerY;
}

- (void)buttonClickBy:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(getOrExamButtonWith:)]) {
        [_delegate getOrExamButtonWith:self];
    }
}

- (void)setPublicExamCell:(NSDictionary *)dict {
    _specialInfo = dict;
    _examPoint.hidden = YES;
    _lineView.hidden = YES;
    _learnCount.hidden = YES;
    _priceLabel.hidden = NO;
    _gotImage.hidden = YES;
    
    _publicTime.hidden = NO;
    
    _examTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    if ([[NSString stringWithFormat:@"%@",dict[@"end_time"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@",dict[@"end_time"]] isEqualToString:@"<null>"]) {
        _publicTime.text = @"开放时间：永久开放";
    } else {
        _publicTime.text = [NSString stringWithFormat:@"开放时间：%@",[EdulineV5_Tool examEvaluateStarTime:[NSString stringWithFormat:@"%@",dict[@"start_time"]] endTime:[NSString stringWithFormat:@"%@",dict[@"end_time"]]]];
    }
    
    _examCount.text = [NSString stringWithFormat:@"共%@题",dict[@"total_count"]];
    NSString *priceCount = [NSString stringWithFormat:@"%@",dict[@"user_price"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,dict[@"user_price"]];
    
    _getOrExamBtn.backgroundColor = EdlineV5_Color.themeColor;
    
    NSString *start_status = [NSString stringWithFormat:@"%@",dict[@"exam_status"]];
    
    if ([priceCount isEqualToString:@"0.00"] || [priceCount isEqualToString:@"0.0"] || [priceCount isEqualToString:@"0"]) {
        _priceLabel.hidden = YES;
        _gotImage.hidden = NO;
        _gotImage.image = Image(@"exam_free_icon");
        _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20);
        [_getOrExamBtn setTitle:@"开始答题" forState:0];
        if ([start_status isEqualToString:@"0"] || [start_status isEqualToString:@"<null>"]) {
            [_getOrExamBtn setTitle:@"暂未开放" forState:0];
            _getOrExamBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
        }
    } else {
        // 不是免费的
        _priceLabel.hidden = NO;
        if ([[NSString stringWithFormat:@"%@",dict[@"has_bought"]] boolValue]) {
            // 已购买
            _priceLabel.hidden = YES;
            _gotImage.hidden = NO;
            _gotImage.image = Image(@"exam_yigouamai_icon");
            _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20);
            [_getOrExamBtn setTitle:@"开始答题" forState:0];
            if ([start_status isEqualToString:@"0"] || [start_status isEqualToString:@"<null>"]) {
                [_getOrExamBtn setTitle:@"暂未开放" forState:0];
                _getOrExamBtn.backgroundColor = EdlineV5_Color.buttonDisableColor;
            }
        } else {
            _gotImage.hidden = YES;
            _examTitle.frame = CGRectMake(12, 14, _whiteBack.width - 12, 20);
            [_getOrExamBtn setTitle:@"购买" forState:0];
        }
    }
}

- (void)setExamPointCell:(NSDictionary *)dict {
    _specialInfo = dict;
    _examPoint.hidden = NO;
    _lineView.hidden = NO;
    _learnCount.hidden = NO;
    _priceLabel.hidden = NO;
    _gotImage.hidden = YES;
    
    _examTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    _examPoint.numberOfLines = 0;
    _examPoint.frame = CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, 14);
    _examPoint.text = [NSString stringWithFormat:@"%@",dict[@"intro"]];
    _learnCount.text = [NSString stringWithFormat:@"%@人已练习",dict[@"bought_count"]];
    
    [_examPoint sizeToFit];
    
    _examPoint.frame = CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, _examPoint.height);
    
    if (_examPoint.height > (11*3 + 7.5*2)) {
        _examPoint.frame = CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, 11*3 + 7.5*2);
    }
    
    _examCount.text = [NSString stringWithFormat:@"%@套",dict[@"paper_count"]];
    CGFloat examCountWidth = [_examCount.text sizeWithFont:_examCount.font].width + 4;
    _examCount.frame = CGRectMake(12, _examPoint.bottom + 12, examCountWidth, 16);
    
    [_lineView setLeft:_examCount.right + 8];
    [_learnCount setLeft:_lineView.right + 8];
    _lineView.centerY = _examCount.centerY;
    _learnCount.centerY = _examCount.centerY;
    
    _priceLabel.frame = CGRectMake(_whiteBack.width - (100 + 14 + 82 + 12), 0, 100, 21);
    NSString *priceCount = [NSString stringWithFormat:@"%@",dict[@"user_price"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,dict[@"user_price"]];
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    _priceLabel.frame = CGRectMake(_whiteBack.width - (priceWidth + 14 + 82 + 12), 0, priceWidth, 21);
    
    _priceLabel.centerY = _examCount.centerY;
    _getOrExamBtn.centerY = _examCount.centerY;
    
    if ([priceCount isEqualToString:@"0.00"] || [priceCount isEqualToString:@"0.0"] || [priceCount isEqualToString:@"0"]) {
        _priceLabel.hidden = YES;
        _gotImage.hidden = NO;
        _gotImage.image = Image(@"exam_free_icon");
        _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20);
        [_getOrExamBtn setTitle:@"开始答题" forState:0];
    } else {
        // 不是免费的
        _priceLabel.hidden = NO;
        if ([[NSString stringWithFormat:@"%@",dict[@"has_bought"]] boolValue]) {
            // 已购买
            _priceLabel.hidden = YES;
            _gotImage.hidden = NO;
            _gotImage.image = Image(@"exam_yigouamai_icon");
            _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20);
            [_getOrExamBtn setTitle:@"开始答题" forState:0];
        } else {
            _gotImage.hidden = YES;
            _examTitle.frame = CGRectMake(12, 14, _whiteBack.width - 12, 20);
            [_getOrExamBtn setTitle:@"购买" forState:0];
        }
    }
    
    [_whiteBack setHeight:_examCount.top + 36];
    
    [self setHeight:_whiteBack.height + 10];
}

- (void)setExamPointDetailCell:(NSDictionary *)dict {
    
    _specialInfo = dict;
    
    _whiteBack.frame = CGRectMake(0, 0, MainScreenWidth, 93);
    _whiteBack.backgroundColor = [UIColor whiteColor];
    _whiteBack.layer.masksToBounds = YES;
    _whiteBack.layer.cornerRadius = 0;
    
    
    _gotImage.frame = CGRectMake(15, 0, 36, 16);
    
    _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 15), 20);
    _examTitle.font = SYSTEMFONT(16);
    _examTitle.textColor = EdlineV5_Color.textFirstColor;
    _gotImage.centerY = _examTitle.centerY;
    
    _examPoint.frame = CGRectMake(15, _examTitle.bottom + 6, _whiteBack.width - 30, 14);
    
    _priceLabel.frame = CGRectMake(_whiteBack.width - (100 + 14 + 82 + 15), 0, 100, 21);
    
    _getOrExamBtn.frame = CGRectMake(_priceLabel.right + 14, 0, 82, 28);
    
    _examTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    _examPoint.numberOfLines = 0;
    _examPoint.frame = CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, 14);
    _examPoint.text = [NSString stringWithFormat:@"%@",dict[@"intro"]];
    _learnCount.text = [NSString stringWithFormat:@"%@人已练习",dict[@"bought_count"]];
    
    [_examPoint sizeToFit];
    
    _examPoint.frame = CGRectMake(15, _examTitle.bottom + 6, _whiteBack.width - 30, _examPoint.height);
    
    if (_examPoint.height > (11*3 + 7.5*2)) {
        _examPoint.frame = CGRectMake(15, _examTitle.bottom + 6, _whiteBack.width - 30, 11*3 + 7.5*2);
    }
    
    _examCount.text = [NSString stringWithFormat:@"%@套",dict[@"paper_count"]];
    CGFloat examCountWidth = [_examCount.text sizeWithFont:_examCount.font].width + 4;
    _examCount.frame = CGRectMake(15, _examPoint.bottom + 12, examCountWidth, 16);
    
    [_lineView setLeft:_examCount.right + 8];
    [_learnCount setLeft:_lineView.right + 8];
    _lineView.centerY = _examCount.centerY;
    _learnCount.centerY = _examCount.centerY;
    
    _priceLabel.frame = CGRectMake(_whiteBack.width - (100 + 14 + 82 + 12), 0, 100, 21);
    NSString *priceCount = [NSString stringWithFormat:@"%@",dict[@"user_price"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,dict[@"user_price"]];
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    _priceLabel.frame = CGRectMake(_whiteBack.width - (priceWidth + 14 + 82 + 12), 0, priceWidth, 21);
    
    _priceLabel.centerY = _examCount.centerY;
    _getOrExamBtn.centerY = _examCount.centerY;
    
    if ([priceCount isEqualToString:@"0.00"] || [priceCount isEqualToString:@"0.0"] || [priceCount isEqualToString:@"0"]) {
        _priceLabel.hidden = YES;
        _gotImage.hidden = NO;
        _gotImage.image = Image(@"exam_free_icon");
        _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20);
        [_getOrExamBtn setTitle:@"开始答题" forState:0];
    } else {
        // 不是免费的
        _priceLabel.hidden = NO;
        if ([[NSString stringWithFormat:@"%@",dict[@"has_bought"]] boolValue]) {
            // 已购买
            _priceLabel.hidden = YES;
            _gotImage.hidden = NO;
            _gotImage.image = Image(@"exam_yigouamai_icon");
            _examTitle.frame = CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20);
            [_getOrExamBtn setTitle:@"开始答题" forState:0];
        } else {
            _gotImage.hidden = YES;
            _examTitle.frame = CGRectMake(12, 14, _whiteBack.width - 12, 20);
            [_getOrExamBtn setTitle:@"购买" forState:0];
        }
    }
    
    [_whiteBack setHeight:_examCount.top + 36];
    
    [self setHeight:_whiteBack.height];
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
