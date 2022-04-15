//
//  StudyCourseCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyCourseCell.h"
#import "V5_Constant.h"

@implementation StudyCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _outDateL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 48 + 28, 16)];
    _outDateL.text = @"过期课程";
    _outDateL.textColor = EdlineV5_Color.textThirdColor;
    _outDateL.font = SYSTEMFONT(12);
    _outDateL.centerX = MainScreenWidth / 2.0;
    _outDateL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_outDateL];
    
    _outDateLineLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, 1)];
    _outDateLineLeft.backgroundColor = HEXCOLOR(0xF1F1F1);
    _outDateLineLeft.centerY = _outDateL.centerY;
    [_outDateLineLeft setRight:_outDateL.left];
    [self.contentView addSubview:_outDateLineLeft];
    
    _outDateLineRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, 1)];
    _outDateLineRight.backgroundColor = HEXCOLOR(0xF1F1F1);
    _outDateLineRight.centerY = _outDateL.centerY;
    [_outDateLineRight setLeft:_outDateL.right];
    [self.contentView addSubview:_outDateLineRight];
    
    _outDateL.hidden = YES;
    _outDateLineLeft.hidden = YES;
    _outDateLineRight.hidden = YES;
    
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
    
    _courseFace.image = DefaultImage;
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 2;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.left, _courseFace.top, 33, 20)];
    _courseTypeImage.image = Image(@"class_icon");
    _courseTypeImage.layer.masksToBounds = YES;
    _courseTypeImage.layer.cornerRadius = 2;
    [self.contentView addSubview:_courseTypeImage];
    _courseTypeImage.hidden = YES;
    
    _learnStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right - 44, _courseFace.bottom - 20, 44, 20)];
    _learnStatusLabel.font = SYSTEMFONT(10);
    _learnStatusLabel.textColor = [UIColor whiteColor];
    _learnStatusLabel.textAlignment = NSTextAlignmentCenter;
    _learnStatusLabel.text = @"未开始";
    _learnStatusLabel.layer.backgroundColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:0.2].CGColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_learnStatusLabel.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _learnStatusLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _learnStatusLabel.layer.mask = maskLayer;
    [self.contentView addSubview:_learnStatusLabel];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20)];
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self.contentView addSubview:_titleL];
    
    _timedate = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16)];
    _timedate.textColor = EdlineV5_Color.textThirdColor;
    _timedate.font = SYSTEMFONT(11);
    [self.contentView addSubview:_timedate];
    
    _learnProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4)];
    _learnProgress.layer.masksToBounds = YES;
    _learnProgress.layer.cornerRadius = 2;
    _learnProgress.progress = 0.5;
    //设置它的风格，为默认的
    _learnProgress.trackTintColor= HEXCOLOR(0xF1F1F1);
    //设置轨道的颜色
    _learnProgress.progressTintColor= EdlineV5_Color.themeColor;
    [self.contentView addSubview:_learnProgress];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.text = @"50%";
    _learnCountLabel.font = SYSTEMFONT(12);
    _learnCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_learnCountLabel];
    
}

- (void)setStudyCourseInfo:(NSDictionary *)courseInfo showOutDate:(BOOL)showOutDate isOutDate:(BOOL)isOutDate {
    [_courseFace sd_setImageWithURL:EdulineUrlString([courseInfo objectForKey:@"course_cover"]) placeholderImage:DefaultImage];
    NSString *courseType = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    
    _titleL.text = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_title"]];
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    
    NSString *expire_rest = [NSString stringWithFormat:@"%@",courseInfo[@"expire_rest"]];
    if ([expire_rest isEqualToString:@"-1"]) {
        _timedate.text = @"永久有效";
        _timedate.textColor = EdlineV5_Color.textThirdColor;
        isOutDate = NO;
    } else if ([expire_rest isEqualToString:@"0"]) {
        _timedate.text = @"课程已过期";
        _timedate.textColor = EdlineV5_Color.textThirdColor;
        isOutDate = YES;
    } else {
        isOutDate = NO;
        _timedate.text = [NSString stringWithFormat:@"距离课程到期还有%@天",expire_rest];
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_timedate.text];
        [priceAtt addAttributes:@{NSForegroundColorAttributeName: EdlineV5_Color.faildColor} range:NSMakeRange(8, expire_rest.length)];
        _timedate.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    }
