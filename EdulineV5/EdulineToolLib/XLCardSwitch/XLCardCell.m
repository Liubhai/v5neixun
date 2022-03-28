//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCardCell.h"
#import "XLCardModel.h"
#import "V5_Constant.h"

@interface XLCardCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (strong, nonatomic) UIImageView *courseTypeImage;

@end

@implementation XLCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelHeight = self.bounds.size.height * 0.20f;
    CGFloat imageViewHeight = self.bounds.size.height - labelHeight;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageViewHeight)];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = true;
    self.imageView.layer.cornerRadius = 2;
    [self.contentView addSubview:self.imageView];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView.left, _imageView.top, 33, 20)];
    _courseTypeImage.layer.masksToBounds = YES;
    _courseTypeImage.layer.cornerRadius = 2;
    [self.contentView addSubview:_courseTypeImage];
    _courseTypeImage.hidden = YES;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewHeight, self.bounds.size.width, labelHeight)];
    self.textLabel.font = SYSTEMFONT(15);
    self.textLabel.textColor = EdlineV5_Color.textFirstColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
//    self.textLabel.adjustsFontSizeToFitWidth = true;
    [self.contentView addSubview:self.textLabel];
}

- (void)setModel:(XLCardModel *)model {
    [self.imageView sd_setImageWithURL:EdulineUrlString(model.imageName) placeholderImage:DefaultImage];
    if ([model.course_type isEqualToString:@"1"]) {
        _courseTypeImage.image = Image(@"dianbo");
    } else if ([model.course_type isEqualToString:@"2"]) {
        _courseTypeImage.image = Image(@"live");
    } else if ([model.course_type isEqualToString:@"3"]) {
        _courseTypeImage.image = Image(@"mianshou");
    } else if ([model.course_type isEqualToString:@"4"]) {
        _courseTypeImage.image = Image(@"class_icon");
    }
    self.textLabel.text = model.title;
}

@end
