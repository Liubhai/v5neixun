//
//  CourseStudentsCollectionCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseStudentsCollectionCell.h"
#import "V5_Constant.h"

@implementation CourseStudentsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 20, 50, 50)];
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = _faceImageView.height / 2.0;
    [self addSubview:_faceImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _faceImageView.bottom + 12, 75, 15)];
    _nameLabel.textColor = EdlineV5_Color.textSecendColor;
    _nameLabel.font = SYSTEMFONT(12);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_nameLabel];
}

- (void)setStudentInfo:(NSDictionary *)info {
    [_faceImageView sd_setImageWithURL:EdulineUrlString(info[@"avatar_url"]) placeholderImage:DefaultUserImage];
    _nameLabel.text = SWNOTEmptyStr(info[@"nick_name"]) ? info[@"nick_name"] : @"";
}

@end
