//
//  ShopMainListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ShopMainListCell.h"
#import "V5_Constant.h"

#define shopMainCellWidth (MainScreenWidth/2.0 - 12.5)
#define shopMainCellHeight (MainScreenHeight - MACRO_UI_UPHEIGHT - 20 * 2)/2.0 - 24

@implementation ShopMainListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 12, shopMainCellWidth, shopMainCellHeight)];
    _backImageView.image = Image(@"exam_card_bg");
    _backImageView.hidden = YES;
    [self.contentView addSubview:_backImageView];
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115, 115)];
    _typeIcon.centerX = _backImageView.centerX;
    _typeIcon.centerY = _backImageView.centerY - 33;
    _typeIcon.hidden = YES;
    [self.contentView addSubview:_typeIcon];
    
    _typeTitle = [[UILabel alloc] initWithFrame:CGRectMake(_backImageView.left + 12, 0, _backImageView.width - 24, 50)];
    _typeTitle.centerX = _backImageView.centerX;
    _typeTitle.centerY = _backImageView.centerY + 141 / 2.0;
    
    _typeTitle.textColor = EdlineV5_Color.textFirstColor;
    _typeTitle.font = SYSTEMFONT(15);
    _typeTitle.numberOfLines = 0;
    [self.contentView addSubview:_typeTitle];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeTitle.left, _typeTitle.bottom, _typeTitle.width, 20)];
    _priceLabel.text = @"12积分";
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.font = SYSTEMFONT(15);
    [self.contentView addSubview:_priceLabel];
}

- (void)setShopMainListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex {
    _backImageView.hidden = NO;
    _typeIcon.hidden = NO;
    _typeTitle.hidden = NO;
    if (cellIndex.row % 2 == 0) {
        _backImageView.frame = CGRectMake(11, 12, shopMainCellWidth, shopMainCellHeight);
    } else {
        _backImageView.frame = CGRectMake(1.5, 12, shopMainCellWidth, shopMainCellHeight);
    }
    _typeIcon.centerX = _backImageView.centerX;
    _typeIcon.centerY = _backImageView.centerY - 33;
    
    _typeTitle.centerX = _backImageView.centerX;
    _typeTitle.centerY = _backImageView.centerY + 141 / 2.0;
    
    [_typeIcon sd_setImageWithURL:EdulineUrlString([info objectForKey:@"cover_url"]) placeholderImage:DefaultImage];
    _typeTitle.text = [info objectForKey:@"title"];
    
    _priceLabel.frame = CGRectMake(_typeTitle.left, _typeTitle.bottom, _typeTitle.width, 20);
}

@end
