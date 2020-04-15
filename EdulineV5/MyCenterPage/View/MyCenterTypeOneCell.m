//
//  MyCenterTypeOneCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterTypeOneCell.h"
#import "V5_Constant.h"

@implementation MyCenterTypeOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
    _cellView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cellView];
}

- (void)setMyCenterClassifyInfo:(NSMutableArray *)info {
    [_cellView removeAllSubviews];
    int m = 0;
    for (int i = 0; i<info.count; i++) {
        m = i/4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%4)*(MainScreenWidth/4.0), m * (28 + 8 + 20 + 33 / 2.0) + 33 / 2.0, MainScreenWidth/4.0, 28 + 8 + 20 + 33 / 2.0);
        btn.titleLabel.font = SYSTEMFONT(14);
        NSString *imageName = [info[i] objectForKey:@"image"];
        [btn setImage:Image(imageName) forState:0];
        [btn setTitle:[info[i] objectForKey:@"title"] forState:0];
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
        btn.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-8/2.0, 0, 0, -labelWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-8/2.0, 0);
        [_cellView addSubview:btn];
        if (i == (info.count - 1)) {
            [_cellView setHeight:btn.bottom];
        }
    }
    [self setHeight:_cellView.height];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
