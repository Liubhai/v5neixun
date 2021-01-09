//
//  MenberCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/22.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MenberCell.h"
#import "V5_Constant.h"

@implementation MenberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, MainScreenWidth - 30, 80)];
    _selectImage.image = Image(@"");
    _selectImage.layer.masksToBounds = YES;
    _selectImage.layer.borderColor = EdlineV5_Color.starNoColor.CGColor;
    _selectImage.layer.borderWidth = 0.5;
    [self.contentView addSubview:_selectImage];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectImage.left + 15, 5, 100, 80)];
    _titleLabel.textColor = HEXCOLOR(0x582F1D);
    _titleLabel.font = SYSTEMFONT(16);
    _titleLabel.text = @"月卡";
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 5, MainScreenWidth - 110 - 95, 80)];
    _priceLabel.font = SYSTEMFONT(24);
    _priceLabel.textColor = HEXCOLOR(0x582F1D);
    [self.contentView addSubview:_priceLabel];
    
    _freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectImage.right - 110 - 15, 5, 110, 80)];
    _freeLabel.font = SYSTEMFONT(12);
    _freeLabel.textColor = HEXCOLOR(0x582F1D);
    _freeLabel.text = @"赠送 100积分";
    _freeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_freeLabel];
    
}

- (void)setMemberInfo:(NSDictionary *)info indexpath:(NSIndexPath *)indexpath currentIndexpath:(NSIndexPath *)currentIndexpath {
    if (indexpath.row == currentIndexpath.row) {
        _selectImage.image = Image(@"card_pre");
        _selectImage.layer.borderColor = HEXCOLOR(0xF8CB9B).CGColor;
    } else {
        _selectImage.image = Image(@"");
        _selectImage.layer.borderColor = EdlineV5_Color.starNoColor.CGColor;
        
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    NSString *price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[info objectForKey:@"scribing_price"]];
    NSString *scribing_price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[info objectForKey:@"price"]];
    NSString *finalPrice = [NSString stringWithFormat:@"%@%@",scribing_price,price];
    NSRange rangOld = NSMakeRange(scribing_price.length, price.length);
    NSRange rangNow = NSMakeRange([NSString stringWithFormat:@"%@",IOSMoneyTitle].length, scribing_price.length - [NSString stringWithFormat:@"%@",IOSMoneyTitle].length);
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
    [priceAtt addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:14],NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:HEXCOLOR(0xA89377)} range:rangOld];
    [priceAtt addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:24],NSForegroundColorAttributeName: HEXCOLOR(0x582F1D)} range:rangNow];
    [priceAtt addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:16],NSForegroundColorAttributeName: HEXCOLOR(0x582F1D)} range:NSMakeRange(0, [NSString stringWithFormat:@"%@",IOSMoneyTitle].length)];
    _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
    _freeLabel.frame = CGRectMake(_selectImage.right - 110 - 15, 5, 110, 80);
    _freeLabel.text = [NSString stringWithFormat:@"赠送 %@积分",[info objectForKey:@"give_credit"]];
    CGFloat freeLabelWidth = [_freeLabel.text sizeWithFont:_freeLabel.font].width + 4;
    _freeLabel.frame = CGRectMake(_selectImage.right - freeLabelWidth - 15, 5, freeLabelWidth, 80);
    
    _priceLabel.frame = CGRectMake(95, 5, _freeLabel.left - 95, 80);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
