//
//  ThirdLoginView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ThirdLoginView.h"
#import "V5_Constant.h"

@implementation ThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubviews];
    }
    return self;
}

- (void)makeSubviews {
    _methodArray = [NSMutableArray arrayWithArray:@[@"login_icon_qq",@"login_icon_wechat",@"login_icon_weibo"]];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    titleL.text = @"第三方登录";
    titleL.textColor = HEXCOLOR(0x909399);
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = SYSTEMFONT(14);
    titleL.centerX = MainScreenWidth / 2.0;
    [self addSubview:titleL];
    
    UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(titleL.left - 10 - 24, 0, 24, 1)];
    lineLeft.backgroundColor = HEXCOLOR(0x909399);
    lineLeft.centerY = titleL.centerY;
    [self addSubview:lineLeft];
    
    UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(titleL.right + 10, 0, 24, 1)];
    lineRight.backgroundColor = HEXCOLOR(0x909399);
    lineRight.centerY = titleL.centerY;
    [self addSubview:lineRight];
    CGFloat space = (MainScreenWidth - _methodArray.count * (40 + 50) + 50) / 2.0;
    for (int i = 0; i<_methodArray.count; i++) {
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(space + 90 * i, titleL.bottom + 30, 40, 40)];
        [iconBtn setImage:Image(_methodArray[i]) forState:0];
        iconBtn.tag = i + 10;
        [iconBtn addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconBtn];
    }
}

- (void)iconButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonClickKKK:)]) {
        [_delegate loginButtonClickKKK:sender];
    }
}

@end
