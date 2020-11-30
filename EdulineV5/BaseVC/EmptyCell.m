//
//  EmptyCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/9/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "EmptyCell.h"
#import "V5_Constant.h"

@implementation EmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _emptyIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, 142, 106)];
    _emptyIconImage.image = Image(@"empty_img");
    _emptyIconImage.clipsToBounds = YES;
    _emptyIconImage.contentMode = UIViewContentModeScaleAspectFill;
    _emptyIconImage.centerX = MainScreenWidth / 2.0;
    [self.contentView addSubview:_emptyIconImage];
    
    _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _emptyIconImage.bottom, MainScreenWidth, 150 - 106 - 14)];
    _emptyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.text = @"暂无内容～";
    _emptyLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_emptyLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
