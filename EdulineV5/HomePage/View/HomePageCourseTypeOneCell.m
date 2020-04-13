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
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
    
    _courseFace.image = DefaultImage;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"album_icon");
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
//    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover"]) placeholderImage:DefaultImage];
//    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
//    // 1 点播 2 直播 3 面授 4 专辑
//    NSString *courseType = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]];
//    if ([courseType isEqualToString:@"1"]) {
//        _courseTypeImage.image = Image(@"dianbo");
//    } else if ([courseType isEqualToString:@"2"]) {
//        _courseTypeImage.image = Image(@"live");
//    } else if ([courseType isEqualToString:@"3"]) {
//        _courseTypeImage.image = Image(@"mianshou");
//    } else if ([courseType isEqualToString:@"4"]) {
//        _courseTypeImage.image = Image(@"album_icon");
//    }
//    _titleL.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
//    _learnCountLabel.text = [NSString stringWithFormat:@"%@人报名",[info objectForKey:@"sale_count"]];
//    _priceLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"price"]];
    
    _titleL.frame = CGRectMake(0, 0, _titleL.width, 100);
    [_titleL sizeToFit];
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, _titleL.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
