//
//  CourseDownView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseDownView.h"
#import "V5_Constant.h"
#import "V5_UserModel.h"

@implementation CourseDownView

- (instancetype)initWithFrame:(CGRect)frame isRecord:(BOOL)isRecord {
    self = [super initWithFrame:frame];
    if (self) {
        _isRecord = isRecord;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    _line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_line];
    
    _serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 35, 40)];
    [_serviceButton setImage:Image(@"tabbar_kefu") forState:0];
    [_serviceButton setTitle:@"咨询" forState:0];
    _serviceButton.titleLabel.font = SYSTEMFONT(13);
    [_serviceButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = _serviceButton.imageView.frame.size.width;
    CGFloat imageHeight = _serviceButton.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = _serviceButton.titleLabel.intrinsicContentSize.width;
        labelHeight = _serviceButton.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = _serviceButton.titleLabel.frame.size.width;
        labelHeight = _serviceButton.titleLabel.frame.size.height;
    }
    _serviceButton.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-0/2.0, 0, 0, -labelWidth);
    _serviceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-0/2.0, 0);
    [_serviceButton addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_serviceButton];
    
    _shopCarButton = [[UIButton alloc] initWithFrame:CGRectMake(_serviceButton.right + 10, 5, 40, 40)];
    [_shopCarButton setImage:Image(@"tabbar_gouwuche") forState:0];
    [_shopCarButton setTitle:@"购物车" forState:0];
    _shopCarButton.titleLabel.font = SYSTEMFONT(13);
    [_shopCarButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat shopimageWith = _serviceButton.imageView.frame.size.width;
    CGFloat shopimageHeight = _serviceButton.imageView.frame.size.height;
    
    CGFloat shoplabelWidth = 0.0;
    CGFloat shoplabelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        shoplabelWidth = _shopCarButton.titleLabel.intrinsicContentSize.width;
        shoplabelHeight = _shopCarButton.titleLabel.intrinsicContentSize.height;
    } else {
        shoplabelWidth = _shopCarButton.titleLabel.frame.size.width;
        shoplabelHeight = _shopCarButton.titleLabel.frame.size.height;
    }
    _shopCarButton.imageEdgeInsets = UIEdgeInsetsMake(-shoplabelHeight-0/2.0, 0, 0, -shoplabelWidth);
    _shopCarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -shopimageWith, -shopimageHeight-0/2.0, 0);
    [_shopCarButton addTarget:self action:@selector(shopCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shopCarButton];
    
    _shopCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopCarButton.centerX, _shopCarButton.top + 3, 18, 12)];
    _shopCountLabel.layer.masksToBounds = YES;
    _shopCountLabel.layer.cornerRadius = 6;
    _shopCountLabel.backgroundColor = EdlineV5_Color.faildColor;
    _shopCountLabel.textColor = [UIColor whiteColor];
    _shopCountLabel.font = SYSTEMFONT(10);
    _shopCountLabel.textAlignment = NSTextAlignmentCenter;
    _shopCountLabel.text = @"12";
    _shopCountLabel.hidden = YES;
    [self addSubview:_shopCountLabel];
    
    CGFloat WW = (self.bounds.size.width - _shopCarButton.right - 30) / 2.0;
    
    _joinShopCarButton = [[UIButton alloc] initWithFrame:CGRectMake(_shopCarButton.right + 10, 5, WW, 40)];
    _joinShopCarButton.layer.masksToBounds = YES;
    _joinShopCarButton.layer.cornerRadius = 20.0;
    _joinShopCarButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _joinShopCarButton.layer.borderWidth = 1.0;
    [_joinShopCarButton setTitle:@"加入购物车" forState:0];
    _joinShopCarButton.titleLabel.font = SYSTEMFONT(16);
    [_joinShopCarButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_joinShopCarButton addTarget:self action:@selector(joinShopCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _joinShopCarButton.hidden = YES;
    [self addSubview:_joinShopCarButton];
    
    _joinStudyButton = [[UIButton alloc] initWithFrame:CGRectMake(_joinShopCarButton.right + 10, 5, WW, 40)];
    _joinStudyButton.layer.masksToBounds = YES;
    _joinStudyButton.layer.cornerRadius = 20.0;
    [_joinStudyButton setTitle:@"加入学习" forState:0];
    _joinStudyButton.titleLabel.font = SYSTEMFONT(16);
    [_joinStudyButton setTitleColor:[UIColor whiteColor] forState:0];
    _joinStudyButton.backgroundColor = EdlineV5_Color.themeColor;
    [_joinStudyButton addTarget:self action:@selector(joinStudyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _joinStudyButton.hidden = YES;
    [self addSubview:_joinStudyButton];
    
    /** 下面两个按钮 是拼图和砍价时候才显示 */
    _activityJoinStudyButton = [[UIButton alloc] initWithFrame:CGRectMake(_shopCarButton.right + 10, 5, WW, 40)];
    _activityJoinStudyButton.layer.masksToBounds = YES;
    _activityJoinStudyButton.layer.cornerRadius = 20.0;
    _activityJoinStudyButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _activityJoinStudyButton.layer.borderWidth = 1.0;
    [_activityJoinStudyButton setTitle:@"立即加入" forState:0];
    _activityJoinStudyButton.titleLabel.font = SYSTEMFONT(16);
    [_activityJoinStudyButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_activityJoinStudyButton addTarget:self action:@selector(joinStudyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _activityJoinStudyButton.hidden = YES;
    [self addSubview:_activityJoinStudyButton];
    
    _activityButton = [[UIButton alloc] initWithFrame:CGRectMake(_joinShopCarButton.right + 10, 5, WW, 40)];
    _activityButton.layer.masksToBounds = YES;
    _activityButton.layer.cornerRadius = 20.0;
    [_activityButton setTitle:@"邀请砍价" forState:0];
    _activityButton.titleLabel.font = SYSTEMFONT(16);
    [_activityButton setTitleColor:[UIColor whiteColor] forState:0];
    _activityButton.backgroundColor = EdlineV5_Color.themeColor;
    [_activityButton addTarget:self action:@selector(KanjiaOrPintuan:) forControlEvents:UIControlEventTouchUpInside];
    _activityButton.hidden = YES;
    [self addSubview:_activityButton];
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 120, 36)];
    _recordButton.layer.masksToBounds = YES;
    _recordButton.layer.cornerRadius = 18;
    [_recordButton setTitle:@"记笔记" forState:0];
    _recordButton.backgroundColor = EdlineV5_Color.themeColor;
    _recordButton.centerX = MainScreenWidth / 2.0;
    [_recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recordButton];
    
    if (_isRecord) {
        _recordButton.hidden = NO;
        _serviceButton.hidden = YES;
        _shopCarButton.hidden = YES;
        _shopCountLabel.hidden = YES;
        _joinShopCarButton.hidden = YES;
        _joinStudyButton.hidden = YES;
    } else {
        _recordButton.hidden = YES;
        _serviceButton.hidden = NO;
        _shopCarButton.hidden = NO;
        _shopCountLabel.hidden = YES;
        _joinShopCarButton.hidden = YES;
        _joinStudyButton.hidden = YES;
    }
    
}

- (void)serviceButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpServiceVC:)]) {
        [_delegate jumpServiceVC:self];
    }
}

