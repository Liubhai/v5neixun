//
//  OtherTypeBindCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/9/4.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OtherTypeBindCell.h"
#import "V5_Constant.h"

@implementation OtherTypeBindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _typeLog = [[UIImageView alloc] initWithFrame:CGRectMake(15, (50-22)/2.0, 22, 22)];
    _typeLog.layer.masksToBounds = YES;
    _typeLog.layer.cornerRadius = _typeLog.height/2.0;
    [self addSubview:_typeLog];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeLog.right + 8, 0, 200, 50)];
    _themeLabel.font = SYSTEMFONT(15);
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [self addSubview:_themeLabel];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 0, 8, 14)];
    _rightIcon.image = Image(@"list_more");
    _rightIcon.centerY = _themeLabel.centerY;
    [self addSubview:_rightIcon];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightIcon.right - 15 - 100, 0, 100, 50)];
    _rightLabel.textColor = EdlineV5_Color.textThirdColor;
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = SYSTEMFONT(15);
    [self addSubview:_rightLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, MainScreenWidth - 15, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
}

- (void)setSetingCellInfo:(NSDictionary *)info {
    _setInfo = info;
    if (SWNOTEmptyDictionary(info)) {
        _typeLog.image = Image(info[@"image"]);
        _themeLabel.text = [info objectForKey:@"title"];
        if ([info[@"status"] isEqualToString:@"bind"]) {
            _rightLabel.text = @"取消绑定";
            _rightLabel.textColor = EdlineV5_Color.faildColor;
        } else {
            _rightLabel.text = @"未绑定";
            _rightLabel.textColor = HEXCOLOR(0xB7BAC1);
        }
        
    }
}

@end
