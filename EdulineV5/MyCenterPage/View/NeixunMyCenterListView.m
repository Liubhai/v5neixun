//
//  NeixunMyCenterListView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/28.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "NeixunMyCenterListView.h"
#import "V5_Constant.h"

#define NeiXunMyCenterWidth (MainScreenWidth - 30.0)

@implementation NeixunMyCenterListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:0.05].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 12;
    }
    return self;
}

- (void)setListinfo:(NSMutableArray *)info {
    [self removeAllSubviews];
    for (int i = 0; i<info.count; i++) {
        
        UIView *cellBack = [[UIView alloc] initWithFrame:CGRectMake(15, 50 * i, NeiXunMyCenterWidth - 30, 50)];
        [self addSubview:cellBack];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.centerY = cellBack.height / 2.0;
        NSString *imageName = [info[i] objectForKey:@"icon"];
        if (SWNOTEmptyStr(imageName)) {
            [img sd_setImageWithURL:EdulineUrlString(imageName) placeholderImage:DefaultImage];
        } else {
            img.image = DefaultImage;
        }
        [cellBack addSubview:img];
        
        UILabel *titlelL = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 10, 0, 150, 50)];
        titlelL.textColor = EdlineV5_Color.textFirstColor;
        titlelL.font = SYSTEMFONT(15);
        titlelL.text = [info[i] objectForKey:@"title"];
        [cellBack addSubview:titlelL];
        
        UIImageView *rightIcon  = [[UIImageView alloc] initWithFrame:CGRectMake(cellBack.width - 8, 0, 8, 14)];
        rightIcon.centerY = img.centerY;
        rightIcon.image = Image(@"list_more");
        [cellBack addSubview:rightIcon];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(img.right + 10, 49, cellBack.width - (img.right + 10), 1)];
        lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
        [cellBack addSubview:lineView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellBack.width, 50)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 66 + i;
        [btn addTarget:self action:@selector(neiXunTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellBack addSubview:btn];
//        if (i == (info.count - 1)) {
//            [self setHeight:cellBack.bottom];
//        }
    }
//    [self setHeight:_cellView.height];
}

- (void)neiXunTypeButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(neixunJumpToOtherPage:)]) {
        [_delegate neixunJumpToOtherPage:sender];
    }
}

@end
