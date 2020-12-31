//
//  JustCircleProgress.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/31.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "JustCircleProgress.h"
#import "V5_Constant.h"

@implementation JustCircleProgress {
    CGFloat radius;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}
 
-(instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
 
-(void)commonInit{
    self.backgroundColor = [UIColor whiteColor];
    self.totalProgress = 100;
    self.lineWidth = 3;
    self.bgColor = EdlineV5_Color.layarLineColor;
    self.progressColor = EdlineV5_Color.successColor;
    self.isSetLineCapRound = NO;
}
 
- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    if (width > height) {
        radius = (height-self.lineWidth)/2;
    }else {
        radius = (width-self.lineWidth)/2;
    }
    
    CGPoint center = CGPointMake(width/2, height/2);
 
    [self.bgColor set];
    UIBezierPath *path = [UIBezierPath new];
    path.lineWidth = self.lineWidth;
    [path addArcWithCenter:center radius:radius startAngle:0  endAngle:2*M_PI clockwise:YES];
    [path stroke];
    [path closePath];
    
    UIBezierPath *path2 = [UIBezierPath new];
    CGFloat perPercent = self.progress/self.totalProgress;
    [self.progressColor set];
    path2.lineWidth = self.lineWidth;
    if (self.isSetLineCapRound) {
        path2.lineCapStyle = kCGLineCapRound;
    }
    // 从圆形正上方0刻钟点开始顺时针方向绘图的起始点 - M_PI_2 和 - M_PI_2 + (perPercent*2*M_PI)
    [path2 addArcWithCenter:center radius:radius startAngle:- M_PI_2  endAngle: - M_PI_2 + (perPercent*2*M_PI) clockwise:YES];
    [path2 stroke];
    [path2 closePath];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
