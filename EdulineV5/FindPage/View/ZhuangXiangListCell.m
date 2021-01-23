//
//  ZhuangXiangListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ZhuangXiangListCell.h"
#import "V5_Constant.h"

@implementation ZhuangXiangListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _jiantouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 13, 13)];
    _jiantouImageView.image = [Image(@"exam_up_icon") converToMainColor];
    [self.contentView addSubview:_jiantouImageView];
    
    _getOrFreeIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(_jiantouImageView.right + 2, 0, 36, 16)];
    _getOrFreeIamgeView.image = Image(@"exam_yigouamai_icon");
    [self.contentView addSubview:_getOrFreeIamgeView];
    
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 5, 5)];
    _blueView.backgroundColor = EdlineV5_Color.themeColor;
    _blueView.layer.masksToBounds = YES;
    _blueView.layer.cornerRadius = _blueView.height / 2.0;
    [self.contentView addSubview:_blueView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_getOrFreeIamgeView.right + 4, 15, MainScreenWidth - 15 - (_getOrFreeIamgeView.right + 4), 20)];
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.font = SYSTEMFONT(15);
    _titleLabel.text = @"专项名称高中一年专项名称高中一年";
    [self.contentView addSubview:_titleLabel];
    
    _jiantouImageView.centerY = _titleLabel.centerY;
    _getOrFreeIamgeView.centerY = _titleLabel.centerY;
    _blueView.centerY = _titleLabel.centerY;
    
    _learnProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_titleLabel.left, 87 - 22 - 6, 60, 6)];
    _learnProgress.layer.masksToBounds = YES;
    _learnProgress.layer.cornerRadius = 3;
    _learnProgress.progress = 0.5;
    //设置它的风格，为默认的
    _learnProgress.trackTintColor= HEXCOLOR(0xF1F1F1);
    //设置轨道的颜色
    _learnProgress.progressTintColor= EdlineV5_Color.themeColor;
    [self.contentView addSubview:_learnProgress];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_learnProgress.right + 5, 0, 100, 14)];
    _progressLabel.font = SYSTEMFONT(11);
    _progressLabel.textColor = EdlineV5_Color.textThirdColor;
    _progressLabel.text = @"12/33";
    [self.contentView addSubview:_progressLabel];
    _progressLabel.centerY = _learnProgress.centerY;
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - (100 + 14 + 82 + 15), 0, 100, 21)];
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = [NSString stringWithFormat:@"%@12,099.00",IOSMoneyTitle];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    [self.contentView addSubview:_priceLabel];
    
    _getOrExamBtn = [[UIButton alloc] initWithFrame:CGRectMake(_priceLabel.right + 14, 0, 82, 28)];
    _getOrExamBtn.backgroundColor = EdlineV5_Color.themeColor;
    _getOrExamBtn.layer.masksToBounds = YES;
    _getOrExamBtn.layer.cornerRadius = _getOrExamBtn.height / 2.0;
    [_getOrExamBtn setTitleColor:[UIColor whiteColor] forState:0];
    _getOrExamBtn.titleLabel.font = SYSTEMFONT(14);
    [_getOrExamBtn setTitle:@"购买" forState:0];
    [_getOrExamBtn addTarget:self action:@selector(buttonClickBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_getOrExamBtn];
    
    _priceLabel.centerY = _learnProgress.centerY;
    _getOrExamBtn.centerY = _learnProgress.centerY;
    
    _doExamButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 22 - 15, 0, 22, 22)];
    [_doExamButton setImage:[Image(@"exam_icon_highlight") converToMainColor] forState:0];
    [_doExamButton addTarget:self action:@selector(buttonClickBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_doExamButton];
    _doExamButton.centerY = _learnProgress.centerY;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 86, MainScreenWidth, 1)];
    _lineView.backgroundColor = EdlineV5_Color.layarLineColor;
    [self.contentView addSubview:_lineView];
}



- (void)buttonClickBy:(UIButton *)sender {
    
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
