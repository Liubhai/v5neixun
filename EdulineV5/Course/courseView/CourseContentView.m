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
    
    _coursePrice = [[UILabel alloc] initWithFrame:CGRectMake(_courseLearn.right, _courseScore.top, MainScreenWidth - 15 - _courseLearn.right, 34)];
    _coursePrice.textAlignment = NSTextAlignmentRight;
    _coursePrice.textColor = EdlineV5_Color.textThirdColor;
    _coursePrice.font = SYSTEMFONT(13);
    [self addSubview:_coursePrice];
    
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _courseScore.bottom + 10, MainScreenWidth, 4)];
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
    
    _sectionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 86 - 35, 150, 20)];
    _sectionCountLabel.font = SYSTEMFONT(14);
    _sectionCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _sectionCountLabel.hidden = YES;
    [self addSubview:_sectionCountLabel];
}

- (void)setCourseContentInfo:(NSDictionary *)contentInfo showTitleOnly:(BOOL)showTitleOnly {
    _courseInfo = [NSDictionary dictionaryWithDictionary:contentInfo];
    // 【0连载完成1连载中】
    if ([[contentInfo objectForKey:@"update_status"] integerValue]) {
        _lianzaiIcon.hidden = NO;
        [_lianzaiIcon setWidth:32];
        [_courseTitleLabel setLeft:_lianzaiIcon.right + 8];
        [_courseTitleLabel setWidth:MainScreenWidth - _courseTitleLabel.left - 15];
    } else {
        _lianzaiIcon.hidden = YES;
        [_lianzaiIcon setWidth:0];
        [_courseTitleLabel setLeft:_lianzaiIcon.left];
        [_courseTitleLabel setWidth:MainScreenWidth - _courseTitleLabel.left - 15];
    }
    _courseTitleLabel.text = [NSString stringWithFormat:@"%@",[contentInfo objectForKey:@"title"]];
    
    _courseScore.text = [NSString stringWithFormat:@"%@分",[contentInfo objectForKey:@"score_star"]];
    
    CGFloat courseScoreWidth = [_courseScore.text sizeWithFont:_courseScore.font].width + 4;
    [_courseScore setWidth:courseScoreWidth];
    [_courseStar setLeft:_courseScore.right + 3];
    [_courseLearn setLeft:_courseStar.right + 8];
    [_coursePrice setLeft:_courseLearn.right];
    
    [_courseStar setStarValue:[[NSString stringWithFormat:@"%@",[contentInfo objectForKey:@"score_star"]] floatValue]];
    _courseLearn.text = [NSString stringWithFormat:@"%@人在学",[contentInfo objectForKey:@"sale_count"]];
    
    NSString *price = [NSString stringWithFormat:@"育币%@",[contentInfo objectForKey:@"price"]];
    NSString *scribing_price = [NSString stringWithFormat:@"育币%@",[contentInfo objectForKey:@"scribing_price"]];
    if ([scribing_price isEqualToString:@"育币0.00"] || [scribing_price isEqualToString:@"育币0.0"] || [scribing_price isEqualToString:@"育币0"]) {
        if ([price isEqualToString:@"育币0.00"] || [price isEqualToString:@"育币0.0"] ||[price isEqualToString:@"育币0"]) {
            _coursePrice.text = @"免费";
            _coursePrice.textColor = EdlineV5_Color.priceFreeColor;
            _coursePrice.font = SYSTEMFONT(18);
        } else {
            _coursePrice.text = price;
            _coursePrice.textColor = EdlineV5_Color.textPriceColor;
            _coursePrice.font = SYSTEMFONT(18);
        }
    } else {
        NSString *user_price = [NSString stringWithFormat:@"%@",[contentInfo objectForKey:@"user_price"]];
        if ([price isEqualToString:@"育币0.00"] || [price isEqualToString:@"育币0.0"] || [price isEqualToString:@"育币0"] || ([[V5_UserModel vipStatus] isEqualToString:@"1"] && ([user_price isEqualToString:@"0.00"] || [user_price isEqualToString:@"0.0"] || [user_price isEqualToString:@"0"]))) {
            price = @"免费";
            NSString *finalPrice = [NSString stringWithFormat:@"%@%@",scribing_price,price];
            NSRange rangNow = NSMakeRange(scribing_price.length, price.length);
            NSRange rangOld = NSMakeRange(0, scribing_price.length);
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangOld];
            [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(18),NSForegroundColorAttributeName: EdlineV5_Color.priceFreeColor} range:rangNow];
            _coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
        } else {
            NSString *finalPrice = [NSString stringWithFormat:@"%@%@",scribing_price,price];
            NSRange rangNow = NSMakeRange(scribing_price.length, price.length);
            NSRange rangOld = NSMakeRange(0, scribing_price.length);
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangOld];
            [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(18),NSForegroundColorAttributeName: EdlineV5_Color.textPriceColor} range:rangNow];
            _coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
        }
    }
    if (showTitleOnly) {
        _courseTitleLabel.frame = CGRectMake(15, 0, MainScreenWidth - 15 - (_detailButton.width + 15), 86 - 35);
        _lianzaiIcon.hidden = YES;
        _courseStar.hidden = YES;
        _coursePrice.hidden = YES;
        _courseScore.hidden = YES;
        _courseLearn.hidden = YES;
        _sectionCountLabel.hidden = NO;
        _detailButton.hidden = NO;
        _detailButton.centerY = _courseTitleLabel.centerY;
        _sectionCountLabel.text = [NSString stringWithFormat:@"共%@课时",_courseInfo[@"section_count"]];
    }
}

- (void)detailButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popToCourseDetailVC)]) {
        [_delegate popToCourseDetailVC];
    }
}

@end
