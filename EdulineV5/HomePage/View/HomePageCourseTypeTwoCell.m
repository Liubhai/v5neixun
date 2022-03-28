//
//  HomePageCourseTypeTwoCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomePageCourseTypeTwoCell.h"
#import "V5_Constant.h"

#define TwoCellHeight ((MainScreenWidth/2 - singleRightSpace * 2 - singleLeftSpace) * 90 / 165 + 6 + 20 + 13 + 16 + 10 + 15)

@implementation HomePageCourseTypeTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _categoryCourseArray = [NSMutableArray new];
        [_categoryCourseArray removeAllObjects];
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setHomePageCourseTypeTwoCellInfo:(NSMutableArray *)infoArray {
    [_categoryCourseArray removeAllObjects];
    [_categoryCourseArray addObjectsFromArray:infoArray];
    [self.contentView removeAllSubviews];
    for (int i = 0; i<infoArray.count; i++) {
        UIImageView *courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
        
        [courseFace sd_setImageWithURL:EdulineUrlString(infoArray[i][@"cover_url"]) placeholderImage:DefaultImage];
        courseFace.layer.masksToBounds = YES;
        courseFace.layer.cornerRadius = 2;
        courseFace.clipsToBounds = YES;
        courseFace.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:courseFace];
        
        UIImageView *courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(courseFace.left, courseFace.top, 33, 20)];
        courseTypeImage.layer.masksToBounds = YES;
        courseTypeImage.layer.cornerRadius = 2;
        [self.contentView addSubview:courseTypeImage];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(courseFace.right + 12, courseFace.top, MainScreenWidth - (courseFace.right + 12) - 15, 50)];
        titleL.textColor = EdlineV5_Color.textFirstColor;
        titleL.font = SYSTEMFONT(15);
        [self.contentView addSubview:titleL];
        
        UILabel *learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleL.left, courseFace.bottom - 18, 100, 16)];
        learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
        learnCountLabel.font = SYSTEMFONT(12);
        [self.contentView addSubview:learnCountLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 150, 0, 150, 21)];
        priceLabel.textColor = EdlineV5_Color.faildColor;
        priceLabel.font = SYSTEMFONT(15);
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.centerY = learnCountLabel.centerY;
        [self.contentView addSubview:priceLabel];
        
        UIButton *tapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        tapButton.backgroundColor = [UIColor clearColor];
        tapButton.tag = 666 + i;
        [tapButton addTarget:self action:@selector(tapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tapButton];
        
        // 1 点播 2 直播 3 面授 4 专辑
        NSString *courseType = [NSString stringWithFormat:@"%@",infoArray[i][@"course_type"]];
        if ([courseType isEqualToString:@"1"]) {
            courseTypeImage.image = Image(@"dianbo");
        } else if ([courseType isEqualToString:@"2"]) {
            courseTypeImage.image = Image(@"live");
        } else if ([courseType isEqualToString:@"3"]) {
            courseTypeImage.image = Image(@"mianshou");
        } else if ([courseType isEqualToString:@"4"]) {
            courseTypeImage.image = Image(@"class_icon");
        }
        courseTypeImage.hidden = YES;
        courseFace.frame = CGRectMake(singleLeftSpace, topSpace, MainScreenWidth/2.0 - singleRightSpace * 2 - singleLeftSpace, faceImageHeight);
        titleL.frame = CGRectMake(courseFace.left, courseFace.bottom + 6, courseFace.width, 20);
        learnCountLabel.frame = CGRectMake(courseFace.left, titleL.bottom + 13, courseFace.width, 16);
        priceLabel.centerY = learnCountLabel.centerY;
        [priceLabel setRight:courseFace.right];
        
        CGFloat priceWidth = 150;
        if (i % 2 == 0) {
            courseFace.frame = CGRectMake(singleLeftSpace, topSpace + (i * TwoCellHeight)/2.0 , MainScreenWidth/2.0 - singleRightSpace * 2 - singleLeftSpace, faceImageHeight);
            courseTypeImage.frame = CGRectMake(courseFace.left, courseFace.top, 33, 20);

            titleL.frame = CGRectMake(courseFace.left, courseFace.bottom + 6, courseFace.width, 20);
            learnCountLabel.frame = CGRectMake(courseFace.left, titleL.bottom + 13, courseFace.width, 16);
            priceLabel.frame = CGRectMake(courseFace.right - priceWidth, 0, priceWidth, 21);
            priceLabel.centerY = learnCountLabel.centerY;
        } else {
            courseFace.frame = CGRectMake(MainScreenWidth / 2.0 + singleRightSpace * 2, topSpace + (((i+1) * TwoCellHeight)/2.0) - TwoCellHeight, MainScreenWidth/2.0 - singleRightSpace * 2 - singleLeftSpace, faceImageHeight);
            courseTypeImage.frame = CGRectMake(courseFace.left, courseFace.top, 33, 20);

            titleL.frame = CGRectMake(courseFace.left, courseFace.bottom + 6, courseFace.width, 20);
            learnCountLabel.frame = CGRectMake(courseFace.left, titleL.bottom + 13, courseFace.width, 16);
            priceLabel.frame = CGRectMake(courseFace.right - priceWidth, 0, priceWidth, 21);
            priceLabel.centerY = learnCountLabel.centerY;
        }
        
        tapButton.frame = CGRectMake(courseFace.left, courseFace.top, courseFace.width, priceLabel.bottom - courseFace.top);
        
        titleL.text = [NSString stringWithFormat:@"%@",infoArray[i][@"title"]];
        learnCountLabel.text = [NSString stringWithFormat:@"%@人在学",infoArray[i][@"sale_count"]];
        NSString *priceValue = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[infoArray[i] objectForKey:@"price"]]];
        priceLabel.textColor = EdlineV5_Color.faildColor;
        if ([[infoArray[i] objectForKey:@"is_buy"] integerValue]) {
            priceLabel.text = @"已购买";
            priceLabel.textColor = EdlineV5_Color.priceFreeColor;
        } else {
            if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"]) {
                priceLabel.text = @"免费";
                priceLabel.textColor = EdlineV5_Color.priceFreeColor;
            } else {
                priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[infoArray[i] objectForKey:@"price"]]];
                priceLabel.textColor = EdlineV5_Color.faildColor;
            }
        }
    }
    if (SWNOTEmptyArr(infoArray)) {
        [self setHeight:(infoArray.count%2 == 0) ? (infoArray.count/2.0) * TwoCellHeight + 30 : ((infoArray.count + 1)/2.0) * TwoCellHeight + 30];
    } else {
        [self setHeight:0];
    }
}

- (void)tapButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(categoryCourseTapJump:)]) {
        [_delegate categoryCourseTapJump:_categoryCourseArray[sender.tag - 666]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
