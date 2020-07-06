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
    int count = [PROFILELAYOUT intValue];
    for (int i = 0; i<info.count; i++) {
        m = i/count;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%count)*(MainScreenWidth/count), m * MainScreenWidth/count, MainScreenWidth/count, MainScreenWidth/count);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, (MainScreenWidth/count - 56) / 2.0, 28, 28)];
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
        UILabel *titlelL = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom + 8, MainScreenWidth/count, 20)];
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

- (void)typeButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToOtherPage:)]) {
        [_delegate jumpToOtherPage:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
