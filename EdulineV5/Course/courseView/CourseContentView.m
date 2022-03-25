//
//  CourseContentView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseContentView.h"
#import "V5_UserModel.h"

@implementation CourseContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _lianzaiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 41, 18)];
    _lianzaiIcon.image = Image(@"star_icon");
    [self addSubview:_lianzaiIcon];
    
    _courseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lianzaiIcon.right + 8, 12, MainScreenWidth - (_lianzaiIcon.right + 8) - 15, 32)];
    _courseTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _courseTitleLabel.font = SYSTEMFONT(16);
    _courseTitleLabel.text = @"面授课考试标题显示标题文字有点标题显";
    [self addSubview:_courseTitleLabel];
    _lianzaiIcon.centerY = _courseTitleLabel.centerY;
    
    _courseScore = [[UILabel alloc] initWithFrame:CGRectMake(_lianzaiIcon.left + 20, _lianzaiIcon.top, 25, 18)];
    _courseScore.text = @"4.8";
    _courseScore.textColor = EdlineV5_Color.textzanColor;
    _courseScore.font = SYSTEMFONT(12);
    _courseScore.backgroundColor = [UIColor clearColor];
    [self addSubview:_courseScore];
    
    /** 不带边框星星 **/
    _courseStar = [[StarEvaluator alloc] initWithFrame:CGRectMake(_courseScore.right + 3, _courseScore.top, 76, 12)];
    _courseStar.centerY = _courseScore.centerY;
    _courseStar.hidden = YES;
    [self addSubview:_courseStar];
    _courseStar.userInteractionEnabled = NO;
    [_courseStar setStarValue:4.1];
    
    _sectionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 86 - 35, 50, 20)];
    _sectionCountLabel.font = SYSTEMFONT(14);
    _sectionCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _sectionCountLabel.hidden = YES;
    [self addSubview:_sectionCountLabel];
    
    _circle1 = [[UIView alloc] initWithFrame:CGRectMake(_sectionCountLabel.right + 4, 0, 3, 3)];
    _circle1.layer.masksToBounds = YES;
    _circle1.layer.cornerRadius = _circle1.height / 2.0;
    _circle1.backgroundColor = HEXCOLOR(0xD6D6D6);//EdlineV5_Color.backColor;
    [self addSubview:_circle1];
    _circle1.centerY = _sectionCountLabel.centerY;
    
    _courseLearn = [[UILabel alloc] initWithFrame:CGRectMake(_circle1.right + 8, _sectionCountLabel.top, 58, 20)];
    _courseLearn.font = SYSTEMFONT(12);
    _courseLearn.textColor = EdlineV5_Color.textThirdColor;
    _courseLearn.text = @"12人在学";
    [self addSubview:_courseLearn];
    
    _circle2 = [[UIView alloc] initWithFrame:CGRectMake(_courseLearn.right + 4, 0, 3, 3)];
    _circle2.layer.masksToBounds = YES;
    _circle2.layer.cornerRadius = _circle2.height / 2.0;
    _circle2.backgroundColor = HEXCOLOR(0xD6D6D6);//EdlineV5_Color.backColor;
    [self addSubview:_circle2];
    _circle2.centerY = _sectionCountLabel.centerY;
    
    _coursePrice = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 34)];
    _coursePrice.textAlignment = NSTextAlignmentRight;
    _coursePrice.textColor = EdlineV5_Color.textPriceColor;
    _coursePrice.font = SYSTEMFONT(16);
    [self addSubview:_coursePrice];
    
    _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_circle2.right + 8, _sectionCountLabel.top, 58, 20)];
    _dateTimeLabel.font = SYSTEMFONT(13);
    _dateTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_dateTimeLabel];
    
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _dateTimeLabel.bottom + 10, MainScreenWidth, 4)];
    _lineView1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView1];
    [self setHeight:_lineView1.bottom];
    
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - (32 + 4 + 6), 17, 32 + 4 + 6, 32)];
    [_detailButton setImage:Image(@"details_icon") forState:0];
    [_detailButton setTitle:@"详情" forState:0];
    _detailButton.titleLabel.font = SYSTEMFONT(14);
    [_detailButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    [EdulineV5_Tool dealButtonImageAndTitleUI:_detailButton];
    [_detailButton addTarget:self action:@selector(detailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _detailButton.hidden = YES;
    [self addSubview:_detailButton];
    
    _circleView = [[JustCircleProgress alloc] initWithFrame:CGRectMake(MainScreenWidth - 14 - 32, 0, 32, 32)];
    _circleView.centerY = _sectionCountLabel.centerY;
    _circleView.hidden = YES;
    [self addSubview:_circleView];
    
    _percentlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 12)];
    _percentlabel.font = SYSTEMFONT(9);
    _percentlabel.textColor = EdlineV5_Color.textSecendColor;
    _percentlabel.textAlignment = NSTextAlignmentCenter;
    _percentlabel.center = _circleView.center;
    _percentlabel.hidden = YES;
    [self addSubview:_percentlabel];
}

