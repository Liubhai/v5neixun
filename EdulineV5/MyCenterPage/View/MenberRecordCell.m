//
//  MenberRecordCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MenberRecordCell.h"
#import "V5_Constant.h"

@implementation MenberRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150 + 23)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 23, MainScreenWidth - 30, 150)];
    _whiteBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
//    _whiteBackView.layer.masksToBounds = YES;
    _whiteBackView.layer.cornerRadius = 4;
    _whiteBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _whiteBackView.layer.shadowOffset = CGSizeMake(0,1);
    _whiteBackView.layer.shadowOpacity = 1;
    _whiteBackView.layer.shadowRadius = 12;
    [_backView addSubview:_whiteBackView];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 15, 13)];
    _icon.image = Image(@"vip_icon");
    [_whiteBackView addSubview:_icon];

    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + 3, 7.5, 100, 21)];
    _themeLabel.font = SYSTEMFONT(15);
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [_whiteBackView addSubview:_themeLabel];

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBackView.width - 12 - 100, _themeLabel.top, 100, _themeLabel.height)];
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.font = SYSTEMFONT(14);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_whiteBackView addSubview:_timeLabel];

    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, _whiteBackView.width, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_whiteBackView addSubview:_lineView];

    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _lineView.bottom + 12, _whiteBackView.width - 24, 20)];
    _numberLabel.textColor = EdlineV5_Color.textThirdColor;
    _numberLabel.font = SYSTEMFONT(14);
    [_whiteBackView addSubview:_numberLabel];

    _openTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _numberLabel.bottom + 12, _whiteBackView.width - 24, 20)];
    _openTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    _openTimeLabel.font = SYSTEMFONT(14);
    [_whiteBackView addSubview:_openTimeLabel];

    _timeLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _openTimeLabel.bottom + 12, _whiteBackView.width - 24, 20)];
    _timeLineLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLineLabel.font = SYSTEMFONT(14);
    [_whiteBackView addSubview:_timeLineLabel];
    
}

- (void)setMemberInfo:(NSDictionary *)info {
    NSString *typeS = [NSString stringWithFormat:@"%@",info[@"ext_data"][@"vip_title"]];
    _themeLabel.text = typeS;

    _timeLabel.text = [NSString stringWithFormat:@"育币%@",info[@"payment"]];

    _numberLabel.text = [NSString stringWithFormat:@"订单编号：%@",info[@"order_no"]];
    NSMutableAttributedString *mut1 = [[NSMutableAttributedString alloc] initWithString:_numberLabel.text];
    [mut1 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor} range:NSMakeRange(0, 5)];
    _numberLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut1];

    _openTimeLabel.text = [NSString stringWithFormat:@"充值时间：%@",[EdulineV5_Tool timeForBalanceYYMMDDHHMM:[NSString stringWithFormat:@"%@",info[@"payment_time"]]]];
    NSMutableAttributedString *mut2 = [[NSMutableAttributedString alloc] initWithString:_openTimeLabel.text];
    [mut2 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor} range:NSMakeRange(0, 5)];
    _openTimeLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut2];

    _timeLineLabel.text = [NSString stringWithFormat:@"有效期至：%@",[EdulineV5_Tool timeForYYYYMMDD:[NSString stringWithFormat:@"%@",info[@"expire_time"]]]];
    NSMutableAttributedString *mut3 = [[NSMutableAttributedString alloc] initWithString:_timeLineLabel.text];
    [mut3 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor} range:NSMakeRange(0, 5)];
    _timeLineLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut3];
    
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
