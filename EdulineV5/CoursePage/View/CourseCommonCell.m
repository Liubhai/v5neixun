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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showOneLine:(BOOL)oneLine {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _showOneLine = oneLine;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _showOneLine ? (MainScreenWidth - 30) : (MainScreenWidth / 4.0 - 30), 59.5)];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.textColor = EdlineV5_Color.textSecendColor;
    _themeLabel.numberOfLines = 0;
    [self addSubview:_themeLabel];
    
    _LeftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 59.5)];
    _LeftLineView.backgroundColor = EdlineV5_Color.themeColor;
    [self addSubview:_LeftLineView];
    _LeftLineView.hidden = YES;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, _themeLabel.width, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
    _lineView.hidden = !_showOneLine;
}

- (void)setCourseCommonCellInfo:(NSDictionary *)info searchKeyWord:(NSString *)searchKeyWord {
    _themeLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
    if (!_showOneLine) {
        [_themeLabel setWidth:MainScreenWidth / 4.0 - 30];
        [_themeLabel sizeToFit];
        if (_themeLabel.height > 60) {
            [_themeLabel setHeight:_themeLabel.height];
        } else {
            [_themeLabel setHeight:60];
        }
        [_LeftLineView setHeight:_themeLabel.height];
        [self setHeight:_themeLabel.height];
    } else {
        if ([[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] isEqualToString:searchKeyWord]) {
            _themeLabel.textColor = EdlineV5_Color.themeColor;
        } else {
            _themeLabel.textColor = EdlineV5_Color.textFirstColor;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
