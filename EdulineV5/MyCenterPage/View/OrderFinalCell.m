//
//  OrderFinalCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderFinalCell.h"
#import "V5_Constant.h"

@implementation OrderFinalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7.5, 120, 66)];
    _faceImageView.image = DefaultImage;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 4;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_faceImageView];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_faceImageView.right - 32, _faceImageView.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"album_icon");
    [self addSubview:_courseTypeImage];
    
    _theme = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _faceImageView.top, MainScreenWidth - _faceImageView.right - 64 - 10, 24)];
    _theme.font = SYSTEMFONT(15);
    _theme.textColor = EdlineV5_Color.textFirstColor;
    _theme.text = @"课程标题显示在这里";
    [self addSubview:_theme];
    
    _dateLine = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _theme.bottom + 5, _theme.width, 15)];
    _dateLine.font = SYSTEMFONT(11);
    _dateLine.textColor = EdlineV5_Color.textThirdColor;
    _dateLine.text = @"有效期至2021-11-12 ";
    [self addSubview:_dateLine];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 12 - 100, _faceImageView.top, 100, 24)];
    _priceLabel.font = SYSTEMFONT(14);
    _priceLabel.textColor = EdlineV5_Color.textFirstColor;
    _priceLabel.text = @"¥199";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    _scribing_price = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 12 - 100, _priceLabel.bottom, 100, 24)];
    _scribing_price.font = SYSTEMFONT(14);
    _scribing_price.textColor = EdlineV5_Color.textThirdColor;
    _scribing_price.text = @"¥199";
    _scribing_price.textAlignment = NSTextAlignmentRight;
    [self addSubview:_scribing_price];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _dateLine.top, 100, 15)];
    _countLabel.font = SYSTEMFONT(12);
    _countLabel.textColor = EdlineV5_Color.textThirdColor;
    _countLabel.text = @"x2";
    [self addSubview:_countLabel];
}

- (void)setOrderFinalInfo:(NSDictionary *)OrderFinalInfo {
    // 1 点播 2 直播 3 面授 4 专辑
    NSString *courseType = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"course_type"]];
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"album_icon");
    }
    
    _theme.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"title"]];
    [_faceImageView sd_setImageWithURL:EdulineUrlString([OrderFinalInfo objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    if ([[NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"expire_time"]] isEqualToString:@"0"]) {
        _dateLine.text = @"永久有效";
    } else {
        _dateLine.text = [NSString stringWithFormat:@"有效期至%@",[EdulineV5_Tool timeForYYYYMMDD:[NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"expire_time"]]]];
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"price"]];
    _scribing_price.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"scribing_price"]];
    NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_scribing_price.text];
    [mut addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, _scribing_price.text.length)];
    _scribing_price.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    [self setHeight:_faceImageView.bottom + 7.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
