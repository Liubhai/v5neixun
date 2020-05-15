//
//  HomePageCourseTypeTwoCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomePageCourseTypeTwoCell.h"
#import "V5_Constant.h"

#define TwoCellHeight ((MainScreenWidth/2 - singleRightSpace * 2 - singleLeftSpace) * 90 / 165 + 6 + 20 + 13 + 16 + 10)

@implementation HomePageCourseTypeTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    self.backgroundColor = [UIColor whiteColor];
//    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
//
//    _courseFace.image = DefaultImage;
//    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:_courseFace];
//
//    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
//    _courseTypeImage.image = Image(@"album_icon");
//    [self addSubview:_courseTypeImage];
//
//    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
//    _titleL.text = @"你是个傻屌";
//    _titleL.textColor = EdlineV5_Color.textFirstColor;
//    _titleL.font = SYSTEMFONT(15);
//    [self addSubview:_titleL];
//
//    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 18, 100, 16)];
//    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
//    _learnCountLabel.text = @"1214人报名";
//    _learnCountLabel.font = SYSTEMFONT(12);
//    [self addSubview:_learnCountLabel];
//
//    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 21)];
//    _priceLabel.textColor = EdlineV5_Color.faildColor;
//    _priceLabel.font = SYSTEMFONT(15);
//    _priceLabel.text = @"¥1099.00";
//    _priceLabel.textAlignment = NSTextAlignmentRight;
//    _priceLabel.centerY = _learnCountLabel.centerY;
//    [self addSubview:_priceLabel];
}

- (void)setHomePageCourseTypeTwoCellInfo:(NSMutableArray *)infoArray {
    [self removeAllSubviews];
    for (int i = 0; i<infoArray.count; i++) {
        
//        NSDictionary *info = [NSDictionary dictionaryWithDictionary:infoArray[i]];
        
        UIImageView *courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
        
        courseFace.image = DefaultImage;
        courseFace.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:courseFace];
        
        UIImageView *courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(courseFace.right - 32, courseFace.top + 8, 32, 18)];
        courseTypeImage.image = Image(@"album_icon");
        [self addSubview:courseTypeImage];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(courseFace.right + 12, courseFace.top, MainScreenWidth - (courseFace.right + 12) - 15, 50)];
        titleL.text = @"你是个傻屌";
        titleL.textColor = EdlineV5_Color.textFirstColor;
        titleL.font = SYSTEMFONT(15);
        [self addSubview:titleL];
        
        UILabel *learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleL.left, courseFace.bottom - 18, 100, 16)];
        learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
        learnCountLabel.text = @"1214人报名";
        learnCountLabel.font = SYSTEMFONT(12);
        [self addSubview:learnCountLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 21)];
        priceLabel.textColor = EdlineV5_Color.faildColor;
        priceLabel.font = SYSTEMFONT(15);
        priceLabel.text = @"¥1099.00";
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.centerY = learnCountLabel.centerY;
        [self addSubview:priceLabel];
        
//        [courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover"]) placeholderImage:DefaultImage];
//        courseFace.contentMode = UIViewContentModeScaleAspectFill;
//        // 1 点播 2 直播 3 面授 4 专辑
//        NSString *courseType = [NSString stringWithFormat:@"%@",[info objectForKey:@"course_type"]];
//        if ([courseType isEqualToString:@"1"]) {
//            courseTypeImage.image = Image(@"dianbo");
//        } else if ([courseType isEqualToString:@"2"]) {
//            courseTypeImage.image = Image(@"live");
//        } else if ([courseType isEqualToString:@"3"]) {
//            courseTypeImage.image = Image(@"mianshou");
//        } else if ([courseType isEqualToString:@"4"]) {
//            courseTypeImage.image = Image(@"album_icon");
//        }
        
        courseFace.frame = CGRectMake(singleLeftSpace, topSpace, MainScreenWidth/2.0 - singleRightSpace * 2 - singleLeftSpace, faceImageHeight);
        titleL.frame = CGRectMake(courseFace.left, courseFace.bottom + 6, courseFace.width, 20);
        learnCountLabel.frame = CGRectMake(courseFace.left, titleL.bottom + 13, courseFace.width, 16);
        priceLabel.centerY = learnCountLabel.centerY;
        [priceLabel setRight:courseFace.right];
        
        CGFloat priceWidth = 150;
        if (i % 2 == 0) {
            courseFace.frame = CGRectMake(singleLeftSpace, topSpace + (i * TwoCellHeight)/2.0 , MainScreenWidth/2.0 - singleRightSpace * 2 - singleLeftSpace, faceImageHeight);
            courseTypeImage.frame = CGRectMake(courseFace.right - 32, courseFace.top + 8, 32, 18);

            titleL.frame = CGRectMake(courseFace.left, courseFace.bottom + 6, courseFace.width, 20);
            learnCountLabel.frame = CGRectMake(courseFace.left, titleL.bottom + 13, courseFace.width, 16);
            priceLabel.frame = CGRectMake(courseFace.right - priceWidth, 0, priceWidth, 21);
            priceLabel.centerY = learnCountLabel.centerY;
        } else {
            courseFace.frame = CGRectMake(MainScreenWidth / 2.0 + singleRightSpace * 2, topSpace + (((i+1) * TwoCellHeight)/2.0) - TwoCellHeight, MainScreenWidth/2.0 - singleRightSpace * 2 - singleLeftSpace, faceImageHeight);
            courseTypeImage.frame = CGRectMake(courseFace.right - 32, courseFace.top + 8, 32, 18);

            titleL.frame = CGRectMake(courseFace.left, courseFace.bottom + 6, courseFace.width, 20);
            learnCountLabel.frame = CGRectMake(courseFace.left, titleL.bottom + 13, courseFace.width, 16);
            priceLabel.frame = CGRectMake(courseFace.right - priceWidth, 0, priceWidth, 21);
            priceLabel.centerY = learnCountLabel.centerY;
        }
        
//        titleL.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
//        learnCountLabel.text = [NSString stringWithFormat:@"%@人报名",[info objectForKey:@"sale_count"]];
//        priceLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"price"]];
    }
    [self setHeight:(infoArray.count%2 == 0) ? (infoArray.count/2.0) * TwoCellHeight + 10 : ((infoArray.count + 1)/2.0) * TwoCellHeight + 10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
