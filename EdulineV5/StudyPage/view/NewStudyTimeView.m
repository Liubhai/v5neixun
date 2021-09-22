//
//  NewStudyTimeView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "NewStudyTimeView.h"
#import "V5_Constant.h"

@implementation NewStudyTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    _studyIcon.layer.cornerRadius = 8;
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
        
        if (i == 0) {
            theme.text = @"今日学习";
            _todayLearnTime = timeCount;
            _todayLearn = theme;
        } else if (i == 1) {
            theme.text = @"连续学习";
            _continuousLearnTime = timeCount;
            _continuousLearn = theme;
        } else {
            theme.text = @"累计学习";
            _allLearnTime = timeCount;
            _allLearn = theme;
        }
    }
}

- (void)newStudyPageTimeInfo:(NSDictionary *)timeInfo {
    if (SWNOTEmptyDictionary(timeInfo)) {
        if ([[[timeInfo objectForKey:@"data"] allKeys] count]) {
            NSDictionary *timeInfoData = [NSDictionary dictionaryWithDictionary:[[timeInfo objectForKey:@"data"] objectForKey:@"basic"]];
            _todayLearnTime.attributedText = [EdulineV5_Tool attributionTimeChangeWithSeconds:[[timeInfoData objectForKey:@"today_learn_time"] integerValue] isMinite:YES];
            NSString *daysTime = [NSString stringWithFormat:@"%@天",[timeInfoData objectForKey:@"days"] ? [timeInfoData objectForKey:@"days"] : @"0"];
            NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:daysTime];
            [pass addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:SYSTEMFONT(10)} range:NSMakeRange(0, daysTime.length)];
            [pass addAttributes:@{NSFontAttributeName:SYSTEMFONT(20)} range:NSMakeRange(0, daysTime.length-1)];
            _continuousLearnTime.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
            _allLearnTime.attributedText = [EdulineV5_Tool attributionTimeChangeWithSeconds:[[timeInfoData objectForKey:@"total_learn_time"] integerValue] isMinite:NO];
        }
    }
}


@end
