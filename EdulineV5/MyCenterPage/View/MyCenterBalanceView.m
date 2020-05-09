//
//  MyCenterBalanceView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterBalanceView.h"
#import "V5_Constant.h"


@implementation MyCenterBalanceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    NSArray *balanceArray = @[@"我的余额",@"我的收入",@"我的积分"];
    CGFloat WW = self.bounds.size.width / (balanceArray.count * 1.0);
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<balanceArray.count; i++) {
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(WW * i, (80 - 28 * 2) / 2.0, WW, 28)];
        lable1.textColor = EdlineV5_Color.textFirstColor;
        lable1.font = SYSTEMFONT(16);
        lable1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable1];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(WW * i, lable1.bottom, WW, 28)];
        lable2.textColor = EdlineV5_Color.textThirdColor;
        lable2.font = SYSTEMFONT(14);
        lable2.textAlignment = NSTextAlignmentCenter;
        lable2.text = balanceArray[i];
        [self addSubview:lable2];
        
        if (i==0) {
            _balanceLabel = lable1;
            _balanceTitleLabel = lable2;
        } else if (i == 1) {
            _incomeLabel = lable1;
            _incomeTitleLabel = lable2;
        } else if (i == 2) {
            _scoreLabel = lable1;
            _scoreTitleLabel = lable2;
        }
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WW * i, 0, WW, 80)];
        selectBtn.backgroundColor = [UIColor clearColor];
        selectBtn.tag = i;
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBtn];
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)selectBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToOtherVC:)]) {
        [_delegate jumpToOtherVC:sender];
    }
}

- (void)setBalanceInfo:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        NSString *balance = [NSString stringWithFormat:@"%@",[[[info objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"balance"]];
        NSString *income = [NSString stringWithFormat:@"%@",[[[info objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"income"]];
        NSString *credit = [NSString stringWithFormat:@"%@",[[[info objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"credit"]];
        _balanceLabel.text = [NSString stringWithFormat:@"¥%.2f",[balance floatValue]];
        _incomeLabel.text = [NSString stringWithFormat:@"¥%.2f",[income floatValue]];
        _scoreLabel.text = [NSString stringWithFormat:@"¥%.2f",[credit floatValue]];
    }
}

@end
