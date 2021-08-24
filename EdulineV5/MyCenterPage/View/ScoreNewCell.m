//
//  ScoreNewCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/24.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ScoreNewCell.h"
#import "V5_Constant.h"

#define scoreCellWith MainScreenWidth - 30

@implementation ScoreNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 12, 150, 21)];
    _scoreTitle.font = SYSTEMFONT(16);
    _scoreTitle.textColor = EdlineV5_Color.textFirstColor;
    [self.contentView addSubview:_scoreTitle];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, _scoreTitle.bottom + 5, 150, 19)];
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_timeLabel];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scoreCellWith - 15 - 15, 0, 15, 15)];
    _iconImageView.image = Image(@"integral_small_icon");
    _iconImageView.centerY = 70 / 2.0;
    [self.contentView addSubview:_iconImageView];
    
    _scoreCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.left - 3 - 100, 0, 100, 30)];
    _scoreCountLabel.font = SYSTEMFONT(15);
    _scoreCountLabel.textColor = HEXCOLOR(0xFF8A52);
    _scoreCountLabel.textAlignment = NSTextAlignmentRight;
    _scoreCountLabel.centerY = 70 / 2.0;
    [self.contentView addSubview:_scoreCountLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(22, 69, scoreCellWith - 22 - 15, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
}

//"type": 4, //变动类型【1:充值;2:冻结;3:解冻;4:网页操作增加;5:兑换收入扣除;6:兑换商品扣除;】
//"num": 4, //变动积分数量
//"create_time": 1623138739, //变动积分时间
//"note": "购买课程《这个课程是用来测一下完结课时的》获得的积分", //业务备注
//"rel_type": "course", //积分操作类型
//"rel_type_text": "购买课程" //积分操作类型名称

- (void)setScoreInfo:(NSDictionary *)dict {
    
    _scoreTitle.text = [NSString stringWithFormat:@"%@",dict[@"rel_type_text"]];
    _timeLabel.text = [EdulineV5_Tool formateYYYYMMDDHHMMTime:[NSString stringWithFormat:@"%@",dict[@"create_time"]]];
    NSString *typeS = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([typeS isEqualToString:@"2"] || [typeS isEqualToString:@"5"] || [typeS isEqualToString:@"6"]) {
        _scoreCountLabel.text = [NSString stringWithFormat:@"-%@",[dict objectForKey:@"num"]];
        _scoreCountLabel.textColor = EdlineV5_Color.textFirstColor;
    } else {
        _scoreCountLabel.text = [NSString stringWithFormat:@"+%@",[dict objectForKey:@"num"]];
        _scoreCountLabel.textColor = HEXCOLOR(0xFF8A52);
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