- (void)shopCarButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToShopCarVC:)]) {
        [_delegate jumpToShopCarVC:self];
    }
}

- (void)joinShopCarButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(joinShopCarEvent:)]) {
        [_delegate joinShopCarEvent:self];
    }
}

- (void)joinStudyButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(joinStudyEvent:)]) {
        [_delegate joinStudyEvent:self];
    }
}

- (void)recordButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToCommentVC)]) {
        [_delegate jumpToCommentVC];
    }
}

- (void)KanjiaOrPintuan:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(kanJiaAndPinTuan:)]) {
        [_delegate kanJiaAndPinTuan:self];
    }
}

- (void)setCOurseInfoData:(NSDictionary *)courseInfo {
    if (SWNOTEmptyDictionary(courseInfo)) {
        if ([[courseInfo objectForKey:@"is_buy"] boolValue]) {
            _joinShopCarButton.hidden = YES;
            
            _activityButton.hidden = YES;
            _activityJoinStudyButton.hidden = YES;
            
            [_joinStudyButton setLeft:_joinShopCarButton.left];
            [_joinStudyButton setWidth:MainScreenWidth - 15 - _joinShopCarButton.left];
            [_joinStudyButton setTitle:@"开始学习" forState:0];
            _joinStudyButton.hidden = NO;
            if ([courseInfo objectForKey:@"recent_learn"]) {
                if (SWNOTEmptyDictionary([courseInfo objectForKey:@"recent_learn"])) {
                    [_joinStudyButton setTitle:@"继续学习" forState:0];
                }
            }
        } else {
            _joinShopCarButton.hidden = NO;
            _joinStudyButton.hidden = NO;
            
            // 活动
            if (SWNOTEmptyDictionary(courseInfo[@"promotion"])) {
                _joinShopCarButton.hidden = YES;
                NSDictionary *promotion = [NSDictionary dictionaryWithDictionary:courseInfo[@"promotion"]];
                NSString *promotionType = [NSString stringWithFormat:@"%@",promotion[@"type"]];
                /** 活动类型【1：限时折扣；2：限时秒杀；3：砍价；4：拼团；】 */
                if ([promotionType isEqualToString:@"1"] || [promotionType isEqualToString:@"2"]) {
                    [_joinStudyButton setLeft:_joinShopCarButton.left];
                    [_joinStudyButton setWidth:MainScreenWidth - 15 - _joinShopCarButton.left];
                    [_joinStudyButton setTitle:@"立即加入" forState:0];
                } else if ([promotionType isEqualToString:@"3"]) {
                    _joinStudyButton.hidden = YES;
                    _activityButton.hidden = NO;
                    _activityJoinStudyButton.hidden = NO;
                    [_activityButton setTitle:@"邀请砍价" forState:0];
                } else if ([promotionType isEqualToString:@"4"]) {
                    _joinStudyButton.hidden = YES;
                    _activityButton.hidden = NO;
                    _activityJoinStudyButton.hidden = NO;
                    [_activityButton setTitle:@"发起拼团" forState:0];
                    if (SWNOTEmptyDictionary(courseInfo[@"pintuan_data"])) {
                        NSString *pintuanStatus = [NSString stringWithFormat:@"%@",courseInfo[@"pintuan_data"][@"status"]];
                        /** 团状态【0：开团待审(未支付成功)；1：开团成功；2：拼团成功；】 */
                        if ([pintuanStatus isEqualToString:@"1"] || [pintuanStatus isEqualToString:@"2"]) {
                            [_activityButton setTitle:@"发起拼团" forState:0];
                        } else {
                            NSString *total_num = [NSString stringWithFormat:@"%@",courseInfo[@"pintuan_data"][@"total_num"]];
                            NSString *join_num = [NSString stringWithFormat:@"%@",courseInfo[@"pintuan_data"][@"join_num"]];
                            [_activityButton setTitle:[NSString stringWithFormat:@"已参团%@/%@人",join_num,total_num] forState:0];
                        }
                    }
                }
            }
        }
        NSString *priceValue = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"price"]];
        NSString *user_price = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"user_price"]];
        if ([priceValue isEqualToString:@"0.00"] || [priceValue isEqualToString:@"0.0"] || [priceValue isEqualToString:@"0"] || ([[V5_UserModel vipStatus] isEqualToString:@"1"] && ([user_price isEqualToString:@"0.00"] || [user_price isEqualToString:@"0.0"] || [user_price isEqualToString:@"0"]))) {
            _joinShopCarButton.hidden = YES;
            [_joinStudyButton setLeft:_joinShopCarButton.left];
            [_joinStudyButton setWidth:MainScreenWidth - 15 - _joinShopCarButton.left];
        }
    }
}

@end