- (void)setCourseContentInfo:(NSDictionary *)contentInfo showTitleOnly:(BOOL)showTitleOnly {
    _courseInfo = [NSDictionary dictionaryWithDictionary:contentInfo];
    // 【0连载完成1连载中】
//    if ([[contentInfo objectForKey:@"update_status"] integerValue]) {
//        _lianzaiIcon.hidden = NO;
//        [_lianzaiIcon setWidth:32];
//        [_courseTitleLabel setLeft:_lianzaiIcon.right + 8];
//        [_courseTitleLabel setWidth:MainScreenWidth - _courseTitleLabel.left - 15];
//    } else {
//        _lianzaiIcon.hidden = YES;
//        [_lianzaiIcon setWidth:0];
//        [_courseTitleLabel setLeft:_lianzaiIcon.left];
//        [_courseTitleLabel setWidth:MainScreenWidth - _courseTitleLabel.left - 15];
//    }
    _courseTitleLabel.text = [NSString stringWithFormat:@"%@",[contentInfo objectForKey:@"title"]];
    
    _courseScore.text = [NSString stringWithFormat:@"%@",[contentInfo objectForKey:@"score_star"]];
    
    CGFloat courseScoreWidth = [_courseScore.text sizeWithFont:_courseScore.font].width + 4;
    [_courseScore setWidth:courseScoreWidth];
    [_courseStar setLeft:_courseScore.right + 3];
//    [_coursePrice setLeft:_courseLearn.right];
    
    [_courseStar setStarValue:[[NSString stringWithFormat:@"%@",[contentInfo objectForKey:@"score_star"]] floatValue]];
    _courseLearn.text = [NSString stringWithFormat:@"%@人在学",[contentInfo objectForKey:@"sale_count"]];
    
//    NSString *price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[contentInfo objectForKey:@"price"]]];
//    NSString *scribing_price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[contentInfo objectForKey:@"scribing_price"]]];
//
//    if ([[V5_UserModel vipStatus] isEqualToString:@"1"]) {
//        NSString *user_price = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[contentInfo objectForKey:@"user_price"]]];
//        if ([price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]] || ([[V5_UserModel vipStatus] isEqualToString:@"1"] && ([user_price isEqualToString:@"0.00"] || [user_price isEqualToString:@"0.0"] || [user_price isEqualToString:@"0"]))) {
//            price = @"免费";
//            NSString *finalPrice = [NSString stringWithFormat:@"%@%@",price,scribing_price];
//            NSRange rangNow = NSMakeRange(price.length, scribing_price.length);
//            NSRange rangOld = NSMakeRange(0, price.length);
//            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
//            [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(18),NSForegroundColorAttributeName: EdlineV5_Color.priceFreeColor} range:rangOld];
//            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
//            _coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
//        } else {
//            NSString *finalPrice = [NSString stringWithFormat:@"%@%@",user_price,scribing_price];
//            NSRange rangNow = NSMakeRange(user_price.length, scribing_price.length);
//            NSRange rangOld = NSMakeRange(0, user_price.length);
//            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
//            [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(18),NSForegroundColorAttributeName: EdlineV5_Color.textPriceColor} range:rangOld];
//            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
//            _coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
//        }
//    } else {
//        if ([scribing_price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [scribing_price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] || [scribing_price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]]) {
//            if ([price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] ||[price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]]) {
//                _coursePrice.text = @"免费";
//                _coursePrice.textColor = EdlineV5_Color.priceFreeColor;
//                _coursePrice.font = SYSTEMFONT(18);
//            } else {
//                _coursePrice.text = price;
//                _coursePrice.textColor = EdlineV5_Color.textPriceColor;
//                _coursePrice.font = SYSTEMFONT(18);
//            }
//        } else {
//            NSString *user_price = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[contentInfo objectForKey:@"user_price"]]];
//            if ([price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]] || ([[V5_UserModel vipStatus] isEqualToString:@"1"] && ([user_price isEqualToString:@"0.00"] || [user_price isEqualToString:@"0.0"] || [user_price isEqualToString:@"0"]))) {
//                price = @"免费";
//                NSString *finalPrice = [NSString stringWithFormat:@"%@%@",price,scribing_price];
//                NSRange rangNow = NSMakeRange(price.length, scribing_price.length);
//                NSRange rangOld = NSMakeRange(0, price.length);
//                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
//                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(18),NSForegroundColorAttributeName: EdlineV5_Color.priceFreeColor} range:rangOld];
//                [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
//                _coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
//            } else {
//                NSString *finalPrice = [NSString stringWithFormat:@"%@%@",price,scribing_price];
//                NSRange rangNow = NSMakeRange(price.length, scribing_price.length);
//                NSRange rangOld = NSMakeRange(0, price.length);
//                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
//                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(18),NSForegroundColorAttributeName: EdlineV5_Color.textPriceColor} range:rangOld];
//                [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
//                _coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
//            }
//        }
//    }
    
    if (showTitleOnly) {
        [_courseLearn setLeft:_courseStar.right + 8];
        _courseTitleLabel.frame = CGRectMake(15, 0, MainScreenWidth - 15 - (_detailButton.width + 15), 86 - 35);
        _lianzaiIcon.hidden = YES;
        _courseStar.hidden = YES;
        _coursePrice.hidden = YES;
        _courseScore.hidden = YES;
        _courseLearn.hidden = YES;
        _dateTimeLabel.hidden = YES;
        
        _sectionCountLabel.hidden = NO;
        _detailButton.hidden = NO;
        _detailButton.centerY = _courseTitleLabel.centerY;
        
        _sectionCountLabel.text = [NSString stringWithFormat:@"已完成：%@/%@",_courseInfo[@"finished_num"],_courseInfo[@"section_count"]];
        NSString *sectionCount = [NSString stringWithFormat:@"%@",_courseInfo[@"section_count"]];
        NSString *finishCount = [NSString stringWithFormat:@"%@",_courseInfo[@"finished_num"]];
        NSString *finishRate = [NSString stringWithFormat:@"%@",_courseInfo[@"learn_rate"]];
        _circleView.progress = [finishRate floatValue];//100 * [finishCount integerValue] / ([sectionCount integerValue] * 1.0);
        _circleView.hidden = NO;
        _percentlabel.hidden = NO;
        if ([sectionCount isEqualToString:@"0"]) {
            _percentlabel.text = @"0%";
        } else {
            _percentlabel.text = [NSString stringWithFormat:@"%.f%%",floor(100 * [finishCount integerValue] / ([sectionCount integerValue] * 1.0))];
        }
        _percentlabel.text = [NSString stringWithFormat:@"%@%%",finishRate];
        _dateTimeLabel.hidden = YES;
        _lineView1.frame = CGRectMake(0, _courseScore.bottom + 10, MainScreenWidth, 4);
        [self setHeight:_lineView1.bottom];
//        if ([[NSString stringWithFormat:@"%@",_courseInfo[@"course_type"]] isEqualToString:@"4"]) {
//            _sectionCountLabel.hidden = YES;
////            _courseTitleLabel.centerY = self.bounds.size.height / 2.0;
////            _detailButton.centerY = _courseTitleLabel.centerY;
////            _sectionCountLabel.text = [NSString stringWithFormat:@"共%@课时",_courseInfo[@"section_count"]];
//            _lineView1.frame = CGRectMake(0, _courseTitleLabel.bottom, MainScreenWidth, 4);
//            [self setHeight:_lineView1.bottom];
//        } else {
//            _sectionCountLabel.text = [NSString stringWithFormat:@"已完成：%@/%@",_courseInfo[@"finished_num"],_courseInfo[@"section_count"]];
//            NSString *sectionCount = [NSString stringWithFormat:@"%@",_courseInfo[@"section_count"]];
//            NSString *finishCount = [NSString stringWithFormat:@"%@",_courseInfo[@"finished_num"]];
//            _circleView.progress = 100 * [finishCount integerValue] / ([sectionCount integerValue] * 1.0);
//            _circleView.hidden = NO;
//            _percentlabel.hidden = NO;
//            if ([sectionCount isEqualToString:@"0"]) {
//                _percentlabel.text = @"0%";
//            } else {
//                _percentlabel.text = [NSString stringWithFormat:@"%.f%%",floor(100 * [finishCount integerValue] / ([sectionCount integerValue] * 1.0))];
//            }
//            _dateTimeLabel.hidden = YES;
//            _lineView1.frame = CGRectMake(0, _courseScore.bottom + 10, MainScreenWidth, 4);
//            [self setHeight:_lineView1.bottom];
//        }
    } else {
        
        _coursePrice.centerY = _sectionCountLabel.centerY;
        
        NSString *is_buy = [NSString stringWithFormat:@"%@",_courseInfo[@"is_buy"]];
        _sectionCountLabel.hidden = NO;
        if ([is_buy isEqualToString:@"1"]) {
            
            _coursePrice.hidden = YES;
            
            _sectionCountLabel.text = [NSString stringWithFormat:@"已完成：%@/%@",_courseInfo[@"finished_num"],_courseInfo[@"section_count"]];
            // 有效期处理
            NSString *term_time = [NSString stringWithFormat:@"%@",contentInfo[@"term_rest"]];
            if ([term_time isEqualToString:@"-1"]) {
                _dateTimeLabel.text = @"永久有效";
                _dateTimeLabel.textColor = EdlineV5_Color.textThirdColor;
            } else {
                _dateTimeLabel.text = [NSString stringWithFormat:@"距离课程到期还有%@天",[EdulineV5_Tool dateDuritionCurrentTime:term_time]];
                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_dateTimeLabel.text];
                [priceAtt addAttributes:@{NSForegroundColorAttributeName: EdlineV5_Color.faildColor} range:NSMakeRange(8, [EdulineV5_Tool dateDuritionCurrentTime:term_time].length)];
                _dateTimeLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
            }
        } else {
            
            NSString *price = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[contentInfo objectForKey:@"price"]]];
            _coursePrice.text = [NSString stringWithFormat:@"%@积分",price];
            if ([price isEqualToString:@"0.00"] || [price isEqualToString:@"0.0"] ||[price isEqualToString:@"0"]) {
                _coursePrice.hidden = YES;
            } else {
                _coursePrice.hidden = NO;
            }
            
            _sectionCountLabel.text = [NSString stringWithFormat:@"共%@课时",_courseInfo[@"section_count"]];
            
            // 有效期处理
            NSString *term_time = [NSString stringWithFormat:@"%@",contentInfo[@"term_time"]];
            if ([term_time isEqualToString:@"0"]) {
                _dateTimeLabel.text = @"永久有效";
                _dateTimeLabel.textColor = EdlineV5_Color.textThirdColor;
            } else if (term_time.length>4) {
                _dateTimeLabel.text = [NSString stringWithFormat:@"%@前有效",[EdulineV5_Tool timeForYYYYMMDDNianYueRI:term_time]];
                _dateTimeLabel.textColor = EdlineV5_Color.textThirdColor;
            } else {
                _dateTimeLabel.text = [NSString stringWithFormat:@"购买之日起%@天内有效",term_time];
                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_dateTimeLabel.text];
                [priceAtt addAttributes:@{NSForegroundColorAttributeName: EdlineV5_Color.faildColor} range:NSMakeRange(5, term_time.length)];
                _dateTimeLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
            }
        }
        
        CGFloat sectioncountWidth = [_sectionCountLabel.text sizeWithFont:_sectionCountLabel.font].width + 4;
        CGFloat couselearnWidth = [_courseLearn.text sizeWithFont:_courseLearn.font].width + 4;
        CGFloat dateLineWidth = [_dateTimeLabel.text sizeWithFont:_dateTimeLabel.font].width + 4;
        
        [_sectionCountLabel setWidth:sectioncountWidth];
        
        [_circle1 setLeft:_sectionCountLabel.right + 4];
        
        [_courseLearn setLeft:_circle1.right + 8];
        [_courseLearn setWidth:couselearnWidth];
        
        [_circle2 setLeft:_courseLearn.right + 4];
        
        [_dateTimeLabel setLeft:_circle2.right + 8];
        [_dateTimeLabel setWidth:dateLineWidth];
        
        [_lineView1 setTop:86 - 4];
        
        [self setHeight:_lineView1.bottom];
    }
}

- (void)detailButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popToCourseDetailVC)]) {
        [_delegate popToCourseDetailVC];
    }
}

@end
