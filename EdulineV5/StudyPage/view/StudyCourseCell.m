//
//  StudyCourseCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyCourseCell.h"
#import "V5_Constant.h"

@implementation StudyCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 153, 86)];
    
    _courseFace.image = DefaultImage;
    _courseFace.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_courseFace];
    
    _courseTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 32, _courseFace.top + 8, 32, 18)];
    _courseTypeImage.image = Image(@"album_icon");
    [self addSubview:_courseTypeImage];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.right + 12, _courseFace.top, MainScreenWidth - (_courseFace.right + 12) - 15, 50)];
    _titleL.text = @"你是个傻屌";
    _titleL.textColor = EdlineV5_Color.textFirstColor;
    _titleL.font = SYSTEMFONT(15);
    [self addSubview:_titleL];
    
    _learnProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_titleL.left, _courseFace.bottom - 8, MainScreenWidth - _titleL.left - 15, 4)];
    _learnProgress.layer.masksToBounds = YES;
    _learnProgress.layer.cornerRadius = 2;
    _learnProgress.progress = 0.5;
    //设置它的风格，为默认的
    _learnProgress.trackTintColor= HEXCOLOR(0xF1F1F1);
    //设置轨道的颜色
    _learnProgress.progressTintColor= EdlineV5_Color.themeColor;
    [self addSubview:_learnProgress];
    
    _learnCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, _learnProgress.top - 3 - 16, 100, 16)];
    _learnCountLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnCountLabel.text = @"50%";
    _learnCountLabel.font = SYSTEMFONT(12);
    _learnCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_learnCountLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
