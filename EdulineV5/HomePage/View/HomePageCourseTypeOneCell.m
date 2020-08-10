//
//  HomePageCourseTypeOneCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomePageCourseTypeOneCell.h"
#import "V5_Constant.h"

@implementation HomePageCourseTypeOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
    
    _courseFace.image = DefaultImage;
    _courseFace.clipsToBounds = YES;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_courseFace];
    
    _weekSortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 33)];
    _weekSortIcon.center = CGPointMake(_courseFace.origin.x, _courseFace.origin.y + 5);
    _weekSortIcon.clipsToBounds = YES;
    _weekSortIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_weekSortIcon];
    
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"class_icon");
    [self addSubview:_courseTypeImage];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.text = @"你是个傻屌";
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self addSubview:_titleL];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 18, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.text = @"1214人报名";
    _learnCountLabel.font = SYSTEMFONT(12);
    [self addSubview:_learnCountLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 21)];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.text = @"¥1099.00";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.centerY = _learnCountLabel.centerY;
    [self addSubview:_priceLabel];
}

- (void)setHomePageCourseTypeOneCellInfo:(NSDictionary *)info {
    _courseInfoDict = info;
    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    // 1 点播 2 直播 3 面授 4 专辑
    NSString *courseType = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    _titleL.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人报名",[info objectForKey:@"sale_count"]];

    NSString *priceValue = [NSString stringWithFormat:@"%@",[info objectForKey:@"price"]];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    if ([[info objectForKey:@"is_buy"] integerValue]) {
        _priceLabel.text = @"已购买";
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else {
        if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"]) {
            _priceLabel.text = @"免费";
            _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"price"]];
            _priceLabel.textColor = EdlineV5_Color.faildColor;
        }
    }
    
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    _titleL.numberOfLines = 0;
    _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleL sizeToFit];
    if (_titleL.height > 40) {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, 40);
    } else {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, _titleL.height);
    }
}

// MARK: - 周榜月榜
- (void)setHomePageCourseTypeOneWeekCellInfo:(NSDictionary *)info indexparh:(NSIndexPath *)indexpath {
    _courseInfoDict = info;
    _weekSortIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_top%@_icon",@(indexpath.row + 1)]];
    if (indexpath.row>2) {
        _weekSortIcon.frame = CGRectMake(0, 0, 26, 26);
    } else {
        _weekSortIcon.frame = CGRectMake(0, 0, 37, 33);
    }
    _weekSortIcon.center = CGPointMake(_courseFace.origin.x, _courseFace.origin.y + 5);;
    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 8;
    // 1 点播 2 直播 3 面授 4 专辑
    NSString *courseType = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    _titleL.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人报名",[info objectForKey:@"sale_count"]];

    NSString *priceValue = [NSString stringWithFormat:@"%@",[info objectForKey:@"price"]];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    if ([[info objectForKey:@"is_buy"] integerValue]) {
        _priceLabel.text = @"已购买";
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else {
        if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"]) {
            _priceLabel.text = @"免费";
            _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"price"]];
            _priceLabel.textColor = EdlineV5_Color.faildColor;
        }
    }
    
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    _titleL.numberOfLines = 0;
    _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleL sizeToFit];
    if (_titleL.height > 40) {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, 40);
    } else {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, _titleL.height);
    }
}

- (void)setMyTeachingInfo:(NSDictionary *)info {
    _learnCountLabel.hidden = YES;
    _priceLabel.hidden = YES;
    _courseInfoDict = info;
    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    // 1 点播 2 直播 3 面授 4 专辑
    NSString *courseType = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    _titleL.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    _titleL.numberOfLines = 0;
    _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleL sizeToFit];
    if (_titleL.height > 40) {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, 40);
    } else {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, _titleL.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
