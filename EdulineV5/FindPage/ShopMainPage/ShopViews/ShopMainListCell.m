//
//  ShopMainListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ShopMainListCell.h"
#import "V5_Constant.h"

#define shopMainCellWidth (MainScreenWidth/2.0 - 4.5 - 15)
#define shopMainCellHeight (MainScreenWidth/2.0 - 4.5 - 15 + 118)

@implementation ShopMainListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, shopMainCellWidth, shopMainCellHeight)];
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    _whiteBackView.layer.masksToBounds = YES;
    _whiteBackView.layer.cornerRadius = 4;
    [self.contentView addSubview:_whiteBackView];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, shopMainCellWidth, shopMainCellWidth)];
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.image = Image(@"example");
//    CGFloat radius = 4; // 圆角大小
//    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_faceImageView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _faceImageView.bounds;
//    maskLayer.path = path.CGPath;
//    _faceImageView.layer.mask = maskLayer;
    
    [_whiteBackView addSubview:_faceImageView];
    
    _shopTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, _faceImageView.bottom + 8, _whiteBackView.width - 16, 19)];
    _shopTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _shopTitle.textColor = EdlineV5_Color.textFirstColor;
    [_whiteBackView addSubview:_shopTitle];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopTitle.left, _shopTitle.bottom + 2, _shopTitle.width, 22)];
    _priceLabel.text = @"100积分+¥10";
    _priceLabel.textColor = EdlineV5_Color.textPriceColor;
    _priceLabel.font = SYSTEMFONT(15);
    [_whiteBackView addSubview:_priceLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopTitle.left, _priceLabel.bottom + 4, _shopTitle.width, 15)];
    _numLabel.font = SYSTEMFONT(11);
    _numLabel.textColor = EdlineV5_Color.textPriceColor;
    _numLabel.text = @"1331人兑换";
    [_whiteBackView addSubview:_numLabel];
    
    _originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteBackView.width / 2.0, _numLabel.top, _whiteBackView.width / 2.0 - 8, 15)];
    _originPriceLabel.font = SYSTEMFONT(11);
    _originPriceLabel.textColor = EdlineV5_Color.textThirdColor;
    _originPriceLabel.textAlignment = NSTextAlignmentRight;
    [_whiteBackView addSubview:_originPriceLabel];
    
    _exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(_shopTitle.left, _numLabel.bottom + 8, _whiteBackView.width - 16, 28)];
    _exchangeButton.layer.masksToBounds = YES;
    _exchangeButton.layer.cornerRadius = 4;
    [_exchangeButton setTitle:@"立即兑换" forState:0];
    [_exchangeButton setTitleColor:[UIColor whiteColor] forState:0];
    [_exchangeButton addTarget:self action:@selector(exchangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _exchangeButton.titleLabel.font = SYSTEMFONT(14);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _exchangeButton.bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[HEXCOLOR(0xFF3B2F) CGColor], (id)[HEXCOLOR(0xFF8A52) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
    [_exchangeButton.layer insertSublayer:gradientLayer atIndex:0];
    
    [_whiteBackView addSubview:_exchangeButton];
}

/**
 "id": 1, //商品ID
 "title": "抽纸", //商品名称，模糊搜索
 "cover": 3988, //商品封面
 "scribing_price": "22.00", //划线价
 "cash_price": "12.00", //所需现金
 "credit_price": 1000, //所需积分
 "stock_num": 10, //库存
 "cover_url": "https://tv5-api.51eduline.com/attach/4bb0a47af12803988e072fbf6265ea54a" //封面URL
 */
- (void)setShopMainListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex {
    _shopInfoDt = info;
    if (cellIndex.row % 2 == 0) {
        _whiteBackView.frame = CGRectMake(15, 0, shopMainCellWidth, shopMainCellHeight);
    } else {
        _whiteBackView.frame = CGRectMake(4.5, 0, shopMainCellWidth, shopMainCellHeight);
    }
    [_faceImageView sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _shopTitle.text = [info objectForKey:@"title"];
    
    _priceLabel.font = SYSTEMFONT(16);
    _priceLabel.textColor = EdlineV5_Color.textPriceColor;
    
    NSString *showCredit = [NSString stringWithFormat:@"%@",info[@"credit_price"]];
    NSString *singlePrice = [NSString stringWithFormat:@"%@",info[@"cash_price"]];
    NSString *iosMoney = [NSString stringWithFormat:@"%@",IOSMoneyTitle];
    
    if ([showCredit isEqualToString:@"0"] && ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"])) {
        _priceLabel.text = @"免费";
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else if ([showCredit isEqualToString:@"0"]) {
        NSString *showPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,info[@"cash_price"]];
        
        NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
        [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(0, [iosMoney length])];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
        
    } else if ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"]) {
        NSString *showPrice = [NSString stringWithFormat:@"%@积分",info[@"credit_price"]];
        
        NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
        [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(showPrice.length - 2, 2)];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
    } else {
        NSString *showPrice = [NSString stringWithFormat:@"%@积分+%@%@",info[@"credit_price"],IOSMoneyTitle,info[@"cash_price"]];
        
        NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
        [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(showCredit.length, [[NSString stringWithFormat:@"积分+%@",IOSMoneyTitle] length])];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%@人兑换",info[@"sale_count"]];
    
    NSString *finalPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,info[@"scribing_price"]];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
    [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, finalPrice.length)];
    _originPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    
    NSString *origin = [NSString stringWithFormat:@"%@",info[@"scribing_price"]];
    if ([origin isEqualToString:@"0.00"] || [origin isEqualToString:@"0.0"] || [origin isEqualToString:@"0"]) {
        _originPriceLabel.hidden = YES;
    } else {
        _originPriceLabel.hidden = NO;
    }
    
}

- (void)exchangeButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeNowButton:)]) {
        [_delegate exchangeNowButton:_shopInfoDt];
    }
}

@end
