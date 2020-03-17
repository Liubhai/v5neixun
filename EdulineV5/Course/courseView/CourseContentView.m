//
//  CourseContentView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseContentView.h"

@implementation CourseContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _lianzaiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 16)];
    _lianzaiIcon.image = Image(@"icon_lianzai");
    [self addSubview:_lianzaiIcon];
    
    _courseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lianzaiIcon.right + 8, 12, MainScreenWidth - (_lianzaiIcon.right + 8) - 15, 32)];
    _courseTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _courseTitleLabel.font = SYSTEMFONT(16);
    _courseTitleLabel.text = @"面授课考试标题显示标题文字有点标题显";
    [self addSubview:_courseTitleLabel];
    _lianzaiIcon.centerY = _courseTitleLabel.centerY;
    
    _courseScore = [[UILabel alloc] initWithFrame:CGRectMake(15, _courseTitleLabel.bottom, 33, 34)];
    _courseScore.text = @"4.1分";
    _courseScore.textColor = EdlineV5_Color.textzanColor;
    _courseScore.font = SYSTEMFONT(13);
    [self addSubview:_courseScore];
    
    /** 不带边框星星 **/
    _courseStar = [[StarEvaluator alloc] initWithFrame:CGRectMake(_courseScore.right + 3, _courseScore.top, 76, 12)];
    _courseStar.centerY = _courseScore.centerY;
    [self addSubview:_courseStar];
    _courseStar.userInteractionEnabled = NO;
    [_courseStar setStarValue:4.1];
    
    _courseLearn = [[UILabel alloc] initWithFrame:CGRectMake(_courseStar.right + 8, _courseScore.top, 58, 34)];
    _courseLearn.font = SYSTEMFONT(12);
    _courseLearn.textColor = EdlineV5_Color.textThirdColor;
    _courseLearn.text = @"12人在学";
    [self addSubview:_courseLearn];
    
    _coursePrice = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 75, _courseScore.top, 75, 34)];
    _coursePrice.textAlignment = NSTextAlignmentRight;
    _coursePrice.text = @"¥1,199";
    _coursePrice.textColor = EdlineV5_Color.faildColor;
    _coursePrice.font = SYSTEMFONT(18);
    [self addSubview:_coursePrice];
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _courseScore.bottom + 10, MainScreenWidth, 4)];
    _lineView1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView1];
    [self setHeight:_lineView1.bottom];
}

@end
