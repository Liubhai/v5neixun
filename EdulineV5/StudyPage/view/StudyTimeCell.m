//
//  StudyTimeCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyTimeCell.h"
#import "V5_Constant.h"

@implementation StudyTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    
    _studyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, MainScreenWidth - 30, 100)];
    _studyIcon.image = Image(@"study_card_img");
    _studyIcon.layer.masksToBounds = YES;
    _studyIcon.layer.cornerRadius = 16;
    _studyIcon.backgroundColor = EdlineV5_Color.themeColor;
    [self addSubview:_studyIcon];
    
    for (int i = 0; i<3; i++) {
        UILabel *timeCount = [[UILabel alloc] initWithFrame:CGRectMake(_studyIcon.width * i /3.0, 22, _studyIcon.width / 3.0, 26)];
        timeCount.font = SYSTEMFONT(22);
        timeCount.textColor = [UIColor whiteColor];
        timeCount.textAlignment = NSTextAlignmentCenter;
        [_studyIcon addSubview:timeCount];
        
        UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(timeCount.left, timeCount.bottom + 6, _studyIcon.width / 3.0, 18)];
        theme.font = SYSTEMFONT(13);
        theme.textColor = [UIColor whiteColor];
        theme.textAlignment = NSTextAlignmentCenter;
        [_studyIcon addSubview:theme];
        
        timeCount.text = @"99";
        
        if (i == 0) {
            theme.text = @"今日学习(分钟)";
            _todayLearnTime = timeCount;
            _todayLearn = theme;
        } else if (i == 1) {
            theme.text = @"连续学习(天)";
            _continuousLearnTime = timeCount;
            _continuousLearn = theme;
        } else {
            theme.text = @"累计学习(小时)";
            _allLearnTime = timeCount;
            _allLearn = theme;
        }
    }
}

- (void)studyPageTimeInfo:(NSDictionary *)timeInfo {
    if (SWNOTEmptyDictionary(timeInfo)) {
        if ([[[timeInfo objectForKey:@"data"] allKeys] count]) {
            NSDictionary *timeInfoData = [NSDictionary dictionaryWithDictionary:[[timeInfo objectForKey:@"data"] objectForKey:@"basic"]];
            _todayLearnTime.text = [NSString stringWithFormat:@"%@",[timeInfoData objectForKey:@"today_learn_time"] ? [timeInfoData objectForKey:@"today_learn_time"] :@"0"];
            _continuousLearnTime.text = [NSString stringWithFormat:@"%@",[timeInfoData objectForKey:@"days"] ? [timeInfoData objectForKey:@"days"] : @"0"];
            _allLearnTime.text = [NSString stringWithFormat:@"%@",[timeInfoData objectForKey:@"total_learn_time"] ? [timeInfoData objectForKey:@"total_learn_time"] : @"0"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
