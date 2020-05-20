//
//  LearnRecordCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LearnRecordCell.h"
#import "V5_Constant.h"

@implementation LearnRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 35 + 14, 21)];
    _timeLabel.font = SYSTEMFONT(13);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.text = @"09:33";
    [self addSubview:_timeLabel];
    
    _dianView = [[UIView alloc] initWithFrame:CGRectMake(_timeLabel.right, 0, 8, 8)];
    _dianView.backgroundColor = HEXCOLOR(0xB7BAC1);
    _dianView.layer.masksToBounds = YES;
    _dianView.layer.cornerRadius = 4;
    _dianView.centerY = _timeLabel.centerY;
    [self addSubview:_dianView];
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 6.5)];
    _topLine.backgroundColor = HEXCOLOR(0xB7BAC1);
    _topLine.centerX = _dianView.centerX;
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _dianView.bottom, 1, 96 - _dianView.bottom)];
    _bottomLine.backgroundColor = HEXCOLOR(0xB7BAC1);
    _bottomLine.centerX = _dianView.centerX;
    [self addSubview:_bottomLine];
    
    _courseTitle = [[UILabel alloc] initWithFrame:CGRectMake(_dianView.right + 14, 0, MainScreenWidth - 15 - _dianView.right - 14, 21)];
    _courseTitle.font = SYSTEMFONT(15);
    _courseTitle.textColor = EdlineV5_Color.textFirstColor;
    _courseTitle.text = @"课程标题显示这的在这里显示这的在…";
    [self addSubview:_courseTitle];
    
    _courseHourseTitle = [[UILabel alloc] initWithFrame:CGRectMake(_courseTitle.left, _courseTitle.bottom + 5, MainScreenWidth - 15 - _dianView.right - 14, 18)];
    _courseHourseTitle.font = SYSTEMFONT(13);
    _courseHourseTitle.textColor = EdlineV5_Color.textThirdColor;
    _courseHourseTitle.text = @"课时名称显示课时名称显示";
    [self addSubview:_courseHourseTitle];
    
    _learnTime = [[UILabel alloc] initWithFrame:CGRectMake(_courseTitle.left, _courseHourseTitle.bottom + 10, MainScreenWidth - 15 - _dianView.right - 14, 15)];
    _learnTime.font = SYSTEMFONT(11);
    _learnTime.textColor = EdlineV5_Color.textThirdColor;
    _learnTime.text = @"学习至 01:12:32";
    [self addSubview:_learnTime];
    
}

- (void)setLearnRecordInfo:(NSDictionary *)recordInfo {
    _timeLabel.text = [EdulineV5_Tool timeForHHmm:[recordInfo objectForKey:@"update_time"]];
    
    _courseTitle.text = [NSString stringWithFormat:@"%@",[recordInfo objectForKey:@"course_title"]];
    
    _courseHourseTitle.text = [NSString stringWithFormat:@"%@",[recordInfo objectForKey:@"section_title"]];
    
    _learnTime.text = [NSString stringWithFormat:@" 学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:[[recordInfo objectForKey:@"current_time"] integerValue]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
