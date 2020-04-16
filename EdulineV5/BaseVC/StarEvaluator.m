//
//  StarEvaluator.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StarEvaluator.h"
#import "EdlineV5_Color.h"

#define Space  4

@interface StarEvaluator ()
{
    float   aWidth; //一个星星+间隙的宽度
    float   aStarWidth; //一个星星的宽度
    float   touchX;
    NSMutableArray  *fullStarArray;
}

@end

@implementation StarEvaluator

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentValue = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setCurrentValue:(float)currentValue
{
    _currentValue = currentValue;
    [self setNeedsDisplay];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    int t = (int)(touchPoint.x/aWidth);
    float f = (touchPoint.x - t*Space - t*aStarWidth)/aStarWidth;
    f = f>1.0?1.0:(f>0.5?1.0:0.5);
    self.currentValue = t + f;
    
    touchX = f * aStarWidth + t * Space + t * aStarWidth;//touchPoint.x;
    [self setNeedsDisplay];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    int t = (int)(touchPoint.x/aWidth);
    float f = (touchPoint.x - t*Space - t*aStarWidth)/aStarWidth;
    f = f>1.0?1.0:(f>0.5?1.0:0.5);
    self.currentValue = t + f;
    
    touchX = f * aStarWidth + t * Space + t * aStarWidth;//touchPoint.x;
    [self setNeedsDisplay];
    
    return YES;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = (self.bounds.size.width - Space*4) / 5;
    
    aStarWidth = width;
    aWidth = width + Space;
    
    
    UIImage *image = [UIImage imageNamed:@"icon_star_pre.png"];
    for (int i = 0; i < 5; i ++) {
        CGRect rect = CGRectMake(i*(width+Space), 0, width, width);
        [image drawInRect:rect];
    }
    
    [EdlineV5_Color.starNoColor set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    
    CGRect newRect = CGRectMake(0, 0, touchX, rect.size.height);
    [EdlineV5_Color.starPreColor set];
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
    
    if ([_delegate respondsToSelector:@selector(anotherStarEvaluator:currentValue:)]) {
        [_delegate anotherStarEvaluator:self currentValue:_currentValue];
    }
}

- (void)setStarValue:(float)starvalue {
    
    CGFloat width = (self.bounds.size.width - Space*4) / 5;
    
    aStarWidth = width;
    aWidth = width + Space;
    
    float yushu = fmodf(starvalue, 1.0);
    NSInteger starCount = floor(starvalue);
    touchX = starCount * aWidth + yushu * aStarWidth;
    [self setNeedsDisplay];
}


@end
