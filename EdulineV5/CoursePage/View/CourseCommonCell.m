//
//  CourseCommonCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommonCell.h"
#import "V5_Constant.h"

@implementation CourseCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 43)];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.textColor = EdlineV5_Color.textSecendColor;
    [self addSubview:_themeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, MainScreenWidth - 30, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setCourseCommonCellInfo:(NSDictionary *)info searchKeyWord:(NSString *)searchKeyWord {
    _themeLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    if ([[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] isEqualToString:searchKeyWord]) {
        _themeLabel.textColor = EdlineV5_Color.themeColor;
    } else {
        _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
