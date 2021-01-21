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
    
    _whiteBack = [[UIView alloc] initWithFrame:CGRectMake(15, 10, MainScreenWidth - 30, 93)];
    _whiteBack.backgroundColor = [UIColor whiteColor];
    _whiteBack.layer.masksToBounds = YES;
    _whiteBack.layer.cornerRadius = 4;
    [self.contentView addSubview:_whiteBack];
    
    _gotImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 36, 16)];
    _gotImage.image = Image(@"exam_yigouamai_icon");
    [_whiteBack addSubview:_gotImage];
    
    _examTitle = [[UILabel alloc] initWithFrame:CGRectMake(_gotImage.right + 6, 14, _whiteBack.width - (_gotImage.right + 6 + 12), 20)];
    _examTitle.font = SYSTEMFONT(15);
    _examTitle.text = @"考试标题只能显示1排文字题只能显示1排文字";
    _examTitle.textColor = EdlineV5_Color.textFirstColor;
    [_whiteBack addSubview:_examTitle];
    _gotImage.centerY = _examTitle.centerY;
    
    _examPoint = [[UILabel alloc] initWithFrame:CGRectMake(12, _examTitle.bottom + 6, _whiteBack.width - 24, 14)];
    _examPoint.font = SYSTEMFONT(11);
    _examPoint.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBack addSubview:_examPoint];
    
    _examCount = [[UILabel alloc] initWithFrame:CGRectMake(12, _whiteBack.height - 36, 80, 16)];
    _examCount.font = SYSTEMFONT(12);
    _examCount.textColor = EdlineV5_Color.textThirdColor;
    _examCount.text = @"共40题";
    [_whiteBack addSubview:_examCount];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_examCount.right + 8, 0, 0.5, 8)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
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
    _examPoint.hidden = YES;
    _lineView.hidden = YES;
    _learnCount.hidden = YES;
}

- (void)setExamPointCell:(NSDictionary *)dict {
    
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
