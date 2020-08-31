//
//  CourseCouponView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCouponView.h"

@implementation CourseCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _couponIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 24, 24)];
    _couponIcon.image = Image(@"icon_quan");
    [self addSubview:_couponIcon];
    
    _couponsBackView = [[UIView alloc] initWithFrame:CGRectMake(_couponIcon.right + 8, 0, MainScreenWidth - (_couponIcon.right + 8 + 8 + 22 + 5), 48)];
    [self addSubview:_couponsBackView];
    
//    _couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(_couponIcon.right + 8, 0, 150, 48)];
//    _couponLabel.text = @"课程相关优惠券";
//    _couponLabel.font = SYSTEMFONT(14);
//    [self addSubview:_couponLabel];
    _couponIcon.centerY = _couponsBackView.centerY;
    
    _couponRightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 8 - 22, 0, 22, 22)];
    _couponRightIcon.centerY = _couponsBackView.centerY;
    _couponRightIcon.image = Image(@"quan_more");
    [self addSubview:_couponRightIcon];
    
    _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _couponsBackView.bottom, MainScreenWidth, 4)];
    _lineView2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView2];
    
    _tapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 52)];
    _tapButton.backgroundColor = [UIColor clearColor];
    [_tapButton addTarget:self action:@selector(tapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tapButton];
}

- (void)setCouponsListInfo:(NSArray *)couponsList {
    [_couponsBackView removeAllSubviews];
    CGFloat xx = 0.0;
    NSInteger counponCount = couponsList.count > 3 ? 3 : couponsList.count;
    for (int i = 0; i<counponCount; i++) {
        UILabel *couponT = [[UILabel alloc] initWithFrame:CGRectMake(xx, (48 - 20) / 2.0, 0, 20)];
        couponT.layer.masksToBounds = YES;
        couponT.layer.cornerRadius = 2.0;
        couponT.layer.borderWidth = 1;
        couponT.layer.borderColor = EdlineV5_Color.youhuijuanColor.CGColor;
        couponT.textAlignment = NSTextAlignmentCenter;
        couponT.textColor = EdlineV5_Color.youhuijuanColor;
        couponT.text = [NSString stringWithFormat:@"%@",couponsList[i]];
        couponT.font = SYSTEMFONT(12);
        CGFloat couponT_Width = [couponT.text sizeWithFont:couponT.font].width + 10;
        [couponT setWidth:couponT_Width];
        xx = couponT.right + 10;
        [_couponsBackView addSubview:couponT];
    }
}

- (void)tapButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToCouponsVC)]) {
        [_delegate jumpToCouponsVC];
    }
}

@end
