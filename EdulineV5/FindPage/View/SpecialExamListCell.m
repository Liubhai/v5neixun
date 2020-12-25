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
    
    _examTitle = [[UILabel alloc] initWithFrame:CGRectMake(_gotImage.right + 6, 14, MainScreenWidth - (_gotImage.right + 6 + 12), 20)];
    _examTitle.font = SYSTEMFONT(15);
    _examTitle.textColor = EdlineV5_Color.textFirstColor;
    [_whiteBack addSubview:_examTitle];
    _gotImage.centerY = _examTitle.centerY;
    
    _examCount = [[UILabel alloc] initWithFrame:CGRectMake(12, _whiteBack.height - 36, 80, 16)];
    _examCount.font = SYSTEMFONT(12);
    _examCount.textColor = EdlineV5_Color.textThirdColor;
    [_whiteBack addSubview:_examCount];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBack.width - (100 + 14 + 82 + 12), 0, 100, 21)];
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_whiteBack addSubview:_priceLabel];
    
    _getOrExamBtn = [[UIButton alloc] initWithFrame:CGRectMake(_priceLabel.right + 14, 0, 82, 28)];
    _getOrExamBtn.backgroundColor = EdlineV5_Color.themeColor;
    _getOrExamBtn.layer.masksToBounds = YES;
    _getOrExamBtn.layer.cornerRadius = _getOrExamBtn.height / 2.0;
    [_getOrExamBtn setTitleColor:[UIColor whiteColor] forState:0];
    _getOrExamBtn.titleLabel.font = SYSTEMFONT(14);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
