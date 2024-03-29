//
//  OrderDetailAsCellView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/8.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "OrderDetailAsCellView.h"
#import "V5_Constant.h"
#import "V5_UserModel.h"

#define OrderDetailCellWidth MainScreenWidth - 30

@implementation OrderDetailAsCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7.5, 120, 66)];
    _faceImageView.image = DefaultImage;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 2;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_faceImageView];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_faceImageView.left, _faceImageView.top, 33, 20)];
    _courseTypeImage.layer.masksToBounds = YES;
    _courseTypeImage.layer.cornerRadius = 2;
    [self addSubview:_courseTypeImage];
    
    _theme = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _faceImageView.top, OrderDetailCellWidth - _faceImageView.right - 64 - 10, 24)];
    _theme.font = SYSTEMFONT(15);
    _theme.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_theme];
    
    _dateLine = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, _theme.bottom + 5, _theme.width, 15)];
    _dateLine.font = SYSTEMFONT(11);
    _dateLine.textColor = EdlineV5_Color.textThirdColor;
//    _dateLine.hidden = YES;
    [self addSubview:_dateLine];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(OrderDetailCellWidth - 12 - 100, _faceImageView.top, 100, 24)];
    _priceLabel.font = SYSTEMFONT(14);
    _priceLabel.textColor = EdlineV5_Color.textFirstColor;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.numberOfLines = 0;
    [self addSubview:_priceLabel];
    
    _scribing_price = [[UILabel alloc] initWithFrame:CGRectMake(OrderDetailCellWidth - 12 - 100, _priceLabel.bottom, 100, 24)];
    _scribing_price.font = SYSTEMFONT(14);
    _scribing_price.textColor = EdlineV5_Color.textThirdColor;
    _scribing_price.textAlignment = NSTextAlignmentRight;
    [self addSubview:_scribing_price];
    _scribing_price.hidden = YES;
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_theme.left, _faceImageView.bottom - 17, 100, 17)];
    _countLabel.font = SYSTEMFONT(12);
    _countLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_countLabel];
}

