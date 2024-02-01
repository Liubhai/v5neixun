//
//  HRewardView.m
//  CCClassRoom
//
//  Created by Chenfy on 2020/7/14.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HRewardView.h"
#import <Masonry.h>


#pragma mark -- 锤子标示
#define KKMark_HAMMER   @"X "


@interface HRewardView ()
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *label;

@end

@implementation HRewardView

- (instancetype)initWithImage:(UIImage *)image count:(NSInteger)count {
    if (self = [super init]) {
        _image = image;
        _count = count;
        _imageV.image = image;
        [self envInitUI];
    }
    return self;
}

- (NSString *)countString:(NSInteger)count {
    NSString *res = [NSString stringWithFormat:@"%@%ld",KKMark_HAMMER,(long)count];
    return res;
}

- (NSInteger)countFromLabel {
    NSString *text = self.label.text;
    text = [text stringByReplacingOccurrencesOfString:KKMark_HAMMER withString:@""];
    return [text integerValue];
}

- (void)envInitUI {
    [self addSubview:self.imageV];
    [self addSubview:self.label];
    self.imageV.image = _image;
    int offset = 3;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(offset);
        make.bottom.mas_equalTo(self).offset(-offset);
        make.right.mas_equalTo(self.mas_right).multipliedBy(0.5);
        
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.imageV.mas_right).offset(0);
    }];
}

- (void)updateCount:(NSInteger)count {
    if (count == 0) {
        self.label.text = @"";
        self.imageV.hidden = YES;
        return;
    }
    NSString *text = [self countString:count];
    self.label.text = text;
    self.imageV.hidden = NO;
}

- (void)addCount:(NSInteger)count {
    if (count == 0) {
        return;
    }
    NSInteger countLocal = [self countFromLabel];
    countLocal += count;
    
    [self updateCount:countLocal];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:13];
    }
    return _label;
}

@end
