//
//  ShopContentView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ShopContentView.h"
#import "V5_Constant.h"

@implementation ShopContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 52)];
    _shopTitleLabel.font = SYSTEMFONT(16);
    _shopTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _shopTitleLabel.numberOfLines = 0;
    [self addSubview:_shopTitleLabel];
    
    _saleNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _shopTitleLabel.bottom, 60, 28)];
    _saleNumLabel.textColor = EdlineV5_Color.textThirdColor;
    _saleNumLabel.font = SYSTEMFONT(12);
    [self addSubview:_saleNumLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_saleNumLabel.right + 8, 0, 1, 8)];
    _lineView.centerY = _saleNumLabel.centerY;
    _lineView.backgroundColor = EdlineV5_Color.backColor;
    [self addSubview:_lineView];
    
    _storageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right + 8, _saleNumLabel.top, 50, _saleNumLabel.height)];
    _storageLabel.textColor = EdlineV5_Color.textThirdColor;
    _storageLabel.font = SYSTEMFONT(12);
    [self addSubview:_storageLabel];
    
    _originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 60, _saleNumLabel.top, 60, _saleNumLabel.height)];
    _originPriceLabel.textAlignment = NSTextAlignmentRight;
    _originPriceLabel.textColor = EdlineV5_Color.textThirdColor;
    _originPriceLabel.font = SYSTEMFONT(12);
    [self addSubview:_originPriceLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_originPriceLabel.left - 4 - 150, 0, 150, 22)];
    _priceLabel.centerY = _saleNumLabel.centerY;
    _priceLabel.font = SYSTEMFONT(18);
    _priceLabel.textColor = EdlineV5_Color.textPriceColor;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
}

- (void)setShopContentInfo:(NSDictionary *)shopInfo {
    _shopTitleLabel.text = [NSString stringWithFormat:@"%@",shopInfo[@"title"]];
    
    _shopTitleLabel.numberOfLines = 0;
    [_shopTitleLabel sizeToFit];
    
    [_shopTitleLabel setHeight:_shopTitleLabel.height + 32];
    
    [_saleNumLabel setTop:_shopTitleLabel.bottom];
    _lineView.centerY = _saleNumLabel.centerY;
    [_storageLabel setTop:_saleNumLabel.top];
    [_originPriceLabel setTop:_saleNumLabel.top];
    _priceLabel.centerY = _saleNumLabel.centerY;
    
    NSString *saleCount = [NSString stringWithFormat:@"%@",shopInfo[@"month_count"]];
    if ([saleCount isEqualToString:@"<null>"] || [saleCount isEqualToString:@"null"]) {
        _saleNumLabel.text = @"月兑换0";
    } else {
        _saleNumLabel.text = [NSString stringWithFormat:@"月兑换%@",shopInfo[@"month_count"]];
    }
    [_saleNumLabel setWidth:[_saleNumLabel.text sizeWithFont:_saleNumLabel.font].width];
    
    [_lineView setLeft:_saleNumLabel.right + 8];
    
    [_storageLabel setLeft:_lineView.right + 8];
    _storageLabel.text = [NSString stringWithFormat:@"库存%@",shopInfo[@"stock_num"]];
    
    NSString *finalPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,shopInfo[@"scribing_price"]];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
    [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, finalPrice.length)];
    _originPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    CGFloat originwidth = [_originPriceLabel.text sizeWithFont:_originPriceLabel.font].width;
    [_originPriceLabel setLeft:MainScreenWidth - 15 - originwidth];
    [_originPriceLabel setWidth:originwidth];
    
    // 如果原始价格为零 不显示
    NSString *origin = [NSString stringWithFormat:@"%@",shopInfo[@"scribing_price"]];
    if ([origin isEqualToString:@"0.00"] || [origin isEqualToString:@"0.0"] || [origin isEqualToString:@"0"]) {
        _originPriceLabel.hidden = YES;
        [_originPriceLabel setLeft:MainScreenWidth - 15];
        [_originPriceLabel setWidth:0];
    } else {
        _originPriceLabel.hidden = NO;
    }
    
    _priceLabel.font = SYSTEMFONT(18);
    _priceLabel.textColor = EdlineV5_Color.textPriceColor;
    
    NSString *showCredit = [NSString stringWithFormat:@"%@",shopInfo[@"credit_price"]];
    NSString *singlePrice = [NSString stringWithFormat:@"%@",shopInfo[@"cash_price"]];
    NSString *iosMoney = [NSString stringWithFormat:@"%@",IOSMoneyTitle];
    
    NSString *showPrice = @"";
    
    if ([showCredit isEqualToString:@"0"] && ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"])) {
        showPrice = @"免费";
        _priceLabel.text = showPrice;
        _priceLabel.textColor = EdlineV5_Color.priceFreeColor;
    } else if ([showCredit isEqualToString:@"0"]) {
        showPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,shopInfo[@"cash_price"]];
        
        NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
        [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(0, [iosMoney length])];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
        
    } else if ([singlePrice isEqualToString:@"0.00"] || [singlePrice isEqualToString:@"0.0"] || [singlePrice isEqualToString:@"0"]) {
        showPrice = [NSString stringWithFormat:@"%@积分",shopInfo[@"credit_price"]];
        
        NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
        [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(showPrice.length - 2, 2)];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
    } else {
        showPrice = [NSString stringWithFormat:@"%@积分+%@%@",shopInfo[@"credit_price"],IOSMoneyTitle,shopInfo[@"cash_price"]];
        
        NSMutableAttributedString *showPriceAtt = [[NSMutableAttributedString alloc] initWithString:showPrice];
        [showPriceAtt addAttributes:@{NSFontAttributeName:SYSTEMFONT(11)} range:NSMakeRange(showCredit.length, [[NSString stringWithFormat:@"积分+%@",IOSMoneyTitle] length])];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:showPriceAtt];
    }
    
    CGFloat pricewidth = [showPrice sizeWithFont:SYSTEMFONT(18)].width;
    
    [_priceLabel setLeft:_originPriceLabel.left - (_originPriceLabel.width>0 ? 4 : 0) - pricewidth];
    [_priceLabel setWidth:pricewidth];
    [self setHeight:38 + _shopTitleLabel.bottom];
}

@end
