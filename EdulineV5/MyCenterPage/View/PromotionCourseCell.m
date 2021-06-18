//
//  PromotionCourseCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "PromotionCourseCell.h"
#import "V5_Constant.h"

@implementation PromotionCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 153, 86)];
    
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
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.text = @"你是个傻屌";
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    _titleL.numberOfLines = 0;
    [self.contentView addSubview:_titleL];
    
    _promotionIncome = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 21, _titleL.width, 21)];
    _promotionIncome.font = SYSTEMFONT(15);
    _promotionIncome.textColor = EdlineV5_Color.faildColor;
    [self.contentView addSubview:_promotionIncome];
}

- (void)setPromotionCourseCellInfo:(NSDictionary *)promotionInfo {
    [_courseFace sd_setImageWithURL:EdulineUrlString([promotionInfo objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    NSString *courseType = [NSString stringWithFormat:@"%@",[promotionInfo objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    _titleL.text = [NSString stringWithFormat:@"%@",[promotionInfo objectForKey:@"title"]];
    _titleL.numberOfLines = 0;
    [_titleL sizeToFit];
    if (_titleL.height > 50) {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    } else {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, _titleL.height);
    }
    _promotionIncome.text = [NSString stringWithFormat:@"累计收益：%@%@",IOSMoneyTitle,[promotionInfo objectForKey:@"sum"]];
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
