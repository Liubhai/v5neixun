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
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
    
    _courseFace.image = DefaultImage;
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 4;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"class_icon");
    [self addSubview:_courseTypeImage];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.text = @"你是个傻屌";
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self addSubview:_titleL];
    
    _learnProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 8, MainScreenWidth - _titleL.left - 15, 4)];
    _learnProgress.layer.masksToBounds = YES;
    _learnProgress.layer.cornerRadius = 2;
    _learnProgress.progress = 0.5;
    //设置它的风格，为默认的
    _learnProgress.trackTintColor= HEXCOLOR(0xF1F1F1);
    //设置轨道的颜色
    _learnProgress.progressTintColor= EdlineV5_Color.themeColor;
    [self addSubview:_learnProgress];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.text = @"50%";
    _learnCountLabel.font = SYSTEMFONT(12);
    _learnCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_learnCountLabel];
    
}

- (void)setStudyCourseInfo:(NSDictionary *)courseInfo {
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
    _learnProgress.progress = [[courseInfo objectForKey:@"finished_rate"] integerValue] / 100;
    if ([[courseInfo objectForKey:@"finished_rate"] integerValue] == 0) {
        _learnCountLabel.text = @"开始学习";
    } else if ([[courseInfo objectForKey:@"finished_rate"] integerValue] == 100) {
        _learnCountLabel.text = @"已完成";
    } else {
        _learnCountLabel.text = [NSString stringWithFormat:@"%@%%",@([[courseInfo objectForKey:@"finished_rate"] integerValue])];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
