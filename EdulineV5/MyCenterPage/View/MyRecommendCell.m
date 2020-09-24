//
//  MyRecommendCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyRecommendCell.h"
#import "V5_Constant.h"

@implementation MyRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _typeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
    _typeTitle.textColor = EdlineV5_Color.textFirstColor;
    _typeTitle.font = SYSTEMFONT(15);
    [self.contentView addSubview:_typeTitle];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, MainScreenWidth - 15, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_lineView];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 18, 8, 14)];
    _rightIcon.image = Image(@"list_more");
    [self.contentView addSubview:_rightIcon];
}

- (void)setInfo:(NSString *)title {
    _typeTitle.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
