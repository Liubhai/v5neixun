//
//  HDHammerView.m
//  CCClassRoom
//
//  Created by Chenfy on 2020/6/17.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HDHammerView.h"
#import <Masonry.h>
#import "HDSTool.h"

@interface HDHammerView ()
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UILabel *label;

@end

@implementation HDHammerView

+ (void)hammerShowText:(NSString *)name {
    HDHammerView *hv = [[HDHammerView alloc]init];
    hv.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.8];
    NSString *text = [NSString stringWithFormat:HDClassLocalizeString(@"%@要加油哦～") ,name];
    hv.label.text = text;
    
    UIWindow *kw = [[UIApplication sharedApplication]keyWindow];
    [kw addSubview:hv];
    [hv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(kw);
    }];
    [[HDSTool sharedTool]playerPlayMedia:@"hammer.mp3"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            hv.alpha = 0;
        } completion:^(BOOL finished) {
            [hv removeFromSuperview];
        }];
    });
}

- (instancetype)init {
    if (self = [super init]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.imgV];
    [self addSubview:self.label];
    
    UIWindow *kw = [[UIApplication sharedApplication]keyWindow];
    float height = kw.frame.size.height * 0.1;
    int w = 280;
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(height);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(w);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(self);
        make.top.mas_equalTo(self.imgV.mas_bottom).offset(-15);
        make.height.mas_equalTo(35);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *img = [UIImage imageNamed:@"hammer"];
        _imgV.image = img;
    }
    return _imgV;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:0 alpha:1];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
