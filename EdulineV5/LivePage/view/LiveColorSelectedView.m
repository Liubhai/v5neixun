//
//  LiveColorSelectedView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveColorSelectedView.h"
#import "V5_Constant.h"

#define liveColorSelectWidth 26
#define liveColorViewWidth 20

@implementation LiveColorSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,2);
    self.bgView.layer.shadowOpacity = 2;
    self.bgView.layer.shadowRadius = 4;
    [self addSubview:self.bgView];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
    self.tipLabel.font = SYSTEMFONT(14);
    self.tipLabel.textColor = EdlineV5_Color.textFirstColor;
    self.tipLabel.text = @"选择颜色";
    [self addSubview:self.tipLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.bounds.size.width, 1)];
    self.lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:self.lineView];
    
    self.colorBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom, self.bounds.size.width, liveColorSelectWidth * 2 + 30)];
    [self makeColorSelectButtonUI];
    [self addSubview:self.colorBackView];
}

- (void)makeColorSelectButtonUI {
    [self.colorBackView removeAllSubviews];
    self.colorArray = [NSMutableArray arrayWithObjects:@"FF0D19",@"FF8F00",@"FFCA00",@"00DD52",@"007CFF",@"C455DF",@"FFFFFF",@"EEEEEE",@"CCCCCC",@"666666",@"333333",@"000000", nil];
    for (int i = 0; i<self.colorArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (liveColorSelectWidth + 10) * (i % 6), 10 + (liveColorSelectWidth + 10) * (i / 6), liveColorSelectWidth, liveColorSelectWidth)];
        
        UIView *outColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, liveColorSelectWidth, liveColorSelectWidth)];
        outColorView.backgroundColor = [UIColor colorWithHexString:@"DEEFFF"];
        outColorView.layer.borderWidth = 1.f;
        outColorView.layer.borderColor = [UIColor colorWithHexString:@"44A2FC"].CGColor;
        outColorView.layer.cornerRadius = 13.f;
        outColorView.layer.masksToBounds = YES;
        outColorView.tag = 10;
        outColorView.hidden = YES;
        [btn addSubview:outColorView];
        
        UIView *colorView = [[UIView alloc] init];
        colorView.frame = CGRectMake(3, 3, liveColorViewWidth, liveColorViewWidth);
        colorView.layer.cornerRadius = 10.f;
        colorView.layer.masksToBounds = YES;
        colorView.backgroundColor = [UIColor colorWithHexString:self.colorArray[i]];
        colorView.userInteractionEnabled = NO;
        [btn addSubview:colorView];
        
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorBackView addSubview:btn];
    }
    [self.colorBackView setHeight:liveColorSelectWidth * 2 + 30];
}

- (void)buttonClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(colorBtnClick:)]) {
        [_delegate colorBtnClick:sender];
    }
}

@end