//    _titleL.numberOfLines = 0;
//    [_titleL sizeToFit];
//    if (_titleL.height > 50) {
//        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
//    } else {
//        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, _titleL.height);
//    }
    
    NSString *progressString = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"finished_rate"]];
    _learnProgress.progress = [progressString integerValue] * 0.01;
    if ([[courseInfo objectForKey:@"finished_rate"] integerValue] == 0) {
        _learnCountLabel.text = @"开始学习";
        _learnCountLabel.textColor = EdlineV5_Color.themeColor;
    } else if ([[courseInfo objectForKey:@"finished_rate"] integerValue] == 100) {
        _learnCountLabel.text = @"已完成";
        _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    } else {
        _learnCountLabel.text = [NSString stringWithFormat:@"%@%%",@([[courseInfo objectForKey:@"finished_rate"] integerValue])];
        _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    }
    
    if (showOutDate) {
        if (isOutDate) {
            _learnProgress.hidden = YES;
            _learnCountLabel.hidden = YES;
            _outDateL.hidden = NO;
            _outDateLineLeft.hidden = NO;
            _outDateLineRight.hidden = NO;
            _courseFace.frame = CGRectMake(15, _outDateL.bottom + 15, 153, 86);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20);
            _titleL.textColor = EdlineV5_Color.textThirdColor;
            _timedate.frame = CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16);
            _timedate.text = @"课程已过期";
            _learnProgress.frame = CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4);
            _learnCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16);
        }
    } else {
        if (isOutDate) {
            _learnProgress.hidden = YES;
            _learnCountLabel.hidden = YES;
            _outDateL.hidden = YES;
            _outDateLineLeft.hidden = YES;
            _outDateLineRight.hidden = YES;
            _courseFace.frame = CGRectMake(15, 10, 153, 86);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20);
            _titleL.textColor = EdlineV5_Color.textThirdColor;
            _timedate.frame = CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16);
            _timedate.text = @"课程已过期";
            _learnProgress.frame = CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4);
            _learnCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16);
        } else {
            _learnProgress.hidden = NO;
            _learnCountLabel.hidden = NO;
            _outDateL.hidden = YES;
            _outDateLineLeft.hidden = YES;
            _outDateLineRight.hidden = YES;
            _courseFace.frame = CGRectMake(15, 10, 153, 86);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20);
            _titleL.textColor = EdlineV5_Color.textFirstColor;
            _timedate.frame = CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16);
            _learnProgress.frame = CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4);
            _learnCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16);
        }
    }
}

- (void)setJoinStudyCourseInfo:(NSDictionary *)courseInfo {
    [_courseFace sd_setImageWithURL:EdulineUrlString([courseInfo objectForKey:@"course_cover"]) placeholderImage:DefaultImage];
    NSString *courseType = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"product_type_id"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    _titleL.text = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"product_title"]];
    
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    _titleL.text = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"course_title"]];
    _titleL.numberOfLines = 0;
    [_titleL sizeToFit];
    if (_titleL.height > 50) {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    } else {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, _titleL.height);
    }
    
    _learnProgress.progress = [[courseInfo objectForKey:@"finished_rate"] integerValue] / 100;
    if ([[courseInfo objectForKey:@"finished_rate"] integerValue] == 0) {
        _learnCountLabel.text = @"开始学习";
    } else if ([[courseInfo objectForKey:@"finished_rate"] integerValue] == 100) {
        _learnCountLabel.text = @"已完成";
    } else {
        _learnCountLabel.text = [NSString stringWithFormat:@"%@%%",@([[courseInfo objectForKey:@"finished_rate"] integerValue])];
    }
}

