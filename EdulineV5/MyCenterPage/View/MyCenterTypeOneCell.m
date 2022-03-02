//
//  MyCenterTypeOneCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterTypeOneCell.h"
#import "V5_Constant.h"
#define MYCENTERONECELLWIDTH (MainScreenWidth - 30.0)

@implementation MyCenterTypeOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _cellView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 0)];
    _cellView.backgroundColor = [UIColor whiteColor];
    _cellView.layer.cornerRadius = 10;
    _cellView.layer.shadowColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:0.05].CGColor;
    _cellView.layer.shadowOffset = CGSizeMake(0,1);
    _cellView.layer.shadowOpacity = 1;
    _cellView.layer.shadowRadius = 12;
    [self.contentView addSubview:_cellView];
}

- (void)setMyCenterClassifyInfo:(NSMutableArray *)info {
    [_cellView removeAllSubviews];
    int m = 0;
    int count = [PROFILELAYOUT intValue];
    for (int i = 0; i<info.count; i++) {
        m = i/count;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%count)*(MYCENTERONECELLWIDTH/count), m * MYCENTERONECELLWIDTH/count, MYCENTERONECELLWIDTH/count, MYCENTERONECELLWIDTH/count);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, (MYCENTERONECELLWIDTH/count - 56) / 2.0, 28, 28)];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.centerX = btn.width / 2.0;
        NSString *imageName = [info[i] objectForKey:@"icon"];
        if (SWNOTEmptyStr(imageName)) {
            [img sd_setImageWithURL:EdulineUrlString(imageName) placeholderImage:DefaultImage];
        } else {
            img.image = DefaultImage;
        }
        [btn addSubview:img];
        UILabel *titlelL = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom + 8, MYCENTERONECELLWIDTH/count, 20)];
        titlelL.font = SYSTEMFONT(14);
        titlelL.textColor = EdlineV5_Color.textSecendColor;
        titlelL.textAlignment = NSTextAlignmentCenter;
        titlelL.text = [info[i] objectForKey:@"title"];
        [btn addSubview:titlelL];
        btn.tag = 66 + i;
        [btn addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cellView addSubview:btn];
        if (i == (info.count - 1)) {
            [_cellView setHeight:btn.bottom];
        }
    }
    [self setHeight:_cellView.height];
}

// 每行一个 模拟cell
- (void)setMyCenterClassifyInfoOnlyOne:(NSMutableArray *)info {
    [_cellView removeAllSubviews];
    for (int i = 0; i<info.count; i++) {
        
        UIView *cellBack = [[UIView alloc] initWithFrame:CGRectMake(15, 50 * i, MYCENTERONECELLWIDTH - 30, 50)];
        [_cellView addSubview:cellBack];
        
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
        [btn addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellBack addSubview:btn];
        if (i == (info.count - 1)) {
            [_cellView setHeight:cellBack.bottom];
        }
    }
    [self setHeight:_cellView.height];
}

- (void)typeButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToOtherPage:)]) {
        [_delegate jumpToOtherPage:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
