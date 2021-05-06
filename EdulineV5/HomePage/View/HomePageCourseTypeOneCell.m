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
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 2;
    _courseFace.clipsToBounds = YES;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.left, _courseFace.top, 33, 20)];
    _courseTypeImage.image = Image(@"class_icon");
    _courseTypeImage.layer.masksToBounds = YES;
    _courseTypeImage.layer.cornerRadius = 2;
    [self.contentView addSubview:_courseTypeImage];
    
    _weekSortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 33)];
    _weekSortIcon.center = CGPointMake(_courseFace.origin.x, _courseFace.origin.y + 5);
    _weekSortIcon.clipsToBounds = YES;
    _weekSortIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_weekSortIcon];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self.contentView addSubview:_titleL];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 18, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.font = SYSTEMFONT(12);
    [self.contentView addSubview:_learnCountLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 21)];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.centerY = _learnCountLabel.centerY;
    [self.contentView addSubview:_priceLabel];
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
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人在学",[info objectForKey:@"sale_count"]];

    NSString *priceValue = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[info objectForKey:@"price"]]];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    if ([[info objectForKey:@"is_buy"] integerValue]) {
        _priceLabel.text = @"已购买";
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else {
        if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"]) {
            _priceLabel.text = @"免费";
            _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[info objectForKey:@"price"]]];
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
    
    _courseFace.frame = CGRectMake(23, 20, 153, 86);
    _courseFace.layer.cornerRadius = 5;
    
    _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
    
    _courseInfoDict = info;
    _weekSortIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_top%@_icon",@(indexpath.row + 1)]];
    if (indexpath.row>2) {
        _weekSortIcon.frame = CGRectMake(0, 0, 26, 26);
        [_weekSortIcon setOrigin:CGPointMake(_courseFace.left - 11, _courseFace.top - 13)];
    } else {
        _weekSortIcon.frame = CGRectMake(0, 0, 37, 33);
        [_weekSortIcon setOrigin:CGPointMake(_courseFace.left - 15.5, _courseFace.top - 20)];
    }
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
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人在学",[info objectForKey:@"sale_count"]];

    NSString *priceValue = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[info objectForKey:@"price"]]];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    if ([[info objectForKey:@"is_buy"] integerValue]) {
        _priceLabel.text = @"已购买";
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else {
        if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"]) {
            _priceLabel.text = @"免费";
            _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[info objectForKey:@"price"]]];
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
    
    _learnCountLabel.frame = CGRectMake(_titleL.left, _courseFace.bottom - 18, 100, 16);
    
    _priceLabel.centerY = _learnCountLabel.centerY;
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
