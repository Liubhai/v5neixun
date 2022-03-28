//
//  ClassCourseCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ClassCourseCell.h"
#import "V5_Constant.h"

@implementation ClassCourseCell

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
    [self.contentView addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"class_icon");
    [self.contentView addSubview:_courseTypeImage];
    _courseTypeImage.hidden = YES;
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self.contentView addSubview:_titleL];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 18, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.font = SYSTEMFONT(12);
    [self.contentView addSubview:_learnCountLabel];
    
    _manageButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 63, 0, 63, 21)];
    _manageButton.centerY = _learnCountLabel.centerY;
    [_manageButton setTitle:@"学员管理" forState:0];
    [_manageButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _manageButton.titleLabel.font = SYSTEMFONT(15);
    [_manageButton addTarget:self action:@selector(manageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_manageButton];
    
}

- (void)setClassCourseInfo:(NSDictionary *)info {
    _classCourseInfo = info;
    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    // 1 点播 2 直播 3 面授 4 专辑
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
    
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人在学",[info objectForKey:@"student_count"]];
}

- (void)manageButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpStudentManageVC:)]) {
        [_delegate jumpStudentManageVC:_classCourseInfo];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