- (void)setOrderDetailFinalInfo:(NSDictionary *)OrderFinalInfo orderStatus:(NSString *)orderStatus cellInfo:(nonnull NSDictionary *)info {
    // 1 点播 2 直播 3 面授 4 专辑
    //_courseFaceImageView.frame = CGRectMake(15, 15, 32, 16);
    
    _priceLabel.textColor = EdlineV5_Color.textFirstColor;
    
    NSString *courseType = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"type_id"]];
    [_faceImageView sd_setImageWithURL:EdulineUrlString([OrderFinalInfo objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _faceImageView.hidden = NO;
    _courseTypeImage.hidden = NO;
    [_courseTypeImage setSize:CGSizeMake(33, 20)];
    
    if ([courseType isEqualToString:@"11"]) {
        _faceImageView.frame = CGRectMake(12, 7.5, 66, 66);
        _theme.frame = CGRectMake(_faceImageView.right + 10, _faceImageView.top, OrderDetailCellWidth - _faceImageView.right - 64 - 10 - 56, 24);
        _theme.numberOfLines = 0;
    } else {
        _faceImageView.frame = CGRectMake(12, 7.5, 120, 66);
        _theme.frame = CGRectMake(_faceImageView.right + 10, _faceImageView.top, OrderDetailCellWidth - _faceImageView.right - 64 - 10, 24);
        _theme.numberOfLines = 1;
    }
    _courseTypeImage.frame = CGRectMake(_faceImageView.left, _faceImageView.top, 33, 20);
    _dateLine.frame = CGRectMake(_faceImageView.right + 10, _theme.bottom + 5, _theme.width, 15);
    
    if ([courseType isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([courseType isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([courseType isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([courseType isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    } else if ([courseType isEqualToString:@"101"]) {
        _faceImageView.hidden = YES;
        [_courseTypeImage setSize:CGSizeMake(32, 16)];
        _courseTypeImage.image = Image(@"contents_icon_video");
    } else if ([courseType isEqualToString:@"102"]) {
        _faceImageView.hidden = YES;
        [_courseTypeImage setSize:CGSizeMake(32, 16)];
        _courseTypeImage.image = Image(@"contents_icon_vioce");
    } else if ([courseType isEqualToString:@"103"]) {
        _faceImageView.hidden = YES;
        [_courseTypeImage setSize:CGSizeMake(32, 16)];
        _courseTypeImage.image = Image(@"img_text_icon");
    } else if ([courseType isEqualToString:@"104"]) {
        _faceImageView.hidden = YES;
        [_courseTypeImage setSize:CGSizeMake(32, 16)];
        _courseTypeImage.image = Image(@"ebook_icon_word");
    } else if ([courseType isEqualToString:@"8"] || [courseType isEqualToString:@"9"] || [courseType isEqualToString:@"10"]) {
        _faceImageView.hidden = YES;
        [_courseTypeImage setSize:CGSizeMake(32, 16)];
        _courseTypeImage.image = Image(@"contents_icon_test");
    } else if ([courseType isEqualToString:@"11"]) {
        _courseTypeImage.hidden = YES;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",[EdulineV5_Tool reviseString:[OrderFinalInfo objectForKey:@"user_price"]],IOSMoneyTitle];
    if ([courseType isEqualToString:@"101"] || [courseType isEqualToString:@"102"] || [courseType isEqualToString:@"103"] || [courseType isEqualToString:@"104"]) {
        _priceLabel.text = [NSString stringWithFormat:@"%@%@",[OrderFinalInfo objectForKey:@"price"],IOSMoneyTitle];
    }
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    _priceLabel.frame = CGRectMake(OrderDetailCellWidth - 12 - priceWidth, _faceImageView.top, priceWidth, 24);
    
    _scribing_price.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool reviseString:[OrderFinalInfo objectForKey:@"scribing_price"]]];
    NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_scribing_price.text];
    [mut addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, _scribing_price.text.length)];
    _scribing_price.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
    
    _theme.frame = CGRectMake(_faceImageView.right + 10, _faceImageView.top, _priceLabel.left - _faceImageView.right - 10 - 10, _theme.height);
    
    _theme.text = [NSString stringWithFormat:@"%@",[OrderFinalInfo objectForKey:@"title"]];
    
    if ([courseType isEqualToString:@"1"] || [courseType isEqualToString:@"2"] || [courseType isEqualToString:@"3"] || [courseType isEqualToString:@"4"]) {
        _theme.numberOfLines = 1;
        [_theme setHeight:24];
    } else if ([courseType isEqualToString:@"101"] || [courseType isEqualToString:@"102"] || [courseType isEqualToString:@"103"] || [courseType isEqualToString:@"104"] || [courseType isEqualToString:@"8"] || [courseType isEqualToString:@"9"] || [courseType isEqualToString:@"10"]) {
        _theme.frame = CGRectMake(_courseTypeImage.right + 10, _courseTypeImage.top, _priceLabel.left - _courseTypeImage.right - 10 - 10, _theme.height);
        _theme.numberOfLines = 0;
        [_theme sizeToFit];
        if (_theme.height > 32) {
            [_theme setHeight:32];
        } else {
            [_theme setHeight:_theme.height];
        }
    } else if ([courseType isEqualToString:@"11"]) {
        _theme.frame = CGRectMake(_faceImageView.right + 10, _faceImageView.top, OrderDetailCellWidth - _faceImageView.right - 64 - 10 - 56, 24);
        _theme.numberOfLines = 0;
        
        [_theme sizeToFit];
        if (_theme.height > 42) {
            [_theme setHeight:42];
        } else {
            [_theme setHeight:_theme.height];
        }
        
        [self setHeight:_faceImageView.bottom + 7.5];
    }
    
    
    _dateLine.frame = CGRectMake(_theme.left, _theme.bottom + 5, OrderDetailCellWidth - _theme.left, 15);
    
    if ([orderStatus isEqualToString:@"20"]) {
        _dateLine.hidden = NO;
        NSString *timeLine = [NSString stringWithFormat:@"%@",OrderFinalInfo[@"expire_rest"]];
        if ([timeLine isEqualToString:@"-1"]) {
            _dateLine.text = @"永久有效";
            _dateLine.textColor = EdlineV5_Color.textThirdColor;
        } else {
            _dateLine.text = [NSString stringWithFormat:@"距离课程到期还有%@天",timeLine];
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:_dateLine.text];
            [priceAtt addAttributes:@{NSForegroundColorAttributeName: EdlineV5_Color.faildColor} range:NSMakeRange(8, timeLine.length)];
            _dateLine.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
        }
    } else {
        _dateLine.hidden = YES;
    }
    
    _scribing_price.frame = CGRectMake(OrderDetailCellWidth - 12 - 100, _priceLabel.bottom, 100, 24);
    
    
    
    _countLabel.frame = CGRectMake(_theme.left, _faceImageView.bottom - 17, 100, 17);
    if ([courseType isEqualToString:@"11"]) {
        NSString *showCredit = [NSString stringWithFormat:@"%@",info[@"ext_data"][@"credit_price"]];
        NSString *singlePrice = [NSString stringWithFormat:@"%@",info[@"ext_data"][@"cash_price"]];
        NSString *iosMoney = [NSString stringWithFormat:@"%@",IOSMoneyTitle];
        
        if ([showCredit isEqualToString:@"0"] && ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"])) {
            _priceLabel.text = @"免费";
            _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
            _priceLabel.frame = CGRectMake(OrderDetailCellWidth - 12 - 100, _faceImageView.top, 100, 24);
        } else if ([showCredit isEqualToString:@"0"]) {
            _priceLabel.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",info[@"ext_data"][@"cash_price"]],IOSMoneyTitle];
            _priceLabel.frame = CGRectMake(OrderDetailCellWidth - 12 - 100, _faceImageView.top, 100, 24);
        } else if ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"]) {
            _priceLabel.text = [NSString stringWithFormat:@"%@积分",[NSString stringWithFormat:@"%@",info[@"ext_data"][@"credit_price"]]];
            _priceLabel.frame = CGRectMake(OrderDetailCellWidth - 12 - 100, _faceImageView.top, 100, 24);
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"%@积分",[NSString stringWithFormat:@"%@",info[@"ext_data"][@"credit_price"]]];
            _priceLabel.frame = CGRectMake(OrderDetailCellWidth - 12 - 100, _faceImageView.top, 100, 24);
        }
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"x%@",info[@"ext_data"][@"num"]];
        _dateLine.hidden = YES;
    } else {
        _countLabel.hidden = YES;
    }
    
    if ([courseType isEqualToString:@"1"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"2"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"3"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"4"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    } else if ([courseType isEqualToString:@"101"] || [courseType isEqualToString:@"102"] || [courseType isEqualToString:@"103"] || [courseType isEqualToString:@"104"] || [courseType isEqualToString:@"8"] || [courseType isEqualToString:@"9"] || [courseType isEqualToString:@"10"]) {
        [self setHeight:_dateLine.bottom + 16.5];
    } else if ([courseType isEqualToString:@"11"]) {
        [self setHeight:_faceImageView.bottom + 7.5];
    }
}

@end