- (void)setJoinStudyCourseListInfo:(NSDictionary *)courseInfo showOutDate:(BOOL)showOutDate isOutDate:(BOOL)isOutDate {
    [_courseFace sd_setImageWithURL:EdulineUrlString([courseInfo objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    
    _titleL.text = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"title"]];
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    
    NSString *expire_rest = [NSString stringWithFormat:@"%@",courseInfo[@"expire_rest"]];
    if ([expire_rest isEqualToString:@"-1"]) {
        _timedate.text = @"永久有效";
        _timedate.textColor = EdlineV5_Color.textThirdColor;
        isOutDate = NO;
    } else if ([expire_rest isEqualToString:@"0"]) {
        _timedate.text = @"课程已过期";
        _timedate.textColor = EdlineV5_Color.textThirdColor;
        isOutDate = YES;
    } else {
        isOutDate = NO;
        _timedate.text = [NSString stringWithFormat:@"距离课程到期还有%@天",expire_rest];
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_timedate.text];
        [priceAtt addAttributes:@{NSForegroundColorAttributeName: EdlineV5_Color.faildColor} range:NSMakeRange(8, expire_rest.length)];
        _timedate.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    }
    
    NSString *progressString = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"rate"]];
    _learnProgress.progress = [progressString integerValue] * 0.01;
    if ([[courseInfo objectForKey:@"rate"] integerValue] == 0) {
        _learnCountLabel.text = @"开始学习";
        _learnCountLabel.textColor = EdlineV5_Color.themeColor;
    } else if ([[courseInfo objectForKey:@"rate"] integerValue] == 100) {
        _learnCountLabel.text = @"已完成";
        _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    } else {
        _learnCountLabel.text = [NSString stringWithFormat:@"%@%%",@([[courseInfo objectForKey:@"rate"] integerValue])];
        _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    }
    
    if (showOutDate) {
        if (isOutDate) {
            _learnProgress.hidden = YES;
            _learnCountLabel.hidden = YES;
            _outDateL.hidden = NO;
            _outDateLineLeft.hidden = NO;
            _outDateLineRight.hidden = NO;
            _courseFace.frame = CGRectMake(15, _outDateL.bottom + 15, 153, 86);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20);
            _titleL.textColor = EdlineV5_Color.textThirdColor;
            _timedate.frame = CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16);
            _timedate.text = @"课程已过期";
            _learnProgress.frame = CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4);
            _learnCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16);
        }
    } else {
        if (isOutDate) {
            _learnProgress.hidden = YES;
            _learnCountLabel.hidden = YES;
            _outDateL.hidden = YES;
            _outDateLineLeft.hidden = YES;
            _outDateLineRight.hidden = YES;
            _courseFace.frame = CGRectMake(15, 10, 153, 86);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20);
            _titleL.textColor = EdlineV5_Color.textThirdColor;
            _timedate.frame = CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16);
            _timedate.text = @"课程已过期";
            _learnProgress.frame = CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4);
            _learnCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16);
        } else {
            _learnProgress.hidden = NO;
            _learnCountLabel.hidden = NO;
            _outDateL.hidden = YES;
            _outDateLineLeft.hidden = YES;
            _outDateLineRight.hidden = YES;
            _courseFace.frame = CGRectMake(15, 10, 153, 86);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 20);
            _titleL.textColor = EdlineV5_Color.textFirstColor;
            _timedate.frame = CGRectMake(_titleL.left, _titleL.bottom + 7, _titleL.width, 16);
            _learnProgress.frame = CGRectMake(_titleL.left, _courseFace.bottom - 4, MainScreenWidth - _titleL.left - 15, 4);
            _learnCountLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
