//
//  ScoreListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ScoreListCell.h"
#import "V5_Constant.h"

@implementation ScoreListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 50)];
    _scoreTitle.font = SYSTEMFONT(15);
    _scoreTitle.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_scoreTitle];
    
    _scoreChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 5 - 40, 5, 40, 40)];
    [_scoreChooseButton setImage:Image(@"checkbox_def") forState:0];
    [_scoreChooseButton setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_scoreChooseButton addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_scoreChooseButton];
    
    _scoreIntro = [[UILabel alloc] initWithFrame:CGRectMake(_scoreChooseButton.left - 150, 0, 150, 50)];
    _scoreIntro.font = SYSTEMFONT(13);
    _scoreIntro.textColor = EdlineV5_Color.textThirdColor;
    _scoreIntro.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_scoreIntro];
    
}

- (void)setScoreCellInfo:(ScoreListModel *)scoreModel cellIndexPath:(NSIndexPath *)cellIndexPath {
    _currentScoreModel = scoreModel;
    _cellIndexpath = cellIndexPath;
    
    _scoreTitle.text = [NSString stringWithFormat:@"%@积分",scoreModel.scoreCount];
    _scoreIntro.text = [NSString stringWithFormat:@"可抵%@%@",IOSMoneyTitle,scoreModel.scoreCount];
    _scoreChooseButton.selected = scoreModel.is_selected;
}

- (void)seleteButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(scoreChoose:)]) {
        [_delegate scoreChoose:self];
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
