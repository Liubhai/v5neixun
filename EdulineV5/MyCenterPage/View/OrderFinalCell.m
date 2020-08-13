//
//  OrderFinalCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderFinalCell.h"
#import "V5_Constant.h"
#import "UserModel.h"

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
    [self addSubview:_courseTypeImage];
    
    _theme = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _faceImageView.top, MainScreenWidth - _faceImageView.right - 64 - 10, 24)];
    _theme.font = SYSTEMFONT(15);
    _theme.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_theme];
    
    _dateLine = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _theme.bottom + 5, _theme.width, 15)];
    _dateLine.font = SYSTEMFONT(11);
    _dateLine.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_dateLine];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 12 - 100, _faceImageView.top, 100, 24)];
    _priceLabel.font = SYSTEMFONT(14);
    _priceLabel.textColor = EdlineV5_Color.textFirstColor;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    _scribing_price = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 12 - 100, _priceLabel.bottom, 100, 24)];
    _scribing_price.font = SYSTEMFONT(14);
    _scribing_price.textColor = EdlineV5_Color.textThirdColor;
    _scribing_price.textAlignment = NSTextAlignmentRight;
    [self addSubview:_scribing_price];
    _scribing_price.hidden = YES;
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _dateLine.top, 100, 15)];
    _countLabel.font = SYSTEMFONT(12);
    _countLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_countLabel];
}

- (void)setOrderFinalInfo:(NSDictionary *)OrderFinalInfo {
    // 1 点播 2 直播 3 面授 4 专辑
    //_courseFaceImageView.frame = CGRectMake(15, 15, 32, 16);
    NSString *courseType = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"type_id"]];
    [_faceImageView sd_setImageWithURL:EdulineUrlString([OrderFinalInfo objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _faceImageView.frame = CGRectMake(12, 7.5, 120, 66);
    _courseTypeImage.hidden = NO;
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    } else if ([courseType isEqualToString:@"5"]) {
        _courseTypeImage.hidden = YES;
        _faceImageView.image = Image(@"contents_icon_video");
        _faceImageView.frame = CGRectMake(12, 7.5, 32, 16);
    } else if ([courseType isEqualToString:@"6"]) {
        _courseTypeImage.hidden = YES;
        _faceImageView.image = Image(@"contents_icon_vioce");
        _faceImageView.frame = CGRectMake(12, 7.5, 32, 16);
    } else if ([courseType isEqualToString:@"7"]) {
        _courseTypeImage.hidden = YES;
        _faceImageView.image = Image(@"img_text_icon");
        _faceImageView.frame = CGRectMake(12, 7.5, 32, 16);
    } else if ([courseType isEqualToString:@"8"]) {
        _courseTypeImage.hidden = YES;
        _faceImageView.image = Image(@"ebook_icon_word");
        _faceImageView.frame = CGRectMake(12, 7.5, 32, 16);
    } else if ([courseType isEqualToString:@"9"]) {
        _courseTypeImage.hidden = YES;
        _faceImageView.image = Image(@"contents_icon_test");
        _faceImageView.frame = CGRectMake(12, 7.5, 32, 16);
    } else if ([courseType isEqualToString:@"10"]) {
        _courseTypeImage.hidden = YES;
    }
    
    _theme.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"title"]];
    
    [_theme sizeToFit];
    
    _theme.frame = CGRectMake(_faceImageView.right + 10, _faceImageView.top, MainScreenWidth - _faceImageView.right - 64 - 10, _theme.height);
    
    
    _dateLine.frame = CGRectMake(_faceImageView.right + 10, _theme.bottom + 5, _theme.width, 15);
    
    
    _priceLabel.frame = CGRectMake(MainScreenWidth - 12 - 100, _faceImageView.top, 100, 24);
    
    
    _scribing_price.frame = CGRectMake(MainScreenWidth - 12 - 100, _priceLabel.bottom, 100, 24);
    
    
    _countLabel.frame = CGRectMake(MainScreenWidth - 15 - 100, _dateLine.top, 100, 15);
    
    
    if ([[NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"expire_time"]] isEqualToString:@"0"] || !SWNOTEmptyStr([OrderFinalInfo objectForKey:@"expire_time"])) {
        _dateLine.text = @"永久有效";
    } else {
        _dateLine.text = [NSString stringWithFormat:@"有效期至%@",[EdulineV5_Tool timeForYYYYMMDD:[NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"expire_time"]]]];
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"price"]];
    if ([[UserModel vipStatus] isEqualToString:@"1"]) {
        _priceLabel.text = [NSString stringWithFormat:@"VIP:¥%@",[OrderFinalInfo objectForKey:@"user_price"]];
    }
    _scribing_price.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"scribing_price"]];
    NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_scribing_price.text];
    [mut addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, _scribing_price.text.length)];
    _scribing_price.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    if ([courseType isEqualToString:@"1"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"2"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"3"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"4"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"5"]) {
        [self setHeight:_dateLine.bottom + 16.5];
    } else if ([courseType isEqualToString:@"6"]) {
        [self setHeight:_dateLine.bottom + 16.5];
    } else if ([courseType isEqualToString:@"7"]) {
        [self setHeight:_dateLine.bottom + 16.5];
    } else if ([courseType isEqualToString:@"8"]) {
        [self setHeight:_dateLine.bottom + 16.5];
    } else if ([courseType isEqualToString:@"9"]) {
        [self setHeight:_dateLine.bottom + 16.5];
    } else if ([courseType isEqualToString:@"10"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
