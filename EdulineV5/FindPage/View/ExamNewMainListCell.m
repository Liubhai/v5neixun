//
//  ExamNewMainListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ExamNewMainListCell.h"
#import "V5_Constant.h"

@implementation ExamNewMainListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth, 22 + 8 * 2)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    _titleLabel.text = @"公开考试";
    [self.contentView addSubview:_titleLabel];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _titleLabel.bottom + 4, MainScreenWidth - 30, 90 * (MainScreenWidth - 30) / 345)];
    
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 10;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.image = Image(@"newpublic");
    [self.contentView addSubview:_faceImageView];
}

- (void)setExamNewMainCellInfo:(NSDictionary *)dict {
    _titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    [_faceImageView sd_setImageWithURL:EdulineUrlString(dict[@"cover_url"]) placeholderImage:DefaultImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
