//
//  MyCenterOrderView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterOrderView.h"
#import "V5_Constant.h"

@implementation MyCenterOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    self.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.layer.cornerRadius = 7;
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    self.layer.shadowOpacity = 1;// 阴影透明度，默认0
    self.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius = 12;
    
    NSArray *orderSortArray = @[@{@"image":@"pre_order_daizhifu",@"title":@"待支付"},@{@"image":@"pre_order_quxiao",@"title":@"已取消"},@{@"image":@"pre_order_fin",@"title":@"已完成"},@{@"image":@"pre_order_tuikuan",@"title":@"课程售后"}];
    
    UILabel *themelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width, 48)];
    themelabel.textColor = EdlineV5_Color.textFirstColor;
    themelabel.font = SYSTEMFONT(15);
    themelabel.text = @"我的订单";
    [self addSubview:themelabel];
    
    UIImageView *moreIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 10 - 8, 0, 8, 14)];
    moreIcon.image = Image(@"list_more");
    moreIcon.centerY = themelabel.centerY;
    [self addSubview:moreIcon];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(moreIcon.left - 8 - 150, 0, 150, 48)];
    moreLabel.text = @"查看全部订单";
    moreLabel.font = SYSTEMFONT(14);
    moreLabel.textColor = EdlineV5_Color.textThirdColor;
    moreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moreLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 48, self.bounds.size.width, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:line];
    
    CGFloat BtnWidth = self.bounds.size.width / (orderSortArray.count * 1.0);
    
    for (int i = 0; i< orderSortArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(BtnWidth * i, line.bottom, BtnWidth, 90)];
        NSString *imageName = [orderSortArray[i] objectForKey:@"image"];
        [btn setImage:Image(imageName) forState:0];
        [btn setTitle:[orderSortArray[i] objectForKey:@"title"] forState:0];
        btn.titleLabel.font = SYSTEMFONT(14);
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = btn.titleLabel.frame.size.width;
            labelHeight = btn.titleLabel.frame.size.height;
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-10/2.0, 0, 0, -labelWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-10/2.0, 0);
        [btn addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)orderButtonClick:(UIButton *)sender {
    
}

@end
