//
//  AreaTableViewCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "AreaTableViewCell.h"
#import "V5_Constant.h"

@implementation AreaTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, 0, 200, 40)];
    _nameLabel.textColor = EdlineV5_Color.textFirstColor;
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.text = @"中国";
    [self.contentView addSubview:_nameLabel];
    
    _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 54 * WidthRatio - 200, 0, 200, 40)];
    _codeLabel.textColor = EdlineV5_Color.textFirstColor;
    _codeLabel.font = SYSTEMFONT(14);
    _codeLabel.textAlignment = NSTextAlignmentRight;
    _codeLabel.text = @"+86";
    [self.contentView addSubview:_codeLabel];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, _nameLabel.bottom, MainScreenWidth - 15 * WidthRatio, 0.5)];
    _line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_line];
}

- (void)setAreaInfo:(NSArray *)info {
    if (SWNOTEmptyArr(info)) {
        _nameLabel.text = info[0];
        _codeLabel.text = info[1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
