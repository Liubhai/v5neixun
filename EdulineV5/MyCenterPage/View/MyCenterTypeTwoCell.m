//
//  MyCenterTypeTwoCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCenterTypeTwoCell.h"
#import "V5_Constant.h"

@implementation MyCenterTypeTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (50 - 22)/2.0, 22, 22)];
    _iconImage.clipsToBounds = YES;
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconImage];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.right + 10, 0, 150, 50)];
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    _themeLabel.font = SYSTEMFONT(15);
    [self addSubview:_themeLabel];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 0, 8, 14)];
    _rightIcon.centerY = _iconImage.centerY;
    _rightIcon.image = Image(@"list_more");
    [self addSubview:_rightIcon];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, MainScreenWidth, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setMyCenterTypeTwoCellInfo:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        [_iconImage sd_setImageWithURL:EdulineUrlString([info objectForKey:@"icon"]) placeholderImage:DefaultImage];
        _themeLabel.text = [info objectForKey:@"title"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
