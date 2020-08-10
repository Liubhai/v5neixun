//
//  CourseCollectionManagerCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCollectionManagerCell.h"
#import "V5_Constant.h"

@implementation CourseCollectionManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _selectedIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [_selectedIconBtn setImage:Image(@"checkbox_orange") forState:UIControlStateSelected];
    [_selectedIconBtn setImage:Image(@"checkbox_def") forState:0];
    [_selectedIconBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectedIconBtn.centerY = 92 / 2.0;
    [self addSubview:_selectedIconBtn];
    
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(_selectedIconBtn.right + 10, 10, 153, 86)];
    _courseFace.image = DefaultImage;
    _courseFace.clipsToBounds = YES;
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

- (void)setCourseCollectionManagerModel:(ShopCarCourseModel *)model indexpath:(nonnull NSIndexPath *)indexpath {
    _courseModel = model;
    _cellIndex= indexpath;
    
    _selectedIconBtn.selected = model.selected;
    
    [_courseFace sd_setImageWithURL:EdulineUrlString(model.cover_url) placeholderImage:DefaultImage];
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    // 1 点播 2 直播 3 面授 4 专辑
    NSString *courseType = [NSString stringWithFormat:@"%@",model.course_type];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    _titleL.text = [NSString stringWithFormat:@"%@",model.title];
    _learnCountLabel.text = [NSString stringWithFormat:@"%@人报名",model.sale_count];

    NSString *priceValue = [NSString stringWithFormat:@"%@",model.price];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"]) {
        _priceLabel.text = @"免费";
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",priceValue];
        _priceLabel.textColor = EdlineV5_Color.faildColor;
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

- (void)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(courseManagerSelectButtonClick:)]) {
        [_delegate courseManagerSelectButtonClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
