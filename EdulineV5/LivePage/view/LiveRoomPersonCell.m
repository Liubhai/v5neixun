//
//  LiveRoomPersonCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveRoomPersonCell.h"
#import "V5_Constant.h"

@implementation LiveRoomPersonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 113, 64)];
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.image = DefaultImage;
    [self addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 16, 113, 16)];
    _nameLabel.layer.masksToBounds = YES;
    _nameLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    _nameLabel.font = SYSTEMFONT(11);
    _nameLabel.text = @" 傻子一号";
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];
}

@end
