//
//  CourseActivityView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CourseActivityView.h"
#import "V5_Constant.h"

@implementation CourseActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _backIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _backIconImage.image = Image(@"detials_pintuan_bg");
    [self addSubview:_backIconImage];
    
    _groupSellPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 3, 200, 23)];
    NSString *sellPrice = @"16999.99";
    NSString *moneyIcon = [NSString stringWithFormat:@"%@",IOSMoneyTitle];
    NSString *fullSellPrice = [NSString stringWithFormat:@"%@%@",moneyIcon,sellPrice];
    NSRange rangNow = NSMakeRange(moneyIcon.length, sellPrice.length);
    NSRange rangOld = NSMakeRange(0, moneyIcon.length);
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:fullSellPrice];
    [priceAtt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]} range:rangOld];
    [priceAtt addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:22],NSForegroundColorAttributeName:[UIColor whiteColor]} range:rangNow];
    _groupSellPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    [self addSubview:_groupSellPriceLabel];
    
    _groupOriginPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupSellPriceLabel.left, _groupSellPriceLabel.bottom + 0.5, _groupSellPriceLabel.width, 15)];
    NSString *originPrice = @"23999.99";
    NSString *fullOriginPrice = [NSString stringWithFormat:@"%@%@",moneyIcon,originPrice];
    NSMutableAttributedString *priceOriginAtt = [[NSMutableAttributedString alloc] initWithString:fullOriginPrice];
    [priceOriginAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, fullOriginPrice.length)];
    _groupOriginPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceOriginAtt];
    _groupOriginPriceLabel.alpha = 0.82;
    [self addSubview:_groupOriginPriceLabel];
    
    _groupTimeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 120, 5.5, 120, 14)];
    _groupTimeTipLabel.font = SYSTEMFONT(10);
    _groupTimeTipLabel.textAlignment = NSTextAlignmentCenter;
    _groupTimeTipLabel.text = @"距结束仅剩";
    _groupTimeTipLabel.textColor = EdlineV5_Color.courseActivityGroupColor;
    [self addSubview:_groupTimeTipLabel];
    
    _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 20 - 17, _groupTimeTipLabel.bottom + 2, 17, 18)];
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.layer.cornerRadius = 3.0;
    _secondLabel.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _secondLabel.font = SYSTEMFONT(10);
    _secondLabel.textColor = [UIColor whiteColor];
    _secondLabel.text = @"23";
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_secondLabel];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(_secondLabel.left - 6, _secondLabel.top, 6, 18)];
    _label2.font = SYSTEMFONT(10);
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.text = @":";
    _label2.textColor = EdlineV5_Color.courseActivityGroupColor;
    [self addSubview:_label2];
    
    _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(_label2.left - 17, _secondLabel.top, 17, 18)];
    _minuteLabel.layer.masksToBounds = YES;
    _minuteLabel.layer.cornerRadius = 3.0;
    _minuteLabel.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _minuteLabel.font = SYSTEMFONT(10);
    _minuteLabel.textColor = [UIColor whiteColor];
    _minuteLabel.text = @"33";
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_minuteLabel];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(_minuteLabel.left - 6, _secondLabel.top, 6, 18)];
    _label1.font = SYSTEMFONT(10);
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.text = @":";
    _label1.textColor = EdlineV5_Color.courseActivityGroupColor;
    [self addSubview:_label1];
    
    _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_label1.left - 17, _secondLabel.top, 17, 18)];
    _hourLabel.layer.masksToBounds = YES;
    _hourLabel.layer.cornerRadius = 3.0;
    _hourLabel.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _hourLabel.font = SYSTEMFONT(10);
    _hourLabel.textColor = [UIColor whiteColor];
    _hourLabel.text = @"12";
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hourLabel];
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hourLabel.left - 6 - 30, _secondLabel.top, 30, 18)];
    _dayLabel.textColor = EdlineV5_Color.courseActivityGroupColor;
    _dayLabel.font = SYSTEMFONT(10);
    _dayLabel.textAlignment = NSTextAlignmentRight;
    _dayLabel.text = @"100天";
    [self addSubview:_dayLabel];
}


@end
