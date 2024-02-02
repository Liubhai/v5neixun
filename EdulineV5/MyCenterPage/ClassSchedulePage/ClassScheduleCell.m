//
//  ClassScheduleCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/20.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ClassScheduleCell.h"
#import "V5_Constant.h"

@implementation ClassScheduleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - 30, 120)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 8;
    [self.contentView addSubview:_whiteView];
    
    _liveIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 16, 16)];
    _liveIcon.image = Image(@"livecourse_icon");
    [_whiteView addSubview:_liveIcon];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(_liveIcon.right + 8, _liveIcon.centerY - 18, _whiteView.width - 14, 36)];
    _fromLabel.textColor = EdlineV5_Color.textFirstColor;
    _fromLabel.font = [UIFont boldSystemFontOfSize:17];
    [_whiteView addSubview:_fromLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteView.width - 15 - 37, _fromLabel.top, 15 + 37, _fromLabel.height)];
    _statusLabel.font = SYSTEMFONT(12);
    _statusLabel.textColor = EdlineV5_Color.textThirdColor;
    [_whiteView addSubview:_statusLabel];
    
    _liveingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_statusLabel.left - 5 - 16, _liveIcon.centerY - 17 / 2.0, 16, 17)];
    _liveingIcon.image = [Image(@"comment_playing") converToMainColor];
    _liveingIcon.animationImages = @[[Image(@"playing1") converToMainColor],[Image(@"playing2") converToMainColor]];
    _liveingIcon.highlightedAnimationImages = @[[Image(@"playing1") converToMainColor],[Image(@"playing2") converToMainColor]];
    _liveingIcon.animationDuration = 0.4;
    [_whiteView addSubview:_liveingIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_liveIcon.left, _fromLabel.bottom, _whiteView.width - 30, 16 + 8)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [_whiteView addSubview:_titleLabel];
    
    _hourseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_liveIcon.left, _titleLabel.bottom, _titleLabel.width, 12 + 8)];
    _hourseLabel.font = SYSTEMFONT(12);
    _hourseLabel.textColor = EdlineV5_Color.textThirdColor;
    [_whiteView addSubview:_hourseLabel];
    
    _teacherName = [[UILabel alloc] initWithFrame:CGRectMake(_liveIcon.left, _hourseLabel.bottom, _titleLabel.width, 12 + 20)];
    _teacherName.font = SYSTEMFONT(12);
    _teacherName.textColor = EdlineV5_Color.textThirdColor;
    [_whiteView addSubview:_teacherName];
    
}

- (void)setClassScheduleCellInfo:(NSDictionary *)dict isTeacher:(BOOL)isTeacher {
    if (isTeacher) {
        _whiteView.frame = CGRectMake(15, 12, MainScreenWidth - 30, 120 - 32 + 5);
        _teacherName.hidden = YES;
    }
    _fromLabel.text = [NSString stringWithFormat:@"%@ - %@",[EdulineV5_Tool timeForHHmm:[NSString stringWithFormat:@"%@",dict[@"start_time"]]],[EdulineV5_Tool timeForHHmm:[NSString stringWithFormat:@"%@",dict[@"end_time"]]]];
    _titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"course_title"]];
    _hourseLabel.text = [NSString stringWithFormat:@"- %@",dict[@"sec_title"]];
    _teacherName.text = [NSString stringWithFormat:@"%@",dict[@"teacher_name"]];
//    【957：未开始；999：直播中；992：已结束；】
    NSString *statusString = [NSString stringWithFormat:@"%@",dict[@"live_status"]];
    _liveingIcon.hidden = YES;
    _statusLabel.hidden = NO;
    if ([statusString isEqualToString:@"957"]) {
        _statusLabel.hidden = YES;
        [_liveingIcon stopAnimating];
    } else if ([statusString isEqualToString:@"999"]) {
        _statusLabel.text = @"直播中";
        _liveingIcon.hidden = NO;
        _statusLabel.textColor = EdlineV5_Color.themeColor;
        [_liveingIcon startAnimating];
    } else if ([statusString isEqualToString:@"992"]) {
        _statusLabel.text = @"已结束";
        _statusLabel.textColor = EdlineV5_Color.textThirdColor;
        [_liveingIcon stopAnimating];
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
