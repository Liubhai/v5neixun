//
//  LiveCourseListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveCourseListCell.h"
#import "V5_Constant.h"
@implementation LiveCourseListCell

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
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 4;
    _courseFace.clipsToBounds = YES;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"class_icon");
    [self.contentView addSubview:_courseTypeImage];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.text = @"你是个傻屌";
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self.contentView addSubview:_titleL];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 21, 150, 21)];
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.font = SYSTEMFONT(15);
    _priceLabel.text = @"育币1099.00";
    [self.contentView addSubview:_priceLabel];
    
    _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 68, _courseFace.bottom - 26, 68, 26)];
    _buyButton.layer.masksToBounds = YES;
    _buyButton.layer.cornerRadius = 13;
    _buyButton.titleLabel.font = SYSTEMFONT(15);
    [_buyButton setTitle:@"去抢购" forState:0];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:0];
    _buyButton.backgroundColor = EdlineV5_Color.themeColor;
    [_buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_buyButton];
}

- (void)setLiveCourseListCellInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndexPath {
    _cellIndex = cellIndexPath;
    [_courseFace sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
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
    _priceLabel.text = [NSString stringWithFormat:@"育币%@",[info objectForKey:@"price"]];
    NSString *priceValue = [NSString stringWithFormat:@"%@",[info objectForKey:@"price"]];
    
    _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50);
    _titleL.numberOfLines = 0;
    _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleL sizeToFit];
    if (_titleL.height > 40) {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, 40);
    } else {
        _titleL.frame = CGRectMake(_courseFace.right + 12, _courseFace.top, _titleL.width, _titleL.height);
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
            _priceLabel.text = [NSString stringWithFormat:@"育币%@",[info objectForKey:@"price"]];
            _priceLabel.textColor = EdlineV5_Color.faildColor;
        }
    }
}

- (void)buyButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpCourseDetailPage:)]) {
        [_delegate jumpCourseDetailPage:_cellIndex];
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