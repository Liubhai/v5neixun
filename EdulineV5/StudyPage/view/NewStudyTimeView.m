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
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 + MACRO_UI_LIUHAI_HEIGHT)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    
    _studyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 + MACRO_UI_LIUHAI_HEIGHT)];
    _studyIcon.image = Image(@"study_card_img_neixun");
    _studyIcon.backgroundColor = EdlineV5_Color.themeColor;
    [self addSubview:_studyIcon];
    CGFloat ww = (MainScreenWidth - 100) / 3.0;
    for (int i = 0; i<6; i++) {
        UILabel *timeCount = [[UILabel alloc] initWithFrame:CGRectMake(25 + (i%3) * (ww + 25), MACRO_UI_LIUHAI_HEIGHT + 44 + (i/3) * (39 + 27), ww, 27)];
        timeCount.font = SYSTEMFONT(20);
        timeCount.textColor = [UIColor whiteColor];
        [_studyIcon addSubview:timeCount];
        
        UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(timeCount.left, timeCount.bottom + 2, timeCount.width, 18)];
        theme.font = SYSTEMFONT(12);
        theme.textColor = [UIColor whiteColor];
        [_studyIcon addSubview:theme];
        
        if (i == 0) {
            theme.text = @"完成/参与课程";
            _courseCount = timeCount;
            _courseCount.text = @"12/24";
            _courseLabel = theme;
        } else if (i == 1) {
            theme.text = @"完成/参与计划";
            _planCount = timeCount;
            _planCount.text = @"10/30";
            _planLabel = theme;
        } else if (i == 2) {
            theme.text = @"获得证书";
            _certificateCount = timeCount;
            _certificateCount.text = @"2";
            _certificateLabel = theme;
        } else if (i == 3) {
            theme.text = @"今日学习";
            _todayLearnTime = timeCount;
            _todayLearn = theme;
        } else if (i == 4) {
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

            NSString *course_count = [NSString stringWithFormat:@"%@",timeInfoData[@"course_count"]];
            NSString *course_finished_count = [NSString stringWithFormat:@"%@",timeInfoData[@"course_finished_count"]];
            NSString *plan_count = [NSString stringWithFormat:@"%@",timeInfoData[@"plan_count"]];
            NSString *plan_finished_count = [NSString stringWithFormat:@"%@",timeInfoData[@"plan_finished_count"]];
            NSString *cert_count = [NSString stringWithFormat:@"%@",timeInfoData[@"cert_count"]];
            _courseCount.text = [NSString stringWithFormat:@"%@/%@",course_finished_count,course_count];
            _planCount.text = [NSString stringWithFormat:@"%@/%@",plan_finished_count,plan_count];
            _certificateCount.text = [NSString stringWithFormat:@"%@",cert_count];
        }
    }
}


@end
