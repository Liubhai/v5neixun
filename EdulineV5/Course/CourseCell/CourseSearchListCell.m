//
//  CourseSearchListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseSearchListCell.h"
#import "V5_Constant.h"

@implementation CourseSearchListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.text = @"你是个傻屌";
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self.contentView addSubview:_titleL];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 18, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.text = @"1214人在学";
    _learnCountLabel.font = SYSTEMFONT(12);
    [self.contentView addSubview:_learnCountLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 21)];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.centerY = _learnCountLabel.centerY;
    [self.contentView addSubview:_priceLabel];
    
    _courseActivityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.bottom - 17, 32, 17)];
    _courseActivityIcon.hidden = YES;
    [self.contentView addSubview:_courseActivityIcon];
}

- (void)setCourseListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex cellType:(BOOL)cellType isHomePageList:(BOOL)isHomePageList {
    _cellType = cellType;
    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    // 1 点播 2 直播 3 面授 4 专辑
    _courseTypeImage.hidden = NO;
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
    if (_cellType) {
        if (_cellType) {
            _courseFace.frame = CGRectMake(singleLeftSpace, topSpace, MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace, faceImageHeight);
            _titleL.frame = CGRectMake(_courseFace.left, _courseFace.bottom + 6, _courseFace.width, 20);
            _learnCountLabel.frame = CGRectMake(_courseFace.left, _titleL.bottom + 13, _courseFace.width, 16);
            _priceLabel.centerY = _learnCountLabel.centerY;
            [_priceLabel setRight:_courseFace.right];
        }
        CGFloat priceWidth = 150;
        if (cellIndex.row % 2 == 0) {
            _courseFace.frame = CGRectMake(singleLeftSpace, topSpace, MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace, faceImageHeight);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            
            _titleL.frame = CGRectMake(_courseFace.left, _courseFace.bottom + 6, _courseFace.width, 20);
            _learnCountLabel.frame = CGRectMake(_courseFace.left, _titleL.bottom + 13, _courseFace.width, 16);
            _priceLabel.frame = CGRectMake(_courseFace.right - priceWidth, 0, priceWidth, 21);
            _priceLabel.centerY = _learnCountLabel.centerY;
        } else {
            _courseFace.frame = CGRectMake(0, topSpace, MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace, faceImageHeight);
            _courseTypeImage.frame = CGRectMake(_courseFace.left, _courseFace.top, 33, 20);
            
            _titleL.frame = CGRectMake(_courseFace.left, _courseFace.bottom + 6, _courseFace.width, 20);
            _learnCountLabel.frame = CGRectMake(_courseFace.left, _titleL.bottom + 13, _courseFace.width, 16);
            _priceLabel.frame = CGRectMake(_courseFace.right - priceWidth, 0, priceWidth, 21);
            _priceLabel.centerY = _learnCountLabel.centerY;
        }
    }
    _titleL.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人在学",[info objectForKey:@"sale_count"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[info objectForKey:@"price"]];
    NSString *priceValue = [NSString stringWithFormat:@"%@",[info objectForKey:@"price"]];
    
    if (!_cellType) {
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
    // 1 限时折扣 2 限时秒杀 3 砍价 4 拼团 0 没有活动
    _courseActivityIcon.frame = CGRectMake(_courseFace.right - 32, _courseFace.bottom - 17, 32, 17);
    NSString *activityType = [NSString stringWithFormat:@"%@",[info objectForKey:@"promotion_type"]];
    if ([activityType isEqualToString:@"0"]) {
        _courseActivityIcon.hidden = YES;
    } else if ([activityType isEqualToString:@"2"]) {
        _courseActivityIcon.hidden = NO;
        _courseActivityIcon.image = Image(@"seckill_icon");
    } else if ([activityType isEqualToString:@"3"]) {
        _courseActivityIcon.hidden = NO;
        _courseActivityIcon.image = Image(@"kanjia_icon");
    } else if ([activityType isEqualToString:@"4"]) {
        _courseActivityIcon.hidden = NO;
        _courseActivityIcon.image = Image(@"pintuan_icon");
    } else if ([activityType isEqualToString:@"1"]) {
        _courseActivityIcon.hidden = NO;
        _courseActivityIcon.image = Image(@"discount_icon");
        _courseActivityIcon.frame = CGRectMake(_courseFace.right - 52, _courseFace.bottom - 17, 52, 17);
    }
    if (isHomePageList) {
        _courseTypeImage.hidden = YES;
        _learnCountLabel.text = [NSString stringWithFormat:@"%@人在学",[info objectForKey:@"student_count"]];
    }
}

@end
