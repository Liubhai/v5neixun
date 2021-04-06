//
//  TaoJuanDetailListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "TaoJuanDetailListCell.h"
#import "V5_Constant.h"

@implementation TaoJuanDetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 30, 20)];
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.font = SYSTEMFONT(15);
    [self.contentView addSubview:_titleLabel];
    
//    _learnProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_titleLabel.left, 80 - 23, 60, 6)];
//    _learnProgress.layer.masksToBounds = YES;
//    _learnProgress.layer.cornerRadius = 3;
//    _learnProgress.progress = 0.5;
//    //设置它的风格，为默认的
//    _learnProgress.trackTintColor= HEXCOLOR(0xF1F1F1);
//    //设置轨道的颜色
//    _learnProgress.progressTintColor= EdlineV5_Color.themeColor;
//    [self.contentView addSubview:_learnProgress];
//
//    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_learnProgress.right + 5, 0, 100, 14)];
//    _progressLabel.font = SYSTEMFONT(11);
//    _progressLabel.textColor = EdlineV5_Color.textThirdColor;
//    [self.contentView addSubview:_progressLabel];
//    _progressLabel.centerY = _learnProgress.centerY;
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.bottom + 18, 100, 14)];//_progressLabel.right + 25
    _learnCountLabel.font = SYSTEMFONT(11);
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_learnCountLabel];
    
    _examDoButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 22, 0, 22, 22)];
    _examDoButton.centerY = _learnCountLabel.centerY;
    [_examDoButton setImage:Image(@"exam_icon_disabled") forState:0];
    [_examDoButton addTarget:self action:@selector(examDoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_examDoButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 79, MainScreenWidth - 15, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
    
}

- (void)setTaojuanDetailListCellInfo:(NSDictionary *)dict {
    _taojuanDetailInfo = dict;
    _titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
//    _progressLabel.text = @"12/30";
//    CGFloat progressWidth = [_progressLabel.text sizeWithFont:_progressLabel.font].width + 2;
//    [_progressLabel setWidth:progressWidth];
//    [_learnCountLabel setLeft:_progressLabel.right + 25];
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人练习",dict[@"bought_num"]];
}

- (void)examDoButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(doVolumeOrBuyExam:)]) {
        [_delegate doVolumeOrBuyExam:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
