//
//  HomePageDiscountCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/7.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "HomePageDiscountCell.h"
#import "V5_Constant.h"

@implementation HomePageDiscountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _discountInfoArray = [NSMutableArray new];
        [_discountInfoArray removeAllObjects];
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _discountScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 + 30)];
    _discountScrollView.backgroundColor = [UIColor whiteColor];
    _discountScrollView.showsVerticalScrollIndicator = NO;
    _discountScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_discountScrollView];
}

- (void)setDiscountArrayInfo:(NSMutableArray *)infoArray {
    [_discountInfoArray removeAllObjects];
    [_discountInfoArray addObjectsFromArray:infoArray];
    [_discountScrollView removeAllSubviews];
    CGFloat TeaViewWidth = 148;
    CGFloat TeaViewHight = 200;
    
    _discountScrollView.contentSize = CGSizeMake(15 * 2 + (TeaViewWidth + 12) * infoArray.count - 12, 200 + 30);
    
    for (int i = 0 ; i < infoArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15 + (TeaViewWidth + 12) * i, 15, TeaViewWidth, TeaViewHight)];
        view.userInteractionEnabled = YES;
        view.tag = i;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = NO;
        
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,1);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 7.5;
        [_discountScrollView addSubview:view];
        
        //添加头像
        UIImageView *TeaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TeaViewWidth, 82.5)];
        NSString *urlStr = [NSString stringWithFormat:@"%@",[infoArray[i] objectForKey:@"product_cover"]];
        [TeaImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:DefaultUserImage];
        TeaImageView.layer.masksToBounds = YES;
        TeaImageView.layer.cornerRadius = 2;
        TeaImageView.clipsToBounds = YES;
        TeaImageView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:TeaImageView];
        
        UIImageView *courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(TeaImageView.left, TeaImageView.top, 33, 20)];
        NSString *courseType = [NSString stringWithFormat:@"%@",[infoArray[i] objectForKey:@"product_type"]];
        if ([courseType isEqualToString:@"1"]) {
            courseTypeImage.image = Image(@"dianbo");
        } else if ([courseType isEqualToString:@"2"]) {
            courseTypeImage.image = Image(@"live");
        } else if ([courseType isEqualToString:@"3"]) {
            courseTypeImage.image = Image(@"mianshou");
        } else if ([courseType isEqualToString:@"4"]) {
            courseTypeImage.image = Image(@"class_icon");
        }
        courseTypeImage.layer.masksToBounds = YES;
        courseTypeImage.layer.cornerRadius = 2;
        [view addSubview:courseTypeImage];
        courseTypeImage.hidden = YES;
        
        UIImageView *courseActivityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(TeaImageView.right - 52, TeaImageView.bottom - 17, 52, 17)];
        courseActivityIcon.image = Image(@"discount_icon");
        [view addSubview:courseActivityIcon];
        
        UILabel *typeTitle = [[UILabel alloc] initWithFrame:CGRectMake(7.5, TeaImageView.bottom + 9, view.width - 15, 40)];
        typeTitle.text = [infoArray[i] objectForKey:@"product_title"];
        typeTitle.textColor = EdlineV5_Color.textFirstColor;
        typeTitle.font = SYSTEMFONT(14);
        typeTitle.numberOfLines = 0;
        [view addSubview:typeTitle];
        
        UILabel *coursePrice = [[UILabel alloc] initWithFrame:CGRectMake(7.5, typeTitle.bottom + 5, view.width - 15, 18)];
        coursePrice.textColor = EdlineV5_Color.textThirdColor;
        coursePrice.font = SYSTEMFONT(11);
        
        NSString *price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[infoArray[i] objectForKey:@"price"]]];
        NSString *scribing_price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:[infoArray[i] objectForKey:@"product_price"]]];
        if ([scribing_price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [scribing_price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] || [scribing_price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]]) {
            if ([price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] ||[price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]]) {
                coursePrice.text = @"免费";
                coursePrice.textColor = EdlineV5_Color.priceFreeColor;
                coursePrice.font = SYSTEMFONT(13);
            } else {
                coursePrice.text = price;
                coursePrice.textColor = EdlineV5_Color.textPriceColor;
                coursePrice.font = SYSTEMFONT(13);
            }
        } else {
            if ([price isEqualToString:[NSString stringWithFormat:@"%@0.00",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0.0",IOSMoneyTitle]] || [price isEqualToString:[NSString stringWithFormat:@"%@0",IOSMoneyTitle]]) {
                price = @"免费";
                NSString *finalPrice = [NSString stringWithFormat:@"%@%@",price,scribing_price];
                NSRange rangNow = NSMakeRange(price.length, scribing_price.length);
                NSRange rangOld = NSMakeRange(0, price.length);
                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(13),NSForegroundColorAttributeName: EdlineV5_Color.priceFreeColor} range:rangOld];
                [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
                coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
            } else {
                NSString *finalPrice = [NSString stringWithFormat:@"%@%@",price,scribing_price];
                NSRange rangNow = NSMakeRange(price.length, scribing_price.length);
                NSRange rangOld = NSMakeRange(0, price.length);
                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(13),NSForegroundColorAttributeName: EdlineV5_Color.textPriceColor} range:rangOld];
                [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
                coursePrice.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
            }
        }
        [view addSubview:coursePrice];
        
        UIButton *lookBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, coursePrice.bottom + 10, 74, 24)];
        [lookBtn setTitle:@"马上抢" forState:0];
        lookBtn.userInteractionEnabled = NO;
        [lookBtn setTitleColor:[UIColor whiteColor] forState:0];
        lookBtn.titleLabel.font = SYSTEMFONT(14);
        lookBtn.backgroundColor = EdlineV5_Color.faildColor;
        lookBtn.layer.masksToBounds = YES;
        lookBtn.layer.cornerRadius = lookBtn.height / 2.0;
        lookBtn.centerX = view.width / 2.0;
        [view addSubview:lookBtn];
        
        //添加手势
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountCourseViewClick:)]];
    }
    [_discountScrollView setHeight:infoArray.count > 0 ? 230 : 0];
    [self setHeight:infoArray.count > 0 ? 230 : 0];
}

- (void)discountCourseViewClick:(UITapGestureRecognizer *)sender {
    NSLog(@"限时打折数据 = %@",_discountInfoArray[sender.view.tag]);
    if (_delegate && [_delegate respondsToSelector:@selector(goToDiscountCourseMainPage:)]) {
        [_delegate goToDiscountCourseMainPage:_discountInfoArray[sender.view.tag]];
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
