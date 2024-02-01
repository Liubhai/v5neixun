//
//  VideoMarqueeViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/12.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "VideoMarqueeViewController.h"
#import "V5_Constant.h"

@interface VideoMarqueeViewController () {
    NSInteger Number;
    CGRect    _labelSize;
    CGFloat labelHeight;
}

@property (strong ,nonatomic)NSTimer   *marqueeTimer;
@property (retain ,nonatomic)UILabel   *marqueeLabel;

@property (strong ,nonatomic)NSString  *showTime;
@property (strong ,nonatomic)NSString  *intervalTime;

@end

@implementation VideoMarqueeViewController

-(instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (!_marqueeLabel) {
        _marqueeLabel = [[UILabel alloc] init];
        _marqueeLabel.backgroundColor = [UIColor clearColor];
        _marqueeLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
        NSString *colorString = [NSString stringWithFormat:@"0x%@",dict[@"font_color"]];
        NSString *fontString = [NSString stringWithFormat:@"%@",dict[@"font_size"]];
        NSString *alphaString = [NSString stringWithFormat:@"%@",dict[@"font_opacity"]];
        labelHeight = [[NSString stringWithFormat:@"%@",dict[@"font_size"]] floatValue] + 5;
        _marqueeLabel.textColor = [EdulineV5_Tool colorWithHexString:colorString alpha:[alphaString integerValue] / 100.0];
        _marqueeLabel.font = SYSTEMFONT([fontString integerValue] / [UIScreen mainScreen].scale);
        [self.view addSubview:_marqueeLabel];
        _dict = dict;
        _showTime = [NSString stringWithFormat:@"%@",_dict[@"show"]];
        _intervalTime = [NSString stringWithFormat:@"%@",_dict[@"times"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self locationMarquu];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = NO;
    
    Number = 0;
    
    self.marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(marqueeTimerDeal) userInfo:nil repeats:YES];
}

- (void)locationMarquu {
    [self locationMarquuSize];
    CGFloat marqueeW = _labelSize.size.width;
    CGFloat marqueeH = labelHeight;
    CGFloat X = arc4random_uniform(MainScreenWidth - marqueeW);
    CGFloat Y = arc4random_uniform(190);
    self.marqueeLabel.frame = CGRectMake(X, Y, marqueeW, marqueeH);
}

- (void)locationMarquuSize {
    //设置label的最大行数
    _marqueeLabel.numberOfLines = 0;
    if ([_marqueeLabel.text isEqual:[NSNull null]]) {
        _marqueeLabel.frame = CGRectMake(15, 130, MainScreenWidth - 30, labelHeight);
        return;
    }
    
    CGRect labelSize = [_marqueeLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: _marqueeLabel.font} context:nil];
    _labelSize = labelSize;
}

- (void)marqueeTimerDeal {
    Number ++;
    if (Number % ([_showTime integerValue] + [_intervalTime integerValue]) == 0) {//刚好显示完一轮
        _marqueeLabel.hidden = YES;
        [self locationMarquu];
    } else if (Number % ([_showTime integerValue] + [_intervalTime integerValue]) < [_intervalTime integerValue]) {//说明正在隐藏阶段
        _marqueeLabel.hidden = YES;
    } else if (Number % ([_showTime integerValue] + [_intervalTime integerValue]) < [_showTime integerValue] + [_intervalTime integerValue]) {//当前正在显示
        _marqueeLabel.hidden = NO;
    }
}

@end
